import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:miniauto_keeper/core/network/api/auth_api.dart';
import 'package:miniauto_keeper/core/network/http_service.dart';
import 'package:miniauto_keeper/core/utils/snackbar_util.dart';

import '../../core/services/user_service.dart';

class LoginController extends GetxController {
  // 1. 输入控制器
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // 2. 状态变量
  var isPasswordVisible = false.obs;
  var isLoading = false.obs;

  //2.api接口：
  final _api = AuthApi(HttpService.to.dio);

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

      final response = await _api.login({
        "email": emailController.text.trim(),
        "password": passwordController.text,
      });

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
    } on DioException catch (e) {
      final body = e.response?.data;
      var msg = body is Map ? (body['message']?.toString() ?? '') : '';
      if (msg.isEmpty) {
        msg = (e.error ?? e.message)?.toString() ?? '注册失败';
      }
      SnackBarUtil.error(msg);
    } catch (e) {
      print(e);
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
