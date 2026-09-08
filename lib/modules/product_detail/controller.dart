import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:get/get.dart';
import 'package:miniauto_keeper/models/result.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/network/api/catalog_api.dart';
import '../../core/network/http_service.dart';
import '../../models/car_model.dart';

class ProductDetailController extends GetxController {
  final CatalogApi _catalog = CatalogApi(HttpService.to.dio);

  final product = Rxn<CarModel>();
  final isLoading = false.obs;

  /// 收藏态为本地展示状态，待后端收藏接口接通后替换为真实数据
  final isFavourite = false.obs;

  final FlutterCarouselController carouselController =
      FlutterCarouselController();
  final currentImgIndex = 0.obs;

  final productId = Get.parameters['id'];

  @override
  void onInit() {
    super.onInit();
    _loadProductData();
  }

  Future<void> _loadProductData() async {
    if (productId == null) return;

    isLoading.value = true;
    try {
      Result<CarModel> response = await _catalog.getModelDetails(productId!);
      product.value = response.data;
    } catch (e) {
      debugPrint('ProductDetail load error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// 加载失败后重试
  Future<void> retry() => _loadProductData();

  void updateImageIndex(int index) {
    currentImgIndex.value = index;
  }

  void toggleFavourite() {
    isFavourite.toggle();
  }

  Future<void> executeShare() async {
    final data = product.value;
    if (data == null) return;

    final String shareText =
        "SPECIFICATION: ${data.name}\n"
        "Brand: ${data.brand.name.isEmpty ? 'N/A' : data.brand.name} | "
        "Series: ${data.series.name.isEmpty ? 'N/A' : data.series.name} | "
        "Code: ${data.modelNumber}\n"
        "Check out full specs here:\n"
        "https://miniauto.keeper.com/product/${data.id}";

    try {
      final result = await Share.share(
        shareText,
        subject: 'Product Specification: ${data.name}',
      );
      if (result.status == ShareResultStatus.success) {
        debugPrint('Share succeeded via: ${result.raw}');
      }
    } catch (e) {
      debugPrint('Share error: $e');
    }
  }
}
