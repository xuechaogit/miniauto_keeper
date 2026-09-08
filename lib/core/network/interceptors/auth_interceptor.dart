// lib/core/network/interceptors/auth_interceptor.dart
import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import '../../services/user_service.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // 从 UserService 中读取 Token
    final token = Get.find<UserService>().token;
    if (token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // HTTP 401（token 过期/无效）：清理登录态并跳转登录页
    if (err.response?.statusCode == 401) {
      Get.find<UserService>().logout();
      if (!(Get.currentRoute.contains('/login'))) {
        Get.offAllNamed('/login');
      }
    }
    return handler.next(err);
  }
}
