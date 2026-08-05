import 'package:get/get.dart';
import 'package:miniauto_keeper/core/services/wishlist_service.dart';
import 'package:miniauto_keeper/core/utils/snackbar_util.dart';
import 'package:miniauto_keeper/models/wishlist_item.dart';

class WishlistController extends GetxController {
  final _service = Get.find<WishlistService>();

  RxList<WishlistItem> get items => _service.items;

  final keyword = ''.obs;
  final selectedBrands = <String>{}.obs;
  final displayItems = <WishlistItem>[].obs;

  bool get isEmpty => items.isEmpty;

  @override
  void onInit() {
    super.onInit();
    _applyFilters();
    everAll([keyword, selectedBrands], (_) => _applyFilters());
  }

  void addItem(WishlistItem item) {
    _service.addItem(item);
    _applyFilters();
  }

  Future<void> removeItem(String productId) async {
    await _service.removeItem(productId);
    _applyFilters();
  }

  void addToGarage(WishlistItem item) {
    SnackBarUtil.primary('已加入车库');
  }

  void openProductDetail(String productId) {
    Get.toNamed('/detail', arguments: {'id': productId});
  }

  void _applyFilters() {
    var list = items.toList();

    if (keyword.value.isNotEmpty) {
      final kw = keyword.value.toLowerCase();
      list = list.where((e) =>
          e.title.toLowerCase().contains(kw) ||
          e.brandName.toLowerCase().contains(kw)).toList();
    }

    if (selectedBrands.isNotEmpty) {
      list = list.where((e) => selectedBrands.contains(e.brandName)).toList();
    }

    displayItems.value = list;
  }
}
