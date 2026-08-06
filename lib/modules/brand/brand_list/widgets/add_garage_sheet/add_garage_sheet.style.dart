import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:miniauto_keeper/core/theme/app_theme.dart';
import 'package:miniauto_keeper/core/utils/screen_adapter.dart';
import 'package:mix/mix.dart';

class AddGarageSheetStyle {
  static Style get sheetContainer => Style(
    $box.color.ref(mxt.color.surface),
    $box.borderRadius.topLeft(r(16)),
    $box.borderRadius.topRight(r(16)),
    $box.clipBehavior(Clip.antiAlias),
  );

  static Style get handleBar => Style(
    $box.width(w(40)),
    $box.height(h(4)),
    $box.color.ref(mxt.color.onSurfaceVariant),
    $box.borderRadius.all(r(2)),
  );

  static Style get handleBarWrapper => Style(
    $box.padding.top(w(12)),
    $box.padding.bottom(w(8)),
    $box.alignment(Alignment.center),
  );

  static Style get titleText => Style(
    $text.style.ref(mxt.textStyle.body),
    $text.color.ref(mxt.color.onSurface),
  );

  static Style get headerRow => Style(
    $box.padding.horizontal(w(16)),
    $box.padding.bottom(w(8)),
    $flex.mainAxisAlignment.spaceBetween(),
    $flex.crossAxisAlignment.center(),
  );

  static Style get productSummary => Style(
    $box.padding.horizontal(w(16)),
    $box.padding.bottom(w(4)),
    $box.padding.top(w(4)),
  );

  static Style get productName => Style(
    $text.style.ref(mxt.textStyle.body),
    $text.color.ref(mxt.color.onSurfaceVariant),
  );

  static Style get formBody => Style($box.padding.horizontal(w(16)));

  static Style get submitArea =>
      Style($box.padding.all(w(16)), $box.padding.bottom(w(32)));

  // ── 数量 / 单价 并排 ──
  static Style get rowFields => Style(
    $flex.mainAxisAlignment.start(),
    $flex.crossAxisAlignment.start(),
    $flex.gap(w(12)),
  );
}
