import 'package:collection/collection.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../../models/wishlist_item.dart';
import 'storage_service.dart';

class WishlistService extends GetxService {
  final StorageService _storage = Get.find<StorageService>();

  static const _boxName = 'wishlist';

  final items = <WishlistItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadItems();
  }

  void loadItems() {
    final box = Hive.box<WishlistItem>(_boxName);
    items.value = box.values.toList();
  }

  void addItem(WishlistItem item) {
    _storage.write<WishlistItem>(_boxName, item.id, item);
    items.add(item);
  }

  Future<void> removeItem(String productId) async {
    final target = items.firstWhereOrNull((e) => e.productId == productId);
    if (target != null) {
      await _storage.remove<WishlistItem>(_boxName, target.id);
      items.removeWhere((e) => e.productId == productId);
    }
  }

  bool exists(String productId) {
    return items.any((e) => e.productId == productId);
  }

  WishlistItem? findById(String id) {
    try {
      return items.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }
}
