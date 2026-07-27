import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:miniauto_keeper/models/product_model.dart';

import '../../core/services/settings_service.dart';
import '../../core/utils/screen_adapter.dart';
import 'repository.dart';
import '../../models/brand_model.dart';
import '../../models/home_stats.dart';
import '../../models/notice_model.dart';

class HomeController extends GetxController {
  final settings = Get.find<SettingsService>();

  final HomeRepository _repository = HomeRepository();

  final ScrollController scrollController = ScrollController();
  final FlutterCarouselController carouselController =
      FlutterCarouselController();

  final totalCars = 0.obs;
  final recentAddedCount = 0.obs;
  final isLoading = false.obs;
  final currentCarouselIndex = 0.obs;
  final carouselAutoPlay = true.obs;
  final isScrolled = false.obs;

  final notices = <NoticeModel>[].obs;
  final noticeCarouselController = FlutterCarouselController();

  final hotProducts = [
    ProductModel(
      id: '1',
      title: 'Porsche 911 (992) GT3 RS - Ice Grey',
      brandName: 'Porsche',
      price: 299.0,
      thumb:
          'https://images.unsplash.com/photo-1503376780353-7e6692767b70?q=80&w=800',
      tags: ['1:18', 'Limited'],
      releaseDate: '2026·08月15日·10:00',
    ),
  ].obs;

  final brands = <BrandModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(_onScroll);
    refreshDashboard();
    fetchNotices();
  }

  @override
  void onClose() {
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    super.onClose();
  }

  void _onScroll() {
    final offset = scrollController.offset;
    final scrolled = offset >= 56;
    if (isScrolled.value != scrolled) {
      isScrolled.value = scrolled;
      if (scrolled) {
        carouselController.stopAutoPlay();
      } else {
        carouselController.startAutoPlay();
      }
    }
  }

  // 2. 调用真实的 API 接口
  Future<void> refreshDashboard() async {
    isLoading.value = true;

    try {
      // 执行网络请求
      final res = await _repository.fetchHomeData();

      if (res.code != 1) throw new Exception(res.message);
      // 请求成功，更新响应式变量
      totalCars.value = res.data!.totalCars;
      recentAddedCount.value = res.data!.recentAdded;
      hotProducts.value = res.data!.itemData.preList.products;
      brands.value = res.data!.brands.take(9).toList();
      print('hotProducts.value ${hotProducts.value}');
    } catch (e) {
      print('e: $e');
    } finally {
      // 无论成功还是失败，最后都关掉加载状态
      isLoading.value = false;
    }
  }

  void quickAddCar() {
    print("触发快捷入库");
  }

  Future<void> fetchNotices() async {
    final response = await _repository.fetchNotices();
    // print('response: $response');
    if (response.data != null) {
      notices.value = response.data!.list;
    }
  }
}
