import 'package:miniauto_keeper/core/theme/app_theme.dart';
import 'package:mix/mix.dart';

class SubmitButtonStyles {
  static Style get base => Style(
    $box.height(58),
    $box.borderRadius.all.ref(mxt.radius.small),
    $box.color.ref(mxt.color.primary),
    $box.alignment.center(),
    $text.style.color.white(),
    $text.style.fontWeight.w700(),
    $text.style.fontSize(16),
    $text.style.letterSpacing(0.5),
  );
}
