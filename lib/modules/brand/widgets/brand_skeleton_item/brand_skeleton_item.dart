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
        // 1. 使用 LayoutBuilder 获取父元素约束
        child: LayoutBuilder(
          builder: (context, constraints) {
            // 获取除去 Padding 后，父容器的实际最大可用宽度
            final parentWidth = constraints.maxWidth;

            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 左侧整体设为 Expanded，让它自动占据除去右侧大字后的所有剩余空间
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 1. 顶部：数字统计 Row
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          // 数字占位：占用父宽度的 20%
                          CustomShimmerBlock(
                            width: parentWidth * 0.2,
                            height: 48,
                          ),
                          const SizedBox(width: 12),
                          // 提示文字占位：占用父宽度的 30%
                          CustomShimmerBlock(
                            width: parentWidth * 0.3,
                            height: 16,
                          ),
                        ],
                      ),

                      const Spacer(),

                      // 2. 中下部：标签组 Row
                      Row(
                        children: [
                          // "1:64" 标签占位：占用父宽度的 12%
                          CustomShimmerBlock(
                            width: parentWidth * 0.12,
                            height: 22,
                            style: BrandSkeletonItemStyle.tagBlock,
                          ),
                          const SizedBox(width: 8),
                          // 品牌名字标签占位：占用父宽度的 22%
                          CustomShimmerBlock(
                            width: parentWidth * 0.22,
                            height: 22,
                            style: BrandSkeletonItemStyle.tagBlock,
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // 3. 底部：单行描述文字占位：占用父宽度的 65%
                      CustomShimmerBlock(width: parentWidth * 0.65, height: 14),
                    ],
                  ),
                ),

                const SizedBox(width: 16), // 左右两侧加个安全间距
                // 右侧数字占位：占用父宽度的 20%
                CustomShimmerBlock(width: parentWidth * 0.2, height: 48),
              ],
            );
          },
        ),
      ),
    );
  }
}
