import 'package:bodysnap/core/platform/platform_style.dart' show PlatformStyle;
import 'package:bodysnap/core/platform/platform_style_provider.dart'
    show platformStyleControllerProvider;
import 'package:bodysnap/core/platform/widgets/adaptive_bottom_sheets.dart';
import 'package:bodysnap/core/platform/widgets/adaptive_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart' show WidgetRef;

///  - Setting Debug
///   1) 플랫폼 설정
List<Widget> buildSettingsDebugTiles({
  required BuildContext context,
  required WidgetRef ref,
}) {
  // 플랫폼 ( system / cupertino / material)
  final platformStyle = ref.watch(platformStyleControllerProvider);

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

  return <Widget>[
    // 1) 비밀번호 설정
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
          await ref.read(platformStyleControllerProvider.notifier).set(picked);
        }
      },
    ),
  ];
}
