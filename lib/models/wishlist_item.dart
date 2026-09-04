import 'package:hive/hive.dart';

import '../core/services/hive_type_ids.dart';

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

/// WishlistItem 手写 TypeAdapter（hive_generator 已移除，改手写避免依赖 .g.dart）
class WishlistItemAdapter extends TypeAdapter<WishlistItem> {
  @override
  final int typeId = HiveTypeIds.wishlistItem;

  @override
  WishlistItem read(BinaryReader reader) {
    final double originalPrice = reader.readDouble();
    final String note = reader.readString();
    return WishlistItem(
      id: reader.readString(),
      productId: reader.readString(),
      title: reader.readString(),
      thumb: reader.readString(),
      price: reader.readDouble(),
      originalPrice: originalPrice == -1 ? null : originalPrice,
      addedAt: reader.readInt(),
      priority: reader.readInt(),
      note: note.isEmpty ? null : note,
      brandName: reader.readString(),
    );
  }

  @override
  void write(BinaryWriter writer, WishlistItem obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.productId);
    writer.writeString(obj.title);
    writer.writeString(obj.thumb);
    writer.writeDouble(obj.price);
    writer.writeDouble(obj.originalPrice ?? -1);
    writer.writeInt(obj.addedAt);
    writer.writeInt(obj.priority);
    writer.writeString(obj.note ?? '');
    writer.writeString(obj.brandName);
  }
}
