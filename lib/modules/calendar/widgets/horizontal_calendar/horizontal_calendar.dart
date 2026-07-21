import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mix/mix.dart';
import 'package:miniauto_keeper/core/utils/screen_adapter.dart';
import '../../../../core/widgets/filter_chips/filter_chips.dart';

import 'horizontal_calendar.dart';
import 'horizontal_calendar.style.dart';

class HorizontalCalendar extends StatelessWidget {
  const HorizontalCalendar({
    super.key,
    required this.dateList,
    required this.selectedDateStr,
    required this.onDateSelected,
  });

  final List<Map<String, dynamic>> dateList;
  final RxString selectedDateStr;
  final Function(Map<String, dynamic>) onDateSelected;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (dateList.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      return FilterChips.builder(
        key: ValueKey(dateList.hashCode),
        filters: dateList,
        selectedFilter: selectedDateStr,
        onSelected: onDateSelected,
        itemBuilder: (context, index, isSelected) {
          // 解析日期数据，例如 "MON 11"
          final String label = dateList[index]['label'];
          final parts = label.split(' ');
          final weekDay = parts[0];
          final day = parts[1];
          // 根据选中状态合并样式
          final containerStyle = isSelected
              ? HorizontalCalendarStyle.itemContainer.merge(
                  HorizontalCalendarStyle.selectedItem,
                )
              : HorizontalCalendarStyle.itemContainer;
          return Box(
            style: containerStyle,

            // 关键：将选中的状态传递给 Mix Style
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                StyledText(weekDay, style: HorizontalCalendarStyle.weekDayText),
                SizedBox(height: h(4)),
                StyledText(day, style: HorizontalCalendarStyle.dayText),

                // 选中时的红点指示器
                if (isSelected)
                  Box(style: HorizontalCalendarStyle.dotIndicator),
              ],
            ),
          );
        },
      );
    });
  }
}
