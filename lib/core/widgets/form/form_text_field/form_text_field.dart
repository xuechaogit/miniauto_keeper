import 'package:flutter/material.dart';
import 'package:miniauto_keeper/core/theme/app_theme.dart';
import 'package:miniauto_keeper/core/theme/app_theme_tool.dart';
import 'package:miniauto_keeper/core/utils/screen_adapter.dart';
import 'package:mix/mix.dart';
import 'package:miniauto_keeper/core/widgets/form/form_field_label/form_field_label.dart';
import 'form_text_field.style.dart';

enum FormTextFieldVariant { outlined, underline }

class FormTextField extends StatelessWidget {
  final String label;
  final TextEditingController? controller;
  final String? hint;
  final bool isRequired;
  final TextInputType? keyboardType;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final FormTextFieldVariant variant;
  final int? maxLines;
  final int? minLines;
  final String? prefixText;
  final String? suffixText;

  const FormTextField({
    super.key,
    required this.label,
    required this.controller,
    this.hint,
    this.isRequired = false,
    this.keyboardType,
    this.prefixIcon,
    this.suffixIcon,
    this.variant = FormTextFieldVariant.underline,
    this.maxLines,
    this.minLines,
    this.prefixText,
    this.suffixText,
  });

  @override
  Widget build(BuildContext context) {
    return VBox(
      children: [
        FormFieldLabel(text: label, isRequired: isRequired),
        Box(
          style: FormTextFieldStyle.inputField,
          child: TextField(
            style: TextStyle(
              fontSize: context.textStyle(mxt.textStyle.body).fontSize,
              color: context.color(mxt.color.onSurface),
            ),
            cursorColor: context.color(mxt.color.primary),
            showCursor: true,
            decoration: _buildDecoration(context),
            controller: controller,
            maxLines: maxLines,
            minLines: minLines,
            keyboardType: _isMultiline
                ? TextInputType.multiline
                : (keyboardType ?? TextInputType.text),
            textAlign: TextAlign.start,
            textAlignVertical: _isMultiline
                ? TextAlignVertical.top
                : TextAlignVertical.center,
          ),
        ),
      ],
    );
  }

  bool get _isMultiline => maxLines != null && maxLines! > 1;

  Widget _buildAffixText(BuildContext context, String text) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: w(4)),
      child: Text(
        text,
        style: TextStyle(
          fontSize: context.textStyle(mxt.textStyle.body).fontSize,
          color: context.color(mxt.color.onSurfaceVariant),
        ),
      ),
    );
  }

  InputDecoration _buildDecoration(BuildContext context) {
    final base = InputDecoration(
      hintText: hint ?? '请输入$label',
      hintStyle: TextStyle(
        color: context.color(mxt.color.onSurfaceVariant).withOpacity(0.5),
        fontSize: context.textStyle(mxt.textStyle.body).fontSize,
      ),
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      prefix: prefixText != null ? _buildAffixText(context, prefixText!) : null,
      suffix: suffixText != null ? _buildAffixText(context, suffixText!) : null,
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
              color: context.color(mxt.color.outlineVariant),
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
              color: context.color(mxt.color.outlineVariant),
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
