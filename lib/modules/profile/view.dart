// lib/modules/profile/view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mix/mix.dart';

import '../../core/router/app_routes.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/tag/tag.dart';
import '../../core/widgets/tag/tag.variant.dart';
import 'controller.dart';
import 'widgets/header_card/header_card.dart';

import 'package:miniauto_keeper/core/utils/screen_adapter.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('PROFILE'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(child: ProfileHeaderCard(name: 'John Doe')),
          // ProfileHeaderCard(),
          _buildLargeEntries(context),
          SliverToBoxAdapter(child: SizedBox(height: h(16))),
          SliverToBoxAdapter(child: _buildTodayIndicator()),
          SliverToBoxAdapter(child: SizedBox(height: h(16))),
          _buildActionMenu(context),
        ],
      ),
    );
  }

  // --- 功能列表 ---
  Widget _buildActionMenu(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.fromLTRB(w(16), h(0), w(16), h(16)), // 顶部收紧，侧边留白
      sliver: SliverToBoxAdapter(
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF111111), // 稍深于背景，增加悬浮感
            borderRadius: BorderRadius.circular(r(20)),
            // 极细的顶部高光，模拟金属边缘
            border: Border.all(
              color: Colors.white.withOpacity(0.05),
              width: 0.5,
            ),
          ),
          child: Column(
            children: controller.menuItems.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isLast = index == controller.menuItems.length - 1;

              return Column(
                children: [
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        final id = item['id'] as String;
                        if (id == 'wishlist') {
                          Get.toNamed(AppRoutes.wishlist);
                        }
                      },
                      borderRadius: _getBorderRadius(
                        index,
                        controller.menuItems.length,
                      ),
                      highlightColor: Colors.white.withOpacity(0.02),
                      splashColor: mxt.color.primary
                          .resolve(context)
                          .withOpacity(0.1),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: w(16),
                          vertical: 14,
                        ),
                        child: Row(
                          children: [
                            // 1. 优化后的 Icon 容器：类似扫描模组
                            Container(
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                color: const Color(0xFF1A1A1A),
                                borderRadius: BorderRadius.circular(r(12)),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.08),
                                ),
                              ),
                              child: Icon(
                                item['icon'] as IconData,
                                color: Colors.white.withOpacity(0.8),
                                size: 22,
                              ),
                            ),
                            SizedBox(width: w(16)),
                            // 2. 标题部分
                            Expanded(
                              child: Text(
                                (item['title'] as String)
                                    .toUpperCase(), // 全大写更具赛车味
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: sp(14),
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: w(1.1),
                                ),
                              ),
                            ),
                            // 3. 右侧箭头：改用更轻盈的图标
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: Colors.white.withOpacity(0.15),
                              size: 14,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // 4. 优化后的分割线：不再横跨全屏
                  if (!isLast)
                    Padding(
                      padding: EdgeInsets.only(left: w(74), right: w(20)),
                      child: Divider(
                        height: 1,
                        thickness: 0.5,
                        color: Colors.white.withOpacity(0.05),
                      ),
                    ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  // 根据索引获取圆角，确保 InkWell 点击效果不超出 Container
  BorderRadius _getBorderRadius(int index, int total) {
    if (index == 0)
      return BorderRadius.vertical(top: Radius.circular(r(20)));
    if (index == total - 1)
      return BorderRadius.vertical(bottom: Radius.circular(r(20)));
    return BorderRadius.zero;
  }

  Widget _buildGTHeaderCard(BuildContext context) {
    final primaryColor = mxt.color.primary.resolve(context);
    const double cardHeight = 180.0;
    const double borderWidth = 1.5; // 红色边框的粗细

    return Padding(
      padding: EdgeInsets.all(r(16)),
      child: SizedBox(
        height: cardHeight,
        child: Stack(
          children: [
            // 1. 底层：红色边框层（利用 Clipper 裁切出外轮廓）
            ClipPath(clipper: GTAeroClipper(), child: Container()),

            // 2. 内容层：稍微缩进，盖在红色层上，形成边框效果
            Padding(
              padding: const EdgeInsets.all(borderWidth),
              child: ClipPath(
                clipper: GTAeroClipper(),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFF0A0A0A), // 硬核赛车黑
                    // 这里可以加一点淡淡的碳纤维斜纹背景贴图
                  ),
                  child: Stack(
                    children: [
                      // --- 顶部装饰条 ---
                      Positioned(
                        top: 20,
                        right: 30,
                        child: Container(
                          width: 80,
                          height: 2,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.transparent,
                                primaryColor.withOpacity(0.6),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // --- 核心内容 ---
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: w(20)),
                        child: Row(
                          children: [
                            _buildCockpitAvatar(context),
                            SizedBox(width: w(18)),
                            Expanded(
                              child: _buildDriverCluster(context, primaryColor),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCockpitAvatar(BuildContext context) {
    final primaryColor = mxt.color.primary.resolve(context);

    return Container(
      width: 78,
      height: 78,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: primaryColor.withOpacity(0.6), width: 1.2),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 外圈仪表环
          SizedBox(width: w(78),
            height: 78,
            child: CircularProgressIndicator(
              value: 0.72,
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation(primaryColor.withOpacity(0.7)),
              backgroundColor: Colors.white.withOpacity(0.05),
            ),
          ),

          // 内部头像
          Container(
            width: 58,
            height: 58,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF151515),
            ),
            child: ClipOval(
              child: Image.network(
                'https://api.dicebear.com/7.x/bottts/png?seed=Collector',
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDriverCluster(BuildContext context, Color primaryColor) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // DRIVER NAME = 仪表主标题
        Obx(
          () => Text(
            controller.userName.value.toUpperCase(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white,
              fontSize: sp(24),
              fontWeight: FontWeight.w800,
              letterSpacing: w(2),
            ),
          ),
        ),

        SizedBox(height: h(10)),

        // SUB SYSTEM STATUS（像车的 mode）
        Text(
          'GT3 • TRACK MODE ACTIVE',
          style: TextStyle(
            color: Colors.white.withOpacity(0.55),
            fontSize: sp(11),
            letterSpacing: w(2.5),
            fontWeight: FontWeight.w600,
          ),
        ),

        SizedBox(height: h(14)),
      ],
    );
  }

  Widget _buildLargeEntries(BuildContext context) {
    final primaryColor = mxt.color.primary.resolve(context);

    return SliverPadding(
      padding: EdgeInsets.fromLTRB(w(16), h(8), w(16), h(16)),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1, // 稍微纵向拉长，更有“控制面板”的感觉
        ),
        delegate: SliverChildListDelegate([
          // 左侧：切右上角 (isReverse: false)
          _buildConsoleEntry(
            context,
            icon: Icons.garage_outlined,
            label: 'Garage',
            subtitle: '3 UNITS TOTAL',
            color: primaryColor,
            isReverse: false,
          ),
          // 右侧：切左上角 (isReverse: true)
          _buildConsoleEntry(
            context,
            icon: Icons.stars_outlined,
            label: 'Wishlist',
            subtitle: 'MY FAVORITES',
            color: primaryColor,
            isReverse: true,
            onTap: () => Get.toNamed(AppRoutes.wishlist),
          ),
        ]),
      ),
    );
  }

  // --- 通用的控制面板入口组件 ---
  Widget _buildConsoleEntry(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String subtitle,
    required Color color,
    required bool isReverse, // 控制裁剪方向和排版对齐
    VoidCallback? onTap,
  }) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // 1. 底层：发光/边框层
        ClipPath(clipper: GTSmallCardClipper(isReverse: isReverse)),

        // 2. 内容层：通过 Padding 露边
        Padding(
          padding: EdgeInsets.all(r(1.2)),
          child: ClipPath(
            clipper: GTSmallCardClipper(isReverse: isReverse),
            child: Material(
              color: const Color(0xFF0F0F0F), // 硬核深空黑
              child: InkWell(
                onTap: onTap,
                splashColor: color.withOpacity(0.12),
                highlightColor: Colors.white.withOpacity(0.02),
                child: Container(
                  padding: EdgeInsets.all(r(16)),
                  child: Column(
                    // 根据裁剪方向自动切换文字对齐：切左边则靠右对齐，切右边则靠左对齐
                    crossAxisAlignment: isReverse
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      // 图标容器
                      Container(
                        padding: EdgeInsets.all(r(8)),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(r(10)),
                        ),
                        child: Icon(icon, color: color, size: r(22)),
                      ),
                      const Spacer(),
                      // 标题
                      Text(
                        label.toUpperCase(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: sp(15),
                          fontWeight: FontWeight.w900,
                          letterSpacing: w(1.5),
                        ),
                      ),
                      SizedBox(height: h(6)),
                      // 动态装饰线
                      Container(
                        width: 28,
                        height: 2,
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(r(1)),
                        ),
                      ),
                      SizedBox(height: h(8)),
                      // 副标题
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.35),
                          fontSize: sp(10),
                          fontFamily: 'monospace',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

Widget _buildTodayIndicator() {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: w(16)),
    child: Row(
      children: [
        // 中间文字部分
        StyledText(
          'SYSTEM TUNINF',
          style: Style(
            $text.fontSize(14),
            $text.color.ref(mxt.color.primary),
            $text.fontWeight.bold(),
            $text.letterSpacing(1.2),
          ),
        ),
        SizedBox(width: w(12)),
        // 右侧长线撑满
        Expanded(child: Container(height: 1, color: Colors.white10)),
      ],
    ),
  );
}
// =============================================================
// GT CARD CLIPPER
// =============================================================

class GTAeroClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    final double w = size.width;
    final double h = size.height;

    // 设定比例参数，方便微调
    const double r = 25.0; // 主圆角
    const double notchDepth = 12.0; // 顶部凹槽深度
    const double sideCutWidth = 35.0; // 右侧切口宽度

    // 1. 从左上角圆角开始
    path.moveTo(r, 0);

    // 2. 顶部边缘 + 中间不对称凹槽
    path.lineTo(w * 0.45, 0);
    path.lineTo(w * 0.48, notchDepth); // 凹槽左斜边
    path.lineTo(w * 0.60, notchDepth); // 凹槽底部
    path.lineTo(w * 0.63, 0); // 凹槽右斜边
    path.lineTo(w - r * 1.5, 0); // 延伸至右上角

    // 3. 右上角圆角
    path.quadraticBezierTo(w, 0, w, r);

    // 4. 右侧阶梯式切口 (图片中最具辨识度的部分)
    path.lineTo(w, h * 0.25);
    path.lineTo(w - 12, h * 0.35); // 向内切
    path.lineTo(w - 12, h * 0.65); // 垂直向下
    path.lineTo(w, h * 0.75); // 向外拔
    path.lineTo(w, h - r);

    // 5. 右下角圆角
    path.quadraticBezierTo(w, h, w - r, h);

    // 6. 底部边缘 (带一点点向上收缩的弧度)
    path.quadraticBezierTo(w * 0.5, h - 20, r, h);

    // 7. 左下角圆角
    path.quadraticBezierTo(0, h, 0, h - r);

    // 8. 左侧垂直上升回到起点
    path.lineTo(0, r);
    path.quadraticBezierTo(0, 0, r, 0);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

class GTSmallCardClipper extends CustomClipper<Path> {
  final bool isReverse;

  GTSmallCardClipper({this.isReverse = false});

  @override
  Path getClip(Size size) {
    var path = Path();
    final double w = size.width;
    final double h = size.height;

    // --- 核心参数 ---
    const double notchDepth = 15.0; // 缺口深度
    const double cutWidth = 45.0; // 斜切宽度
    const double cutHeight = 55.0; // 斜切高度
    const double r = 20.0; // 主圆角
    const double sR = 6.0; // 每一个微小转折处的圆角 (消除尖锐感的关键)
    const double liftH = 35.0; // 底部翘起高度

    if (!isReverse) {
      // --- 左侧卡片 (左低右高) ---
      path.moveTo(r, 0);

      // 2. 右上斜切 (带圆角过渡)
      path.lineTo(w - cutWidth - sR, 0);
      path.quadraticBezierTo(
        w - cutWidth,
        0,
        w - cutWidth + sR / 2,
        sR / 2,
      ); // 斜切起点圆角
      path.lineTo(w - sR / 2, cutHeight - sR / 2);
      path.quadraticBezierTo(w, cutHeight, w, cutHeight + sR); // 斜切终点圆角

      // 3. 右侧下行 & 底部流线
      path.lineTo(w, h - liftH - sR);
      // 使用 CubicTo 绘制圆润饱满的底
      path.cubicTo(w, h - liftH + 10, w * 0.4, h + 12, r, h);

      // 4. 左下主圆角
      path.quadraticBezierTo(0, h, 0, h - r);
      path.lineTo(0, r);
      path.quadraticBezierTo(0, 0, r, 0);
    } else {
      // --- 右侧卡片 (左高右低) ---
      path.moveTo(cutWidth + sR, 0);

      // 2. 右上主圆角
      path.lineTo(w - r, 0);
      path.quadraticBezierTo(w, 0, w, r);

      // 3. 右侧下行至最低点
      path.lineTo(w, h - r);
      path.quadraticBezierTo(w, h, w - r, h);

      // 4. 底部流线 (连向左侧高点)
      path.cubicTo(w * 0.6, h + 12, 0, h - liftH + 10, 0, h - liftH - sR);

      // 5. 左侧斜切闭合 (带圆角)
      path.lineTo(0, cutHeight + sR);
      path.quadraticBezierTo(0, cutHeight, sR / 2, cutHeight - sR / 2);
      path.lineTo(cutWidth - sR / 2, sR / 2);
      path.quadraticBezierTo(cutWidth, 0, cutWidth + sR, 0);
    }

    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}
