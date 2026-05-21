import 'package:flutter/material.dart';
import 'package:mix/mix.dart';
// 引入刚刚封装的通用骨架屏

import '../../../../core/widgets/custom_shimmer/custom_shimmer.dart';
import 'notice_skeleton_item.style.dart';

class NoticeSkeletonItem extends StatelessWidget {
  const NoticeSkeletonItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 外层照旧留着带有 Card 属性颜色的 Box
    return Box(
      style: NoticeSkeletonStyles.cardMix,
      child: CustomShimmer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 模拟标题
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Expanded(
                  child: CustomShimmerBlock(height: 18, width: double.infinity),
                ),
                SizedBox(width: 40),
                CustomShimmerBlock(height: 18, width: 36),
              ],
            ),
            const SizedBox(height: 12),
            // 模拟正文第一行
            const CustomShimmerBlock(height: 14, width: double.infinity),
            const SizedBox(height: 8),
            // 模拟正文第二行
            const FractionallySizedBox(
              widthFactor: 0.6,
              child: CustomShimmerBlock(height: 14, width: double.infinity),
            ),
            const SizedBox(height: 16),
            // 模拟底部元数据
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                CustomShimmerBlock(height: 12, width: 60),
                CustomShimmerBlock(height: 12, width: 80),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
