import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/l10n/l10n_util.dart'; // 导入我们之前的扩展
import '../../core/services/settings_service.dart';

import 'controller.dart';
import 'widget/personalization_drawer/personalization_drawer.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = Get.find<SettingsService>();

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.appName), // 使用国际化
        centerTitle: false,
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
            ),
          ),
        ],
      ),
      // 3. 配置右侧抽屉
      endDrawer: PersonalizationDrawer(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 欢迎卡片
            _buildWelcomeCard(context),
            const SizedBox(height: 32),

            // 主题色选择区
            Text(
              "品牌色配置",
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildColorPicker(settings),
            const SizedBox(height: 32),

            SizedBox(height: 16),
            ElevatedButton(
              child: Text("Go to Login"),
              onPressed: () => Get.toNamed('/login'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              child: Text("Go to Calender"),
              onPressed: () => Get.toNamed('/calender'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {},
      ),
    );
  }

  // 欢迎卡片（未来可以用 Mix 重构）
  Widget _buildWelcomeCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.homeTitle, // 国际化标题
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
          const SizedBox(height: 8),
          const Text("欢迎使用车仔助手，您的专业模型车库管家。"),
        ],
      ),
    );
  }

  // 主题色选择器
  Widget _buildColorPicker(SettingsService settings) {
    final colors = [
      const Color(0xFF003366), // 专业深蓝
      const Color(0xFF1B5E20), // 森林绿
      const Color(0xFFB71C1C), // 赛道红
      const Color(0xFFE65100), // 活力橙
    ];

    return Wrap(
      spacing: 12,
      children: colors.map((color) {
        return Obx(
          () => GestureDetector(
            onTap: () => settings.updateThemeColor(color.value),
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(
                  color: settings.themeColorValue == color.value
                      ? Colors.white
                      : Colors.transparent,
                  width: 3,
                ),
                boxShadow: [
                  if (settings.themeColorValue == color.value)
                    BoxShadow(
                      color: color.withOpacity(0.4),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                ],
              ),
              child: settings.themeColorValue == color.value
                  ? const Icon(Icons.check, color: Colors.white)
                  : null,
            ),
          ),
        );
      }).toList(),
    );
  }
}

class Other extends StatelessWidget {
  const Other({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(child: Text('Other'));
  }
}
