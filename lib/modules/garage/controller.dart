import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/product_model.dart';

/// 排序维度枚举
enum SortType {
  priceAsc, // 单价从低到高
  priceDesc, // 单价从高到低
  dateAsc, // 购入时间从旧到新
  dateDesc, // 购入时间从新到旧
}

/// 模型数据结构

class GarageController extends GetxController {
  final isListMode = false.obs;

  // --- 原始数据源 ---
  final RxList<ProductModel> _allModels = <ProductModel>[].obs;

  // --- 状态变量 ---
  final searchQuery = ''.obs; // 搜索关键字
  final currentSort = SortType.priceDesc.obs; // 当前排序方式
  final selectedBrands = <String>[].obs; // 选中的品牌过滤

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
  // 当搜索、排序或筛选发生变化时，filteredModels 会自动更新
  List<ProductModel> get filteredModels {
    List<ProductModel> list = _allModels.where((item) {
      // 1. 搜索过滤 (名称或品牌)
      final matchesSearch =
          item.title.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
          item.brandName.toLowerCase().contains(
            searchQuery.value.toLowerCase(),
          );

      // 2. 品牌多选过滤
      final matchesBrand =
          selectedBrands.isEmpty || selectedBrands.contains(item.brandName);

      return matchesSearch && matchesBrand;
    }).toList();

    // 3. 排序逻辑
    switch (currentSort.value) {
      case SortType.priceAsc:
        list.sort((a, b) => a.price.compareTo(b.price));
        break;
      case SortType.priceDesc:
        list.sort((a, b) => b.price.compareTo(a.price));
        break;
      case SortType.dateAsc:
        list.sort((a, b) => a.purchaseDate.compareTo(b.purchaseDate));
        break;
      case SortType.dateDesc:
        list.sort((a, b) => b.purchaseDate.compareTo(a.purchaseDate));
        break;
    }
    return list;
  }

  // 获取所有可用的品牌（去重，用于筛选面板）
  List<String> get availableBrands =>
      _allModels.map((e) => e.brandName).toSet().toList()..sort();

  @override
  void onInit() {
    super.onInit();
    _loadMockData();
  }

  // --- 交互方法 ---
  void updateSortWithoutPop(SortType type) {
    currentSort.value = type;
    // 不再调用 Get.back()，因为 Dropdown 选完会自动收起
  }

  void toggleViewMode() {
    print('isListMode.value ${isListMode.value}');
    isListMode.value = !isListMode.value;
  }

  void changeFilter(Map<String, dynamic> brandItem) {
    selectedFilter.value = brandItem['value']!;
    print('brandItem ${brandItem}');
    print(' selectedFilter.value ${selectedFilter.value}');
  }

  void updateSearch(String value) => searchQuery.value = value;

  void updateSort(SortType type) {
    currentSort.value = type;
    if (Get.isBottomSheetOpen ?? false) Get.back(); // 选完自动关闭菜单
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

  // --- 模拟数据填充 ---
  void _loadMockData() {
    _allModels.assignAll([
      ProductModel(
        id: '1',
        title: 'Porsche 911 (992) GT3 RS - Ice Grey',
        brandName: 'Porsche',
        price: 299.0,
        thumb:
            'https://images.unsplash.com/photo-1503376780353-7e6692767b70?q=80&w=800',
        tags: ['1:18', 'Limited'],
      ),
      ProductModel(
        id: '2',
        title: 'Ferrari SF90 Stradale Assetto Fiorano',
        brandName: 'Ferrari',
        price: 350.0,
        thumb:
            'https://images.unsplash.com/photo-1592198084033-aade902d1aae?q=80&w=800',
        tags: ['1:18', 'Diecast'],
      ),
      ProductModel(
        id: '3',
        title: 'Lamborghini Huracán STO - Blue Laufey',
        brandName: 'Lamborghini',
        price: 280.0,
        thumb:
            'https://images.unsplash.com/photo-1544636331-e26879cd4d9b?q=80&w=800',
        tags: ['1:43', 'In Stock'],
      ),
      ProductModel(
        id: '4',
        title:
            'Lamborghini Huracán STO - Blue Laufey Lamborghini Huracán STO - Blue Laufey',
        brandName: 'Lamborghini',
        price: 280.0,
        thumb:
            'https://images.unsplash.com/photo-1544636331-e26879cd4d9b?q=80&w=800',
        tags: ['1:43', 'In Stock'],
      ),
      ProductModel(
        id: '5',
        title:
            'Lamborghini Huracán STO - Blue Laufey Lamborghini Huracán STO - Blue Laufey',
        brandName: 'Lamborghini',
        price: 280.0,
        thumb:
            'https://images.unsplash.com/photo-1544636331-e26879cd4d9b?q=80&w=800',
        tags: ['1:43', 'In Stock'],
      ),
      ProductModel(
        id: '6',
        title: 'BMW M4 CSL (G82) - Frozen Grey',
        brandName: 'BMW',
        price: 180.0,
        thumb:
            'https://images.unsplash.com/photo-1555215695-3004980ad94e?q=80&w=800',
        tags: ['1:18', 'New'],
      ),
      ProductModel(
        id: '7',
        title: 'Audi RS6 Avant - Nardo Grey Custom',
        brandName: 'Audi',
        price: 150.0,
        thumb:
            'https://images.unsplash.com/photo-1606152421660-0e7829762957?q=80&w=800',
        tags: ['1:43', 'Classic'],
      ),
    ]);
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
