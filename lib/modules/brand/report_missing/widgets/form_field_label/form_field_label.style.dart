import 'dart:ui';

import 'package:miniauto_keeper/core/theme/app_theme.dart';
import 'package:mix/mix.dart';

class FormFieldLabelStyle {
  static const accent = Color(0xFF3B5EF5);

  static Style get formLabel => Style(
    $text.color.ref(mxt.color.onSurfaceVariant),
    $text.style.ref(mxt.textStyle.caption),
    $text.fontWeight.bold(),
    $box.margin.bottom.ref(mxt.space.small),
  );
}
