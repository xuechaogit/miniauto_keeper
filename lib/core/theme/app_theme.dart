import 'package:miniauto_keeper/core/utils/screen_adapter.dart';
import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

// 1. 定义 Token 结构
const mxt = MyThemeToken();

class MyThemeToken {
  const MyThemeToken();
  final color = const MyThemeColorToken();
  final textStyle = const MyThemeTextStyleToken();
  final radius = const MyThemeRadiusToken();
  final space = const MyThemeSpaceToken();
}

class MyThemeColorToken {
  const MyThemeColorToken();
  ColorToken get primary => const ColorToken('primary');

  // 基础背景：用于 Scaffold 的底层
  ColorToken get background => const ColorToken('background');

  // 表面背景：用于 Card、Dialog、Menu
  ColorToken get surface => const ColorToken('surface');

  // 变体表面：用于输入框填充、稍微深/浅一点的区域
  ColorToken get surfaceVariant => const ColorToken('surface-variant');

  // 品牌卡片背景色
  ColorToken get brandCardBg => const ColorToken('brand-card-bg');
  ColorToken get brandCardOverlay => const ColorToken('brand-card-overlay');

  // 边框颜色
  ColorToken get outline => const ColorToken('outline');
  ColorToken get outlineVariant => const ColorToken('outline-variant');
  ColorToken get outlinePrimary => const ColorToken('outline-primary');

  // 语义色：背景
  ColorToken get primaryContainer => const ColorToken('primary-container');
  ColorToken get infoContainer => const ColorToken('info-container');
  ColorToken get successContainer => const ColorToken('success-container');
  ColorToken get warningContainer => const ColorToken('warning-container');
  ColorToken get errorContainer => const ColorToken('error-container');

  // 语义色：文字/图标
  ColorToken get onPrimaryContainer => const ColorToken('on-primary-container');
  ColorToken get onInfoContainer => const ColorToken('on-info-container');
  ColorToken get onSuccessContainer => const ColorToken('on-success-container');
  ColorToken get onWarningContainer => const ColorToken('on-warning-container');
  ColorToken get onErrorContainer => const ColorToken('on-error-container');

  // 内容颜色
  ColorToken get onSurface => const ColorToken('on-surface');
  ColorToken get onSurfaceVariant => const ColorToken('on-surface-variant');

  // Shimmer 骨架屏专属颜色
  ColorToken get shimmerBase => const ColorToken('shimmer-base');
  ColorToken get shimmerHighlight => const ColorToken('shimmer-highlight');
}

class MyThemeTextStyleToken {
  const MyThemeTextStyleToken();
  TextStyleToken get headline1 => const TextStyleToken('headline1');
  TextStyleToken get headline2 => const TextStyleToken('headline2');
  TextStyleToken get headline3 => const TextStyleToken('headline3');
  TextStyleToken get body => const TextStyleToken('body');
  TextStyleToken get caption => const TextStyleToken('caption');
}

class MyThemeRadiusToken {
  const MyThemeRadiusToken();
  RadiusToken get large => const RadiusToken('radius-large');
  RadiusToken get medium => const RadiusToken('radius-medium');
  RadiusToken get small => const RadiusToken('radius-small');
}

class MyThemeSpaceToken {
  const MyThemeSpaceToken();
  SpaceToken get large => const SpaceToken('space-large');
  SpaceToken get medium => const SpaceToken('space-medium');
  SpaceToken get small => const SpaceToken('space-small');
}

// === 共享 Token 值（亮暗主题通用，与颜色无关） ===

final _sharedTextStyles = <TextStyleToken, TextStyle>{
  mxt.textStyle.headline1: TextStyle(
    fontSize: sp(20),
    fontWeight: FontWeight.bold,
  ),
  mxt.textStyle.headline2: TextStyle(
    fontSize: sp(18),
    fontWeight: FontWeight.bold,
  ),
  mxt.textStyle.headline3: TextStyle(
    fontSize: sp(16),
    fontWeight: FontWeight.bold,
  ),
  mxt.textStyle.body: TextStyle(
    fontSize: sp(14),
    fontWeight: FontWeight.normal,
  ),
  mxt.textStyle.caption: TextStyle(
    fontSize: sp(12),
    fontWeight: FontWeight.normal,
  ),
};

final _sharedRadii = <RadiusToken, Radius>{
  mxt.radius.large: Radius.circular(w(100)),
  mxt.radius.medium: Radius.circular(w(12)),
  mxt.radius.small: Radius.circular(w(4)),
};

final _sharedSpaces = <SpaceToken, double>{
  mxt.space.large: w(24),
  mxt.space.medium: w(16),
  mxt.space.small: w(8),
};

// 2. 颜色定义

Map<ColorToken, Color> _lightColors() => {
  mxt.color.primary: const Color(0xFF3B5EF5),
  mxt.color.background: const Color(0xFFFFFFFF),
  mxt.color.surface: const Color(0xFFF2F4F7),
  mxt.color.surfaceVariant: const Color(0xFFE4E8F0),
  mxt.color.onSurface: const Color(0xFF16181D),
  mxt.color.onSurfaceVariant: const Color(0xFF5F6470),
  mxt.color.brandCardBg: const Color(0xFF1A1F2E),
  mxt.color.brandCardOverlay: const Color(0xFF10131A),
  mxt.color.outline: const Color(0xFF9196A4),
  mxt.color.outlineVariant: const Color(0xFFD0D4DC),
  mxt.color.outlinePrimary: const Color(0xFF3B5EF5),
  mxt.color.primaryContainer: const Color(0xFFE8EDFF),
  mxt.color.infoContainer: const Color(0xFFE8EDFF),
  mxt.color.successContainer: const Color(0xFFE6F4EA),
  mxt.color.warningContainer: const Color(0xFFFFF5E6),
  mxt.color.errorContainer: const Color(0xFFFDE8EC),
  mxt.color.onPrimaryContainer: const Color(0xFF1E3FA8),
  mxt.color.onInfoContainer: const Color(0xFF1E3FA8),
  mxt.color.onSuccessContainer: const Color(0xFF1B7A3A),
  mxt.color.onWarningContainer: const Color(0xFFB86E00),
  mxt.color.onErrorContainer: const Color(0xFFC6283A),
  mxt.color.shimmerBase: const Color(0xFFE4E8F0),
  mxt.color.shimmerHighlight: const Color(0xFFF2F4F7),
};

