// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get common_confirm => '확인';

  @override
  String get common_cancel => '취소';

  @override
  String get common_delete => '삭제';

  @override
  String get settings_page_title => '설정';

  @override
  String get settings_section_application => '일반';

  @override
  String get settings_section_security => '보안';

  @override
  String get settings_section_support => '지원';

  @override
  String get settings_list_version => '버전';

  @override
  String get settings_list_subscribe => '구독';

  @override
  String get settings_list_theme => '테마';

  @override
  String get settings_list_language => '언어';

  @override
  String get settings_list_password => '비밀번호 설정';

  @override
  String get settings_list_privacy => '개인정보처리방침';

  @override
  String get settings_list_backup => '백업 및 복구';

  @override
  String get settings_list_reset => '초기화';

  @override
  String get settings_list_contact => '문의하기';

  @override
  String get settings_theme_system => '자동';

  @override
  String get settings_theme_light => '주간';

  @override
  String get settings_theme_dark => '야간';

  @override
  String get settings_language_system => '자동';

  @override
  String get settings_language_en => '영어';

  @override
  String get settings_language_kr => '한국어';

  @override
  String get settings_reset_title => '초기화';

  @override
  String get settings_reset_message => '앱 데이터를 초기화 하시겠습니까?\n이 작업은 되돌릴 수 없습니다.';

  @override
  String get settings_reset_confirm => '초기화';

  @override
  String get settings_password_input_enter => '비밀번호를 입력하세요.';

  @override
  String get settings_password_input_new => '새로운 비밀번호를 입력하세요.';

  @override
  String get settings_password_input_repeat => '비밀번호를 한 번 더 입력해 주세요.';

  @override
  String get settings_password_input_error => '비밀번호가 일치하지 않습니다.\n다시 입력해 주세요.';
}
