import 'package:flutter/material.dart';
import 'package:miniauto_keeper/core/theme/app_theme.dart';
import 'package:miniauto_keeper/core/utils/screen_adapter.dart';
import 'package:mix/mix.dart';

class HotProductStyle {
  static Style get bgContainer => Style(
    $box.width(double.infinity),
    $with.aspectRatio(1),
    $with.clipRect(),
  );

  static Style get bgImage => Style(
    $image.fit(BoxFit.cover),
    $image.alignment(Alignment.center),
    $with.scale(1.5),
  );

  static Style get infoCard =>
      Style($box.color.ref(mxt.color.surface), $box.width(double.infinity));

  static Style get infoArea => Style(
    $box.padding.all.ref(mxt.space.medium),
    $flex.gap.ref(mxt.space.small),
  );

  static Style get title => Style(
    $text.color.ref(mxt.color.onSurface),
    $text.style.ref(mxt.textStyle.headline3),
    $text.maxLines(1),
    $text.overflow(TextOverflow.ellipsis),
  );

  static Style get brandName => Style(
    $text.color.ref(mxt.color.onSurfaceVariant),
    $text.style.ref(mxt.textStyle.caption),
  );

  static Style get divider =>
      Style($box.height(1), $box.color.ref(mxt.color.outlineVariant));

  static Style get price => Style(
    $text.color.ref(mxt.color.primary),
    $text.style.ref(mxt.textStyle.headline3),
  );

  static Style get arrowButton => Style();

  static Style get arrowIcon =>
      Style($icon.color(Colors.white), $icon.size(sp(24)));
}
