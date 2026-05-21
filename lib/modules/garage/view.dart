import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:mix/mix.dart';
import '../../core/theme/app_mix_themes.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/app_theme_tool.dart';
import '../../core/widgets/filter_chips/filter_chips.dart';
import '../../core/widgets/filter_chips/filter_chips.variant.dart';
import '../../core/widgets/product/product.dart';
import 'controller.dart';
import 'widget/stats_dashboard/stats_dashboard.dart';

class GarageView extends GetView<GarageController> {
  const GarageView({super.key});

  // --- Mix 样式定义 ---

  // 顶部统计卡片文字样式
  Style get labelStyle => Style(
    $text.style.color.white38(),
    $text.style.fontSize(10),
    $text.style.fontWeight.bold(),
  );

  Style get valueStyle => Style(
    $text.style.color.white(),
    $text.style.fontSize(20),
    $text.style.fontWeight.bold(),
    $text.style.fontFamily('Inter'), // 建议使用硬朗的字体
  );

  // 搜索框容器样式
  Style get searchBarBoxStyle => Style(
    $box.color(const Color(0xFF161616)),
    $box.borderRadius.all(12),
    $box.border.all.color(Colors.white10),
    $box.padding.horizontal(12),
  );

  Style get sectionTitleStyle => Style(
    $text.style.color.white(),
    $text.style.fontSize(14),
    $text.style.fontWeight.bold(),
    $text.style.letterSpacing(1.2),
  );

