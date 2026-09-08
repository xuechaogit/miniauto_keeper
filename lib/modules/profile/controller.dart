// lib/modules/profile/controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/network/api/auth_api.dart';
import '../../core/network/http_service.dart';
import '../../core/services/user_service.dart';

class ProfileController extends GetxController {
  // 响应式变量
  final totalModels = 1248.obs;
  final daysActive = 742.obs;
  final userName = "Apex Collector".obs;
  final rank = "Master Collector".obs;
  final isLoggingOut = false.obs;
  // 菜单配置
  final menuItems = [
    {'id': 'wishlist', 'title': 'My Wishlist', 'icon': Icons.favorite_border},
    {'id': 'history', 'title': 'Trading History', 'icon': Icons.history_edu},
    {'id': 'settings', 'title': 'Settings', 'icon': Icons.settings_outlined},
    {'id': 'help', 'title': 'Help & Support', 'icon': Icons.help_outline},
  ];

  @override
  void onInit() {
    super.onInit();
    // 可以在这里调用 Repository 获取服务器真实数据
  }

  Future<void> handleLogout() async {
    if (isLoggingOut.value) return;
    isLoggingOut.value = true;
    // 先通知服务端；网络失败不阻断本地清理
    try {
      await AuthApi(HttpService.to.dio).logout();
    } catch (_) {}
    Get.find<UserService>().logout();
    isLoggingOut.value = false;
    Get.offAllNamed('/login');
  }
}
