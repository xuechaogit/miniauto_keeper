import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../models/envelope/brand_list_envelope.dart';

part 'catalog_api.g.dart';

/// catalog 模块接口
///
/// 统一约定：响应由 ResponseInterceptor 剥壳，retrofit 方法返回值即业务结构。
/// - 带 meta 的分页接口剥壳后产出 envelope { data, meta }，返回具体 Envelope 类型
/// - 无额外字段的接口剥壳后 data 即本体，返回 `Future<T>` / `Future<List<T>>`
@RestApi()
abstract class CatalogApi {
  factory CatalogApi(Dio dio, {String? baseUrl}) = _CatalogApi;

  /// 品牌列表（分页，page 从 1 开始）
  /// 剥壳后 envelope：data 为品牌数组、meta 为分页信息
  @GET('/catalog/brands')
  Future<BrandListEnvelope> getBrands(@Query('page') int page);
}

