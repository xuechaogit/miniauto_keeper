import 'package:flutter/material.dart';
import 'package:flutter_filter_dialog/flutter_filter_dialog.dart';
import 'package:miniauto_keeper/core/theme/app_theme.dart';
import 'package:miniauto_keeper/core/theme/app_theme_tool.dart';
import 'package:miniauto_keeper/core/utils/screen_adapter.dart';
import 'package:miniauto_keeper/core/widgets/form/form_picker_field/form_picker_field.dart';
import 'package:miniauto_keeper/core/widgets/form/form_picker_field/form_picker_field.variant.dart';
import 'package:miniauto_keeper/core/widgets/form/form_select_field/form_select_field.dart';
import 'package:miniauto_keeper/core/widgets/form/form_select_field/form_select_field.variant.dart';
import 'package:miniauto_keeper/core/widgets/form/form_text_field/form_text_field.dart';
import 'package:miniauto_keeper/core/widgets/social_button/social_button.dart';
import 'package:miniauto_keeper/core/widgets/social_button/social_button.variant.dart';
import 'package:miniauto_keeper/modules/brand/brand_list/garage_form_config.dart';
import 'package:mix/mix.dart';

import 'add_garage_sheet.style.dart';

class AddGarageSheet extends StatefulWidget {
  final String productName;
  final void Function(Map<String, dynamic> values) onSubmit;

  const AddGarageSheet({
    super.key,
    required this.productName,
    required this.onSubmit,
  });

  @override
  State<AddGarageSheet> createState() => _AddGarageSheetState();
}

class _AddGarageSheetState extends State<AddGarageSheet> {
  final _controllers = <String, TextEditingController>{};
  final _values = <String, dynamic>{};
  DateTime? _selectedDate;

  static const _channelOptions = ['线上商城', '线下门店', '二手平台', '海外代购', '私人收藏', '其他'];

  static const _limitedOptions = [
    '不限量',
    '限量500台',
    '限量1000台',
    '限量3000台',
    '限量5000台',
    '其他限量',
  ];

  static final _fields = [
    const GarageFormFieldConfig(
      type: GarageFieldType.number,
      key: 'quantity',
      label: '数量',
      hint: '请输入数量',
    ),
    const GarageFormFieldConfig(
      type: GarageFieldType.price,
      key: 'price',
      label: '单价',
      hint: '请输入单价',
    ),
    const GarageFormFieldConfig(
      type: GarageFieldType.text,
      key: 'nickname',
      label: '爱车昵称',
      hint: '为你的爱车取个名字',
    ),
    const GarageFormFieldConfig(
      type: GarageFieldType.date,
      key: 'purchaseDate',
      label: '购买时间',
      hint: '选择购买日期',
    ),
    const GarageFormFieldConfig(
      type: GarageFieldType.select,
      key: 'channel',
      label: '购买渠道',
      pickOptions: _channelOptions,
    ),
    const GarageFormFieldConfig(
      type: GarageFieldType.select,
      key: 'limitedInfo',
      label: '限量信息',
      pickOptions: _limitedOptions,
    ),
    const GarageFormFieldConfig(
      type: GarageFieldType.textarea,
      key: 'notes',
      label: '入手心得',
      hint: '分享你的入手体验',
    ),
  ];

  @override
  void initState() {
    super.initState();
    for (final f in _fields) {
      if (f.type == GarageFieldType.text ||
          f.type == GarageFieldType.number ||
          f.type == GarageFieldType.price ||
          f.type == GarageFieldType.textarea) {
        _controllers[f.key] = TextEditingController();
      }
    }
    _values['quantity'] = '1';
    _controllers['quantity']?.text = '1';
    _controllers['price']?.text = '0';
  }

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  // ═══════════════════════════════════════════
  // 提交
  // ═══════════════════════════════════════════

  void _submit() {
    // 收集文本类字段
    for (final f in _fields) {
      if (f.type == GarageFieldType.text ||
          f.type == GarageFieldType.number ||
          f.type == GarageFieldType.price ||
          f.type == GarageFieldType.textarea) {
        _values[f.key] = _controllers[f.key]?.text ?? '';
      }
    }
    // 收集日期
    if (_selectedDate != null) {
      _values['purchaseDate'] =
          '${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}';
    }
    Navigator.of(context).pop();
    widget.onSubmit(_values);
  }

  // ═══════════════════════════════════════════
  // 字段分发
  // ═══════════════════════════════════════════

