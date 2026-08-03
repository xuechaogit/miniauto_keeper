import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:miniauto_keeper/core/theme/app_theme.dart';
import 'package:miniauto_keeper/core/theme/app_theme_tool.dart';
import 'package:miniauto_keeper/core/utils/screen_adapter.dart';
import 'package:miniauto_keeper/modules/brand/brand_list/widgets/brand_app_bar/brand_app_bar.dart';
import 'package:miniauto_keeper/modules/brand/brand_list/widgets/brand_filter_bar/brand_filter_bar.dart';
import 'package:miniauto_keeper/modules/brand/brand_list/widgets/brand_info_header/brand_info_header.dart';
import 'package:mix/mix.dart';

import '../../../core/widgets/product/product.dart';
import '../../../models/product_model.dart';

import 'controller.dart';

class BrandDetailView extends GetView<BrandDetailController> {
  const BrandDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: context.color(mxt.color.surface),
      body: Stack(
        children: [
          // ── 1. 底层：普通的 Scroll 页面（包含你的 Header、筛选栏、列表） ──
          NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (notification is ScrollUpdateNotification) {
                // 滚动超过指定距离（如 80）时显示悬浮 AppBar
                controller.isScrolled.value = notification.metrics.pixels > 80;
              }
              if (notification is ScrollEndNotification &&
                  notification.metrics.pixels >=
                      notification.metrics.maxScrollExtent - 100) {
                controller.loadMore();
              }
              return false;
            },
            child: CustomScrollView(
              slivers: [
                // 动态高度 Header，正常贴顶绘制，不会被强行往下推
                SliverToBoxAdapter(child: BrandInfoHeaderWidget()),

                // 筛选栏（吸顶）
                SliverPersistentHeader(
                  pinned: true,
                  delegate: BrandFilterBarDelegate(topPadding: topPadding),
                ),

                // 商品列表
                _buildProductGrid(context),
              ],
            ),
          ),

          // ── 2. 顶层：直接悬浮覆盖在页面最上方的 AppBar ──
          Obx(() {
            final isScrolled = controller.isScrolled.value;

            return AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              // 未滚动时隐藏到屏幕上方（-100），滚动后贴紧最顶端（0）
              top: isScrolled ? 0 : -(kToolbarHeight + topPadding),
              left: 0,
              right: 0,
              child: Container(
                color: context.color(mxt.color.surface),
                padding: EdgeInsets.only(top: topPadding),
                height: kToolbarHeight + topPadding,
                child: BrandSearchBar(),
              ),
            );
          }),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════
  // 商品列表
  // ═══════════════════════════════════════════

  Widget _buildProductGrid(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const SliverFillRemaining(
          child: Center(child: CircularProgressIndicator()),
        );
      }

      if (controller.products.isEmpty) {
        return const SliverFillRemaining(child: Center(child: Text('暂无商品')));
      }

      return SliverPadding(
        padding: EdgeInsets.all(w(12)),
        sliver: SliverMasonryGrid.count(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childCount:
              controller.products.length +
              (controller.isLoadingMore.value ? 1 : 0),
          itemBuilder: (context, index) {
            if (index >= controller.products.length) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: CircularProgressIndicator(),
                ),
              );
            }
            return ProductItem(
              controller.products[index],
              onTap: () =>
                  controller.toProductDetail(controller.products[index]),
            );
          },
        ),
      );
    });
  }
}
