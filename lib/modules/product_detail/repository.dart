import 'package:get/get.dart';

import '../../core/network/api_response.dart';
import '../../core/network/http_service.dart';
import '../../models/product_detail_model.dart';

class ProductDetailRepository {
  final _http = Get.find<HttpService>();

  Future<ApiResponse<ProductDetailModel>> fetchProductDetail(int id) async {
    return await _http.request<ProductDetailModel>(
      '/product/detail',
      method: 'POST',
      data: {'id': id},
      fromJsonT: (data) => ProductDetailModel.fromJson(data['detail']),
    );
  }
}
