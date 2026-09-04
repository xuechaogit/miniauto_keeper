// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'page_meta.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PageMeta _$PageMetaFromJson(Map<String, dynamic> json) => PageMeta(
  currentPage: (json['current_page'] as num).toInt(),
  lastPage: (json['last_page'] as num).toInt(),
  perPage: (json['per_page'] as num).toInt(),
  total: (json['total'] as num).toInt(),
);

Map<String, dynamic> _$PageMetaToJson(PageMeta instance) => <String, dynamic>{
  'current_page': instance.currentPage,
  'last_page': instance.lastPage,
  'per_page': instance.perPage,
  'total': instance.total,
};
