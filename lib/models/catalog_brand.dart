import 'package:json_annotation/json_annotation.dart';

part 'catalog_brand.g.dart';

@JsonSerializable()
class CatalogBrand {
  final int id;
  final String name;
  final String description;
  final String logoUrl;
  final String country;
  final int sortOrder;

  const CatalogBrand({
    this.id = 0,
    this.name = '',
    this.description = '',
    this.logoUrl = '',
    this.country = '',
    this.sortOrder = 0,
  });

  factory CatalogBrand.fromJson(Map<String, dynamic> json) =>
      _$CatalogBrandFromJson(json);

  Map<String, dynamic> toJson() => _$CatalogBrandToJson(this);
}
