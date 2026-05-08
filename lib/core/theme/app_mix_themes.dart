import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import 'app_theme.dart';

class AppMixStyles {
  // 通用卡片样式
  static Style get cardStyle => Style(
    $box.padding.all.ref(mxt.space.medium),
    $box.borderRadius.all.ref(mxt.radius.medium),
    $box.color.ref(mxt.color.surface),
    // 文本联动
    $text.style.ref(mxt.textStyle.body),
    $text.color.ref(mxt.color.onSurface),
  );

  // 标题文字样式
  static Style get titleStyle => Style(
    $text.style.ref(mxt.textStyle.headline1),
    $text.color.ref(mxt.color.onSurface),
  );
  // 副标题：中字 + 灰色
  static Style get subtitleStyle => Style(
    $text.style.ref(mxt.textStyle.headline2),
    $text.color.ref(mxt.color.onSurfaceVariant),
  );

  // 辅助说明：小字 + 变淡
  static Style get captionStyle => Style(
    $text.style.ref(mxt.textStyle.headline3),
    $text.color.ref(mxt.color.onSurfaceVariant),
  );

  // 按钮文字：标签字体 + 强制大写 (Mix 特色)

  // 2. 具体的语义 Tag

  // 1. Tag 基础布局样式
  static Style get _tagBase => Style(
    $box.padding.horizontal.ref(mxt.space.medium),
    $box.padding.vertical(6),
    $box.borderRadius.all.ref(mxt.radius.medium), // 建议新增一个较小的圆角 Token
    $text.style.ref(mxt.textStyle.caption), // 使用刚才定义的最小字号
    $text.fontWeight.w600(), // 标签文字通常稍微加粗
  );

  // 轮廓标签 (无背景，有边框)
  static Style get outlineTag => Style.combine([
    _tagBase,
    Style(
      $box.border.width(1),
      $box.border.color.ref(mxt.color.onSurfaceVariant),
      $text.color.ref(mxt.color.onSurfaceVariant),
    ),
  ]);

  static Style get brandCardStyle => Style(
    $box.padding(20),
    $box.borderRadius(16),
    $box.color.ref(mxt.color.surface),
    $box.shadow(
      color: Colors.black.withOpacity(0.1),
      blurRadius: 10,
      offset: const Offset(0, 4),
    ),
    // 交互态
    $on.hover(
      $box.color.ref(mxt.color.surfaceVariant),
      // $box.transform.scale(1.02),
    ),
    // $on.press($box.transform.scale(0.98)),
  );

  static Style get progressBarStyle =>
      Style($box.height(6), $box.borderRadius(3), $box.color(Colors.white10));
}

ThemeData convertMixToThemeData(MixThemeData mixData, Brightness brightness) {
  // 从 Mix 的 Token 中提取颜色
  final primaryColor = mixData.colors[mxt.color.primary]!;
  final surfaceColor = mixData.colors[mxt.color.surface]!;

  return ThemeData(
    brightness: brightness,
    useMaterial3: true,
    // 核心：使用 colorScheme.fromSeed 自动生成一套完整的 Material 颜色
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      surface: surfaceColor,
      brightness: brightness,
    ),
    // 同步 Scaffold 背景色
    scaffoldBackgroundColor: surfaceColor,
  );
}
