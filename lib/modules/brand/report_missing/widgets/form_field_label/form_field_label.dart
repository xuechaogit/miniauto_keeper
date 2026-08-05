import 'package:flutter/material.dart';
import 'package:miniauto_keeper/core/theme/app_theme.dart';
import 'package:mix/mix.dart';

import 'form_field_label.style.dart';

class FormFieldLabel extends StatelessWidget {
  final String text;

  const FormFieldLabel({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return HBox(
      style: Style(
        $box.width(double.infinity),
        $box.margin.bottom.ref(mxt.space.small),
      ),
      children: [StyledText(text, style: FormFieldLabelStyle.formLabel)],
    );
  }
}
