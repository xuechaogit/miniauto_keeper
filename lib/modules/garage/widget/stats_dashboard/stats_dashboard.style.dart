import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import '../../../../core/theme/app_theme.dart';

class StatsDashboardStyles {
  // 整个仪表盘外层大面板的容器样式（极其深沉的工业碳黑 + 硬质小圆角）
  static Style get containerBox => Style(
    $box.padding.all.ref(mxt.space.medium),
    $box.color.ref(mxt.color.surface),
    $box.borderRadius.all.ref(mxt.radius.medium),
    // $box.border.all.color.ref(mxt.color.outlineVariant),
    // $box.border.all.width(1),
  );

  // 内嵌 FlexBox 的样式：核心加入了 `$box.width.full()` 确保百分百占满父元素宽度
  static Style get flexBoxStyle =>
      Style($flex.mainAxisAlignment.spaceBetween());

  // 统计项 - 标签样式
  static Style get labelText => Style(
    $text.style.color.ref(mxt.color.onSurfaceVariant),
    $text.style.ref(mxt.textStyle.caption),
    $text.style.letterSpacing(1.2),
    $text.style.fontWeight.bold(),
  );

  // 统计项 - 普通数字样式
  static Style get valueText => Style(
    $text.style.color.ref(mxt.color.onSurface),
    $text.style.ref(mxt.textStyle.headline1),
    $text.style.fontWeight.bold(),
  );

  // 统计项 - 高亮红色数字样式
  static Style get redValueText => Style(
    $text.style.color.ref(mxt.color.primary),
    $text.style.ref(mxt.textStyle.headline1),
    $text.style.fontWeight.bold(),
  );
}
