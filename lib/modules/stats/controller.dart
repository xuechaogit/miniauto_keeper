import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BarData {
  final String month;
  final double value;
  final bool isGrowth;

  BarData({required this.month, required this.value, this.isGrowth = false});
}

class StatsController extends GetxController {
  // 模拟总资产
  final totalValue = 142580.0.obs;
  // 模拟总收藏数量
  final totalCollections = 84.obs;
  // 增长率
  final growthRate = 12.4.obs;

  // 模拟柱状图数据
  final selectedYear = '2026'.obs;
  final years = ['2024', '2025', '2026'];
  // 增加半年份状态
  final isFirstHalf = true.obs;

  // 2. 模拟不同年份的数据源
  final Map<String, List<BarData>> annualData = {
    '2026': [
      BarData(month: 'JAN', value: 30),
      BarData(month: 'FEB', value: 45),
      BarData(month: 'MAR', value: 35),
      BarData(month: 'APR', value: 65, isGrowth: true),
      BarData(month: 'MAY', value: 75, isGrowth: true),
      BarData(month: 'JUN', value: 90, isGrowth: true),
      BarData(month: 'JUL', value: 85, isGrowth: true),
      BarData(month: 'AUG', value: 70),
      BarData(month: 'SEP', value: 95, isGrowth: true),
      BarData(month: 'OCT', value: 80),
      BarData(month: 'NOV', value: 85, isGrowth: true),
      BarData(month: 'DEC', value: 100, isGrowth: true),
    ],
    '2025': [
      BarData(month: 'JAN', value: 20),
      BarData(month: 'FEB', value: 25),
      BarData(month: 'MAR', value: 50, isGrowth: true),
      BarData(month: 'APR', value: 40),
      BarData(month: 'MAY', value: 55, isGrowth: true),
      BarData(month: 'JUN', value: 60, isGrowth: true),
      BarData(month: 'JUL', value: 45),
      BarData(month: 'AUG', value: 50),
      BarData(month: 'SEP', value: 65, isGrowth: true),
      BarData(month: 'OCT', value: 70, isGrowth: true),
      BarData(month: 'NOV', value: 75, isGrowth: true),
      BarData(month: 'DEC', value: 85, isGrowth: true),
    ],
    '2024': [
      BarData(month: 'JAN', value: 10),
      BarData(month: 'FEB', value: 15),
      BarData(month: 'MAR', value: 12),
      BarData(month: 'APR', value: 25, isGrowth: true),
      BarData(month: 'MAY', value: 30, isGrowth: true),
      BarData(month: 'JUN', value: 28),
      BarData(month: 'JUL', value: 35, isGrowth: true),
      BarData(month: 'AUG', value: 40, isGrowth: true),
      BarData(month: 'SEP', value: 38),
      BarData(month: 'OCT', value: 45, isGrowth: true),
      BarData(month: 'NOV', value: 50, isGrowth: true),
      BarData(month: 'DEC', value: 60, isGrowth: true),
    ],
  };

  // 3. 获取当前展示的数据
  List<BarData> get currentChartData => annualData[selectedYear.value] ?? [];

  void changeYear(String year) {
    selectedYear.value = year;
  }

  // 模拟品牌分布
  final brands = [
    {'name': 'Hot Wheels', 'value': 35.0, 'color': Color(0xFFE94E32)},
    {'name': 'Matchbox', 'value': 20.0, 'color': Color(0xFF2196F3)},
    {'name': 'Mini GT', 'value': 15.0, 'color': Color(0xFF4CAF50)},
    {'name': 'Kaido House', 'value': 10.0, 'color': Color(0xFFFFC107)},
    {'name': 'AutoArt', 'value': 8.0, 'color': Color(0xFF9C27B0)},
    {'name': 'Inno64', 'value': 5.0, 'color': Color(0xFF00BCD4)},
    {'name': 'Tarmac Works', 'value': 4.0, 'color': Color(0xFF795548)},
    {'name': 'Tomica', 'value': 3.0, 'color': Color(0xFF607D8B)},
  ].obs;

  // 新增：今日进度数据
  final todayAddedCount = 3.obs;
  final progressValue = 0.65.obs; // 0.0 到 1.0
  final progressDetail = "+2 Mini GT, +1 Kaido House".obs;

  // 模拟品牌图片路径 (你实际项目中替换为 asset 路径)
  final recentAddedLogos = [
    'https://images.unsplash.com/photo-1503376780353-7e6692767b70?q=80&w=800',
    'https://images.unsplash.com/photo-1592198084033-aade902d1aae?q=80&w=800',
    'https://images.unsplash.com/photo-1592198084033-aade902d1aae?q=80&w=400',
    'https://images.unsplash.com/photo-1592198084033-aade902d1aae?q=80&w=500',
    'https://images.unsplash.com/photo-1592198084033-aade902d1aae?q=80&w=600',
  ];

  // 过滤当前展示的数据
  List<BarData> get filteredChartData {
    final fullData = annualData[selectedYear.value] ?? [];
    if (fullData.isEmpty) return [];
    return isFirstHalf.value ? fullData.sublist(0, 6) : fullData.sublist(6, 12);
  }

  // 在 StatsController 内部
  List<Map<String, dynamic>> get summarizedBrands {
    if (brands.length <= 6) return brands;

    // 排序并取前 5
    var sorted = List<Map<String, dynamic>>.from(brands);
    sorted.sort(
      (a, b) => (b['value'] as double).compareTo(a['value'] as double),
    );

    var top5 = sorted.sublist(0, 5);

    // 计算剩余所有品牌的总和
    double othersValue = sorted
        .sublist(5)
        .fold(0, (sum, item) => sum + (item['value'] as double));

    return [
      ...top5,
      {'name': 'Others', 'value': othersValue, 'color': Colors.grey.shade600},
    ];
  }
}
