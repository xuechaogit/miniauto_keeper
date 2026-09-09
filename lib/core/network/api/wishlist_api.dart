import 'package:dio/dio.dart';
import 'package:miniauto_keeper/models/result.dart';
import 'package:miniauto_keeper/models/wishlist_entry.dart';
import 'package:retrofit/retrofit.dart';

part 'wishlist_api.g.dart';

/// 心愿单模块接口
///
/// 统一约定同 CatalogApi / GarageApi：响应由 ResponseInterceptor 剥壳；
/// baseUrl 已含 /api/v1，路径不重复前缀。
/// 分页参数为 page + **per_page**（注意 catalog 的 getModels 用的是 page_size，
/// 心愿单接口 per_page 与 garage 一致）。
@RestApi()
abstract class WishlistApi {
  factory WishlistApi(Dio dio, {String? baseUrl}) = _WishlistApi;

  /// 我的心愿单（分页）
  ///
  /// 剥壳后 envelope：data 为心愿单数组、meta 为分页信息，
  /// 返回 `Result<List<WishlistEntry>>` 携带列表与分页数据。
  @GET('/wishlist')
  Future<Result<List<WishlistEntry>>> getMyWishlist(
    @Query('page') int page,
    @Query('per_page') int perPage,
  );

  /// 加入心愿单
  @POST('/wishlist')
  Future<Result<void>> addToWishlist(@Body() WishlistAddRequest body);

  /// 移出心愿单
  @DELETE('/wishlist/{id}')
  Future<void> removeFromWishlist(@Path('id') int id);
}
