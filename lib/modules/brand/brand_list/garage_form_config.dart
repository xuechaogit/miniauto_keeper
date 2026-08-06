enum GarageFieldType { text, number, select, date, textarea, price }

class GarageFormFieldConfig {
  final GarageFieldType type;
  final String key;
  final String label;
  final bool isRequired;
  final String? hint;
  final List<String>? pickOptions;
  final String? prefixText;
  final String? suffixText;

  const GarageFormFieldConfig({
    required this.type,
    required this.key,
    required this.label,
    this.isRequired = false,
    this.hint,
    this.pickOptions,
    this.prefixText,
    this.suffixText,
  });
}
