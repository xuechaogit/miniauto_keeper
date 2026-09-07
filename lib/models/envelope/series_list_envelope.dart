import 'package:json_annotation/json_annotation.dart';
import 'package:miniauto_keeper/models/series.dart';

import '../page_meta.dart';

part 'series_list_envelope.g.dart';

/// 品牌列表接口返回值：data 列表本体 + 通用分页 meta
///
/// 对应拦截器剥壳后的 envelope 结构 { data, meta }。
@JsonSerializable()
class SeriesListEnvelope {
  final List<Series> data;
  final PageMeta? meta;

  const SeriesListEnvelope({required this.data, this.meta});

  factory SeriesListEnvelope.fromJson(Map<String, dynamic> json) =>
      _$SeriesListEnvelopeFromJson(json);

  Map<String, dynamic> toJson() => _$SeriesListEnvelopeToJson(this);
}
