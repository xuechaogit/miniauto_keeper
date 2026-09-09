import 'package:dio/dio.dart';
import 'package:miniauto_keeper/models/result.dart';
import 'package:miniauto_keeper/models/auth_result.dart';
import 'package:miniauto_keeper/models/verification.dart';
import 'package:retrofit/retrofit.dart';

part 'auth_api.g.dart';

/// auth 模块接口
///
/// 统一约定同 CatalogApi：响应由 ResponseInterceptor 剥壳；
/// baseUrl 已含 /api/v1，路径不重复前缀。
/// 发送验证码接口因需读取后端 message（开发模式验证码在 message 中），
/// 通过 @Extra keepEnvelope 标记让拦截器保留完整 envelope，
/// 返回 SendCodeEnvelope 直接取 message，不再走手写 Dio。
@RestApi()
abstract class AuthApi {
  factory AuthApi(Dio dio, {String? baseUrl}) = _AuthApi;

  /// 发送邮箱验证码
  ///
  /// 开发模式下验证码在后端 message 字段；keepEnvelope 标记保留完整响应，
  /// 拦截器不剥壳，DTO 可读取 { code, message, data } 中的 message。
  @POST('/auth/send-verification-code')
  @Extra({'keepEnvelope': true})
  Future<Result<Verification>> sendVerificationCode(
    @Body() Map<String, dynamic> body,
  );

  /// 邮箱注册
  @POST('/auth/register')
  Future<Result<AuthResult>> register(@Body() Map<String, dynamic> body);

  /// 邮箱密码登录
  @POST('/auth/login')
  Future<Result<AuthResult>> login(@Body() Map<String, dynamic> body);

  /// 退出登录
  @POST('/auth/logout')
  Future<void> logout();
}
