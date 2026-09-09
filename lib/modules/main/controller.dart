import 'package:get/get.dart';
import 'package:miniauto_keeper/core/services/garage_repository.dart';

class MainController extends GetxController {
  /// Tab 总数（与 IndexedStack children 一一对应）
  static const int _tabCount = 5;

  /// 车库 Tab 在 IndexedStack 中的位置（GarageView 所在槽位）
  static const int _garageTabIndex = 2;

  // 当前选中的 Tab 索引
  final _currentIndex = 0.obs;
  int get currentIndex => _currentIndex.value;

  /// 懒加载标记：仅首个进入的 tab 才创建对应页面并实例化 controller。
  /// 首页(index 0)默认创建，其余 4 个 tab 首次切换时才置 true，
  /// 之后保活不销毁（IndexedStack 语义不变）。
  final List<bool> _created = List<bool>.filled(_tabCount, false);

  final GarageRepository _garageRepo = Get.find<GarageRepository>();

  MainController() {
    _created[0] = true; // 首页默认创建
  }

  /// 该 tab 页面是否已创建
  bool isCreated(int index) =>
      index >= 0 && index < _tabCount && _created[index];

  // 切换 Tab 方法
  void changePage(int index) {
    if (index < 0 || index >= _tabCount) return;
    // 进入车库 tab 时，兑现前台写操作产生的脏标记（首次进入会拉首屏）。
    // ensureLoaded 幂等：仅「未加载过」或「有脏」时才重拉第一页清脏，否则直接跳过。
    if (index == _garageTabIndex) {
      _garageRepo.ensureLoaded();
    }
    _currentIndex.value = index;
    _created[index] = true; // 首次进入该 tab 时标记创建
  }

  // 如果需要点击中间的特殊按钮或执行特定逻辑，可以在这里写
}
