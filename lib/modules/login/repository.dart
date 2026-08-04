import 'package:get/get.dart';

import '../../core/network/api_response.dart';
import '../../core/network/http_service.dart';

class LoginRepository {
  final _http = Get.find<HttpService>();

  Future<ApiResponse<Map<String, dynamic>>> login({
    required String username,
    required String password,
  }) {
    return _http.request<Map<String, dynamic>>(
      '/member/login',
      method: 'POST',
      data: {'username': username, 'password': password},
    );
  }
}
