import 'package:bodysnap/app/app_providers.dart';
import 'package:bodysnap/core/platform/platform_style.dart';
import 'package:bodysnap/core/platform/platform_style_provider.dart';
import 'package:bodysnap/core/platform/widgets/adaptive_list_tile.dart';
import 'package:bodysnap/core/platform/widgets/adaptive_scaffold.dart';
import 'package:bodysnap/core/platform/widgets/adaptive_sheets.dart';
import 'package:bodysnap/core/platform/widgets/adaptive_switch_tile.dart';
import 'package:bodysnap/core/util/app_log.dart';
import 'package:bodysnap/features/setting/providers/password_enabled_provider.dart';
import 'package:bodysnap/l10n/l10n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// 설정 페이지
/// - 상단 AppBar: 좌측 뒤로가기, 가운데 타이틀
/// - 본문: 리스트 형태 항목들
///   1) 버전 (오른쪽에 버전 표시)
///   2) 비밀번호 설정 (화면 이동)
///   3) 백업 및 복구 (화면 이동)
///   4) 초기화 (경고 확인 다이얼로그)
///   5) 구독 (화면 이동)
///   디버깅용
///   6) 플랫폼 변경 ( cupertino / material )
///   7) 테마변경 ( light / dart )
///   8) 언어변경 ( ko / en )
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
    ref.listen<AsyncValue<String>>(
      passwordProvider,
      (prev, next) {
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
      },
      // 처음 빌드 시 현재 상태도 한 번 보고 싶다면:
      // fireImmediately: true,
    );

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
            context.push('/setting/password');
          } else {
            await notifier.clear();
          }
        },
      ),

      // 3) 백업 및 복구
      AdaptiveListTile.nav(
        title: Text(l10n.settings_list_backup),
        onTap: () => context.push('/setting/backup'),
      ),

      // 4) 초기화
      AdaptiveListTile.nav(
        title: Text(l10n.settings_list_reset),
        // onTap: () => context.push('/setting/subscription'),
      ),

      // 5) 구독
      AdaptiveListTile.nav(
        title: Text(l10n.settings_list_subscribe),
        // onTap: () => context.push('/setting/subscription'),
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
            final picked = await showAdaptiveSheet<PlatformStyle>(
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
            final picked = await showAdaptiveSheet<ThemeMode>(
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
            final picked = await showAdaptiveSheet<Locale?>(
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

    //CupertinoScrollbar:
    //Flutter는 기본적으로 ListView에 스크롤바가 자동으로 붙지 않음.
    //iOS 네이티브 앱은 스크롤 시 오른쪽에 얇은 인디케이터가 잠깐 나타나는데, Flutter에선 그 역할을 **CupertinoScrollbar**가 해줘.
    //Material 쪽은 같은 역할을 **Scrollbar**가 하고, 모양/애니메이션이 머티리얼 스타일임.
    final Widget body = isCupertino
        ? ListView(
            children: [
              // iOS: 섹션형 리스트(구분선 X)
              CupertinoListSection.insetGrouped(children: tiles),
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

    final groupedBg = CupertinoColors.systemGroupedBackground.resolveFrom(
      context,
    );

    return AppScaffold(
      title: context.l10n.settings_page_title,
      body: body,
      cupertinoBackgroundColor: groupedBg,
      cupertinoNavBarBackgroundColor: groupedBg,
    );
  }
}
