import 'package:get/get.dart';

import 'controller.dart';

class ProductDetailBinding extends Bindings {
  @override
  void dependencies() {
    // 延迟注入 Controller，当页面销毁时自动释放内存
    Get.lazyPut<ProductDetailController>(() => ProductDetailController());
  }
}