  Style get cardDecoration => Style(
    $box.color(const Color(0xFF121212)),
    $box.borderRadius.all(12),
    $box.border.all.color(Colors.white.withOpacity(0.05)),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: StyledText('MY GARAGE', style: AppMixStyles.titleStyle),
        // actions: [IconButton(icon: const Icon(Icons.search), onPressed: () {})],
      ),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // 1. 统计面板
              const SliverToBoxAdapter(child: SizedBox(height: 16)),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Obx(
                    () => StatsDashboard(
                      modelsCount:
                          "${controller.filteredModels.length}", // 举例：动态拿到当前的长度
                      brandsCount: "32",
                      valuation: "\$14.2K",
                    ),
                  ),
                ),
              ),

              // 2. The Vault 展示
              // _buildTheVaultHeader(),
              // _buildMainCard(),

              // 3.筛选
              _buildStickyFilterPanel(context),

              // 4. Shelf View 宫格
              _buildShelfHeader(),

              Obx(() {
                return controller.isListMode.value
                    ? _buildListView()
                    : _buildGridView();
              }),
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
        ],
      ),
    );
  }

  // 🌟 将搜索和筛选合并为一个吸顶组件
  Widget _buildStickyFilterPanel(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true, // 关键：设置为 true 开启吸顶效果
      delegate: _SliverHeaderDelegate(
        height: 128, // 严格计算后的总面板高度
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 1. 搜索框部分 (去掉了原本多余的 vertical padding，改为精准控制)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: SizedBox(
                height: 40,
                child: TextField(
                  style: context.textStyle(mxt.textStyle.body),
                  onChanged: (value) {},
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
                      borderRadius: BorderRadius.all(
                        context.radius(mxt.radius.large),
                      ),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  ),
                ),
              ),
            ),

            // 2. 筛选 Chips 部分
            HBox(
              style: Style(
                $box.padding.horizontal(16),
                $box.padding.vertical(8),
              ),
              children: [
                Expanded(
                  child: FilterChips(
                    filters: controller.filters.take(5).toList(),
                    selectedFilter: controller.selectedFilter,
                    onSelected: (v) => controller.changeFilter(v),
                    type: FilterChipType.outlined,
                  ),
                ),
                const SizedBox(width: 8),
                _buildTuneButton(context),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // 列表布局
  Widget _buildListView() {
    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverList.separated(
        itemCount: controller.filteredModels.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) =>
            ProductItem(controller.filteredModels[index], isListMode: true),
      ),
    );
  }

  // 网格布局
  Widget _buildGridView() {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      sliver: Obx(
        () => SliverMasonryGrid.count(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childCount: controller.filteredModels.length,
          itemBuilder: (context, index) =>
              ProductItem(controller.filteredModels[index], isListMode: false),
        ),
      ),
    );
  }

  Widget _buildTuneButton(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.tune, size: 20),
      onPressed: () => Scaffold.of(context).openEndDrawer(),
    );
  }

  Widget _buildTheVaultHeader() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
        child: Row(
          children: [
            Container(width: 24, height: 2, color: const Color(0xFFE54335)),
            const SizedBox(width: 8),
            StyledText("THE  VAULT", style: sectionTitleStyle),
            const Spacer(),
            const Text(
              "ARCHIVE 01",
              style: TextStyle(
                color: Colors.white24,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainCard() {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        height: 240,
        child: Stack(
          children: [
            // 卡片主体
            Box(
              style: cardDecoration.merge(
                Style($box.width.infinity(), $box.height.infinity()),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Column(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Image.network(
                        'https://your-image-url/gtr_r35.jpg', // 替换为你的 GT-R 图片
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        color: const Color(0xFF161616),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "LIBERTY WALK PERFORMANCE",
                                  style: TextStyle(
                                    color: Color(0xFFE54335),
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  "Nissan GT-R R35",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "STATUS",
                                  style: TextStyle(
                                    color: Colors.white38,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "MINT / IN BOX",
                                  style: TextStyle(
                                    color: Color(0xFFE54335),
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // 图片上的 Super Chase 标签 (带斜切效果)
            Positioned(
              top: 12,
              left: 12,
              child: ClipPath(
                clipper: TagClipper(),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  color: const Color(0xFFE54335),
                  child: const Text(
                    "SUPER CHASE",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
            ),
            // 数量标签
            Positioned(
              top: 12,
              left: 100,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  "1 OF 100",
                  style: TextStyle(color: Colors.white, fontSize: 9),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShelfHeader() {
    final FocusNode dropdownFocus = FocusNode();
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            // 🌟 1. 用 DropdownButton 替代原本的 "SHELF VIEW" 标题
            Obx(() {
              return DropdownButtonHideUnderline(
                child: DropdownButton<SortType>(
                  focusNode: dropdownFocus,
                  value: controller.currentSort.value,
                  alignment: Alignment.centerLeft,
                  onChanged: (SortType? newValue) {
                    dropdownFocus.unfocus();
                    if (newValue != null) {
                      controller.updateSortWithoutPop(newValue);
                    }
                  },
                  // 🌟 关键优化：定制按钮闭合时在主界面上展示的纯净外观
                  selectedItemBuilder: (BuildContext context) {
                    return controller.sortOptions.map((item) {
                      return Box(
                        child: HBox(
                          children: [
                            StyledIcon(
                              item['icon'] as IconData,
                              style: Style(
                                $icon.color.ref(mxt.color.onSurface),
                                $icon.size(14),
                              ),
                            ),
                            const SizedBox(width: 10),
                            StyledText(
                              (item['label'] as String).toUpperCase(),
                              style: Style(
                                $text.color.ref(mxt.color.onSurface),
                                $text.style.ref(mxt.textStyle.caption),
                                $text.letterSpacing(1.2),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList();
                  },
                  // 展开后的菜单项样式优化
                  items: controller.sortOptions.map((item) {
                    final itemValue = item['value'] as SortType;
                    final isSelected =
                        controller.currentSort.value == itemValue;

                    return DropdownMenuItem<SortType>(
                      value: itemValue,
                      child: Container(
                        // 填满包裹，并给一丁点内边距
                        width: double.infinity,
                        height: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            StyledIcon(
                              item['icon'] as IconData,
                              style: Style(
                                $icon.color.ref(
                                  isSelected
                                      ? mxt.color.primary
                                      : mxt.color.onSurface,
                                ),
                                $icon.size(14),
                              ),
                            ),
                            const SizedBox(width: 10),
                            StyledText(
                              item['label'] as String,
                              style: Style(
                                $text.color.ref(
                                  isSelected
                                      ? mxt.color.primary
                                      : mxt.color.onSurface,
                                ),
                                $text.style.ref(mxt.textStyle.caption),
                                $text.letterSpacing(1.2),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              );
            }),
            const Spacer(),

            // 2. 右侧保持原有的 列表/网格 切换按钮
            Obx(() {
              return IconButton(
                icon: Icon(
                  controller.isListMode.value
                      ? Icons.list_rounded
                      : Icons.grid_view_rounded,
                  size: 20,
                ),
                onPressed: controller.toggleViewMode,
              );
            }),
          ],
        ),
      ),
    );
  }
}

// 专门用于实现图片中那种左侧垂直、右侧倾斜的标签感
// --- 修正后的斜切标签裁剪器 ---
class TagClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    // 1. 起点：左上角
    path.lineTo(0, 0);
    // 2. 移动到右上角，但往左缩进 10 像素形成斜边
    path.lineTo(size.width - 10, 0);
    // 3. 移动到右下角
    path.lineTo(size.width, size.height);
    // 4. 移动到左下角
    path.lineTo(0, size.height);
    // 5. 闭合
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class _SliverHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double height;

  _SliverHeaderDelegate({required this.child, required this.height});

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    // 使用 Material 阻断背景穿透，并强制子组件占满系统给予的当前实际高度空间
    return Material(
      color: Theme.of(context).scaffoldBackgroundColor,
      elevation: overlapsContent ? 2 : 0,
      child: SizedBox.expand(
        child: SingleChildScrollView(
          // 防止极端情况下出现像素溢出，允许微弱的内部滑动或者直接截断
          physics: const NeverScrollableScrollPhysics(),
          child: child,
        ),
      ),
    );
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(covariant _SliverHeaderDelegate oldDelegate) {
    return oldDelegate.height != height || oldDelegate.child != child;
  }
}
