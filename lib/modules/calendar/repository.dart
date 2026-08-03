import 'package:get/get.dart';
import '../../core/network/http_service.dart';
import '../../models/product_model.dart';

class CalendarPlanResponse {
  final Map<String, List<ProductModel>> etaData;
  final String currentMonth;

  CalendarPlanResponse({required this.etaData, required this.currentMonth});

  factory CalendarPlanResponse.fromJson(Map<String, dynamic> json) {
    final raw = json['etaData'] as Map<String, dynamic>? ?? {};
    final etaData = <String, List<ProductModel>>{};
    raw.forEach((key, value) {
      if (value is List) {
        etaData[key] = value.map((e) => ProductModel.fromJson(e)).toList();
      }
    });
    return CalendarPlanResponse(
      etaData: etaData,
      currentMonth: json['current_month'] ?? '',
    );
  }
}

class CalendarRepository {
  final _http = Get.find<HttpService>();

  Future<CalendarPlanResponse> fetchPlanList({
    required int year,
    required int month,
  }) async {
    final response = await _http.dio.get(
      '/plan/list',
      queryParameters: {'year': year, 'month': month, 'webType': 2},
    );

    return CalendarPlanResponse.fromJson(response.data);
  }
}
