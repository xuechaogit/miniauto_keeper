import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:miniauto_keeper/core/theme/app_mix_themes.dart';
import 'package:mix/mix.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_theme_tool.dart';
import '../../../core/widgets/filter_chips/filter_chips.dart';
import '../../../core/widgets/filter_chips/filter_chips.variant.dart';
import '../../../core/widgets/image/image.dart';
import '../../../models/product_model.dart';
import 'controller.dart';

import 'package:miniauto_keeper/core/utils/screen_adapter.dart';

class BrandDetailView extends GetView<BrandDetailController> {
  const BrandDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(controller.brand.name.toUpperCase())),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            // 1. 初始搜索框：随滚动正常消失
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(w(16), h(8), w(16), h(0)),
                child: _buildSearchBar(context),
              ),
            ),
            // 2. 增强型吸顶 Header
            SliverPersistentHeader(
              pinned: true,
              delegate: _SliverAppBarDelegate(
                minHeight: 64.0, // 稍微加高一点，留给 padding 空间
                maxHeight: 64.0,
                builder: (context, shrinkOffset, isCollapsed) {
                  return Container(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    // 这里就是你的 Padding
                    padding: EdgeInsets.fromLTRB(w(16), h(8), w(16), h(8)),
                    alignment: Alignment.center,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: isCollapsed
                          ? _buildCollapsedRow(context)
                          : _buildExpandedRow(context),
                    ),
                  );
                },
              ),
            ),
          ];
        },
        // 4. 商品列表：保持 MasonryGridView
        body: Obx(
          () => MasonryGridView.count(
            padding: EdgeInsets.fromLTRB(w(16), h(8), w(16), h(16)), // 顶部间距缩小
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            itemCount: controller.products.length,
            itemBuilder: (context, index) => PressableBox(
              onPress: () =>
                  controller.toProductDetailPage(controller.products[index]),
              child: _buildProductCard(context, controller.products[index]),
            ),
          ),
        ),
      ),
      endDrawer: _buildEndDrawer(context),
    );
  }

  Widget _buildTuneButton(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.tune, size: r(20)),
      onPressed: () => Scaffold.of(context).openEndDrawer(),
    );
  }

  // 情况 A：吸顶后的布局 (Key 用于 AnimatedSwitcher 识别变化)
  Widget _buildCollapsedRow(BuildContext context) {
    return Row(
      key: const ValueKey('collapsed'),
      children: [
        Expanded(child: _buildSearchBar(context)),
        SizedBox(width: w(8)),
        _buildTuneButton(context),
      ],
    );
  }

  // 情况 B：正常展开时的布局
  Widget _buildExpandedRow(BuildContext context) {
    return Row(
      key: const ValueKey('expanded'),
      children: [
        Expanded(
          child: FilterChips(
            filters: controller.filters.take(5).toList(),
            selectedFilter: controller.selectedFilter,
            onSelected: (v) => controller.changeFilter(v),
            type: FilterChipType.outlined,
          ),
        ),
        SizedBox(width: w(8)),
        _buildTuneButton(context),
      ],
    );
  }

  Widget _buildEndDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            child: Center(
              child: StyledText(
                'FILTER SETTINGS',
                style: AppMixStyles.titleStyle,
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(r(16)),
              children: [
                const Text(
                  'Categories',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const Divider(),
                // 这里放纵向滚动的筛选列表
                ...controller.filters
                    .map(
                      (f) => Obx(
                        () => CheckboxListTile(
                          title: Text(f['label']),
                          value: controller.selectedFilter.value == f,
                          onChanged: (_) => controller.changeFilter(f),
                          activeColor: context.color(mxt.color.primary),
                        ),
                      ),
                    )
                    .toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return SizedBox(
      // 显式约束高度，确保和 FilterChips 在视觉上分量相当
      height: 40,
      child: TextField(
        textAlignVertical: TextAlignVertical.center, // 确保文字居中
        style: context.textStyle(mxt.textStyle.body),
        onChanged: (value) => null,
        decoration: InputDecoration(
          hintText: 'Search products...',
          filled: true,
          fillColor: context.color(mxt.color.surfaceVariant),
          prefixIcon: Icon(
            Icons.search,
            color: context.color(mxt.color.primary),
            size: 20,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(context.radius(mxt.radius.large)),
            borderSide: BorderSide.none,
          ),
          // 关键：减少垂直 Padding，因为外部已经有 SizedBox 限制高度了
          contentPadding: EdgeInsets.symmetric(horizontal: w(12)),
        ),
      ),
    );
  }

  // 4. 商品卡片设计
  Widget _buildProductCard(BuildContext context, ProductModel item) {
    // 模拟瀑布流的高度差异（实际开发中可以根据图片比例计算）
    // final double aspectRatio = (item.id.hashCode % 2 == 0) ? 1.0 : 0.8;

    return Container(
      decoration: BoxDecoration(
        color: context.color(mxt.color.surfaceVariant).withOpacity(0.4),
        borderRadius: BorderRadius.circular(r(16)),
        border: Border.all(
          color: context.color(mxt.color.surface).withOpacity(0.1),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(r(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 商品图片 - 瀑布流的关键：不限制 Expanded，改用比例或自适应高度
            Stack(
              children: [
                CustomImage(
                  imageUrl: item.imageUrl,
                  aspectRatio: 1, // 如果后端有比例，可以传 item.width / item.height
                  // borderRadius: 16, // 如果需要圆角
                ),
              ],
            ),

            Padding(
              padding: EdgeInsets.all(r(12)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StyledText(
                    item.title,
                    style: Style(
                      $text.style.ref(mxt.textStyle.body),
                      $text.overflow.ellipsis(),
                      $text.maxLines(2),
                    ),
                  ),
                  SizedBox(height: h(8)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${item.price}',
                        style: context
                            .textStyle(mxt.textStyle.body)
                            .copyWith(
                              color: context.color(mxt.color.primary),
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      // 更加低调但精致的“加入车库”触发器
                      GestureDetector(
                        onTap: () => controller.addToGarage(item),
                        child: Container(
                          padding: EdgeInsets.all(r(6)),
                          decoration: BoxDecoration(
                            color: context
                                .color(mxt.color.primary)
                                .withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.add_road,
                            color: context.color(mxt.color.primary),
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 辅助类：用于实现 Sliver 吸顶效果
typedef SliverHeaderBuilder =
    Widget Function(
      BuildContext context, // 第1个
      double shrinkOffset, // 第2个
      bool isCollapsed, // 第3个
    );

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.builder,
  });

  final double minHeight;
  final double maxHeight;
  final SliverHeaderBuilder builder;

  @override
  double get minExtent => minHeight;
  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    // 稍微滚动（比如超过 10 像素）就触发内容切换
    final bool isCollapsed = shrinkOffset > 10;

    return SizedBox.expand(child: builder(context, shrinkOffset, isCollapsed));
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        builder != oldDelegate.builder;
  }
}
