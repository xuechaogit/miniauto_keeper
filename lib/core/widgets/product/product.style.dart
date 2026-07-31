import 'package:flutter/material.dart';
import 'package:miniauto_keeper/core/utils/screen_adapter.dart';
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
    ProductMode.listMode($box.width(double.infinity), $box.padding(8)),

    // 网格模式下的容器特定属性
    ProductMode.gridMode($box.padding(8)),
  );

  // 2. 图片样式
  static Style get image => Style(
    $box.color(Color(0xFFF5F5F5)),
    $box.borderRadius(8),

    ProductMode.listMode($box.width(w(100)), $box.height(w(100))),

    ProductMode.gridMode($box.width(double.infinity)),
  );

  // 3. 标题文字样式
  static Style get title => Style(
    $text.style.ref(mxt.textStyle.body),
    $text.style.color.ref(mxt.color.onSurface),
    $text.maxLines(2),
    $text.overflow.ellipsis(),
  );

  // 4. 价格文字样式
  static Style get price => Style(
    $text.style.color(Colors.deepOrange),
    $text.style.ref(mxt.textStyle.body),
  );

  // 5. 列表模式子元素间距
  static Style get listGap =>
      Style($flex.gap(12), $flex.crossAxisAlignment.start());

  // 6. 网格模式子元素间距
  static Style get gridGap => Style($flex.gap(8));

  // 7. 品牌名文字
  static Style get brandName => Style(
    $text.style.ref(mxt.textStyle.body),
    $text.style.color(Colors.blueAccent),
  );

  // 8. grid 模式 action bar（收藏 + 加入车库 行）
  static Style get gridActionBar => Style(
    $flex.gap(w(6)),
    $flex.crossAxisAlignment.center(),
    $flex.mainAxisAlignment.spaceBetween(),
  );

  // 9. grid 模式收藏按钮（icon + 文字 紧凑）
  static Style get gridFavBtn => Style(
    $flex.gap(2),
    $flex.crossAxisAlignment.center(),
    $flex.mainAxisAlignment.center(),
  );

  // 10. grid 模式收藏按钮文字
  static Style get gridFavBtnText => Style(
    $text.color.ref(mxt.color.onSurfaceVariant),
    $text.style.ref(mxt.textStyle.caption),
  );

  // 11. grid 模式加入车库按钮
  static const _gridAccent = Color(0xFFE54335);

  static Style get gridAddGarageBtn => Style(
    $box.color(_gridAccent),
    $box.padding.horizontal(8),
    $box.padding.vertical(4),
    $box.borderRadius.all(4),

    $flex.mainAxisAlignment.center(),
    $flex.crossAxisAlignment.center(),
  );

  // 12. grid 模式加入车库按钮文字
  static Style get gridAddGarageBtnText => Style(
    $text.color(const Color(0xFFFFFFFF)),
    $text.style.ref(mxt.textStyle.caption),
  );
}
