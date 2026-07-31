import 'package:get/get.dart';

import '../../../core/network/api_response.dart';
import '../../../core/network/http_service.dart';
import '../../../models/product_model.dart';

class BrandListRepository {
  final _http = Get.find<HttpService>();

  Future<ApiResponse<ProductListData>> fetchProductList({
    required int page,
    int size = 10,
    String? sort,
    String? keyword,
  }) async {
    final params = <String, dynamic>{
      'page': page,
      'size': size,
    };
    if (sort != null && sort != '默认') params['sort'] = sort;
    if (keyword != null && keyword.isNotEmpty) params['keyword'] = keyword;

    return await _http.request<ProductListData>(
      '/product/cate-list',
      method: 'GET',
      queryParameters: params,
      fromJsonT: (data) => ProductListData.fromJson(data),
    );
  }
}
