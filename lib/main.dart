import 'package:bodysnap/app/app.dart';
import 'package:bodysnap/app/app_bootstrap.dart';
import 'package:bodysnap/app/app_providers.dart';
import 'package:bodysnap/core/util/app_log.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  // Flutter 엔진과 위젯 시스템을 준비시키고, 그 바인딩 객체를 binding 변수에 담는다.
  // runApp() 전에 비동기/네이티브 초기화 작업이 필요한 경우
  // 예: SharedPreferences 초기화, Firebase 초기화, 플러그인 채널 호출 등
  final binding = WidgetsFlutterBinding.ensureInitialized();

  // 로그 설정
  AppLog.setup(name: 'BodySnap');
  AppLog.i('App Start');

  // 세로 모드 고정
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp, // 세로 위
    // DeviceOrientation.portraitDown, // 필요하면 뒤집힌 세로도 허용 가능
  ]);

  // 스플래시 유지
  FlutterNativeSplash.preserve(widgetsBinding: binding);

  // 디버그 할때 화면에 레이어 경계선 등을 그려준다.
  // if (kDebugMode) {
  //   SdebugPaintSizeEnabled = true; // 위젯 크기/패딩/정렬 가이드
  //   debugPaintLayerBordersEnabled = true; // 레이어 경계선
  //   debugPaintPointersEnabled = true; // 포인터 히트테스트
  // }

  final packageInfo = await PackageInfo.fromPlatform();
  AppLog.d('appName: ${packageInfo.appName}');
  AppLog.d('packageName: ${packageInfo.packageName}');
  AppLog.d('buildNumber: ${packageInfo.buildNumber}');
  AppLog.d('version size: ${packageInfo.version}');

  final sharedPreferences = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        packageInfoProvider.overrideWithValue(packageInfo),
        sharedPrefsProvider.overrideWithValue(sharedPreferences),
      ],
      child: const AppBootStrap(),
    ),
  );
}
