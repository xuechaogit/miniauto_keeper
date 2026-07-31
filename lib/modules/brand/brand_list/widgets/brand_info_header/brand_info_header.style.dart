import 'package:miniauto_keeper/core/theme/app_mix_themes.dart';
import 'package:miniauto_keeper/core/theme/app_theme.dart';
import 'package:miniauto_keeper/core/utils/screen_adapter.dart';
import 'package:mix/mix.dart';

class BrandInfoHeaderStyle {
  /// 外层内边距
  static Style get outerPadding => Style($box.padding.all(16));

  /// Logo 图片容器
  static Style get logoBox => Style(
    $box.width(64),
    $box.height(64),
    $box.borderRadius(12),
    $box.clipBehavior.antiAlias(),
  );

  /// 品牌名称
  static Style get brandName => Style(
    $text.style.ref(mxt.textStyle.headline3),
    $text.color.ref(mxt.color.onSurface),
  );

  /// Logo 与文字间距
  static const logoSpacing = 16.0;

  /// 药丸按钮容器
  static Style get pillContainer => Style(
    $box.padding.horizontal(12),
    $box.padding.vertical(6),
    $box.borderRadius(20),
    $box.color.ref(mxt.color.surfaceVariant),
  );

  /// 切换品牌图标
  static Style get switchBrandIcon =>
      Style($icon.size(sp(16)), $icon.color.ref(mxt.color.onSurfaceVariant));

  /// 切换品牌文字
  static Style get switchBrandText => Style(
    $text.style.ref(mxt.textStyle.caption),
    $text.style.color.ref(mxt.color.onSurfaceVariant),
  );

  /// 缺失上报图标
  static Style get reportIcon =>
      Style($icon.size(14), $icon.color.ref(mxt.color.onSurfaceVariant));

  /// 缺失上报文字
  static Style get reportText => Style(
    $text.style.ref(mxt.textStyle.caption),
    $text.style.color.ref(mxt.color.onSurfaceVariant),
  );

  /// 收录商品数文字
  static Style get countText => Style($text.style.ref(mxt.textStyle.caption));

  /// 描述区间距
  static Style get descTopGap => Style($box.margin.top(12));

  /// 描述正文
  static Style get descriptionText => Style(
    $text.style.ref(mxt.textStyle.caption),
    $text.style.color.ref(mxt.color.onSurfaceVariant),
  );

  /// 描述正文（折叠态：单行省略）
  static Style get collapsedDescText => descriptionText.merge(
    Style($text.overflow.ellipsis(), $text.maxLines(1)),
  );

  /// 展开/收起文字
  static Style get toggleText => Style(
    $text.style.ref(mxt.textStyle.caption),
    $text.style.color.ref(mxt.color.primary),
  );

  /// 展开/收起图标
  static Style get toggleIcon =>
      Style($icon.size(18), $icon.color.ref(mxt.color.primary));
}
