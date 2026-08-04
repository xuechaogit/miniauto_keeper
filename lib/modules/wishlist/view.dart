import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mix/mix.dart';

import '../../core/theme/app_theme.dart';
import '../../core/theme/app_theme_tool.dart';
import '../../core/utils/screen_adapter.dart';
import '../../core/widgets/custom_shimmer/custom_shimmer.dart';
import '../../core/widgets/product/product.dart';
import '../../models/product_model.dart';
import '../../models/wishlist_item.dart';
import 'controller.dart';

class WishlistView extends GetView<WishlistController> {
  const WishlistView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.color(mxt.color.background),
      appBar: AppBar(
        backgroundColor: context.color(mxt.color.surface),
        elevation: 0,
        title: const Text('我的想要'),
        actions: [
          IconButton(
            icon: const Icon(Icons.sort_rounded),
            tooltip: '排序',
            onPressed: () => _showSortSheet(context),
          ),
          IconButton(
            icon: Obx(
              () => Icon(
                controller.isGridMode.value
                    ? Icons.view_list_rounded
                    : Icons.grid_view_rounded,
              ),
            ),
            tooltip: '切换视图',
            onPressed: () => controller.toggleViewMode(),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return _buildShimmer();
        }
        if (controller.isEmpty.value) {
          return _buildEmptyState(context);
        }
        return controller.isGridMode.value
            ? _buildGrid(context)
            : _buildList(context);
      }),
    );
  }

  Widget _buildShimmer() {
    return CustomShimmer(
      child: GridView.builder(
        padding: EdgeInsets.all(w(12)),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.72,
        ),
        itemCount: 4,
        itemBuilder: (_, __) => Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(r(12)),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.favorite_border_rounded,
            size: w(64),
            color: context.color(mxt.color.onSurfaceVariant).withOpacity(0.3),
          ),
          SizedBox(height: h(16)),
          Text(
            '还没有心仪的宝贝',
            style: TextStyle(
              fontSize: sp(16),
              color: context.color(mxt.color.onSurfaceVariant),
            ),
          ),
          SizedBox(height: h(8)),
          Text(
            '去逛逛发现喜欢的，点击收藏加入心愿单',
            style: TextStyle(
              fontSize: sp(13),
              color: context.color(mxt.color.onSurfaceVariant).withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGrid(BuildContext context) {
    return Obx(
      () => GridView.builder(
        padding: EdgeInsets.all(w(12)),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: w(12),
          crossAxisSpacing: w(12),
          childAspectRatio: 0.72,
        ),
        itemCount: controller.items.length,
        itemBuilder: (_, index) {
          final item = controller.items[index];
          return _buildDismissibleItem(item, context, isListMode: false);
        },
      ),
    );
  }

  Widget _buildList(BuildContext context) {
    return Obx(
      () => ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: w(12), vertical: w(8)),
        itemCount: controller.items.length,
        itemBuilder: (_, index) {
          final item = controller.items[index];
          return Padding(
            padding: EdgeInsets.only(bottom: w(8)),
            child: _buildDismissibleItem(item, context, isListMode: true),
          );
        },
      ),
    );
  }

  Widget _buildDismissibleItem(
    WishlistItem item,
    BuildContext context, {
    required bool isListMode,
  }) {
    return Dismissible(
      key: Key(item.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: w(24)),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.8),
          borderRadius: BorderRadius.circular(r(12)),
        ),
        child: Icon(Icons.delete_outline, color: Colors.white, size: w(28)),
      ),
      confirmDismiss: (_) async {
        return await Get.defaultDialog<bool>(
              title: '移除心愿',
              middleText: '确定要移除「${item.title}」吗？',
              textConfirm: '确定',
              textCancel: '取消',
              confirmTextColor: Colors.white,
              onConfirm: () => Get.back(result: true),
              onCancel: () => Get.back(result: false),
            ) ??
            false;
      },
      onDismissed: (_) => controller.removeItem(item.id),
      child: ProductItem(
        _toProductModel(item),
        isListMode: isListMode,
        onTap: () => controller.openProductDetail(item.productId),
      ),
    );
  }

  ProductModel _toProductModel(WishlistItem item) {
    return ProductModel(
      id: item.productId,
      title: item.title,
      brandName: item.brandName,
      price: item.price,
      thumb: item.thumb,
      tags: const [],
      description: item.note ?? '',
      purchaseDate: '',
    );
  }

  void _showSortSheet(BuildContext context) {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: context.color(mxt.color.surface),
          borderRadius: BorderRadius.vertical(top: Radius.circular(r(16))),
        ),
        padding: EdgeInsets.all(w(16)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: w(36),
              height: w(4),
              decoration: BoxDecoration(
                color: context.color(mxt.color.outlineVariant),
                borderRadius: BorderRadius.circular(r(2)),
              ),
            ),
            SizedBox(height: h(16)),
            Text(
              '排序方式',
              style: TextStyle(
                fontSize: sp(16),
                fontWeight: FontWeight.w600,
                color: context.color(mxt.color.onSurface),
              ),
            ),
            SizedBox(height: h(12)),
            _sortOption(context, '最新添加', WishlistSort.newest),
            _sortOption(context, '最早添加', WishlistSort.oldest),
            _sortOption(context, '价格从高到低', WishlistSort.priceHigh),
            _sortOption(context, '价格从低到高', WishlistSort.priceLow),
            SizedBox(height: h(16)),
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
    );
  }

  Widget _sortOption(BuildContext context, String label, WishlistSort mode) {
    return Obx(() {
      final isSelected = controller.sortMode.value == mode;
      return ListTile(
        title: Text(
          label,
          style: TextStyle(
            fontSize: sp(14),
            color: isSelected
                ? context.color(mxt.color.primary)
                : context.color(mxt.color.onSurface),
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        trailing: isSelected
            ? Icon(Icons.check, color: context.color(mxt.color.primary))
            : null,
        onTap: () {
          controller.setSortMode(mode);
          Get.back();
        },
      );
    });
  }
}
