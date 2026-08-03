import 'package:flutter/material.dart';
import '../../../models/product_model.dart';
import 'widgets/product_grid_layout.dart';
import 'widgets/product_list_layout.dart';

class ProductItem extends StatelessWidget {
  final bool isListMode;
  final ProductModel product;
  final Widget? details;
  final VoidCallback? onTap;

  const ProductItem(
    this.product, {
    super.key,
    this.isListMode = false,
    this.details,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return isListMode
        ? ProductListLayout(product, details: details)
        : ProductGridLayout(product, details: details, onTap: onTap);
  }
}
