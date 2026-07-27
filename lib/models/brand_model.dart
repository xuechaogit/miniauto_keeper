class BrandModel {
  final int id;
  final int pid;
  final String name;
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
