import 'package:flutter/material.dart';
import 'package:miniauto_keeper/core/theme/app_theme.dart';
import 'package:miniauto_keeper/core/theme/app_theme_tool.dart';
import 'package:miniauto_keeper/core/utils/screen_adapter.dart';
import 'package:mix/mix.dart';
import '../form_field_label/form_field_label.dart';
import 'form_text_field.style.dart';

enum FormTextFieldVariant { outlined, underline }

class FormTextField extends StatelessWidget {
  final String label;
  final TextEditingController? controller;
  final String? hint;
  final TextInputType? keyboardType;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final FormTextFieldVariant variant;

  const FormTextField({
    super.key,
    required this.label,
    required this.controller,
    this.hint,
    this.keyboardType,
    this.prefixIcon,
    this.suffixIcon,
    this.variant = FormTextFieldVariant.outlined,
  });

  @override
  Widget build(BuildContext context) {
    return VBox(
      children: [
        FormFieldLabel(text: label),
        Box(
          style: FormTextFieldStyle.inputField,
          child: TextField(
            style: TextStyle(
              fontSize: context.textStyle(mxt.textStyle.caption).fontSize,
              color: context.color(mxt.color.onSurface),
            ),
            cursorColor: context.color(mxt.color.primary),
            showCursor: true,
            decoration: _buildDecoration(context),
            controller: controller,
            keyboardType: keyboardType ?? TextInputType.text,
            textAlign: TextAlign.start,
          ),
        ),
      ],
    );
  }

  InputDecoration _buildDecoration(BuildContext context) {
    final base = InputDecoration(
      hintText: hint ?? '请输入$label',
      hintStyle: TextStyle(
        color: context.color(mxt.color.onSurfaceVariant).withOpacity(0.5),
        fontSize: context.textStyle(mxt.textStyle.caption).fontSize,
      ),
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
    );

    switch (variant) {
      case FormTextFieldVariant.outlined:
        return base.copyWith(
          contentPadding: EdgeInsets.symmetric(
            horizontal: w(12),
            vertical: w(10),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(r(8)),
            borderSide: BorderSide(
              color: context.color(mxt.color.outline).withOpacity(0.5),
              width: 1.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(r(8)),
            borderSide: BorderSide(
              color: context.color(mxt.color.primary),
              width: 2.0,
            ),
          ),
        );

      case FormTextFieldVariant.underline:
        return base.copyWith(
          contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: w(10)),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: context.color(mxt.color.outline),
              width: 1.0,
            ),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: context.color(mxt.color.primary),
              width: 2.0,
            ),
          ),
        );
    }
  }
}
