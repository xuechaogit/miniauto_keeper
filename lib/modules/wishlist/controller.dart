import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:miniauto_keeper/models/wishlist_item.dart';

enum WishlistSort { newest, oldest, priceHigh, priceLow }

class WishlistController extends GetxController {
  static const boxName = 'wishlist';

  final items = <WishlistItem>[].obs;
  final isLoading = false.obs;
  final isEmpty = false.obs;
  final isGridMode = true.obs;
  final sortMode = WishlistSort.newest.obs;

  late Box<WishlistItem> _box;

  @override
  void onInit() {
    super.onInit();
    _box = Hive.box<WishlistItem>(boxName);
    loadItems();
  }

  Future<void> loadItems() async {
    isLoading.value = true;
    try {
      final all = _box.values.toList();
      sort(all);
      items.value = all;
      isEmpty.value = all.isEmpty;
    } finally {
      isLoading.value = false;
    }
  }

  void addItem(WishlistItem item) {
    _box.put(item.id, item);
    loadItems();
  }

  Future<void> removeItem(String id) async {
    await _box.delete(id);
    loadItems();
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
