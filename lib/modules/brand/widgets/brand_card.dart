import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:mix/mix.dart';
import '../../../../models/brand_stats.dart';
import 'brand_card.style.dart';

class BrandCard extends StatelessWidget {
  final BrandModel brand;
  final VoidCallback? onTap;

  const BrandCard({super.key, required this.brand, this.onTap});

  @override
  Widget build(BuildContext context) {
    // 准备数据
    final brandColor = brand.themeColor ?? Colors.red;
    final String brandName = (brand.name ?? 'UNKNOWN').toUpperCase();

    return Pressable(
      onPress: onTap,
      child: Box(
        style: BrandCardStyle.container,
        child: Stack(
          children: [
            // 1. 底层装饰：方格旗与赛车
            _buildBackgroundDecorations(brandColor),

            // 2. 中层：品牌 Logo 文字 (视觉中心)
            _buildBrandLogo(brandName),

            // 3. 上层：交互与信息层
            _buildInfoLayer(brandName),
          ],
        ),
      ),
    );
  }

  /// 构建背景装饰层
  Widget _buildBackgroundDecorations(Color brandColor) {
    return Stack(
      children: [
        // 赛车方格旗
        Positioned(
          right: -10,
          top: 0,
          bottom: 0,
          child: Opacity(
            opacity: 0.05,
            child: ShaderMask(
              shaderCallback: (rect) => const LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Colors.transparent, Colors.black],
                stops: [0.0, 0.4],
              ).createShader(rect),
              blendMode: BlendMode.dstIn,
              child: Box(style: BrandCardStyle.checkerFlag),
            ),
          ),
        ),
        // 赛车绘制
        Positioned(
          right: 0,
          top: 0,
          bottom: 0,
          width: 320,
          child: Opacity(
            opacity: 0.7,
            child: CustomPaint(painter: _GTCartPainter(brandColor: brandColor)),
          ),
        ),
      ],
    );
  }

  /// 构建品牌 Logo 文本
  Widget _buildBrandLogo(String name) {
    return Positioned(
      right: 25,
      top: 0,
      bottom: 0,
      child: Center(child: StyledText(name, style: BrandCardStyle.logoText)),
    );
  }

  /// 构建信息展示层
  Widget _buildInfoLayer(String brandName) {
    return Box(
      style: BrandCardStyle.contentPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 数量统计
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              StyledText(
                '${brand.totalCount}',
                style: BrandCardStyle.countText,
              ),
              const SizedBox(width: 8),
              StyledText('Total Inclusion', style: BrandCardStyle.subLabelText),
            ],
          ),
          const Spacer(),
          // 标签组
          Row(
            children: [
              _buildMiniTag('1:64'),
              const SizedBox(width: 8),
              _buildMiniTag(brandName),
            ],
          ),
          const SizedBox(height: 12),
          // 描述文字
          StyledText(
            'Latest: Detailed description of the limited edition...',
            style: BrandCardStyle.descriptionText,
          ),
        ],
      ),
    );
  }

  /// 内部复用的 MiniTag
  Widget _buildMiniTag(String text) {
    return Box(
      style: BrandCardStyle.miniTagContainer,
      child: StyledText(text, style: BrandCardStyle.miniTagText),
    );
  }
}

/// 赛车图形绘制器 (私有，仅供 BrandCard 使用)
class _GTCartPainter extends CustomPainter {
  final Color brandColor;

  _GTCartPainter({required this.brandColor});

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    // ===== 整体缩小 =====
    const scale = 0.8;

    canvas.save();

    // 以右下为锚点缩小（适合你现在的赛车位置）
    canvas.translate(w * (1 - scale), h * (1 - scale));

    canvas.scale(scale);

    // 1. 提亮后的主车身渐变
    final bodyPaint = Paint()
      ..shader = ui.Gradient.linear(
        Offset(w * 0.2, h * 0.2),
        Offset(w, h),
        [
          brandColor.withOpacity(0.0), // 起点保持透明
          brandColor.withOpacity(0.3), // 中段减淡 (原 0.6)
          brandColor.withOpacity(0.5), // 终点最高处设为 0.5 (原 0.9)
        ],
        [0.0, 0.4, 1.0], // 调整权重，让颜色在更靠后的位置才显现
      );

    final bodyPath = Path()
      ..moveTo(0, h * 0.65)
      ..quadraticBezierTo(w * 0.35, h * 0.25, w * 0.6, h * 0.35)
      ..lineTo(w * 0.85, h * 0.35)
      ..lineTo(w * 0.88, h * 0.15)
      ..lineTo(w * 0.98, h * 0.15)
      ..lineTo(w, h * 0.3)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();

    canvas.drawPath(bodyPath, bodyPaint);

    // 2. 增强高光层 (Highlight) - 让轮廓更锐利、更亮
    final highlightPaint = Paint()
      ..color = Colors.white
          .withOpacity(0.4) // 提高亮度 (原 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final highlightPath = Path()
      ..moveTo(w * 0.1, h * 0.62)
      ..quadraticBezierTo(w * 0.35, h * 0.28, w * 0.6, h * 0.36);
    canvas.drawPath(highlightPath, highlightPaint);

    // 3. 尾翼阴影 - 调浅一点，避免显得脏
    final wingShadowPaint = Paint()..color = Colors.black.withOpacity(0.2);
    final wingShadowPath = Path()
      ..moveTo(w * 0.85, h * 0.35)
      ..lineTo(w * 0.98, h * 0.35)
      ..lineTo(w * 0.95, h * 0.42)
      ..close();
    canvas.drawPath(wingShadowPath, wingShadowPaint);

    // 4. 赛车拉花 - 使用更透的白色
    final liveryPaint = Paint()
      ..color = Colors.white
          .withOpacity(0.25) // 减淡 (原 0.5)
      ..style = PaintingStyle.fill;

    final liveryPath = Path()
      ..moveTo(w * 0.4, h)
      ..lineTo(w * 0.55, h)
      ..lineTo(w * 0.7, h * 0.55)
      ..lineTo(w * 0.65, h * 0.55)
      ..close();
    canvas.drawPath(liveryPath, liveryPaint);

    // 5. 扩散器 - 调细一点，增加精致感
    final diffuserPaint = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..strokeWidth = 1.2
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < 4; i++) {
      double xPos = w * (0.78 + (i * 0.06));
      canvas.drawLine(Offset(xPos, h), Offset(xPos - 6, h - 15), diffuserPaint);
    }

    // 6. 后轮暗影 - 同样调浅
    final wheelPaint = Paint()
      ..shader = ui.Gradient.radial(Offset(w * 0.2, h * 0.85), 25, [
        Colors.black.withOpacity(0.4),
        Colors.transparent,
      ]);
    canvas.drawCircle(Offset(w * 0.2, h * 0.85), 25, wheelPaint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
