import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../models/product_model.dart';

class CalendarController extends GetxController {
  // 品牌筛选：RxString
  final selectedBrand = 'ALL BRANDS'.obs;
  final brands = ['ALL BRANDS', 'MINI GT', 'KAIDO HOUSE', 'INNO64', 'TARMAC'];

  // 日期筛选：将日期转换为字符串列表以便 FilterChips 使用
  // 格式例如: "MON 11", "TUE 12"
  final RxString selectedDateStr = ''.obs;
  final dateList = <String>[].obs;

  // 实际存储的 DateTime 对象，用于逻辑计算
  final currentSelectedDate = DateTime.now().obs;

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
      final date = base.add(Duration(days: index - 7));
      return DateFormat('EEE d').format(date).toUpperCase();
    });
    _updateSelectedDateStr();
  }

  void _updateSelectedDateStr() {
    selectedDateStr.value = DateFormat(
      'EEE d',
    ).format(currentSelectedDate.value).toUpperCase();
  }

  // 处理横向日历点击
  void onDateChipSelected(String dateStr) {
    selectedDateStr.value = dateStr;
    // 反向推算 DateTime (实际建议直接在列表存储 Model，这里简化处理)
    final index = dateList.indexOf(dateStr);
    if (index != -1) {
      currentSelectedDate.value = currentSelectedDate.value.add(
        Duration(days: index - 7),
      );
    }
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

  void changeBrand(String brand) => selectedBrand.value = brand;
}
