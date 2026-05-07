import 'package:flutter/material.dart';
import 'package:mix/mix.dart';
import 'app_theme.dart'; // 确保能访问到你的 mxt 实例

extension MixContextX on BuildContext {
  // 获取当前上下文中的 MixThemeData
  MixThemeData get _mixData => MixTheme.of(this);

  /// 获取颜色值
  Color color(ColorToken token) => _mixData.colors[token]!;

  /// 获取圆角值
  Radius radius(RadiusToken token) => _mixData.radii[token]!;

  /// 获取数值型间距
  double space(SpaceToken token) => _mixData.spaces[token]!;

  /// 获取完整的文本样式
  TextStyle textStyle(TextStyleToken token) => _mixData.textStyles[token]!;
}
