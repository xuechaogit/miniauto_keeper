import 'package:flutter/material.dart';
import 'package:mix/mix.dart';
import '../../../../core/theme/app_mix_themes.dart';
import '../../../core/theme/app_theme.dart';

class BrandCardStyle {
  /// 1. 卡片外层容器
  static Style get container => Style(
    $box.height(180),
    $box.borderRadius(20),
    $box.clipBehavior.antiAlias(),
    $box.color.ref(mxt.color.brandCardBg), // 引用你的主题 Token
    $box.border.all(color: Colors.white.withOpacity(0.05), width: 1),
  );

  /// 2. 背景方格旗容器样式
  static Style get checkerFlag => Style(
    $box.width(220),
    $box.height.infinity(),
    $box.decoration.image(
      image: const AssetImage('assets/images/checker_flag.webp'),
      fit: BoxFit.cover,
      alignment: Alignment.centerRight,
    ),
  );

  /// 3. 信息层内边距
  static Style get contentPadding => Style($box.padding.all(24));

  /// 4. 品牌 Logo 大文字 (背景层)
  static Style get logoText => Style(
    $text.style.fontSize(32),
    $text.style.fontWeight.w900(),
    $text.style.color(Colors.white.withOpacity(0.9)),
    $text.style.letterSpacing(-1.5),
    $text.style.shadow(
      color: Colors.black26,
      blurRadius: 10,
      offset: const Offset(2, 2),
    ),
  );

  /// 5. 数量数字样式
  static Style get countText => Style(
    $text.style.fontSize(48),
    $text.style.fontWeight.w700(),
    $text.style.color(Colors.white),
    $text.style.height(1),
  );

  /// 6. "Total Inclusion" 辅助说明文字
  static Style get subLabelText => Style(
    $text.style.ref(mxt.textStyle.body),
    $text.style.color(Colors.white70),
  );

  /// 7. 迷你标签容器
  static Style get miniTagContainer => Style(
    $box.padding.horizontal(8),
    $box.padding.vertical(4),
    $box.borderRadius(4),
    $box.color(Colors.black.withOpacity(0.4)),
  );

  /// 8. 迷你标签文字
  static Style get miniTagText => Style(
    $text.style.ref(mxt.textStyle.caption),
    $text.style.color(Colors.white70),
    // $text.style.fontWeight.bold(),
  );

  /// 9. 底部描述文字
  static Style get descriptionText => Style(
    $text.style.ref(mxt.textStyle.caption),
    $text.style.color(Colors.white30),
    $text.overflow.ellipsis(),
    $text.maxLines(1),
  );
}
