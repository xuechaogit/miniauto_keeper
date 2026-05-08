import 'package:get/get.dart';
import 'controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    // 使用 Get.lazyPut 确保只有进入登录页才会实例化逻辑
    Get.lazyPut<LoginController>(() => LoginController());
  }
}
