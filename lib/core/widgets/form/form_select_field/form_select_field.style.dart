import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:miniauto_keeper/core/theme/app_theme.dart';
import 'package:miniauto_keeper/core/utils/screen_adapter.dart';
import 'package:mix/mix.dart';

import 'form_select_field.variant.dart';

class FormSelectFieldStyle {
  const FormSelectFieldStyle({this.variant = FormSelectFieldVariant.outlined});
  final FormSelectFieldVariant variant;

  static const accent = Color(0xFF3B5EF5);

  // ── 表单字段（垂直布局：label 上，value 下） ──

  static Style get formField =>
      Style($box.padding.vertical.ref(mxt.space.small));

  Style get formValueBox => Style(
    $box.padding.horizontal(w(12)),
    $box.padding.vertical(w(10)),

    $flex.mainAxisAlignment.spaceBetween(),
    $flex.crossAxisAlignment.center(),

    // --- outlined variant (default) ---
    FormSelectFieldVariant.outlined(
      $box.borderRadius.all(r(8)),
      $box.border.color.ref(mxt.color.outlineVariant),
      $box.border.width(1),
    ),
    // --- underline variant ---
    FormSelectFieldVariant.underline(
      $box.borderRadius(0),
      $box.border.bottom.color.ref(mxt.color.outlineVariant),
      $box.border.bottom.width(1),
      $box.padding.horizontal(0),
    ),
  ).applyVariants([variant]);

  // ── 表单值文本 ──
  static Style get formValue => Style(
    $text.color.ref(mxt.color.onSurface),
    $text.style.ref(mxt.textStyle.body),
  );

  static Style formPlaceholder(BuildContext context) => Style(
    $text.color(mxt.color.onSurfaceVariant.resolve(context).withOpacity(0.5)),
    $text.style.ref(mxt.textStyle.body),
  );
}
