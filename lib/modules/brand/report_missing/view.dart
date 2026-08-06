import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:miniauto_keeper/core/theme/app_theme.dart';
import 'package:miniauto_keeper/core/theme/app_theme_tool.dart';
import 'package:miniauto_keeper/core/utils/screen_adapter.dart';
import 'package:miniauto_keeper/core/widgets/form/form_builder/form_builder.dart';
import 'package:miniauto_keeper/core/widgets/form/form_builder/form_field_config.dart';
import 'package:miniauto_keeper/core/widgets/form/form_picker_field/form_picker_field.dart';
import 'package:miniauto_keeper/core/widgets/form/form_picker_field/form_picker_field.variant.dart';
import 'package:miniauto_keeper/core/widgets/social_button/social_button.dart';
import 'package:miniauto_keeper/core/widgets/social_button/social_button.variant.dart';
import 'package:miniauto_keeper/models/brand_model.dart';
import 'package:mix/mix.dart';

import 'controller.dart';
import 'style.dart';

class ReportMissingView extends GetView<ReportMissingController> {
  ReportMissingView({super.key});

  final _formKeys = <GlobalKey<FormBuilderState>>[];

  @override
  Widget build(BuildContext context) {
    // 每个 section 一个 FormBuilder → 等量 GlobalKey
    if (_formKeys.length != ReportMissingController.sections.length) {
      _formKeys.clear();
      for (var i = 0; i < ReportMissingController.sections.length; i++) {
        _formKeys.add(GlobalKey<FormBuilderState>());
      }
    }

    return Scaffold(
      backgroundColor: context.color(mxt.color.background),
      appBar: AppBar(
        title: const Text('缺失上报'),
        elevation: 0,
        backgroundColor: context.color(mxt.color.surface),
      ),
      body: SingleChildScrollView(
        child: VBox(
          style: Style(
            $flex.gap.ref(mxt.space.medium),
            $box.padding.bottom(h(40)),
          ),
          children: [_buildImageSection(), ..._buildFormSections()],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  List<Widget> _buildFormSections() {
    final widgets = <Widget>[];
    final sections = ReportMissingController.sections;

    for (var i = 0; i < sections.length; i++) {
      final s = sections[i];
      widgets.add(
        CardPanel(
          title: s.title,
          content: FormBuilder(
            key: _formKeys[i],
            fields: s.fields,
            valueGetters: _brandGetters,
            customBuilders: _brandCustomBuilders,
          ),
        ),
      );
    }
    return widgets;
  }

  Map<String, dynamic Function()> get _brandGetters => {
    'modelBrand': () => controller.formValues['modelBrand'],
    'carBrand': () => controller.formValues['carBrand'],
  };

  Map<FormFieldType, Widget Function(BuildContext, FormFieldConfig)>
  get _brandCustomBuilders => {FormFieldType.brand: _buildBrandField};

  // ── Bottom Bar ──

  Widget _buildBottomBar() {
    return SafeArea(
      child: Box(
        style: ReportMissingStyle.bottomBar,
        child: SocialButton(
          prefixIcon: Icons.upload_rounded,
          label: '提交缺失上报',
          onTap: () {
            final allValues = <String, dynamic>{};
            for (final key in _formKeys) {
              allValues.addAll(key.currentState!.collectValues());
            }
            controller.onFormSubmit(allValues);
          },
          type: SocialButtonTypeVariant.primary,
          fill: SocialButtonFillVariant.fill,
          size: SocialButtonSizeVariant.defaults,
          shape: SocialButtonShapeVariant.rounded,
        ),
      ),
    );
  }

  // ── 图片区 ──

  Widget _buildImageSection() {
    return Box(
      style: ReportMissingStyle.imageSection,
      child: VBox(
        style: Style($flex.gap.ref(mxt.space.small)),
        children: [
          HBox(
            style: Style(
              $flex.mainAxisAlignment.spaceBetween(),
              $flex.crossAxisAlignment.center(),
            ),
            children: [
              StyledText('车模图片', style: ReportMissingStyle.imageSectionTitle),
              Obx(
                () => StyledText(
                  '${controller.images.length}/5',
                  style: ReportMissingStyle.formPlaceholder,
                ),
              ),
            ],
          ),
          SizedBox(height: h(8)),
          Obx(() {
            return Wrap(
              spacing: w(8),
              runSpacing: h(8),
              children: [
                ...controller.images.asMap().entries.map((entry) {
                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Box(
                        style: ReportMissingStyle.imageThumb,
                        child: Image.file(
                          entry.value,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: -6,
                        right: -6,
                        child: GestureDetector(
                          onTap: () => controller.removeImage(entry.key),
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: const BoxDecoration(
                              color: Color(0xFFE54335),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close,
                              size: 12,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
                if (controller.images.length < 5)
                  GestureDetector(
                    onTap: controller.pickImages,
                    child: Box(
                      style: ReportMissingStyle.imageAddBtn,
                      child: StyledIcon(
                        Icons.add_photo_alternate_outlined,
                        style: Style(
                          $icon.size(28),
                          $icon.color.ref(mxt.color.onSurfaceVariant),
                        ),
                      ),
                    ),
                  ),
              ],
            );
          }),
        ],
      ),
    );
  }

  // ── Brand 字段自定义渲染 ──
  Widget _buildBrandField(BuildContext context, FormFieldConfig f) {
    final kind = f.extra as BrandFieldKind;
    return Obx(() {
      final brand = controller.formValues[f.key] as BrandModel?;
      return FormPickerField(
        label: f.label,
        isRequired: f.isRequired,
        displayText: brand?.name,
        variant: FormPickerFieldVariant.outlined,
        onTap: () => controller.selectBrand(kind),
      );
    });
  }
}

// ── 简易 CardPanel ──

class CardPanel extends StatelessWidget {
  final String title;
  final Widget content;

  const CardPanel({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Box(
      style: Style(
        $box.color.ref(mxt.color.surface),
        $box.borderRadius(r(12)),
        $box.padding.horizontal.ref(mxt.space.medium),
        $box.padding.vertical.ref(mxt.space.medium),
      ),
      child: VBox(
        style: Style($flex.gap.ref(mxt.space.small)),
        children: [
          StyledText(
            title,
            style: Style(
              $text.style.fontWeight.w600(),
              $text.style.fontSize(16),
              $text.style.color.ref(mxt.color.onSurface),
            ),
          ),
          Divider(height: h(1)),
          SizedBox(height: h(8)),
          content,
        ],
      ),
    );
  }
}
