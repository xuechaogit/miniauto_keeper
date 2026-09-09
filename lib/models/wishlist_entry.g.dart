// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wishlist_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WishlistEntry _$WishlistEntryFromJson(Map<String, dynamic> json) =>
    WishlistEntry(
      id: (json['id'] as num?)?.toInt() ?? 0,
      userId: (json['user_id'] as num?)?.toInt() ?? 0,
      modelId: (json['model_id'] as num?)?.toInt() ?? 0,
      priority: (json['priority'] as num?)?.toInt() ?? 0,
      notes: json['notes'] as String?,
      createdAt: json['created_at'] as String? ?? '',
      updatedAt: json['updated_at'] as String? ?? '',
      model: json['model'] == null
          ? const CarModel()
          : CarModel.fromJson(json['model'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$WishlistEntryToJson(WishlistEntry instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'model_id': instance.modelId,
      'priority': instance.priority,
      'notes': instance.notes,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'model': instance.model.toJson(),
    };

WishlistAddRequest _$WishlistAddRequestFromJson(Map<String, dynamic> json) =>
    WishlistAddRequest(
      modelId: (json['model_id'] as num?)?.toInt() ?? 0,
      priority: (json['priority'] as num?)?.toInt(),
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$WishlistAddRequestToJson(WishlistAddRequest instance) =>
    <String, dynamic>{
      'model_id': instance.modelId,
      'priority': instance.priority,
      'notes': instance.notes,
    };
