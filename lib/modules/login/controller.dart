import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/services/user_service.dart';
import '../../models/member_model.dart';
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

      final result = await _repo.login(
        username: emailController.text.trim(),
        password: passwordController.text,
      );

      isLoading.value = false;

      if (result.code != 1) throw new Exception(result.message);

      final userService = Get.find<UserService>();
      final data = result.data!;
      final memberInfo = MemberInfo.fromJson(data['member_info']);

      userService.saveLoginInfo(
        token: data['token'] ?? '',
        userId: memberInfo.id.toString(),
        nickname: memberInfo.realname ?? memberInfo.username,
      );
      userService.memberInfo.value = memberInfo;

      Get.offAllNamed('/main');
    } catch (e) {
      isLoading.value = false;
      print('Login Failed: $e');
      Get.snackbar('Login Error', e.toString());
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
