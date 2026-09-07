import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:miniauto_keeper/core/theme/app_theme_tool.dart';
import 'package:miniauto_keeper/core/widgets/divider/divider.dart';
import 'package:mix/mix.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/product/product.dart';

import 'controller.dart';
import 'widgets/action_button/action_button.dart';
import 'widgets/horizontal_calendar/horizontal_calendar.dart';
import 'widgets/note_paper/note_paper.dart';

import 'package:miniauto_keeper/core/utils/screen_adapter.dart';

class CalendarView extends GetView<CalendarController> {
  const CalendarView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.color(mxt.color.surface),
        elevation: 0,
        title: StyledText(
          'PRECISION HUB',
          style: Style($text.fontWeight.bold()),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(w(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            NotePaper(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context),
                  AppDivider(style: Style($box.margin.vertical(w(12)))),
                  _buildHorizontalCalendar(),
                ],
              ),
            ),
            SizedBox(height: h(30)),
            _buildTodayIndicator(),
            SizedBox(height: h(16)),

            _buildReleaseList(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StyledText(
              'Release Calendar',
              style: Style(
                $text.style.ref(mxt.textStyle.headline1),
                $text.fontWeight.bold(),
              ),
            ),
            Obx(
              () => StyledText(
                DateFormat(
                  'MMMM yyyy',
                ).format(controller.currentSelectedDate.value),
                style: Style($text.style.ref(mxt.textStyle.headline3)),
              ),
            ),
          ],
        ),
        ActionButton(
          icon: Icons.calendar_today_outlined,
          onTap: () => controller.pickDate(context),
        ),
      ],
    );
  }

  Widget _buildHorizontalCalendar() {
    return Obx(() {
      if (controller.dateList.isEmpty) return const CircularProgressIndicator();
      if (controller.filteredDateList.isEmpty) return const SizedBox.shrink();
      return HorizontalCalendar(
        dateList: controller.filteredDateList,
        selectedDateStr: controller.selectedDateStr,
        onDateSelected: (value) => controller.onDateSelected(value),
      );
    });
  }

  Widget _buildTodayIndicator() {
    return Obx(() {
      // 格式化当前选中的日期，用于中间文本展示
      // 如果 selectedDateStr 是 "MON 11"，我们可以根据逻辑判断是否显示 "TODAY"
      // 这里为了演示，直接使用控制器中的 currentSelectedDate
      final dateText = DateFormat(
        'MMM d',
      ).format(controller.currentSelectedDate.value).toUpperCase();

      // 模拟判断：如果选中的是今天，显示 TODAY，否则显示 SELECTED
      final isToday = _isSameDay(
        controller.currentSelectedDate.value,
        DateTime.now(),
      );
      final label = isToday ? 'TODAY' : 'SELECTED';

      return Row(
        children: [
          // 左侧短线
          Box(
            style: Style(
              $box.width(40),
              $box.height(1),
              $box.color.ref(mxt.color.primary),
            ),
          ),
          SizedBox(width: w(12)),
          // 中间文字部分
          StyledText(
            '$label · $dateText',
            style: Style(
              $text.fontSize(14),
              $text.color.ref(mxt.color.primary),
              $text.fontWeight.bold(),
              $text.letterSpacing(1.2),
            ),
          ),
          SizedBox(width: w(12)),
          // 右侧长线撑满
          // Expanded(child: Container(height: 1, color: Colors.white10)),
        ],
      );
    });
  }

  // 辅助方法：判断是否为同一天
  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  // 产品卡片列表
  Widget _buildReleaseList() {
    return Obx(() {
      final products = controller.currentDayProducts;
      if (controller.isLoading.value) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(32),
            child: CircularProgressIndicator(),
          ),
        );
      }
      if (products.isEmpty) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(32),
            child: Text('当日无上新', style: TextStyle(color: Colors.grey)),
          ),
        );
      }
      return VBox(
        style: Style($box.padding.all(w(6)), $box.color.ref(mxt.color.surface)),
        children: products.asMap().entries.expand((entry) {
          final index = entry.key;
          final p = entry.value;

          return [
            ProductItem(p, isListMode: true),
            // 只要不是最后一个商品，就插入一条分割线
            if (index < products.length - 1) AppDivider(),
          ];
        }).toList(),
      );
    });
  }
}
