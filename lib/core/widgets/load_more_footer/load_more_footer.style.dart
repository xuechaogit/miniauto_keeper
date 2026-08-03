import 'package:miniauto_keeper/core/theme/app_theme.dart';
import 'package:miniauto_keeper/core/theme/app_theme_tool.dart';
import 'package:miniauto_keeper/core/utils/screen_adapter.dart';
import 'package:mix/mix.dart';

class LoadMoreFooterStyle {
  static const double spinnerSize = 16;
  static const double spinnerGap = 8;

  static Style get container => Style($box.height(48), $box.alignment.center());

  static Style get loadingText => Style(
    $text.style.ref(mxt.textStyle.body),
    $text.style.color.ref(mxt.color.onSurface),
  );

  static Style get errorText => Style(
    $text.style.ref(mxt.textStyle.body),
    $text.style.color.ref(mxt.color.onSurface),
  );

  static Style get noMoreText => Style(
    $text.style.ref(mxt.textStyle.body),
    $text.style.color.ref(mxt.color.onSurface),
  );

  static Style get errorIcon => Style(
    $text.style.ref(mxt.textStyle.headline2),
    $icon.color.ref(mxt.color.onSurface),
  );
}
