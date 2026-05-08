import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:miniauto_keeper/core/theme/app_mix_themes.dart';
import 'package:mix/mix.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_theme_tool.dart';
import '../../../core/widgets/filter_chips/filter_chips.dart';
import '../../../core/widgets/filter_chips/filter_chips.variant.dart';
import '../../../core/widgets/tag/tag.dart';
import '../../../core/widgets/tag/tag.style.dart';
import '../../../models/product_model.dart';
import 'controller.dart';

class BrandDetailView extends GetView<BrandDetailController> {
  const BrandDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(controller.brand.name.toUpperCase()),
        actions: [
          Builder(
            builder: (context) {
              return IconButton(
                icon: const Icon(Icons.tune),
                onPressed: () => Scaffold.of(context).openEndDrawer(),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // 1. 搜索框 (复用你的搜索框样式)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildSearchBar(context),
          ),

          // 2. 筛选标签流
          FilterChips(
            // 数据源：List<String>
            filters: controller.filters,
            // 选中的状态：RxString
            selectedFilter: controller.selectedFilter,
            // 点击回调：将点击的值传递给控制器逻辑
            onSelected: (value) => controller.changeFilter(value),
            // type: FilterChipType.underlined, // 你可以切换成 link 模式试试
            type: FilterChipType.outlined, // 你可以切换成 link 模式试试
          ),

          // 3. 商品列表
          Expanded(
            child: Obx(
              () => MasonryGridView.count(
                padding: const EdgeInsets.all(16),
                crossAxisCount: 2, // 两列
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                itemCount: controller.products.length,
                itemBuilder: (context, index) =>
                    _buildProductCard(context, controller.products[index]),
              ),
            ),
          ),
        ],
      ),
      endDrawer: Drawer(
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
                padding: const EdgeInsets.all(16),
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
                            title: Text(f),
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
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return TextField(
      style: context.textStyle(mxt.textStyle.body),
      // 这里的 controller 可以根据需要绑定到 BrandDetailController
      onChanged: (value) => /* controller.search(value) */ null,
      decoration: InputDecoration(
        hintText: 'Search products in ${controller.brand.name}...',
        filled: true,
        fillColor: context.color(mxt.color.surfaceVariant),
        prefixIcon: Icon(
          Icons.search,
          color: context.color(mxt.color.primary),
          size: 20,
        ),
        // 使用你的 Token 圆角
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(context.radius(mxt.radius.large)),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(
          vertical: context.space(mxt.space.small),
          horizontal: context.space(mxt.space.medium),
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
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: context.color(mxt.color.surface).withOpacity(0.1),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 商品图片 - 瀑布流的关键：不限制 Expanded，改用比例或自适应高度
            Stack(
              children: [
                Image.network(
                  item.imageUrl,
                  fit: BoxFit.cover,
                  // 这里如果不设置高度，Masonry 会根据图片下载后的尺寸自动排版
                  errorBuilder: (c, e, s) =>
                      Container(height: 150, color: Colors.grey),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(12),
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
                  const SizedBox(height: 8),
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
                          padding: const EdgeInsets.all(6),
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
