import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:miniauto_keeper/core/network/api/wishlist_api.dart';
import 'package:miniauto_keeper/core/network/http_service.dart';
import 'package:miniauto_keeper/core/utils/snackbar_util.dart';
import 'package:miniauto_keeper/models/wishlist_entry.dart';

/// 心愿单全局仓库：心愿单路由页的唯一数据源与写操作入口。
///
/// - MainBinding 常驻（permanent: true），不随路由页销毁；
/// - Controller 只保留搜索/品牌等 UI 状态，数据与分页全部收敛在本仓库；
/// - 写操作策略（与 GarageRepository 一致，避免非目标页全量刷新）：
///   - remove 发生在心愿单页内，成功即更新本地 Rx，所见即所得；
///   - add 通常发生在品牌/详情页（用户当时不看心愿单），只置 dirty 标记，
///     由下次进入心愿单页 ensureLoaded() 兑现重拉。
class WishlistRepository extends GetxService {
  // retrofit 接口实例：复用 HttpService 的 dio（baseUrl 与响应剥壳已收敛于 HttpService）
  final WishlistApi _api = WishlistApi(HttpService.to.dio);

  // --- 数据 ---
  /// 已加载的心愿单条目（第一页 + 后续 loadMore 分页数据）
  final RxList<WishlistEntry> items = <WishlistEntry>[].obs;

  /// 服务端总条数（meta.total）
  final RxInt total = 0.obs;

  /// 是否已成功加载过首屏（幂等标记，避免重复自动拉取）
  final RxBool loadedOnce = false.obs;

  /// 本地写操作是否引入脏数据（true 表示再次进入心愿单页需重拉第一页）
  final RxBool dirty = false.obs;

  /// 已收藏的 model_id 集合（品牌详情页 ❤️ 按钮状态，Rx 驱动 UI 刷新）。
  /// 与 items 不同：这是独立的收藏态缓存，可被 syncFavSet 全量重建，
  /// 不干扰心愿单页的分页数据。
  final RxSet<int> favModelIds = <int>{}.obs;

  /// model_id → wishlist 条目 id 映射（remove 接口按条目 id 删，故需此映射）
  final Map<int, int> _wishlistIdByModel = {};

  // --- 请求状态 ---
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool hasMore = true.obs;

  int _page = 1;
  static const _pageSize = 20;

  /// 进入心愿单页时调用（WishlistController.onInit）。
  /// 仅当「未加载过」或「有脏标记」时重拉第一页并清脏；否则直接跳过。
  Future<void> ensureLoaded() async {
    if (!loadedOnce.value || dirty.value) {
      await _loadFirstPage();
      dirty.value = false;
    }
  }

  /// 下拉刷新：强制回到第一页并清脏。
  Future<void> refresh() async {
    dirty.value = false;
    await _loadFirstPage();
  }

  Future<void> _loadFirstPage() async {
    isLoading.value = true;
    _page = 1;
    hasMore.value = true;
    try {
      final envelope = await _api.getMyWishlist(_page, _pageSize);
      final list = envelope.data ?? [];
      items.assignAll(list);
      _rebuildFavSet();
      total.value = envelope.meta?.total ?? list.length;
      hasMore.value =
          (envelope.meta?.lastPage ?? (_page + 1)) > _page && list.isNotEmpty;
      loadedOnce.value = true;
    } catch (e) {
      items.clear();
      total.value = 0;
      SnackBarUtil.error(_extractApiMessage(e));
    } finally {
      isLoading.value = false;
    }
  }

