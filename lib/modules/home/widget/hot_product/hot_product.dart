import 'package:flutter/material.dart';
import 'package:miniauto_keeper/core/widgets/image/image.dart';
import 'package:miniauto_keeper/models/product_model.dart';
import 'package:mix/mix.dart';

import 'hot_product.style.dart';

class HotProduct extends StatelessWidget {
  final List<ProductModel> products;
  final VoidCallback? onViewMore;

  const HotProduct({super.key, required this.products, this.onViewMore});

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) return const SizedBox.shrink();

    final top1 = products[0];
    final top2 = products.length > 1 ? products[1] : null;
    final top3 = products.length > 2 ? products[2] : null;

    return IntrinsicHeight(
      child: HBox(
        style: HotProductStyle.row,
        children: [
          Expanded(flex: 3, child: _Top1Card(product: top1)),
          Expanded(
            flex: 2,
            child: VBox(
              style: HotProductStyle.rightColumn,
              children: [
                if (top2 != null) Expanded(child: _SmallCard(product: top2)),
                if (top3 != null) Expanded(child: _SmallCard(product: top3)),
                if (onViewMore != null) _buildViewMore(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildViewMore() {
    return PressableBox(
      onPress: onViewMore,
      child: HBox(
        style: HotProductStyle.viewMore,
        children: [
          StyledText('查看更多', style: HotProductStyle.viewMoreText),
          StyledIcon(
            Icons.arrow_forward_ios,
            style: HotProductStyle.viewMoreIcon,
          ),
        ],
      ),
    );
  }
}

class _Top1Card extends StatelessWidget {
  final ProductModel product;

  const _Top1Card({required this.product});

  @override
  Widget build(BuildContext context) {
    return Box(
      style: HotProductStyle.top1Card,
      child: VBox(
        children: [
          Stack(
            children: [
              CustomImage(imageUrl: product.thumb, aspectRatio: 1.0),
              Positioned(
                top: 8,
                left: 8,
                child: Box(
                  style: HotProductStyle.hotBadge,
                  child: StyledText('HOT', style: HotProductStyle.hotBadgeText),
                ),
              ),
            ],
          ),
          VBox(
            style: HotProductStyle.infoArea,
            children: [
              StyledText(product.title, style: HotProductStyle.title),
              StyledText(product.brandName, style: HotProductStyle.brandName),
              Box(style: HotProductStyle.divider),
              Align(
                alignment: Alignment.centerRight,
                child: StyledText(
                  '¥${product.price.toStringAsFixed(0)}',
                  style: HotProductStyle.price,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SmallCard extends StatelessWidget {
  final ProductModel product;

  const _SmallCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return Box(
      style: HotProductStyle.smallCard,
      child: HBox(
        children: [
          Box(
            style: HotProductStyle.smallImage,
            child: CustomImage(imageUrl: product.thumb, aspectRatio: 1.0),
          ),
          Expanded(
            child: VBox(
              style: HotProductStyle.infoArea,
              children: [
                StyledText(product.title, style: HotProductStyle.titleSmall),
                StyledText(product.brandName, style: HotProductStyle.brandName),
                Box(style: HotProductStyle.divider),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: StyledText(
                      '¥${product.price.toStringAsFixed(0)}',
                      style: HotProductStyle.priceSmall,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
