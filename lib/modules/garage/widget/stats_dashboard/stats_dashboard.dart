import 'package:flutter/material.dart';
import 'package:mix/mix.dart';
import '../../../../core/theme/app_theme.dart';
import 'stats_dashboard.style.dart';

import 'package:miniauto_keeper/core/utils/screen_adapter.dart';

class StatsDashboard extends StatelessWidget {
  final String modelsCount;
  final String brandsCount;
  final String valuation;

  const StatsDashboard({
    super.key,
    required this.modelsCount,
    required this.brandsCount,
    required this.valuation,
  });

  @override
  Widget build(BuildContext context) {
    return Box(
      style: StatsDashboardStyles.containerBox,
      child: Row(
        children: [
          Expanded(
            child: FlexBox(
              direction: Axis.horizontal,
              style: StatsDashboardStyles.flexBoxStyle,
              children: [
                _buildIntegratedItem(
                  "MODELS",
                  modelsCount,
                  style: StatsDashboardStyles.valueText,
                ),
                _innerDivider(),
                _buildIntegratedItem(
                  "BRANDS",
                  brandsCount,
                  style: StatsDashboardStyles.valueText,
                ),
                _innerDivider(),
                _buildIntegratedItem(
                  "VALUATION",
                  valuation,
                  style: StatsDashboardStyles.redValueText,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 内部集成的单个数据项
  Widget _buildIntegratedItem(
    String label,
    String value, {
    required Style style,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        StyledText(label, style: StatsDashboardStyles.labelText),
        SizedBox(height: h(6)),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: StyledText(
            value,
            style: style.merge(
              // 补充等宽数字特性，防止数字变动时面板抖动
              Style(
                $text.style.fontFeatures([const FontFeature.tabularFigures()]),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // 极细纵向分割线
  Widget _innerDivider() {
    return Box(
      style: Style(
        $box.width(1),
        $box.height(36),
        $box.color.ref(mxt.color.outlineVariant),
      ),
    );
  }
}
