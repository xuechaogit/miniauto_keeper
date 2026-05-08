import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import '../../../../core/theme/app_theme.dart';

class LoginInputStyle {
  static Style get container => Style(
    $box.height(58),
    $box.padding.horizontal(16),
    $box.borderRadius(16),
    $box.border.color.ref(mxt.color.outline),
    $box.border.all(width: 1),
  );

  static Style get iconStyle => Style($icon.color.white30(), $icon.size(22));
}
