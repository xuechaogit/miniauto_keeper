import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import '../../../../core/theme/app_theme.dart';

class NoticeSkeletonStyles {
  // 基础骨架卡片外框
  static Style get cardMix => Style(
    $box.color.ref(mxt.color.surface),
    $box.borderRadius.all.ref(mxt.radius.medium),
    $box.padding(16),
    $box.margin.bottom(12),
    $box.margin.horizontal(16),
    $box.border.color.ref(mxt.color.outlineVariant),
    $box.border.width(1),
  );
}