  /// 触底加载更多：追加下一页。
  Future<void> loadMore() async {
    if (isLoadingMore.value || !hasMore.value || isLoading.value) return;
    isLoadingMore.value = true;
    try {
      final nextPage = _page + 1;
      final envelope = await _api.getMyWishlist(nextPage, _pageSize);
      final list = envelope.data ?? [];
      if (list.isEmpty) {
        hasMore.value = false;
      } else {
        _page = envelope.meta?.currentPage ?? nextPage;
        items.addAll(list);
        total.value = envelope.meta?.total ?? total.value;
        hasMore.value = (envelope.meta?.lastPage ?? _page) > _page;
      }
    } catch (e) {
      // 保持现有数据不变
    } finally {
      isLoadingMore.value = false;
    }
  }

  /// 加入心愿单：仅 POST + 置脏标记，不重拉列表、不插本地。
  /// 成功与否由调用方提示；此处不吞错误，rethrow 交由调用方处理。
  Future<void> addToWishlist(WishlistAddRequest req) async {
    await _api.addToWishlist(req);
    dirty.value = true;
    // 收藏态即时 +1（无需知道新条目 id，remove 兜底走 syncFavSet 或 mapping 不存在时刷新）
    favModelIds.add(req.modelId);
  }

  /// 移出心愿单：DELETE 成功后即时从本地 Rx 移除（用户在心愿单页内操作）。
  /// 失败 rethrow，由调用方提示。
  Future<void> removeFromWishlist(int id) async {
    await _api.removeFromWishlist(id);
    int? removedModelId;
    for (final e in items) {
      if (e.id == id) {
        removedModelId = e.modelId;
        break;
      }
    }
    items.removeWhere((e) => e.id == id);
    if (removedModelId != null) {
      favModelIds.remove(removedModelId);
      _wishlistIdByModel.remove(removedModelId);
    }
    if (total.value > 0) total.value -= 1;
    dirty.value = true;
  }

  /// 判断某车模是否已收藏（品牌详情页 ❤️ 按钮状态）。
  /// 依赖 favModelIds（RxSet），Obx 中读取即可响应式刷新。
  bool containsModel(int modelId) => favModelIds.contains(modelId);

  /// 查询 model_id 对应的 wishlist 条目 id（remove 需要条目 id）。
  /// 返回 null 表示本地尚未缓存该映射（需 syncFavSet 或 ensureLoaded 刷新）。
  int? wishlistIdOf(int modelId) => _wishlistIdByModel[modelId];

  /// 全量同步收藏态：静默拉取所有分页，仅重建 favModelIds 与
  /// modelId→wishlistId 映射，不动 items（不干扰心愿单页分页数据）。
  /// 供品牌/详情页进入时以整批数据确认收藏状态；失败静默保持上次结果。
  Future<void> syncFavSet() async {
    try {
      var page = 1;
      var lastPage = 1;
      _wishlistIdByModel.clear();
      favModelIds.assignAll(<int>{});
      while (true) {
        final envelope = await _api.getMyWishlist(page, 100);
        final list = envelope.data ?? const <WishlistEntry>[];
        for (final e in list) {
          _wishlistIdByModel[e.modelId] = e.id;
          favModelIds.add(e.modelId);
        }
        final meta = envelope.meta;
        lastPage = meta?.lastPage ?? (list.isNotEmpty ? page : page - 1);
        if (page >= lastPage) break;
        page += 1;
      }
    } catch (_) {
      // 静默失败：保留上次收藏态
    }
  }

  /// 由 items 重建收藏态缓存（首屏/下拉刷新后调用，与分页数据同源）。
  void _rebuildFavSet() {
    _wishlistIdByModel.clear();
    favModelIds.assignAll(<int>{});
    for (final e in items) {
      _wishlistIdByModel[e.modelId] = e.id;
      favModelIds.add(e.modelId);
    }
  }

  /// 提取接口错误信息：优先响应体 message，兜底 e.error。
  String _extractApiMessage(Object e) {
    if (e is DioException) {
      final body = e.response?.data;
      if (body is Map && body['message'] != null) {
        return '${body['message']}';
      }
      return '${e.error ?? '请求失败，请稍后重试'}';
    }
    return '$e';
  }
}
