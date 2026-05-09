import 'package:get/get.dart';
import 'controller.dart';

class CalendarBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CalendarController>(() => CalendarController());
  }
}
