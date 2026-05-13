import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import '../../../../core/theme/app_theme.dart';

class MonthlySpendingStyle {
  /// 外部大卡片容器样式
  static Style get cardStyle => Style(
    $box.color.ref(mxt.color.surface),
    $box.borderRadius(16),
    $box.padding.horizontal(12),
    $box.padding.vertical(20),
  );

  /// 顶部标题样式
  static Style get headerTextStyle => Style(
    $text.style.color.ref(mxt.color.onSurface),
    $text.style.ref(mxt.textStyle.headline2),
    $text.style.fontWeight.bold(),
  );

  /// H1/H2 切换器背景容器
  static Style get toggleContainerStyle => Style(
    $box.color.black12(),
    $box.borderRadius(8),
    $box.padding.all(2),
    $box.height(28),
  );

  /// 年份选择器文字样式
  static Style get pickerTextStyle => Style(
    $text.style.color.ref(mxt.color.onSurface),
    $text.style.fontSize(13),
    $text.style.fontWeight.bold(),
  );
}
