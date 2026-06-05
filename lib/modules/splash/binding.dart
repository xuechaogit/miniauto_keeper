import 'package:get/get.dart';
import 'controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    // 使用 Get.lazyPut 延迟注入你的启动页控制器
    Get.lazyPut<SplashController>(() => SplashController());
  }
}
