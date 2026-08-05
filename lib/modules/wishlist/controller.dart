import 'package:get/get.dart';
import 'package:miniauto_keeper/core/services/wishlist_service.dart';
import 'package:miniauto_keeper/models/wishlist_item.dart';

enum WishlistSort { newest, oldest, priceHigh, priceLow }

class WishlistController extends GetxController {
  final _service = Get.find<WishlistService>();

  RxList<WishlistItem> get items => _service.items;

  final isLoading = false.obs;
  final isGridMode = true.obs;
  final sortMode = WishlistSort.newest.obs;

  bool get isEmpty => items.isEmpty;

  void addItem(WishlistItem item) {
    _service.addItem(item);
    sort(items);
  }

  Future<void> removeItem(String id) async {
    await _service.removeItem(id);
  }

  void toggleViewMode() {
    isGridMode.toggle();
  }

  void openProductDetail(String productId) {
    Get.toNamed('/detail', arguments: {'id': productId});
  }

  void setSortMode(WishlistSort mode) {
    sortMode.value = mode;
    sort(items);
  }

  void sort(List<WishlistItem> list) {
    switch (sortMode.value) {
      case WishlistSort.newest:
        list.sort((a, b) => b.addedAt.compareTo(a.addedAt));
        break;
      case WishlistSort.oldest:
        list.sort((a, b) => a.addedAt.compareTo(b.addedAt));
        break;
      case WishlistSort.priceHigh:
        list.sort((a, b) => b.price.compareTo(a.price));
        break;
      case WishlistSort.priceLow:
        list.sort((a, b) => a.price.compareTo(b.price));
        break;
    }
    items.refresh();
  }
}
