import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/router/app_routes.dart';
import '../../core/services/user_service.dart';
import 'repository.dart';

class ForgotPasswordController extends GetxController {
  final _repo = ForgotPasswordRepository();

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

  // 发送验证码
  void sendResetLink() async {
    if (emailController.text.isEmpty) {
      Get.snackbar("Error", "Please enter your email");
      return;
    }
    isLoading.value = true;
    try {
      final response = await _repo.sendVerifyCode(emailController.text.trim());
      if (response.code == 1) {
        Get.toNamed('/forgot-password/verify');
      } else {
        Get.snackbar("Error", response.message);
      }
    } catch (e) {
      print("Resend Reset Link: $e");
      Get.snackbar("Error", "Network error, please try again");
    } finally {
      isLoading.value = false;
    }
  }

  // 重新发送验证码
  void resendCode() async {
    timer.value = 59;
    startTimer();
    try {
      final response = await _repo.sendVerifyCode(emailController.text.trim());
      if (response.code == 1) {
        Get.snackbar("Success", "Verification code resent");
      } else {
        Get.snackbar("Error", response.message);
      }
    } catch (e) {
      print("Resend code error: $e");
      Get.snackbar("Error", "Failed to resend verification code");
    }
  }

  // 验证验证码
  void verifyCode(String pin) {
    if (pin.length == 4) {
      print("正在验证: $pin");
      Get.toNamed(AppRoutes.forgotReset);
    } else {
      Get.snackbar("Error", "Please enter full 6-digit code");
    }
  }

  // 更新密码
  void updatePassword() async {
    final newPwd = newPwdController.text.trim();
    final confirmPwd = confirmPwdController.text.trim();
    final otpCode = otpController.text.trim();
    final email = emailController.text.trim();

    if (email.isEmpty ||
        newPwd.isEmpty ||
        confirmPwd.isEmpty ||
        otpCode.isEmpty) {
      Get.snackbar("Error", "All fields are required");
      return;
    }
    if (newPwd != confirmPwd) {
      Get.snackbar("Error", "Passwords do not match");
      return;
    }

    // 收起键盘并移除焦点
    FocusManager.instance.primaryFocus?.unfocus();

    isLoading.value = true;
    try {
      final response = await _repo.resetPassword(
        username: email,
        password: newPwd,
        verifyCode: otpCode,
      );
      if (response.isSuccess) {
        await Future.delayed(const Duration(milliseconds: 100));
        Get.offAllNamed(AppRoutes.login);
      } else {
        Get.snackbar("Error", response.message);
      }
    } catch (e) {
      print("Update password error: $e");
      Get.snackbar("Error", "Network error, please try again");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    // 停止计时器，防止在控制器销毁后继续执行 timer.value--
    _resendTimer?.cancel();

    // 释放所有控制器
    emailController.dispose();
    otpController.dispose();
    newPwdController.dispose();
    confirmPwdController.dispose();

    super.onClose();
  }
}
