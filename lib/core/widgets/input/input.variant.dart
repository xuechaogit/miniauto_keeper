import 'package:mix/mix.dart';

class CustomInputShape extends Variant {
  const CustomInputShape._(super.name);

  static const CustomInputShape rounded = CustomInputShape._(
    'custom.input.rounded',
  );
  static const CustomInputShape square = CustomInputShape._(
    'custom.input.square',
  );
}
