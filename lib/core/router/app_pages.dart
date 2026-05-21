//定义实际的页面映射和对应的 Binding（自动管理生命周期）

import 'package:get/get.dart';
import 'package:miniauto_keeper/modules/calendar/binding.dart';
import 'package:miniauto_keeper/modules/calendar/view.dart';
import 'package:miniauto_keeper/modules/notice/notice_detail/view.dart';

//路由中间件

//路由路径
import '../../modules/modules.dart';
import '../../modules/notice/index.dart';
import '../../modules/product_detail/index.dart';
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
    _productDetailRoute(),
    _noticeRoute(), // 公告
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

  static GetPage _productDetailRoute() => GetPage(
    name: AppRoutes.productDetail,
    page: () => const ProductDetailView(),
    binding: ProductDetailBinding(),
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

  //公告
  static GetPage _noticeRoute() => GetPage(
    name: AppRoutes.notice,
    page: () => const NoticeListView(),
    binding: NoticeBinding(),
    transition: Transition.fadeIn,
    middlewares: [AuthMiddleware()],
    children: [
      GetPage(
        name: '/detail',
        page: () => const NoticeDetailView(),
        binding: NoticeDetailBinding(),
        transition: Transition.fadeIn,
      ),
    ],
  );
}
