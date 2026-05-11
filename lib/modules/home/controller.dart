import 'package:get/get.dart';

import '../../core/services/settings_service.dart';
import 'repository.dart'; // 导入仓库

class HomeController extends GetxController {
  final settings = Get.find<SettingsService>();

  // 1. 实例化仓库
  final HomeRepository _repository = HomeRepository();

  final totalCars = 0.obs;
  final recentAddedCount = 0.obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    refreshDashboard();
  }

  // 2. 调用真实的 API 接口
  Future<void> refreshDashboard() async {
    isLoading.value = true;

    try {
      // 执行网络请求
      final res = await _repository.fetchHomeData();

      if (res.data != null) {
        // 请求成功，更新响应式变量
        totalCars.value = res.data!.totalCars;
        recentAddedCount.value = res.data!.recentAdded;
      }
    } finally {
      // 无论成功还是失败，最后都关掉加载状态
      isLoading.value = false;
    }
  }

  void quickAddCar() {
    print("触发快捷入库");
  }
}
