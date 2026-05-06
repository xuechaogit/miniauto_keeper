//为了让业务层不被 Dynamic 类型折磨，我们定义一个泛型包装类：
class ApiResponse<T> {
  final int code; // 业务状态码 (非 HTTP 状态码)
  final String msg; // 提示信息
  final T? data; // 数据负载

  ApiResponse({required this.code, required this.msg, this.data});

  // 是否成功
  bool get isSuccess => code == 200 || code == 0;
}
