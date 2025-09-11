import 'package:bodysnap/app/app_password_provider.dart';
import 'package:bodysnap/app/app_providers.dart';
import 'package:bodysnap/core/platform/platform_style.dart';
import 'package:bodysnap/core/platform/platform_style_provider.dart';
import 'package:bodysnap/core/platform/widgets/adaptive_alert_dialog.dart';
import 'package:bodysnap/core/platform/widgets/adaptive_bottom_sheets.dart';
import 'package:bodysnap/core/platform/widgets/adaptive_list_tile.dart';
import 'package:bodysnap/core/platform/widgets/adaptive_scaffold.dart';
import 'package:bodysnap/core/platform/widgets/adaptive_switch_tile.dart';
import 'package:bodysnap/core/util/app_log.dart';
import 'package:bodysnap/l10n/l10n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// 설정 페이지
///  - Application
///   1) 버전() : 업데이트
///   2) 구독
///   3) 테마 ( system, light, dark)
///   4) 언어 ( ko, en)
/// 
///  - security 
///   1) 비밀번호 설정
///   2) 개인정보보호 방침
/// 
///  - support
///   1) 백업 및 복구
///   2) 초기화
///   3) 문의하기
/// 
///  - debug
///   1) 플랫폼 변경

class SettingPage extends ConsumerWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;

    // 현재 플랫폼/테마/언어 상태
    final isCupertino = ref.watch(isCupertinoProvider);

    // system / cupertino / material
    final platformStyle = ref.watch(platformStyleControllerProvider);

    // system / light / dark
    final themeMode = ref.watch(themeModeProvider);

    // null(시스템) / ko / en
    final locale = ref.watch(localeProvider);

    // 버전 텍스트
    final versionText = ref.watch(
      packageInfoProvider.select((p) => '${p.version} (${p.buildNumber})'),
    );

    // 비밀번호 상태
    final isPasswordEnabled = ref.watch(passwordEnabledProvider);

    if (kDebugMode) {
      ref.listen<AsyncValue<String>>(passwordProvider, (prev, next) {
        next.when(
          data: (value) {
            final old = prev?.valueOrNull;
            if (old != value) {
              AppLog.d(
                '[passwordProvider] old="$old" -> new="$value" '
                '(len=${value.length})',
              );
            }
          },
          loading: () {
            AppLog.d('[passwordProvider] loading…');
          },
          error: (e, st) {
            AppLog.e('[passwordProvider] error: $e');
          },
        );
      });
    }

    // 공통으로 쓰일 항목들(타일만 구성)
    final tiles = <Widget>[
      // 1) 버전
      AdaptiveListTile(
        title: Text(l10n.settings_list_version),
        trailing: Text(versionText),
      ),

      // 2) 비밀번호 설정
      AdaptiveSwitchTile(
        title: l10n.settings_list_password,
        value: isPasswordEnabled,
        onChanged: (next) async {
          final notifier = ref.read(passwordProvider.notifier);
          if (next) {
            GoRouter.of(context).push('/setting/password');
          } else {
            await notifier.clear();
          }
        },
      ),

      // 3) 백업 및 복구
      AdaptiveListTile.nav(
        title: Text(l10n.settings_list_backup),
        onTap: () => GoRouter.of(context).push('/setting/backup'),
      ),

      // 4) 초기화
      AdaptiveListTile.nav(
        title: Text(l10n.settings_list_reset),
        onTap: () async {
          await showAdaptiveAlertDialog(
            isDestructiveAction: true,
            context: context,
            title: context.l10n.settings_reset_title,
            message: context.l10n.settings_reset_message,
            confirmText: context.l10n.settings_reset_confirm,
            confirmPress: () => AppLog.d('Dialog Press Confirm'),
            cancelPress: () => AppLog.d('Dialog Press Cancel'),
          );

          AppLog.d('dismiss dialog');
        },
      ),

      // 5) 구독
      AdaptiveListTile.nav(
        title: Text(l10n.settings_list_subscribe),
        onTap: () => GoRouter.of(context).push('/setting/premium'),
      ),
    ];

    /// 디버그 전용 타일
    List<Widget> buildDebugTiles() {
      String platformLabel() {
        switch (platformStyle) {
          case PlatformStyle.system:
            return 'System';
          case PlatformStyle.cupertino:
            return 'Cupertino';
          case PlatformStyle.material:
            return 'Material';
        }
      }

      String themeLabel() {
        switch (themeMode) {
          case ThemeMode.system:
            return 'System';
          case ThemeMode.light:
            return 'Light';
          case ThemeMode.dark:
            return 'Dark';
        }
      }

      String localeLabel() {
        if (locale == null) return 'System';
        switch (locale.languageCode) {
          case 'ko':
            return 'Korean';
          case 'en':
            return 'English';
          default:
            return locale.languageCode;
        }
      }

      return [
        AdaptiveListTile.nav(
          title: const Text('Platform'),
          trailing: Text(platformLabel()),
          onTap: () async {
            final picked = await showAdaptiveBottomSheet<PlatformStyle>(
              context: context,
              title: 'Platform',
              options: [
                (
                  label: 'System',
                  value: PlatformStyle.system,
                  selected: platformStyle == PlatformStyle.system,
                  destructive: false,
                ),
                (
                  label: 'Cupertino',
                  value: PlatformStyle.cupertino,
                  selected: platformStyle == PlatformStyle.cupertino,
                  destructive: false,
                ),
                (
                  label: 'Material',
                  value: PlatformStyle.material,
                  selected: platformStyle == PlatformStyle.material,
                  destructive: false,
                ),
              ],
            );
            if (picked != null) {
              await ref
                  .read(platformStyleControllerProvider.notifier)
                  .set(picked);
            }
          },
        ),
        AdaptiveListTile.nav(
          title: const Text('Theme'),
          trailing: Text(themeLabel()),
          onTap: () async {
            final picked = await showAdaptiveBottomSheet<ThemeMode>(
              context: context,
              title: 'Theme',
              options: [
                (
                  label: 'System',
                  value: ThemeMode.system,
                  selected: themeMode == ThemeMode.system,
                  destructive: false,
                ),
                (
                  label: 'Light',
                  value: ThemeMode.light,
                  selected: themeMode == ThemeMode.light,
                  destructive: false,
                ),
                (
                  label: 'Dark',
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
        AdaptiveListTile.nav(
          title: const Text('Language'),
          trailing: Text(localeLabel()),
          onTap: () async {
            final picked = await showAdaptiveBottomSheet<Locale?>(
              context: context,
              title: 'Language',
              options: [
                (
                  label: 'System',
                  value: null,
                  selected: locale == null,
                  destructive: false,
                ),
                (
                  label: 'Korean',
                  value: const Locale('ko'),
                  selected: locale?.languageCode == 'ko',
                  destructive: false,
                ),
                (
                  label: 'English',
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

    final Widget body = isCupertino
        ? ListView(
            children: [
              // iOS: 섹션형 리스트(구분선 X)
              CupertinoListSection.insetGrouped(
                hasLeading: false,
                children: tiles,
              ),
              if (kDebugMode)
                CupertinoListSection.insetGrouped(
                  header: const Text('Debug Section'),
                  children: buildDebugTiles(),
                ),
            ],
          )
        : ListView.builder(
            // Material: 구분선 자동 삽입
            itemBuilder: (_, i) {
              // Material에선 단일 리스트로 이어붙이기
              final materialTiles = [
                ...tiles,
                if (kDebugMode) ...buildDebugTiles(),
              ];
              return materialTiles[i];
            },
            //separatorBuilder: (_, __) => const Divider(height: 0),
            itemCount:
                tiles.length + (kDebugMode ? buildDebugTiles().length : 0),
          );

    return AppScaffold(
      title: context.l10n.settings_page_title,
      body: body,
      cupertinoBackgroundColor: CupertinoColors.systemGroupedBackground,
    );
  }
}
