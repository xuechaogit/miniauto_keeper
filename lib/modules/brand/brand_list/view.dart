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
    return Scaffold(
      backgroundColor: context.color(mxt.color.surface),
      body: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification is ScrollUpdateNotification) {
            controller.isScrolled.value = notification.metrics.pixels > 0;
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
            // ── 搜索栏：滚动后吸顶出现 ──
            Obx(
              () => SliverAppBar(
                pinned: true,
                automaticallyImplyLeading: false,
                elevation: controller.isScrolled.value ? 2 : 0,
                backgroundColor: context.color(mxt.color.surface),
                surfaceTintColor: Colors.transparent,
                title: controller.isScrolled.value
                    ? BrandSearchBar()
                    : const SizedBox.shrink(),
                toolbarHeight: controller.isScrolled.value ? kToolbarHeight : 0,
              ),
            ),

            SliverToBoxAdapter(child: BrandInfoHeaderWidget()),

            // ── 筛选栏（吸顶）──
            // SliverToBoxAdapter(
            //   child: Box(
            //     style: Style(
            //       $box.height(w(16)),
            //       $box.borderRadius.topLeft(r(12)),
            //       $box.borderRadius.topRight(r(12)),
            //       $box.color.ref(mxt.color.surface),
            //     ),
            //   ),
            // ),
            SliverPersistentHeader(
              pinned: true,
              delegate: BrandFilterBarDelegate(),
            ),

            // ── 商品列表 ──
            _buildProductGrid(context),
          ],
        ),
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
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
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
            return GestureDetector(
              onTap: () =>
                  controller.toProductDetail(controller.products[index]),
              child: ProductItem(controller.products[index]),
            );
          },
        ),
      );
    });
  }
}
