import 'package:bodysnap/core/platform/platform_style_provider.dart';
import 'package:bodysnap/core/platform/widgets/adaptive_scaffold.dart';
import 'package:bodysnap/features/setting/pages/setting_section_appliction.dart';
import 'package:bodysnap/features/setting/pages/setting_section_debug.dart';
import 'package:bodysnap/features/setting/pages/setting_section_header.dart';
import 'package:bodysnap/features/setting/pages/setting_section_security.dart';
import 'package:bodysnap/features/setting/pages/setting_section_support.dart';
import 'package:bodysnap/l10n/l10n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
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

    final Widget body = isCupertino
        ? ListView(
            children: [
              CupertinoListSection.insetGrouped(
                header: SettingSectionHeader(
                  label: l10n.settings_section_application,
                  top: 0,
                  bottom: 0,
                ),
                children: buildSettingsApplicationTiles(
                  context: context,
                  ref: ref,
                ),
              ),
              CupertinoListSection.insetGrouped(
                header: SettingSectionHeader(
                  label: l10n.settings_section_security,
                  top: 0,
                  bottom: 0,
                ),
                children: buildSettingsSecurityTiles(
                  context: context,
                  ref: ref,
                ),
              ),
              CupertinoListSection.insetGrouped(
                header: SettingSectionHeader(
                  label: l10n.settings_section_support,
                  top: 0,
                  bottom: 0,
                ),
                children: buildSettingsSupportTiles(context: context),
              ),
              if (kDebugMode)
                CupertinoListSection.insetGrouped(
                  header: const SettingSectionHeader(
                    label: 'debug',
                    top: 0,
                    bottom: 0,
                  ),
                  children: buildSettingsDebugTiles(context: context, ref: ref),
                ),
            ],
          )
        : ListView(
            padding: const EdgeInsets.all(8),
            children: [
              SettingSectionHeader(
                label: l10n.settings_section_application,
                top: 0,
                bottom: 8,
              ),
              ...buildSettingsApplicationTiles(context: context, ref: ref),
              SettingSectionHeader(label: l10n.settings_section_security),
              ...buildSettingsSecurityTiles(context: context, ref: ref),
              SettingSectionHeader(label: l10n.settings_section_support),
              ...buildSettingsSupportTiles(context: context),
              if (kDebugMode) const SettingSectionHeader(label: 'debug'),
              if (kDebugMode)
                ...buildSettingsDebugTiles(context: context, ref: ref),
            ],
          );

    return AppScaffold(
      title: context.l10n.settings_page_title,
      body: body,
      cupertinoBackgroundColor: CupertinoColors.systemGroupedBackground,
    );
  }
}
