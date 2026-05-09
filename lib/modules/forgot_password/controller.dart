import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/router/app_routes.dart';

class ForgotPasswordController extends GetxController {
  // --- 步骤一：邮箱 ---
  final emailController = TextEditingController();

  // --- 步骤二：验证码 ---
  final otpController = TextEditingController();
  final timer = 59.obs;
  Timer? _resendTimer;

  // --- 步骤三：新密码 ---
  final newPwdController = TextEditingController();
  final confirmPwdController = TextEditingController();
  final isPasswordVisible = false.obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // 模拟进入验证页面后启动倒计时
    startTimer();
  }

  void startTimer() {
    timer.value = 59;
    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (timer.value > 0) {
        timer.value--;
      } else {
        _resendTimer?.cancel();
      }
    });
  }

  // 发送重置邮件
  void sendResetLink() async {
    if (emailController.text.isEmpty) return;
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 2)); // 模拟网络请求
    isLoading.value = false;
    Get.toNamed('/forgot-password/verify');
  }

  // 验证验证码
  void verifyCode(String pin) {
    if (pin.length == 6) {
      print("正在验证: $pin");
      Get.toNamed(AppRoutes.forgotReset);
    } else {
      Get.snackbar("Error", "Please enter full 6-digit code");
    }
  }

  // 更新密码
  // lib/modules/forgot_password/controller.dart

  void updatePassword() async {
    // 1. 确保在销毁前收起键盘并移除所有输入框焦点
    FocusManager.instance.primaryFocus?.unfocus();

    // 2. 增加一帧或微小的延时，让 TextField 完成其自身的 dispose 过程
    // 这一步是解决 "A TextEditingController was used after being disposed" 的关键
    await Future.delayed(const Duration(milliseconds: 100));

    // 3. 执行跳转。此时 Controller 销毁时，UI 已经不再依赖它了
    Get.toNamed(AppRoutes.login);
  }

  @override
  void onClose() {
    // 停止计时器，防止在控制器销毁后继续执行 timer.value--
    _resendTimer?.cancel();

    // 释放所有控制器
    emailController.dispose();
    otpController.dispose();
    newPwdController.dispose(); // 补上这个
    confirmPwdController.dispose(); // 补上这个

    super.onClose();
  }
}
