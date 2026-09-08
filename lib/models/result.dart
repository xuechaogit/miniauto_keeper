import 'package:json_annotation/json_annotation.dart';
import 'package:miniauto_keeper/models/page_meta.dart';

part 'result.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class Result<T> {
  const Result({
    required this.code,
    required this.message,
    this.data,
    this.meta,
  });

  final int code;
  final String message;
  final T? data;
  final PageMeta? meta;

  factory Result.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) => _$ResultFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      _$ResultToJson(this, toJsonT);
}
