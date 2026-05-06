// 业务配置服务（语言/主题切换）

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'storage_service.dart';

class SettingsService extends GetxService {
  final StorageService _storage = Get.find<StorageService>();

  static const _boxName = 'settings';
  static const _keyLanguage = 'app_language';
  static const _keyThemeColor = 'theme_seed_color';
  static const _keyIsDarkMode = 'is_dark_mode';

  // 1. 定义响应式变量 (.obs)
  final _language = 'en'.obs;
  final _themeColor = 0xFF003366.obs;
  final _isDarkMode = false.obs;

  // 2. 暴露 Getter，方便 UI 层直接访问值
  String get language => _language.value;
  int get themeColorValue => _themeColor.value;
  bool get isDarkMode => _isDarkMode.value;

  // 3. 在 init 中完成从 Hive 到 Rx 变量的同步
  Future<SettingsService> init() async {
    _language.value = _storage.read<String>(
      _boxName,
      _keyLanguage,
      defaultValue: _language.value,
    );
    _themeColor.value = _storage.read<int>(
      _boxName,
      _keyThemeColor,
      defaultValue: _themeColor.value,
    );
    _isDarkMode.value = _storage.read<bool>(
      _boxName,
      _keyIsDarkMode,
      defaultValue: _isDarkMode.value,
    );
    return this;
  }

  // --- 语言设置 ---
  set language(String value) {
    _language.value = value; // 触发 Obx 刷新
    _storage.write(_boxName, _keyLanguage, value);
    Get.updateLocale(Locale(value));
  }

  // --- 主题色设置 ---
  void updateThemeColor(int colorHex) {
    _themeColor.value = colorHex; // 触发 Obx 刷新
    _storage.write(_boxName, _keyThemeColor, colorHex);

    // 实时更新当前主题
    Get.changeTheme(
      ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(colorHex),
          brightness: isDarkMode ? Brightness.dark : Brightness.light,
        ),
      ),
    );
  }

  // --- 深色模式 ---
  void toggleDarkMode(bool value) {
    _isDarkMode.value = value; // 触发 Obx 刷新
    _storage.write(_boxName, _keyIsDarkMode, value);
    Get.changeThemeMode(value ? ThemeMode.dark : ThemeMode.light);
  }
}
