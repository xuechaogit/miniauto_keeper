import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:miniauto_keeper/core/network/api/garage_api.dart';
import 'package:miniauto_keeper/core/network/http_service.dart';
import 'package:miniauto_keeper/core/utils/snackbar_util.dart';
import 'package:miniauto_keeper/models/garage_item.dart';

/// 排序维度枚举
enum SortType {
  priceAsc, // 单价从低到高
  priceDesc, // 单价从高到低
  dateAsc, // 购入时间从旧到新
  dateDesc, // 购入时间从新到旧
}

class GarageController extends GetxController {
  final isListMode = false.obs;

  // --- 原始数据源（真实车库条目） ---
  final RxList<GarageItem> _allModels = <GarageItem>[].obs;

  // --- 状态变量 ---
  final searchQuery = ''.obs; // 搜索关键字（本地过滤：仅作用于已加载数据）
  final currentSort = SortType.priceDesc.obs; // 当前排序方式
  final selectedBrands = <String>[].obs; // 选中的品牌过滤（本地）

  // --- 分页状态 ---
  final isLoading = false.obs;
  final isLoadingMore = false.obs;
  final hasMore = true.obs;
  final total = 0.obs; // 服务端总条数（meta.total）
  int _page = 1;
  static const _pageSize = 10;

  // retrofit 接口实例：复用 HttpService 的 dio（baseUrl 与响应处理已收敛于 HttpService）
  final GarageApi _api = GarageApi(HttpService.to.dio);

  // 筛选标签状态
  final selectedFilter = 'All'.obs;
  final List<Map<String, dynamic>> filters = [
    {'label': 'ALL', 'value': 'ALL'},
    {'label': 'MINI GT', 'value': 'MINI GT'},
    {'label': 'KAIDO HOUSE', 'value': 'KAIDO HOUSE'},
    {'label': 'INNO64', 'value': 'INNO64'},
    {'label': 'TARMAC', 'value': 'TARMAC'},
  ];

  final List<Map<String, dynamic>> sortOptions = [
    {
      'label': 'PRICE: HIGH-LOW',
      'value': SortType.priceDesc,
      'icon': Icons.arrow_downward,
    },
    {
      'label': 'PRICE: LOW-HIGH',
      'value': SortType.priceAsc,
      'icon': Icons.arrow_upward,
    },
    {
      'label': 'DATE: NEWEST',
      'value': SortType.dateDesc,
      'icon': Icons.calendar_today,
    },
    {'label': 'DATE: OLDEST', 'value': SortType.dateAsc, 'icon': Icons.history},
  ];

  // --- 界面展示用的流 (计算属性) ---
  List<GarageItem> get filteredModels {
    List<GarageItem> list = _allModels.where((item) {
      final name =
          '${item.model.name} ${item.model.brand.name}'.toLowerCase();
      final query = searchQuery.value.toLowerCase();
      final matchesSearch = query.isEmpty || name.contains(query);

      // 品牌多选过滤（本地）
      final matchesBrand =
          selectedBrands.isEmpty || selectedBrands.contains(item.model.brand.name);

      return matchesSearch && matchesBrand;
    }).toList();

    // 排序（价格/购入日期均来自真实车库字段）
    switch (currentSort.value) {
      case SortType.priceAsc:
        list.sort(
          (a, b) =>
              (double.tryParse(a.purchasePrice) ?? 0)
                  .compareTo(double.tryParse(b.purchasePrice) ?? 0),
        );
        break;
      case SortType.priceDesc:
        list.sort(
          (a, b) =>
              (double.tryParse(b.purchasePrice) ?? 0)
                  .compareTo(double.tryParse(a.purchasePrice) ?? 0),
        );
        break;
      case SortType.dateAsc:
        list.sort(
          (a, b) => (DateTime.tryParse(a.purchaseDate) ?? DateTime(0))
              .compareTo(DateTime.tryParse(b.purchaseDate) ?? DateTime(0)),
        );
        break;
      case SortType.dateDesc:
        list.sort(
          (a, b) => (DateTime.tryParse(b.purchaseDate) ?? DateTime(0))
              .compareTo(DateTime.tryParse(a.purchaseDate) ?? DateTime(0)),
        );
        break;
    }
    return list;
  }

