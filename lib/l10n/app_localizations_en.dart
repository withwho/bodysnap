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
  String get settings_page_title => 'Setting';

  @override
  String get settings_section_application => 'General';

  @override
  String get settings_section_security => 'Security';

  @override
  String get settings_section_support => 'Support';

  @override
  String get settings_list_version => 'Version';

  @override
  String get settings_list_subscribe => 'Subscription';

  @override
  String get settings_list_theme => 'Theme';

  @override
  String get settings_list_language => 'Language';

  @override
  String get settings_list_password => 'Set Password';

  @override
  String get settings_list_privacy => 'Privacy Policy';

  @override
  String get settings_list_backup => 'Backup & Restore';

  @override
  String get settings_list_reset => 'Reset';

  @override
  String get settings_list_contact => 'Contact Us';

  @override
  String get settings_theme_system => 'System';

  @override
  String get settings_theme_light => 'Light';

  @override
  String get settings_theme_dark => 'Dark';

  @override
  String get settings_language_system => 'System';

  @override
  String get settings_language_en => 'English';

  @override
  String get settings_language_kr => 'Korean';

  @override
  String get settings_reset_title => 'Reset';

  @override
  String get settings_reset_message => 'Reset app data?\nThis action can\'t be undone.';

  @override
  String get settings_reset_confirm => 'Reset';

  @override
  String get settings_password_input_enter => 'Enter passcode';

  @override
  String get settings_password_input_new => 'Enter new passcode';

  @override
  String get settings_password_input_repeat => 'Repeat passcode';

  @override
  String get settings_password_input_error => 'Passcode do not match.\nTry again';
}
