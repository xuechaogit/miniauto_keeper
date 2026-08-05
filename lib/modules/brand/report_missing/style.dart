import 'dart:ui';

import 'package:mix/mix.dart';

import '../../../core/theme/app_theme.dart';

class ReportMissingStyle {
  static const accent = Color(0xFF3B5EF5);

  // ── 表单字段（垂直布局：label 上，value 下） ──

  static Style get formField =>
      Style($box.padding.vertical.ref(mxt.space.small));

  static Style get formLabel => Style(
    $text.color.ref(mxt.color.onSurfaceVariant),
    $text.style.ref(mxt.textStyle.caption),
    $text.fontWeight.w500(),
    $box.margin.bottom.ref(mxt.space.small),
  );

  static Style get formValueBox => Style(
    $box.height(48),
    $box.borderRadius.all(8),
    $box.color.ref(mxt.color.surface),
    $box.border.color.ref(mxt.color.outlineVariant),
    $box.border.width(1),
    $box.padding.horizontal.ref(mxt.space.medium),
    $flex.mainAxisAlignment.spaceBetween(),
    $flex.crossAxisAlignment.center(),
  );

  // ── 表单值文本 ──

  static Style get formValue => Style(
    $text.color.ref(mxt.color.onSurface),
    $text.style.ref(mxt.textStyle.body),
  );

  static Style get formPlaceholder => Style(
    $text.color.ref(mxt.color.onSurfaceVariant),
    $text.style.ref(mxt.textStyle.body),
  );

  // ── 输入框 ──

  static Style get inputField => Style(
    $box.height(48),
    $box.borderRadius.all(8),
    $box.color.ref(mxt.color.surface),
    $box.border.color.ref(mxt.color.outlineVariant),
    $box.border.width(1),
    $flex.mainAxisAlignment.center(),
    $flex.crossAxisAlignment.center(),
  );

  // ── 图片区域 ──

  static Style get imageSection => Style(
    $box.padding.all.ref(mxt.space.medium),
    $box.color.ref(mxt.color.surface),
    $box.margin.bottom.ref(mxt.space.medium),
  );

  static Style get imageSectionTitle => Style(
    $text.color.ref(mxt.color.onSurface),
    $text.style.ref(mxt.textStyle.headline3),
    $text.fontWeight.w600(),
  );

  static Style get imageAddBtn => Style(
    $box.width(80),
    $box.height(80),
    $box.borderRadius.all(8),
    $box.color.ref(mxt.color.surfaceVariant),
    $box.border.color.ref(mxt.color.outlineVariant),
    $box.border.width(1),
    $flex.mainAxisAlignment.center(),
    $flex.crossAxisAlignment.center(),
  );

  static Style get imageThumb => Style(
    $box.width(80),
    $box.height(80),
    $box.borderRadius.all(8),
    $box.clipBehavior.antiAlias(),
  );

  // ── 底部栏 ──

  static Style get bottomBar => Style(
    $box.color.ref(mxt.color.surface),
    $box.padding.all.ref(mxt.space.medium),
  );
}
