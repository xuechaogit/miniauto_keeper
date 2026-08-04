import 'package:hive/hive.dart';

import '../core/services/hive_type_ids.dart';

part 'wishlist_item.g.dart';

@HiveType(typeId: HiveTypeIds.wishlistItem)
class WishlistItem {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String productId;
  @HiveField(2)
  final String title;
  @HiveField(3)
  final String thumb;
  @HiveField(4)
  final double price;
  @HiveField(5)
  final double? originalPrice;
  @HiveField(6)
  final int addedAt;
  @HiveField(7)
  final int priority;
  @HiveField(8)
  final String? note;
  @HiveField(9)
  final String brandName;

  WishlistItem({
    required this.id,
    required this.productId,
    required this.title,
    required this.thumb,
    required this.price,
    this.originalPrice,
    required this.addedAt,
    this.priority = 0,
    this.note,
    this.brandName = '',
  });

  factory WishlistItem.fromJson(Map<String, dynamic> json) {
    return WishlistItem(
      id: json['id']?.toString() ?? '',
      productId: json['productId']?.toString() ?? '',
      title: json['title'] ?? '',
      thumb: json['thumb'] ?? '',
      price: double.tryParse('${json['price'] ?? ''}') ?? 0.0,
      originalPrice: json['originalPrice'] != null
          ? double.tryParse('${json['originalPrice']}')
          : null,
      addedAt: int.tryParse('${json['addedAt'] ?? ''}') ??
          DateTime.now().millisecondsSinceEpoch,
      priority: int.tryParse('${json['priority'] ?? ''}') ?? 0,
      note: json['note'],
      brandName: json['brandName'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'title': title,
      'thumb': thumb,
      'price': price,
      'originalPrice': originalPrice,
      'addedAt': addedAt,
      'priority': priority,
      'note': note,
      'brandName': brandName,
    };
  }

  WishlistItem copyWith({
    String? id,
    String? productId,
    String? title,
    String? thumb,
    double? price,
    double? originalPrice,
    int? addedAt,
    int? priority,
    String? note,
    String? brandName,
  }) {
    return WishlistItem(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      title: title ?? this.title,
      thumb: thumb ?? this.thumb,
      price: price ?? this.price,
      originalPrice: originalPrice ?? this.originalPrice,
      addedAt: addedAt ?? this.addedAt,
      priority: priority ?? this.priority,
      note: note ?? this.note,
      brandName: brandName ?? this.brandName,
    );
  }
}
