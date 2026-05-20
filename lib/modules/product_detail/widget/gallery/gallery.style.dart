import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

class GalleryStyle {
  // 画廊外层 ZBox 底座基础样式
  static Style get wrapper =>
      Style($box.color(const Color(0xFF161616)), $box.width(double.infinity));

  // 单张轮播图容器样式
  static Style get imageContainer => Style($box.width(double.infinity));

  // LED 刻度核心色值与形状配置
  static BoxDecoration ledIndicator({required bool isSelected}) {
    return BoxDecoration(
      // 激活时赛车红高亮，未激活时采用半透明浅白以适应各类背景车模图
      color: isSelected
          ? const Color(0xFFE54335)
          : const Color(0xFFFFFFFF).withOpacity(0.3),
      borderRadius: BorderRadius.circular(1), // 硬直角赛车感
    );
  }
}
