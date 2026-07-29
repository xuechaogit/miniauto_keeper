import 'package:miniauto_keeper/core/utils/screen_adapter.dart';
import 'package:mix/mix.dart';

import 'package:miniauto_keeper/core/theme/app_theme.dart';

class AppDividerStyle {
  /// 默认分割线
  static Style get base => Style(
    $box.color.ref(mxt.color.outlineVariant),
    $box.height(h(1)),
    $box.margin.vertical.ref(mxt.space.small),
  );
}
