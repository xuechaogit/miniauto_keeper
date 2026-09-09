// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'garage_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GarageItem _$GarageItemFromJson(Map<String, dynamic> json) => GarageItem(
  id: (json['id'] as num?)?.toInt() ?? 0,
  modelId: (json['model_id'] as num?)?.toInt() ?? 0,
  model: json['model'] == null
      ? const CarModel()
      : CarModel.fromJson(json['model'] as Map<String, dynamic>),
  purchaseDate: json['purchase_date'] as String? ?? '',
  purchasePrice: json['purchase_price'] as String? ?? '',
  purchaseChannel: json['purchase_channel'] as String? ?? '',
  condition: (json['condition'] as num?)?.toInt() ?? 0,
  styleNote: json['style_note'] as String?,
  customTag: json['custom_tag'] as String?,
  notes: json['notes'] as String?,
  isPublic: json['is_public'] == null
      ? false
      : GarageItem._boolFromInt(json['is_public']),
  createdAt: json['created_at'] as String? ?? '',
);

Map<String, dynamic> _$GarageItemToJson(GarageItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'model_id': instance.modelId,
      'model': instance.model.toJson(),
      'purchase_date': instance.purchaseDate,
      'purchase_price': instance.purchasePrice,
      'purchase_channel': instance.purchaseChannel,
      'condition': instance.condition,
      'style_note': instance.styleNote,
      'custom_tag': instance.customTag,
      'notes': instance.notes,
      'is_public': instance.isPublic,
      'created_at': instance.createdAt,
    };

GarageAddRequest _$GarageAddRequestFromJson(Map<String, dynamic> json) =>
    GarageAddRequest(
      modelId: (json['model_id'] as num?)?.toInt() ?? 0,
      purchaseDate: json['purchase_date'] as String? ?? '',
      purchasePrice: (json['purchase_price'] as num?)?.toDouble() ?? 0,
      purchaseChannel: json['purchase_channel'] as String? ?? '',
      condition: (json['condition'] as num?)?.toInt() ?? 0,
      styleNote: json['style_note'] as String?,
      customTag: json['custom_tag'] as String?,
      notes: json['notes'] as String?,
      isPublic: json['is_public'] == null
          ? true
          : GarageAddRequest._boolFromJson(json['is_public']),
    );

Map<String, dynamic> _$GarageAddRequestToJson(GarageAddRequest instance) =>
    <String, dynamic>{
      'model_id': instance.modelId,
      'purchase_date': instance.purchaseDate,
      'purchase_price': instance.purchasePrice,
      'purchase_channel': instance.purchaseChannel,
      'condition': instance.condition,
      'style_note': instance.styleNote,
      'custom_tag': instance.customTag,
      'notes': instance.notes,
      'is_public': GarageAddRequest._boolToInt(instance.isPublic),
    };
