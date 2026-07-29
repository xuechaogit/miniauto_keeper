import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import 'divider.style.dart';

/// Mix 实现的分割线组件。
class AppDivider extends StatelessWidget {
  const AppDivider({super.key, this.style});

  final Style? style;

  @override
  Widget build(BuildContext context) {
    return Box(style: AppDividerStyle.base.merge(style));
  }
}
