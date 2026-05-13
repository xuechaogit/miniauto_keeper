import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../models/product_model.dart';

class CalendarController extends GetxController {
  // 品牌筛选：RxString
  final selectedBrand = 'ALL BRANDS'.obs;
  final List<Map<String, dynamic>> brands = [
    {'label': 'ALL BRANDS', 'value': 'ALL'},
    {'label': 'MINI GT', 'value': 'MINI GT'},
    {'label': 'KAIDO HOUSE', 'value': 'KAIDO HOUSE'},
    {'label': 'INNO64', 'value': 'INNO64'},
    {'label': 'TARMAC', 'value': 'TARMAC'},
  ];

  // 日期筛选：将日期转换为字符串列表以便 FilterChips 使用
  // 格式例如: "MON 11", "TUE 12"
  final RxString selectedDateStr = ''.obs; // 当前选中的日期字符串
  final dateList = <Map<String, dynamic>>[].obs; // 日期列表
  final currentSelectedDate = DateTime.now().obs; // 当前选中的日期

  final releases = <ProductModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadMockData();
    _generateDates();
  }

  // 根据当前选中的日期，生成前后各 7 天的日期字符串列表
  void _generateDates() {
    final base = currentSelectedDate.value;
    dateList.value = List.generate(15, (index) {
      final date = DateTime(
        base.year,
        base.month,
        base.day,
      ).add(Duration(days: index - 7));
      // 存储 label 用于 UI，value 用于逻辑
      return {
        'label': DateFormat('EEE d').format(date).toUpperCase(),
        'value': date,
      };
    });
    _updateSelectedDateStr();
  }

  void _updateSelectedDateStr() {
    selectedDateStr.value = DateFormat(
      'EEE d',
    ).format(currentSelectedDate.value).toUpperCase();
  }

  // 处理横向日历点击
  void onDateSelected(Map<String, dynamic> item) {
    DateTime selectedDate = item['value'];
    if (isSameDay(currentSelectedDate.value, selectedDate)) return;

    currentSelectedDate.value = selectedDate;
    selectedDateStr.value = item['label']; // 直接从 item 拿 label

    // 如果需要点击后重新居中，取消注释下面这行
    // _generateDates();
  }

  /// 辅助方法：判断是否为同一天（排除时间干扰）
  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  // 弹出 Material 日历选择器
  Future<void> pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: currentSelectedDate.value,
      firstDate: DateTime(2024),
      lastDate: DateTime(2026, 12, 31), // 明确指定到年底
    );
    if (picked != null) {
      currentSelectedDate.value = picked;
      _generateDates();
    }
  }

  void _loadMockData() {
    releases.assignAll([
      ProductModel(
        id: '1',
        title: 'Nissan Skyline GT-R (R34)',
        brandName: 'MINI GT',
        price: 19.99,
        imageUrl:
            'https://images.unsplash.com/photo-1544636331-e26879cd4d9b?q=80&w=800', // 实际图片路径
        tags: ['HOT', 'Z-Tune Midnight Purple III'],
      ),
      ProductModel(
        id: '2',
        title: 'Datsun 510 Pro Street',
        brandName: 'KAIDO HOUSE',
        price: 24.99,
        imageUrl:
            'https://images.unsplash.com/photo-1544636331-e26879cd4d9b?q=80&w=800',
        tags: ['OG Green Carbon Edition'],
      ),
    ]);
  }

  void changeBrand(Map<String, dynamic> brandItem) {
    selectedBrand.value = brandItem['value']!;
  }
}
