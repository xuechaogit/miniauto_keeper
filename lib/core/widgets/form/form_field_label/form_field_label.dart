import 'package:flutter/material.dart';
import 'package:miniauto_keeper/core/theme/app_theme.dart';
import 'package:miniauto_keeper/core/utils/screen_adapter.dart';
import 'package:mix/mix.dart';

import 'form_field_label.style.dart';

class FormFieldLabel extends StatelessWidget {
  final String text;
  final bool isRequired;

  const FormFieldLabel({
    super.key,
    required this.text,
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    return HBox(
      style: Style(
        $box.width(double.infinity),
        $box.margin.bottom.ref(mxt.space.small),
        $flex.crossAxisAlignment.center(),
      ),
      children: [
        if (isRequired)
          Box(
            style: Style(
              $box.margin.right(w(4)),
              $flex.crossAxisAlignment.center(),
            ),
            child: StyledText(
              '*',
              style: FormFieldLabelStyle.formLabelRequired,
            ),
          ),
        StyledText(text, style: FormFieldLabelStyle.formLabel),
      ],
    );
  }
}
