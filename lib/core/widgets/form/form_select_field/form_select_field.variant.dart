import 'package:mix/mix.dart';

class FormSelectFieldVariant extends Variant {
  const FormSelectFieldVariant._(super.name);

  static const outlined = FormSelectFieldVariant._('select.outlined');
  static const underline = FormSelectFieldVariant._('select.underline');
}
