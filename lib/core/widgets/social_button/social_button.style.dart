import 'package:flutter/material.dart';
import 'package:miniauto_keeper/core/utils/screen_adapter.dart';
import 'package:mix/mix.dart';

import '../../theme/app_theme.dart';

class SocialButtonStyle {
  static Style get main => Style(
    $box.height(h(46)),
    $box.borderRadius(r(8)),
    $box.color.white.withOpacity(0.04),
    $box.border.color.ref(mxt.color.outline),
    $box.border.all(width: 1),
    $box.alignment.center(),
    $on.press(
      $box.color.white.withOpacity(0.08),
      $box.transform(Matrix4.diagonal3Values(0.99, 0.99, 1.0)),
    ),
  );

  static Style get iconStyle => Style($icon.size(26));

  static Style get labelStyle =>
      Style($text.style.fontWeight.w600(), $text.style.fontSize(14));
}
