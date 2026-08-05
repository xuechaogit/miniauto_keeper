import 'wishlist_item.dart';

class ProductListData {
  final int page;
  final int total;
  final List<ProductModel> list;

  ProductListData({
    required this.page,
    required this.total,
    required this.list,
  });

  factory ProductListData.fromJson(Map<String, dynamic> json) {
    return ProductListData(
      page: json['page'] ?? 1,
      total: json['total'] ?? 0,
      list:
          (json['list'] as List?)
              ?.map((e) => ProductModel.fromJson(e))
              .toList() ??
          [],
    );
  }
}

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
  final String code;
  final String dash;

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
    this.code = '',
    this.dash = '',
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      brandName: json['brandName'] ?? '',
      price: double.tryParse('${json['price'] ?? ''}') ?? 0.0,
      thumb: json['thumb'] ?? '',
      tags: json['tags'] ?? [],
      purchaseDate: json['purchaseDate'] ?? '',
      description: json['description'] ?? '',
      releaseDate: json['ship_at']?.toString() ?? '',
      code: json['code'] ?? '',
      dash: json['dash'] ?? '',
    );
  }

  WishlistItem toWishlistItem() {
    return WishlistItem(
      id: id,
      productId: id,
      title: title,
      thumb: thumb,
      price: price,
      brandName: brandName,
      addedAt: DateTime.now().millisecondsSinceEpoch,
    );
  }
}
