//定义实际的页面映射和对应的 Binding（自动管理生命周期）

import 'package:get/get.dart';
import 'package:miniauto_keeper/modules/calendar/binding.dart';
import 'package:miniauto_keeper/modules/calendar/view.dart';

//路由中间件
import '../../modules/brand/brand_list/binding.dart';
import '../../modules/brand/brand_list/view.dart';
import '../../modules/forgot_password/binding.dart';
import '../../modules/forgot_password/reset_view.dart';
import '../../modules/forgot_password/verify_view.dart';
import '../../modules/forgot_password/view.dart';
import '../../modules/login/binding.dart';
import '../../modules/login/view.dart';
import '../../modules/main/binding.dart';
import '../../modules/main/view.dart';
import '../../modules/calendar/binding.dart';
import '../../modules/calendar/view.dart';
import '../middleware/auth_middleware.dart';
//路由路径
import 'app_routes.dart';

// ... 其他页面

class AppPages {
  // 初始页面
  static const initial = AppRoutes.initial;

  static final routes = [
    GetPage(
      name: AppRoutes.initial,
      page: () => const MainView(),
      binding: MainBinding(),
      transition: Transition.fadeIn,
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.brandDetail,
      page: () => const BrandDetailView(),
      binding: BrandDetailBinding(), // 记得创建对应的 Binding
      transition: Transition.fadeIn,
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginView(),
      binding: LoginBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.forgotPassword,
      page: () => const ForgotPasswordView(),
      binding: ForgotPasswordBinding(), // 注入控制器
      transition: Transition.fadeIn,
      children: [
        // 验证码页 (实际路径为 /forgot-password/verify)
        GetPage(
          name: '/verify',
          page: () => const VerifyIdentityView(),
          transition: Transition.fadeIn,
        ),
        // 重置密码页 (实际路径为 /forgot-password/reset)
        GetPage(
          name: '/reset',
          page: () => const SetNewPasswordView(),
          transition: Transition.fadeIn,
        ),
      ],
    ),
    GetPage(
      name: AppRoutes.calender,
      page: () => const CalendarView(),
      binding: CalendarBinding(),
      transition: Transition.fadeIn,
      middlewares: [AuthMiddleware()],
    ),
    // GetPage(
    //   name: AppRoutes.home,
    //   page: () => const HomeView(),
    //   binding: HomeBinding(), // 这里绑定生命周期
    //   transition: Transition.fadeIn, // 专业的淡入效果
    //   middlewares: [AuthMiddleware()],
    // ),
    // GetPage(
    //   name: AppRoutes.brand,
    //   page: () => const BrandView(),
    //   binding: BrandBinding(), // 这里绑定生命周期
    //   transition: Transition.fadeIn, // 专业的淡入效果
    //   middlewares: [AuthMiddleware()],
    // ),
  ];
}
