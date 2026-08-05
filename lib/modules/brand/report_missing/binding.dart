import 'package:get/get.dart';
import 'controller.dart';

class ReportMissingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReportMissingController>(() => ReportMissingController());
  }
}
