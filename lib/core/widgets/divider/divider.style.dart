import 'package:miniauto_keeper/core/utils/screen_adapter.dart';
import 'package:mix/mix.dart';

import 'package:miniauto_keeper/core/theme/app_theme.dart';

class AppDividerStyle {
  /// 水平分割线
  static Style get horizontal => Style(
    $box.color.ref(mxt.color.outlineVariant),
    $box.height(1),
    $box.width.infinity(),
    $box.margin.vertical.ref(mxt.space.small),
  );

  /// 垂直分割线
  static Style get vertical => Style(
    $box.color.ref(mxt.color.outlineVariant),
    $box.width(1),
    $box.height.infinity(),
    $box.margin.horizontal.ref(mxt.space.small),
  );

  /// @deprecated 向后兼容，等价于 [horizontal]
  static Style get base => horizontal;
}
