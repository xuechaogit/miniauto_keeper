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

  // 1. 基础背景：用于 Scaffold 的底层
  ColorToken get background => const ColorToken('background');

  // 2. 表面背景：用于 Card、Dialog、Menu
  ColorToken get surface => const ColorToken('surface');

  // 3. 变体表面：用于输入框填充、稍微深/浅一点的区域
  ColorToken get surfaceVariant => const ColorToken('surface-variant');

  // 4. 反向颜色：用于黑色主题下的浅色背景（如浮层）
  ColorToken get inverseSurface => const ColorToken('inverse-surface');

  //  // 5. 品牌卡片背景色
  ColorToken get brandCardBg => const ColorToken('brand-card-bg');
  ColorToken get brandCardOverlay => const ColorToken('brand-card-overlay');

  // 6. 边框颜色
  // 标准边框色，用于卡片边框、按钮边框等
  ColorToken get outline => const ColorToken('outline');
  // 装饰性边框/分割线，颜色更浅
  ColorToken get outlineVariant => const ColorToken('outline-variant');
  // 专注边框，用于输入框获取焦点或选中的主色边框
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
  //标题、正文、图标
  ColorToken get onSurface => const ColorToken('on-surface');
  //说明文字、输入框的占位符、不活跃的图标
  ColorToken get onSurfaceVariant => const ColorToken('on-surface-variant');
}

class MyThemeTextStyleToken {
  const MyThemeTextStyleToken();
  TextStyleToken get headline1 => const TextStyleToken('headline1');
  TextStyleToken get headline2 => const TextStyleToken('headline2');
  TextStyleToken get headline3 => const TextStyleToken('headline3');
  TextStyleToken get body => const TextStyleToken('body');
  TextStyleToken get callout => const TextStyleToken('callout');
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

// 2. 声明明亮主题
final lightTheme = MixThemeData(
  colors: {
    mxt.color.primary: const Color(0xFF617AFA),
    mxt.color.background: const Color(0xFFF5F5F5), // 带一点点暖/冷调的白
    mxt.color.surface: const Color(0xFFFFFFFF),
    mxt.color.surfaceVariant: const Color(0xFFE4E9F2), // 输入框用的淡蓝色/灰色

    mxt.color.brandCardBg: const Color(0xFF24292E), // 亮色模式下使用深色卡片形成对比
    mxt.color.brandCardOverlay: const Color(0xFF1A1D21),

    // 边框色定义
    mxt.color.outline: const Color(0xFF74777F),
    mxt.color.outlineVariant: const Color(0xFFC4C6D0),
    mxt.color.outlinePrimary: const Color(0xFF617AFA), // 使用主色作为高亮边框
    // 文字：
    // 1. OnSurface: 接近黑但不是纯黑，非常有质感
    mxt.color.onSurface: const Color(0xFF1A1C1E),
    // 2. OnSurfaceVariant: 用于次要信息
    mxt.color.onSurfaceVariant: const Color(0xFF44474E),

    mxt.color.primaryContainer: const Color(0xFFE3F2FD),
    mxt.color.infoContainer: const Color(0xFFE3F2FD),
    mxt.color.successContainer: const Color(0xFFE8F5E9),
    mxt.color.warningContainer: const Color(0xFFFFF3E0),
    mxt.color.errorContainer: const Color(0xFFFFEbee),
    mxt.color.onPrimaryContainer: const Color(0xFF1976D2),
    mxt.color.onInfoContainer: const Color(0xFF1976D2),
    mxt.color.onSuccessContainer: const Color(0xFF388E3C),
    mxt.color.onWarningContainer: const Color(0xFFFF8F00),
    mxt.color.onErrorContainer: const Color(0xFFD32F2F),
  },
  textStyles: {
    // 使用原生 TextStyle，不再依赖 GoogleFonts
    mxt.textStyle.headline1: const TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.bold,
      // 如果你有本地字体，在这里指定 fontFamily
    ),
    mxt.textStyle.headline2: const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      // 如果你有本地字体，在这里指定 fontFamily
    ),
    mxt.textStyle.headline3: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      // 如果你有本地字体，在这里指定 fontFamily
    ),
    mxt.textStyle.body: const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.normal,
    ),
    mxt.textStyle.caption: const TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.normal,
    ),
  },
  radii: {
    mxt.radius.large: const Radius.circular(100),
    mxt.radius.medium: const Radius.circular(12),
    mxt.radius.small: const Radius.circular(4),
  },
  spaces: {mxt.space.large: 24, mxt.space.medium: 16, mxt.space.small: 8},
);

