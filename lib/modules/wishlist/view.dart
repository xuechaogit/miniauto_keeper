import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:miniauto_keeper/core/widgets/product/product.style.dart';

import 'package:mix/mix.dart';

import '../../core/theme/app_theme.dart';
import '../../core/theme/app_theme_tool.dart';
import '../../core/utils/screen_adapter.dart';
import '../../core/widgets/product/product.dart';

import '../../models/wishlist_entry.dart';
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
      ),
      body: Column(
        children: [
          _buildSearchBar(context),
          // _buildBrandChips(context),
          Expanded(child: _buildBody(context)),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(w(12), h(8), w(12), h(4)),
      child: TextField(
        controller: controller.searchCtrl,
        onChanged: (v) => controller.keyword.value = v,
        decoration: InputDecoration(
          hintText: '搜索商品名称或品牌',
          hintStyle: TextStyle(
            fontSize: sp(14),
            color: context.color(mxt.color.onSurfaceVariant).withOpacity(0.5),
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            size: w(20),
            color: context.color(mxt.color.onSurfaceVariant),
          ),
          suffixIcon: Obx(
            () => controller.keyword.value.isNotEmpty
                ? IconButton(
                    icon: Icon(Icons.clear_rounded, size: w(18)),
                    onPressed: controller.clearSearch,
                  )
                : const SizedBox.shrink(),
          ),
          filled: true,
          fillColor: context.color(mxt.color.surface).withOpacity(0.3),
          contentPadding: EdgeInsets.symmetric(vertical: h(10)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(r(10)),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildBrandChips(BuildContext context) {
    return Obx(() {
      final brands = controller.items
          .map((e) => e.model.brand.name)
          .where((n) => n.isNotEmpty)
          .toSet()
          .toList();
      if (brands.isEmpty) return const SizedBox.shrink();

      return SizedBox(
        height: h(40),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: w(12)),
          itemCount: brands.length,
          itemBuilder: (_, index) {
            final brand = brands[index];
            final isSelected = controller.selectedBrands.contains(brand);
            return Padding(
              padding: EdgeInsets.only(right: w(8)),
              child: FilterChip(
                label: Text(
                  brand,
                  style: TextStyle(
                    fontSize: sp(12),
                    color: isSelected
                        ? context.color(mxt.color.primary)
                        : context.color(mxt.color.onSurface),
                  ),
                ),
                selected: isSelected,
                onSelected: (v) {
                  if (v) {
                    controller.selectedBrands.add(brand);
                  } else {
                    controller.selectedBrands.remove(brand);
                  }
                  controller.selectedBrands.refresh();
                },
                backgroundColor: context
                    .color(mxt.color.surface)
                    .withOpacity(0.3),
                selectedColor: context.color(mxt.color.primary),
                checkmarkColor: context.color(mxt.color.primary),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(r(20)),
                ),
                side: BorderSide.none,
                visualDensity: VisualDensity.compact,
              ),
            );
          },
        ),
      );
    });
  }

  Widget _buildBody(BuildContext context) {
    return Obx(() {
      if (controller.isLoading) {
        return const Center(child: CircularProgressIndicator());
      }
      if (controller.isEmpty) {
        return _buildEmptyState(context);
      }
      if (controller.displayItems.isEmpty) {
        return _buildSearchEmptyState(context);
      }
      return _buildGrid(context);
    });
  }

  Widget _buildGrid(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        // 接近底部时触发分页加载更多
        if (notification.metrics.pixels >=
            notification.metrics.maxScrollExtent - 200) {
          controller.loadMore();
        }
        return false;
      },
      child: Obx(
        () => MasonryGridView.count(
          padding: EdgeInsets.all(w(12)),
          crossAxisCount: 2,
          mainAxisSpacing: w(12),
          crossAxisSpacing: w(12),
          itemCount:
              controller.displayItems.length +
              (controller.isLoadingMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index >= controller.displayItems.length) {
              return const Padding(
                padding: EdgeInsets.all(16),
                child: Center(
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              );
            }
            final item = controller.displayItems[index];
            final title = item.model.name.isNotEmpty
                ? item.model.name
                : item.model.modelNumber;
            return Dismissible(
              key: ValueKey(item.id),
              direction: DismissDirection.endToStart,
              background: Container(
                alignment: Alignment.centerRight,
                padding: EdgeInsets.only(right: w(24)),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(r(12)),
                ),
                child: Icon(
                  Icons.delete_outline,
                  color: Colors.white,
                  size: w(28),
                ),
              ),
              confirmDismiss: (_) async {
                return await Get.defaultDialog<bool>(
                      title: '移除心愿',
                      middleText: '确定要移除「$title」吗？',
                      textConfirm: '确定',
                      textCancel: '取消',
                      confirmTextColor: Colors.white,
                      onConfirm: () => Get.back(result: true),
                      onCancel: () => Get.back(result: false),
                    ) ??
                    false;
              },
              onDismissed: (_) => controller.removeItem(item),
              child: ProductItem(
                item.model,
                onTap: () => controller.openProductDetail(item),
                actionBar: _buildActionBar(item),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildActionBar(WishlistEntry item) {
    return HBox(
      style: ProductStyle.gridActionBar,
      children: [
        PressableBox(
          onPress: () => controller.removeItem(item),
          child: StyledIcon(
            Icons.favorite_outline,
            style: Style(
              $icon.size(sp(24)),
              $icon.color(const Color(0xFFE54335)),
            ),
          ),
        ),
        Expanded(
          child: PressableBox(
            onPress: () => controller.addToGarage(item),
            child: HBox(
              style: ProductStyle.gridAddGarageBtn,
              children: [
                StyledText('加入车库', style: ProductStyle.gridAddGarageBtnText),
              ],
            ),
          ),
        ),
      ],
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

  Widget _buildSearchEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: w(64),
            color: context.color(mxt.color.onSurfaceVariant).withOpacity(0.3),
          ),
          SizedBox(height: h(16)),
          Text(
            '没有找到相关商品',
            style: TextStyle(
              fontSize: sp(16),
              color: context.color(mxt.color.onSurfaceVariant),
            ),
          ),
        ],
      ),
    );
  }
}
