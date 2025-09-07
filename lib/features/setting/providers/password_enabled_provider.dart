import 'package:bodysnap/app/app_providers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

const _kKeyPasswordEnabled = 'password_enabled';

final passwordEnabledProvider =
    AsyncNotifierProvider<PasswordEnabledNotifier, bool>(
      PasswordEnabledNotifier.new,
    );

class PasswordEnabledNotifier extends AsyncNotifier<bool> {
  @override
  Future<bool> build() async {
    final prefs = ref.read(sharedPrefsProvider);
    return prefs.getBool(_kKeyPasswordEnabled) ?? false;
  }

  Future<void> enable() => _set(true);
  Future<void> disable() => _set(false);

  Future<void> _set(bool value) async {
    final prefs = ref.read(sharedPrefsProvider);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await prefs.setBool(_kKeyPasswordEnabled, value);
      return value;
    });
  }
}
