import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/services/settings_service.dart';

import '../../models/brand_stats.dart';

class BrandsController extends GetxController {
  // 模拟品牌数据列表 (.obs 使其成为响应式)
  final brands = <BrandModel>[].obs;

  // 模拟资产数据
  final totalValue = r"$4,250".obs;
  final portfolioGrowth = "+12.4%".obs;

  @override
  void onInit() {
    super.onInit();
    // 模拟从 API 加载数据
    loadMockData();
  }

  // 2. 调用真实的 API 接口
  void loadMockData() {
    brands.assignAll([
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
    ]);
  }

  void quickAddCar() {
    print("触发快捷入库");
  }
}
