import 'package:flutter/foundation.dart';

enum LogLevel { v, d, i, w, e }

class AppLog {
  AppLog._();

  static String _name = 'app'; // 기본 태그/카테고리

  /// 앱 시작 시 한 번 호출해서 기본 태그를 바꿀 수 있습니다.
  static void setup({String name = 'app'}) => _name = name;

  static void v(Object? message, {String? name}) =>
      _log(LogLevel.v, message, name: name);

  static void d(Object? message, {String? name}) =>
      _log(LogLevel.d, message, name: name);

  static void i(Object? message, {String? name}) =>
      _log(LogLevel.i, message, name: name);

  static void w(
    Object? message, {
    String? name,
    Object? error,
    StackTrace? stackTrace,
  }) => _log(
    LogLevel.w,
    message,
    name: name,
    error: error,
    stackTrace: stackTrace,
  );

  static void e(
    Object? message, {
    String? name,
    Object? error,
    StackTrace? stackTrace,
  }) => _log(
    LogLevel.e,
    message,
    name: name,
    error: error,
    stackTrace: stackTrace,
  );

  static void _log(
    LogLevel level,
    Object? message, {
    String? name,
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (!kDebugMode) return; // 디버그에서만 실행

    final tag = name ?? _name;
    final msg = message is String ? message : message.toString();

    // 1) 터미널/`flutter run` 콘솔용
    //    debugPrint는 길이 스로틀링이 있어 긴 로그도 잘리지 않게 나눠 찍어줍니다.
    debugPrint('[$tag][${level.name}] $msg');

    // 2) DevTools Logging 스트림용(구조화 로그)
    // final levelValue = switch (level) {
    //   LogLevel.v => 300, // verbose
    //   LogLevel.d => 500, // debug
    //   LogLevel.i => 800, // info
    //   LogLevel.w => 900, // warning
    //   LogLevel.e => 1000, // error
    // };
    //dev.log(msg, name: tag, level: levelValue, error: error, stackTrace: stackTrace);
  }
}
