import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:miniauto_keeper/core/network/api/catalog_api.dart';
import 'package:miniauto_keeper/core/network/http_service.dart';
import 'package:miniauto_keeper/core/router/app_routes.dart';
import 'package:miniauto_keeper/core/services/wishlist_service.dart';
import 'package:miniauto_keeper/core/services/garage_repository.dart';
import 'package:miniauto_keeper/core/utils/snackbar_util.dart';
import 'package:miniauto_keeper/core/widgets/form/form_builder/form_builder.dart';
import 'package:miniauto_keeper/models/brand_model.dart';
import 'package:miniauto_keeper/models/car_model.dart';
import 'package:miniauto_keeper/models/catalog_brand.dart';
import 'package:miniauto_keeper/models/garage_item.dart';
import 'package:miniauto_keeper/models/series.dart';

import 'package:miniauto_keeper/models/wishlist_item.dart';

import 'package:miniauto_keeper/core/widgets/brand_selector/brand_selector.dart';
import 'package:miniauto_keeper/modules/brand/brand_list/widgets/add_garage_sheet/add_garage_sheet.dart';

class BrandDetailController extends GetxController {
  //品牌详情信息
  CatalogBrand get brand => Get.arguments ?? CatalogBrand();

  final products = <CarModel>[].obs;
  final isLoading = false.obs;
  final isLoadingMore = false.obs;
  final isLoadMoreError = false.obs;
  final hasMore = true.obs;
  final total = 0.obs;

  // 筛选状态
  final selectedYear = '全部'.obs;
  final selectedSeries = '全部'.obs;
  final selectedScale = '全部'.obs;
  final selectedSort = '默认'.obs;

  // 系列列表（本品牌下，用于系列筛选层）
  final seriesList = <Series>[].obs;
  final selectedSeriesId = Rx<int?>(null);

  /// 系列筛选项（首个为「全部」，选中它表示不按系列过滤）
  List<String> get seriesOptions => ['全部', ...seriesList.map((s) => s.name)];

  int? _seriesIdByName(String name) {
    for (final s in seriesList) {
      if (s.name == name) return s.id;
    }
    return null;
  }

  // 搜索关键词
  final keyword = ''.obs;

  // 品牌描述折叠
  final isDescriptionExpanded = false.obs;

  // 滚动状态（AppBar 透明 ↔ 实色切换）
  final isScrolled = false.obs;

  // 收藏状态
  final favIds = <String>{}.obs;
  final favService = Get.find<WishlistService>();

  bool isFav(CarModel product) => favService.exists(product.id.toString());

  void toggleFav(CarModel product) {
    if (favService.exists(product.id.toString())) {
      favService.removeItem(product.id.toString());
    } else {
      // favService.addItem(product.toWishlistItem());
    }
    favIds.refresh();
  }

