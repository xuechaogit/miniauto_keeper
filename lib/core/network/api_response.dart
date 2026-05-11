//为了让业务层不被 Dynamic 类型折磨，我们定义一个泛型包装类：
class ApiResponse<T> {
  final int code; // 业务状态码 (非 HTTP 状态码)
  final String message; // 提示信息
  final T? data; // 数据负载

  ApiResponse({required this.code, required this.message, this.data});

  // 是否成功
  bool get isSuccess => code == 200 || code == 0;

  //核心：支持从 Json 转换，并由外部传入来自 Model 的 fromJson 构造器
  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic)? fromJsonT,
  ) {
    return ApiResponse<T>(
      code: json['code'] ?? -1,
      message: json['message'] ?? 'Unknown Error',
      data: (json['data'] != null && fromJsonT != null)
          ? fromJsonT(json['data'])
          : json['data'] as T?,
    );
  }
}
