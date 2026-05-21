import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

class AppPagedStyles {
  /// 工业风底部状态/标语提示文本
  static Style get footerText => Style(
    $text.color(const Color(0xFF444444)),
    $text.style.fontSize(11),
    $text.style.fontFamily('Courier'),
    $text.style.letterSpacing(1.0),
  );
}
