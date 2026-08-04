import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:miniauto_keeper/core/utils/screen_adapter.dart';
import 'package:mix/mix.dart';
import 'note_paper.style.dart';

class NotePaper extends StatelessWidget {
  final Widget child;
  const NotePaper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // 阴影层：底部模糊投影
        Positioned(
          left: 0,
          top: 4,
          right: 0,
          bottom: -h(4),
          child: IgnorePointer(
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
              child: ClipPath(
                clipper: CurlClipper(),
                child: Container(color: Colors.grey.withValues(alpha: 0.08)),
              ),
            ),
          ),
        ),
        // 卡片本体（右下角已被裁剪切除）
        ClipPath(
          clipper: CurlClipper(),
          child: Box(
            style: NotePaperStyle.card,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHoleDots(),
                SizedBox(height: w(12)),
                child,
              ],
            ),
          ),
        ),
        // 折叠三角面：铺满整卡，由 painter 内部取实际 size 绘制
        Positioned.fill(
          child: IgnorePointer(child: CustomPaint(painter: CurlPainter())),
        ),
      ],
    );
  }

  Widget _buildHoleDots() {
    return HBox(
      style: NotePaperStyle.holeRow,
      children: List.generate(18, (_) => _buildSingleHole()),
    );
  }

  Widget _buildSingleHole() {
    return Container(
      width: w(12),
      height: w(12),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0x1A000000), Color(0x05000000), Color(0x33FFFFFF)],
          stops: [0.0, 0.5, 1.0],
        ),
        border: Border.fromBorderSide(
          BorderSide(color: Color(0x0F000000), width: 0.5),
        ),
      ),
    );
  }
}
