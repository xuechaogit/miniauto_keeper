import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import '../../../../core/theme/app_theme.dart';

class BrandShareStyle {
  // 核心卡片容器样式
  static Style get container => Style(
    $text.style.color.ref(mxt.color.onSurface),
    $box.color.ref(mxt.color.surface),
    $box.borderRadius(16),
    $box.padding.all(20),
  );

  // 标题样式
  static Style get title => Style(
    $text.style.fontSize(18),
    $text.style.fontWeight.bold(),
    $text.style.letterSpacing(0.5),
  );

  // 品牌名称标签
  static Style get label => Style(
    $text.style.color.ref(mxt.color.onSurface),
    $text.style.fontSize(13),
  );

  // 数值样式
  static Style get valueText => Style(
    $text.style.color.ref(mxt.color.onSurface),
    $text.style.fontSize(13),
    $text.style.fontWeight.bold(),
  );

  // 环形图的基础常量
  static const double pieSize = 140;
}
