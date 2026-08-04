// lib/app/data/network/interceptors/auth_interceptor.dart
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
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // 如果后端返回 401，可以在这里直接跳转登录页
    if (response.data['code'] == 401) {
      Get.offAllNamed('/login');
    }
    return handler.next(response);
  }
}
