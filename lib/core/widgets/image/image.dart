import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../theme/app_theme.dart';
import '../../theme/app_theme_tool.dart';
import '../custom_shimmer/custom_shimmer.dart';

class CustomImage extends StatelessWidget {
  final String imageUrl;
  final double aspectRatio;
  final BoxFit fit;
  final double borderRadius;

  const CustomImage({
    super.key,
    required this.imageUrl,
    this.aspectRatio = 1.0,
    this.fit = BoxFit.cover,
    this.borderRadius = 0,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: AspectRatio(
        aspectRatio: aspectRatio,
        child: Image.network(
          imageUrl,
          fit: fit,
          // 关键点 1：frameBuilder 处理从“无”到“有”的渲染帧监听
          frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
            // 如果是同步加载（缓存命中），直接给图，不要任何动画
            if (wasSynchronouslyLoaded) return child;

            // 如果图片还没准备好（包括请求中、下载中、解码中）
            if (frame == null) {
              return _buildShimmer(context); // 这里放你的 Shimmer 或 Loading 文本
            }

            return AnimatedOpacity(
              opacity: 1.0,
              duration: const Duration(milliseconds: 400),
              child: child,
            );
          },
          // 关键点 2：loadingBuilder 处理大文件下载时的字节流监听
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return _buildShimmer(context);
          },
          // 关键点 3：错误处理
          errorBuilder: (context, error, stackTrace) => Container(
            color: context.color(mxt.color.shimmerBase),
            child: Icon(
              Icons.directions_car_filled,
              size: 72,
              color: context.color(mxt.color.onSurfaceVariant),
            ),
          ),
        ),
      ),
    );
  }

  // 内部封装的骨架屏样式
  Widget _buildShimmer(BuildContext context) {
    return CustomShimmer(
      child: Container(
        color: context.color(mxt.color.shimmerBase), // 这里的颜色会被 Shimmer 覆盖
      ),
    );
  }
}
