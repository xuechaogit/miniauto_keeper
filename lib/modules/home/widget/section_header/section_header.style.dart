import 'package:miniauto_keeper/core/theme/app_theme.dart';
import 'package:miniauto_keeper/core/utils/screen_adapter.dart';
import 'package:mix/mix.dart';

class SectionHeaderStyle {
  static Style get container => Style(
    $flex.mainAxisAlignment.spaceBetween(),
    $flex.crossAxisAlignment.center(),
  );

  static Style get title => Style(
    $text.color.ref(mxt.color.onSurface),
    $text.style.ref(mxt.textStyle.headline3),
  );

  static Style get moreRow => Style(
    $flex.mainAxisAlignment.center(),
    $flex.crossAxisAlignment.center(),
    $flex.gap.ref(mxt.space.small),
  );

  static Style get moreText => Style(
    $text.color.ref(mxt.color.onSurfaceVariant),
    $text.style.ref(mxt.textStyle.body),
  );

  static Style get moreIcon =>
      Style($icon.color.ref(mxt.color.onSurfaceVariant), $icon.size(14));
}
