import 'dart:math';
import 'dart:ui';

import 'package:miniauto_keeper/core/theme/app_theme.dart';
import 'package:miniauto_keeper/core/utils/screen_adapter.dart';
import 'package:mix/mix.dart';

class BrandSectionStyle {
  // ========== 磁吸标签云 - 胶囊容器 ==========

  static final _neonCyan = const Color(0xFF00E5FF);
  static final _neonPink = const Color(0xFF2D55);
  static final _cardBg = const Color(0xFF131822);
  static final _rng = Random();

  // 胶囊基础
  static Style _pillBase(double height, Color borderColor, double borderOpacity) => Style(
    $box.height(height),
    $box.color(_cardBg),
    $box.borderRadius.all.circular(height / 2),
    $box.border.all(width: 1, color: borderColor.withOpacity(borderOpacity)),
    $flex.mainAxisSize.min(),
    $flex.mainAxisAlignment.center(),
    $flex.crossAxisAlignment.center(),
    $flex.gap(w(6)),
    $box.padding.horizontal(w(12)),
  );

  // 三档胶囊
  static Style get pillLarge => _pillBase(h(42), _neonCyan, 0.6);
  static Style get pillMedium => _pillBase(h(36), _neonPink, 0.35);
  static Style get pillSmall => _pillBase(h(30), _neonCyan, 0.15);

  // logo 小图标
  static Style get pillLogo => Style(
    $box.width(w(22)),
    $box.height(w(22)),
    $box.borderRadius.all.circular(r(4)),
  );

  // 品牌名文字
  static Style get pillNameLarge => Style(
    $text.maxLines(1),
    $text.overflow.ellipsis(),
    $text.color(const Color(0xFFFFFFFF)),
    $text.style.fontSize(sp(13)),
    $text.style.fontWeight.w600(),
  );

  static Style get pillNameMedium => Style(
    $text.maxLines(1),
    $text.overflow.ellipsis(),
    $text.color(const Color(0xFFFFFFFF)),
    $text.style.fontSize(sp(12)),
    $text.style.fontWeight.w500(),
  );

  static Style get pillNameSmall => Style(
    $text.maxLines(1),
    $text.overflow.ellipsis(),
    $text.color(const Color(0xFFFFFFFF)),
    $text.style.fontSize(sp(11)),
    $text.style.fontWeight.w400(),
  );

  // Wrap 外层
  static Style get wrapContainer => Style(
    $box.padding.horizontal(w(16)),
    $box.padding.vertical(h(12)),
  );
}
