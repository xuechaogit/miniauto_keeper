import 'package:flutter/material.dart';
import 'package:flutter_filter_dialog/flutter_filter_dialog.dart';
import 'package:miniauto_keeper/core/theme/app_theme.dart';
import 'package:miniauto_keeper/core/widgets/form/form_picker_field/form_picker_field.dart';
import 'package:miniauto_keeper/core/widgets/form/form_picker_field/form_picker_field.variant.dart';
import 'package:miniauto_keeper/core/widgets/form/form_select_field/form_select_field.dart';
import 'package:miniauto_keeper/core/widgets/form/form_select_field/form_select_field.variant.dart';
import 'package:miniauto_keeper/core/widgets/form/form_text_field/form_text_field.dart';
import 'package:mix/mix.dart';

import 'form_builder.style.dart';
import 'form_field_config.dart';

class FormBuilder extends StatefulWidget {
  final List<FormFieldConfig> fields;
  final Map<String, dynamic Function()>? valueGetters;
  final Map<FormFieldType, Widget Function(BuildContext, FormFieldConfig)>?
      customBuilders;
  final Map<String, String>? defaults;

  const FormBuilder({
    super.key,
    required this.fields,
    this.valueGetters,
    this.customBuilders,
    this.defaults,
  });

  @override
  FormBuilderState createState() => FormBuilderState();
}

class FormBuilderState extends State<FormBuilder> {
  final _controllers = <String, TextEditingController>{};
  final _selectValues = <String, String>{};
  final _dateValues = <String, DateTime?>{};

  static final _textLikeTypes = {
    FormFieldType.text,
    FormFieldType.number,
    FormFieldType.price,
    FormFieldType.textarea,
  };

  @override
  void initState() {
    super.initState();
    for (final f in widget.fields) {
      if (_textLikeTypes.contains(f.type)) {
        _controllers[f.key] = TextEditingController();
      }
      if (f.type == FormFieldType.select) {
        _selectValues[f.key] = '';
      }
      if (f.type == FormFieldType.date) {
        _dateValues[f.key] = null;
      }
    }

    if (widget.defaults != null) {
      for (final entry in widget.defaults!.entries) {
        final ctrl = _controllers[entry.key];
        if (ctrl != null) {
          ctrl.text = entry.value;
        }
      }
    }
  }

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  Map<String, dynamic> collectValues() {
    final values = <String, dynamic>{};

    for (final f in widget.fields) {
      if (_textLikeTypes.contains(f.type)) {
        values[f.key] = _controllers[f.key]?.text ?? '';
      } else if (f.type == FormFieldType.select) {
        values[f.key] = _selectValues[f.key] ?? '';
      } else if (f.type == FormFieldType.date) {
        final d = _dateValues[f.key];
        if (d != null) {
          values[f.key] =
              '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
        }
      }
    }

    if (widget.valueGetters != null) {
      for (final entry in widget.valueGetters!.entries) {
        values[entry.key] = entry.value();
      }
    }

    return values;
  }

  @override
  Widget build(BuildContext context) {
    return VBox(
      style: FormBuilderStyle.fieldGap,
      children: widget.fields.map(_buildField).toList(),
    );
  }

  Widget _buildField(FormFieldConfig f) {
    if (widget.customBuilders?.containsKey(f.type) == true) {
      return widget.customBuilders![f.type]!(context, f);
    }

    switch (f.type) {
      case FormFieldType.text:
        return _buildText(f);
      case FormFieldType.number:
        return _buildNumber(f);
      case FormFieldType.price:
        return _buildPrice(f);
      case FormFieldType.select:
        return _buildSelect(f);
      case FormFieldType.date:
        return _buildDate(f);
      case FormFieldType.textarea:
        return _buildTextarea(f);
      case FormFieldType.brand:
        return const SizedBox.shrink();
    }
  }

  Widget _buildText(FormFieldConfig f) {
    return FormTextField(
      key: ValueKey(f.key),
      label: f.label,
      isRequired: f.isRequired,
      controller: _controllers[f.key]!,
      hint: f.hint,
      keyboardType: f.keyboardType,
      variant: FormTextFieldVariant.outlined,
    );
  }

  Widget _buildNumber(FormFieldConfig f) {
    return FormTextField(
      key: ValueKey(f.key),
      label: f.label,
      isRequired: f.isRequired,
      controller: _controllers[f.key]!,
      hint: f.hint,
      keyboardType: TextInputType.number,
      variant: FormTextFieldVariant.outlined,
    );
  }

  Widget _buildPrice(FormFieldConfig f) {
    return FormTextField(
      key: ValueKey(f.key),
      label: f.label,
      isRequired: f.isRequired,
      controller: _controllers[f.key]!,
      hint: f.hint,
      keyboardType: TextInputType.number,
      prefixText: '\$',
      variant: FormTextFieldVariant.outlined,
    );
  }

  Widget _buildSelect(FormFieldConfig f) {
    final choices = (f.pickOptions ?? <String>[])
        .map((o) => S2Choice<String>(value: o, title: o))
        .toList();

    return FormSelectField(
      key: ValueKey(f.key),
      label: f.label,
      isRequired: f.isRequired,
      current: _selectValues[f.key] ?? '',
      hint: f.hint ?? '请选择',
      choices: choices,
      onChanged: (v) => setState(() => _selectValues[f.key] = v),
      variant: FormSelectFieldVariant.outlined,
    );
  }

  Widget _buildDate(FormFieldConfig f) {
    final selected = _dateValues[f.key];
    return FormPickerField(
      key: ValueKey(f.key),
      label: f.label,
      isRequired: f.isRequired,
      variant: FormPickerFieldVariant.outlined,
      displayText: selected != null
          ? '${selected.year}-${selected.month.toString().padLeft(2, '0')}-${selected.day.toString().padLeft(2, '0')}'
          : null,
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: selected ?? DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        );
        if (picked != null) {
          setState(() => _dateValues[f.key] = picked);
        }
      },
    );
  }

  Widget _buildTextarea(FormFieldConfig f) {
    return FormTextField(
      key: ValueKey(f.key),
      label: f.label,
      isRequired: f.isRequired,
      controller: _controllers[f.key]!,
      hint: f.hint,
      variant: FormTextFieldVariant.outlined,
      maxLines: 4,
    );
  }
}
