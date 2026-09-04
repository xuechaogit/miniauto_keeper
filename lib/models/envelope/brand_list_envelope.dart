import 'package:json_annotation/json_annotation.dart';

import '../catalog_brand.dart';
import '../page_meta.dart';

part 'brand_list_envelope.g.dart';

/// 品牌列表接口返回值：data 列表本体 + 通用分页 meta
///
/// 对应拦截器剥壳后的 envelope 结构 { data, meta }。
@JsonSerializable()
class BrandListEnvelope {
  final List<CatalogBrand> data;
  final PageMeta? meta;

  const BrandListEnvelope({required this.data, this.meta});

  factory BrandListEnvelope.fromJson(Map<String, dynamic> json) =>
      _$BrandListEnvelopeFromJson(json);

  Map<String, dynamic> toJson() => _$BrandListEnvelopeToJson(this);
}
