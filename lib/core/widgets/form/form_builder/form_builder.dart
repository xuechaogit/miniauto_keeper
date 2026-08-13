import 'package:flutter/material.dart';
import 'package:flutter_filter_dialog/flutter_filter_dialog.dart';
import 'package:miniauto_keeper/core/utils/screen_adapter.dart';
import 'package:miniauto_keeper/core/widgets/form/form_picker_field/form_picker_field.dart';
import 'package:miniauto_keeper/core/widgets/form/form_picker_field/form_picker_field.variant.dart';
import 'package:miniauto_keeper/core/widgets/form/form_select_field/form_select_field.dart';
import 'package:miniauto_keeper/core/widgets/form/form_select_field/form_select_field.variant.dart';
import 'package:miniauto_keeper/core/widgets/form/form_text_field/form_text_field.dart';
import 'package:miniauto_keeper/core/widgets/form/form_number_field/form_number_field.dart';
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

  /// 校验所有表单：全部通过返回合并后的 values，任一失败返回 null。
  static Map<String, dynamic>? validateAndCollect(
    List<GlobalKey<FormBuilderState>> keys,
  ) {
    var allValid = true;
    final allValues = <String, dynamic>{};
    for (final key in keys) {
      final state = key.currentState;
      if (state == null) continue;
      if (!state.validate()) allValid = false;
      allValues.addAll(state.collectValues());
    }
    return allValid ? allValues : null;
  }
}

class FormBuilderState extends State<FormBuilder> {
  final _controllers = <String, TextEditingController>{};
  final _selectValues = <String, String>{};
  final _dateValues = <String, DateTime?>{};
  final _stepperValues = <String, num>{};
  final _errors = <String, String?>{};

  static final _textLikeTypes = {
    FormFieldType.text,
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
      if (f.type == FormFieldType.number) {
        _stepperValues[f.key] = f.stepperMin;
      }
    }

    if (widget.defaults != null) {
      for (final entry in widget.defaults!.entries) {
        final ctrl = _controllers[entry.key];
        if (ctrl != null) {
          ctrl.text = entry.value;
        }
        if (_stepperValues.containsKey(entry.key)) {
          _stepperValues[entry.key] = int.tryParse(entry.value) ?? 0;
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
      } else if (f.type == FormFieldType.number) {
        values[f.key] = _stepperValues[f.key]?.toString() ?? '';
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

  /// 校验所有字段，返回 true 表示全部通过
  bool validate() {
    _errors.clear();
    final values = collectValues();
    bool ok = true;

    for (final f in widget.fields) {
      final raw = values[f.key];
      final isEmpty = raw == null || (raw is String && raw.isEmpty);

      if (f.isRequired && isEmpty) {
        _errors[f.key] = '${f.label}不能为空';
        ok = false;
        continue;
      }

      if (f.validator != null && raw is String && raw.isNotEmpty) {
        final err = f.validator!(raw);
        if (err != null) {
          _errors[f.key] = err;
          ok = false;
        }
      }
    }

    setState(() {});
    return ok;
  }

  /// 校验单个字段，失焦 / 变更后即时反馈
  void _validateField(String key) {
    final f = widget.fields.firstWhere((f) => f.key == key);
    final raw = collectValues()[key] as String?;

    if (f.isRequired && (raw == null || raw.isEmpty)) {
      _errors[key] = '${f.label}不能为空';
    } else if (f.validator != null && raw != null && raw.isNotEmpty) {
      _errors[key] = f.validator!(raw);
    } else {
      _errors.remove(key);
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return VBox(
      // style: FormBuilderStyle.fieldGap,
      children: widget.fields.map(_buildField).toList(),
    );
  }

  Widget _buildField(FormFieldConfig f) {
    Widget child;
    if (widget.customBuilders?.containsKey(f.type) == true) {
      child = widget.customBuilders![f.type]!(context, f);
    } else {
      print('${f.type} not supported');
      switch (f.type) {
        case FormFieldType.text:
          child = _buildText(f);
          break;
        case FormFieldType.number:
          child = _buildNumber(f);
          break;
        case FormFieldType.price:
          child = _buildPrice(f);
          break;
        case FormFieldType.select:
          child = _buildSelect(f);
          break;
        case FormFieldType.date:
          child = _buildDate(f);
          break;
        case FormFieldType.textarea:
          child = _buildTextarea(f);
          break;
        case FormFieldType.brand:
          child = const SizedBox.shrink();
          break;
      }
    }

    return _wrapWithError(f, child);
  }

  Widget _wrapWithError(FormFieldConfig f, Widget child) {
    final error = _errors[f.key];
    return VBox(
      style: Style(
        $box.width(double.infinity),
        $flex.crossAxisAlignment.start(),
      ),
      children: [
        child,
        Box(
          style: Style($box.height(w(24))),
          child: StyledText(
            error ?? '',
            style: FormBuilderStyle.errorText(show: error != null),
          ),
        ),
      ],
    );
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
      onFocusLost: () => _validateField(f.key),
    );
  }

  Widget _buildNumber(FormFieldConfig f) {
    return FormNumberField(
      key: ValueKey(f.key),
      label: f.label,
      isRequired: f.isRequired,
      value: _stepperValues[f.key] ?? f.stepperMin,
      minVal: f.stepperMin,
      maxVal: f.stepperMax,
      steps: f.stepperStep,
      onChanged: (val) => _stepperValues[f.key] = val,
      onEditingComplete: () => _validateField(f.key),
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
      onFocusLost: () => _validateField(f.key),
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
      onChanged: (v) {
        setState(() => _selectValues[f.key] = v);
        _validateField(f.key);
      },
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
          _validateField(f.key);
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
      onFocusLost: () => _validateField(f.key),
    );
  }
}
