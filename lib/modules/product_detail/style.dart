import 'dart:ui';

import 'package:mix/mix.dart';

import '../../../core/theme/app_theme.dart';

class ProductDetailStyle {
  static const accent = Color(0xFFE54335);

  // 底部操作按钮

  // 底栏图标+文字按钮
  static Style get bottomIconBtn => Style(
    $flex.gap(4),
    $flex.crossAxisAlignment.center(),
    $flex.mainAxisAlignment.center(),
  );

  // 图标按钮文字
  static Style get bottomIconBtnText => Style(
    $text.color.ref(mxt.color.onSurfaceVariant),
    $text.style.ref(mxt.textStyle.caption),
  );

  // 按钮文字
  static Style get btnText => Style(
    $text.color(const Color(0xFFFFFFFF)),
    $text.fontWeight.w700(),
    $text.style.ref(mxt.textStyle.body),
    $text.letterSpacing(0.5),
  );

  // 商品全称
  static Style get productTitle => Style(
    $text.color.ref(mxt.color.onSurface),
    $text.style.ref(mxt.textStyle.headline3),
    $text.textAlign.start(),
  );

  // ── 参数面板 ──

  static Style get paramRow => Style(
    $flex.mainAxisAlignment.spaceBetween(),
    $flex.crossAxisAlignment.center(),
    $box.padding.horizontal.ref(mxt.space.medium),
  );

  static Style get paramLabel => Style(
    $text.color.ref(mxt.color.onSurfaceVariant),
    $text.style.ref(mxt.textStyle.caption),
  );

  static Style get paramValue => Style(
    $text.color.ref(mxt.color.onSurface),
    $text.style.ref(mxt.textStyle.caption),
    $text.fontWeight.w600(),
  );

  static Style get expandBtn => Style(
    $flex.mainAxisAlignment.center(),
    $flex.crossAxisAlignment.center(),
  );

  static Style get expandBtnText => Style(
    $text.color.ref(mxt.color.primary),
    $text.style.ref(mxt.textStyle.caption),
    $text.fontWeight.w600(),
  );

  // ── 评分卡片 ──
  static Style get ratingValue => Style(
    $text.color.ref(mxt.color.onSurface),
    $text.style.ref(mxt.textStyle.headline3),
  );
}
