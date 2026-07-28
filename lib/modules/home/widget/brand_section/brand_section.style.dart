import 'dart:ui';

import 'package:miniauto_keeper/core/theme/app_theme.dart';
import 'package:miniauto_keeper/core/utils/screen_adapter.dart';
import 'package:mix/mix.dart';

class BrandSectionStyle {
  // ========== 胶囊标签 — 三档规格 ==========

  static Style _pillBase(double height, double radius) => Style(
    $box.height(height),
    $box.borderRadius.all.circular(radius),
    $flex.mainAxisSize.min(),
    $flex.mainAxisAlignment.center(),
    $flex.crossAxisAlignment.center(),
    $flex.gap.ref(mxt.space.small),
    $box.padding.horizontal.ref(mxt.space.medium),
    $box.padding.vertical(h(6)),
    $box.color.ref(mxt.color.surface),
    $box.border.all(width: 1),
    $box.border.color.ref(mxt.color.outlineVariant),
  );

  // 大号 42×21
  static Style get pillLarge => _pillBase(h(42), r(21));
  // 中号 36×18
  static Style get pillMedium => _pillBase(h(36), r(18));
  // 小号 30×15
  static Style get pillSmall => _pillBase(h(30), r(15));

  // 选中叠加
  static Style get cardSelected => Style(
    $box.color.ref(mxt.color.primaryContainer),
    $box.border.all(width: 2),
    $box.border.color.ref(mxt.color.outlinePrimary),
    $box.shadow(
      color: const Color(0xFF93C5FD).withOpacity(0.15),
      blurRadius: 6,
      offset: const Offset(0, 2),
    ),
  );

  // ========== 文字三档 ==========
  static Style get nameLarge => Style(
    $text.maxLines(1),
    $text.overflow.ellipsis(),
    $text.style.ref(mxt.textStyle.headline3),
    $text.style.fontWeight.w600(),
    $text.color.ref(mxt.color.onSurfaceVariant),
  );

  static Style get nameMedium => Style(
    $text.maxLines(1),
    $text.overflow.ellipsis(),
    $text.style.ref(mxt.textStyle.body),
    $text.style.fontWeight.w500(),
    $text.color.ref(mxt.color.onSurfaceVariant),
  );

  static Style get nameSmall => Style(
    $text.maxLines(1),
    $text.overflow.ellipsis(),
    $text.style.ref(mxt.textStyle.caption),
    $text.style.fontWeight.w400(),
    $text.color.ref(mxt.color.onSurfaceVariant),
  );

  static Style get nameSelected => Style($text.color.ref(mxt.color.onSurface));

  // Wrap 外层
  static Style get wrapContainer => Style();
}
