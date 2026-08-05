import 'package:flutter/material.dart';
import 'package:mix/mix.dart';
import '../../style.dart';
import '../form_field_label/form_field_label.dart';

class FormBrandField extends StatelessWidget {
  final String label;
  final String? displayText;
  final VoidCallback onTap;

  const FormBrandField({
    super.key,
    required this.label,
    required this.displayText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasValue = displayText != null;
    return VBox(
      style: ReportMissingStyle.formField,
      children: [
        FormFieldLabel(text: label),
        PressableBox(
          onPress: onTap,
          child: Box(
            style: ReportMissingStyle.formValueBox,
            child: HBox(
              style: Style($flex.crossAxisAlignment.center()),
              children: [
                StyledText(
                  displayText ?? '请选择',
                  style: hasValue ? ReportMissingStyle.formValue : ReportMissingStyle.formPlaceholder,
                ),
                const Spacer(),
                const Icon(Icons.chevron_right, size: 20, color: Color(0xFF5F6470)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
