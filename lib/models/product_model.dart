class ProductModel {
  final String id;
  final String title;
  final String brandName;
  final double price;
  final String thumb;
  final List<String> tags; // 比如：1:18, Limited, Diecast
  final String description;
  final String purchaseDate;
  final String? releaseDate; // 新品发售日期

  ProductModel({
    required this.id,
    required this.title,
    required this.brandName,
    required this.price,
    required this.thumb,
    required this.tags,
    this.purchaseDate = '',
    this.description = '',
    this.releaseDate,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      brandName: json['brandName'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      thumb: json['thumb'] ?? '',
      tags: json['tags'] ?? [],
      purchaseDate: json['purchaseDate'] ?? '',
      description: json['description'] ?? '',
      releaseDate: json['ship_at']?.toString() ?? '',
    );
  }
}
