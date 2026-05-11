//定义实际的页面映射和对应的 Binding（自动管理生命周期）

import 'package:get/get.dart';
import 'package:miniauto_keeper/modules/calendar/binding.dart';
import 'package:miniauto_keeper/modules/calendar/view.dart';

//路由中间件

//路由路径
import '../../modules/modules.dart';
import '../middleware/auth_middleware.dart';
import 'app_routes.dart';

// ... 其他页面

class AppPages {
  // 初始页面
  static const initial = AppRoutes.initial;

  static final routes = [
    _mainRoute(),
    _loginRoute(),
    _profileRoute(),
    _forgotPasswordRoute(), // 提取子路由逻辑
    _calendarRoute(),
    _brandDetailRoute(),
  ];

  // 模块化路由定义，避免 AppPages 类过长
  static GetPage _mainRoute() => GetPage(
    name: AppRoutes.initial,
    page: () => const MainView(),
    binding: MainBinding(),
    middlewares: [AuthMiddleware()],
  );

  static GetPage _brandDetailRoute() => GetPage(
    name: AppRoutes.brandDetail,
    page: () => const BrandDetailView(),
    binding: BrandDetailBinding(), // 记得创建对应的 Binding
    transition: Transition.fadeIn,
    middlewares: [AuthMiddleware()],
  );

  static GetPage _loginRoute() => GetPage(
    name: AppRoutes.login,
    page: () => const LoginView(),
    binding: LoginBinding(),
    transition: Transition.fadeIn,
  );

  static GetPage _profileRoute() => GetPage(
    name: AppRoutes.login,
    page: () => const ProfileView(),
    binding: ProfileBinding(),
    transition: Transition.fadeIn,
    middlewares: [AuthMiddleware()],
  );

  static GetPage _calendarRoute() => GetPage(
    name: AppRoutes.calender,
    page: () => const CalendarView(),
    binding: CalendarBinding(),
    transition: Transition.fadeIn,
    middlewares: [AuthMiddleware()],
  );

  static GetPage _forgotPasswordRoute() => GetPage(
    name: AppRoutes.forgotPassword,
    page: () => const ForgotPasswordView(),
    binding: ForgotPasswordBinding(),
    children: [
      GetPage(name: '/verify', page: () => const VerifyIdentityView()),
      GetPage(name: '/reset', page: () => const SetNewPasswordView()),
    ],
  );
}
