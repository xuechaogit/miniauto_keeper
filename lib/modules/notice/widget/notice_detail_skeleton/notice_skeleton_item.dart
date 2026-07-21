import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mix/mix.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/custom_shimmer/custom_shimmer.dart';

import 'package:miniauto_keeper/core/utils/screen_adapter.dart';

// 导入你提供的通用骨架屏组件
// import 'path_to_your_custom_shimmer/custom_shimmer.dart';

class NoticeDetailSkeletonStyles {
  /// 骨架屏专用的黑灰色块样式，完美契合车库暗黑工业风
  static Style get shimmerBlockStyle => Style($box.borderRadius(4));
}

class NoticeDetailSkeleton extends StatelessWidget {
  const NoticeDetailSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomShimmer(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(r(24.0)),
        physics: const NeverScrollableScrollPhysics(), // 骨架状态下锁定滚动
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. 顶部元数据流光块
            Row(
              children: [
                CustomShimmerBlock(
                  width: 100,
                  height: 12,
                  style: NoticeDetailSkeletonStyles.shimmerBlockStyle,
                ),
                const Spacer(),
                CustomShimmerBlock(
                  width: 50,
                  height: 12,
                  style: NoticeDetailSkeletonStyles.shimmerBlockStyle,
                ),
              ],
            ),
            SizedBox(height: h(20)),

            // 2. 模拟大标题（错落两行，更具真实感）
            CustomShimmerBlock(
              width: double.infinity,
              height: 24,
              style: NoticeDetailSkeletonStyles.shimmerBlockStyle,
            ),
            SizedBox(height: h(8)),
            CustomShimmerBlock(
              width: Get.width * 0.6,
              height: 24,
              style: NoticeDetailSkeletonStyles.shimmerBlockStyle,
            ),
            SizedBox(height: h(16)),

            // 3. 工业分割线占位
            CustomShimmerBlock(
              width: double.infinity,
              height: 2,
              style: NoticeDetailSkeletonStyles.shimmerBlockStyle,
            ),
            SizedBox(height: h(28)),

            // 4. 模拟富文本段落一
            CustomShimmerBlock(
              width: double.infinity,
              height: 16,
              style: NoticeDetailSkeletonStyles.shimmerBlockStyle,
            ),
            SizedBox(height: h(12)),
            CustomShimmerBlock(
              width: double.infinity,
              height: 16,
              style: NoticeDetailSkeletonStyles.shimmerBlockStyle,
            ),
            SizedBox(height: h(12)),
            CustomShimmerBlock(
              width: Get.width * 0.8,
              height: 16,
              style: NoticeDetailSkeletonStyles.shimmerBlockStyle,
            ),
            SizedBox(height: h(24)),

            // 5. 模拟富文本段落二
            CustomShimmerBlock(
              width: double.infinity,
              height: 16,
              style: NoticeDetailSkeletonStyles.shimmerBlockStyle,
            ),
            SizedBox(height: h(12)),
            CustomShimmerBlock(
              width: Get.width * 0.4,
              height: 16,
              style: NoticeDetailSkeletonStyles.shimmerBlockStyle,
            ),
          ],
        ),
      ),
    );
  }
}
