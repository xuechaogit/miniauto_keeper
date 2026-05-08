// lib/modules/brand/brand_detail/controller.dart
import 'package:get/get.dart';
import '../../../../models/product_model.dart';
import '../../../models/brand_stats.dart';

class BrandDetailController extends GetxController {
  // 响应式商品列表
  final products = <ProductModel>[].obs;

  // 筛选标签状态
  final selectedFilter = 'All'.obs;
  final filters = [
    'All MODELS',
    '1:18 SCALE',
    '1:43 SCALE',
    'Limited1',
    'In Stock2',
    'All MODELS3',
    '1:18 SCALE4',
    '1:43 SCALE5',
    'Limited6',
    'In Stock7',
  ];

  // 如果你担心参数为空导致崩溃，可以加个兜底：
  BrandModel get brand => Get.arguments ?? BrandModel(name: 'Unknown');

  @override
  void onInit() {
    super.onInit();
    _loadMockProducts();
  }

  void _loadMockProducts() {
    // 模拟网络延迟
    Future.delayed(const Duration(milliseconds: 500), () {
      products.value = [
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
        // ProductModel(
        //   id: '4',
        //   title: 'BMW M4 CSL (G82) - Frozen Grey',
        //   brandName: 'BMW',
        //   price: 180.0,
        //   imageUrl:
        //       'https://images.unsplash.com/photo-1555215695-3004980ad94e?q=80&w=800',
        //   tags: ['1:18', 'New'],
        // ),
        // ProductModel(
        //   id: '5',
        //   title: 'Audi RS6 Avant - Nardo Grey Custom',
        //   brandName: 'Audi',
        //   price: 150.0,
        //   imageUrl:
        //       'https://images.unsplash.com/photo-1606152421660-0e7829762957?q=80&w=800',
        //   tags: ['1:43', 'Classic'],
        // ),
      ];
    });
  }

  void addToGarage(ProductModel product) {
    // 加入车库逻辑
    Get.snackbar('Success', '${product.title} added to Garage');
  }

  void changeFilter(String filter) {
    selectedFilter.value = filter;
    // 这里可以写实际的过滤逻辑
  }
}
