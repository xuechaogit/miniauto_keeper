import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/l10n/l10n_util.dart'; // 导入我们之前的扩展
import '../../core/services/settings_service.dart';

import '../../core/theme/app_theme.dart';
import '../../core/theme/app_theme_tool.dart';
import '../../models/brand_stats.dart';
import 'controller.dart';
// 导入MIX
import 'package:mix/mix.dart';
import '../../core/theme/app_mix_themes.dart';

class BrandView extends GetView<BrandsController> {
  const BrandView({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = Get.find<SettingsService>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: StyledText('PRECISION HUB', style: AppMixStyles.titleStyle),
        actions: [IconButton(icon: const Icon(Icons.search), onPressed: () {})],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 120), // 为底部卡片留出空间
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 搜索框
                TextField(
                  // 1. 同步文字样式
                  style: context.textStyle(mxt.textStyle.body),

                  decoration: InputDecoration(
                    // A. 默认状态的边框（未选中时）
                    hintText: 'Search Your collection...',
                    // 2. 使用 Token 颜色
                    hintStyle: TextStyle(
                      color: context.color(mxt.color.onSurfaceVariant),
                    ),
                    // 💡 关键：必须设为 true
                    filled: true,
                    // 使用 context 扩展引用 Token
                    fillColor: context.color(mxt.color.surfaceVariant),
                    // 3. 使用 Token 圆角
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        context.radius(mxt.radius.large),
                      ),
                      borderSide: BorderSide.none,
                    ),
                    // 4. 使用 Token 间距
                    contentPadding: EdgeInsets.all(
                      context.space(mxt.space.medium),
                    ),

                    prefixIcon: Icon(
                      Icons.search,
                      color: context.color(mxt.color.primary),
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // 标题行
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    StyledText('Brands', style: AppMixStyles.titleStyle),
                    Box(
                      style: AppMixStyles.primaryTag,
                      child: const StyledText('PREMIUM GRER'),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // 3. 使用 Obx 响应数据变化 (品牌列表)
                Obx(
                  () => ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.brands.length,
                    separatorBuilder: (c, i) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final brand = controller.brands[index];
                      return _buildBrandCard(context, brand);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 品牌卡片组件
  Widget _buildBrandCard(BuildContext context, BrandModel brand) {
    final brandColor = brand.themeColor ?? Colors.red;
    final String brandName = (brand.name ?? 'UNKNOWN').toUpperCase();

    return Pressable(
      onPress: () => Get.toNamed('/brand-details', arguments: brand),
      child: Box(
        style: Style(
          $box.height(180),
          $box.margin.bottom(16),
          $box.borderRadius(20),
          $box.clipBehavior.antiAlias(),
          $box.color.ref(mxt.color.brandCardBg),
          // 增加一点边框，提升精致感
          $box.border.all(color: Colors.white.withOpacity(0.05), width: 1),
        ),
        child: Stack(
          children: [
            // 1. 装饰背景：赛车方格旗 - 使用 Opacity 组件解决参数报错
            Positioned(
              right: -10,
              top: 0,
              bottom: 0,
              child: Opacity(
                opacity: 0.05,
                // 💡 使用 ShaderMask 来控制图片的可见区域
                child: ShaderMask(
                  shaderCallback: (rect) {
                    return const LinearGradient(
                      begin: Alignment.centerLeft, // 从左侧开始
                      end: Alignment.centerRight, // 到右侧结束
                      colors: [
                        Colors.transparent, // 左侧完全透明
                        Colors.black, // 右侧完全不透明（显示图片）
                      ],
                      stops: [0.0, 0.4], // 0% 到 40% 的位置完成淡入，你可以根据生硬程度微调 0.4
                    ).createShader(rect);
                  },
                  blendMode: BlendMode.dstIn, // 关键：只保留遮罩范围内的内容
                  child: Box(
                    style: Style(
                      $box.width(220), // 稍微宽一点，让淡入过程更自然
                      $box.height.infinity(),
                      $box.decoration.image(
                        image: const AssetImage(
                          'assets/images/checker_flag.webp',
                        ),
                        fit: BoxFit.cover, // 建议使用 cover 避免拉伸变形
                        alignment: Alignment.centerRight,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // A. 赛车底色层
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              width: 320, // 增加宽度以包含更多车身细节
              child: Opacity(
                opacity: 0.7, // 保持卡片整体质感
                child: CustomPaint(
                  painter: GTCartPainter(
                    brandColor: brandColor,
                  ), // 具象赛车 Painter
                ),
              ),
            ),

            // 2. 品牌 Logo 文字 (放在右侧，作为视觉中心)
            Positioned(
              right: 25,
              top: 0,
              bottom: 0,
              child: Center(
                child: StyledText(
                  brandName,
                  style: Style(
                    $text.style.fontSize(32),
                    $text.style.fontWeight.w900(),
                    $text.style.color(Colors.white.withOpacity(0.9)),
                    $text.style.letterSpacing(-1.5),
                    // 给文字加一点点阴影，模仿 Logo 质感
                    $text.style.shadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: const Offset(2, 2),
                    ),
                  ),
                ),
              ),
            ),
            // 3. 左侧信息展示区
            Box(
              style: Style($box.padding.all(24)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 数字展示
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      StyledText(
                        '${brand.totalCount}',
                        style: Style(
                          $text.style.fontSize(48),
                          $text.style.fontWeight.w700(),
                          $text.style.color(Colors.white),
                          $text.style.height(1),
                        ),
                      ),
                      const SizedBox(width: 8),
                      StyledText(
                        'Total Inclusion',
                        style: Style(
                          $text.style.fontSize(12),
                          $text.style.color(Colors.white70),
                        ),
                      ),
                    ],
                  ),

                  const Spacer(),

                  // 底部标签
                  Row(
                    children: [
                      _buildMiniTag('1:64'),
                      const SizedBox(width: 8),
                      _buildMiniTag(brandName),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // 底部车辆描述信息
                  StyledText(
                    'Latest: Detailed description of the limited edition car model of XXX...',

                    style: Style(
                      $text.style.fontSize(11),
                      $text.style.color(Colors.white30),
                      $text.overflow.ellipsis(),
                      $text.maxLines(1),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 辅助标签组件
  Widget _buildMiniTag(String text) {
    return Box(
      style: Style(
        $box.padding.horizontal(8),
        $box.padding.vertical(4),
        $box.borderRadius(4),
        $box.color(Colors.black.withOpacity(0.4)),
      ),
      child: StyledText(
        text,
        style: Style(
          $text.style.fontSize(10),
          $text.style.color(Colors.white70),
          $text.style.fontWeight.bold(),
        ),
      ),
    );
  }
}

// 纯代码绘制 GT 赛车后端
class GTCartPainter extends CustomPainter {
  final Color brandColor;

  GTCartPainter({required this.brandColor});

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
