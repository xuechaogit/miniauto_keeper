import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:miniauto_keeper/core/widgets/divider/divider.dart';
import 'package:miniauto_keeper/core/widgets/price_tag/price_tag.dart';
import 'package:mix/mix.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../core/widgets/html_renderer/html_renderer.dart';
import '../../core/theme/app_theme.dart';
import 'package:miniauto_keeper/core/theme/app_theme_tool.dart';
import '../../models/product_detail_model.dart';
import 'controller.dart';
import 'style.dart';
import 'widget/card_panel/card_panel.dart';
import 'widget/gallery/gallery.dart';

import 'package:miniauto_keeper/core/utils/screen_adapter.dart';

class ProductDetailView extends GetView<ProductDetailController> {
  const ProductDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SPECIFICATION'), elevation: 0),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFFE54335)),
          );
        }
        final data = controller.product.value;
        if (data == null) {
          return Center(
            child: StyledText(
              '商品数据加载失败',
              style: Style(
                $text.color.ref(mxt.color.onSurfaceVariant),
                $text.style.ref(mxt.textStyle.body),
              ),
            ),
          );
        }
        return Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.only(bottom: h(90)),
              child: VBox(
                style: Style($flex.crossAxisAlignment.start()),
                children: [
                  ProductImageGallery(data: data),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: w(12),
                      vertical: w(12),
                    ),
                    child: VBox(
                      style: Style($flex.gap.ref(mxt.space.medium)),
                      children: [
                        _buildCoreMetaCard(data),
                        _buildParamPanel(data),
                        _buildRatingCard(data, context),
                        _buildDetailDescCard(data),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
      bottomNavigationBar: Obx(() {
        final data = controller.product.value;
        return data == null
            ? const SizedBox.shrink()
            : _buildBottomControlPanel(data, context);
      }),
    );
  }

  Widget _buildCoreMetaCard(ProductDetailModel data) {
    return CardPanel(
      showDivider: false,
      content: VBox(
        style: Style(
          $flex.gap.ref(mxt.space.medium),
          $flex.crossAxisAlignment.start(),
        ),
        children: [
          HBox(
            style: Style(
              $flex.mainAxisAlignment.spaceBetween(),
              $flex.crossAxisAlignment.end(),
            ),
            children: [
              PriceTag(price: data.price, originalPrice: data.originalPrice),
            ],
          ),
          StyledText(data.title, style: ProductDetailStyle.productTitle),
        ],
      ),
    );
  }

  Widget _buildParamPanel(ProductDetailModel data) {
    return CardPanel(
      showDivider: false,
      content: VBox(
        style: Style($flex.gap(0)),
        children: [
          _buildFieldGrid([
            ('年份', data.year),
            ('车模品牌', data.level2Category),
            ('货号', data.code),
            ('批次号', data.dash),
          ], vertical: true),

          const AppDivider(),
          Obx(
            () => controller.isExpanded.value
                ? _buildFieldGrid([
                    ('车模系列', data.series),
                    ('产地', data.country),
                    ('评级', data.erpRating),
                    ('入库时间', data.createdAt),
                  ], grid: false)
                : const SizedBox.shrink(),
          ),

          if (data.bundleTags.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(top: 8),
              child: Wrap(
                spacing: 6,
                runSpacing: 4,
                children: data.bundleTags
                    .map(
                      (tag) => Chip(
                        label: Text(tag, style: const TextStyle(fontSize: 11)),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity: VisualDensity.compact,
                        padding: EdgeInsets.zero,
                      ),
                    )
                    .toList(),
              ),
            ),

          PressableBox(
            onPress: () => controller.isExpanded.toggle(),
            style: ProductDetailStyle.expandBtn,
            child: Obx(
              () => StyledText(
                controller.isExpanded.value ? '收起参数' : '更多参数',
                style: ProductDetailStyle.expandBtnText,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFieldGrid(
    List<(String, String?)> fields, {
    bool grid = true,
    bool vertical = false,
  }) {
    if (grid) {
      return IntrinsicHeight(
        child: HBox(
          style: Style($flex.crossAxisAlignment.center()),
          children: [
            for (var i = 0; i < fields.length; i++) ...[
              if (i > 0)
                AppDivider(
                  direction: AppDividerDirection.vertical,
                  style: Style(
                    $box.margin.horizontal(0),
                    $box.margin.vertical(h(4)),
                  ),
                ),
              Expanded(
                child: _paramCell(fields[i].$1, fields[i].$2, vertical: true),
              ),
            ],
          ],
        ),
      );
    }
    return VBox(
      style: Style($flex.gap.ref(mxt.space.small)),
      children: [
        for (var field in fields)
          _paramCell(field.$1, field.$2, vertical: vertical),
        const AppDivider(),
      ],
    );
  }

  Widget _paramCell(String label, String? value, {bool vertical = false}) {
    if (value == null || value.trim().isEmpty) return const SizedBox.shrink();
    final children = vertical
        ? <Widget>[
            StyledText(value, style: ProductDetailStyle.paramValue),
            StyledText(label, style: ProductDetailStyle.paramLabel),
          ]
        : <Widget>[
            StyledText(label, style: ProductDetailStyle.paramLabel),
            StyledText(value, style: ProductDetailStyle.paramValue),
          ];

    return Box(
      style: ProductDetailStyle.paramRow,
      child: vertical
          ? VBox(
              style: Style($flex.crossAxisAlignment.center()),
              children: children,
            )
          : HBox(
              style: Style(
                $flex.mainAxisAlignment.spaceBetween(),
                $flex.crossAxisAlignment.center(),
              ),
              children: children,
            ),
    );
  }

  Widget _buildDetailDescCard(ProductDetailModel data) {
    if (data.content.isEmpty) return const SizedBox.shrink();

    return CardPanel(
      title: 'OVERVIEW / 详情描述',
      showDivider: false,
      content: AppHtmlRenderer(htmlContent: data.content),
    );
  }

  Widget _buildBottomIconBtn({
    required IconData icon,
    required String label,
    required VoidCallback onPress,
    Color? iconColor,
  }) {
    final iconStyle = iconColor != null
        ? Style($icon.color(iconColor), $icon.size(24))
        : Style($icon.color.ref(mxt.color.onSurface), $icon.size(24));

    return PressableBox(
      onPress: onPress,
      child: VBox(
        style: ProductDetailStyle.bottomIconBtn,
        children: [
          StyledIcon(icon, style: iconStyle),
          StyledText(label, style: ProductDetailStyle.bottomIconBtnText),
        ],
      ),
    );
  }

  Widget _buildBottomControlPanel(
    ProductDetailModel data,
    BuildContext context,
  ) {
    return BottomAppBar(
      height: 70,
      elevation: 8,
      padding: EdgeInsets.symmetric(horizontal: w(16), vertical: 8),
      color: context.color(mxt.color.surface),
      child: HBox(
        style: Style($flex.gap.ref(mxt.space.small)),
        children: [
          _buildBottomIconBtn(
            icon: data.isFavourite ? Icons.star_sharp : Icons.star_border_sharp,
            label: data.isFavourite ? '已收藏' : '收藏',
            iconColor: data.isFavourite ? ProductDetailStyle.accent : null,
            onPress: () {
              Get.snackbar(
                'SYSTEM',
                data.isFavourite ? '已取消收藏' : '已收藏',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: const Color(0xFF1E1E1E),
                colorText: ProductDetailStyle.accent,
                duration: const Duration(seconds: 2),
              );
            },
          ),
          SizedBox(width: w(4)),
          _buildBottomIconBtn(
            icon: Icons.ios_share_outlined,
            label: '分享',
            iconColor: null,
            onPress: controller.executeShare,
          ),

          SizedBox(width: w(4)),

          // 提货按钮
          Expanded(
            child: PressableBox(
              style: ProductDetailStyle.primaryActionBtn,
              onPress: () {
                Get.snackbar(
                  'SYSTEM',
                  '入库单生成中...',
                  backgroundColor: ProductDetailStyle.accent,
                  colorText: Colors.white,
                );
              },
              child: StyledText('加入到我的车库', style: ProductDetailStyle.btnText),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingCard(ProductDetailModel data, BuildContext context) {
    return CardPanel(
      title: '评分',
      showDivider: false,
      content: Obx(() {
        final rating =
            controller.userRating.value ??
            (double.tryParse(data.erpRating ?? '') ?? 0.0);
        return HBox(
          style: Style(
            $flex.mainAxisAlignment.spaceBetween(),
            $flex.crossAxisAlignment.center(),
          ),
          children: [
            StyledText(
              rating.toStringAsFixed(1),
              style: ProductDetailStyle.ratingValue,
            ),
            IgnorePointer(
              child: RatingBar.builder(
                initialRating: rating,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemSize: 28,
                itemPadding: EdgeInsets.symmetric(horizontal: 2),
                itemBuilder: (context, _) =>
                    Icon(Icons.star, color: Colors.amber),
                onRatingUpdate: (val) {},
              ),
            ),
            GestureDetector(
              onTap: () => _showRatingSheet(context, data),
              child: Row(
                children: [
                  StyledText(
                    controller.userRating.value == null ? '点击评分' : '修改评分',
                    style: ProductDetailStyle.expandBtnText,
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: mxt.color.primary.resolve(context),
                    size: 18,
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  void _showRatingSheet(BuildContext context, ProductDetailModel data) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(w(16)),
            decoration: BoxDecoration(
              color: mxt.color.surface.resolve(context),
              borderRadius: BorderRadius.vertical(
                top: mxt.radius.medium.resolve(context),
              ),
            ),
            child: VBox(
              style: Style(
                $flex.gap.ref(mxt.space.medium),
                $flex.crossAxisAlignment.center(),
              ),
              children: [
                SizedBox(height: h(8)),
                StyledText('您的评分', style: ProductDetailStyle.paramLabel),
                SizedBox(height: h(8)),
                RatingBar.builder(
                  initialRating:
                      controller.userRating.value ??
                      (double.tryParse(data.erpRating ?? '') ?? 0.0),
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemSize: 40,
                  itemPadding: EdgeInsets.symmetric(horizontal: 4),
                  itemBuilder: (context, _) =>
                      Icon(Icons.star, color: Colors.amber),
                  onRatingUpdate: (val) {
                    controller.userRating.value = val;
                  },
                ),
                SizedBox(height: h(24)),
                Row(
                  children: [
                    Expanded(
                      child: PressableBox(
                        style: Style(
                          $box.borderRadius.all.ref(mxt.radius.small),
                          $box.color.ref(mxt.color.surface),
                          $box.padding.vertical.ref(mxt.space.small),
                          $flex.mainAxisAlignment.center(),
                        ),
                        onPress: () => Navigator.pop(context),
                        child: StyledText(
                          '取消',
                          style: ProductDetailStyle.paramLabel,
                        ),
                      ),
                    ),
                    SizedBox(width: w(12)),
                    Expanded(
                      child: PressableBox(
                        style: ProductDetailStyle.primaryActionBtn,
                        onPress: () {
                          Navigator.pop(context);
                          Get.snackbar(
                            'SUCCESS',
                            '评分已提交',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: const Color(0xFF1E1E1E),
                            colorText: ProductDetailStyle.accent,
                            duration: const Duration(seconds: 1),
                          );
                        },
                        child: StyledText(
                          '确认',
                          style: ProductDetailStyle.btnText,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
