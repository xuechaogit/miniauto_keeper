import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:miniauto_keeper/core/network/api/garage_api.dart';
import 'package:miniauto_keeper/core/network/http_service.dart';
import 'package:miniauto_keeper/core/utils/snackbar_util.dart';
import 'package:miniauto_keeper/models/garage_item.dart';

/// 车库全局仓库：所有页面共享的唯一数据源与写操作入口。
///
/// - 在 MainBinding 里 `Get.put(GarageRepository(), permanent: true)` 常驻，
///   不随页面销毁，也不依赖任何页面 onInit（避免首屏全拉回归）；
/// - 页面 controller 只持有搜索/排序/筛选等 UI 状态，数据一律读本仓库内存；
/// - 写操作（add）仅请求后端 + 置 dirty 标记，**不重拉列表、不插本地**；
///   dirty 由下次进入车库 tab 时 `ensureLoaded()` 兑现（见 MainController.changePage）；
/// - remove 当前无 UI 入口，首批不封装，需要时再加。
class GarageRepository extends GetxService {
  // retrofit 接口实例：复用 HttpService 的 dio（baseUrl 与响应剥壳已收敛于 HttpService）
  final GarageApi _api = GarageApi(HttpService.to.dio);

  // --- 数据 ---
  /// 已加载的车库条目（第一页 + 后续 loadMore 分页数据）
  final RxList<GarageItem> models = <GarageItem>[].obs;

  /// 服务端总条数（meta.total）
  final RxInt total = 0.obs;

  /// 是否已成功加载过首屏（幂等标记，避免重复自动拉取）
  final RxBool loadedOnce = false.obs;

  /// 本地写操作是否引入脏数据（true 表示再次进入车库 tab 需重拉第一页）
  final RxBool dirty = false.obs;

  // --- 请求状态 ---
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool hasMore = true.obs;

  int _page = 1;
  static const _pageSize = 10;

  /// 进入车库 tab 时调用（MainController.changePage）。
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
      final envelope = await _api.getMyGarage(
        _page,
        _pageSize,
        null, // brandId：暂不接接口筛选，本地按名字过滤
        null, // condition：暂不接接口筛选
      );
      final items = envelope.data ?? [];
      models.assignAll(items);
      total.value = envelope.meta?.total ?? items.length;
      hasMore.value =
          (envelope.meta?.lastPage ?? (_page + 1)) > _page && items.isNotEmpty;
      loadedOnce.value = true;
    } on DioException catch (e) {
      models.clear();
      total.value = 0;
      SnackBarUtil.error(_extractApiMessage(e));
    } catch (e) {
      models.clear();
      total.value = 0;
      SnackBarUtil.error(_extractApiMessage(e));
    } finally {
      isLoading.value = false;
    }
  }

  /// 触底加载更多：追加下一页，不做去重（新增已由 dirty 重拉覆盖）。
  Future<void> loadMore() async {
    if (isLoadingMore.value || !hasMore.value || isLoading.value) return;
    isLoadingMore.value = true;
    try {
      final nextPage = _page + 1;
      final envelope = await _api.getMyGarage(
        nextPage,
        _pageSize,
        null,
        null,
      );
      final items = envelope.data ?? [];
      if (items.isEmpty) {
        hasMore.value = false;
      } else {
        _page = envelope.meta?.currentPage ?? nextPage;
        models.addAll(items);
        total.value = envelope.meta?.total ?? total.value;
        hasMore.value = (envelope.meta?.lastPage ?? _page) > _page;
      }
    } catch (e) {
      // 保持现有数据不变
    } finally {
      isLoadingMore.value = false;
    }
  }

  /// 加入车库（方案 B）：仅 POST + 置脏标记，不拉列表、不插本地。
  /// 成功与否由调用方提示；此处不吞错误，rethrow 交由调用方处理。
  Future<void> addToGarage(GarageAddRequest req) async {
    await _api.addToGarage(req);
    dirty.value = true;
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
