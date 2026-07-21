import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';

import '../../core/services/settings_service.dart';
import '../../core/utils/screen_adapter.dart';
import 'repository.dart';
import '../../models/product_model.dart';

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

  final hotProducts = [
    ProductModel(
      id: '1',
      title: 'Porsche 911 (992) GT3 RS - Ice Grey',
      brandName: 'Porsche',
      price: 299.0,
      imageUrl:
          'https://images.unsplash.com/photo-1503376780353-7e6692767b70?q=80&w=800',
      tags: ['1:18', 'Limited'],
    ),
    ProductModel(
      id: '2',
      title: 'Ferrari SF90 Stradale Assetto Fiorano',
      brandName: 'Ferrari',
      price: 350.0,
      imageUrl:
          'https://images.unsplash.com/photo-1592198084033-aade902d1aae?q=80&w=800',
      tags: ['1:18', 'Diecast'],
    ),
    ProductModel(
      id: '3',
      title: 'Lamborghini Huracán STO - Blue Laufey',
      brandName: 'Lamborghini',
      price: 280.0,
      imageUrl:
          'https://images.unsplash.com/photo-1544636331-e26879cd4d9b?q=80&w=800',
      tags: ['1:43', 'In Stock'],
    ),
    ProductModel(
      id: '4',
      title:
          'Lamborghini Huracán STO - Blue Laufey Lamborghini Huracán STO - Blue Laufey',
      brandName: 'Lamborghini',
      price: 280.0,
      imageUrl:
          'https://images.unsplash.com/photo-1544636331-e26879cd4d9b?q=80&w=800',
      tags: ['1:43', 'In Stock'],
    ),
    ProductModel(
      id: '5',
      title:
          'Lamborghini Huracán STO - Blue Laufey Lamborghini Huracán STO - Blue Laufey',
      brandName: 'Lamborghini',
      price: 280.0,
      imageUrl:
          'https://images.unsplash.com/photo-1544636331-e26879cd4d9b?q=80&w=800',
      tags: ['1:43', 'In Stock'],
    ),
    ProductModel(
      id: '6',
      title: 'BMW M4 CSL (G82) - Frozen Grey',
      brandName: 'BMW',
      price: 180.0,
      imageUrl:
          'https://images.unsplash.com/photo-1555215695-3004980ad94e?q=80&w=800',
      tags: ['1:18', 'New'],
    ),
    ProductModel(
      id: '7',
      title: 'Audi RS6 Avant - Nardo Grey Custom',
      brandName: 'Audi',
      price: 150.0,
      imageUrl:
          'https://images.unsplash.com/photo-1606152421660-0e7829762957?q=80&w=800',
      tags: ['1:43', 'Classic'],
    ),
  ].obs;

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(_onScroll);
    refreshDashboard();
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
