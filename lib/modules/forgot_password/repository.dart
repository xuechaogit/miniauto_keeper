import 'package:get/get.dart';

import '../../core/network/api_response.dart';
import '../../core/network/http_service.dart';

class ForgotPasswordRepository {
  final _http = Get.find<HttpService>();

  Future<ApiResponse<dynamic>> sendVerifyCode(String username) {
    return _http.request<dynamic>(
      '/member/send-verify-code',
      method: 'POST',
      data: {'username': username, 'type': 0},
    );
  }

  Future<ApiResponse<dynamic>> resetPassword({
    required String username,
    required String password,
    required String verifyCode,
  }) {
    return _http.request<dynamic>(
      '/member/forget-password',
      method: 'POST',
      data: {
        'username': username,
        'password': password,
        'verify_code': verifyCode,
      },
    );
  }
}
