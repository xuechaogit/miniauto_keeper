import 'package:flutter/material.dart';
import 'package:mix/mix.dart';
import '../../../../core/theme/app_theme.dart';

class HorizontalCalendarStyle {
  // 基础容器样式
  static Style get itemContainer =>
      Style(
        $box.width(70),
        $box.height(85),
        $box.borderRadius(16),
        $box.color.ref(mxt.color.surfaceVariant),
        $with.opacity(0.75),
        $box.border.color.ref(mxt.color.outlineVariant),
      ).animate(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
      );

  // 选中时的样式叠加
  static Style get selectedItem =>
      Style($box.color.ref(mxt.color.primaryContainer), $with.opacity(1));

  // 选中时的边框样式叠加
  static Style get selectedBorder => Style(
    $box.border.color.ref(mxt.color.primary),
    $box.border.width(2),
    $box.border.color.ref(mxt.color.primary),
  );

  static Style get weekDayText => Style($text.style.fontSize(14));

  static Style get dayText =>
      Style($text.style.fontSize(16), $text.style.fontWeight.bold());

  static Style get dotIndicator => Style(
    $box.margin.top(4),
    $box.width(4),
    $box.height(4),
    $box.shape.circle(),
    $box.color.ref(mxt.color.primary),
  );
}
