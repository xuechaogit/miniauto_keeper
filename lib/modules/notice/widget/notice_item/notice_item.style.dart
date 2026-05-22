import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import '../../../../core/theme/app_theme.dart';

class NoticeItemStyles {
  // 基础公告卡片样式
  static Style get cardMix => Style(
    $box.color.ref(mxt.color.surface),
    $box.borderRadius.all.ref(mxt.radius.medium),
    $box.padding(16),
    $box.border.color.ref(mxt.color.outlineVariant),
    $box.border.width(1),
    $box.border.style(BorderStyle.solid),
  );

  // 普通公告标题文本
  static Style get titleText => Style(
    $text.color.ref(mxt.color.onSurface),
    $text.style.ref(mxt.textStyle.headline3),
    $text.style.fontWeight(FontWeight.bold),
    $text.style.letterSpacing(0.5),
  );

  // 公告内容预览
  static Style get previewText => Style(
    $text.color.ref(mxt.color.onSurfaceVariant),
    $text.style.ref(mxt.textStyle.body),
    $text.style.height(1.4),
    $text.maxLines(2),
  );

  // 底部元数据文本（ID、日期）
  static Style get metaText => Style(
    $text.color.ref(mxt.color.onSurfaceVariant),
    $text.style.ref(mxt.textStyle.caption),
  );
}
