import 'package:flutter/material.dart';
import 'package:mix/mix.dart';
import '../../theme/app_theme.dart';
import 'input.variant.dart';

class CustomInputStyle {
  const CustomInputStyle({this.shape = CustomInputShape.rounded});

  final CustomInputShape shape;

  Style get layout =>
      Style(
            CustomInputShape.square(
              $box.borderRadius.all.ref(mxt.radius.medium),
            ),
            CustomInputShape.rounded(
              $box.borderRadius.all.ref(mxt.radius.large),
            ),
            $box.clipBehavior.antiAlias(),
            $box.border.all(width: 1, color: Colors.transparent), // 默认边框
            // 响应式状态：当 TextField 获得焦点时
            $on.focus(
              $box.border.color.ref(mxt.color.primary),
              $box.color.ref(mxt.color.surface),
            ),

            // 默认背景
            $box.color.ref(mxt.color.surfaceVariant),
          )
          .animate(
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeInOut,
          )
          .applyVariants([shape]);

  static Style get iconStyle =>
      Style(
        $icon.size(22),
        $on.focus($icon.color.ref(mxt.color.primary)),
      ).animate(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeInOut,
      );
}
