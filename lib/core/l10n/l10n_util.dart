import 'package:flutter/widgets.dart';
import 'arb/app_localizations.dart';

extension ContextL10n on BuildContext {
  /// 快速获取翻译实例
  AppLocalizations get l10n => AppLocalizations.of(this)!;

  /// 获取所有支持的语言列表
  List get supportedLocales => AppLocalizations.supportedLocales;

  /// 获取当前语言名称（用于显示在 UI 上）
  String get currentLanguageName => Localizations.localeOf(this).displayName;
}

extension LocaleL10n on Locale {
  /// 将语言代码（Locale）统一映射为高可读性的显示名称
  String get displayName {
    switch (languageCode) {
      case 'zh':
        return '简体中文';
      case 'en':
        return 'English';
      case 'ja':
        return '日本語';
      default:
        return languageCode; // 如果未匹配到，则降级显示原始语言代码（如 'fr'）
    }
  }
}
