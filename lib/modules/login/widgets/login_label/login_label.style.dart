import 'package:mix/mix.dart';

import '../../../../core/theme/app_theme.dart';

class LoginLabelStyle {
  static Style get main => Style(
    $text.style.ref(mxt.textStyle.caption),
    $text.style.fontWeight.w600(),
    $box.margin.bottom(10),
    $box.margin.left(4),
  );
}
