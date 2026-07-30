import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/services/settings_service.dart';

import '../../models/brand_stats.dart';

class BrandsController extends GetxController {
  // 模拟品牌数据列表 (.obs 使其成为响应式)
  final brands = <BrandModel>[].obs;
  final isLoading = true.obs; // 首次进入或下拉刷新的全局加载状态
  final isLoadingMore = false.obs; // 底部加载更多的轻量状态
  final hasMore = true.obs; // 是否还有更多数据

  int _page = 1; // 当前页码
  final int _pageSize = 4; // 每页条数

  // 模拟资产数据
  final totalValue = r"$4,250".obs;
  final portfolioGrowth = "+12.4%".obs;

  @override
  void onInit() {
    super.onInit();
    // 模拟从 API 加载数据
    fetchBrands();
  }

  // 模拟 API 数据库（准备了多条数据用来测试分页）
  final List<BrandModel> _mockDatabase = [
    BrandModel(
      name: 'Kaido House',
      collectedCount: 45,
      totalCount: 60,
      tag: 'HOT',
      themeColor: const Color(0xFFE30613), // 经典本田红/改装红
      category: 'JDM / Custom',
    ),
    BrandModel(
      name: 'Mini GT',
      collectedCount: 128,
      totalCount: 850,
      themeColor: const Color(0xFF212121),
      category: 'Global Edition',
    ),
    BrandModel(
      name: 'Tarmac Works',
      collectedCount: 32,
      totalCount: 200,
      tag: 'RACING',
      themeColor: const Color(0xFFFFD700), // 联名金
      category: 'Motorsport',
    ),
    BrandModel(
      name: 'Inno64',
      collectedCount: 12,
      totalCount: 180,
      tag: 'NEW',
      themeColor: const Color(0xFF00529B),
      category: 'Premium Diecast',
    ),
    BrandModel(
      name: 'Schuco',
      collectedCount: 18,
      totalCount: 120,
      themeColor: const Color(0xFF757575),
      category: 'Classic Euro',
    ),
    BrandModel(
      name: 'Ignition Model',
      collectedCount: 5,
      totalCount: 45,
      tag: 'ELITE',
      themeColor: const Color(0xFF4A148C),
      category: 'High-End Resin',
    ),
    BrandModel(
      name: 'Kaido House',
      collectedCount: 45,
      totalCount: 60,
      tag: 'HOT',
      themeColor: const Color(0xFFE30613), // 经典本田红/改装红
      category: 'JDM / Custom',
    ),
    BrandModel(
      name: 'Mini GT',
      collectedCount: 128,
      totalCount: 850,
      themeColor: const Color(0xFF212121),
      category: 'Global Edition',
    ),
    BrandModel(
      name: 'Tarmac Works',
      collectedCount: 32,
      totalCount: 200,
      tag: 'RACING',
      themeColor: const Color(0xFFFFD700), // 联名金
      category: 'Motorsport',
    ),
    BrandModel(
      name: 'Inno64',
      collectedCount: 12,
      totalCount: 180,
      tag: 'NEW',
      themeColor: const Color(0xFF00529B),
      category: 'Premium Diecast',
    ),
    BrandModel(
      name: 'Schuco',
      collectedCount: 18,
      totalCount: 120,
      themeColor: const Color(0xFF757575),
      category: 'Classic Euro',
    ),
    BrandModel(
      name: 'Ignition Model',
      collectedCount: 5,
      totalCount: 45,
      tag: 'ELITE',
      themeColor: const Color(0xFF4A148C),
      category: 'High-End Resin',
    ),
    BrandModel(
      name: 'Kaido House',
      collectedCount: 45,
      totalCount: 60,
      tag: 'HOT',
      themeColor: const Color(0xFFE30613), // 经典本田红/改装红
      category: 'JDM / Custom',
    ),
    BrandModel(
      name: 'Mini GT',
      collectedCount: 128,
      totalCount: 850,
      themeColor: const Color(0xFF212121),
      category: 'Global Edition',
    ),
    BrandModel(
      name: 'Tarmac Works',
      collectedCount: 32,
      totalCount: 200,
      tag: 'RACING',
      themeColor: const Color(0xFFFFD700), // 联名金
      category: 'Motorsport',
    ),
    BrandModel(
      name: 'Inno64',
      collectedCount: 12,
      totalCount: 180,
      tag: 'NEW',
      themeColor: const Color(0xFF00529B),
      category: 'Premium Diecast',
    ),
    BrandModel(
      name: 'Schuco',
      collectedCount: 18,
      totalCount: 120,
      themeColor: const Color(0xFF757575),
      category: 'Classic Euro',
    ),
    BrandModel(
      name: 'Ignition Model',
      collectedCount: 5,
      totalCount: 45,
      tag: 'ELITE',
      themeColor: const Color(0xFF4A148C),
      category: 'High-End Resin',
    ),
  ];

  // 刷新或初次加载
  Future<void> fetchBrands() async {
    _page = 1;
    hasMore.value = true;
    isLoading.value = true;

    await Future.delayed(const Duration(milliseconds: 1000)); // 模拟网络延迟

    // 模拟截取第一页数据
    final firstPageData = _mockDatabase.take(_pageSize).toList();
    brands.assignAll(firstPageData);

    isLoading.value = false;
  }

  // 加载更多
  Future<void> fetchMoreBrands() async {
    // 防抖：如果正在加载或者已经没有更多了，直接拦截
    if (isLoadingMore.value || !hasMore.value) return;

    isLoadingMore.value = true;
    await Future.delayed(const Duration(milliseconds: 2000)); // 模拟微小延迟

    final int startIndex = _page * _pageSize;

    if (startIndex >= _mockDatabase.length) {
      hasMore.value = false;
    } else {
      // 计算下一页的截取范围
      final nextPageData = _mockDatabase
          .skip(startIndex)
          .take(_pageSize)
          .toList();
      brands.addAll(nextPageData);
      _page++;

      // 判断加完这页后是否到头了
      if (brands.length >= _mockDatabase.length) {
        hasMore.value = false;
      }
    }
    isLoadingMore.value = false;
  }

  void quickAddCar() {
    print("触发快捷入库");
  }
}
