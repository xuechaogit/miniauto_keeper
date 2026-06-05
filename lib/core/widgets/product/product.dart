import 'package:flutter/material.dart';
import '../../../models/product_model.dart';
import 'widgets/product_grid_layout.dart';
import 'widgets/product_list_layout.dart';

class ProductItem extends StatelessWidget {
  final bool isListMode;
  final ProductModel product;
  final Widget? details;

  const ProductItem(
    this.product, {
    super.key,
    this.isListMode = false,
    this.details,
  });

  @override
  Widget build(BuildContext context) {
    // 根据模式返回不同的布局 Widget
    // 这样即便以后 List 和 Grid 的结构天差地别，代码也非常易于维护
    return isListMode
        ? ProductListLayout(product, details: details)
        : ProductGridLayout(product, details: details);
  }
}
