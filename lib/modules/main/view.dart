import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:miniauto_keeper/modules/modules.dart';
import 'package:mix/mix.dart';
import '../../core/theme/app_mix_themes.dart';

// 导入各个子页面
import '../../core/theme/app_theme.dart';
import '../../core/theme/app_theme_tool.dart';
import '../home/view.dart';
import '../brand/view.dart';
import '../profile/view.dart';

import 'controller.dart';

class MainView extends GetView<MainController> {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // IndexedStack 保证了页面切换时不会被销毁重绘
      body: Obx(
        () => IndexedStack(
          index: controller.currentIndex,
          children: const [
            HomeView(), // Index 0
            BrandView(), // Index 1
            Placeholder(), // Index 2 (收藏页占位)
            ProfileView(), // Index 3 (个人页占位)
          ],
        ),
      ),

      bottomNavigationBar: Obx(() => _buildBottomBar(context)),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: controller.currentIndex,
      onTap: controller.changePage,
      // 样式配置，你可以继续使用你的 Mix Token
      selectedItemColor: context.color(mxt.color.primary),
      unselectedItemColor: context
          .color(mxt.color.onSurfaceVariant)
          .withOpacity(0.5),
      backgroundColor: context.color(mxt.color.surface),
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.speed), label: 'HOME'),
        BottomNavigationBarItem(icon: Icon(Icons.grid_view), label: 'BRANDS'),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite_border),
          label: 'GARAGE',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: 'DRIVER',
        ),
      ],
    );
  }
}
