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

  static const _channelOptions = ['线上商城', '线下门店', '二手平台', '海外代购', '私人收藏', '其他'];

  static const _limitedOptions = [
    '不限量',
    '限量500台',
    '限量1000台',
    '限量3000台',
    '限量5000台',
    '其他限量',
  ];

  static final _fields = const [
    FormFieldConfig(
      type: FormFieldType.number,
      key: 'quantity',
      label: '数量',
      hint: '请输入数量',
    ),
    FormFieldConfig(
      type: FormFieldType.price,
      key: 'price',
      label: '单价',
      hint: '请输入单价',
    ),
    FormFieldConfig(
      type: FormFieldType.text,
      key: 'nickname',
      label: '爱车昵称',
      hint: '为你的爱车取个名字',
    ),
    FormFieldConfig(
      type: FormFieldType.date,
      key: 'purchaseDate',
      label: '购买时间',
      hint: '选择购买日期',
    ),
    FormFieldConfig(
      type: FormFieldType.select,
      key: 'channel',
      label: '购买渠道',
      pickOptions: _channelOptions,
    ),
    FormFieldConfig(
      type: FormFieldType.select,
      key: 'limitedInfo',
      label: '限量信息',
      pickOptions: _limitedOptions,
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
                    defaults: const {'quantity': '1', 'price': '0'},
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
          final values = formKey.currentState!.collectValues();
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
