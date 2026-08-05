import 'package:miniauto_keeper/core/theme/app_theme.dart';
import 'package:mix/mix.dart';

class BrandSelectorStyle {
  static Style get sheetContainer => Style(
    $box.color.ref(mxt.color.surface),
    $box.borderRadius.topLeft.ref(mxt.radius.medium),
    $box.borderRadius.topRight.ref(mxt.radius.medium),
    $box.clipBehavior.antiAlias(),
    $box.padding.horizontal.ref(mxt.space.medium),
    $box.padding.bottom.ref(mxt.space.medium),
  );

  static Style get dragHandle => Style(
    $box.width(36),
    $box.height(4),
    $box.borderRadius.all(2),
    $box.color.ref(mxt.color.outlineVariant),
    $box.margin.bottom.ref(mxt.space.medium),
  );

  static Style get title => Style(
    $text.style.ref(mxt.textStyle.headline3),
    $text.color.ref(mxt.color.onSurface),
  );

  static Style get searchBar => Style(
    $box.height(40),
    $box.borderRadius.all(8),
    $box.color.ref(mxt.color.surfaceVariant),
    $box.padding.horizontal(12),
    $box.margin.bottom(12),
    $flex.crossAxisAlignment.center(),
    $flex.gap(8),
  );

  static Style get searchIcon =>
      Style($icon.size(18), $icon.color.ref(mxt.color.onSurfaceVariant));

  static const crossAxisCount = 4;
  static const mainAxisSpacing = 12.0;
  static const crossAxisSpacing = 12.0;
  static const childAspectRatio = 0.72;

  static Style get tileContainer =>
      Style($flex.gap(6), $flex.crossAxisAlignment.center());

  static Style get tileImageBox => Style(
    $box.borderRadius.all(8),
    $box.clipBehavior.antiAlias(),
    $box.color.ref(mxt.color.surfaceVariant),
  );

  static Style get tileName => Style(
    $text.style.ref(mxt.textStyle.caption),
    $text.color.ref(mxt.color.onSurface),
    $text.maxLines(1),
    $text.overflow.ellipsis(),
  );
}
