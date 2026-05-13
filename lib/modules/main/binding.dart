import 'package:get/get.dart';
import '../home/controller.dart';
import '../brand/controller.dart';
import '../profile/controller.dart';
import '../stats/controller.dart';
import './controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MainController());
    Get.lazyPut(() => HomeController());
    Get.lazyPut(() => BrandsController());
    Get.lazyPut(() => ProfileController());
    Get.lazyPut(() => StatsController());
    // 收藏和个人的 Controller 依此类推
  }
}
