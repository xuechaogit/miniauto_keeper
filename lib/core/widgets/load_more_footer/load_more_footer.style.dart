import 'package:flutter/material.dart';
import 'package:miniauto_keeper/core/theme/app_theme.dart';
import 'package:miniauto_keeper/core/theme/app_theme_tool.dart';
import 'package:miniauto_keeper/core/utils/screen_adapter.dart';
import 'package:mix/mix.dart';

class LoadMoreFooterStyle {
  static const double spinnerSize = 16;
  static const double spinnerGap = 8;
  static const double containerHeight = 48;

  static TextStyle get textStyle => TextStyle(
    fontSize: sp(13),
    color: const Color(0xFF16181D).withOpacity(0.45),
  );

  static TextStyle get errorTextStyle => TextStyle(
    fontSize: sp(13),
    color: const Color(0xFF16181D).withOpacity(0.5),
  );

  static TextStyle get noMoreTextStyle => TextStyle(
    fontSize: sp(12),
    color: const Color(0xFF16181D).withOpacity(0.25),
  );
}
