import 'package:get/get.dart';
import 'package:miniauto_keeper/core/router/app_routes.dart';
import 'package:miniauto_keeper/core/utils/snackbar_util.dart';
import 'package:miniauto_keeper/models/brand_model.dart';
import 'package:miniauto_keeper/models/product_model.dart';

import 'repository.dart';
import 'widgets/brand_selector_sheet/brand_selector_sheet.dart';

class BrandDetailController extends GetxController {
  dynamic get brand =>
      Get.arguments ?? BrandModel(id: 0, pid: 0, name: 'Unknown', thumb: '');

  final _repository = BrandListRepository();

  final products = <ProductModel>[].obs;
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

  // 搜索关键词
  final keyword = ''.obs;

  // 品牌描述折叠
  final isDescriptionExpanded = false.obs;

  // 滚动状态（AppBar 透明 ↔ 实色切换）
  final isScrolled = false.obs;

  static const _pageSize = 10;

  int _page = 1;

  @override
  void onInit() {
    super.onInit();
    _loadFirstPage();
  }

  void toggleDescription() => isDescriptionExpanded.toggle();

  Future<void> _loadFirstPage() async {
    isLoading.value = true;
    _page = 1;
    hasMore.value = true;

    try {
      final res = await _repository.fetchProductList(
        page: _page,
        size: _pageSize,
        sort: _buildSortParam(),
        keyword: keyword.value.isEmpty ? null : keyword.value,
      );

      if (res.code != 1) throw new Exception(res.message);

      final data = res.data!;
      products.value = data.list;
      total.value = data.total;
      hasMore.value = data.list.length < data.total;
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
      final res = await _repository.fetchProductList(
        page: _page + 1,
        size: _pageSize,
        sort: _buildSortParam(),
        keyword: keyword.value.isEmpty ? null : keyword.value,
      );

      if (res.code != 1) throw new Exception(res.message);

      final data = res.data!;
      products.addAll(data.list);
      _page = data.page;
      hasMore.value = products.length < data.total;
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

  String? _buildSortParam() {
    final v = selectedSort.value;
    if (v == '默认') return null;
    return v;
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
    SnackBarUtil.primary('缺失商品已上报');
  }

  void toProductDetail(ProductModel product) {
    Get.toNamed('${AppRoutes.productDetail}?id=${product.id}');
  }
}
