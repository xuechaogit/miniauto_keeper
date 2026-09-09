import 'package:mix/mix.dart';

import '../../theme/app_theme.dart';
import 'tag.variant.dart';

class CustomTagStyle {
  const CustomTagStyle({
    this.type = CustomTagType.primary,
    this.size = CustomTagSize.medium,
    this.shape = CustomTagShape.rounded,
  });

  final CustomTagType type;
  final CustomTagSize size;
  final CustomTagShape shape;

  Style container() => Style(
    CustomTagType.primary($box.color.ref(mxt.color.primaryContainer)),
    CustomTagType.success($box.color.ref(mxt.color.successContainer)),
    CustomTagType.info($box.color.ref(mxt.color.infoContainer)),
    CustomTagType.warning($box.color.ref(mxt.color.warningContainer)),
    CustomTagType.error($box.color.ref(mxt.color.errorContainer)),
    // 圆角走 radius token：capsule 用 large(999)，方形用 small(4)，square+large 用 medium(12)
    CustomTagShape.rounded($box.borderRadius.all.ref(mxt.radius.large)),
    CustomTagShape.square(
      $box.borderRadius.all.ref(mxt.radius.small),
      CustomTagSize.large($box.borderRadius.all.ref(mxt.radius.medium)),
    ),
    // padding 走 space token：垂直:水平 ≈ 1:2
    CustomTagSize.small(
      $box.padding.vertical.ref(mxt.space.xs),
      $box.padding.horizontal.ref(mxt.space.small),
    ),
    CustomTagSize.medium(
      $box.padding.vertical.ref(mxt.space.tiny),
      $box.padding.horizontal.ref(mxt.space.medium),
    ),
    CustomTagSize.large(
      $box.padding.vertical.ref(mxt.space.small),
      $box.padding.horizontal.ref(mxt.space.large),
    ),
  ).applyVariants([type, size, shape]);

  Style label() => Style(
    CustomTagType.primary($text.color.ref(mxt.color.onPrimaryContainer)),
    CustomTagType.success($text.color.ref(mxt.color.onSuccessContainer)),
    CustomTagType.info($text.color.ref(mxt.color.onInfoContainer)),
    CustomTagType.warning($text.color.ref(mxt.color.onWarningContainer)),
    CustomTagType.error($text.color.ref(mxt.color.onErrorContainer)),
    CustomTagSize.small($text.style.ref(mxt.textStyle.caption)),
    CustomTagSize.medium($text.style.ref(mxt.textStyle.body)),
    CustomTagSize.large($text.style.ref(mxt.textStyle.subTitle)),
  ).applyVariants([type, size]);
}
