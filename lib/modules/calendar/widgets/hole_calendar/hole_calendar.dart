import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// 孔洞日历卡片
/// 上方：孔洞圆点（实心=有数据，空心=无数据）
/// 下方：Release Calendar 标题 + 月份 + 日期
class HoleCalendar extends StatelessWidget {
  final DateTime selectedDate;
  final Map<String, bool> dataMap; // "yyyy-MM-dd" → 是否有数据
  final VoidCallback? onCalendarTap;

  const HoleCalendar({
    super.key,
    required this.selectedDate,
    required this.dataMap,
    this.onCalendarTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final now = DateTime.now();
    // 当前选中日期所在周的周一
    final weekStart = selectedDate.subtract(
      Duration(days: selectedDate.weekday - 1),
    );
    final weekDays = List.generate(
      7,
      (i) => weekStart.add(Duration(days: i)),
    );

    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withOpacity(0.3),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 孔洞行
          _buildHoleRow(context, weekDays),
          const SizedBox(height: 12),
          // 标题 + 图标
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Release Calendar',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                onTap: onCalendarTap,
                child: Icon(
                  Icons.calendar_today_outlined,
                  size: 22,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          // 月份
          Text(
            DateFormat('MMMM yyyy').format(selectedDate).toUpperCase(),
            style: TextStyle(
              fontSize: 14,
              color: theme.colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 14),
          // 星期
          _buildWeekdayRow(context, weekDays),
          const SizedBox(height: 6),
          // 日期数字
          _buildDayNumberRow(context, weekDays),
        ],
      ),
    );
  }

  Widget _buildHoleRow(BuildContext context, List<DateTime> weekDays) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: weekDays.map((day) {
        final key = DateFormat('yyyy-MM-dd').format(day);
        final hasData = dataMap[key] == true;
        return Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: hasData
                ? theme.colorScheme.primary
                : Colors.transparent,
            border: Border.all(
              color: hasData
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurface.withOpacity(0.15),
              width: 1.5,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildWeekdayRow(BuildContext context, List<DateTime> weekDays) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: weekDays.map((day) {
        final label = DateFormat('EEE').format(day).toUpperCase().substring(0, 3);
        return SizedBox(
          width: 36,
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface.withOpacity(0.4),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDayNumberRow(BuildContext context, List<DateTime> weekDays) {
    final theme = Theme.of(context);
    final now = DateTime.now();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: weekDays.map((day) {
        final isToday = day.year == now.year &&
            day.month == now.month &&
            day.day == now.day;
        final isSelected = day.year == selectedDate.year &&
            day.month == selectedDate.month &&
            day.day == selectedDate.day;
        return Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isSelected
                ? theme.colorScheme.primary
                : isToday
                    ? Colors.amber.withOpacity(0.15)
                    : Colors.transparent,
            border: isToday && !isSelected
                ? Border.all(color: Colors.amber, width: 1)
                : null,
          ),
          alignment: Alignment.center,
          child: Text(
            '${day.day}',
            style: TextStyle(
              fontSize: 16,
              fontWeight: isSelected || isToday ? FontWeight.bold : FontWeight.w500,
              color: isSelected
                  ? Colors.white
                  : theme.colorScheme.onSurface,
            ),
          ),
        );
      }).toList(),
    );
  }
}
