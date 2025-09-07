import 'package:bodysnap/core/util/app_log.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 디바이스 화면 정보 번들
typedef DeviceMetrics = ({
  double devicePixelRatio,
  Size physicalSize,
  Size logicalSize,
});

final sharedPrefsProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('Override in BootStrap!');
});

final packageInfoProvider = Provider<PackageInfo>((ref) {
  throw UnimplementedError('Override in BootStrap!');
});

final deviceMetricsProvider = FutureProvider.autoDispose<DeviceMetrics>((
  ref,
) async {
  // Flutter 엔진 바인딩 보장
  final binding = WidgetsFlutterBinding.ensureInitialized();

  // 주 View 가져오기
  final view = binding.platformDispatcher.views.first;
  final dpr = view.devicePixelRatio;
  final physicalSize = view.physicalSize;
  final logicalSize = Size(physicalSize.width / dpr, physicalSize.height / dpr);

  AppLog.d('devicePixelRatio: $dpr');
  AppLog.d('physicalSize: $physicalSize');
  AppLog.d('logical size: ${physicalSize.width} x ${physicalSize.height}');

  return (
    devicePixelRatio: dpr,
    physicalSize: physicalSize,
    logicalSize: logicalSize,
  );
});

/// ThemeMode Provider
final themeModeProvider =
    NotifierProvider<ThemeModeNotifier, ThemeMode>(ThemeModeNotifier.new);

class ThemeModeNotifier extends Notifier<ThemeMode> {
  static const _kKey = 'themeMode'; // 0:system,1:light,2:dark

  @override
  ThemeMode build() {
    final prefs = ref.watch(sharedPrefsProvider);
    final idx = prefs.getInt(_kKey) ?? 0;
    return ThemeMode.values[idx.clamp(0, ThemeMode.values.length - 1)];
  }

  Future<void> set(ThemeMode mode) async {
    state = mode;
    final prefs = ref.read(sharedPrefsProvider);
    await prefs.setInt(_kKey, mode.index);
  }
}

/// Locale Provider (null = 시스템)
final localeProvider =
    NotifierProvider<LocaleNotifier, Locale?>(LocaleNotifier.new);

class LocaleNotifier extends Notifier<Locale?> {
  static const _kKey = 'localeCode'; // 'ko' | 'en' | 미설정(null=system)

  @override
  Locale? build() {
    final prefs = ref.watch(sharedPrefsProvider);
    final code = prefs.getString(_kKey);
    if (code == null || code.isEmpty) return null; // 시스템
    return Locale(code);
  }

  Future<void> set(Locale? locale) async {
    state = locale;
    final prefs = ref.read(sharedPrefsProvider);
    if (locale == null) {
      await prefs.remove(_kKey);
    } else {
      await prefs.setString(_kKey, locale.languageCode);
    }
  }
}