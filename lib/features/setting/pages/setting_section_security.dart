import 'package:bodysnap/app/app_password_provider.dart'
    show passwordEnabledProvider, passwordProvider;
import 'package:bodysnap/core/platform/widgets/adaptive_list_tile.dart';
import 'package:bodysnap/core/platform/widgets/adaptive_switch_tile.dart';
import 'package:bodysnap/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart' show GoRouter;
import 'package:hooks_riverpod/hooks_riverpod.dart' show WidgetRef;

///  - Setting Security
///   1) 비밀번호 설정
///   2) 개인정보 처리방침
List<Widget> buildSettingsSecurityTiles({
  required BuildContext context,
  required WidgetRef ref,
}) {
  final l10n = context.l10n;
  // 비밀번호 상태
  final isPasswordEnabled = ref.watch(passwordEnabledProvider);

  return <Widget>[
    // 1) 비밀번호 설정
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

    // 2) 개인정보 처리방침
    AdaptiveListTile.nav(
      title: Text(l10n.settings_list_privacy),
      //onTap: () => GoRouter.of(context).push('/setting/backup'),
    ),
  ];
}
