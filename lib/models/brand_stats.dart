import 'package:flutter/material.dart';

class BrandModel {
  final String name;
  final int collectedCount;
  final int totalCount; // 总收录数
  final String? tag; // 标签：HOT, NEW, LIMITED
  final Color? themeColor; // 品牌主色调（可选，用于进度条或装饰）
  final String category; // 类别：JDM, Euro, Racing 等

  BrandModel({
    required this.name,
    this.collectedCount = 0,
    this.totalCount = 0,
    this.tag,
    this.themeColor,
    this.category = 'Standard',
  });

  // 计算百分比的辅助属性
  double get progress => totalCount > 0 ? collectedCount / totalCount : 0.0;
}
