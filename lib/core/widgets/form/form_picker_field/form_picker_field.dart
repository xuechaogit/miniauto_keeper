import 'package:flutter/material.dart';
import 'package:miniauto_keeper/core/theme/app_theme.dart';
import 'package:miniauto_keeper/core/utils/screen_adapter.dart';
import 'package:mix/mix.dart';
import 'package:miniauto_keeper/core/widgets/form/form_field_label/form_field_label.dart';
import 'form_picker_field.style.dart';
import 'form_picker_field.variant.dart';

class FormPickerField extends StatelessWidget {
  final String label;
  final String? displayText;
  final VoidCallback onTap;
  final FormPickerFieldVariant variant;
  final bool isRequired;

  const FormPickerField({
    super.key,
    required this.label,
    required this.onTap,
    this.displayText,
    this.variant = FormPickerFieldVariant.underline,
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    final hasValue = displayText != null;
    final style = FormPickerFieldStyle(variant: variant);
    return VBox(
      style: FormPickerFieldStyle.formField,
      children: [
        FormFieldLabel(text: label, isRequired: isRequired),
        PressableBox(
          onPress: onTap,
          child: Box(
            style: style.formValueBox,
            child: HBox(
              style: Style($flex.crossAxisAlignment.center()),
              children: [
                StyledText(
                  displayText ?? '请选择',
                  style: hasValue
                      ? FormPickerFieldStyle.formValue
                      : FormPickerFieldStyle.formPlaceholder(context),
                ),
                const Spacer(),
                StyledIcon(
                  Icons.chevron_right,
                  style: Style(
                    $icon.color.ref(mxt.color.onSurfaceVariant),
                    $icon.size(sp(20)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
