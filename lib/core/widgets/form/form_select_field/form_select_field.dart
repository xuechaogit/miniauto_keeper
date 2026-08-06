import 'package:flutter/material.dart';
import 'package:flutter_filter_dialog/flutter_filter_dialog.dart';
import 'package:miniauto_keeper/core/theme/app_theme.dart';
import 'package:miniauto_keeper/core/utils/screen_adapter.dart';
import 'package:mix/mix.dart';

import 'package:miniauto_keeper/core/widgets/form/form_field_label/form_field_label.dart';
import 'form_select_field.style.dart';
import 'form_select_field.variant.dart';

class FormSelectField extends StatelessWidget {
  final String label;
  final String current;
  final String hint;
  final bool isRequired;
  final List<S2Choice<String>> choices;
  final ValueChanged<String> onChanged;
  final FormSelectFieldVariant variant;

  const FormSelectField({
    super.key,
    required this.label,
    required this.current,
    required this.hint,
    required this.choices,
    required this.onChanged,
    this.isRequired = false,
    this.variant = FormSelectFieldVariant.underline,
  });

  @override
  Widget build(BuildContext context) {
    final hasValue = current.isNotEmpty;
    return VBox(
      children: [
        FormFieldLabel(text: label, isRequired: isRequired),
        SmartSelect<String>.single(
          title: label,
          selectedValue: hasValue ? current : hint,
          choiceItems: choices,
          modalType: S2ModalType.bottomSheet,
          choiceType: S2ChoiceType.radios,
          onChange: (selected) => onChanged(selected.value ?? ''),
          tileBuilder: (ctx, state) {
            return GestureDetector(
              onTap: state.showModal,
              child: Box(
                style: FormSelectFieldStyle(variant: variant).formValueBox,
                child: HBox(
                  style: Style($flex.crossAxisAlignment.center()),
                  children: [
                    StyledText(
                      hasValue ? current : hint,
                      style: hasValue
                          ? FormSelectFieldStyle.formValue
                          : FormSelectFieldStyle.formPlaceholder(context),
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
            );
          },
        ),
      ],
    );
  }
}
