import 'package:bodysnap/app/app_providers.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'platform_style.dart';

const _kPlatformStyleKey = 'platform_style';

final platformStyleControllerProvider =
    NotifierProvider<PlatformStyleController, PlatformStyle>(
      PlatformStyleController.new,
    );

class PlatformStyleController extends Notifier<PlatformStyle> {
  SharedPreferences? _sp;

  @override
  PlatformStyle build() {
    _sp = ref.watch(sharedPrefsProvider);
    final stored = _sp?.getInt(_kPlatformStyleKey) ?? 0;
    return platformStyleFromInt(stored); // 기본값: system(0)
  }

  Future<void> set(PlatformStyle next) async {
    state = next; // 즉시 반영
    final sp = _sp;
    if (sp != null) {
      await sp.setInt(_kPlatformStyleKey, platformStyleToInt(next));
    }
  }
}

/// 실제 위젯 트리에서 사용할 해석된 플랫폼 (변경 없음)
final resolvedPlatformProvider = Provider<TargetPlatform>((ref) {
  final style = ref.watch(platformStyleControllerProvider);
  return resolveTargetPlatform(style);
});

final isCupertinoProvider = Provider<bool>((ref) {
  return ref.watch(resolvedPlatformProvider) == TargetPlatform.iOS;
});
