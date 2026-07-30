import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import 'divider.style.dart';

enum AppDividerDirection { horizontal, vertical }

/// 通用分割线组件，支持水平和垂直方向。
class AppDivider extends StatelessWidget {
  const AppDivider({
    super.key,
    this.direction = AppDividerDirection.horizontal,
    this.style,
  });

  final AppDividerDirection direction;
  final Style? style;

  @override
  Widget build(BuildContext context) {
    final baseStyle = direction == AppDividerDirection.horizontal
        ? AppDividerStyle.horizontal
        : AppDividerStyle.vertical;
    return Box(style: baseStyle.merge(style));
  }
}
