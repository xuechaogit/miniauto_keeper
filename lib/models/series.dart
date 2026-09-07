import 'package:json_annotation/json_annotation.dart';
import 'package:miniauto_keeper/models/catalog_brand.dart';

part 'series.g.dart';

@JsonSerializable()
class Series {
  final int id;
  final String name;
  final String thumb;
  final String price;
  final String description;
  final int brandId;
  final CatalogBrand brand;
  final int sortOrder;
  final int status;
  final String createdAt;
  final String updatedAt;

  const Series({
    this.id = 0,
    this.name = '',
    this.thumb = '',
    this.price = '',
    this.description = '',
    this.brandId = 0,
    this.brand = const CatalogBrand(),
    this.sortOrder = 0,
    this.status = 1,
    this.createdAt = '',
    this.updatedAt = '',
  });

  factory Series.fromJson(Map<String, dynamic> json) => _$SeriesFromJson(json);

  Map<String, dynamic> toJson() => _$SeriesToJson(this);
}
