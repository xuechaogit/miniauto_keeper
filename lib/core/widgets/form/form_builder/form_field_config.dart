import 'package:flutter/material.dart';

enum FormFieldType { text, number, price, select, date, textarea, brand }

class FormFieldConfig {
  final FormFieldType type;
  final String key;
  final String label;
  final bool isRequired;
  final String? hint;
  final List<String>? pickOptions;
  final TextInputType? keyboardType;
  final dynamic extra;

  const FormFieldConfig({
    required this.type,
    required this.key,
    required this.label,
    this.isRequired = false,
    this.hint,
    this.pickOptions,
    this.keyboardType,
    this.extra,
  });
}
