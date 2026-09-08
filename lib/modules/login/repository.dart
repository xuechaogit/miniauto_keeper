import 'package:miniauto_keeper/models/result.dart';

import '../../core/network/api/auth_api.dart';
import '../../core/network/http_service.dart';
import '../../models/auth_result.dart';

class LoginRepository {
  final _api = AuthApi(HttpService.to.dio);

  Future<Result<AuthResult>> login({
    required String email,
    required String password,
  }) {
    return _api.login({'email': email, 'password': password});
  }
}
