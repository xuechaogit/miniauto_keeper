import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:miniauto_keeper/core/utils/screen_adapter.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../models/product_model.dart';
import 'repository.dart';

class CalendarController extends GetxController {
  final _repository = CalendarRepository();

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
    final picked = await showDialog<DateTime>(
      context: context,
      builder: (ctx) => Dialog(
        // 自定义外层 Container，赋予现代化的圆角与阴影
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 8,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Container(
          width: w(300),
          height: 420, // 1. 固定整体高度，彻底解决数据加载/切换时的窗口抖动问题
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(ctx).colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Obx(() {
            if (isLoading.value) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(strokeWidth: 3),
                    SizedBox(height: 16),
                    Text(
                      'Loading calendar...',
                      style: TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  ],
                ),
              );
            }
            return TableCalendar(
              // 2. 填充整个 420px 的卡片空间，布局自然舒展，不再拥挤
              shouldFillViewport: true,
              focusedDay: currentYearMonth.value,
              firstDay: DateTime(2024),
              lastDay: DateTime(2026, 12, 31),
              selectedDayPredicate: (day) =>
                  isSameDay(day, currentSelectedDate.value),
              enabledDayPredicate: (day) => hasDataForDate(day),
              onDaySelected: (selectedDay, _) {
                Navigator.of(ctx).pop(selectedDay);
              },
              onPageChanged: (focusedDay) {
                fetchMonth(focusedDay.year, focusedDay.month);
              },
              calendarFormat: CalendarFormat.month,

              // 3. 自定义精致的 Header（月份/左右箭头）
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                titleTextStyle: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(ctx).colorScheme.onSurface,
                ),
                leftChevronIcon: Icon(
                  Icons.chevron_left_rounded,
                  color: Theme.of(ctx).colorScheme.primary,
                  size: 28,
                ),
                rightChevronIcon: Icon(
                  Icons.chevron_right_rounded,
                  color: Theme.of(ctx).colorScheme.primary,
                  size: 28,
                ),
                headerPadding: const EdgeInsets.only(bottom: 12),
              ),

              // 4. 自定义星期头部（Mon, Tue, Wed...）
              daysOfWeekStyle: DaysOfWeekStyle(
                weekdayStyle: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(ctx).colorScheme.onSurface.withOpacity(0.5),
                ),
                weekendStyle: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(ctx).colorScheme.error.withOpacity(0.6),
                ),
              ),

              // ================= 核心：自定义渲染构建器 =================
              calendarBuilders: CalendarBuilders(
                // 当日期被禁用（无数据）时触发此回调
                disabledBuilder: (context, day, focusedDay) {
                  // 判断这个禁用的日期是不是“今天”
                  if (isSameDay(day, DateTime.now())) {
                    return Center(
                      child: Container(
                        margin: const EdgeInsets.all(6),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          // 禁用状态下的“今天”：使用浅色背景和醒目的虚线/实线边框
                          color: Theme.of(
                            context,
                          ).colorScheme.primary.withOpacity(0.08),
                          border: Border.all(
                            color: Theme.of(
                              context,
                            ).colorScheme.primary.withOpacity(0.4),
                            width: 1.5,
                          ),
                        ),
                        child: Text(
                          '${day.day}',
                          style: TextStyle(
                            // 文字使用带有主色的浅半透明，区分于普通灰色禁用状态
                            color: Theme.of(
                              context,
                            ).colorScheme.primary.withOpacity(0.5),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  }

                  // 普通的禁用日期保持默认样式（返回 null 就会按 calendarStyle.disabledTextStyle 渲染）
                  return null;
                },
              ),
              // 5. 精细化日期单元格样式
              calendarStyle: CalendarStyle(
                cellMargin: const EdgeInsets.all(6),
                // 选中日期：突出高亮
                selectedDecoration: BoxDecoration(
                  color: Theme.of(ctx).colorScheme.primary,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(ctx).colorScheme.primary.withOpacity(0.4),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                selectedTextStyle: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                // 今天：柔和浅背景
                todayDecoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.15), // 柔和的浅黄色背景
                  shape: BoxShape.circle, // 圆形
                  border: Border.all(color: Colors.amber, width: 1), // 添加一个实心边框
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 3,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                todayTextStyle: TextStyle(
                  color: Theme.of(ctx).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
                // 正常有数据的日期
                defaultTextStyle: TextStyle(
                  color: Theme.of(ctx).colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                ),
                // 禁用日期（无数据）
                disabledTextStyle: TextStyle(
                  color: Theme.of(ctx).colorScheme.onSurface.withOpacity(0.2),
                ),
              ),
            );
          }),
        ),
      ),
    );

    if (picked != null) {
      currentSelectedDate.value = picked;
      _updateSelectedDateStr();
    }
  }
}