  Widget _buildField(GarageFormFieldConfig f) {
    switch (f.type) {
      case GarageFieldType.text:
        return _buildTextField(f);
      case GarageFieldType.number:
        return _buildNumberField(f);
      case GarageFieldType.price:
        return _buildPriceField(f);
      case GarageFieldType.select:
        return _buildSelectField(f);
      case GarageFieldType.date:
        return _buildDateField(f);
      case GarageFieldType.textarea:
        return _buildTextAareaField(f);
    }
  }

  Widget _buildTextField(GarageFormFieldConfig f) {
    return FormTextField(
      key: ValueKey(f.key),
      label: f.label,
      controller: _controllers[f.key]!,
      hint: f.hint,
      variant: FormTextFieldVariant.outlined,
    );
  }

  Widget _buildNumberField(GarageFormFieldConfig f) {
    return FormTextField(
      key: ValueKey(f.key),
      label: f.label,
      controller: _controllers[f.key]!,
      hint: f.hint,
      keyboardType: TextInputType.number,
    );
  }

  Widget _buildPriceField(GarageFormFieldConfig f) {
    return FormTextField(
      key: ValueKey(f.key),
      label: f.label,
      controller: _controllers[f.key]!,
      hint: f.hint,
      keyboardType: TextInputType.number,
      prefixText: '\$',
      variant: FormTextFieldVariant.outlined,
    );
  }

  Widget _buildSelectField(GarageFormFieldConfig f) {
    return FormSelectField(
      key: ValueKey(f.key),
      label: f.label,
      current: (_values[f.key] as String?) ?? '',
      hint: f.hint ?? '请选择',
      choices: [
        for (final option in f.pickOptions ?? <String>[])
          S2Choice<String>(value: option, title: option),
      ],
      onChanged: (v) => setState(() => _values[f.key] = v),
      variant: FormSelectFieldVariant.outlined,
    );
  }

  Widget _buildDateField(GarageFormFieldConfig f) {
    return FormPickerField(
      key: ValueKey(f.key),
      label: f.label,
      variant: FormPickerFieldVariant.outlined,
      displayText: _selectedDate != null
          ? '${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}'
          : null,
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: _selectedDate ?? DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        );
        if (picked != null) {
          setState(() => _selectedDate = picked);
        }
      },
    );
  }

  Widget _buildTextAareaField(GarageFormFieldConfig f) {
    return FormTextField(
      key: ValueKey(f.key),
      label: f.label,
      controller: _controllers[f.key]!,
      hint: f.hint,
      variant: FormTextFieldVariant.outlined,
      maxLines: 4,
    );
  }
  // ═══════════════════════════════════════════
  // Build
  // ═══════════════════════════════════════════

  @override
  Widget build(BuildContext context) {
    return Box(
      style: Style($box.color.ref(mxt.color.surface), $box.borderRadius(r(16))),

      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── 拖拽指示条 ──
          Center(
            child: Container(
              width: w(40),
              height: h(4),
              margin: EdgeInsets.only(top: w(12), bottom: w(8)),
              decoration: BoxDecoration(
                color: context
                    .color(mxt.color.onSurfaceVariant)
                    .withOpacity(0.3),
                borderRadius: BorderRadius.circular(r(2)),
              ),
            ),
          ),

          // ── 标题行 ──
          HBox(
            style: Style(
              $box.padding.all.ref(mxt.space.medium),
              $flex.mainAxisAlignment.spaceBetween(),
            ),
            children: [
              StyledText('添加车库', style: AddGarageSheetStyle.titleText),
              PressableBox(
                onPress: () => Navigator.of(context).pop(),
                child: StyledIcon(
                  Icons.close,
                  style: Style(
                    $icon.size(sp(24)),
                    $icon.color.ref(mxt.color.onSurfaceVariant),
                  ),
                ),
              ),
            ],
          ),

          // ── 产品名 ──
          StyledText(
            widget.productName,
            style: AddGarageSheetStyle.productName,
          ),

          const Divider(),

          // ── 表单（可滚动） ──
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: w(12)),
              child: VBox(
                children: [
                  // 数量 + 单价 并排
                  HBox(
                    style: AddGarageSheetStyle.rowFields,
                    children: [
                      Expanded(child: _buildField(_fields[0])),
                      Expanded(child: _buildField(_fields[1])),
                    ],
                  ),
                  for (int i = 2; i < _fields.length; i++)
                    _buildField(_fields[i]),
                ],
              ),
            ),
          ),

          // ── 提交按钮 ──
          Box(
            style: Style(
              $box.width(double.infinity),
              $box.padding.all.ref(mxt.space.medium),
            ),
            child: SocialButton(
              onTap: _submit,
              type: SocialButtonTypeVariant.primary,
              size: SocialButtonSizeVariant.defaults,
              shape: SocialButtonShapeVariant.rounded,
              label: '提交',
            ),
          ),
        ],
      ),
    );
  }
}
