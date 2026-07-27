import 'package:flutter/material.dart';
import 'package:miniauto_keeper/core/utils/screen_adapter.dart';
import 'package:mix/mix.dart';
import '../../../../models/product_model.dart';
import '../../image/image.dart';
import '../product.style.dart';
import '../product.variant.dart';

class ProductListLayout extends StatelessWidget {
  final ProductModel product;
  final Widget? details;

  const ProductListLayout(this.product, {super.key, this.details});

  @override
  Widget build(BuildContext context) {
    // 应用 listMode 变体
    final style = ProductStyle.container.applyVariant(ProductMode.listMode);

    return Box(
      style: style,
      child: HBox(
        style: Style($flex.gap(12), $flex.crossAxisAlignment.start()),
        children: [
          // 图片
          Box(
            style: Style($box.width(w(100)), $box.height(w(100))),
            child: CustomImage(imageUrl: product.thumb, aspectRatio: 1),
          ),

          // 右侧内容
          Expanded(
            child:
                details ??
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.brandName,
                      style: TextStyle(
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: sp(12),
                      ),
                    ),
                    StyledText(
                      product.title,
                      style: ProductStyle.title.applyVariant(
                        ProductMode.listMode,
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
