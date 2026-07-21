import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:mix/mix.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_theme_tool.dart';
import '../../controller.dart';
import 'monthly_spending_trend.style.dart';

import 'package:miniauto_keeper/core/utils/screen_adapter.dart';

class MonthlySpendingTrend extends GetView<StatsController> {
  const MonthlySpendingTrend({super.key});

  @override
  Widget build(BuildContext context) {
    return Box(
      style: MonthlySpendingStyle.cardStyle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          SizedBox(height: h(16)),
          _buildChartCard(context),
        ],
      ),
    );
  }

  /// 构建顶部 Row：标题 + H1/H2 切换 + 年份选择
  Widget _buildHeader() {
    return Row(
      children: [
        StyledText(
          'Monthly spending trend',
          style: MonthlySpendingStyle.headerTextStyle,
        ),
        const Spacer(),
        // 使用 Material 3 SegmentedButton
        // Obx(
        //   () => SegmentedButton<int>(
        //     showSelectedIcon: false,
        //     // 选中的索引，必须是 Set 类型
        //     selected: {controller.isFirstHalf.value ? 0 : 1},
        //     // 选项配置
        //     segments: const [
        //       ButtonSegment<int>(value: 0, label: Text('H1')),
        //       ButtonSegment<int>(value: 1, label: Text('H2')),
        //     ],
        //     // 选中回调
        //     onSelectionChanged: (Set<int> newSelection) {
        //       controller.isFirstHalf.value = (newSelection.first == 0);
        //     },
        //     style: SegmentedButton.styleFrom(
        //       // 这里的 side 如果报错，请检查是否传入了 BorderSide.none 或具体的 BorderSide
        //       side: const BorderSide(color: Colors.transparent),
        //       shape: RoundedRectangleBorder(
        //         borderRadius: BorderRadius.circular(8),
        //       ),
        //       visualDensity: VisualDensity.comfortable,
        //     ),
        //   ),
        // ),
        SizedBox(width: w(12)),
        _buildYearPicker(),
      ],
    );
  }

  /// 构建切换按钮

  /// 构建图表卡片
  Widget _buildChartCard(BuildContext context) {
    return Obx(() {
      // 数据处理逻辑
      final allData =
          controller.annualData[controller.selectedYear.value] ?? [];
      final displayData = controller.isFirstHalf.value
          ? (allData.length >= 6 ? allData.sublist(0, 6) : allData)
          : (allData.length >= 12 ? allData.sublist(6, 12) : []);

      return Box(
        child: SizedBox(height: h(200),
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: 100,
              barTouchData: _touchData(context, displayData),
              titlesData: _titlesData(displayData),
              gridData: const FlGridData(show: false),
              borderData: FlBorderData(show: false),
              barGroups: _chartGroups(context, displayData),
            ),
            swapAnimationDuration: const Duration(milliseconds: 350),
          ),
        ),
      );
    });
  }

  /// 年份下拉选择器
  Widget _buildYearPicker() {
    FocusNode dropdownFocusNode = FocusNode();
    return Obx(
      () => DropdownButtonHideUnderline(
        child: Container(
          alignment: Alignment.centerLeft,
          child: DropdownButton<String>(
            focusNode: dropdownFocusNode,
            value: controller.selectedYear.value,
            icon: Padding(
              padding: EdgeInsets.only(left: w(12)), // 控制左侧间距
              child: Icon(Icons.keyboard_arrow_down, size: r(16)),
            ),
            onChanged: (val) {
              dropdownFocusNode.unfocus();
              return val != null ? controller.changeYear(val) : null;
            },
            items: controller.years
                .map(
                  (y) => DropdownMenuItem(
                    value: y,
                    child: StyledText(
                      y,
                      style: MonthlySpendingStyle.pickerTextStyle,
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }

  // --- FL Chart 辅助方法 ---
  BarTouchData _touchData(BuildContext context, List data) => BarTouchData(
    touchTooltipData: BarTouchTooltipData(
      tooltipBgColor: context.color(mxt.color.background),
      getTooltipItem: (group, groupIndex, rod, rodIndex) {
        return BarTooltipItem(
          '${data[groupIndex].month}\n',
          TextStyle(
            color: context.color(mxt.color.onSurface),
            fontWeight: FontWeight.bold,
          ),
          children: [
            TextSpan(
              text: '${rod.toY.toInt()}%',
              style: TextStyle(color: context.color(mxt.color.primary)),
            ),
          ],
        );
      },
    ),
  );

  FlTitlesData _titlesData(List data) => FlTitlesData(
    show: true,
    rightTitles: const AxisTitles(),
    topTitles: const AxisTitles(),
    leftTitles: const AxisTitles(),
    bottomTitles: AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        getTitlesWidget: (value, meta) {
          int i = value.toInt();
          if (i < 0 || i >= data.length) return const SizedBox();
          return Padding(
            padding: EdgeInsets.only(top: h(8)),
            child: Text(
              data[i].month,
              style: TextStyle(color: Colors.grey, fontSize: sp(11)),
            ),
          );
        },
      ),
    ),
  );

  List<BarChartGroupData> _chartGroups(BuildContext context, List data) {
    return data.asMap().entries.map((entry) {
      final isGrowth = entry.value.isGrowth;
      return BarChartGroupData(
        x: entry.key,
        barRods: [
          BarChartRodData(
            toY: entry.value.value.toDouble(),
            width: 28,
            borderRadius: BorderRadius.circular(4),
            gradient: LinearGradient(
              colors: [
                context.color(mxt.color.primary),
                context.color(mxt.color.primary).withOpacity(0.8),
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
            backDrawRodData: BackgroundBarChartRodData(
              show: true,
              toY: 100,
              color: context.color(mxt.color.surfaceVariant).withOpacity(0.6),
            ),
          ),
        ],
      );
    }).toList();
  }
}
