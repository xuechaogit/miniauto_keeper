import 'package:flutter/material.dart';
import 'package:miniauto_keeper/models/car_model.dart';

import 'package:mix/mix.dart';

import '../../image/image.dart';
import '../product.style.dart';
import '../product.variant.dart';

class ProductListLayout extends StatelessWidget {
  final CarModel product;
  final Widget? details;
  final Widget? actionBar;

  const ProductListLayout(
    this.product, {
    super.key,
    this.details,
    this.actionBar,
  });

  @override
  Widget build(BuildContext context) {
    // 应用 listMode 变体
    final style = ProductStyle.container.applyVariant(ProductMode.listMode);

    return Box(
      style: style,
      child: HBox(
        style: ProductStyle.listGap,
        children: [
          // 图片
          Box(
            style: ProductStyle.image.applyVariant(ProductMode.listMode),
            child: CustomImage(imageUrl: product.coverImage, aspectRatio: 1),
          ),

          // 右侧内容
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                details ??
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        StyledText(
                          product.brand.name,
                          style: ProductStyle.brandName,
                        ),
                        StyledText(
                          product.name,
                          style: ProductStyle.title.applyVariant(
                            ProductMode.listMode,
                          ),
                        ),
                      ],
                    ),
                ?actionBar,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
