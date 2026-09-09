import 'package:dio/dio.dart';
import 'package:miniauto_keeper/models/garage_item.dart';
import 'package:miniauto_keeper/models/result.dart';
import 'package:retrofit/retrofit.dart';

part 'garage_api.g.dart';

/// garage 模块接口
///
/// 统一约定同 CatalogApi：响应由 ResponseInterceptor 剥壳；
/// baseUrl 已含 /api/v1，路径不重复前缀。
/// 我的车库为分页接口，剥壳后 envelope = `{ data, meta }`，
/// 返回值 `Result<List<GarageItem>>` 携带列表与分页信息。
@RestApi()
abstract class GarageApi {
  factory GarageApi(Dio dio, {String? baseUrl}) = _GarageApi;

  /// 我的车库（分页）
  ///
  /// brandId / condition 为可选筛选，传 null 时 Dio 自动跳过，不参与请求。
  /// condition：1全新 2近新 3有瑕疵 4破损
  @GET('/garage')
  Future<Result<List<GarageItem>>> getMyGarage(
    @Query('page') int page,
    @Query('per_page') int perPage,
    @Query('brand_id') int? brandId,
    @Query('condition') int? condition,
  );

  /// 加入车库
  @POST('/garage')
  Future<Result<void>> addToGarage(@Body() GarageAddRequest body);

  /// 移出车库
  @DELETE('/garage/{id}')
  Future<void> removeFromGarage(@Path('id') int id);
}
