import 'package:flutter/material.dart';
import 'package:mix/mix.dart';
import '../../../../models/product_model.dart';
import '../../../theme/app_theme.dart';
import '../../image/image.dart';
import '../product.style.dart';
import '../product.variant.dart';

class ProductGridLayout extends StatelessWidget {
  final ProductModel product;
  final Widget? details;

  const ProductGridLayout(this.product, {super.key, this.details});

  @override
  Widget build(BuildContext context) {
    // 应用 gridMode 变体
    final style = ProductStyle.container.applyVariant(ProductMode.gridMode);

    return Box(
      style: style,
      child: VBox(
        style: Style($flex.gap(8)),
        children: [
          // 图片
          ZBox(
            children: [
              CustomImage(
                imageUrl: product.imageUrl,
                aspectRatio: 1, // 如果后端有比例，可以传 item.width / item.height
                // borderRadius: 16, // 如果需要圆角
              ),
            ],
          ),

          ZBox(
            children: [
              details ??
                  StyledText(
                    product.title,
                    style: ProductStyle.title.applyVariant(
                      ProductMode.gridMode,
                    ),
                  ),
            ],
          ),
        ],
      ),
    );
  }
}
