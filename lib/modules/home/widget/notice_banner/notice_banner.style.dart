import 'package:flutter/material.dart';
import 'package:miniauto_keeper/core/theme/app_theme.dart';
import 'package:miniauto_keeper/core/utils/screen_adapter.dart';
import 'package:mix/mix.dart';

class NoticeBannerStyle {
  static Style get container => Style();

  static Style get logo => Style($box.width(w(60)));

  static Style get divider =>
      Style($box.color(Colors.white30), $box.width(1), $box.height(20));

  static Style get titleBox => Style($box.alignment(Alignment.centerLeft));

  static Style get titleText => Style(
    $text.style.color.ref(mxt.color.onSurface),
    $text.style.ref(mxt.textStyle.body),
    $text.maxLines(1),
    $text.overflow.ellipsis(),
  );

  static Style get chevronIcon =>
      Style($icon.size(16), $icon.color(Colors.white60));
}
