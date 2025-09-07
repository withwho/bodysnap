// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get common_confirm => 'OK';

  @override
  String get common_cancel => 'Cancel';

  @override
  String get common_delete => 'Delete';

  @override
  String get settings_page_title => 'Settings';

  @override
  String get settings_list_version => 'Version';

  @override
  String get settings_list_password => 'Password';

  @override
  String get settings_list_backup => 'Backup & Restore';

  @override
  String get settings_list_reset => 'Reset';

  @override
  String get settings_list_subscribe => 'Subscribe';

  @override
  String get settings_reset_title => 'Reset';

  @override
  String get settings_reset_message => 'Reset app data? This action can\'t be undone.';

  @override
  String get settings_reset_confirm => 'Reset';
}
