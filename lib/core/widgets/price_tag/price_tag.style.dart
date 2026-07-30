import 'dart:ui';

import 'package:miniauto_keeper/core/theme/app_theme.dart';
import 'package:miniauto_keeper/core/utils/screen_adapter.dart';
import 'package:mix/mix.dart';

class PriceTagStyle {
  static const accent = Color(0xFFE54335);

  // 货币符号 (较小)
  static Style get currency => Style(
    $text.color(accent),
    $text.fontSize(sp(10)),
    $text.fontWeight.w700(),
  );

  // 价格数值 (较大)
  static Style get price => Style(
    $text.color(accent),
    $text.style.ref(mxt.textStyle.headline3),
    $text.fontWeight.w700(),
  );

  // 原价划线
  static Style get originalPrice => Style(
    $text.color.ref(mxt.color.onSurfaceVariant),
    $text.style.ref(mxt.textStyle.caption),
    $text.decoration(TextDecoration.lineThrough),
  );
}