Map<ColorToken, Color> _darkColors() => {
  mxt.color.primary: const Color(0xFF7B93FC),
  mxt.color.background: const Color(0xFF13151A),
  mxt.color.surface: const Color(0xFF1C1E24),
  mxt.color.surfaceVariant: const Color(0xFF2A2D36),
  mxt.color.onSurface: const Color(0xFFE3E6EE),
  mxt.color.onSurfaceVariant: const Color(0xFFA3A8B5),
  mxt.color.brandCardBg: const Color(0xFF0D0E12),
  mxt.color.brandCardOverlay: const Color(0xFF060708),
  mxt.color.outline: const Color(0xFF6B7080),
  mxt.color.outlineVariant: const Color(0xFF404350),
  mxt.color.outlinePrimary: const Color(0xFF7B93FC),
  mxt.color.primaryContainer: const Color(0xFF1E2F6E),
  mxt.color.infoContainer: const Color(0xFF1E2F6E),
  mxt.color.successContainer: const Color(0xFF0F2E1A),
  mxt.color.warningContainer: const Color(0xFF332200),
  mxt.color.errorContainer: const Color(0xFF3D1518),
  mxt.color.onPrimaryContainer: const Color(0xFFD0DBFF),
  mxt.color.onInfoContainer: const Color(0xFFD0DBFF),
  mxt.color.onSuccessContainer: const Color(0xFF7BD99A),
  mxt.color.onWarningContainer: const Color(0xFFFFC74D),
  mxt.color.onErrorContainer: const Color(0xFFFF9E9E),
  mxt.color.shimmerBase: const Color(0xFF23262D),
  mxt.color.shimmerHighlight: const Color(0xFF2D3039),
};

// 3. 声明主题
final lightTheme = MixThemeData(
  colors: _lightColors(),
  textStyles: _sharedTextStyles,
  radii: _sharedRadii,
  spaces: _sharedSpaces,
);

final darkTheme = MixThemeData(
  colors: _darkColors(),
  textStyles: _sharedTextStyles,
  radii: _sharedRadii,
  spaces: _sharedSpaces,
);

// 4. Mix → Material 桥接
const _lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFF3B5EF5),
  onPrimary: Color(0xFFFFFFFF),
  primaryContainer: Color(0xFFE8EDFF),
  onPrimaryContainer: Color(0xFF1E3FA8),
  secondary: Color(0xFF5F6470),
  onSecondary: Color(0xFFFFFFFF),
  secondaryContainer: Color(0xFFE4E8F0),
  onSecondaryContainer: Color(0xFF16181D),
  tertiary: Color(0xFF7B7A40),
  onTertiary: Color(0xFFFFFFFF),
  tertiaryContainer: Color(0xFFFFF5E6),
  onTertiaryContainer: Color(0xFFB86E00),
  error: Color(0xFFC6283A),
  onError: Color(0xFFFFFFFF),
  errorContainer: Color(0xFFFDE8EC),
  onErrorContainer: Color(0xFFC6283A),
  surface: Color(0xFFF2F4F7),
  onSurface: Color(0xFF16181D),
  surfaceContainerHighest: Color(0xFFE4E8F0),
  onSurfaceVariant: Color(0xFF5F6470),
  outline: Color(0xFF9196A4),
  outlineVariant: Color(0xFFD0D4DC),
  surfaceTint: Color(0xFF3B5EF5),
);

const _darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFF7B93FC),
  onPrimary: Color(0xFF13151A),
  primaryContainer: Color(0xFF1E2F6E),
  onPrimaryContainer: Color(0xFFD0DBFF),
  secondary: Color(0xFFA3A8B5),
  onSecondary: Color(0xFF1C1E24),
  secondaryContainer: Color(0xFF2A2D36),
  onSecondaryContainer: Color(0xFFE3E6EE),
  tertiary: Color(0xFFFFC74D),
  onTertiary: Color(0xFF332200),
  tertiaryContainer: Color(0xFF332200),
  onTertiaryContainer: Color(0xFFFFC74D),
  error: Color(0xFFFF9E9E),
  onError: Color(0xFF3D1518),
  errorContainer: Color(0xFF3D1518),
  onErrorContainer: Color(0xFFFF9E9E),
  surface: Color(0xFF1C1E24),
  onSurface: Color(0xFFE3E6EE),
  surfaceContainerHighest: Color(0xFF2A2D36),
  onSurfaceVariant: Color(0xFFA3A8B5),
  outline: Color(0xFF6B7080),
  outlineVariant: Color(0xFF404350),
  surfaceTint: Color(0xFF7B93FC),
);

ThemeData convertMixToThemeData(MixThemeData mixData, Brightness brightness) {
  return ThemeData(
    brightness: brightness,
    useMaterial3: true,
    colorScheme: brightness == Brightness.light
        ? _lightColorScheme
        : _darkColorScheme,
    scaffoldBackgroundColor: mixData.colors[mxt.color.background]!,
  );
}
