import 'package:mix/mix.dart';

class CustomImageShape extends Variant {
  const CustomImageShape._(super.name);

  static const CustomImageShape rounded =
      CustomImageShape._('custom.image.rounded');
  static const CustomImageShape square =
      CustomImageShape._('custom.image.square');
  static const CustomImageShape circle =
      CustomImageShape._('custom.image.circle');
}
