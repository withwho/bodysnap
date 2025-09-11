import 'package:bodysnap/app/app_providers.dart';
import 'package:bodysnap/core/platform/widgets/adaptive_bottom_sheets.dart';
import 'package:bodysnap/core/platform/widgets/adaptive_list_tile.dart'
    show AdaptiveListTile;
import 'package:bodysnap/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart' show GoRouter;
import 'package:hooks_riverpod/hooks_riverpod.dart' show WidgetRef;

///  - Setting Application
///   1) 버전() : 업데이트
///   2) 구독
///   3) 테마 ( system, light, dark)
///   4) 언어 ( ko, en)
List<Widget> buildSettingsApplicationTiles({
  required BuildContext context,
  required WidgetRef ref,
}) {
  final l10n = context.l10n;

  // 버전
  final versionText = ref.watch(
    packageInfoProvider.select((p) => '${p.version} (${p.buildNumber})'),
  );
  // 테마, system / light / dark
  final themeMode = ref.watch(themeModeProvider);

  // 언어, null(시스템) / ko / en
  final locale = ref.watch(localeProvider);

  String themeLabel() {
    switch (themeMode) {
      case ThemeMode.system:
        return l10n.settings_theme_system;
      case ThemeMode.light:
        return l10n.settings_theme_light;
      case ThemeMode.dark:
        return l10n.settings_theme_dark;
    }
  }

  String localeLabel() {
    if (locale == null) return l10n.settings_language_system;
    switch (locale.languageCode) {
      case 'ko':
        return l10n.settings_language_kr;
      case 'en':
        return l10n.settings_language_en;
      default:
        return locale.languageCode;
    }
  }

  return <Widget>[
    // 버젼
    AdaptiveListTile(
      title: Text(l10n.settings_list_version),
      subtitle: Text(versionText),
      trailing: const Text('Update'),
    ),

    // 구독
    AdaptiveListTile.nav(
      title: Text(l10n.settings_list_subscribe),
      onTap: () => GoRouter.of(context).push('/setting/premium'),
    ),

    // 테마
    AdaptiveListTile.nav(
      title: Text(l10n.settings_list_theme),
      trailing: Text(themeLabel()),
      onTap: () async {
        final picked = await showAdaptiveBottomSheet<ThemeMode>(
          context: context,
          title: l10n.settings_list_theme,
          options: [
            (
              label: l10n.settings_theme_system,
              value: ThemeMode.system,
              selected: themeMode == ThemeMode.system,
              destructive: false,
            ),
            (
              label: l10n.settings_theme_light,
              value: ThemeMode.light,
              selected: themeMode == ThemeMode.light,
              destructive: false,
            ),
            (
              label: l10n.settings_theme_dark,
              value: ThemeMode.dark,
              selected: themeMode == ThemeMode.dark,
              destructive: false,
            ),
          ],
        );

        if (picked != null) {
          await ref.read(themeModeProvider.notifier).set(picked);
        }
      },
    ),

    //언어
    AdaptiveListTile.nav(
      title: Text(l10n.settings_list_language),
      trailing: Text(localeLabel()),
      onTap: () async {
        final picked = await showAdaptiveBottomSheet<Locale?>(
          context: context,
          title: l10n.settings_list_language,
          options: [
            (
              label: l10n.settings_language_system,
              value: null,
              selected: locale == null,
              destructive: false,
            ),
            (
              label: l10n.settings_language_kr,
              value: const Locale('ko'),
              selected: locale?.languageCode == 'ko',
              destructive: false,
            ),
            (
              label: l10n.settings_language_en,
              value: const Locale('en'),
              selected: locale?.languageCode == 'en',
              destructive: false,
            ),
          ],
        );
        if (picked case final Locale? v) {
          await ref.read(localeProvider.notifier).set(v);
        }
      },
    ),
  ];
}
