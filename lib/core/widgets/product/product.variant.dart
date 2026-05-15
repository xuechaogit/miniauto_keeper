import 'package:mix/mix.dart';

class ProductMode extends Variant {
  const ProductMode._(super.name);
  static const listMode = ProductMode._('product.list.mode');
  static const gridMode = ProductMode._('product.grid.mode');
}
