import 'package:bodysnap/app/app.dart';
import 'package:bodysnap/app/app_lock_guard.dart';
import 'package:bodysnap/app/app_password_provider.dart';
import 'package:bodysnap/core/util/app_log.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AppBootStrap extends HookConsumerWidget {
  const AppBootStrap({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(passwordProvider); // AsyncValue<String?>
    AppLog.d(
      'AppBootStrap passwordProvider state: ${state.hasValue
          ? "data"
          : state.hasError
          ? "error"
          : "loading"}',
    );

    // 스플래시 제거: 로딩 → (data|error) 전환 시 1회만
    final removedSplash = useRef(false);
    useEffect(() {
      if (!removedSplash.value && (state.hasValue || state.hasError)) {
        FlutterNativeSplash.remove();
        removedSplash.value = true;
        AppLog.d('Splash removed');
      }
      return null;
    }, [state.hasValue, state.hasError]);

    return state.when(
      data: (password) {
        final isLocked = (password.isNotEmpty);
        return isLocked ? const AppLockGuard(child: App()) : const App();
      },
      error: (_, __) => const App(), // 에러 시 잠금 없이 진입
      loading: () => const SizedBox.shrink(), // 네이티브 스플래시 유지
    );
  }
}
