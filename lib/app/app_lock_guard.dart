import 'package:bodysnap/app/app_constants.dart';
import 'package:bodysnap/app/app_password_provider.dart';
import 'package:bodysnap/app/app_router.dart';
import 'package:bodysnap/core/util/app_log.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AppLockGuard extends ConsumerStatefulWidget {
  const AppLockGuard({super.key, required this.child});
  final Widget child;

  @override
  ConsumerState<AppLockGuard> createState() => _AppLockGuardState();
}

class _AppLockGuardState extends ConsumerState<AppLockGuard>
    with WidgetsBindingObserver {
  bool _presenting = false; // 중복 호출 방지

  @override
  void initState() {
    super.initState();
    AppLog.d("AppLockGuard initState");
    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance.addPostFrameCallback((_) => _maybePresentLock());
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        AppLog.d("didChangeAppLifecycleState : resumed");
        ref.read(unlockedProvider.notifier).state = false;
        _maybePresentLock(); // ✅ 포그라운드 복귀시에만 검사
        break;
      case AppLifecycleState.paused:
        AppLog.d("didChangeAppLifecycleState : paused");
        ref.read(lastBackgroundAtProvider.notifier).state = DateTime.now();
        break;
      default:
        AppLog.d("didChangeAppLifecycleState : $state");
        break;
    }
  }

  Future<void> _maybePresentLock() async {
    AppLog.d("AppLock PresentLock mounted : ${mounted}");
    if (!mounted) return;

    AppLog.d("AppLock PresentLock _presenting : ${_presenting}");
    if (_presenting) return;

    final enabled = ref.read(passwordEnabledProvider);
    AppLog.d("AppLock PresentLock passwordEnable : ${enabled}");
    if (!enabled) return;

    final unlocked = ref.read(unlockedProvider);
    AppLog.d("AppLock PresentLock Unlock : ${unlocked}");
    if (unlocked) return;

    final now = DateTime.now();
    final lastUnlockAt = ref.read(lastBackgroundAtProvider);
    AppLog.d("AppLock Last Unlock : ${lastUnlockAt}");
    final elapsed = (lastUnlockAt == null)
        ? AppConstants.unlockDuration * 2
        : now.difference(lastUnlockAt);
    if (elapsed < AppConstants.unlockDuration) {
      ref.read(lastBackgroundAtProvider.notifier).state = now;
      return;
    }
    _presenting = true;

    try {
      final router = ref.read(appRouterProvider);

      // 현재 경로 파악
      final matches = router.routerDelegate.currentConfiguration;
      final currentPath = matches.last.matchedLocation;
      AppLog.d("AppLock is activating : $currentPath");

      if (currentPath != '/lock') {
        // 잠금 화면이 닫힐 때까지 대기 -> 중복 push 방지
        await router.push('/lock');
        AppLog.d("AppLock is release ");
      }

    } catch (e, st) {
      AppLog.e('AppLock push failed', error: e, stackTrace: st);
    } finally {
      if (mounted) _presenting = false;
      ref.read(lastBackgroundAtProvider.notifier).state = DateTime.now();
      AppLog.d("AppLock Closed _presenting : $_presenting");
    }
  }

  @override
  void dispose() {
    AppLog.d("AppLockGuard dispose");
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
