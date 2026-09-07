import 'package:flutter/material.dart';
import 'package:miniauto_keeper/models/car_model.dart';

import 'widgets/product_grid_layout.dart';
import 'widgets/product_list_layout.dart';

class ProductItem extends StatelessWidget {
  final bool isListMode;
  final CarModel product;
  final Widget? details;
  final Widget? actionBar;
  final VoidCallback? onTap;

  const ProductItem(
    this.product, {
    super.key,
    this.isListMode = false,
    this.details,
    this.actionBar,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return isListMode
        ? ProductListLayout(product, details: details, actionBar: actionBar)
        : ProductGridLayout(
            product,
            details: details,
            actionBar: actionBar,
            onTap: onTap,
          );
  }
}
