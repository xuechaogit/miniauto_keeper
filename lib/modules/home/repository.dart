import 'package:get/get.dart';

import '../../core/network/api_response.dart';
import '../../core/network/http_service.dart';
import '../../models/home_stats.dart';
import '../../models/notice_model.dart';

class HomeRepository {
  final _http = Get.find<HttpService>();

  Future<ApiResponse<HomeStats>> fetchHomeData() async {
    return await _http.request<HomeStats>(
      '/home',
      method: 'GET',
      fromJsonT: (data) => HomeStats.fromJson(data),
    );
  }

  Future<ApiResponse<NoticeListData>> fetchNotices() async {
    return await _http.request<NoticeListData>(
      '/notice/list',
      method: 'GET',
      queryParameters: {'reced': 1},
      fromJsonT: (data) => NoticeListData.fromJson(data),
    );
  }
}
