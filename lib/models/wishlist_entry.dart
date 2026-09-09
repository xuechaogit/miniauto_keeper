import 'package:json_annotation/json_annotation.dart';

import 'car_model.dart';

part 'wishlist_entry.g.dart';

/// 心愿单条目网络模型（对应接口 /wishlist）
///

///   字段结构完全不同，二者不可混用；
/// - model 复用 [CarModel]：后端心愿单项内嵌 model 对象与 catalog/garage 一致，
///   缺失字段由 CarModel 默认值兜底，可安全复用；
/// - id / userId / modelId / priority / createdAt / updatedAt 等 snake_case
///   由 build.yaml 的 field_rename: snake 自动映射，无需手写 @JsonKey。
@JsonSerializable()
class WishlistEntry {
  final int id;
  final int userId;
  final int modelId;
  final int priority;
  final String? notes;
  final String createdAt;
  final String updatedAt;
  final CarModel model;

  const WishlistEntry({
    this.id = 0,
    this.userId = 0,
    this.modelId = 0,
    this.priority = 0,
    this.notes,
    this.createdAt = '',
    this.updatedAt = '',
    this.model = const CarModel(),
  });

  factory WishlistEntry.fromJson(Map<String, dynamic> json) =>
      _$WishlistEntryFromJson(json);

  Map<String, dynamic> toJson() => _$WishlistEntryToJson(this);
}

/// 加入心愿单请求体
///
/// 后端未给出明确入参，按常规 REST 约定推断：
/// - modelId：车模 id，必填
/// - priority：优先级，可选（返回结构中存在该字段，推测可作为可选入参）
/// - notes：备注，可选（如上）
/// 若实际字段不同，按后端文档在本类中调整即可（snake_case 自动映射）。
@JsonSerializable()
class WishlistAddRequest {
  final int modelId;
  final int? priority;
  final String? notes;

  const WishlistAddRequest({
    this.modelId = 0,
    this.priority = 1,
    this.notes = '',
  });

  factory WishlistAddRequest.fromJson(Map<String, dynamic> json) =>
      _$WishlistAddRequestFromJson(json);

  Map<String, dynamic> toJson() => _$WishlistAddRequestToJson(this);
}
