import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:mix/mix.dart';
import '../../core/theme/app_mix_themes.dart';
import '../../core/widgets/filter_chips/filter_chips.dart';
import '../../core/widgets/filter_chips/filter_chips.variant.dart';
import '../../core/widgets/product/product.dart';
import 'controller.dart';

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
      backgroundColor: const Color(0xFF0A0A0A), // 极黑背景
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: StyledText('MY GARAGE', style: AppMixStyles.titleStyle),
        // actions: [IconButton(icon: const Icon(Icons.search), onPressed: () {})],
      ),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // 2. 统计面板
              _buildStatsDashboard(),

              // 4. The Vault 展示
              // _buildTheVaultHeader(),
              // _buildMainCard(),

              // 5.筛选
              _buildSearchAndFilterActions(),
              _buildExpandedRow(context),

              // 7. 底部占位
              const SliverToBoxAdapter(child: SizedBox(height: 32)),

              // 6. Shelf View 宫格
              _buildShelfHeader(),

              // _buildShelfGrid(),
              // _buildGridView(),
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

  // 情况 B：正常展开时的布局
  Widget _buildExpandedRow(BuildContext context) {
    return SliverToBoxAdapter(
      child: HBox(
        style: Style($box.padding.horizontal(16)),
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
    );
  }

  Widget _buildTuneButton(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.tune, size: 20),
      onPressed: () => Scaffold.of(context).openEndDrawer(),
    );
  }

  Widget _actionButton({
    required IconData icon,
    required VoidCallback onTap,
    bool isPrimary = false, // 是否使用强调色（红色系）
  }) {
    // 定义 Mix 样式
    final buttonStyle = Style(
      $box.width(48),
      $box.height(48),
      $box.borderRadius.all(12),
      // 根据是否为 Primary 切换背景色
      $box.color(
        isPrimary
            ? const Color(0xFFE54335).withOpacity(0.1)
            : const Color(0xFF161616),
      ),
      // 细微的边框，增强工业感
      $box.border.all.color(
        isPrimary
            ? const Color(0xFFE54335).withOpacity(0.4)
            : Colors.white.withOpacity(0.05),
      ),
    );

    return Pressable(
      onPress: onTap,
      child: Box(
        style: buttonStyle,
        child: Center(
          child: Icon(
            icon,
            // 图标颜色也随状态切换
            color: isPrimary ? const Color(0xFFE54335) : Colors.white70,
            size: 22,
          ),
        ),
      ),
    );
  }

  // 弹出排序菜单
  void _showSortMenu() {
    Get.bottomSheet(
      Box(
        style: Style(
          $box.color(const Color(0xFF161616)),
          $box.borderRadius.top(20),
          $box.padding.all(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "SORT BY",
              style: TextStyle(
                color: Colors.white38,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            _sortOption(
              "Price: High to Low",
              SortType.priceDesc,
              Icons.arrow_downward,
            ),
            _sortOption(
              "Price: Low to High",
              SortType.priceAsc,
              Icons.arrow_upward,
            ),
            const Divider(color: Colors.white10, height: 32),
            _sortOption(
              "Date: Newest First",
              SortType.dateDesc,
              Icons.calendar_today,
            ),
            _sortOption("Date: Oldest First", SortType.dateAsc, Icons.history),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _sortOption(String label, SortType type, IconData icon) {
    return Obx(() {
      final isSelected = controller.currentSort.value == type;
      return Pressable(
        onPress: () => controller.updateSort(type),
        child: Box(
          style: Style(
            $box.padding.vertical(12),
            $box.padding.horizontal(8),
            $box.borderRadius.all(8),
            // 选中时给一个微弱的红色背景
            // ifCondition(
            //   isSelected,
            //   Style(
            //     $box.backgroundColor.color(
            //       const Color(0xFFE54335).withOpacity(0.1),
            //     ),
            //   ),
            // ),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 18,
                color: isSelected ? const Color(0xFFE54335) : Colors.white38,
              ),
              const SizedBox(width: 16),
              Text(
                label.toUpperCase(),
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.white70,
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              const Spacer(),
              if (isSelected)
                const Icon(Icons.check, color: Color(0xFFE54335), size: 18),
            ],
          ),
        ),
      );
    });
  }

  // 2. 统计面板 (还原：MODELS, BRANDS, VALUATION)
  Widget _buildStatsDashboard() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Row(
          children: [
            _statItem("MODELS", "256"),
            _divider(),
            _statItem("BRANDS", "32"),
            _divider(),
            _statItem("VALUATION", "\$14.2k", isRed: true),
            const Spacer(),
            // 占位，留给右侧的浮动按钮空间
            const SizedBox(width: 60),
          ],
        ),
      ),
    );
  }

  // 3. 搜索与排序 (实现你要求的 1 和 2)
  Widget _buildSearchAndFilterActions() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            Expanded(
              child: Box(
                style: searchBarBoxStyle,
                child: TextField(
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: "SEARCH MODELS...",
                    hintStyle: const TextStyle(
                      color: Colors.white24,
                      fontSize: 12,
                    ),
                    icon: Icon(Icons.manage_search, color: Colors.white38),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // 2. 排序按钮 (普通状态)
            _actionButton(
              icon: Icons.unfold_more_rounded,
              onTap: () => _showSortMenu(),
            ),
          ],
        ),
      ),
    );
  }

  // 辅助组件：统计项
  Widget _statItem(String label, String value, {bool isRed = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StyledText(label, style: labelStyle),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: isRed ? const Color(0xFFE54335) : Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
          ),
        ),
      ],
    );
  }

  Widget _divider() => Container(
    margin: const EdgeInsets.symmetric(horizontal: 20),
    width: 0.5,
    height: 30,
    color: Colors.white10,
  );

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
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            StyledText("SHELF VIEW", style: sectionTitleStyle),
            const Spacer(),
            Obx(() {
              return controller.isListMode.value
                  ? IconButton(
                      icon: const Icon(Icons.list_rounded, size: 20),
                      onPressed: controller.toggleViewMode,
                    )
                  : IconButton(
                      icon: const Icon(Icons.grid_view_rounded, size: 20),
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
