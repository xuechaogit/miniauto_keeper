import 'package:json_annotation/json_annotation.dart';

import 'car_model.dart';

part 'garage_item.g.dart';

/// 车库条目（对应接口 /garage）
///
/// - model 直接复用 CarModel：车库接口返回的 model 对象结构与 catalog 的
///   车模对象一致，CarModel 按 snake_case 解析且缺失字段有默认值兜底，
///   故可安全复用，无需新建车模模型
/// - purchasePrice 后端为字符串（如 "129.00"），保留 String 展示，需要计算时再 parse
/// - isPublic 后端为 0/1 整数，通过 [GarageItem._boolFromInt] 转 bool
@JsonSerializable()
class GarageItem {
  final int id;
  final int modelId;
  final CarModel model;
  final String purchaseDate;
  final String purchasePrice;
  final String purchaseChannel;
  final int condition; // 1全新 2近新 3有瑕疵 4破损
  final String? styleNote;
  final String? customTag;
  final String? notes;
  @JsonKey(fromJson: _boolFromInt)
  final bool isPublic;
  final String createdAt;

  const GarageItem({
    this.id = 0,
    this.modelId = 0,
    this.model = const CarModel(),
    this.purchaseDate = '',
    this.purchasePrice = '',
    this.purchaseChannel = '',
    this.condition = 0,
    this.styleNote,
    this.customTag,
    this.notes,
    this.isPublic = false,
    this.createdAt = '',
  });

  factory GarageItem.fromJson(Map<String, dynamic> json) =>
      _$GarageItemFromJson(json);

  Map<String, dynamic> toJson() => _$GarageItemToJson(this);

  static bool _boolFromInt(dynamic v) => v == 1 || v == true;
}

/// 加入车库请求体
///
/// - 与列表返回不同，请求的 purchase_price 为数字（后端示例 129）
/// - toJson 统一转 snake_case，isPublic 转 0/1 整数（见 [_boolToInt]）
@JsonSerializable()
class GarageAddRequest {
  final int modelId;
  final String purchaseDate;
  final double purchasePrice;
  final String purchaseChannel;
  final int condition;
  final String? styleNote;
  final String? customTag;
  final String? notes;
  @JsonKey(fromJson: _boolFromJson, toJson: _boolToInt)
  final bool isPublic;

  const GarageAddRequest({
    this.modelId = 0,
    this.purchaseDate = '',
    this.purchasePrice = 0,
    this.purchaseChannel = '',
    this.condition = 0,
    this.styleNote,
    this.customTag,
    this.notes,
    this.isPublic = true,
  });

  factory GarageAddRequest.fromJson(Map<String, dynamic> json) =>
      _$GarageAddRequestFromJson(json);

  Map<String, dynamic> toJson() => _$GarageAddRequestToJson(this);

  static bool _boolFromJson(dynamic v) => v == 1 || v == true;

  static int _boolToInt(bool v) => v ? 1 : 0;
}
