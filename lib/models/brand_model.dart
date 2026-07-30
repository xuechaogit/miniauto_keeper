import 'package:hive/hive.dart';

import '../core/services/hive_type_ids.dart';

part 'brand_model.g.dart';

@HiveType(typeId: HiveTypeIds.brandModel)
class BrandModel {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final int pid;
  @HiveField(2)
  final String name;
  @HiveField(3)
  final String thumb;

  BrandModel({
    required this.id,
    required this.pid,
    required this.name,
    required this.thumb,
  });

  factory BrandModel.fromJson(Map<String, dynamic> json) {
    return BrandModel(
      id: json['id'] ?? 0,
      pid: json['pid'] ?? 0,
      name: json['name'] ?? '',
      thumb: json['thumb'] ?? '',
    );
  }
}
