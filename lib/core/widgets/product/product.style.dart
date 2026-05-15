import 'package:flutter/material.dart';
import 'package:mix/mix.dart';
import '../../theme/app_theme.dart';
import 'product.variant.dart';

class ProductStyle {
  // 1. 卡片外层容器样式
  static Style get container => Style(
    $box.color.ref(mxt.color.surface),
    $box.borderRadius.all(8),
    $box.clipBehavior.antiAlias(),

    // 列表模式下的容器特定属性
    ProductMode.listMode($box.width(double.infinity), $box.padding(12)),

    // 网格模式下的容器特定属性
    ProductMode.gridMode($box.padding(8)),
  );

  // 2. 图片样式
  static Style get image => Style(
    $box.color(Color(0xFFF5F5F5)),
    $box.borderRadius(8),

    ProductMode.listMode($box.width(100), $box.height(100)),

    ProductMode.gridMode($box.width(double.infinity)),
  );

  // 3. 标题文字样式
  static Style get title => Style(
    $text.style.fontWeight.bold(),
    $text.style.fontSize(16),
    $text.style.color.ref(mxt.color.onSurface),
    $text.maxLines(2),
    $text.overflow.ellipsis(),

    // ProductMode.listMode($text.style.fontSize(16)),

    // ProductMode.gridMode($text.style.fontSize(14)),
  );

  // 4. 价格文字样式
  static Style get price => Style(
    $text.style.color(Colors.deepOrange),
    $text.style.fontWeight.w600(),
    $text.style.fontSize(14),
  );
}
