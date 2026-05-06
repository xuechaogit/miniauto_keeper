// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appName => '车仔助手';

  @override
  String get homeTitle => '模型车库';

  @override
  String collectStatus(String count, String total) {
    return '收藏进度：$count / $total';
  }
}
