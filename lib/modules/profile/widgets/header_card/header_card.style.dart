import 'package:mix/mix.dart';

import '../../../../core/theme/app_theme.dart';

class HeaderCardStyle {
  static final container = Style($box.color.ref(mxt.color.surfaceVariant));

  static final driverName = Style(
    $text.color.ref(mxt.color.onSurface),
    $text.fontSize(24),
    $text.fontWeight.w800(),
    $text.letterSpacing(2),
  );

  static final statusText = Style(
    $text.color.ref(mxt.color.onSurfaceVariant),
    $text.fontSize(11),
    $text.letterSpacing(2.5),
    $text.fontWeight.w600(),
  );
}
