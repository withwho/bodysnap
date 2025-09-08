import 'package:bodysnap/app/app_providers.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'platform_style.dart';

const _kPlatformStyleKey = 'platform_style';

final platformStyleControllerProvider =
    NotifierProvider<PlatformStyleController, PlatformStyle>(
      PlatformStyleController.new,
    );

class PlatformStyleController extends Notifier<PlatformStyle> {
  @override
  PlatformStyle build() {
    final sp = ref.watch(sharedPrefsProvider);
    final stored = sp.getInt(_kPlatformStyleKey) ?? 0;
    return PlatformStyleX.fromInt(stored);
  }

  Future<void> set(PlatformStyle next) async {
    state = next; // 즉시 반영
    final sp = ref.read(sharedPrefsProvider);
    await sp.setInt(_kPlatformStyleKey, next.asInt);
  }
}

/// 실제 위젯 트리에서 사용할 해석된 플랫폼
final resolvedPlatformProvider = Provider<TargetPlatform>((ref) {
  return ref.watch(platformStyleControllerProvider).resolvedTarget;
});

final isCupertinoProvider = Provider<bool>((ref) {
  return ref.watch(resolvedPlatformProvider) == TargetPlatform.iOS;
});
