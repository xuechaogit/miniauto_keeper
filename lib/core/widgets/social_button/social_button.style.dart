import 'package:flutter/material.dart';
import 'package:miniauto_keeper/core/utils/screen_adapter.dart';
import 'package:mix/mix.dart';

import '../../theme/app_theme.dart';

import 'social_button.variant.dart';

class SocialButtonStyle {
  const SocialButtonStyle({
    this.type = SocialButtonTypeVariant.primary,
    this.fill = SocialButtonFillVariant.fill,
    this.size = SocialButtonSizeVariant.defaults,
    this.shape = SocialButtonShapeVariant.rounded,
  });
  final SocialButtonTypeVariant type;
  final SocialButtonFillVariant fill;
  final SocialButtonSizeVariant size;
  final SocialButtonShapeVariant shape;

  Style get main => Style(
    // -- shape --
    SocialButtonShapeVariant.sharp($box.borderRadius.all(r(0))),
    SocialButtonShapeVariant.rounded(
      $box.borderRadius.all.ref(mxt.radius.small),
    ),
    SocialButtonShapeVariant.pill($box.borderRadius.all(r(999))),

    // -- size --
    SocialButtonSizeVariant.small(
      $box.height(h(36)),
      $box.padding.horizontal(h(16)),
    ),
    SocialButtonSizeVariant.defaults(
      $box.height(h(46)),
      $box.padding.horizontal(h(24)),
    ),
    SocialButtonSizeVariant.large(
      $box.height(h(56)),
      $box.padding.horizontal(h(32)),
    ),

    // -- fill mode --
    SocialButtonFillVariant.fill(
      SocialButtonTypeVariant.info(
        $text.color.ref(mxt.color.onSurface),
        $icon.color.ref(mxt.color.onSurfaceVariant),
      ),
      $text.color(Colors.white),
      $icon.color(Colors.white),
    ),

    // -- outline mode --
    SocialButtonFillVariant.outline(
      $box.border.all(width: 1),
      $box.color(Colors.transparent),
      SocialButtonTypeVariant.primary(
        $box.border.color.ref(mxt.color.primary),
        $text.color.ref(mxt.color.primary),
        $icon.color.ref(mxt.color.primary),
      ),
      SocialButtonTypeVariant.info(
        $box.border.color.ref(mxt.color.info),
        $text.color.ref(mxt.color.info),
        $icon.color.ref(mxt.color.info),
      ),
      SocialButtonTypeVariant.success(
        $box.border.color.ref(mxt.color.success),
        $text.color.ref(mxt.color.success),
        $icon.color.ref(mxt.color.success),
      ),
      SocialButtonTypeVariant.warning(
        $box.border.color.ref(mxt.color.warning),
        $text.color.ref(mxt.color.warning),
        $icon.color.ref(mxt.color.warning),
      ),
      SocialButtonTypeVariant.error(
        $box.border.color.ref(mxt.color.error),
        $text.color.ref(mxt.color.error),
        $icon.color.ref(mxt.color.error),
      ),
    ),
  ).applyVariants([size, type, fill, shape]);

  Color containerColor(BuildContext context) {
    if (fill == SocialButtonFillVariant.outline) {
      return Colors.transparent;
    }
    return _typeColor(context);
  }

  Color hoverColor(BuildContext context) {
    return _typeColor(context).withOpacity(0.08);
  }

  Color loaderColor(BuildContext context) {
    if (fill == SocialButtonFillVariant.outline) {
      return _typeColor(context);
    }
    return Colors.white;
  }

  Color _typeColor(BuildContext context) {
    switch (type) {
      case SocialButtonTypeVariant.primary:
        return mxt.color.primary.resolve(context);
      case SocialButtonTypeVariant.info:
        return mxt.color.info.resolve(context);
      case SocialButtonTypeVariant.success:
        return mxt.color.success.resolve(context);
      case SocialButtonTypeVariant.warning:
        return mxt.color.warning.resolve(context);
      case SocialButtonTypeVariant.error:
        return mxt.color.error.resolve(context);
      default:
        return mxt.color.primary.resolve(context);
    }
  }

  BorderRadius borderRadius() {
    switch (shape) {
      case SocialButtonShapeVariant.sharp:
        return BorderRadius.zero;
      case SocialButtonShapeVariant.rounded:
        return BorderRadius.circular(r(8));
      case SocialButtonShapeVariant.pill:
        return BorderRadius.circular(r(999));
      default:
        return BorderRadius.circular(r(8));
    }
  }

  double get loaderSize {
    switch (size) {
      case SocialButtonSizeVariant.small:
        return r(16);
      case SocialButtonSizeVariant.defaults:
        return r(22);
      case SocialButtonSizeVariant.large:
        return r(28);
      default:
        return r(22);
    }
  }

  Style get iconStyle {
    switch (size) {
      case SocialButtonSizeVariant.small:
        return Style($icon.size(sp(16)));
      case SocialButtonSizeVariant.defaults:
        return Style($icon.size(sp(22)));
      case SocialButtonSizeVariant.large:
        return Style($icon.size(sp(28)));
      default:
        return Style($icon.size(sp(22)));
    }
  }

  Style get labelStyle {
    switch (size) {
      case SocialButtonSizeVariant.small:
        return Style(
          $text.style.fontWeight.bold(),
          $text.style.ref(mxt.textStyle.caption),
        );
      case SocialButtonSizeVariant.defaults:
        return Style(
          $text.style.fontWeight.bold(),
          $text.style.ref(mxt.textStyle.body),
        );
      case SocialButtonSizeVariant.large:
        return Style(
          $text.style.fontWeight.bold(),
          $text.style.ref(mxt.textStyle.headline3),
        );
      default:
        return Style(
          $text.style.fontWeight.bold(),
          $text.style.ref(mxt.textStyle.body),
        );
    }
  }
}
