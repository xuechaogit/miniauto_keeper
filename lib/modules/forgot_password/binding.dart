import 'package:get/get.dart';
import 'controller.dart';

class ForgotPasswordBinding extends Bindings {
  @override
  void dependencies() {
    // 使用 fenix 保持控制器，直到退出整个忘记密码流程
    Get.lazyPut<ForgotPasswordController>(() => ForgotPasswordController());
  }
}
