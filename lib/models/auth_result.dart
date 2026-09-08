/// 认证结果：登录 / 注册成功后的响应 data
///
/// 后端响应 data 字段名尚未最终确认，这里做多 key 兼容解析：
/// - token：兼容 token / access_token
/// - user：兼容 user / member_info
class AuthResult {
  final String token;
  final AuthUser? user;

  const AuthResult({required this.token, this.user});

  factory AuthResult.fromJson(Map<String, dynamic> json) {
    final userRaw = (json['user'] ?? json['member_info']);
    return AuthResult(
      token: (json['token'] ?? json['access_token'] ?? '')?.toString() ?? '',
      user: userRaw is Map<String, dynamic>
          ? AuthUser.fromJson(userRaw)
          : (userRaw is Map ? AuthUser.fromJson(Map<String, dynamic>.from(userRaw)) : null),
    );
  }

  Map<String, dynamic> toJson() => {
    'token': token,
    if (user != null) 'user': user!.toJson(),
  };
}

/// 认证用户信息
class AuthUser {
  final int? id;
  final String email;
  final String? nickname;
  final String? avatar;
  final String? language;

  const AuthUser({
    this.id,
    this.email = '',
    this.nickname,
    this.avatar,
    this.language,
  });

  factory AuthUser.fromJson(Map<String, dynamic> json) => AuthUser(
    id: json['id'] is int ? json['id'] as int : int.tryParse('${json['id'] ?? ''}'),
    email: (json['email'] ?? '')?.toString() ?? '',
    nickname: json['nickname']?.toString(),
    avatar: json['avatar']?.toString(),
    language: json['language']?.toString(),
  );

  Map<String, dynamic> toJson() => {
    if (id != null) 'id': id,
    'email': email,
    'nickname': nickname,
    'avatar': avatar,
    'language': language,
  };
}
