import 'package:flutter/material.dart';
import 'package:miniauto_keeper/core/theme/app_theme.dart';
import 'package:miniauto_keeper/core/utils/screen_adapter.dart';
import 'package:mix/mix.dart';

class FormBuilderStyle {
  static final fieldGap = Style($flex.gap.ref(mxt.space.medium));

  static Style errorText({required bool show}) =>
      Style(
        $text.textAlign.start(),
        $text.style.color.ref(mxt.color.error),
        $text.style.ref(mxt.textStyle.caption),
        $with.opacity(show ? 1.0 : 0.0),
      ).animate(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
      );
}
