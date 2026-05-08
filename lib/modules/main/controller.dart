import 'package:get/get.dart';

class MainController extends GetxController {
  // 当前选中的 Tab 索引
  final _currentIndex = 0.obs;
  int get currentIndex => _currentIndex.value;

  // 切换 Tab 方法
  void changePage(int index) {
    _currentIndex.value = index;
  }

  // 如果需要点击中间的特殊按钮或执行特定逻辑，可以在这里写
}
