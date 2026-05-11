import 'package:get/get.dart';

import '../../core/network/api_response.dart';
import '../../core/network/http_service.dart';
import '../../models/home_stats.dart';

class HomeRepository {
  final _http = Get.find<HttpService>();

  Future<ApiResponse<HomeStats>> fetchHomeData() async {
    return await _http.request<HomeStats>(
      '/home',
      method: 'GET',
      // 这里处理 List 类型的泛型转换
      fromJsonT: (data) => HomeStats.fromJson(data),
    );
  }
}
