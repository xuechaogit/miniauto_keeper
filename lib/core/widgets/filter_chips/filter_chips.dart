import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mix/mix.dart';
import 'filter_chips.style.dart';
import 'filter_chips.variant.dart';

class FilterChips extends StatefulWidget {
  // 修改为 StatefulWidget 以管理 ScrollController
  final List<String> filters;
  final RxString selectedFilter;
  final Function(String) onSelected;
  final bool uppercase;
  final FilterChipType type;

  const FilterChips({
    super.key,
    required this.filters,
    required this.selectedFilter,
    required this.onSelected,
    this.uppercase = true,
    this.type = FilterChipType.outlined,
  });

  @override
  State<FilterChips> createState() => _FilterChipsState();
}

class _FilterChipsState extends State<FilterChips> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    // 初始化时，如果已有选中项，延迟一会滚动到对应位置
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final index = widget.filters.indexOf(widget.selectedFilter.value);
      if (index != -1) {
        _scrollToIndex(index);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// 自动滚动逻辑
  void _scrollToIndex(int index) {
    if (!_scrollController.hasClients) return;

    // 估算偏移量 (Item 宽度 + Separator 宽度)
    // 假设：每个 Chip 最小宽度+Padding 大约 80-100，Separator 是 12
    // 如果你的 Chip 长度差异极大，建议使用 GlobalKey 方案，但对于 Filter 来说，估算通常足够好
    const double itemApproxWidth = 90.0;
    const double separatorWidth = 12.0;

    final double targetOffset = index * (itemApproxWidth + separatorWidth);

    // 获取当前视口宽度
    final double viewportWidth = MediaQuery.of(context).size.width;

    // 目标是让选中的 item 尽量靠左（或者居中）
    // 居中计算：targetOffset - (viewportWidth / 2) + (itemApproxWidth / 2)
    final double finalScrollOffset =
        (targetOffset - (viewportWidth / 2) + (itemApproxWidth / 2)).clamp(
          0.0,
          _scrollController.position.maxScrollExtent,
        );

    _scrollController.animateTo(
      finalScrollOffset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Box(
      style: FilterChipStyles.container,
      child: SizedBox(
        height: 36,
        child: ListView.separated(
          controller: _scrollController, // 绑定控制器
          padding: const EdgeInsets.symmetric(horizontal: 16),
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          itemCount: widget.filters.length,
          separatorBuilder: (context, index) => const SizedBox(width: 12),
          itemBuilder: (context, index) {
            final filter = widget.filters[index];
            return Obx(() {
              final isSelected = widget.selectedFilter.value == filter;

              return GestureDetector(
                onTap: () {
                  widget.onSelected(filter);
                  _scrollToIndex(index); // 点击时触发滚动
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Box(
                      style: FilterChipStyles.chipStyle(
                        isSelected,
                        context,
                      ).applyVariant(widget.type),
                      child: StyledText(
                        widget.uppercase ? filter.toUpperCase() : filter,
                        style: FilterChipStyles.textStyle(
                          isSelected,
                          context,
                        ).applyVariant(widget.type),
                      ),
                    ),
                    if (widget.type == FilterChipType.underlined)
                      Positioned(
                        bottom: 0,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          height: 3,
                          width: isSelected ? 24 : 0,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            });
          },
        ),
      ),
    );
  }
}
