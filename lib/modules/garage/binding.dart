import 'package:get/get.dart';
import 'controller.dart';

class GarageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GarageController>(() => GarageController());
  }
}
