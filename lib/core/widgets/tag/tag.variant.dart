import 'package:mix/mix.dart';

class CustomTagType extends Variant {
  const CustomTagType._(super.name);

  static const CustomTagType primary = CustomTagType._('custom.tag.primary');
  static const CustomTagType success = CustomTagType._('custom.tag.success');
  static const CustomTagType info = CustomTagType._('custom.tag.info');
  static const CustomTagType warning = CustomTagType._('custom.tag.warning');
  static const CustomTagType error = CustomTagType._('custom.tag.error');
}

class CustomTagSize extends Variant {
  const CustomTagSize._(super.name);

  static const CustomTagSize small = CustomTagSize._('custom.tag.small');
  static const CustomTagSize medium = CustomTagSize._('custom.tag.medium');
  static const CustomTagSize large = CustomTagSize._('custom.tag.large');
}

class CustomTagShape extends Variant {
  const CustomTagShape._(super.name);

  static const CustomTagShape rounded = CustomTagShape._('custom.tag.rounded');
  static const CustomTagShape square = CustomTagShape._('custom.tag.square');
}
