import 'package:mix/mix.dart';

class FormPickerFieldVariant extends Variant {
  const FormPickerFieldVariant._(super.name);

  static const outlined = FormPickerFieldVariant._('picker.outlined');
  static const underline = FormPickerFieldVariant._('picker.underline');
}
