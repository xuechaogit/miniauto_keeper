import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/network/api/catalog_api.dart';
import '../../core/network/http_service.dart';
import '../../models/brand_stats.dart';
import '../../models/catalog_brand.dart';

class BrandsController extends GetxController {
  // 品牌数据列表 (.obs 使其成为响应式)
  final brands = <CatalogBrand>[].obs;
  final isLoading = true.obs; // 首次进入或下拉刷新的全局加载状态
  final isLoadingMore = false.obs; // 底部加载更多的轻量状态
  final hasMore = true.obs; // 是否还有更多数据

  int _page = 1; // 当前页码（后端从 1 开始）

  // retrofit 接口实例：复用 HttpService 的 dio（baseUrl 与剥壳拦截器已收敛于 HttpService）
  final CatalogApi _api = CatalogApi(HttpService.to.dio);

  // 模拟资产数据
  final totalValue = r"$4,250".obs;
  final portfolioGrowth = "+12.4%".obs;

  @override
  void onInit() {
    super.onInit();
    fetchBrands();
  }

  // 刷新或初次加载：拦截器剥壳后得到 envelope { data, meta }
  Future<void> fetchBrands() async {
    _page = 1;
    hasMore.value = true;
    isLoading.value = true;
    try {
      final envelope = await _api.getBrands(_page);
      final items = envelope.data;
      brands.assignAll(items);
      print("品牌列表已刷新，当前页: $_page, 数据量: ${items.length}");
      print(items);
      // meta 不在时回退为「拿到非空数据即视为有下一页」
      hasMore.value =
          (envelope.meta?.lastPage ?? (_page + 1)) > _page && items.isNotEmpty;
    } catch (_) {
      // 业务失败：保持空列表
    } finally {
      isLoading.value = false; // 必须复位，否则骨架屏卡死
    }
  }

  // 加载更多
  Future<void> fetchMoreBrands() async {
    // 防抖：如果正在加载或者已经没有更多了，直接拦截
    if (isLoadingMore.value || !hasMore.value) return;

    isLoadingMore.value = true;
    try {
      final nextPage = _page + 1;
      final envelope = await _api.getBrands(nextPage);
      final items = envelope.data;
      if (items.isEmpty) {
        // 返回空列表说明已到底
        hasMore.value = false;
      } else {
        _page = envelope.meta?.currentPage ?? nextPage;
        brands.addAll(items);
        hasMore.value = (envelope.meta?.lastPage ?? _page) > _page;
      }
    } catch (_) {
      // 保持现有数据不变
    } finally {
      isLoadingMore.value = false;
    }
  }

  void quickAddCar() {
    print("触发快捷入库");
  }

  // 接口暂无主题色字段：按品牌名稳定派生一个色板色
  Color _colorFromName(String name) {
    const palette = [
      Color(0xFFE30613),
      Color(0xFF212121),
      Color(0xFFFFD700),
      Color(0xFF00529B),
      Color(0xFF4A148C),
      Color(0xFF757575),
    ];
    return palette[name.hashCode.abs() % palette.length];
  }
}
