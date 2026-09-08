// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Result<T> _$ResultFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) => Result<T>(
  code: (json['code'] as num).toInt(),
  message: json['message'] as String,
  data: _$nullableGenericFromJson(json['data'], fromJsonT),
  meta: json['meta'] == null
      ? null
      : PageMeta.fromJson(json['meta'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ResultToJson<T>(
  Result<T> instance,
  Object? Function(T value) toJsonT,
) => <String, dynamic>{
  'code': instance.code,
  'message': instance.message,
  'data': _$nullableGenericToJson(instance.data, toJsonT),
  'meta': instance.meta?.toJson(),
};

T? _$nullableGenericFromJson<T>(
  Object? input,
  T Function(Object? json) fromJson,
) => input == null ? null : fromJson(input);

Object? _$nullableGenericToJson<T>(
  T? input,
  Object? Function(T value) toJson,
) => input == null ? null : toJson(input);
