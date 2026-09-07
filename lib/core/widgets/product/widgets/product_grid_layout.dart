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
          // 图片
          GestureDetector(
            onTap: onTap,
            child: Box(
              style: ProductStyle.image.applyVariant(ProductMode.gridMode),
              child: CustomImage(imageUrl: product.coverImage, aspectRatio: 1),
            ),
          ),

          // title area
          details ??
              GestureDetector(
                onTap: onTap,
                child: Box(
                  style: Style($box.height(sp(40))),
                  child: StyledText(
                    product.name,
                    style: ProductStyle.title.applyVariant(
                      ProductMode.gridMode,
                    ),
                  ),
                ),
              ),

          // action bar (optional, controlled by caller)
          if (actionBar != null) actionBar!,
        ],
      ),
    );
  }
}
