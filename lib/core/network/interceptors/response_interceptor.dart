import 'package:dio/dio.dart';

/// 统一响应剥壳拦截器
///
/// 后端统一响应结构：{ code, message, data, meta? }
/// - code == 200：
///   - 若响应体仅有 code/message/data 三键 → data 即本体（retrofit 直接声明 T / List<T>）
///   - 若响应体还含其它字段（如 meta）→ 剥掉 code/message，产出 envelope `{ data, ...额外字段 }`
///   - 剥壳前的完整响应体暂存 extra['__raw__']，供仍走 ApiResponse 语义的旧调用读取
/// - code != 200：统一上抛 DioException（error 携带后端 message）
class ResponseInterceptor extends Interceptor {
  /// 剥壳前的完整响应体 key，供 [HttpService.request]（ApiResponse 语义）读取
  static const String rawKey = '__raw__';

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final body = response.data;
    if (body is Map<String, dynamic> && body.containsKey('code')) {
      final code = body['code'];
      if (code == 200) {
        response.extra[rawKey] = body;
        final extra = body.keys.where((k) => k != 'code' && k != 'message' && k != 'data').toList();
        if (extra.isEmpty) {
          // 无额外字段：data 即本体
          response.data = body['data'];
        } else {
          // 有额外字段（meta 等）：剥掉 code/message，数据与其它字段平级保留
          final envelope = <String, dynamic>{'data': body['data']};
          for (final k in extra) {
            envelope[k] = body[k];
          }
          response.data = envelope;
        }
        handler.next(response);
      } else {
        handler.reject(
          DioException(
            requestOptions: response.requestOptions,
            type: DioExceptionType.badResponse,
            error: body['message'] ?? 'Unknown business error',
          ),
        );
      }
    } else {
      // 非统一结构（如文件流、第三方接口）直接放行
      handler.next(response);
    }
  }
}

