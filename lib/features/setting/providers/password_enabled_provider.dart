import 'package:bodysnap/app/app_providers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// password 존재 여부만 필요한 곳을 위한 파생 Provider
final passwordEnabledProvider = Provider<bool>((ref) {
  final asyncPassword = ref.watch(passwordProvider);
  return asyncPassword.maybeWhen(
    data: (p) => p.isNotEmpty,
    orElse: () => false,
  );
});

/// 실제 비밀번호 상태 (보안 저장소 사용)
final passwordProvider = AsyncNotifierProvider<PasswordNotifier, String>(
  PasswordNotifier.new,
);

class PasswordNotifier extends AsyncNotifier<String> {
  static const _key = 'password';

  @override
  Future<String> build() async {
    final storage = ref.read(secureStorageProvider);
    final value = await storage.read(key: _key);
    return value ?? '';
  }

  /// 저장: 저장 성공 시에만 state 업데이트
  Future<bool> setPassword(String password) async {
    final storage = ref.read(secureStorageProvider);
    try {
      await storage.write(key: _key, value: password);
      state = AsyncData(password);
      return true;
    } catch (_) {
      // 실패 시 state 변경 없음
      return false;
    }
  }

  /// 삭제: 삭제 성공 시에만 state 업데이트 (''로)
  Future<bool> clear() async {
    final storage = ref.read(secureStorageProvider);
    try {
      await storage.delete(key: _key);
      state = const AsyncData('');
      return true;
    } catch (_) {
      // 실패 시 state 변경 없음
      return false;
    }
  }
}
