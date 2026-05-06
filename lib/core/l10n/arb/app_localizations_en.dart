// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'MiniAuto Keeper';

  @override
  String get homeTitle => 'Model Garage';

  @override
  String collectStatus(String count, String total) {
    return 'Progress: $count / $total';
  }
}
