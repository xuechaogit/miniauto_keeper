import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

import 'model.dart';

class ProductDetailController extends GetxController {
  // 响应式商品数据对象
  final product = Rxn<ProductMockModel>();

  // 声明专属于轮播图的控制器
  final FlutterCarouselController carouselController =
      FlutterCarouselController();
  // 轮播图当前页码
  final currentImgIndex = 0.obs;

  // 收藏/入库库房状态
  final isStored = false.obs;

  // 商品页通过 parameters 拿 ID
  final productId = Get.parameters['id'];

  @override
  void onInit() {
    super.onInit();
    _loadProductData();
  }

  // 模拟 API 请求或本地数据加载
  void _loadProductData() {
    // 引入上层抽离的 Mock 数据
    product.value = ProductMockModel.getMockData();
  }

  // 切换轮播页
  void updateImageIndex(int index) {
    currentImgIndex.value = index;
  }

  // 切换车库收藏状态
  void toggleStorageStatus() {
    isStored.value = !isStored.value;
    Get.snackbar(
      isStored.value ? "已入库 MANAGER" : "已出库",
      isStored.value ? "成功添加至您的专属资产车库" : "已从车库资产中移除",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF1E1E1E),
      colorText: const Color(0xFFE54335),
      duration: const Duration(seconds: 2),
    );
  }

  /// 执行国际化分享
  Future<void> executeShare() async {
    final data = product.value;
    if (data == null) return;

    // 1. 构造面向海外用户的分享文本 (带上单车编号或规格)
    final String shareText =
        "🔥 SPECIFICATION ANALYSIS: ${data.name}\n"
        "Brand: ${data.brand} | Scale: ${data.scale}\n"
        "Check out the full data and technical specs here:\n"
        "https://miniauto.keeper.com/product/${data.itemNumber}"; // 替换为你们实际的海外 H5 域名

    try {
      // 2. 调用原生的 Share Sheet
      // shareUriString / share 都可以。对于纯文本+链接，直接用 Share.share
      final result = await Share.share(
        shareText,
        subject: 'Product Specification: ${data.name}', // 邮件等渠道会作为标题
      );

      // 3. （可选）追踪分享结果（部分系统平台支持返回具体行为）
      if (result.status == ShareResultStatus.success) {
        // 用户成功分享或复制了链接，可以在这里上报埋点或给用户积分
        print('Share succeeded via: ${result.raw}');
      }
    } catch (e) {
      print("Share error: $e");
    }
  }
}
