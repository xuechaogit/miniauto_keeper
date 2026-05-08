import 'package:get/get.dart';
import '../home/controller.dart';
import '../brand/controller.dart';
import './controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MainController());
    Get.lazyPut(() => HomeController());
    Get.lazyPut(() => BrandsController());
    // 收藏和个人的 Controller 依此类推
  }
}
