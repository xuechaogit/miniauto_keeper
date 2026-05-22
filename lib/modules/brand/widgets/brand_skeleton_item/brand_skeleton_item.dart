import 'package:flutter/material.dart';
import 'package:mix/mix.dart';
import '../../../../core/widgets/custom_shimmer/custom_shimmer.dart';
import 'brand_skeleton_item.style.dart';

class BrandSkeletonItem extends StatelessWidget {
  const BrandSkeletonItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Box(
      style: Style.combine([
        BrandSkeletonItemStyle.container,
        BrandSkeletonItemStyle.contentPadding,
      ]),
      child: CustomShimmer(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. 顶部：对应真实卡片的数字统计 Row (CountText + SubLabelText)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    // 数字占位 (对应 48 号大字)
                    const CustomShimmerBlock(width: 70, height: 48),
                    const SizedBox(width: 12),
                    // "Total Inclusion" 提示文字占位
                    const CustomShimmerBlock(width: 110, height: 16),
                  ],
                ),

                const Spacer(),

                // 2. 中下部：标签组 Row
                Row(
                  children: [
                    // "1:64" 标签占位
                    CustomShimmerBlock(
                      width: 45,
                      height: 22,
                      style: BrandSkeletonItemStyle.tagBlock,
                    ),
                    const SizedBox(width: 8),
                    // 品牌名字标签占位
                    CustomShimmerBlock(
                      width: 80,
                      height: 22,
                      style: BrandSkeletonItemStyle.tagBlock,
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // 3. 底部：单行描述文字占位
                const CustomShimmerBlock(width: 240, height: 14),
              ],
            ),
            // 数字占位 (对应 48 号大字)
            const CustomShimmerBlock(width: 70, height: 48),
          ],
        ),
      ),
    );
  }
}
