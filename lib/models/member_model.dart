class MemberInfo {
  final int id;
  final String username;
  final String avatar;
  final String? realname;
  final String balance;
  final int level;
  final String levelName;
  final int status;

  MemberInfo({
    required this.id,
    required this.username,
    required this.avatar,
    this.realname,
    required this.balance,
    required this.level,
    required this.levelName,
    required this.status,
  });

  factory MemberInfo.fromJson(Map<String, dynamic> json) {
    return MemberInfo(
      id: json['id'] ?? 0,
      username: json['username'] ?? '',
      avatar: json['avatar'] ?? '',
      realname: json['realname'],
      balance: json['balance']?.toString() ?? '0',
      level: json['level'] ?? 1,
      levelName: json['levelName'] ?? '',
      status: json['status'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'username': username,
    'avatar': avatar,
    'realname': realname,
    'balance': balance,
    'level': level,
    'levelName': levelName,
    'status': status,
  };
}
