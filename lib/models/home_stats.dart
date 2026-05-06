class HomeStats {
  final int totalCars;
  final int recentAdded;

  HomeStats({required this.totalCars, required this.recentAdded});

  // 从 JSON 转换的工厂方法
  factory HomeStats.fromJson(Map<String, dynamic> json) {
    return HomeStats(
      totalCars: json['total_cars'] ?? 0,
      recentAdded: json['recent_added'] ?? 0,
    );
  }
}
