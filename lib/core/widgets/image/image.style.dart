import 'dart:ui';

import 'package:miniauto_keeper/core/utils/screen_adapter.dart';
import 'package:mix/mix.dart';

import 'image.variant.dart';

class CustomImageStyle {
  final CustomImageShape shape;
  final double? customRadius;

  const CustomImageStyle({
    this.shape = CustomImageShape.rounded,

    this.customRadius,
  });

  Style container() {
    final shapeStyle = customRadius != null
        ? Style($box.borderRadius(customRadius!))
        : Style(
            CustomImageShape.rounded($box.borderRadius(r(8))),
            CustomImageShape.square($box.borderRadius(0)),
            CustomImageShape.circle($box.borderRadius(r(100))),
          ).applyVariants([shape]);
    return Style.combine([
      shapeStyle,
      Style($box.clipBehavior(Clip.antiAlias)),
    ]);
  }
}
