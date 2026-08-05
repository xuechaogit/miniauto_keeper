import 'dart:ui';

import 'package:miniauto_keeper/core/theme/app_theme.dart';
import 'package:miniauto_keeper/core/utils/screen_adapter.dart';
import 'package:mix/mix.dart';

class FormSelectFieldStyle {
  static const accent = Color(0xFF3B5EF5);

  // ── 表单字段（垂直布局：label 上，value 下） ──

  static Style get formField =>
      Style($box.padding.vertical.ref(mxt.space.small));

  static Style get formValueBox => Style(
    $box.borderRadius.all(r(8)),

    $box.border.color.ref(mxt.color.outlineVariant),
    $box.border.width(1),

    $box.padding.horizontal(w(12)),
    $box.padding.vertical(w(10)),

    $flex.mainAxisAlignment.spaceBetween(),
    $flex.crossAxisAlignment.center(),
  );

  // ── 表单值文本 ──
  static Style get formValue => Style(
    $text.color.ref(mxt.color.onSurface),
    $text.style.ref(mxt.textStyle.caption),
  );

  static Style get formPlaceholder => Style(
    $text.color.ref(mxt.color.onSurfaceVariant),
    $text.style.ref(mxt.textStyle.caption),
  );
}
