import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mix/mix.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/filter_chips/filter_chips.dart';
import 'controller.dart';
import 'widgets/action_button/action_button.dart';
import 'widgets/horizontal_calendar/horizontal_calendar.dart';
import 'widgets/horizontal_calendar/horizontal_calendar.style.dart';

class CalendarView extends GetView<CalendarController> {
  const CalendarView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: StyledText(
          'PRECISION HUB',
          style: Style($text.fontWeight.bold()),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          const CircleAvatar(radius: 15),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context), // 传入 context
            const SizedBox(height: 20),
            _buildHorizontalCalendar(),
            const SizedBox(height: 20),
            FilterChips(
              // 数据源：List<String>
              filters: controller.brands,
              // 选中的状态：RxString
              selectedFilter: controller.selectedBrand,
              // 点击回调：将点击的值传递给控制器逻辑
              onSelected: (value) => controller.changeBrand(value),
            ),
            const SizedBox(height: 30),
            _buildTodayIndicator(),
            const SizedBox(height: 16),
            _buildReleaseList(),
          ],
        ),
      ),
    );
  }

  // 标题栏：Release Calendar + 功能按钮
  // Header：点击图标弹出日历
  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Release Calendar',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            // 联动显示当前选中的月份
            Obx(
              () => Text(
                DateFormat(
                  'MMMM yyyy',
                ).format(controller.currentSelectedDate.value),
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
        Row(
          children: [
            ActionButton(
              icon: Icons.calendar_today_outlined,
              onTap: () => controller.pickDate(context),
            ),
            // const SizedBox(width: 10),
            // ActionButton(icon: Icons.tune, onTap: () {}),
          ],
        ),
      ],
    );
  }

  // 横向滚动日历：联动修改
  Widget _buildHorizontalCalendar() {
    return Obx(() {
      // 1. 显式读取长度，确保 Obx 注册
      if (controller.dateList.isEmpty) return const CircularProgressIndicator();

      return HorizontalCalendar(
        dateList: controller.dateList,
        selectedDateStr: controller.selectedDateStr,
        onDateSelected: (value) => controller.onDateChipSelected(value),
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
          const SizedBox(width: 12),
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
          const SizedBox(width: 12),
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
    return Obx(
      () => Column(
        children: controller.releases
            .map((product) => _buildProductCard(product))
            .toList(),
      ),
    );
  }

  Widget _buildProductCard(dynamic product) {
    return Box(
      style: Style(
        $box.margin.bottom(16),
        $box.padding(16),
        $box.borderRadius(20),
        $box.color.white.withOpacity(0.03),
        $box.border.color.ref(mxt.color.outlineVariant),
      ),
      child: Row(
        children: [
          // 模拟图片区域
          Box(
            style: Style(
              $box.width(80),
              $box.height(80),
              $box.borderRadius(12),
              $box.color.white.withOpacity(0.05),
            ),
            child: const Center(child: Icon(Icons.directions_car, size: 40)),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.brandName,
                  style: const TextStyle(
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                Text(
                  product.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(product.tags.last, style: const TextStyle(fontSize: 13)),
              ],
            ),
          ),
          const Icon(Icons.notifications_none),
        ],
      ),
    );
  }
}
