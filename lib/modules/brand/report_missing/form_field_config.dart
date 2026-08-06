import 'package:flutter/material.dart';

enum FieldType { text, select, brand }

enum BrandFieldKind { model, car }

class FormSection {
  final String title;
  final List<FormFieldConfig> fields;

  const FormSection({required this.title, required this.fields});
}

class FormFieldConfig {
  final FieldType type;
  final String key;
  final bool isRequired;
  final String label;
  final String? hint;
  final List<String>? pickOptions;
  final TextInputType? keyboardType;
  final BrandFieldKind? brandKind;

  const FormFieldConfig({
    required this.type,
    required this.key,
    required this.label,
    this.isRequired = false,
    this.hint,
    this.pickOptions,
    this.keyboardType,
    this.brandKind,
  });
}
