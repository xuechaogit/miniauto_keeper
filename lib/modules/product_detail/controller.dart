import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

import '../../models/product_detail_model.dart';
import 'repository.dart';

class ProductDetailController extends GetxController {
  final ProductDetailRepository _repository = ProductDetailRepository();

  final product = Rxn<ProductDetailModel>();
  final isLoading = false.obs;
  final isExpanded = false.obs;
  final userRating = Rxn<double>();

  final FlutterCarouselController carouselController =
      FlutterCarouselController();
  final currentImgIndex = 0.obs;

  final productId = Get.parameters['id'];

  @override
  void onInit() {
    super.onInit();
    print('Init Product Detail Page: ');
    _loadProductData();
  }

  Future<void> _loadProductData() async {
    if (productId == null) return;

    isLoading.value = true;
    try {
      final res = await _repository.fetchProductDetail(int.parse(productId!));
      if (res.code != 1) throw Exception(res.message);
      product.value = res.data;
    } catch (e) {
      debugPrint('ProductDetail load error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void updateImageIndex(int index) {
    currentImgIndex.value = index;
  }

  Future<void> executeShare() async {
    final data = product.value;
    if (data == null) return;

    final String shareText =
        "SPECIFICATION: ${data.title}\n"
        "Series: ${data.series ?? 'N/A'} | Code: ${data.code}\n"
        "Check out full specs here:\n"
        "https://miniauto.keeper.com/product/${data.id}";

    try {
      final result = await Share.share(
        shareText,
        subject: 'Product Specification: ${data.title}',
      );
      if (result.status == ShareResultStatus.success) {
        debugPrint('Share succeeded via: ${result.raw}');
      }
    } catch (e) {
      debugPrint('Share error: $e');
    }
  }
}
