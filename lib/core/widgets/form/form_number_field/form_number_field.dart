import 'package:flutter/material.dart';
import 'package:input_quantity/input_quantity.dart';
import 'package:miniauto_keeper/core/theme/app_theme.dart';
import 'package:miniauto_keeper/core/theme/app_theme_tool.dart';
import 'package:miniauto_keeper/core/utils/screen_adapter.dart';
import 'package:mix/mix.dart';

import 'package:miniauto_keeper/core/widgets/form/form_field_label/form_field_label.dart';
import 'form_number_field.style.dart';

enum FormNumberFieldVariant { classic, btnOnLeft, btnOnRight }

class FormNumberField extends StatelessWidget {
  final String label;
  final bool isRequired;
  final num value;
  final num minVal;
  final num maxVal;
  final num steps;
  final ValueChanged<num>? onChanged;
  final VoidCallback? onEditingComplete;
  final FocusNode? focusNode;
  final FormNumberFieldVariant variant;

  const FormNumberField({
    super.key,
    required this.label,
    this.isRequired = false,
    this.value = 0,
    this.minVal = 0,
    this.maxVal = 9999,
    this.steps = 1,
    this.onChanged,
    this.onEditingComplete,
    this.focusNode,
    this.variant = FormNumberFieldVariant.classic,
  });

  @override
  Widget build(BuildContext context) {
    final node = focusNode ?? FocusNode();
    return Focus(
      focusNode: node,
      onFocusChange: (hasFocus) {
        if (!hasFocus) {
          onEditingComplete?.call();
        }
      },
      child: VBox(
      children: [
        FormFieldLabel(text: label, isRequired: isRequired),
        HBox(
          style: FormNumberFieldStyle.inputField,
          children: [
            InputQty.int(
              initVal: value.toInt(),
              minVal: minVal.toInt(),
              maxVal: maxVal.toInt(),
              steps: steps.toInt(),
              onQtyChanged: (val) {
                if (val is num) onChanged?.call(val);
              },
              qtyFormProps: QtyFormProps(
                textAlign: TextAlign.center,
                style: mxt.textStyle.body.resolve(context),
                cursorColor: context.color(mxt.color.primary),
                enableTyping: true,
              ),
              decoration: QtyDecorationProps(
                qtyStyle: _toQtyStyle(variant),
                width: 20,
                btnColor: mxt.color.primary.resolve(context),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: w(12),
                  vertical: h(12),
                ),

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(r(8)),
                  borderSide: BorderSide(
                    color: mxt.color.outlineVariant.resolve(context),
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: mxt.color.primary.resolve(context),
                    width: 2,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
    );
  }

  QtyStyle _toQtyStyle(FormNumberFieldVariant v) {
    switch (v) {
      case FormNumberFieldVariant.classic:
        return QtyStyle.classic;
      case FormNumberFieldVariant.btnOnLeft:
        return QtyStyle.btnOnLeft;
      case FormNumberFieldVariant.btnOnRight:
        return QtyStyle.btnOnRight;
    }
  }
}
