import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import '../../../../core/theme/app_theme.dart';

class HeaderStatsStyles {
  // 基础卡片容器
  static final container = Style(
    $box.padding(16),
    $box.color.ref(mxt.color.surface),
    $box.decoration.borderRadius(16),
  );

  // 标题标签
  static final label = Style(
    $text.style.ref(mxt.textStyle.headline3),
    $text.style.fontWeight.bold(),
    $text.style.color.ref(mxt.color.onSurface),
  );

  // 收藏数值 (主色)
  static final collectionValue = Style(
    $text.style.fontWeight(FontWeight.bold),
    $text.style.height(1.2),
    $text.style.fontSize(24),
    $text.style.color.ref(mxt.color.onSurface),
  );

  // 增长率 Badge
  static final growthBadge = Style(
    $box.padding.horizontal(8),
    $box.padding.vertical(4),
    $box.decoration.color(Colors.blue.withOpacity(0.1)),
    $box.decoration.borderRadius(20),
    $text.style.color(Colors.blue),
    $text.style.fontSize(12),
    $text.style.fontWeight(FontWeight.bold),
  );

  // 用于 Items 文本的微调样式
  static final itemsLabel = label.merge(
    Style(
      $text.style.ref(mxt.textStyle.caption),
      $text.style.fontWeight(FontWeight.normal),
    ),
  );
}
