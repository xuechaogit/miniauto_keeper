// lib/app/data/network/http_service.dart
import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response, ResponseInterceptor;
import 'api_response.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/response_interceptor.dart';

import '../config/api_config.dart';

class HttpService extends GetxService {
  static HttpService get to => Get.find();
  late final Dio _dio;
  Dio get dio => _dio;

  Future<HttpService> init() async {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        contentType: 'application/json',
      ),
    );

    // 添加拦截器链（ResponseInterceptor 负责统一剥壳，必须优先于业务读取）
    _dio.interceptors.addAll([
      AuthInterceptor(),
      // ResponseInterceptor(),
      LogInterceptor(responseBody: true, requestBody: true),
    ]);

    return this;
  }

  // 企业级通用请求：支持 T 类型的自动转换
  Future<ApiResponse<T>> request<T>(
    String path, {
    String method = 'GET',
    dynamic data,
    Map<String, dynamic>? queryParameters,
    T Function(dynamic)? fromJsonT, // 传入 Model.fromJson
  }) async {
    try {
      final response = await _dio.request(
        path,
        data: data,
        queryParameters: {...?queryParameters, 'webType': 2},
        options: Options(method: method),
      );

      // 拦截器已剥壳：优先使用剥壳前的原始响应体，保持 ApiResponse 语义不变
      final raw = response.extra[ResponseInterceptor.rawKey] ?? response.data;
      return ApiResponse<T>.fromJson(raw, fromJsonT);
    } on DioException catch (e) {
      return _handleDioError<T>(e);
    } catch (e) {
      return ApiResponse<T>(code: -1, message: "Unexpected Error: $e");
    }
  }

  ApiResponse<T> _handleDioError<T>(DioException e) {
    // 这里可以根据不同状态码显示 Snackbar
    return ApiResponse<T>(code: -1, message: "Network error: ${e.type}");
  }
}
