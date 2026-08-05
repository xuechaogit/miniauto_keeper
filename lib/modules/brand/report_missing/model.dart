import 'dart:io';

import 'package:miniauto_keeper/models/brand_model.dart';

class ReportMissingForm {
  final List<File> images;
  final BrandModel? modelBrand;
  final BrandModel? carBrand;
  final String scale;
  final String version;
  final String color;
  final String material;
  final String limitedInfo;
  final String productName;
  final String releaseYear;
  final String productCode;
  final String releasePrice;

  ReportMissingForm({
    this.images = const [],
    this.modelBrand,
    this.carBrand,
    this.scale = '',
    this.version = '',
    this.color = '',
    this.material = '',
    this.limitedInfo = '',
    this.productName = '',
    this.releaseYear = '',
    this.productCode = '',
    this.releasePrice = '',
  });
}
