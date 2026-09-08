import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:miniauto_keeper/core/widgets/custom_shimmer/custom_shimmer.dart';
import 'package:miniauto_keeper/core/widgets/social_button/social_button.dart';
import 'package:miniauto_keeper/core/widgets/social_button/social_button.variant.dart';
import 'package:miniauto_keeper/core/widgets/tag/tag.dart';
import 'package:miniauto_keeper/core/widgets/tag/tag.variant.dart';
import 'package:mix/mix.dart';
import '../../core/theme/app_theme.dart';
import 'package:miniauto_keeper/core/theme/app_theme_tool.dart';
import '../../models/car_model.dart';
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
          return const _BuildSkeleton();
        }
        final data = controller.product.value;
        if (data == null) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                StyledText(
                  '车模数据加载失败',
                  style: Style(
                    $text.color.ref(mxt.color.onSurfaceVariant),
                    $text.style.ref(mxt.textStyle.body),
                  ),
                ),
                SizedBox(height: h(12)),
                PressableBox(
                  onPress: controller.retry,
                  style: Style(
                    $box.padding.horizontal(w(16)),
                    $box.padding.vertical(h(8)),
                  ),
                  child: StyledText(
                    '重试',
                    style: Style(
                      $text.color.ref(mxt.color.primary),
                      $text.style.ref(mxt.textStyle.body),
                      $text.fontWeight.w600(),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        final imageUrls = <String>[
          if (data.coverImage.isNotEmpty) data.coverImage,
          ...data.images.map((e) => e.imageUrl).where((u) => u.isNotEmpty),
        ];
        return SingleChildScrollView(
          padding: EdgeInsets.only(bottom: h(90)),
          child: VBox(
            style: Style($flex.crossAxisAlignment.start()),
            children: [
              ProductImageGallery(images: imageUrls),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: w(14),
                  vertical: w(14),
                ),
                child: VBox(
                  style: Style($flex.gap.ref(mxt.space.medium)),
                  children: [
                    _buildCoreMetaCard(data),
                    _buildParamPanel(context, data),
                    _buildDetailDescCard(data),
                  ],
                ),
              ),
            ],
          ),
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

  String? _v(String? s) {
    if (s == null) return null;
    final t = s.trim();
    return t.isEmpty ? null : t;
  }

  Widget _buildCoreMetaCard(CarModel data) {
    final name = data.name.isNotEmpty ? data.name : data.modelNumber;

    // 浏览量
    final viewLine = data.viewCount > 0 ? '${data.viewCount} 次浏览' : '';

    return VBox(
      style: Style(
        $flex.gap(w(2)),
        $flex.crossAxisAlignment.start(),
        $box.width(double.infinity),
        $box.padding.horizontal.ref(mxt.space.medium),
      ),
      children: [
        if (data.isLimited)
          StyledText(
            data.limitedQuantity != null && data.limitedQuantity! > 0
                ? 'LIMITED ${data.limitedQuantity}'
                : 'LIMITED',
            style: ProductDetailStyle.limitedBadge,
          ),
        StyledText(name, style: ProductDetailStyle.productTitle),
        if (viewLine.isNotEmpty)
          StyledText(viewLine, style: ProductDetailStyle.hotMeta),
      ],
    );
  }

  Widget _buildParamPanel(BuildContext context, CarModel data) {
    // 快参已在顶部胶囊展示，specs 分组跳过同名 key 去重
    const quickKeys = {'scale', '比例', 'material', '材质', 'color', '颜色'};

    // 基础信息组：品牌/系列已在 meta 锚定，这里只留中长文本字段
    final baseFields = <(String, String?)>[
      ('年份', _v(data.realCarYear?.toString())),
      ('品牌', _v(data.brand.name)),
      ('系列', _v(data.series.name)),
      ('车模比例', _v(data.scale)),
      ('发售价', _v(data.releasePrice)),
      ('发售日', _v(data.releaseDate)),
      ('产地', _v(data.brand.country)),
      ('颜色', _v(data.color)),
      ('材质', _v(data.material)),
    ];

    return CardPanel(
      showDivider: false,
      title: '车模信息',
      content: VBox(
        style: Style(
          $flex.gap.ref(mxt.space.small),
          $box.width(double.infinity),
        ),
        children: [
          if (baseFields.any((f) => _v(f.$2) != null))
            _buildGroupGrid(context, baseFields),
        ],
      ),
    );
  }

  /// 规格分组宫格：组标题 + 2 列 label上value下小格，无逐行边框
  Widget _buildGroupGrid(BuildContext context, List<(String, String?)> fields) {
    final nonEmpty = fields.where((f) => _v(f.$2) != null).toList();
    if (nonEmpty.isEmpty) return const SizedBox.shrink();
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: nonEmpty.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisExtent: w(50),
        mainAxisSpacing: w(8),
        crossAxisSpacing: w(8),
      ),
      itemBuilder: (context, index) {
        final field = nonEmpty[index];
        return _paramCell(context, field.$1, field.$2);
      },
    );
  }

  CustomTagType _tagTypeOf(String group) {
    switch (group.trim().toLowerCase()) {
      case 'color':
      case '颜色':
        return CustomTagType.success;
      case 'type':
      case '类型':
        return CustomTagType.info;
      default:
        return CustomTagType.primary;
    }
  }

  /// 宫殿单格：label 上 value 下，轻底圆角，适配短文本
  Widget _paramCell(BuildContext context, String label, String? value) {
    final v = _v(value);
    if (v == null) return const SizedBox.shrink();
    return Box(
      style: Style(
        $box.border.left.width(1),
        $box.border.left.color.ref(mxt.color.outlineVariant),
        $box.padding.horizontal(w(8)),
        $box.padding.vertical(h(6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          StyledText(
            label,
            style: Style(
              $text.style.ref(mxt.textStyle.caption),
              $text.color.ref(mxt.color.onSurfaceVariant),
              $text.maxLines(1),
              $text.overflow(TextOverflow.ellipsis),
            ),
          ),
          const SizedBox(height: 3),
          StyledText(
            v,
            style: Style(
              $text.style.ref(mxt.textStyle.caption),
              $text.color.ref(mxt.color.onSurface),
              $text.fontWeight.w600(),
              $text.maxLines(2),
              $text.overflow(TextOverflow.ellipsis),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailDescCard(CarModel data) {
    final parts = <String>[if (data.description.isNotEmpty) data.description];
    if (parts.isEmpty && data.tags.isEmpty) return const SizedBox.shrink();

    return CardPanel(
      title: '详情描述',
      showDivider: false,
      content: VBox(
        style: Style(
          $box.width(double.infinity),
          $flex.crossAxisAlignment.start(),
        ),
        children: [
          if (parts.isNotEmpty)
            StyledText(parts.join('\n'), style: ProductDetailStyle.descText),
        ],
      ),
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

  Widget _buildBottomControlPanel(CarModel data, BuildContext context) {
    return BottomAppBar(
      height: 70,
      elevation: 8,
      padding: EdgeInsets.symmetric(horizontal: w(16), vertical: 8),
      color: context.color(mxt.color.surface),
      child: HBox(
        style: Style($flex.gap.ref(mxt.space.small)),
        children: [
          _buildBottomIconBtn(
            icon: controller.isFavourite.value
                ? Icons.star_sharp
                : Icons.star_border_sharp,
            label: controller.isFavourite.value ? '已收藏' : '收藏',
            iconColor: controller.isFavourite.value
                ? ProductDetailStyle.accent
                : null,
            onPress: () {
              controller.toggleFavourite();
              Get.snackbar(
                'SYSTEM',
                controller.isFavourite.value ? '已收藏' : '已取消收藏',
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

          // 加入车库按钮
          Expanded(
            child: SocialButton(
              prefixIcon: Icons.upload_rounded,
              label: '加入到我的车库',
              onTap: () {
                Get.snackbar(
                  'SYSTEM',
                  '入库单生成中...',
                  backgroundColor: ProductDetailStyle.accent,
                  colorText: Colors.white,
                );
              },
              type: SocialButtonTypeVariant.primary,
              fill: SocialButtonFillVariant.fill,
              size: SocialButtonSizeVariant.defaults,
              shape: SocialButtonShapeVariant.rounded,
            ),
          ),
        ],
      ),
    );
  }
}

/// 详情加载骨架屏：图块 + meta 占位 + 内容占位
class _BuildSkeleton extends StatelessWidget {
  const _BuildSkeleton();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(bottom: h(90)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 图库占位：全宽沉浸
          CustomShimmer(
            child: CustomShimmerBlock(
              width: MediaQuery.of(context).size.width,
              height: w(390),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: w(14), vertical: w(14)),
            child: CustomShimmer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  CustomShimmerBlock(width: 120, height: 26),
                  SizedBox(height: 12),
                  CustomShimmerBlock(width: 220, height: 18),
                  SizedBox(height: 8),
                  CustomShimmerBlock(width: 150, height: 14),
                  SizedBox(height: 24),
                  _SkeletonCard(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SkeletonCard extends StatelessWidget {
  const _SkeletonCard();

  @override
  Widget build(BuildContext context) {
    final parentWidth = MediaQuery.of(context).size.width - w(28);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomShimmerBlock(width: parentWidth, height: 80),
        SizedBox(height: h(16)),
        CustomShimmerBlock(width: parentWidth, height: 120),
      ],
    );
  }
}
