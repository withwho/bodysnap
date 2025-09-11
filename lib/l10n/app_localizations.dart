import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ko.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ko')
  ];

  /// No description provided for @common_confirm.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get common_confirm;

  /// No description provided for @common_cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get common_cancel;

  /// No description provided for @common_delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get common_delete;

  /// No description provided for @settings_page_title.
  ///
  /// In en, this message translates to:
  /// **'Setting'**
  String get settings_page_title;

  /// No description provided for @settings_section_application.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get settings_section_application;

  /// No description provided for @settings_section_security.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get settings_section_security;

  /// No description provided for @settings_section_support.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get settings_section_support;

  /// No description provided for @settings_list_version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get settings_list_version;

  /// No description provided for @settings_list_subscribe.
  ///
  /// In en, this message translates to:
  /// **'Subscription'**
  String get settings_list_subscribe;

  /// No description provided for @settings_list_theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settings_list_theme;

  /// No description provided for @settings_list_language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settings_list_language;

  /// No description provided for @settings_list_password.
  ///
  /// In en, this message translates to:
  /// **'Set Password'**
  String get settings_list_password;

  /// No description provided for @settings_list_privacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get settings_list_privacy;

  /// No description provided for @settings_list_backup.
  ///
  /// In en, this message translates to:
  /// **'Backup & Restore'**
  String get settings_list_backup;

  /// No description provided for @settings_list_reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get settings_list_reset;

  /// No description provided for @settings_list_contact.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get settings_list_contact;

  /// No description provided for @settings_theme_system.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get settings_theme_system;

  /// No description provided for @settings_theme_light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get settings_theme_light;

  /// No description provided for @settings_theme_dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get settings_theme_dark;

  /// No description provided for @settings_language_system.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get settings_language_system;

  /// No description provided for @settings_language_en.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get settings_language_en;

  /// No description provided for @settings_language_kr.
  ///
  /// In en, this message translates to:
  /// **'Korean'**
  String get settings_language_kr;

  /// No description provided for @settings_reset_title.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get settings_reset_title;

  /// No description provided for @settings_reset_message.
  ///
  /// In en, this message translates to:
  /// **'Reset app data?\nThis action can\'t be undone.'**
  String get settings_reset_message;

  /// No description provided for @settings_reset_confirm.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get settings_reset_confirm;

  /// No description provided for @settings_password_input_enter.
  ///
  /// In en, this message translates to:
  /// **'Enter passcode'**
  String get settings_password_input_enter;

  /// No description provided for @settings_password_input_new.
  ///
  /// In en, this message translates to:
  /// **'Enter new passcode'**
  String get settings_password_input_new;

  /// No description provided for @settings_password_input_repeat.
  ///
  /// In en, this message translates to:
  /// **'Repeat passcode'**
  String get settings_password_input_repeat;

  /// No description provided for @settings_password_input_error.
  ///
  /// In en, this message translates to:
  /// **'Passcode do not match.\nTry again'**
  String get settings_password_input_error;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'ko'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'ko': return AppLocalizationsKo();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
