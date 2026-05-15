import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:miniauto_keeper/modules/modules.dart';
import 'package:mix/mix.dart';
import '../../core/theme/app_mix_themes.dart';

// 导入各个子页面
import '../../core/theme/app_theme.dart';
import '../../core/theme/app_theme_tool.dart';
import '../garage/view.dart';
import '../home/view.dart';
import '../brand/view.dart';
import '../profile/view.dart';
import '../stats/view.dart';

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
            GarageView(), // Index 2 (收藏页占位)
            StatsView(), // Index 3 (收藏页占位)
            ProfileView(), // Index 3 (个人页占位)
          ],
        ),
      ),
      // 核心修改 1：添加大的悬浮按钮
      floatingActionButton: Obx(() => _buildBigGarageButton(context)),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // 核心修改 2：使用 BottomAppBar
      bottomNavigationBar: Obx(() => _buildBottomBar(context)),
    );
  }

  // 中间的大按钮
  Widget _buildBigGarageButton(BuildContext context) {
    bool isSelected = controller.currentIndex == 2;
    return Box(
      style: Style(
        $box.width(64),
        $box.height(64),
        $box.decoration.shape(BoxShape.circle),
        $box.decoration.color(
          isSelected
              ? context.color(mxt.color.primary) // 选中时使用浅色/容器色
              : context.color(mxt.color.primary), // 未选中时使用主色
        ),
      ),
      child: InkWell(
        onTap: () => controller.changePage(2),
        borderRadius: BorderRadius.circular(32),
        child: const Icon(
          Icons.directions_car_filled,
          color: Colors.white,
          size: 32,
        ),
      ),
    );
  }

  // 辅助构建普通 Item
  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required int index,
  }) {
    bool isSelected = controller.currentIndex == index;
    Color activeColor = context.color(mxt.color.primary);
    Color inactiveColor = context
        .color(mxt.color.onSurfaceVariant)
        .withOpacity(0.5);

    return PressableBox(
      onPress: () => controller.changePage(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: isSelected ? activeColor : inactiveColor, size: 24),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? activeColor : inactiveColor,
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return BottomAppBar(
      height: 70,
      shape: const CircularNotchedRectangle(), // 让底部栏产生凹陷感
      notchMargin: 8.0, // 凹陷的边距
      color: context.color(mxt.color.surface),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: _buildNavItem(
              context,
              icon: Icons.speed,
              label: 'HOME',
              index: 0,
            ),
          ),
          Expanded(
            child: _buildNavItem(
              context,
              icon: Icons.grid_view,
              label: 'BRANDS',
              index: 1,
            ),
          ),
          const SizedBox(width: 48), // 中间留出大按钮的空间
          Expanded(
            child: _buildNavItem(
              context,
              icon: Icons.favorite_border,
              label: 'GARAGE',
              index: 3,
            ),
          ),
          Expanded(
            child: _buildNavItem(
              context,
              icon: Icons.person_outline,
              label: 'DRIVER',
              index: 4,
            ),
          ),
        ],
      ),
    );
  }
}
