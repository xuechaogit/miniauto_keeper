import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mix/mix.dart';
import 'package:miniauto_keeper/core/theme/app_theme.dart';
import 'package:miniauto_keeper/core/utils/screen_adapter.dart';

class NotePaperStyle {
  static const $ = Style;

  static Style get card => Style(
    $box.padding.all(w(12)),
    $box.padding.bottom(w(50)),
    $box.color.ref(mxt.color.surface),
  );

  static Style get holeRow => Style($flex.mainAxisAlignment.spaceBetween());

  static double curlWidth = w(65.0); // 底边裁切宽度（水平方向）
  static double curlHeight = w(20.0); // 右边裁切高度（垂直方向）
  static final double radius = r(12); // 卡片圆角半径
}

/// 卡片裁剪器：切除右下角折角区域
class CurlClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final w = size.width;
    final h = size.height;
    final cw = NotePaperStyle.curlWidth;
    final ch = NotePaperStyle.curlHeight;
    final r = NotePaperStyle.radius;

    final path = Path();
    path.moveTo(r, 0);
    path.lineTo(w - r, 0);
    path.arcToPoint(Offset(w, r), radius: Radius.circular(r));
    path.lineTo(w, h - ch);
    path.lineTo(w - cw, h);
    path.lineTo(r, h);
    path.arcToPoint(Offset(0, h - r), radius: Radius.circular(r));
    path.lineTo(0, r);
    path.arcToPoint(Offset(r, 0), radius: Radius.circular(r));
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

/// 折叠三角面 Painter：以 CustomPaint 自身尺寸为画布，在右下角绘制翻折三角
class CurlPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    if (w <= 0 || h <= 0 || !w.isFinite || !h.isFinite) return;

    final cw = NotePaperStyle.curlWidth;
    final ch = NotePaperStyle.curlHeight;

    // 折痕端点
    final creaseStart = Offset(w, h - ch);
    final creaseEnd = Offset(w - cw, h);
    final corner = Offset(w, h);
    final foldCorner = _reflect(corner, creaseStart, creaseEnd);

    // 折面三角形
    final path = Path()
      ..moveTo(creaseStart.dx, creaseStart.dy)
      ..lineTo(creaseEnd.dx, creaseEnd.dy)
      ..lineTo(foldCorner.dx, foldCorner.dy)
      ..close();

    // 折角阴影：翻折三角面向右下的投影
    final shadowPath = Path()
      ..moveTo(creaseStart.dx + 2, creaseStart.dy + 1)
      ..lineTo(creaseEnd.dx + 2, creaseEnd.dy + 1)
      ..lineTo(foldCorner.dx + 4, foldCorner.dy + 4)
      ..close();
    canvas.drawShadow(shadowPath, Colors.grey.withValues(alpha: 0.2), 4, false);

    // 折面纯色
    final fillPaint = Paint()..color = const Color(0xFFE6E6E6);
    canvas.drawPath(path, fillPaint);
  }

  /// 点 p 关于线段 ab 的反射点
  Offset _reflect(Offset p, Offset a, Offset b) {
    final dx = b.dx - a.dx;
    final dy = b.dy - a.dy;
    final lenSq = dx * dx + dy * dy;
    if (lenSq == 0) return p;

    final t = ((p.dx - a.dx) * dx + (p.dy - a.dy) * dy) / lenSq;
    final proj = Offset(a.dx + t * dx, a.dy + t * dy);
    return Offset(2 * proj.dx - p.dx, 2 * proj.dy - p.dy);
  }

  @override
  bool shouldRepaint(covariant CurlPainter oldDelegate) => false;
}
