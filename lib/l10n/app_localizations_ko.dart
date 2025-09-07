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
  String get settings_list_version => '버전';

  @override
  String get settings_list_password => '비밀번호 설정';

  @override
  String get settings_list_backup => '백업 및 복구';

  @override
  String get settings_list_reset => '초기화';

  @override
  String get settings_list_subscribe => '구독';

  @override
  String get settings_reset_title => '초기화';

  @override
  String get settings_reset_message => '앱 데이터를 초기화하시겠습니까? 이 작업은 되돌릴 수 없습니다.';

  @override
  String get settings_reset_confirm => '초기화';
}
