import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/theme/app_theme.dart';
import 'controller.dart';
import 'widgets/brand_share/brand_share.dart';
import 'widgets/header_stats/header_stats.dart';
import 'widgets/monthly_spending_trend/monthly_spending_trend.dart';
import 'package:mix/mix.dart';

import 'package:miniauto_keeper/core/utils/screen_adapter.dart';

class StatsView extends GetView<StatsController> {
  const StatsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PRECISION HUB'),
        elevation: 0,
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.search))],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(r(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(
              () => HeaderStats(
                totalValue: controller.totalValue.value,
                totalCollections: controller.totalCollections.value,
                growthRate: controller.growthRate.value,
              ),
            ),
            SizedBox(height: h(24)),
            _buildTodayGarage(),
            SizedBox(height: h(24)),
            //月花费趋势组件
            const MonthlySpendingTrend(),
            SizedBox(height: h(24)),
            // 品牌分布组件
            BrandShare(),
          ],
        ),
      ),
    );
  }

  Widget _buildTodayGarage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Today Added to Your Garage',
              style: TextStyle(fontSize: sp(18), fontWeight: FontWeight.bold),
            ),
            Text(
              '+${controller.todayAddedCount.value} Total Today',
              style: TextStyle(color: Color(0xFFE99E8D), fontSize: sp(14)),
            ),
          ],
        ),
        SizedBox(height: h(16)),
        Container(
          padding: EdgeInsets.all(r(16)),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
          child: Column(
            children: [
              Row(
                children: [
                  // 左侧图片叠加效果
                  SizedBox(width: w(80),
                    height: 40,
                    child: Stack(
                      children: [
                        Positioned(left: 0, child: _buildCarThumb()),
                        Positioned(
                          left: 20,
                          child: _buildCarThumb(isOverlay: true),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: w(12)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Collection Progress',
                          style: TextStyle(fontSize: sp(14)),
                        ),
                        Text(
                          controller.progressDetail.value,
                          style: TextStyle(fontSize: sp(12)),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.emoji_events_outlined,
                    color: Color(0xFFE99E8D),
                    size: 24,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // 辅助方法：构建图片缩略图
  Widget _buildCarThumb({bool isOverlay = false}) {
    return Container(
      width: 50,
      height: 35,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: const Color(0xFF1E1E1E), width: 2),
        image: const DecorationImage(
          image: NetworkImage('https://via.placeholder.com/50x35'), // 替换为你的本地图片
          fit: BoxFit.cover,
        ),
      ),
      child: isOverlay
          ? Center(
              child: Text(
                '+1',
                style: TextStyle(fontSize: sp(10), color: Colors.white),
              ),
            )
          : null,
    );
  }
}

class ThemeStyles {
  // 容器样式：圆角卡片，带内边距
  static final container = Style(
    $box.padding(20),
    $box.color.ref(mxt.color.surface),
    $box.decoration.borderRadius(16),
    // $box.decoration.shadow(
    //   color: Colors.black.withOpacity(0.05),
    //   blurRadius: 10,
    //   offset: const Offset(0, 4),
    // ),
  );

  // 标签样式 (小字标题)
  static final label = Style(
    $text.style.fontSize(12),
    $text.style.color.ref(mxt.color.onSurface),
    $text.style.fontWeight(FontWeight.w600),
    $text.style.letterSpacing(1.0),
  );

  // 数值基础样式
  static final valueBase = Style(
    $text.style.fontWeight(FontWeight.bold),
    $text.style.height(1.2),
  );

  // 资产数值 (大橘红)
  static final assetValue = valueBase.merge(
    Style($text.style.color(const Color(0xFFE99E8D)), $text.style.fontSize(32)),
  );

  // 收藏数值 (深色)
  static final collectionValue = valueBase.merge(
    Style(
      // $text.style.color(const Color(0基础333333)),
      $text.style.fontSize(28),
    ),
  );

  // 增长率标签
  static final growthBadge = Style(
    $box.padding.horizontal(8),
    $box.padding.vertical(2),
    $box.decoration.color(Colors.blue.withOpacity(0.1)),
    $box.decoration.borderRadius(20),
    $text.style.color(Colors.blue),
    $text.style.fontSize(12),
    $text.style.fontWeight(FontWeight.bold),
  );
}
