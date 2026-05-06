import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
// 统一的 API 响应格式
import 'api_response.dart'; // 避免与 Dio 的 Response 冲突

class HttpService extends GetxService {
  late final Dio _dio;

  // 基础配置
  static const String baseUrl =
      'https://api.macnninc.com/api/frontend'; // 换成你的 MACNN 域名
  static const int connectTimeout = 5000;

  Future<HttpService> init() async {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(milliseconds: connectTimeout),
        receiveTimeout: const Duration(milliseconds: connectTimeout),
        contentType: 'application/json',
      ),
    );

    // 添加拦截器
    _dio.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true),
    );
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // 在这里注入你的 Token（如果有）
          // options.headers['Authorization'] = 'Bearer your_token';
          return handler.next(options);
        },
        onError: (DioException e, handler) {
          _handleError(e);
          return handler.next(e);
        },
      ),
    );

    return this;
  }

  // 统一的请求方法
  Future<ApiResponse<T>> request<T>(
    String path, {
    String method = 'GET',
    Map<String, dynamic>? queryParameters,
    dynamic data,
  }) async {
    try {
      final response = await _dio.request(
        path,
        data: data,
        queryParameters: {...?queryParameters, 'webType': 2},
        options: Options(method: method),
      );

      // 假设后端返回格式为 {code: 200, message: "success", data: {...}}
      return ApiResponse<T>(
        code: response.data['code'] ?? -1,
        msg: response.data['message'] ?? '',
        data: response.data['data'] as T?,
      );
    } catch (e) {
      return ApiResponse<T>(code: -1, msg: '网络错误: $e');
    }
  }

  // 错误统一处理
  void _handleError(DioException e) {
    // 这里可以使用 Get.snackbar 弹出高对比度的警告提示
    String message = "未知错误";
    if (e.type == DioExceptionType.connectionTimeout) message = "连接超时";
    if (e.response?.statusCode == 401) message = "登录失效";

    Get.snackbar(
      "网络异常",
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Get.theme.colorScheme.errorContainer,
      colorText: Get.theme.colorScheme.onErrorContainer,
    );
  }
}
