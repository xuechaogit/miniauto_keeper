import 'package:flutter/material.dart';
import 'package:mix/mix.dart';
import '../../../../../core/theme/app_mix_themes.dart';
import '../../../../core/theme/app_theme.dart';
import '../brand_card/brand_card.style.dart';

class BrandSkeletonItemStyle {
  /// 1. 骨架屏外层卡片容器（直接复用真实卡片的宽高、边框和圆角）
  static Style get container => BrandCardStyle.container;

  /// 2. 骨架屏内部内容区边距
  static Style get contentPadding => BrandCardStyle.contentPadding;

  /// 3. 微光图块默认的灰色背景和圆角
  static Style get defaultBlock => Style($box.borderRadius.all(4));

  /// 4. 专门针对 MiniTag 形状的骨架图块样式
  static Style get tagBlock => Style($box.borderRadius.all(4));
}
