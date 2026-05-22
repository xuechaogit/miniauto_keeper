import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mix/mix.dart';
import '../../core/widgets/paged_list/paged_list.dart';
import 'controller.dart';
import 'widget/notice_item/notice_item.dart';
import 'widget/notice_skeleton_item/notice_skeleton_item.dart';

// ==========================================
// 视图页面：公告列表
// ==========================================
class NoticeListView extends GetView<NoticeController> {
  const NoticeListView({super.key});

  @override
  Widget build(BuildContext context) {
    // 实例化滚动控制器来监听列表触底
    final ScrollController scrollController = ScrollController();

    scrollController.addListener(() {
      // 当滚动距离接近底部 50 像素以内时，触发加载更多
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 50) {
        controller.fetchMoreNotices();
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'SYSTEM NOTICES',
          style: TextStyle(fontFamily: 'Courier', fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => controller.fetchNotices(),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsetsGeometry.all(16),
        child: AppPagedListView<NoticeModel>(
          data: controller.notices,
          isLoading: controller.isLoading,
          isLoadingMore: controller.isLoadingMore,
          hasMore: controller.hasMore,
          onLoadMore: controller.fetchMoreNotices,
          // 全局初次加载时显示的骨架屏结构
          skeletonList: ListView.separated(
            itemCount: 5,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) => const NoticeSkeletonItem(),
          ),
          // 单项如何渲染的声明
          itemBuilder: (context, notice, index) {
            return NoticeItem(
              notice: notice,
              onTap: () => controller.viewDetails(notice),
            );
          },
        ),
      ),
    );
  }
}
