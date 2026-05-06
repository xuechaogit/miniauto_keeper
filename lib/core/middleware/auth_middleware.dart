import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/settings_service.dart'; // 假设你的用户信息存这

class AuthMiddleware extends GetMiddleware {
  // 优先级：数字越小越先执行
  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    // 这里判断逻辑：比如从 StorageService 读取 token
    // final bool isLogin = Get.find<SettingsService>().isLogin;
    final bool isLogin = true;

    if (!isLogin) {
      // 如果没登录，重定向到登录页
      // 并记录当前想去的页面，方便登录后跳回来
      return const RouteSettings(name: '/login');
    }

    return null; // 有权限，放行
  }
}
