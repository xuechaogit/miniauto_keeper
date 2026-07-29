import 'package:flutter/material.dart';
import 'package:miniauto_keeper/core/theme/app_theme.dart';
import 'package:miniauto_keeper/core/utils/screen_adapter.dart';
import 'package:mix/mix.dart';

class CarouselStyle {
  static Style get container => Style($box.height(w(390)));

  static Style get overlay => Style($box.height(h(80)));

  static Style get title => Style(
    $text.style.ref(mxt.textStyle.headline3),
    $text.color(Colors.white),
    $text.fontWeight.bold(),
    $text.maxLines(2),
    $text.overflow.ellipsis(),
  );

  static Style get titleWrapper => Style($box.height(sp(40)));

  static Style get priceLabel => Style(
    $text.style.ref(mxt.textStyle.body),
    $text.color.ref(mxt.color.surfaceVariant),
    $text.fontWeight.bold(),
    $text.textAlign.start(),
  );
  static Style get price => Style(
    $text.style.ref(mxt.textStyle.body),
    $text.color.ref(mxt.color.primary),
    $text.fontWeight.bold(),
    $text.textAlign.start(),
  );

  static Style get indicatorActive => Style(
    $box.width(w(16)),
    $box.height(h(4)),
    $box.margin.right(w(4)),
    $box.borderRadius.circular(h(2)),
    $box.color.ref(mxt.color.primary),
  );

  static Style get indicatorInactive => Style(
    $box.width(w(6)),
    $box.height(h(4)),
    $box.margin.right(w(4)),
    $box.borderRadius.circular(h(2)),
    $box.color(Color(0x4DFFFFFF)),
  );
}
