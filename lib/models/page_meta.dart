import 'package:json_annotation/json_annotation.dart';

part 'page_meta.g.dart';

/// 通用分页元数据（后端 meta 字段为 camelCase，各接口复用）
@JsonSerializable()
class PageMeta {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  const PageMeta({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  factory PageMeta.fromJson(Map<String, dynamic> json) => _$PageMetaFromJson(json);

  Map<String, dynamic> toJson() => _$PageMetaToJson(this);
}
