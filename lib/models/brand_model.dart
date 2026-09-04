import 'package:hive/hive.dart';

import '../core/services/hive_type_ids.dart';

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

/// BrandModel 手写 TypeAdapter（hive_generator 已移除，改手写避免依赖 .g.dart）
class BrandModelAdapter extends TypeAdapter<BrandModel> {
  @override
  final int typeId = HiveTypeIds.brandModel;

  @override
  BrandModel read(BinaryReader reader) => BrandModel(
        id: reader.readInt(),
        pid: reader.readInt(),
        name: reader.readString(),
        thumb: reader.readString(),
      );

  @override
  void write(BinaryWriter writer, BrandModel obj) {
    writer.writeInt(obj.id);
    writer.writeInt(obj.pid);
    writer.writeString(obj.name);
    writer.writeString(obj.thumb);
  }
}
