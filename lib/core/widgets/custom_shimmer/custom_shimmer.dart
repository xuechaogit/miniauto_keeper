import 'package:flutter/material.dart';
import 'package:mix/mix.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_theme_tool.dart';
import 'custom_shimmer.style.dart';

/// ==========================================
/// 1. 骨架屏动画外壳容器
/// ==========================================
class CustomShimmer extends StatelessWidget {
  final Widget child;
  final Duration period;

  const CustomShimmer({
    Key? key,
    required this.child,
    this.period = const Duration(milliseconds: 1200),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 聚合你项目主题中的标准色彩链路

    final baseColor = context.color(mxt.color.shimmerBase);
    final highlightColor = context.color(mxt.color.shimmerHighlight);

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      period: period,
      child: child,
    );
  }
}

/// ==========================================
/// 2. 骨架屏通用原子块组件 (整合 Mix 1.7.0)
/// ==========================================
class CustomShimmerBlock extends StatelessWidget {
  final double? width;
  final double? height;
  final Style? style;

  const CustomShimmerBlock({Key? key, this.width, this.height, this.style})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 合并传入的自定义样式与默认样式
    final finalStyle = style != null
        ? Style.combine([CustomShimmerStyles.defaultBlock, style!])
        : CustomShimmerStyles.defaultBlock;

    return Box(
      style: finalStyle,
      child: SizedBox(width: width, height: height),
    );
  }
}
