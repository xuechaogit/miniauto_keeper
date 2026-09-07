import 'package:dio/dio.dart';
import 'package:miniauto_keeper/models/car_model.dart';
import 'package:miniauto_keeper/models/catalog_brand.dart';
import 'package:miniauto_keeper/models/envelope/car_list_envelope.dart';
import 'package:miniauto_keeper/models/envelope/series_list_envelope.dart';
import 'package:miniauto_keeper/models/series.dart';
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

  /// 品牌详情
  @GET('/catalog/brands/{id}')
  Future<CatalogBrand> getBrandDetails(@Path('id') String id);

  //系列列表（分页）
  @GET('/catalog/series')
  Future<SeriesListEnvelope> getSeries(
    @Query('brand_id') int brand_id,
    @Query('page') int page,
    @Query('page_size') int page_size,
    @Query('Sort') String Sort,
    @Query('keyword') String keyword,
  );

  //系列详情
  @GET('/catalog/series/{id}')
  Future<Series> getSeriesDetails(@Path('id') String id);

  /// 车模列表（分页）
  /// 参数：brand_id / series_id / tag_id / search 为可选筛选，page/page_size 为分页
  /// 可选筛参数传 null 时 Dio 自动跳过，不参与请求
  @GET('/catalog/models')
  Future<CarListEnvelope> getModels(
    @Query('page') int page,
    @Query('page_size') int pageSize,
    @Query('brand_id') int? brandId,
    @Query('series_id') int? seriesId,
    @Query('tag_id') int? tagId,
    @Query('search') String? search,
  );

  /// 车模详情
  @GET('/catalog/models/{id}')
  Future<CarModel> getModelDetails(@Path('id') String id);
}
