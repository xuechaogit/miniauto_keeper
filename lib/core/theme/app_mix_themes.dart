import 'package:mix/mix.dart';
import 'package:flutter/material.dart';

class AppMixStyles {
  // 通用卡片样式 (用于仓库中的模型车卡片)
  static Style get cardStyle => Style(
    $box.padding(16),
    $box.borderRadius(12),
    $box.color.white(),
    $box.shadow.color(Colors.black.withOpacity(0.05), blurRadius: 10),
    $box.border.all(color: Colors.grey.shade200, width: 1),
    // 鼠标悬停或点击时的交互状态
    $on.hover(
      $box.border.color.ref(ColorScheme.primary),
      $box.shadow.blurRadius(15),
    ),
  );

  // 高对比度标题文本样式
  static Style get titleStyle => Style(
    $text.style.fontWeight.bold(),
    $text.style.fontSize(18),
    $text.style.letterSpacing(0.5),
    $text.style.color.black(),
  );

  // 状态标签样式 (如：库存充足、已售罄)
  static Style get badgeStyle => Style(
    $box.padding.horizontal(8),
    $box.padding.vertical(4),
    $box.borderRadius(4),
    $text.style.fontSize(12),
    $text.style.fontWeight.w600(),
  );
}
