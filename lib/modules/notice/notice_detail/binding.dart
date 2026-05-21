import 'package:get/get.dart';
import 'controller.dart';

class NoticeDetailBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NoticeDetailController>(() => NoticeDetailController());
  }
}
