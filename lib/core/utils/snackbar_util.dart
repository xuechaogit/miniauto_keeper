import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:miniauto_keeper/core/utils/screen_adapter.dart';

class SnackBarUtil {
  // 私有基础配置，减少重复代码
  static void _show({
    required String title,
    required String message,
    required Color backgroundColor,
    required IconData icon,
    duration = const Duration(seconds: 5),
    Color textColor = Colors.white,
  }) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: backgroundColor.withOpacity(0.4),
      colorText: textColor,
      icon: Icon(icon, color: textColor),
      margin: EdgeInsets.all(w(16)),
      duration: duration,
      borderRadius: r(8),
      snackStyle: SnackStyle.FLOATING,
    );
  }

  // 1. 成功提示 (Success)
  static void success(
    String message, {
    String title = 'Success',
    Duration duration = const Duration(seconds: 5),
  }) {
    _show(
      title: title,
      message: message,
      backgroundColor: Colors.green.withOpacity(0.4),
      icon: Icons.check_circle_outline,
      duration: duration,
    );
  }

  // 2. 主要提示 (Primary / Blue)
  static void primary(
    String message, {
    String title = 'Hint',
    Duration duration = const Duration(seconds: 5),
  }) {
    _show(
      title: title,
      message: message,
      backgroundColor: Colors.blueAccent.withOpacity(0.4),
      icon: Icons.info_outline,
      duration: duration,
    );
  }

  // 3. 危险提示 (Danger / Warning)
  static void danger(
    String message, {
    String title = 'Danger',
    Duration duration = const Duration(seconds: 5),
  }) {
    _show(
      title: title,
      message: message,
      backgroundColor: Colors.orange.withOpacity(0.4),
      icon: Icons.warning_amber_rounded,
      duration: duration,
    );
  }

  // 4. 错误提示 (Error)
  static void error(
    String message, {
    String title = 'Error',
    Duration duration = const Duration(seconds: 5),
  }) {
    _show(
      title: title,
      message: message,
      backgroundColor: Colors.redAccent.withOpacity(0.4),
      icon: Icons.error_outline,
      duration: duration,
    );
  }

  // 5. 信息提示 (Info)
  static void info(
    String message, {
    String title = 'Info',
    Duration duration = const Duration(seconds: 5),
  }) {
    _show(
      title: title,
      message: message,
      backgroundColor: Colors.grey.withOpacity(0.4),
      icon: Icons.message_outlined,
      duration: duration,
    );
  }
}
