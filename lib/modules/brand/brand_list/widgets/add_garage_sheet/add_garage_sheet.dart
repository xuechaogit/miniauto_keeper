import 'package:flutter/material.dart';
import 'package:miniauto_keeper/core/theme/app_theme.dart';
import 'package:miniauto_keeper/core/theme/app_theme_tool.dart';
import 'package:miniauto_keeper/core/utils/screen_adapter.dart';
import 'package:miniauto_keeper/core/widgets/form/form_builder/form_builder.dart';
import 'package:miniauto_keeper/core/widgets/form/form_builder/form_field_config.dart';
import 'package:miniauto_keeper/core/widgets/social_button/social_button.dart';
import 'package:miniauto_keeper/core/widgets/social_button/social_button.variant.dart';
import 'package:mix/mix.dart';

import 'add_garage_sheet.style.dart';

class AddGarageSheet extends StatelessWidget {
  final String productName;
  final GlobalKey<FormBuilderState> formKey;
  final void Function(Map<String, dynamic> values) onSubmit;

  const AddGarageSheet({
    super.key,
    required this.productName,
    required this.formKey,
    required this.onSubmit,
  });

  static const _conditionOptions = ['全新', '近新', '有瑕疵', '破损'];

  static final _fields = const [
    // FormFieldConfig(
    //   type: FormFieldType.number,
    //   key: 'quantity',
    //   label: '数量',
    //   hint: '请输入数量',
    //   stepperMin: 1,
    //   stepperMax: 999,
    //   stepperStep: 1,
    // ),
    FormFieldConfig(
      type: FormFieldType.date,
      key: 'purchaseDate',
      label: '购买日期',
      hint: '选择购买日期',
    ),
    FormFieldConfig(
      type: FormFieldType.price,
      key: 'purchasePrice',
      label: '购买价格',
      hint: '请输入单价',
    ),
    FormFieldConfig(
      type: FormFieldType.text,
      key: 'purchaseChannel',
      label: '购买渠道',
      hint: '请输入购买渠道',
    ),
    FormFieldConfig(
      type: FormFieldType.select,
      key: 'condition',
      label: '车模状况',
      hint: '选择车模状况',
      pickOptions: _conditionOptions,
    ),
    FormFieldConfig(
      type: FormFieldType.textarea,
      key: 'notes',
      label: '入手心得',
      hint: '分享你的入手体验',
    ),
  ];

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
          StyledText(productName, style: AddGarageSheetStyle.productName),

          const Divider(),

          // ── 表单 + 提交按钮 ──
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: w(12)),
              child: Column(
                children: [
                  FormBuilder(
                    key: formKey,
                    fields: _fields,
                    defaults: const {'purchasePrice': '0'},
                  ),
                ],
              ),
            ),
          ),
          _buildSubmitButton(context, formKey),
        ],
      ),
    );
  }

  Widget _buildSubmitButton(
    BuildContext context,
    GlobalKey<FormBuilderState> formKey,
  ) {
    return Box(
      style: Style(
        $box.width(double.infinity),
        $box.padding.all.ref(mxt.space.medium),
      ),
      child: SocialButton(
        onTap: () {
          final state = formKey.currentState;
          if (state == null || !state.validate()) return;
          final values = state.collectValues();
          Navigator.of(context).pop();
          onSubmit(values);
        },
        type: SocialButtonTypeVariant.primary,
        size: SocialButtonSizeVariant.defaults,
        shape: SocialButtonShapeVariant.rounded,
        label: '提交',
      ),
    );
  }
}
