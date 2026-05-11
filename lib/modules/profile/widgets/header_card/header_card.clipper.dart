import 'package:flutter/material.dart';

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
