import 'package:flutter/material.dart';
import 'package:mix/mix.dart';
import '../../theme/app_theme.dart';
import '../../theme/app_theme_tool.dart';
import 'filter_chips.variant.dart'; // 假设你的 mxt 引用

class FilterChipStyles {
  /// 容器样式
  static Style get container =>
      Style($box.padding.vertical.ref(mxt.space.medium));

  /// 基础 Chip 样式
  static Style chipStyle(bool isSelected, BuildContext context) {
    return Style(
      $box.alignment.center(),
      $box.padding.horizontal.ref(mxt.space.small),
      $box.borderRadius(6),

      // --- Outlined 模式样式 ---
      FilterChipType.outlined(
        $box.border.all(
          color: isSelected
              ? context.color(mxt.color.primary)
              : context.color(mxt.color.outlineVariant),
          width: 1,
        ),
        isSelected
            ? $box.color(context.color(mxt.color.primary))
            : $box.color(
                context.color(mxt.color.surfaceVariant).withOpacity(0.5),
              ),
        isSelected
            ? $box.shadow(
                color: context.color(mxt.color.primary).withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              )
            : const Style.empty(),
      ),

      // --- Underlined (Link) 模式样式 ---
      FilterChipType.underlined(
        $box.color.transparent(), // 背景透明
        $box.border.none(),
      ),
    ).animate(duration: const Duration(milliseconds: 200));
  }

  /// 文字样式
  static Style textStyle(bool isSelected, BuildContext context) {
    final primaryColor = context.color(mxt.color.primary);
    final onSurface = context.color(mxt.color.onSurfaceVariant);

    return Style(
      $text.style.ref(mxt.textStyle.caption),
      $text.style.letterSpacing(1.1),

      // 默认颜色（未选中）
      $text.style.color(onSurface),
      $text.style.fontWeight.normal(),

      // 根据 isSelected 手动应用样式分支
      isSelected
          ? Style(
              $text.style.fontWeight.bold(),

              // 模式差异化：Outlined 选中文字白，Underlined 选中文字主色
              FilterChipType.outlined($text.style.color(Colors.white)),
              FilterChipType.underlined($text.style.color(primaryColor)),
            )
          : const Style.empty(),
    );
  }
}
