import 'package:mix/mix.dart';

class SocialButtonTypeVariant extends Variant {
  const SocialButtonTypeVariant._(super.name);

  static const primary = SocialButtonTypeVariant._('social.button.primary');
  static const info = SocialButtonTypeVariant._('social.button.info');
  static const error = SocialButtonTypeVariant._('social.button.error');
  static const warning = SocialButtonTypeVariant._('social.button.warning');
  static const success = SocialButtonTypeVariant._('social.button.success');
}

class SocialButtonFillVariant extends Variant {
  const SocialButtonFillVariant._(super.name);

  static const fill = SocialButtonFillVariant._('social.button.fill');
  static const outline = SocialButtonFillVariant._('social.button.outline');
}

class SocialButtonSizeVariant extends Variant {
  const SocialButtonSizeVariant._(super.name);

  static const small = SocialButtonSizeVariant._('social.button.small');
  static const defaults = SocialButtonSizeVariant._('social.button.default');
  static const large = SocialButtonSizeVariant._('social.button.large');
}

class SocialButtonShapeVariant extends Variant {
  const SocialButtonShapeVariant._(super.name);

  static const sharp = SocialButtonShapeVariant._('social.button.sharp');
  static const rounded = SocialButtonShapeVariant._('social.button.rounded');
  static const pill = SocialButtonShapeVariant._('social.button.pill');
}
