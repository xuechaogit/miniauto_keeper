import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:miniauto_keeper/core/utils/snackbar_util.dart';
import 'package:miniauto_keeper/models/auth_result.dart';
import 'package:miniauto_keeper/models/result.dart';

import '../../core/network/api/auth_api.dart';
import '../../core/network/http_service.dart';
import '../../core/services/user_service.dart';

class RegisterController extends GetxController {
  // 输入
  final emailController = TextEditingController();
  final codeController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();
  final nicknameController = TextEditingController();

  // 状态
  var isPasswordVisible = false.obs;
  var isLoading = false.obs;
  var isCodeLoading = false.obs;
  var codeCountdown = 0.obs;
  Timer? _timer;

  final _api = AuthApi(HttpService.to.dio);

  bool get canSendCode => codeCountdown.value <= 0;

  /// 发送验证码；开发模式下后端把验证码放在 message，返回后以 Snackbar 展示
  Future<void> sendCode() async {
    final email = emailController.text.trim();
    if (email.isEmpty) {
      SnackBarUtil.error('Please enter email first');
      return;
    }
    try {
      isCodeLoading.value = true;
      final envelope = await _api.sendVerificationCode({'email': email});
      final msg = envelope.message ?? '';
      print('envelope: $envelope');
      SnackBarUtil.success(msg.isNotEmpty ? msg : 'Code sent');
      startCountdown();
    } on DioException catch (e) {
      // 后端原始响应体（无论 HTTP 200/422，response.data 都是反序列化好的 JSON）
      final body = e.response?.data;
      var msg = body is Map ? (body['message']?.toString() ?? '') : '';
      if (msg.isEmpty) {
        // 兜底：拦截器 reject 场景 e.error 已带 message；网络异常走 message
        msg = (e.error ?? e.message)?.toString() ?? '发送失败';
      }
      SnackBarUtil.error(msg);
    } catch (e) {
      print('sendCode error: $e');
    } finally {
      isCodeLoading.value = false;
    }
  }

  void startCountdown() {
    codeCountdown.value = 60;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (codeCountdown.value > 0) {
        codeCountdown.value--;
      } else {
        _timer?.cancel();
      }
    });
  }

  Future<void> register() async {
    final email = emailController.text.trim();
    final code = codeController.text.trim();
    final pwd = passwordController.text;
    final confirm = confirmController.text;
    // if (email.isEmpty || code.isEmpty || pwd.isEmpty || confirm.isEmpty) {
    //   SnackBarUtil.error('Please complete all required fields');
    //   return;
    // }
    // if (!GetUtils.isEmail(email)) {
    //   SnackBarUtil.error('Invalid email address');
    //   return;
    // }
    // if (pwd.length < 6) {
    //   SnackBarUtil.error('Password must be at least 6 characters');
    //   return;
    // }
    // if (pwd != confirm) {
    //   SnackBarUtil.error('Passwords do not match');
    //   return;
    // }
    try {
      isLoading.value = true;
      Result<AuthResult> result = await _api.register({
        'email': email,
        'password': pwd,
        'password_confirmation': confirm,
        'verification_code': code,
        'nickname': nicknameController.text.trim().isEmpty
            ? ''
            : nicknameController.text.trim(),
        'language': 'zh',
      });

      final userService = Get.find<UserService>();
      final user = result.data?.user;
      userService.saveLoginInfo(
        token: result.data?.token ?? '',
        userId: user?.id?.toString(),
        nickname: user?.nickname,
      );

      Get.offAllNamed('/login');
    } on DioException catch (e) {
      final body = e.response?.data;
      var msg = body is Map ? (body['message']?.toString() ?? '') : '';
      if (msg.isEmpty) {
        msg = (e.error ?? e.message)?.toString() ?? '注册失败';
      }
      SnackBarUtil.error(msg);
    } catch (e) {
      final msg = e.toString().replaceFirst(RegExp(r'^Exception: '), '');
      SnackBarUtil.error(msg);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    emailController.dispose();
    codeController.dispose();
    passwordController.dispose();
    confirmController.dispose();
    nicknameController.dispose();
    super.onClose();
  }
}
