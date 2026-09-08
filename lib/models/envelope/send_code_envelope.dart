import 'package:json_annotation/json_annotation.dart';

part 'send_code_envelope.g.dart';

/// 发送邮箱验证码接口返回值：保留完整 envelope，message 承载验证码/提示信息
///
/// 该接口由 AuthApi 声明走 retrofit，配合 ResponseInterceptor 的
/// keepEnvelope 标记返回未剥壳的完整响应 { code, message, data }。
/// 开发模式下后端把验证码放在 message 字段，UI 直接展示 message 即可。
@JsonSerializable()
class SendCodeEnvelope {
  final int? code;
  final String? message;
  final dynamic data;

  const SendCodeEnvelope({this.code, this.message, this.data});

  factory SendCodeEnvelope.fromJson(Map<String, dynamic> json) =>
      _$SendCodeEnvelopeFromJson(json);

  Map<String, dynamic> toJson() => _$SendCodeEnvelopeToJson(this);
}
