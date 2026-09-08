import 'package:flutter/material.dart';
import 'package:miniauto_keeper/core/utils/screen_adapter.dart';
import 'package:miniauto_keeper/models/car_model.dart';

import 'package:mix/mix.dart';

import '../../image/image.dart';
import '../product.style.dart';
import '../product.variant.dart';

class ProductGridLayout extends StatelessWidget {
  final CarModel product;
  final Widget? details;
  final Widget? actionBar;
  final VoidCallback? onTap;

  const ProductGridLayout(
    this.product, {
    super.key,
    this.details,
    this.actionBar,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // 应用 gridMode 变体
    final style = ProductStyle.container.applyVariant(ProductMode.gridMode);

    return Box(
      style: style,
      child: VBox(
        style: ProductStyle.gridGap,
        children: [
          // ── 图片 + 限量徽章 ──
          GestureDetector(
            onTap: onTap,
            child: Stack(
              children: [
                Box(
                  style: ProductStyle.image.applyVariant(ProductMode.gridMode),
                  child: CustomImage(
                    imageUrl: product.coverImage,
                    aspectRatio: 1,
                  ),
                ),
                if (product.isLimited)
                  Positioned(
                    top: w(8),
                    left: w(8),
                    child: Box(
                      style: ProductStyle.gridLimitedBadge,
                      child: StyledText(
                        'LIMITED',
                        style: ProductStyle.gridLimitedBadgeText,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // ── 默认 meta 区：名称 → 规格带 → 价格 ──
          details ?? _buildMeta(),

          // action bar (optional, controlled by caller)
          ?actionBar,
        ],
      ),
    );
  }

  // ── 默认 meta 区：名称 → 规格带 → 价格 ──
  Widget _buildMeta() {
    final specs = <String>[
      if (product.scale.isNotEmpty) product.scale,
      if (product.material.isNotEmpty) _capitalize(product.material),
      if (product.color.isNotEmpty) product.color,
    ];

    final title = product.name.isNotEmpty ? product.name : product.modelNumber;

    return VBox(
      style: ProductStyle.gridMeta,
      children: [
        StyledText(
          title,
          style: ProductStyle.title.applyVariant(ProductMode.gridMode),
        ),
        if (specs.isNotEmpty)
          StyledText(specs.join(' · '), style: ProductStyle.gridSpecText),
        // if (_hasPrice) _buildPriceRow(),
      ],
    );
  }

  bool get _hasPrice =>
      double.tryParse(product.marketPrice) != null ||
      double.tryParse(product.releasePrice) != null;

  // ── 价格行：主价 + 划线价 ──
  Widget _buildPriceRow() {
    final market = double.tryParse(product.marketPrice);
    final release = double.tryParse(product.releasePrice);
    final main = ProductStyle.gridPriceMain ? market : release;
    final original = ProductStyle.gridPriceMain ? release : market;
    final mainText = ProductStyle.gridPriceMain
        ? product.marketPrice
        : product.releasePrice;
    final originalText = ProductStyle.gridPriceMain
        ? product.releasePrice
        : product.marketPrice;
    final showOriginal = main != null && original != null && original > main;

    return HBox(
      style: ProductStyle.gridPriceRow,
      children: [
        StyledText('\$ $mainText', style: ProductStyle.gridPrice),
        if (showOriginal) ...[
          StyledText('\$ $originalText', style: ProductStyle.gridPriceMarket),
        ],
      ],
    );
  }

  String _capitalize(String value) {
    if (value.isEmpty) return value;
    return value[0].toUpperCase() + value.substring(1);
  }
}
