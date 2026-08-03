import 'package:mix/mix.dart';

class BrandFilterBarStyle {
  /// 筛选栏外层内边距
  static Style get barPadding =>
      Style($box.padding.horizontal(16), $box.padding.vertical(8));

  /// 筛选项间距
  static const chipGap = 8.0;

  /// 筛选项基础容器
  static Style get chipBase =>
      Style($box.padding.horizontal(12), $box.padding.vertical(12));

  /// 筛选项文字基础
  static Style get chipTextBase => Style($text.style.fontSize(13));

  /// 筛选项图标基础
  static Style get chipIconBase => Style($icon.size(16));
}
