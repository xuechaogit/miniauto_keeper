import 'package:mix/mix.dart';

import '../../theme/app_theme.dart';
import 'tag.style.dart';

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
    CustomTagShape.rounded($box.borderRadius(100)),
    CustomTagShape.square(
      $box.borderRadius(8), // 默认方角值
      // 嵌套判定：如果是 square 且是 small
      CustomTagSize.small($box.borderRadius(4)),
      // 嵌套判定：如果是 square 且是 large
      CustomTagSize.large($box.borderRadius(12)),
    ),
    CustomTagSize.small($box.padding(4, 8)),
    CustomTagSize.medium($box.padding(6, 12)),
    CustomTagSize.large($box.padding(8, 16)),
  ).applyVariants([type, size, shape]);

  Style label() => Style(
    CustomTagType.primary($text.color.ref(mxt.color.onPrimaryContainer)),
    CustomTagType.success($text.color.ref(mxt.color.onSuccessContainer)),
    CustomTagType.info($text.color.ref(mxt.color.onInfoContainer)),
    CustomTagType.warning($text.color.ref(mxt.color.onWarningContainer)),
    CustomTagType.error($text.color.ref(mxt.color.onErrorContainer)),
    CustomTagSize.small($text.fontSize(12)),
    CustomTagSize.medium($text.fontSize(14)),
    CustomTagSize.large($text.fontSize(16)),
  ).applyVariants([type, size, shape]);
}
