import 'package:json_annotation/json_annotation.dart';

import 'catalog_brand.dart';
import 'series.dart';

part 'car_model.g.dart';

/// 车模实体（对应接口 /models 系列）
///
/// - brand / series 复用现有 CatalogBrand、Series
/// - 价格字段（releasePrice / marketPrice）后端为字符串，按 String 处理，需要计算时再 parse
/// - isLimited 后端为 0/1 整数，通过 [CarModel._boolFromInt] 转 bool
@JsonSerializable()
class CarModel {
  final int id;
  final String name;
  final String description;
  final String realCarName;
  final int brandId;
  final CatalogBrand brand;
  final int seriesId;
  final Series series;
  final int realCarBrandId;
  final String modelNumber;
  final String scale;
  final String material;
  final String color;
  final double? sizeLength;
  final double? sizeWidth;
  final double? sizeHeight;
  final int? weightGrams;
  final String packaging;
  final String coverImage;
  final String releaseDate;
  final String releasePrice;
  final String marketPrice;
  @JsonKey(fromJson: _boolFromInt)
  final bool isLimited;
  final int? limitedQuantity;
  final int? realCarYear;
  final int status;
  final int hotScore;
  final int viewCount;
  final List<ModelImage> images;
  final List<ModelSpec> specs;
  final List<ModelTag> tags;
  final String createdAt;

  const CarModel({
    this.id = 0,
    this.name = '',
    this.description = '',
    this.realCarName = '',
    this.brandId = 0,
    this.brand = const CatalogBrand(),
    this.seriesId = 0,
    this.series = const Series(),
    this.realCarBrandId = 0,
    this.modelNumber = '',
    this.scale = '',
    this.material = '',
    this.color = '',
    this.sizeLength,
    this.sizeWidth,
    this.sizeHeight,
    this.weightGrams,
    this.packaging = '',
    this.coverImage = '',
    this.releaseDate = '',
    this.releasePrice = '',
    this.marketPrice = '',
    this.isLimited = false,
    this.limitedQuantity,
    this.realCarYear,
    this.status = 1,
    this.hotScore = 0,
    this.viewCount = 0,
    this.images = const [],
    this.specs = const [],
    this.tags = const [],
    this.createdAt = '',
  });

  factory CarModel.fromJson(Map<String, dynamic> json) =>
      _$CarModelFromJson(json);

  Map<String, dynamic> toJson() => _$CarModelToJson(this);

  static bool _boolFromInt(dynamic v) => v == 1 || v == true;
}

/// 车模图片
@JsonSerializable()
class ModelImage {
  final int id;
  final String imageUrl;
  final String thumbUrl;
  final String imageType;
  final int sortOrder;

  const ModelImage({
    this.id = 0,
    this.imageUrl = '',
    this.thumbUrl = '',
    this.imageType = '',
    this.sortOrder = 0,
  });

  factory ModelImage.fromJson(Map<String, dynamic> json) =>
      _$ModelImageFromJson(json);

  Map<String, dynamic> toJson() => _$ModelImageToJson(this);
}

/// 车模规格项
@JsonSerializable()
class ModelSpec {
  final int id;
  final String specGroup;
  final String specKey;
  final String specValue;
  final int sortOrder;

  const ModelSpec({
    this.id = 0,
    this.specGroup = '',
    this.specKey = '',
    this.specValue = '',
    this.sortOrder = 0,
  });

  factory ModelSpec.fromJson(Map<String, dynamic> json) =>
      _$ModelSpecFromJson(json);

  Map<String, dynamic> toJson() => _$ModelSpecToJson(this);
}

/// 车模标签
@JsonSerializable()
class ModelTag {
  final int id;
  final String name;
  final String group;
  final int sortOrder;
  final String createdAt;
  final String updatedAt;

  const ModelTag({
    this.id = 0,
    this.name = '',
    this.group = '',
    this.sortOrder = 0,
    this.createdAt = '',
    this.updatedAt = '',
  });

  factory ModelTag.fromJson(Map<String, dynamic> json) =>
      _$ModelTagFromJson(json);

  Map<String, dynamic> toJson() => _$ModelTagToJson(this);
}
