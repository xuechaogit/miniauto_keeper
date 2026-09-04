import 'package:flutter/material.dart';
import 'package:miniauto_keeper/core/utils/screen_adapter.dart';
import 'package:get/get.dart';
import 'package:miniauto_keeper/models/catalog_brand.dart';

import '../../core/router/app_routes.dart';
import '../../core/services/settings_service.dart';

import '../../core/theme/app_theme.dart';
import '../../core/theme/app_theme_tool.dart';
import '../../core/widgets/paged_list/paged_list.dart';
import '../../core/widgets/tag/tag.dart';

import '../../core/widgets/tag/tag.variant.dart';
import '../../models/brand_stats.dart';

import 'controller.dart';
// 导入MIX
import 'package:mix/mix.dart';
import '../../core/theme/app_mix_themes.dart';
import 'widgets/brand_card/brand_card.dart';
import 'widgets/brand_skeleton_item/brand_skeleton_item.dart';

class BrandView extends GetView<BrandsController> {
  BrandView({super.key});

  // 1. 创建属于整个页面的滚动控制器
  final ScrollController _pageScrollController = ScrollController();

  // 2. 在这里监听整个页面的触底
  void _setupScrollListener() {
    _pageScrollController.addListener(() {
      // 当整个页面滑到距离底部还有 50 像素时
      if (_pageScrollController.position.pixels >=
          _pageScrollController.position.maxScrollExtent - 50) {
        // 💥 重点：直接通知控制器去加载更多，不需要通过组件中转了！
        controller.fetchMoreBrands();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final settings = Get.find<SettingsService>();

    _setupScrollListener();
    return Scaffold(
      // 保持 AppBar 固定，或者你可以把它移入 CustomScrollView 变成 SliverAppBar
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: StyledText('PRECISION HUB', style: AppMixStyles.titleStyle),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => controller.fetchBrands(),
          ),
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
        ],
      ),
      body: CustomScrollView(
        cacheExtent: 1000,
        controller: _pageScrollController,
        // 控制整个页面的内边距，顺便为你底部的卡片预留 120 的安全空间
        slivers: [
          SliverPadding(
            padding: EdgeInsets.fromLTRB(w(16), h(16), w(16), h(32)),
            sliver: SliverMainAxisGroup(
              slivers: [
                // 1. 搜索框
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: h(40),
                    child: TextField(
                      style: context.textStyle(mxt.textStyle.body),
                      onChanged: (value) => null,
                      decoration: InputDecoration(
                        hintText: 'Search products...',
                        filled: true,
                        fillColor: context.color(mxt.color.surfaceVariant),
                        prefixIcon: Icon(
                          Icons.search,
                          color: context.color(mxt.color.primary),
                          size: r(20),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            context.radius(mxt.radius.large),
                          ),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: w(12)),
                      ),
                    ),
                  ),
                ),

                SliverToBoxAdapter(child: SizedBox(height: h(32))),

                // 2. 标题行
                SliverToBoxAdapter(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      StyledText('Brands', style: AppMixStyles.titleStyle),
                      CustomTag(
                        label: 'PREMIUM GREY',
                        type: CustomTagType.primary,
                        size: CustomTagSize.medium,
                        shape: CustomTagShape.rounded,
                      ),
                    ],
                  ),
                ),

                SliverToBoxAdapter(child: SizedBox(height: h(24))),

                AppPagedListView<CatalogBrand>.sliver(
                  data: controller.brands,
                  isLoading: controller.isLoading,
                  isLoadingMore: controller.isLoadingMore,
                  hasMore: controller.hasMore,
                  // 💥 重点修复：这里的骨架屏在 CustomScrollView 环境下必须限制滚动天性
                  skeletonList: SliverList.separated(
                    itemCount: 5,
                    separatorBuilder: (context, index) =>
                        SizedBox(height: h(16)),
                    itemBuilder: (context, index) => const BrandSkeletonItem(),
                  ),

                  itemBuilder: (context, brand, index) {
                    return BrandCard(
                      brand: brand,
                      onTap: () =>
                          Get.toNamed(AppRoutes.brandDetail, arguments: brand),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),

      // 如果你在 Stack 底部定位了悬浮卡片（例如 Positioned(bottom: 0, ...)），可以直接写在这里
    );
  }
}
