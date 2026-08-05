import 'dart:ui';

import 'package:mix/mix.dart';

import '../../../core/theme/app_theme.dart';

class ReportMissingStyle {
  static const accent = Color(0xFF3B5EF5);

  // 表单行
  static Style get formRow => Style(
    $box.height(48),
    $box.padding.horizontal.ref(mxt.space.medium),
    $flex.mainAxisAlignment.spaceBetween(),
    $flex.crossAxisAlignment.center(),
  );

  // 表单行 label
  static Style get formLabel => Style(
    $text.color.ref(mxt.color.onSurfaceVariant),
    $text.style.ref(mxt.textStyle.body),
  );

  // 表单行 value / placeholder
  static Style get formValue => Style(
    $text.color.ref(mxt.color.onSurface),
    $text.style.ref(mxt.textStyle.body),
  );

  static Style get formPlaceholder => Style(
    $text.color.ref(mxt.color.onSurfaceVariant),
    $text.style.ref(mxt.textStyle.body),
  );

  // 图片区域
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

  // 输入框
  static Style get inputField => Style(
    $box.height(48),
    $box.padding.horizontal.ref(mxt.space.medium),
    $box.borderRadius.all.ref(mxt.radius.small),
    $box.color.ref(mxt.color.surface),
  );

  // 提交按钮
  static Style get submitBtn => Style(
    $box.color(accent),
    $box.height(50),
    $box.alignment.center(),
    $box.borderRadius.all.ref(mxt.radius.small),
    $box.margin.all.ref(mxt.space.medium),
  );

  static Style get submitBtnText => Style(
    $text.color(const Color(0xFFFFFFFF)),
    $text.fontWeight.w700(),
    $text.style.ref(mxt.textStyle.body),
    $text.letterSpacing(0.5),
  );
}
