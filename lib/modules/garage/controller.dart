import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:miniauto_keeper/core/services/garage_repository.dart';
import 'package:miniauto_keeper/models/garage_item.dart';

/// 排序维度枚举
enum SortType {
  priceAsc, // 单价从低到高
  priceDesc, // 单价从高到低
  dateAsc, // 购入时间从旧到新
  dateDesc, // 购入时间从新到旧
}

/// 车库页控制器：只保留 UI 状态（视图模式/搜索/排序/筛选）。
/// 原始数据与分页/写操作全部收敛于 GarageRepository（MainBinding 常驻）。
class GarageController extends GetxController {
  /// 全局仓库：唯一数据源
  final repo = Get.find<GarageRepository>();

  final isListMode = false.obs;

  // --- UI 状态 ---
  final searchQuery = ''.obs; // 搜索关键字（本地过滤：仅作用于已加载数据）
  final currentSort = SortType.priceDesc.obs; // 当前排序方式
  final selectedBrands = <String>[].obs; // 选中的品牌过滤（本地）
  final selectedFilter = 'All'.obs;

  // 筛选标签状态
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

  // --- 请求状态转发（仓库持有，页面只读） ---
  bool get isLoading => repo.isLoading.value;
  bool get isLoadingMore => repo.isLoadingMore.value;
  bool get hasMore => repo.hasMore.value;

  // --- 界面展示用的流 (计算属性，底层数据来自仓库) ---
  List<GarageItem> get filteredModels {
    List<GarageItem> list = repo.models.where((item) {
      final name =
          '${item.model.name} ${item.model.brand.name}'.toLowerCase();
      final query = searchQuery.value.toLowerCase();
      final matchesSearch = query.isEmpty || name.contains(query);

      // 品牌多选过滤（本地）
      final matchesBrand =
          selectedBrands.isEmpty ||
              selectedBrands.contains(item.model.brand.name);

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
      repo.models.map((e) => e.model.brand.name).toSet().toList()..sort();

  // --- 统计真实值（派生自仓库已加载数据） ---
  /// 车库总条数（服务端 meta.total，前端按已加载数据兜底）
  int get totalModels =>
      repo.total.value > 0 ? repo.total.value : repo.models.length;

  /// 已加载数据中的去重品牌数
  int get brandModelsCount =>
      repo.models.map((e) => e.model.brand.name).toSet().length;

  /// 车库总估值（purchasePrice 求和，前端展示用）
  double get totalValuation => repo.models.fold(
    0,
    (sum, e) => sum + (double.tryParse(e.purchasePrice) ?? 0),
  );

  /// 估值展示文案：>=1000 缩写为 K（保留 1 位）
  String get valuationLabel {
    final v = totalValuation;
    if (v >= 1000) return '\$${(v / 1000).toStringAsFixed(1)}K';
    return '\$${v.toStringAsFixed(0)}';
  }

  // --- 数据操作方法：委托仓库 ---

  /// 下拉刷新：强制回到第一页
  @override
  Future<void> refresh() => repo.refresh();

  /// 触底加载更多
  Future<void> loadMore() => repo.loadMore();

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
