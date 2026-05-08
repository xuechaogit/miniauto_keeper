import 'package:mix/mix.dart';

class FilterChipType extends Variant {
  const FilterChipType(super.name);

  static const outlined = FilterChipType('filter_chip.outlined');
  static const underlined = FilterChipType('filter_chip.underlined');
}
