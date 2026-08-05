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
import '../../../core/widgets/product/product.style.dart';
import '../../../models/product_model.dart';

import 'package:miniauto_keeper/core/widgets/load_more_footer/load_more_footer.dart';

import 'controller.dart';

class BrandDetailView extends GetView<BrandDetailController> {
  const BrandDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: context.color(mxt.color.background),
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

                // 筛选栏：未滚动时在列表中展示，滚动后由悬浮层接管
                SliverToBoxAdapter(
                  child: Obx(() {
                    final isScrolled = controller.isScrolled.value;

                    return IgnorePointer(
                      ignoring: isScrolled, // 隐藏时禁止点击交互
                      child: Opacity(
                        opacity: isScrolled ? 0.0 : 1.0, // 隐藏时设为透明（完全占位）
                        child: const BrandFilterBar(),
                      ),
                    );
                  }),
                ),

                // 商品列表
                _buildProductGrid(context),

                // 底部加载状态
                // 4. 底部加载状态（修正后的结构）
                SliverToBoxAdapter(
                  child: Obx(() {
                    // 首次加载中，或者数据为空时，不展示加载底栏
                    if (controller.isLoading.value ||
                        controller.products.isEmpty) {
                      return const SizedBox.shrink();
                    }

                    // 状态 1：正在加载更多
                    if (controller.isLoadingMore.value) {
                      return const LoadMoreFooter(
                        status: LoadMoreStatus.loading,
                      );
                    }

                    // 状态 2：加载失败，支持点击重试
                    if (controller.isLoadMoreError.value) {
                      return LoadMoreFooter(
                        status: LoadMoreStatus.error,
                        onRetry: controller.loadMore,
                      );
                    }

                    // 状态 3：没有更多数据了
                    if (!controller.hasMore.value) {
                      return const LoadMoreFooter(
                        status: LoadMoreStatus.noMore,
                      );
                    }

                    // 状态 4：空置（虽然有更多，但当前未触底）
                    return const SizedBox.shrink();
                  }),
                ),
              ],
            ),
          ),

          // ── 2. 顶层：直接悬浮覆盖在页面最上方的 AppBar ──
          Obx(() {
            final isScrolled = controller.isScrolled.value;

            return AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              // 未滚动时隐藏到屏幕上方，滚动后贴紧最顶端（0）
              top: isScrolled ? 0 : -(kToolbarHeight + topPadding + 50),
              left: 0,
              right: 0,
              child: Container(
                color: context.color(mxt.color.surface),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    BrandSearchBar(),
                    if (isScrolled)
                      VBox(
                        children: [
                          const BrandFilterBar(),
                          SizedBox(height: w(12)),
                        ],
                      ),
                  ],
                ),
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
          childCount: controller.products.length,
          itemBuilder: (context, index) {
            final product = controller.products[index];
            return ProductItem(
              product,
              onTap: () => controller.toProductDetail(product),
              actionBar: HBox(
                style: ProductStyle.gridActionBar,
                children: [
                  PressableBox(
                    onPress: () => controller.toggleFav(product),
                    child: Obx(
                      () => StyledIcon(
                        controller.isFav(product)
                            ? Icons.star_sharp
                            : Icons.star_border_sharp,
                        style: Style(
                          $icon.size(sp(24)),
                          $icon.color(
                            controller.isFav(product)
                                ? const Color(0xFFE54335)
                                : const Color(0xFF888888),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: PressableBox(
                      onPress: () => controller.addToGarage(product),
                      child: HBox(
                        style: ProductStyle.gridAddGarageBtn,
                        children: [
                          StyledText(
                            '加入车库',
                            style: ProductStyle.gridAddGarageBtnText,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );
    });
  }
}
