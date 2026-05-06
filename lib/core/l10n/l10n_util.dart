import 'package:flutter/widgets.dart';

import 'arb/app_localizations.dart';

extension ContextL10n on BuildContext {
  // 快速获取翻译实例
  AppLocalizations get l10n => AppLocalizations.of(this)!;

  // 获取所有支持的语言列表
  List<Locale> get supportedLocales => AppLocalizations.supportedLocales;

  // 获取当前语言名称（用于显示在 UI 上）
  String get currentLanguageName {
    final locale = Localizations.localeOf(this);
    switch (locale.languageCode) {
      case 'zh':
        return '简体中文';
      case 'en':
        return 'English';
      default:
        return locale.languageCode;
    }
  }
}
