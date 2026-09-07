import 'package:json_annotation/json_annotation.dart';

import '../car_model.dart';
import '../page_meta.dart';

part 'car_list_envelope.g.dart';

/// 车模列表接口返回值：data 列表本体 + 通用分页 meta
///
/// 对应拦截器剥壳后的 envelope 结构 { data, meta }。
@JsonSerializable()
class CarListEnvelope {
  final List<CarModel> data;
  final PageMeta? meta;

  const CarListEnvelope({required this.data, this.meta});

  factory CarListEnvelope.fromJson(Map<String, dynamic> json) =>
      _$CarListEnvelopeFromJson(json);

  Map<String, dynamic> toJson() => _$CarListEnvelopeToJson(this);
}
