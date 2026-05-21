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

  const AppPagedListView({
    Key? key,
    required this.data,
    required this.isLoading,
    required this.isLoadingMore,
    required this.hasMore,
    required this.onLoadMore,
    required this.itemBuilder,
    required this.skeletonList,
    this.padding,
  }) : super(key: key);

  @override
  State<AppPagedListView<T>> createState() => _AppPagedListViewState<T>();
}

class _AppPagedListViewState<T> extends State<AppPagedListView<T>> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    // 触底前 50 像素触发加载更多
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 50) {
      widget.onLoadMore();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose(); // 自动释放控制器，防止内存占用
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // 1. 初次进入时的全局骨架屏
      if (widget.isLoading.value) {
        return widget.skeletonList;
      }

      // 2. 空状态
      if (widget.data.isEmpty) {
        return const Center(
          child: Text(
            'NO DATA',
            style: TextStyle(color: Color(0xFF666666), fontFamily: 'Courier'),
          ),
        );
      }

      // 3. 数据展示主列表
      return ListView.builder(
        controller: _scrollController,
        padding: widget.padding ?? const EdgeInsets.only(top: 16, bottom: 24),
        itemCount: widget.data.length + 1,
        itemBuilder: (context, index) {
          if (index == widget.data.length) {
            return _buildFooterIndicator();
          }
          return widget.itemBuilder(context, widget.data[index], index);
        },
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
