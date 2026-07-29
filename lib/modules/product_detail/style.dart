import 'dart:ui';

import 'package:mix/mix.dart';

import '../../../core/theme/app_theme.dart';

class ProductDetailStyle {
  static const accent = Color(0xFFE54335);

  // 工业仪表盘感内容区块容器
  static Style get industrialCard => Style(
    $box.color.ref(mxt.color.surface),
    $box.borderRadius.all.ref(mxt.radius.small),
    $box.padding.all.ref(mxt.space.small),
  );

  // 核心高亮标签 (现货/预售)
  static Style get statusTag => Style(
    $box.color(accent),
    $box.borderRadius(2),
    $box.padding.horizontal(8),
    $box.padding.vertical(3),
  );

  // 灰色参数面板单元
  static Style get specGridItem => Style(
    $box.color.ref(mxt.color.surfaceVariant),
    $box.padding.all.ref(mxt.space.small),
    $box.borderRadius.all.ref(mxt.radius.small),
  );

  // 底部操作按钮
  static Style get primaryActionBtn => Style(
    $box.color(accent),
    $box.height(50),
    $box.alignment.center(),
    $box.borderRadius.all.ref(mxt.radius.small),
  );

  // 底栏图标+文字按钮
  static Style get bottomIconBtn => Style(
    $flex.gap(4),
    $flex.crossAxisAlignment.center(),
    $flex.mainAxisAlignment.center(),
  );

  // 图标按钮文字
  static Style get bottomIconBtnText => Style(
    $text.color.ref(mxt.color.onSurfaceVariant),
    $text.style.ref(mxt.textStyle.caption),
  );

  // 标签 Chip
  static Style get tagChip => Style(
    $box.color.ref(mxt.color.surfaceVariant),
    $box.borderRadius(2),
    $box.border.color.ref(mxt.color.outline),
    $box.border.width(1),
    $box.padding.horizontal.ref(mxt.space.small),
    $box.padding.vertical(2),
  );

  // 分割线
  static Style get divider => Style(
    $box.height(1),
    $box.color.ref(mxt.color.outlineVariant),
    $box.width(double.infinity),
    $box.margin.vertical.ref(mxt.space.medium),
  );

  // ── 文本样式 ──

  // 价格大字 (红色)
  static Style get priceLarge => Style(
    $text.color(accent),
    $text.style.ref(mxt.textStyle.headline1),
    $text.fontWeight.w700(),
  );

  // 价格小字 (红色)
  static Style get priceSmall => Style(
    $text.color(accent),
    $text.style.ref(mxt.textStyle.headline3),
    $text.fontWeight.w700(),
  );

  // 原价划线
  static Style get originalPrice => Style(
    $text.color.ref(mxt.color.onSurfaceVariant),
    $text.style.ref(mxt.textStyle.caption),
    $text.decoration(TextDecoration.lineThrough),
  );

  // 系列名称
  static Style get seriesName => Style(
    $text.color.ref(mxt.color.onSurface),
    $text.style.ref(mxt.textStyle.body),
    $text.fontWeight.w700(),
    $text.letterSpacing(1),
  );

  // 商品全称
  static Style get productTitle => Style(
    $text.color.ref(mxt.color.onSurface),
    $text.style.ref(mxt.textStyle.headline3),
    $text.textAlign.start(),
    $text.fontWeight.w700(),
  );

  // 编号/库存等 mono 字
  static Style get monoLabel => Style(
    $text.color.ref(mxt.color.onSurfaceVariant),
    $text.style.ref(mxt.textStyle.caption),
  );

  static Style get monoValue => Style(
    $text.color.ref(mxt.color.onSurface),
    $text.style.ref(mxt.textStyle.caption),
  );

  // 区块标题
  static Style get sectionTitle => Style(
    $text.color.ref(mxt.color.onSurface),
    $text.style.ref(mxt.textStyle.caption),
    $text.fontWeight.w700(),
    $text.letterSpacing(1),
  );

  // 规格标签
  static Style get specLabel => Style(
    $text.color.ref(mxt.color.onSurfaceVariant),
    $text.style.ref(mxt.textStyle.caption),
  );

  // 规格值
  static Style get specValue => Style(
    $text.color.ref(mxt.color.onSurface),
    $text.style.ref(mxt.textStyle.caption),
    $text.fontWeight.w700(),
    $text.maxLines(1),
    $text.overflow.ellipsis(),
  );

  // 标签文字
  static Style get tagText => Style(
    $text.color.ref(mxt.color.onSurfaceVariant),
    $text.style.ref(mxt.textStyle.caption),
  );

  // 按钮文字
  static Style get btnText => Style(
    $text.color(const Color(0xFFFFFFFF)),
    $text.fontWeight.w700(),
    $text.style.ref(mxt.textStyle.body),
    $text.letterSpacing(0.5),
  );

  // 红色斜杠
  static Style get redSlash => Style(
    $text.color(accent),
    $text.style.ref(mxt.textStyle.headline3),
    $text.fontWeight.w700(),
  );

  // ── 布局 ──

  static Style get infoCard => Style($flex.gap.ref(mxt.space.small));

  static Style get metaRow => Style(
    $flex.gap.ref(mxt.space.small),
    $flex.mainAxisAlignment.center(),
    $flex.crossAxisAlignment.center(),
  );

  // ── 参数面板 ──

  static Style get paramPanel => Style(
    $box.borderRadius.all.ref(mxt.radius.small),
    $box.color.ref(mxt.color.surface),
    $box.padding.all.ref(mxt.space.small),
    $box.width(double.infinity),
  );

  static Style get paramRow => Style(
    $flex.mainAxisAlignment.spaceBetween(),
    $flex.crossAxisAlignment.center(),
    $box.padding.horizontal.ref(mxt.space.small),
  );

  static Style get paramLabel => Style(
    $text.color.ref(mxt.color.onSurfaceVariant),
    $text.style.ref(mxt.textStyle.caption),
  );

  static Style get paramValue => Style(
    $text.color.ref(mxt.color.onSurface),
    $text.style.ref(mxt.textStyle.caption),
    $text.fontWeight.w600(),
  );

  static Style get expandBtn => Style(
    $flex.mainAxisAlignment.center(),
    $flex.crossAxisAlignment.center(),
  );

  static Style get expandBtnText => Style(
    $text.color.ref(mxt.color.primary),
    $text.style.ref(mxt.textStyle.caption),
    $text.fontWeight.w600(),
  );

  // ── 评分卡片 ──

  static Style get ratingCard => Style(
    $box.borderRadius.all.ref(mxt.radius.small),
    $box.padding.all.ref(mxt.space.small),
    $box.color.ref(mxt.color.surface),
    $box.width(double.infinity),
  );

  static Style get ratingValue => Style(
    $text.color.ref(mxt.color.onSurface),
    $text.style.ref(mxt.textStyle.headline2),
    $text.fontWeight.w700(),
  );

  static Style get ratingHint => Style(
    $text.color.ref(mxt.color.onSurfaceVariant),
    $text.style.ref(mxt.textStyle.caption),
  );

  static Style get ratingErpLabel => Style(
    $text.color.ref(mxt.color.onSurfaceVariant),
    $text.style.ref(mxt.textStyle.caption),
  );

  // 图标
  static Style get navIcon =>
      Style($icon.color.ref(mxt.color.onSurface), $icon.size(20));
}
