import 'package:bodysnap/core/platform/widgets/adaptive_alert_dialog.dart';
import 'package:bodysnap/core/platform/widgets/adaptive_list_tile.dart';
import 'package:bodysnap/core/util/app_log.dart';
import 'package:bodysnap/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart' show GoRouter;

///  - Setting Support
///   1) 백업 및 복구
///   2) 초기화
///   3) 문의하기
List<Widget> buildSettingsSupportTiles({required BuildContext context}) {
  final l10n = context.l10n;

  return <Widget>[
    // 1) 백업 및 복구
    AdaptiveListTile.nav(
      title: Text(l10n.settings_list_backup),
      onTap: () => GoRouter.of(context).push('/setting/backup'),
    ),

    // 2) 초기화
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
    // 3) 백업 및 복구
    AdaptiveListTile.nav(
      title: Text(l10n.settings_list_contact),
      //onTap: () => GoRouter.of(context).push('/setting/backup'),
    ),
  ];
}
