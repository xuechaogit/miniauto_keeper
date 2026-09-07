// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'car_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CarModel _$CarModelFromJson(Map<String, dynamic> json) => CarModel(
  id: (json['id'] as num?)?.toInt() ?? 0,
  name: json['name'] as String? ?? '',
  description: json['description'] as String? ?? '',
  realCarName: json['real_car_name'] as String? ?? '',
  brandId: (json['brand_id'] as num?)?.toInt() ?? 0,
  brand: json['brand'] == null
      ? const CatalogBrand()
      : CatalogBrand.fromJson(json['brand'] as Map<String, dynamic>),
  seriesId: (json['series_id'] as num?)?.toInt() ?? 0,
  series: json['series'] == null
      ? const Series()
      : Series.fromJson(json['series'] as Map<String, dynamic>),
  realCarBrandId: (json['real_car_brand_id'] as num?)?.toInt() ?? 0,
  modelNumber: json['model_number'] as String? ?? '',
  scale: json['scale'] as String? ?? '',
  material: json['material'] as String? ?? '',
  color: json['color'] as String? ?? '',
  sizeLength: (json['size_length'] as num?)?.toDouble(),
  sizeWidth: (json['size_width'] as num?)?.toDouble(),
  sizeHeight: (json['size_height'] as num?)?.toDouble(),
  weightGrams: (json['weight_grams'] as num?)?.toInt(),
  packaging: json['packaging'] as String? ?? '',
  coverImage: json['cover_image'] as String? ?? '',
  releaseDate: json['release_date'] as String? ?? '',
  releasePrice: json['release_price'] as String? ?? '',
  marketPrice: json['market_price'] as String? ?? '',
  isLimited: json['is_limited'] == null
      ? false
      : CarModel._boolFromInt(json['is_limited']),
  limitedQuantity: (json['limited_quantity'] as num?)?.toInt(),
  realCarYear: (json['real_car_year'] as num?)?.toInt(),
  status: (json['status'] as num?)?.toInt() ?? 1,
  hotScore: (json['hot_score'] as num?)?.toInt() ?? 0,
  viewCount: (json['view_count'] as num?)?.toInt() ?? 0,
  images:
      (json['images'] as List<dynamic>?)
          ?.map((e) => ModelImage.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  specs:
      (json['specs'] as List<dynamic>?)
          ?.map((e) => ModelSpec.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  tags:
      (json['tags'] as List<dynamic>?)
          ?.map((e) => ModelTag.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  createdAt: json['created_at'] as String? ?? '',
);

Map<String, dynamic> _$CarModelToJson(CarModel instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'real_car_name': instance.realCarName,
  'brand_id': instance.brandId,
  'brand': instance.brand.toJson(),
  'series_id': instance.seriesId,
  'series': instance.series.toJson(),
  'real_car_brand_id': instance.realCarBrandId,
  'model_number': instance.modelNumber,
  'scale': instance.scale,
  'material': instance.material,
  'color': instance.color,
  'size_length': instance.sizeLength,
  'size_width': instance.sizeWidth,
  'size_height': instance.sizeHeight,
  'weight_grams': instance.weightGrams,
  'packaging': instance.packaging,
  'cover_image': instance.coverImage,
  'release_date': instance.releaseDate,
  'release_price': instance.releasePrice,
  'market_price': instance.marketPrice,
  'is_limited': instance.isLimited,
  'limited_quantity': instance.limitedQuantity,
  'real_car_year': instance.realCarYear,
  'status': instance.status,
  'hot_score': instance.hotScore,
  'view_count': instance.viewCount,
  'images': instance.images.map((e) => e.toJson()).toList(),
  'specs': instance.specs.map((e) => e.toJson()).toList(),
  'tags': instance.tags.map((e) => e.toJson()).toList(),
  'created_at': instance.createdAt,
};

ModelImage _$ModelImageFromJson(Map<String, dynamic> json) => ModelImage(
  id: (json['id'] as num?)?.toInt() ?? 0,
  imageUrl: json['image_url'] as String? ?? '',
  thumbUrl: json['thumb_url'] as String? ?? '',
  imageType: json['image_type'] as String? ?? '',
  sortOrder: (json['sort_order'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$ModelImageToJson(ModelImage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'image_url': instance.imageUrl,
      'thumb_url': instance.thumbUrl,
      'image_type': instance.imageType,
      'sort_order': instance.sortOrder,
    };

ModelSpec _$ModelSpecFromJson(Map<String, dynamic> json) => ModelSpec(
  id: (json['id'] as num?)?.toInt() ?? 0,
  specGroup: json['spec_group'] as String? ?? '',
  specKey: json['spec_key'] as String? ?? '',
  specValue: json['spec_value'] as String? ?? '',
  sortOrder: (json['sort_order'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$ModelSpecToJson(ModelSpec instance) => <String, dynamic>{
  'id': instance.id,
  'spec_group': instance.specGroup,
  'spec_key': instance.specKey,
  'spec_value': instance.specValue,
  'sort_order': instance.sortOrder,
};

ModelTag _$ModelTagFromJson(Map<String, dynamic> json) => ModelTag(
  id: (json['id'] as num?)?.toInt() ?? 0,
  name: json['name'] as String? ?? '',
  group: json['group'] as String? ?? '',
  sortOrder: (json['sort_order'] as num?)?.toInt() ?? 0,
  createdAt: json['created_at'] as String? ?? '',
  updatedAt: json['updated_at'] as String? ?? '',
);

Map<String, dynamic> _$ModelTagToJson(ModelTag instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'group': instance.group,
  'sort_order': instance.sortOrder,
  'created_at': instance.createdAt,
  'updated_at': instance.updatedAt,
};
