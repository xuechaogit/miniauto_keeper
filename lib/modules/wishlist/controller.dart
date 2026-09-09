import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:miniauto_keeper/core/router/app_routes.dart';
import 'package:miniauto_keeper/core/services/garage_repository.dart';
import 'package:miniauto_keeper/core/services/wishlist_repository.dart';
import 'package:miniauto_keeper/core/utils/snackbar_util.dart';
import 'package:miniauto_keeper/core/widgets/form/form_builder/form_builder.dart';
import 'package:miniauto_keeper/models/garage_item.dart';
import 'package:miniauto_keeper/models/wishlist_entry.dart';
import 'package:miniauto_keeper/modules/brand/brand_list/widgets/add_garage_sheet/add_garage_sheet.dart';

class WishlistController extends GetxController {
  /// 全局仓库：唯一数据源（MainBinding 常驻，不随路由销毁）
  final repo = Get.find<WishlistRepository>();

  RxList<WishlistEntry> get items => repo.items;

  /// 搜索输入框控制器（Controller 持有，随页面销毁释放，避免每次 build 重建丢光标）
  final searchCtrl = TextEditingController();

  final keyword = ''.obs;
  final selectedBrands = <String>{}.obs;
  final displayItems = <WishlistEntry>[].obs;

  bool get isEmpty => items.isEmpty;

  /// 首屏加载中且尚无数据（供 view 显示 loading）
  bool get isLoading => repo.isLoading.value && items.isEmpty;

  /// 触底加载更多中（供 view 显示 footer）
  bool get isLoadingMore => repo.isLoadingMore.value;

  @override
  void onInit() {
    super.onInit();
    repo.ensureLoaded();
    _applyFilters();
    everAll([keyword, selectedBrands], (_) => _applyFilters());
  }

  @override
  void onClose() {
    searchCtrl.dispose();
    super.onClose();
  }

  /// 清空搜索词与输入框
  void clearSearch() {
    keyword.value = '';
    searchCtrl.clear();
  }

  /// 加入心愿单（入口可来自品牌/详情页），委托仓库置脏，进入页面再重拉。
  void addItem(WishlistAddRequest req) {
    repo.addToWishlist(req);
  }

  Future<void> removeItem(WishlistEntry entry) async {
    try {
      await repo.removeFromWishlist(entry.id);
      _applyFilters();
    } catch (_) {
      SnackBarUtil.error('移除失败，请稍后重试');
    }
  }

  /// 加入车库：弹出入库表单，成功后写入车库并从心愿单移除
  void addToGarage(WishlistEntry entry) {
    final formKey = GlobalKey<FormBuilderState>();
    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      builder: (_) => FractionallySizedBox(
        heightFactor: 0.75,
        child: AddGarageSheet(
          formKey: formKey,
          productName: entry.model.name.isNotEmpty
              ? entry.model.name
              : entry.model.modelNumber,
          onSubmit: (values) => _submitGarage(entry, values),
        ),
      ),
    );
  }

  bool _isSubmitting = false;

  /// 车模状况(表单中文枚举) → 后端 condition 数值
  static const _conditionMap = {'全新': 1, '近新': 2, '有瑕疵': 3, '破损': 4};

  Future<void> _submitGarage(
    WishlistEntry entry,
    Map<String, dynamic> values,
  ) async {
    if (_isSubmitting) return;
    _isSubmitting = true;
    try {
      final req = GarageAddRequest(
        modelId: entry.model.id,
        purchaseDate: values['purchaseDate']?.toString() ?? '',
        purchasePrice: double.tryParse('${values['purchasePrice'] ?? ''}') ?? 0,
        purchaseChannel: values['purchaseChannel']?.toString().trim() ?? '',
        condition: _conditionMap[values['condition']?.toString()] ?? 1, // 默认全新
        notes: _emptyToNull(values['notes']),
        isPublic: true, // 表单未录入公开状态，默认公开
      );
      await Get.find<GarageRepository>().addToGarage(req);
      // 加入车库成功后从心愿单移除该条目
      await repo.removeFromWishlist(entry.id);
      _applyFilters();
      SnackBarUtil.success('已加入车库');
      if (Get.isBottomSheetOpen ?? false) Get.back();
    } catch (e) {
      SnackBarUtil.error(_extractApiMessage(e));
    } finally {
      _isSubmitting = false;
    }
  }

  void openProductDetail(WishlistEntry entry) {
    Get.toNamed('${AppRoutes.productDetail}?id=${entry.model.id}');
  }

  void loadMore() => repo.loadMore();

  /// 提取接口错误信息：优先响应体 message，兜底 e.error；其余异常直接 toString。
  String _extractApiMessage(Object e) {
    if (e is DioException) {
      final body = e.response?.data;
      if (body is Map && body['message'] != null) {
        return '${body['message']}';
      }
      return '${e.error ?? '请求失败，请稍后重试'}';
    }
    return '$e';
  }

  void _applyFilters() {
    var list = items.toList();

    if (keyword.value.isNotEmpty) {
      final kw = keyword.value.toLowerCase();
      list = list
          .where((e) {
            final m = e.model;
            return m.modelNumber.toLowerCase().contains(kw) ||
                '${m.brand.name} ${m.scale} ${m.material} ${m.color}'
                    .toLowerCase()
                    .contains(kw);
          })
          .toList();
    }

    if (selectedBrands.isNotEmpty) {
      list = list
          .where((e) => selectedBrands.contains(e.model.brand.name))
          .toList();
    }

    displayItems.value = list;
  }

  static String? _emptyToNull(dynamic v) {
    final s = v?.toString().trim() ?? '';
    return s.isEmpty ? null : s;
  }
}
