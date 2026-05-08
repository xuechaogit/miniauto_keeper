// lib/models/product_model.dart
class ProductModel {
  final String id;
  final String title;
  final String brandName;
  final double price;
  final String imageUrl;
  final List<String> tags; // 比如：1:18, Limited, Diecast
  final String description;

  ProductModel({
    required this.id,
    required this.title,
    required this.brandName,
    required this.price,
    required this.imageUrl,
    required this.tags,
    this.description = '',
  });
}
