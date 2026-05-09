import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mix/mix.dart';
import 'filter_chips.style.dart';
import 'filter_chips.variant.dart';

typedef FilterChipBuilder =
    Widget Function(BuildContext context, int index, bool isSelected);

class FilterChips extends StatefulWidget {
  // 修改为 StatefulWidget 以管理 ScrollController
  List<String> filters;
  RxString selectedFilter;
  final Function(String) onSelected;
  final bool uppercase;
  final FilterChipType type;

  // 新增：自定义构建器插槽
  final FilterChipBuilder? itemBuilder;

  FilterChips({
    super.key,
    required this.filters,
    required this.selectedFilter,
    required this.onSelected,
    this.uppercase = true,
    this.type = FilterChipType.outlined,
  }) : itemBuilder = null; // 默认构造函数不使用 builder

  // 新增：专门用于高度自定义样式的构造函数
  FilterChips.builder({
    super.key,
    required this.filters,
    required this.selectedFilter,
    required this.onSelected,
    required this.itemBuilder,
    this.type = FilterChipType.outlined,
    this.uppercase = true,
  });

  @override
  State<FilterChips> createState() => _FilterChipsState();
}

class _FilterChipsState extends State<FilterChips> {
  late ScrollController _scrollController;
  // 定义一个 Worker 用来取消监听
  Worker? _worker;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    // _setupWorker(); // 抽离出监听逻辑
    // 1. 初始位置滚动
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _handleInitialScroll();
    });
  }

  // 关键：当父组件重新构建并传入新的 filters 时触发
  // @override
  // void didUpdateWidget(covariant FilterChips oldWidget) {
  //   super.didUpdateWidget(oldWidget);

  //   // 关键点：如果 filters 列表内容变了
  //   if (oldWidget.filters != widget.filters ||
  //       oldWidget.selectedFilter != widget.selectedFilter) {
  //     _worker?.dispose();
  //     _setupWorker(); // 重新绑定

  //     WidgetsBinding.instance.addPostFrameCallback((_) {
  //       _handleInitialScroll();
  //     });
  //   }
  // }

  void _setupWorker() {
    _worker = ever(widget.selectedFilter, (String value) {
      // 现在的 widget.filters 保证是最新的
      final index = widget.filters.indexOf(value);
      if (index != -1) {
        _scrollToIndex(index);
      }
    });
  }

  void _handleInitialScroll() {
    final index = widget.filters.indexOf(widget.selectedFilter.value);
    if (index != -1) {
      _scrollToIndex(index);
    }
  }

  @override
  void dispose() {
    _worker?.dispose();
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
  @override
  Widget build(BuildContext context) {
    return Box(
      // style: FilterChipStyles.container,
      child: SizedBox(
        height: widget.itemBuilder != null ? 90 : 36, // 如果是自定义插槽（如日历），高度调大
        child: ListView.separated(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          itemCount: widget.filters.length,
          separatorBuilder: (context, index) => const SizedBox(width: 12),
          itemBuilder: (context, index) {
            final filter = widget.filters[index];

            return Obx(() {
              final isSelected = widget.selectedFilter.value == filter;

              // --- 核心改动：插槽逻辑 ---
              if (widget.itemBuilder != null) {
                return GestureDetector(
                  onTap: () {
                    widget.onSelected(filter);
                    _scrollToIndex(index);
                  },
                  child: widget.itemBuilder!(context, index, isSelected),
                );
              }
              // --- 默认逻辑 ---
              return GestureDetector(
                onTap: () {
                  widget.onSelected(filter);
                  _scrollToIndex(index);
                },
                child: _buildDefaultChip(filter, isSelected),
              );
            });
          },
        ),
      ),
    );
  }

  /// --- 核心修正：定义缺失的默认构建方法 ---
  Widget _buildDefaultChip(String filter, bool isSelected) {
    return Stack(
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
    );
  }
}