  void showAddGarageSheet(CarModel product) {
    final formKey = GlobalKey<FormBuilderState>(); // ← 提到 builder 之外
    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      builder: (_) => FractionallySizedBox(
        heightFactor: 0.75,
        child: AddGarageSheet(
          formKey: formKey,
          productName: product.name,
          onSubmit: (values) => _submitGarageEntry(product, values),
        ),
      ),
    );
  }

  bool _isSubmitting = false;

  /// 车模状况(表单中文枚举) → 后端 condition 数值
  static const _conditionMap = {'全新': 1, '近新': 2, '有瑕疵': 3, '破损': 4};

  /// 提交加入车库
  Future<void> _submitGarageEntry(
    CarModel product,
    Map<String, dynamic> values,
  ) async {
    if (_isSubmitting) return;
    _isSubmitting = true;
    try {
      final req = GarageAddRequest(
        modelId: product.id,
        purchaseDate: values['purchaseDate']?.toString() ?? '',
        purchasePrice: double.tryParse('${values['purchasePrice'] ?? ''}') ?? 0,
        purchaseChannel: values['purchaseChannel']?.toString().trim() ?? '',
        condition:
            _conditionMap[values['condition']?.toString()] ?? 1, // 默认全新
        notes: _emptyToNull(values['notes']),
        isPublic: true, // 表单未录入公开状态，默认公开
      );
      await Get.find<GarageRepository>().addToGarage(req);
      SnackBarUtil.success('已加入车库');
      if (Get.isBottomSheetOpen ?? false) Get.back();
    } catch (e) {
      SnackBarUtil.error(_extractApiMessage(e));
    } finally {
      _isSubmitting = false;
    }
  }

  /// 提取接口错误信息：优先响应体 message（覆盖 HTTP 200 剥壳 reject 与
  /// HTTP 422 两种情形），兜底拦截器 reject 场景塞入的 e.error。
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

  static String? _emptyToNull(dynamic v) {
    final s = v?.toString().trim() ?? '';
    return s.isEmpty ? null : s;
  }

  static const _pageSize = 10;

  int _page = 1;

  @override
  void onInit() {
    super.onInit();
    _loadSeries();
    _loadFirstPage();
  }

  /// 加载本品牌下的系列列表（失败时降级为仅有「全部」）
  Future<void> _loadSeries() async {
    try {
      final envelope = await _api.getSeries(brand.id, 1, 100, '', '');
      seriesList.assignAll(envelope.data!);
    } catch (_) {
      seriesList.clear();
    }
  }

  void toggleDescription() => isDescriptionExpanded.toggle();

  // retrofit 接口实例：复用 HttpService 的 dio（baseUrl 与剥壳拦截器已收敛于 HttpService）
  final CatalogApi _api = CatalogApi(HttpService.to.dio);

  Future<void> _loadFirstPage() async {
    isLoading.value = true;
    _page = 1;
    hasMore.value = true;

    try {
      final envelope = await _api.getModels(
        _page,
        _pageSize,
        brand.id, // brandId
        selectedSeriesId.value, // seriesId：系列筛选
        null, // tagId：暂无标签筛选映射
        keyword.value.isEmpty ? null : keyword.value, // search
      );
      final items = envelope.data;
      products.assignAll(items!);
      // meta 不在时回退为「拿到非空数据即视为有下一页」
      hasMore.value =
          (envelope.meta?.lastPage ?? (_page + 1)) > _page && items.isNotEmpty;
    } catch (_) {
      products.clear();
      total.value = 0;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMore() async {
    if (isLoadingMore.value || !hasMore.value || isLoading.value) return;
    isLoadingMore.value = true;

    try {
      final nextPage = _page + 1;
      final envelope = await _api.getModels(
        nextPage,
        _pageSize,
        brand.id, // brandId
        selectedSeriesId.value, // seriesId：系列筛选
        null, // tagId：暂无标签筛选映射
        keyword.value.isEmpty ? null : keyword.value, // search
      );
      final items = envelope.data!;
      if (items.isEmpty) {
        // 返回空列表说明已到底
        hasMore.value = false;
      } else {
        _page = envelope.meta?.currentPage ?? nextPage;
        products.addAll(items);
        hasMore.value = (envelope.meta?.lastPage ?? _page) > _page;
      }
    } catch (_) {
      // 保持现有数据不变
    } finally {
      isLoadingMore.value = false;
    }
  }

  void applyFilter(String type, String value) {
    switch (type) {
      case 'year':
        selectedYear.value = value;
        break;
      case 'series':
        selectedSeries.value = value;
        // 「全部」映射为 null（不按系列过滤），否则解析为系列 id
        selectedSeriesId.value = value == '全部' ? null : _seriesIdByName(value);
        break;
      case 'scale':
        selectedScale.value = value;
        break;
      case 'sort':
        selectedSort.value = value;
        break;
    }
    _loadFirstPage();
  }

  void onSearchChanged(String value) {
    keyword.value = value;
    _loadFirstPage();
  }

  void switchBrand() async {
    final selected = await showBrandSelectorSheet();
    if (selected != null) {
      Get.offNamed('/brand-detail', arguments: selected);
    }
  }

  void reportMissing() {
    Get.toNamed(AppRoutes.reportMissing);
  }

  void toProductDetail(CarModel product) {
    Get.toNamed('${AppRoutes.productDetail}?id=${product.id}');
  }
}
