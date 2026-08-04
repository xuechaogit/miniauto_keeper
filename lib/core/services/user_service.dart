import 'package:get/get.dart';
import 'storage_service.dart';

class UserService extends GetxService {
  final StorageService _storage = Get.find<StorageService>();

  static const _boxName = 'user';
  static const _keyToken = 'auth_token';
  static const _keyUserId = 'user_id';
  static const _keyNickname = 'nickname';

  final _token = ''.obs;
  final _userId = ''.obs;
  final _nickname = ''.obs;

  String get token => _token.value;
  String get userId => _userId.value;
  String get nickname => _nickname.value;
  bool get isLogin => _token.value.isNotEmpty;

  Future<UserService> init() async {
    _token.value = _storage.read<String>(_boxName, _keyToken, defaultValue: '');
    _userId.value = _storage.read<String>(_boxName, _keyUserId, defaultValue: '');
    _nickname.value = _storage.read<String>(_boxName, _keyNickname, defaultValue: '');
    return this;
  }

  /// 登录成功后调用
  void saveLoginInfo({required String token, String? userId, String? nickname}) {
    _token.value = token;
    _storage.write(_boxName, _keyToken, token);
    if (userId != null) {
      _userId.value = userId;
      _storage.write(_boxName, _keyUserId, userId);
    }
    if (nickname != null) {
      _nickname.value = nickname;
      _storage.write(_boxName, _keyNickname, nickname);
    }
  }

  /// 登出
  void logout() {
    _token.value = '';
    _userId.value = '';
    _nickname.value = '';
    _storage.clear(_boxName);
  }
}
