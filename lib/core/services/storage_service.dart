// Hive 底层封装
import 'package:hive_flutter/hive_flutter.dart';
import 'package:get/get.dart';

import '../../models/brand_model.dart';

class StorageService extends GetxService {
  // 静态初始化方法，在 main.dart 中调用
  static Future<void> init() async {
    await Hive.initFlutter();

    // 注册 TypeAdapter
    Hive.registerAdapter(BrandModelAdapter());

    // 在这里预开常用的 Box
    await Hive.openBox('settings');
    await Hive.openBox('user');
    await Hive.openBox('cache');
    await Hive.openBox('wishlist');
  }

  // 泛型写入：支持任何已注册适配器的类型
  Future<void> write<T>(String boxName, String key, T value) async {
    var box = Hive.box(boxName);
    await box.put(key, value);
  }

  // 泛型读取
  T read<T>(String boxName, String key, {required T defaultValue}) {
    var box = Hive.box(boxName);
    return box.get(key, defaultValue: defaultValue) as T;
  }

  // 删除
  Future<void> remove<T>(String boxName, String key) async {
    var box = Hive.box(boxName);
    await box.delete(key);
  }

  // 清空整个 Box
  Future<void> clear(String boxName) async {
    await Hive.box(boxName).clear();
  }
}
