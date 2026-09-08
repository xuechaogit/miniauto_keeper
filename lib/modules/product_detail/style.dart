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
    $text.fontWeight.bold(),
    $text.textAlign.start(),
  );


  // ── 限量徽章 ──
  static Style get limitedBadge => Style(
    $text.color(accent),
    $text.style.ref(mxt.textStyle.caption),
    $text.fontWeight.w700(),
    $text.letterSpacing(0.5),
  );

  // 副标题（品牌 · 系列 · 货号）
  static Style get subtitle => Style(
    $text.color.ref(mxt.color.onSurfaceVariant),
    $text.style.ref(mxt.textStyle.caption),
  );

  // ── 规格分组标题 ──
  static Style get specGroupTitle => Style(
    $text.color.ref(mxt.color.onSurface),
    $text.style.ref(mxt.textStyle.caption),
    $text.fontWeight.w700(),
    $box.margin.bottom(6),
  );

  // ── 详情描述 ──
  static Style get descText => Style(
    $text.color.ref(mxt.color.onSurfaceVariant),
    $text.style.ref(mxt.textStyle.body),
  );

  // ── 人气 meta 行（并入简介区） ──
  static Style get hotMeta => Style(
    $text.color.ref(mxt.color.onSurfaceVariant),
    $text.style.ref(mxt.textStyle.caption),
    $text.fontWeight.normal(),
    $text.letterSpacing(0.3),
  );
}

