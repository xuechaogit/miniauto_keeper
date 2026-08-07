import 'package:miniauto_keeper/core/theme/app_theme.dart';
import 'package:miniauto_keeper/core/utils/screen_adapter.dart';
import 'package:mix/mix.dart';

class FormNumberFieldStyle {
  static Style get formField => Style(
    $box.padding.vertical.ref(mxt.space.small),
    $flex.mainAxisAlignment.start(),
  );

  static Style get inputField => Style();
}
