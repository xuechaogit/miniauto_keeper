import 'package:get/get.dart';
import 'controller.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    // 使用 lazyPut 节省内存，只有在使用时才实例化
    Get.lazyPut<ProfileController>(() => ProfileController());
  }
}
