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

  // ── number 类型步进器参数 ──
  final num stepperMin;
  final num stepperMax;
  final num stepperStep;

  // ── 自定义校验 ──
  final String? Function(String? value)? validator;

  const FormFieldConfig({
    required this.type,
    required this.key,
    required this.label,
    this.isRequired = false,
    this.hint,
    this.pickOptions,
    this.keyboardType,
    this.extra,
    this.stepperMin = 0,
    this.stepperMax = 9999,
    this.stepperStep = 1,
    this.validator,
  });
}
