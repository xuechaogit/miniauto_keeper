import 'package:miniauto_keeper/core/theme/app_theme.dart';
import 'package:mix/mix.dart';

class CardPanelStyle {
  // 默认卡片容器
  static Style get base => Style(
    $box.borderRadius.all.ref(mxt.radius.small),
    $box.color.ref(mxt.color.surface),
    $box.padding.all.ref(mxt.space.medium),
    $box.width(double.infinity),
  );

  // 头部标题
  static Style get title => Style(
    $text.color.ref(mxt.color.onSurface),
    $text.style.ref(mxt.textStyle.body),
    $text.fontWeight.w700(),
    $text.letterSpacing(1),
  );
}
