import 'package:flutter/material.dart';
import 'package:miniauto_keeper/core/theme/app_theme.dart';
import 'package:mix/mix.dart';

class NewArrivalStyle {
  // 轮播图片
  static Style get carouselImage =>
      Style($box.borderRadius.all.ref(mxt.radius.medium));

  // 详情卡片容器
  static Style get detailCard =>
      Style($box.padding.horizontal.ref(mxt.space.small));

  // 左侧信息列
  static Style get infoColumn => Style(
    $flex.gap(4),
    $flex.crossAxisAlignment.start(),
  );

  // 品牌名
  static Style get brandText => Style(
    $text.color.ref(mxt.color.onSurface),
    $text.style.ref(mxt.textStyle.headline3),
  );

  // 商品标题
  static Style get titleText => Style(
    $text.color.ref(mxt.color.onSurfaceVariant),
    $text.style.ref(mxt.textStyle.body),
    $text.maxLines(2),
    $text.overflow.ellipsis(),
  );

  // 发售时间
  static Style get deliveryTimeText => Style(
    $text.color.ref(mxt.color.onSurfaceVariant),
    $text.style.ref(mxt.textStyle.caption),
  );

  // 提醒按钮
  static Style get reminderButton => Style(
    $box.border.all(width: 1, color: const Color(0xFF333333)),
    $box.borderRadius.all.circular(20),
    $box.padding.vertical(8),
    $box.padding.horizontal(16),
  );

  // 提醒按钮文字
  static Style get reminderText => Style(
    $text.color.ref(mxt.color.onSurface),
    $text.style.ref(mxt.textStyle.caption),
    $text.fontWeight.w600(),
  );

  // 指示器圆点 - 激活
  static Style dotActive(Color activeColor) => Style(
    $box.width(6),
    $box.height(6),
    $box.borderRadius.all.circular(3),
    $box.color(activeColor),
  );

  // 指示器圆点 - 未激活
  static Style dotInactive(Color inactiveColor) => Style(
    $box.width(6),
    $box.height(6),
    $box.borderRadius.all.circular(3),
    $box.color(inactiveColor),
  );
}
