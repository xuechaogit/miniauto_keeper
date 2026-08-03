import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../models/product_model.dart';
import 'repository.dart';

class CalendarController extends GetxController {
  final _repository = CalendarRepository();

  // 品牌筛选
  final selectedBrand = 'ALL BRANDS'.obs;
  final List<Map<String, dynamic>> brands = [
    {'label': 'ALL BRANDS', 'value': 'ALL'},
    {'label': 'MINI GT', 'value': 'MINI GT'},
    {'label': 'KAIDO HOUSE', 'value': 'KAIDO HOUSE'},
    {'label': 'INNO64', 'value': 'INNO64'},
    {'label': 'TARMAC', 'value': 'TARMAC'},
  ];

  // 日期筛选
  final RxString selectedDateStr = ''.obs;
  final dateList = <Map<String, dynamic>>[].obs;
  final filteredDateList = <Map<String, dynamic>>[].obs;
  final currentSelectedDate = DateTime.now().obs;
  final currentYearMonth = DateTime.now().obs;
  final isLoading = false.obs;

  // API 数据
  final etaData = <String, List<ProductModel>>{}.obs;

  // 当前选中日期的产品
  List<ProductModel> get currentDayProducts {
    final key = DateFormat('yyyy-MM-dd').format(currentSelectedDate.value);
    return etaData[key] ?? [];
  }

  // 判断某天是否有数据
  bool hasDataForDate(DateTime date) {
    final key = DateFormat('yyyy-MM-dd').format(date);
    return etaData[key]?.isNotEmpty == true;
  }

  @override
  void onInit() {
    super.onInit();
    fetchMonth(DateTime.now().year, DateTime.now().month);
  }

  Future<void> fetchMonth(int year, int month) async {
    isLoading.value = true;
    try {
      final res = await _repository.fetchPlanList(year: year, month: month);
      etaData.value = res.etaData;
      currentYearMonth.value = DateTime(year, month);
      _generateDates(year, month);
      if (currentSelectedDate.value.year != year ||
          currentSelectedDate.value.month != month) {
        currentSelectedDate.value = DateTime(
          year,
          month,
          DateTime.now().day.clamp(1, DateTime(year, month + 1, 0).day),
        );
      }
      _updateSelectedDateStr();
    } catch (e) {
      print('Error fetching data for $year-$month: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void _generateDates(int year, int month) {
    final daysInMonth = DateTime(year, month + 1, 0).day;
    dateList.value = List.generate(daysInMonth, (i) {
      final date = DateTime(year, month, i + 1);
      return {
        'label': DateFormat('EEE d').format(date).toUpperCase(),
        'value': date,
      };
    });
    _updateFilteredDateList();
  }

  void _updateFilteredDateList() {
    filteredDateList.value = dateList.where((item) {
      final date = item['value'] as DateTime;
      return hasDataForDate(date);
    }).toList();
  }

  void _updateSelectedDateStr() {
    selectedDateStr.value = DateFormat(
      'EEE d',
    ).format(currentSelectedDate.value).toUpperCase();
  }

  void onDateSelected(Map<String, dynamic> item) {
    DateTime selectedDate = item['value'];
    if (isSameDay(currentSelectedDate.value, selectedDate)) return;
    currentSelectedDate.value = selectedDate;
    selectedDateStr.value = item['label'];
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  void goToPreviousMonth() {
    final prev = DateTime(
      currentYearMonth.value.year,
      currentYearMonth.value.month - 1,
    );
    fetchMonth(prev.year, prev.month);
  }

  void goToNextMonth() {
    final next = DateTime(
      currentYearMonth.value.year,
      currentYearMonth.value.month + 1,
    );
    fetchMonth(next.year, next.month);
  }

  Future<void> pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: currentSelectedDate.value,
      firstDate: DateTime(2024),
      lastDate: DateTime(2026, 12, 31),
      selectableDayPredicate: (day) => hasDataForDate(day),
    );
    if (picked != null) {
      if (picked.year != currentYearMonth.value.year ||
          picked.month != currentYearMonth.value.month) {
        await fetchMonth(picked.year, picked.month);
      }
      currentSelectedDate.value = picked;
      _updateSelectedDateStr();
    }
  }

  void changeBrand(Map<String, dynamic> brandItem) {
    selectedBrand.value = brandItem['value']!;
  }
}
