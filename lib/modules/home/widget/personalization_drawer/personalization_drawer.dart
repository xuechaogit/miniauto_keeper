// 右侧设置抽屉组件
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/l10n/l10n_util.dart';
import '../../../../core/services/settings_service.dart';

import 'package:miniauto_keeper/core/utils/screen_adapter.dart';

Widget PersonalizationDrawer(BuildContext context) {
  final settings = Get.find<SettingsService>();
  return Drawer(
    child: SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 抽屉头部
          Container(
            height: kToolbarHeight,
            padding: EdgeInsets.only(left: w(16), right: w(16)),
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                Icon(
                  Icons.tune,
                  color: Theme.of(context).colorScheme.primary,
                  size: r(24),
                ),
                SizedBox(width: w(12)),
                Text(
                  "个性化设置",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: sp(20),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // 1. 明暗色切换菜单
          Obx(
            () => SwitchListTile(
              secondary: Icon(
                settings.isDarkMode ? Icons.dark_mode : Icons.light_mode,
              ),
              title: const Text("深色模式"),
              value: settings.isDarkMode,
              onChanged: (value) => settings.toggleDarkMode(value),
            ),
          ),

          const Divider(height: 1),

          // 2. 语言切换菜单（Popup 弹出菜单设计，优雅且不易出错）
          Obx(
            () => ListTile(
              leading: const Icon(Icons.language),
              title: const Text("语言设置"),
              trailing: PopupMenuButton<String>(
                // 初始化当前选中的语言代码
                initialValue: settings.language,
                // 触发弹出的组件样式
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      // 使用扩展中的 currentLanguageName 属性
                      context.currentLanguageName,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Icon(Icons.arrow_drop_down),
                  ],
                ),
                // 选择后更新 SettingsService
                onSelected: (String langCode) {
                  settings.language = langCode;
                  // 同步更新 GetX 的 Locale 状态
                  Get.updateLocale(Locale(langCode));
                },
                // 动态根据支持的 Locales 生成菜单项
                itemBuilder: (BuildContext context) {
                  return context.supportedLocales.map((locale) {
                    final loc = locale as Locale; // 显式进行类型转换，彻底解决编译期 dynamic 冲突
                    return PopupMenuItem<String>(
                      value: loc.languageCode,
                      child: Text(loc.displayName), // 直接调用工具类拓展
                    );
                  }).toList();
                },
              ),
            ),
          ),

          const Divider(height: 1),
          const Spacer(),

          // 底部版权/品牌信息展示
          Padding(
            padding: EdgeInsets.all(w(24)),
            child: Center(
              child: Text(
                "车仔助手 v1.0.0",
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
