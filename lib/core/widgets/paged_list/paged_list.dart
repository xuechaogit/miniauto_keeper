import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mix/mix.dart';
import 'paged_list.style.dart';

class AppPagedListView<T> extends StatefulWidget {
  final List<T> data; // 数据源
  final RxBool isLoading; // 首次/刷新的全局加载状态
  final RxBool isLoadingMore; // 触底加载更多状态
  final RxBool hasMore; // 是否还有更多数据
  final Future<void> Function() onLoadMore; // 触发加载更多的回调
  final Widget Function(BuildContext context, T item, int index)
  itemBuilder; // 单项渲染器
  final Widget skeletonList; // 全局加载时的骨架屏占位
  final EdgeInsetsGeometry? padding; // 列表内边距
  final bool _isSliver; // 内部标记位
  final double gap; // 内部标记位

  const AppPagedListView({
    Key? key,
    required this.data,
    required this.isLoading,
    required this.isLoadingMore,
    required this.hasMore,
    required this.onLoadMore,
    required this.itemBuilder,
    required this.skeletonList,
    this.gap = 16,
    this.padding,
  }) : _isSliver = false,
       super(key: key);

  // 注意：在 sliver 模式下，外部必须传入一个 ScrollController 给 CustomScrollView
  const AppPagedListView.sliver({
    Key? key,
    required this.data,
    required this.isLoading,
    required this.isLoadingMore,
    required this.hasMore,
    required this.itemBuilder,
    required this.skeletonList, // 这里要求传入一个 Sliver 组件，比如 SliverList
    this.gap = 16,
  }) : padding = null,
       _isSliver = true,
       onLoadMore = _emptyCallback,
       super(key: key);
  // 2. 在类内部定义一个静态的空函数常量
  static Future<void> _emptyCallback() async {}

  @override
  State<AppPagedListView<T>> createState() => _AppPagedListViewState<T>();
}

class _AppPagedListViewState<T> extends State<AppPagedListView<T>> {
  // 普通模式才需要内部控制器
  ScrollController? _internalScrollController;

  @override
  void initState() {
    super.initState();
    // 如果是 sliver 模式，监听就由外部的 CustomScrollView 搞定，这里不用自己监听触底
    if (!widget._isSliver) {
      _internalScrollController = ScrollController()..addListener(_onScroll);
    }
  }

  void _onScroll() {
    if (_internalScrollController!.position.pixels >=
        _internalScrollController!.position.maxScrollExtent - 50) {
      widget.onLoadMore();
    }
  }

  @override
  void dispose() {
    _internalScrollController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (widget.isLoading.value) {
        //// 如果是 sliver 模式，确保外部传进来的是 SliverToBoxAdapter(child: Skeleton) 或者是 SliverList
        return widget.skeletonList;
      }

      if (widget.data.isEmpty) {
        // 如果是 sliver 模式，空状态也得包裹在 SliverToBoxAdapter 里
        Widget emptyWidget = const Center(
          child: Text(
            'NO DATA',
            style: TextStyle(color: Color(0xFF666666), fontFamily: 'Courier'),
          ),
        );
        return widget._isSliver
            ? SliverToBoxAdapter(child: emptyWidget)
            : emptyWidget;
      }

      // 💥 如果是 Sliver 模式，直接返回 SliverList
      if (widget._isSliver) {
        return SliverList.separated(
          itemCount: widget.data.length + 1,
          // 🌟 每一项卡片的渲染器
          itemBuilder: (context, index) {
            if (index == widget.data.length) return _buildFooterIndicator();
            return widget.itemBuilder(context, widget.data[index], index);
          },
          // 🌟 这里就是你要的 Item 之间的间距！要多大给多大
          separatorBuilder: (context, index) => SizedBox(height: widget.gap),
        );
      }

      // 普通模式保持原样
      return ListView.separated(
        controller: _internalScrollController,
        itemCount: widget.data.length + 1,
        itemBuilder: (context, index) {
          if (index == widget.data.length) return _buildFooterIndicator();
          return widget.itemBuilder(context, widget.data[index], index);
        },
        separatorBuilder: (context, index) => SizedBox(height: widget.gap),
      );
    });
  }

  /// 内部构建底部指示器
  Widget _buildFooterIndicator() {
    return Obx(() {
      if (widget.isLoadingMore.value) {
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Center(
            child: SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFE54335)),
                strokeWidth: 2,
              ),
            ),
          ),
        );
      }

      if (!widget.hasMore.value) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Center(
            child: StyledText(
              '// END OF CODES. NO MORE DATA //',
              style: AppPagedStyles.footerText,
            ),
          ),
        );
      }

      return const SizedBox.shrink();
    });
  }
}
