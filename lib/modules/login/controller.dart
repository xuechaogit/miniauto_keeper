import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/services/user_service.dart';
import 'repository.dart';

class LoginController extends GetxController {
  // 1. 输入控制器
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // 2. 状态变量
  var isPasswordVisible = false.obs;
  var isLoading = false.obs;

  final _repo = LoginRepository();

  // 切换密码显示/隐藏
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  Future<void> login() async {
    try {
      if (emailController.text.isEmpty || passwordController.text.isEmpty) {
        Get.snackbar('Error', 'Please enter email and password');
        return;
      }
      isLoading.value = true;

      final response = await _repo.login(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      final result = response.data!;

      isLoading.value = false;

      final userService = Get.find<UserService>();
      final user = result.user;
      userService.saveLoginInfo(
        token: result.token,
        userId: user?.id?.toString(),
        nickname: user?.nickname,
      );

      Get.offAllNamed('/main');
    } catch (e) {
      isLoading.value = false;
      final msg = e.toString().replaceFirst(RegExp(r'^Exception: '), '');
      Get.snackbar('Login Error', msg);
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