  // 获取所有可用的品牌（去重，用于筛选面板）
  List<String> get availableBrands =>
      _allModels.map((e) => e.model.brand.name).toSet().toList()..sort();

  // --- 统计真实值 ---
  /// 车库总条数（服务端 meta.total，前端按已加载数据兜底）
  int get totalModels =>
      total.value > 0 ? total.value : _allModels.length;

  /// 已加载数据中的去重品牌数
  int get brandModelsCount =>
      _allModels.map((e) => e.model.brand.name).toSet().length;

  /// 车库总估值（purchasePrice 求和，前端展示用）
  double get totalValuation => _allModels.fold(
        0,
        (sum, e) => sum + (double.tryParse(e.purchasePrice) ?? 0),
      );

  /// 估值展示文案：>=1000 缩写为 K（保留 1 位）
  String get valuationLabel {
    final v = totalValuation;
    if (v >= 1000) return '\$${(v / 1000).toStringAsFixed(1)}K';
    return '\$${v.toStringAsFixed(0)}';
  }

  @override
  void onInit() {
    super.onInit();
    _loadFirstPage();
  }

  // --- 真实接口加载 ---
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
      _allModels.assignAll(items);
      total.value = envelope.meta?.total ?? items.length;
      hasMore.value =
          (envelope.meta?.lastPage ?? (_page + 1)) > _page && items.isNotEmpty;
    } on DioException catch (e) {
      _allModels.clear();
      total.value = 0;
      SnackBarUtil.error(_extractApiMessage(e));
    } catch (e) {
      _allModels.clear();
      total.value = 0;
      SnackBarUtil.error(_extractApiMessage(e));
    } finally {
      isLoading.value = false;
    }
  }

  /// 下拉刷新：回到第一页
  @override
  Future<void> refresh() => _loadFirstPage();

  /// 触底加载更多
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
        _allModels.addAll(items);
        total.value = envelope.meta?.total ?? total.value;
        hasMore.value = (envelope.meta?.lastPage ?? _page) > _page;
      }
    } catch (e) {
      // 保持现有数据不变
    } finally {
      isLoadingMore.value = false;
    }
  }

  /// 提取接口错误信息：优先响应体 message，兜底 e.error
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

  // --- 交互方法 ---
  void updateSortWithoutPop(SortType type) {
    currentSort.value = type;
    // 不再调用 Get.back()，因为 Dropdown 选完会自动收起
  }

  void toggleViewMode() {
    isListMode.value = !isListMode.value;
  }

  void changeFilter(Map<String, dynamic> brandItem) {
    selectedFilter.value = brandItem['value']!;
  }

  void updateSearch(String value) => searchQuery.value = value;

  void updateSort(SortType type) {
    currentSort.value = type;
    if (Get.isBottomSheetOpen ?? false) Get.back();
  }

  void toggleBrand(String brand) {
    if (selectedBrands.contains(brand)) {
      selectedBrands.remove(brand);
    } else {
      selectedBrands.add(brand);
    }
  }

  void resetFilters() {
    selectedBrands.clear();
    searchQuery.value = '';
    currentSort.value = SortType.priceDesc;
  }

  // 格式化当前排序显示的文字
  String get sortLabel {
    switch (currentSort.value) {
      case SortType.priceAsc:
        return "PRICE: LOW TO HIGH";
      case SortType.priceDesc:
        return "PRICE: HIGH TO LOW";
      case SortType.dateAsc:
        return "DATE: OLDEST FIRST";
      case SortType.dateDesc:
        return "DATE: NEWEST FIRST";
    }
  }
}
