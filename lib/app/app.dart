import 'package:bodysnap/app/app_providers.dart';
import 'package:bodysnap/app/app_router.dart';
import 'package:bodysnap/core/platform/app_scroll_behavior.dart';
import 'package:bodysnap/core/platform/platform_style_provider.dart';
import 'package:bodysnap/l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loader_overlay/loader_overlay.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    final isCupertino = ref.watch(isCupertinoProvider);
    final themeMode = ref.watch(themeModeProvider);

    if (isCupertino) {
      Brightness systemBrightness() =>
          WidgetsBinding.instance.platformDispatcher.platformBrightness;

      final brightness = switch (themeMode) {
        ThemeMode.system => systemBrightness(),
        ThemeMode.light => Brightness.light,
        ThemeMode.dark => Brightness.dark,
      };

      return CupertinoApp.router(
        // 디버그에서 true (배너 표시)
        //debugShowCheckedModeBanner: kDebugMode,
        //화면 전체에 머티리얼 베이스라인 그리드(보통 8dp 격자)를 덮어 그려서 레이아웃 정렬을 확인하게 해주는 오버레이.
        //debugShowMaterialGrid: kDebugMode,
        //theme: lightTheme,
        //darkTheme: darkTheme,
        theme: CupertinoThemeData(brightness: brightness),
        locale: locale,
        routerConfig: appRouter,
        scrollBehavior: const AppScrollBehavior(TargetPlatform.iOS),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        builder: (context, child) => LoaderOverlay(
          overlayColor: CupertinoColors.black.withValues(alpha: .35),
          overlayWidgetBuilder: (_) =>
              const Center(child: CupertinoActivityIndicator(radius: 16)),
          child: child ?? const SizedBox.shrink(),
        ),
      );
    }

    final materialLightScheme = ColorScheme.fromSeed(
      seedColor: Colors.blue,
      brightness: Brightness.light,
    );
    final materialDarkScheme = ColorScheme.fromSeed(
      seedColor: Colors.blue,
      brightness: Brightness.dark,
    );

    return MaterialApp.router(
      // 디버그에서 true (배너 표시)
      //debugShowCheckedModeBanner: kDebugMode,
      //화면 전체에 머티리얼 베이스라인 그리드(보통 8dp 격자)를 덮어 그려서 레이아웃 정렬을 확인하게 해주는 오버레이.
      //debugShowMaterialGrid: kDebugMode,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: materialLightScheme,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: materialDarkScheme,
      ),
      themeMode: themeMode,
      locale: locale,
      routerConfig: appRouter,
      scrollBehavior: const AppScrollBehavior(TargetPlatform.android),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (context, child) =>
          LoaderOverlay(child: child ?? const SizedBox.shrink()),
    );
  }
}
