import 'package:get/get.dart';
import 'controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    // 使用 lazyPut，只有在 HomeView 真正渲染时才会实例化
    Get.lazyPut<HomeController>(() => HomeController());
  }
}
