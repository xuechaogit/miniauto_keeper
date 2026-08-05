import 'dart:ui';

import 'package:miniauto_keeper/core/theme/app_theme.dart';
import 'package:miniauto_keeper/core/utils/screen_adapter.dart';
import 'package:mix/mix.dart';

class BrandFilterBarStyle {
  /// 筛选栏外层内边距
  static Style get barPadding => Style($box.padding.horizontal(w(12)));

  /// 筛选项间距
  static final chipGap = w(8);

  /// 筛选项基础容器
  static Style chipBase({bool isActive = false}) => Style(
    $box.padding.horizontal(10),
    $box.padding.vertical(5),
    $box.borderRadius.all(r(16)),
    $box.border.width(isActive ? 1.5 : 1),
    $box.border.color.ref(isActive ? mxt.color.primary : mxt.color.onSurface),
  );

  /// 筛选项文字基础
  static Style chipText({bool isActive = false}) => Style(
    $text.style.ref(mxt.textStyle.caption),
    $text.style.color.ref(isActive ? mxt.color.primary : mxt.color.onSurface),
    $text.style.fontWeight(isActive ? FontWeight.w600 : FontWeight.normal),
  );

  /// 筛选项文字基础
  static Style get chipTextBase => Style($text.style.fontSize(13));

  /// 筛选项图标基础
  static Style get chipIconBase => Style($icon.size(16));
}
