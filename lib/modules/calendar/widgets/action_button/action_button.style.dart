import 'package:flutter/material.dart';
import 'package:mix/mix.dart';
import '../../../../core/theme/app_theme.dart';

class ActionButtonStyle {
  static Style get layout => Style(
    $box.borderRadius(100),
    $box.border.color.ref(mxt.color.outlineVariant),
  );

  static Style get icon => Style($icon.size(20));
}
