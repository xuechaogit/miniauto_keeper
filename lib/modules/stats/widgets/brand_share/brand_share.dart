import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:mix/mix.dart';
import '../../controller.dart';
import 'brand_share.style.dart';

class BrandShare extends GetView<StatsController> {
  const BrandShare({super.key});

  @override
  Widget build(BuildContext context) {
    // 使用 Box 替代 Container，StyledText 替代 Text
    return Box(
      style: BrandShareStyle.container,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StyledText('Brand Share', style: BrandShareStyle.title),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildChartSection(),
              const SizedBox(width: 30),
              _buildLegendSection(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChartSection() {
    return SizedBox(
      height: BrandShareStyle.pieSize,
      width: BrandShareStyle.pieSize,
      child: Obx(
        () => PieChart(
          PieChartData(
            sectionsSpace: 2,
            centerSpaceRadius: 40,
            startDegreeOffset: -90,
            sections: controller.summarizedBrands.map((brand) {
              return PieChartSectionData(
                color: brand['color'] as Color,
                value: brand['value'] as double,
                radius: 18,
                showTitle: false,
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildLegendSection() {
    return Expanded(
      child: Obx(
        () => Column(
          children: controller.summarizedBrands.map((brand) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  // 小圆点也可以用 Box 快速构建
                  Box(
                    style: Style(
                      $box.height(8),
                      $box.width(8),
                      $box.shape.circle(),
                      $box.color(brand['color'] as Color),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: StyledText(
                      brand['name'] as String,
                      style: BrandShareStyle.label,
                    ),
                  ),
                  StyledText(
                    '${(brand['value'] as double).toStringAsFixed(0)}%',
                    style: BrandShareStyle.valueText,
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
