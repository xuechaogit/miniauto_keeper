// lib/models/home_stats.dart

import 'package:miniauto_keeper/models/car_model.dart';

import 'brand_model.dart';

class PreList {
  final List<CarModel> products;
  final String title;

  PreList({required this.products, required this.title});

  factory PreList.fromJson(Map<String, dynamic> json) {
    return PreList(
      products: (json['items'] as List? ?? [])
          .map((e) => CarModel.fromJson(e))
          .toList(),
      title: json['title'] ?? '',
    );
  }
}

class ItemData {
  final PreList preList;
  final PreList recList;

  ItemData({required this.preList, required this.recList});

  factory ItemData.fromJson(Map<String, dynamic> json) {
    return ItemData(
      preList: PreList.fromJson(json['preList']),
      recList: PreList.fromJson(json['recList']),
    );
  }
}

class HomeStats {
  final ItemData itemData;
  final int code;
  final String message;
  final int totalCars;
  final int recentAdded;
  final List<BrandModel> brands;

  HomeStats({
    required this.code,
    required this.message,
    required this.itemData,
    required this.recentAdded,
    required this.totalCars,
    required this.brands,
  });

  factory HomeStats.fromJson(Map<String, dynamic> json) {
    final itemDataJson = json['itemData'];
    return HomeStats(
      totalCars: json['total_cars'] ?? 0,
      recentAdded: json['recent_added'] ?? 0,
      code: json['code'] ?? 0,
      message: json['message'] ?? '',
      itemData: itemDataJson != null
          ? ItemData.fromJson(itemDataJson)
          : ItemData(
              preList: PreList(products: [], title: ''),
              recList: PreList(products: [], title: ''),
            ),
      brands:
          (json['categoryData']?['level-2'] as List?)
              ?.map((e) => BrandModel.fromJson(e))
              .toList() ??
          [],
    );
  }
}
