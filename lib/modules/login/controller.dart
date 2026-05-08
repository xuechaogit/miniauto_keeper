import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  // 1. 输入控制器
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // 2. 状态变量
  var isPasswordVisible = false.obs;
  var isLoading = false.obs;

  // 切换密码显示/隐藏
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  // 登录逻辑
  Future<void> login() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar(
        'Tip',
        'Please enter your credentials',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withOpacity(0.8),
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;

    try {
      // 模拟网络请求
      await Future.delayed(const Duration(seconds: 2));

      // 登录成功，跳转到主壳页面
      Get.offAllNamed('/main');
    } finally {
      isLoading.value = false;
    }
  }

  //
  void loginWithGoogle() {}

  void loginWithApple() {}

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
