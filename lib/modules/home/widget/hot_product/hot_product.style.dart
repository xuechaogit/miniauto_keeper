import 'package:flutter/material.dart';
import 'package:miniauto_keeper/core/theme/app_theme.dart';
import 'package:mix/mix.dart';

class HotProductStyle {
  static Style get top1Card => Style(
    $box.color.ref(mxt.color.surface),
    $box.borderRadius.all.ref(mxt.radius.medium),
    $box.clipBehavior(Clip.antiAlias),
  );

  static Style get smallCard => Style(
    $box.color.ref(mxt.color.surface),
    $box.borderRadius.all.ref(mxt.radius.medium),
    $box.clipBehavior(Clip.antiAlias),
  );

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

  static Style get titleSmall => Style(
    $text.color.ref(mxt.color.onSurface),
    $text.style.ref(mxt.textStyle.body),
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
    $text.style.ref(mxt.textStyle.headline2),
  );

  static Style get priceSmall => Style(
    $text.color.ref(mxt.color.primary),
    $text.style.ref(mxt.textStyle.headline3),
  );

  static Style get hotBadge => Style(
    $box.color.ref(mxt.color.primaryContainer),
    $box.borderRadius(4),
    $box.padding.horizontal.ref(mxt.space.small),
    $box.padding.vertical(2),
  );

  static Style get hotBadgeText => Style(
    $text.color.ref(mxt.color.onPrimaryContainer),
    $text.style.ref(mxt.textStyle.caption),
    $text.fontWeight.bold(),
  );

  static Style get row => Style($flex.gap.ref(mxt.space.medium));

  static Style get rightColumn => Style($flex.gap.ref(mxt.space.small));

  static Style get smallImage => Style($box.width(72), $box.height(72));

  static Style get viewMore => Style(
    $flex.mainAxisAlignment.center(),
    $flex.crossAxisAlignment.center(),
    $flex.gap.ref(mxt.space.small),
  );

  static Style get viewMoreText => Style(
    $text.color.ref(mxt.color.onSurfaceVariant),
    $text.style.ref(mxt.textStyle.caption),
  );

  static Style get viewMoreIcon =>
      Style($icon.color.ref(mxt.color.onSurfaceVariant), $icon.size(14));
}
