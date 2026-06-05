import 'package:animated_digit/animated_digit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:miniauto_keeper/core/widgets/tag/tag.dart';
import 'package:mix/mix.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_theme_tool.dart';
import '../../../main/controller.dart';
import 'header_stats.style.dart';

class HeaderStats extends StatelessWidget {
  final double totalValue;
  final int totalCollections;
  final double growthRate;

  const HeaderStats({
    super.key,
    required this.totalValue,
    required this.totalCollections,
    required this.growthRate,
  });

  @override
  Widget build(BuildContext context) {
    final mainController = Get.find<MainController>();
    final int currentIndex = mainController.currentIndex; // 当前选中的tab索引
    return Box(
      style: HeaderStatsStyles.container,
      child: Column(
        children: [
          // 上部分：总资产
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StyledText(
                    'TOTAL ESTIMATED VALUE',
                    style: HeaderStatsStyles.label,
                  ),
                  const SizedBox(height: 4),
                  // =================== 动画数字组件 ===================
                  AnimatedDigitWidget(
                    key: ValueKey('stats_animate_${currentIndex == 3}'),
                    value: currentIndex == 3 ? totalValue : 0,
                    prefix: '\$',
                    enableSeparator: true,
                    fractionDigits: 0,
                    curve: Curves.easeOutExpo,
                    duration: const Duration(milliseconds: 1500),
                    textStyle: TextStyle(
                      // 💡 从解析后的样式中直接读取具体的颜色、字号等
                      color: context.color(mxt.color.primary),
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                      fontFeatures: const [
                        FontFeature.tabularFigures(),
                      ], // 保持等宽
                    ),
                  ),
                ],
              ),
              CustomTag.builder(
                builder: (context, state) {
                  return HBox(
                    children: [
                      const Icon(
                        Icons.trending_up,
                        color: Colors.blue,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      StyledText(
                        '+$growthRate%',
                        style: HeaderStatsStyles.growthBadge,
                      ),
                    ],
                  );
                },
              ),
            ],
          ),

          // 分割线
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Divider(
              color: context.color(mxt.color.outlineVariant),
              thickness: 1,
            ),
          ),

          // 下部分：收藏统计
          Row(
            children: [
              const Icon(Icons.auto_awesome_mosaic_outlined, size: 18),
              const SizedBox(width: 8),
              StyledText('COLLECTIONS', style: HeaderStatsStyles.label),
              const Spacer(),
              HBox(
                children: [
                  StyledText(
                    '$totalCollections',
                    style: HeaderStatsStyles.collectionValue,
                  ),
                  const SizedBox(width: 4),
                  StyledText('Items', style: HeaderStatsStyles.itemsLabel),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
