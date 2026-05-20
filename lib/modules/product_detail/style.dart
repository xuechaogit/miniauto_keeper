import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

class ProductDetailStyle {
  // 赛车硬核深色底
  static final pageBackground = Style($box.color(const Color(0xFF121212)));

  // 工业仪表盘感内容区块容器
  static final industrialCard = Style(
    $box.color(const Color(0xFF1E1E1E)),
    $box.borderRadius(4),
    $box.padding(16),
    $box.margin.bottom(12),
    $box.border.color(const Color(0xFF2C2C2C)),
    $box.border.width(1),
    $box.border.style(BorderStyle.solid),
  );

  // 核心高亮警示红标签 (现货/预售)
  static final statusTagRed = Style(
    $box.color(const Color(0xFFE54335)),
    $box.borderRadius(2),
    $box.padding.horizontal(8),
    $box.padding.vertical(3),
  );

  // 灰色参数面板单元
  static final specGridItem = Style(
    $box.color(const Color(0xFF252525)),
    $box.padding(10),
    $box.borderRadius(2),
  );

  // 底部硬朗线条大操作按钮
  static final primaryActionBtn = Style(
    $box.color(const Color(0xFFE54335)),
    $box.height(50),
    $box.alignment.center(),
    $box.borderRadius(4),
  );
}
