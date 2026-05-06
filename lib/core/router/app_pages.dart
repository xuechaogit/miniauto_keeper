//定义实际的页面映射和对应的 Binding（自动管理生命周期）

import 'package:get/get.dart';
import '../../modules/home/view.dart';
import '../../modules/home/binding.dart';

import 'app_routes.dart'; // 稍后创建
// ... 其他页面

class AppPages {
  // 初始页面
  static const initial = AppRoutes.home;

  static final routes = [
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeView(),
      binding: HomeBinding(), // 这里绑定生命周期
      transition: Transition.fadeIn, // 专业的淡入效果
    ),
  ];
}
