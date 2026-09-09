import 'package:get/get.dart';
import 'package:miniauto_keeper/core/services/garage_repository.dart';
import 'package:miniauto_keeper/core/services/wishlist_repository.dart';
import '../garage/controller.dart';
import '../home/controller.dart';
import '../brand/controller.dart';
import '../profile/controller.dart';
import '../stats/controller.dart';
import './controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MainController());
    Get.lazyPut(() => HomeController());
    Get.lazyPut(() => BrandsController());
    // 车库仓库：启动即常驻、永不销毁，作为全局唯一数据源/写操作入口。
    // 不参与 lazyPut —— 写操作（品牌详情页等）随时 Get.find 即可；
    // 数据加载统一由 MainController.changePage 首次切车库 tab 触发 ensureLoaded。
    Get.put(GarageRepository(), permanent: true);
    // 心愿单仓库：与车库同策略，常驻为全局唯一数据源/写操作入口。
    // 心愿单是独立路由页，由 WishlistController.onInit 触发 ensureLoaded 首拉。
    Get.put(WishlistRepository(), permanent: true);
    // 车库页 controller：仅 UI 状态，无 onInit 网络副作用，随页面首次 build 惰性实例化
    Get.lazyPut(() => GarageController());
    Get.lazyPut(() => ProfileController());
    Get.lazyPut(() => StatsController());
    // 收藏和个人的 Controller 依此类推
  }
}
