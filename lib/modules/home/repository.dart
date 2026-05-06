import 'package:get/get.dart';

import '../../core/network/request_client.dart';
import '../../models/home_stats.dart';

class HomeRepository {
  final _http = Get.find<HttpService>();

  Future<HomeStats?> fetchHomeData() async {
    // 发起请求
    final response = await _http.request<Map<String, dynamic>>('/home');

    if (response.isSuccess && response.data != null) {
      return HomeStats.fromJson(response.data!);
    }
    return null;
  }
}
