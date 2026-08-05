import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_filter_dialog/flutter_filter_dialog.dart';
import 'package:get/get.dart';
import 'package:miniauto_keeper/core/theme/app_theme.dart';
import 'package:miniauto_keeper/core/theme/app_theme_tool.dart';
import 'package:miniauto_keeper/core/utils/screen_adapter.dart';
import 'package:miniauto_keeper/modules/product_detail/widget/card_panel/card_panel.dart';
import 'package:mix/mix.dart';

import 'controller.dart';
import 'style.dart';

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
            _buildImageSection(context),
            _buildBasicInfoCard(context),
            _buildSpecCard(context),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════
  // 图片区域
  // ═══════════════════════════════════════════

  Widget _buildImageSection(BuildContext context) {
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
              Obx(() => StyledText(
                '${controller.images.length}/5',
                style: ReportMissingStyle.formPlaceholder,
              )),
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

  // ═══════════════════════════════════════════
  // 基本信息卡片
  // ═══════════════════════════════════════════

  Widget _buildBasicInfoCard(BuildContext context) {
    return CardPanel(
      title: '基本信息',
      content: VBox(
        style: Style($flex.gap(0)),
        children: [
          _buildInputRow('车模名称', controller.productNameCtrl, hint: '请输入车模名称'),
          const _RowDivider(),
          _buildBrandRow(context),
          const _RowDivider(),
          _buildCarBrandRow(context),
          const _RowDivider(),
          _buildInputRow('发行年份', controller.releaseYearCtrl, hint: '如 2024', keyboardType: TextInputType.number),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════
  // 规格详情卡片
  // ═══════════════════════════════════════════

  Widget _buildSpecCard(BuildContext context) {
    return CardPanel(
      title: '规格详情',
      content: VBox(
        style: Style($flex.gap(0)),
        children: [
          _buildSelectRow(
            context,
            label: '比例',
            value: controller.scale,
            options: ReportMissingController.scaleOptions,
            onChange: controller.onScaleChanged,
          ),
          const _RowDivider(),
          _buildInputRow('车模编号', controller.productCodeCtrl, hint: '如 ABC123'),
          const _RowDivider(),
          _buildSelectRow(
            context,
            label: '版本',
            value: controller.version,
            options: ReportMissingController.versionOptions,
            onChange: controller.onVersionChanged,
          ),
          const _RowDivider(),
          _buildSelectRow(
            context,
            label: '颜色',
            value: controller.color,
            options: ReportMissingController.colorOptions,
            onChange: controller.onColorChanged,
          ),
          const _RowDivider(),
          _buildSelectRow(
            context,
            label: '材质',
            value: controller.material,
            options: ReportMissingController.materialOptions,
            onChange: controller.onMaterialChanged,
          ),
          const _RowDivider(),
          _buildSelectRow(
            context,
            label: '限量信息',
            value: controller.limitedInfo,
            options: ReportMissingController.limitedOptions,
            onChange: controller.onLimitedChanged,
          ),
          const _RowDivider(),
          _buildInputRow('发售价', controller.releasePriceCtrl, hint: '如 299.00', keyboardType: const TextInputType.numberWithOptions(decimal: true)),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════
  // 输入行
  // ═══════════════════════════════════════════

  Widget _buildInputRow(
    String label,
    TextEditingController ctrl, {
    String hint = '',
    TextInputType keyboardType = TextInputType.text,
  }) {
    return HBox(
      style: ReportMissingStyle.formRow,
      children: [
        StyledText(label, style: ReportMissingStyle.formLabel),
        SizedBox(width: w(12)),
        Expanded(
          child: TextField(
            controller: ctrl,
            keyboardType: keyboardType,
            textAlign: TextAlign.end,
            style: TextStyle(
              fontSize: sp(14),
              color: Color(0xFF16181D),
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                fontSize: sp(14),
                color: Color(0xFF5F6470),
              ),
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════
  // 品牌选择行（底部抽屉式，带缩略图预览）
  // ═══════════════════════════════════════════

  Widget _buildBrandRow(BuildContext context) {
    return Obx(() {
      final brand = controller.modelBrand.value;
      return PressableBox(
        onPress: controller.selectModelBrand,
        child: HBox(
          style: ReportMissingStyle.formRow,
          children: [
            StyledText('车模品牌', style: ReportMissingStyle.formLabel),
            const Spacer(),
            StyledText(
              brand?.name ?? '请选择',
              style: brand != null
                  ? ReportMissingStyle.formValue
                  : ReportMissingStyle.formPlaceholder,
            ),
            SizedBox(width: w(4)),
            Icon(
              Icons.chevron_right,
              size: 20,
              color: Color(0xFF5F6470),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildCarBrandRow(BuildContext context) {
    return Obx(() {
      final brand = controller.carBrand.value;
      return PressableBox(
        onPress: controller.selectCarBrand,
        child: HBox(
          style: ReportMissingStyle.formRow,
          children: [
            StyledText('汽车品牌', style: ReportMissingStyle.formLabel),
            const Spacer(),
            StyledText(
              brand?.name ?? '请选择',
              style: brand != null
                  ? ReportMissingStyle.formValue
                  : ReportMissingStyle.formPlaceholder,
            ),
            SizedBox(width: w(4)),
            Icon(
              Icons.chevron_right,
              size: 20,
              color: Color(0xFF5F6470),
            ),
          ],
        ),
      );
    });
  }

  // ═══════════════════════════════════════════
  // 枚举选择行（SmartSelect 底部抽屉）
  // ═══════════════════════════════════════════

  Widget _buildSelectRow(
    BuildContext context, {
    required String label,
    required RxString value,
    required List<String> options,
    required void Function(String?) onChange,
  }) {
    final choiceItems = options
        .map((o) => S2Choice<String>(value: o, title: o))
        .toList();

    return Obx(() {
      return SmartSelect<String>.single(
        title: label,
        selectedValue: value.value.isEmpty ? '请选择' : value.value,
        choiceItems: choiceItems,
        modalType: S2ModalType.bottomSheet,
        choiceType: S2ChoiceType.radios,
        onChange: (selected) => onChange(selected.value),
        tileBuilder: (ctx, state) {
          return GestureDetector(
            onTap: state.showModal,
            child: HBox(
              style: ReportMissingStyle.formRow,
              children: [
                StyledText(label, style: ReportMissingStyle.formLabel),
                const Spacer(),
                StyledText(
                  value.value.isEmpty ? '请选择' : value.value,
                  style: value.value.isEmpty
                      ? ReportMissingStyle.formPlaceholder
                      : ReportMissingStyle.formValue,
                ),
                SizedBox(width: w(4)),
                Icon(
                  Icons.chevron_right,
                  size: 20,
                  color: Color(0xFF5F6470),
                ),
              ],
            ),
          );
        },
      );
    });
  }

  // ═══════════════════════════════════════════
  // 提交按钮
  // ═══════════════════════════════════════════

  Widget _buildSubmitButton() {
    return PressableBox(
      style: ReportMissingStyle.submitBtn,
      onPress: controller.submit,
      child: StyledText('提交缺失上报', style: ReportMissingStyle.submitBtnText),
    );
  }
}

// ── 行分隔线 ──
class _RowDivider extends StatelessWidget {
  const _RowDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 0.5,
      margin: EdgeInsets.symmetric(horizontal: w(12)),
      color: Color(0xFFE8EBF0),
    );
  }
}