// 3. 声明暗黑主题
final darkTheme = MixThemeData(
  colors: {
    mxt.color.primary: const Color(0xFF617AFA),
    mxt.color.background: const Color(0xFF1A1C1E), // 极深蓝灰，比纯黑更高级
    mxt.color.surface: const Color(0xFF222427), // 稍微提亮的卡片色
    mxt.color.surfaceVariant: const Color(0xFF44474E), // 输入框等容器色
    mxt.color.onSurface: const Color(0xFFE2E2E6),
    mxt.color.onSurfaceVariant: const Color(0xFFC4C6D0),

    mxt.color.brandCardBg: const Color(0xFF161616), // 纯净的深碳黑
    mxt.color.brandCardOverlay: const Color(0xFF0D0D0D),

    mxt.color.outline: const Color(0xFF8E9199),
    mxt.color.outlineVariant: const Color(0xFF44474E),
    mxt.color.outlinePrimary: const Color(0xFF8194FF), // 稍微提亮的主色，更适合暗底
    // 语义色
    mxt.color.primaryContainer: const Color(0xFF1E2A4A), // 深蓝色背景
    mxt.color.onPrimaryContainer: const Color(0xFFD1E4FF), // 浅蓝色文字
    // 信息 (Info) - 通常与 Primary 接近，或偏青色
    mxt.color.infoContainer: const Color(0xFF003355), // 深蓝偏青
    mxt.color.onInfoContainer: const Color(0xFFA1E4FF), // 亮青色文字
    // 成功 (Success)
    mxt.color.successContainer: const Color(0xFF0A3E1F), // 深森林绿
    mxt.color.onSuccessContainer: const Color(0xFFB9F6CA), // 亮薄荷绿
    // 警告 (Warning)
    mxt.color.warningContainer: const Color(0xFF432D00), // 深琥珀色
    mxt.color.onWarningContainer: const Color(0xFFFFE082), // 亮金黄色
    // 错误 (Error)
    mxt.color.errorContainer: const Color(0xFF621B16), // 深酒红
    mxt.color.onErrorContainer: const Color(0xFFFFDAD6), // 浅粉红
  },
  textStyles: {
    mxt.textStyle.headline1: const TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.bold,
      // 如果你有本地字体，在这里指定 fontFamily
    ),
    mxt.textStyle.headline2: const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      // 如果你有本地字体，在这里指定 fontFamily
    ),
    mxt.textStyle.headline3: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      // 如果你有本地字体，在这里指定 fontFamily
    ),
    mxt.textStyle.body: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.normal,
    ),
    mxt.textStyle.caption: const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.normal,
    ),
  },
  radii: {
    mxt.radius.large: const Radius.circular(100),
    mxt.radius.medium: const Radius.circular(12),
    mxt.radius.small: const Radius.circular(4), // 暗色模式通常更紧凑
  }, // 暗色模式通常更硬朗
  spaces: {mxt.space.large: 24, mxt.space.medium: 16, mxt.space.small: 8},
);

ThemeData convertMixToThemeData(MixThemeData mixData, Brightness brightness) {
  final primaryColor = mixData.colors[mxt.color.primary]!;
  final backgroundColor = mixData.colors[mxt.color.background]!;
  final surfaceColor = mixData.colors[mxt.color.surface]!;
  final onSurfaceColor = mixData.colors[mxt.color.onSurface]!;

  return ThemeData(
    brightness: brightness,
    useMaterial3: true,
    colorScheme:
        ColorScheme.fromSeed(
          seedColor: primaryColor,
          brightness: brightness,
        ).copyWith(
          // 核心：强制同步 Mix 的背景定义
          surface: surfaceColor,
          onSurface: onSurfaceColor,
          // 在 M3 中，background 已经逐渐被 surface 家族取代
          // 但为了兼容 Scaffold，这里必须明确赋值
          background: backgroundColor,
          onBackground: onSurfaceColor,
        ),
    // 关键：解决 Scaffold 不跟随 Mix 设计的问题
    scaffoldBackgroundColor: backgroundColor,
    // 影响弹窗、菜单的背景
    canvasColor: surfaceColor,
  );
}
