import 'package:flutter/material.dart';
import 'package:flutter_filter_dialog/flutter_filter_dialog.dart';
import 'package:get/get.dart';
import 'package:miniauto_keeper/core/theme/app_theme.dart';
import 'package:miniauto_keeper/core/theme/app_theme_tool.dart';
import 'package:miniauto_keeper/core/utils/screen_adapter.dart';
import 'package:miniauto_keeper/core/widgets/social_button/social_button.dart';
import 'package:miniauto_keeper/models/brand_model.dart';
import 'package:miniauto_keeper/modules/product_detail/widget/card_panel/card_panel.dart';
import 'package:mix/mix.dart';

import 'controller.dart';
import 'form_field_config.dart';
import 'style.dart';
import 'widgets/form_text_field/form_text_field.dart';
import 'widgets/form_select_field/form_select_field.dart';
import 'widgets/form_brand_field/form_brand_field.dart';

class ReportMissingView extends GetView<ReportMissingController> {
  const ReportMissingView({super.key});

  @override
  Widget build(BuildContext context) {
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
          children: [
            _buildImageSection(),
            for (final section in ReportMissingController.sections)
              _buildSectionCard(section),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildBottomBar() {
    return SafeArea(
      child: Box(
        style: ReportMissingStyle.bottomBar,
        child: SocialButton(
          icon: Icons.upload_rounded,
          label: '提交缺失上报',
          onTap: controller.submit,
        ),
      ),
    );
  }

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

  Widget _buildSectionCard(FormSection section) {
    final fieldWidgets = <Widget>[];
    final fields = section.fields;
    for (int i = 0; i < fields.length; i++) {
      fieldWidgets.add(_buildField(fields[i]));

      if (i < fields.length - 1) fieldWidgets.add(SizedBox(height: w(16)));
    }

    return CardPanel(
      title: section.title,
      content: VBox(style: Style($flex.gap(0)), children: fieldWidgets),
    );
  }

  Widget _buildField(FormFieldConfig f) {
    if (f.type == FieldType.text) {
      return FormTextField(
        label: f.label,
        controller: controller.textCtrl(f.key),
        hint: f.hint,
        keyboardType: f.keyboardType,
      );
    }
    if (f.type == FieldType.select) {
      final choices = f.pickOptions!
          .map((o) => S2Choice<String>(value: o, title: o))
          .toList();
      return Obx(() {
        final current = (controller.formValues[f.key] as String?) ?? '';
        return FormSelectField(
          label: f.label,
          current: current,
          hint: '请选择',
          choices: choices,
          onChanged: (v) => controller.formValues[f.key] = v,
        );
      });
    }
    return Obx(() {
      final brand = controller.formValues[f.key] as BrandModel?;
      return FormBrandField(
        label: f.label,
        displayText: brand?.name,
        onTap: () => controller.selectBrand(f.brandKind!),
      );
    });
  }
}
