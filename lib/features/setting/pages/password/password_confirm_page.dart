import 'package:bodysnap/app/app_password_provider.dart';
import 'package:bodysnap/core/platform/widgets/adaptive_scaffold.dart';
import 'package:bodysnap/features/widgets/number_pad.dart';
import 'package:bodysnap/features/widgets/pin_boxes.dart';
import 'package:bodysnap/features/widgets/pin_controller.dart';
import 'package:bodysnap/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loader_overlay/loader_overlay.dart';

class PasswordConfirmPage extends HookConsumerWidget {
  const PasswordConfirmPage({
    super.key,
    required this.pin,
    required this.pinMaxLength,
  });

  final String pin;
  final int pinMaxLength;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final pinController = usePinController(pinMaxLength);
    useListenable(pinController);

    final value = pinController.value;
    final isEqual = pin.startsWith(value);
    final isConfirmEnabled = value.length == pinMaxLength && isEqual;

    return AppScaffold(
      title: l10n.settings_list_password,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(height: 8),
              PinBoxes(
                message: context.l10n.settings_password_input_repeat,
                maxLength: pinMaxLength,
                pin: value,
                isError: !isEqual,
              ),
              const SizedBox(height: 8),
              NumberPad(
                onDigit: (d) => pinController.tryAddDigit(d),
                onBackspace: () => pinController.tryBackspace(),
                onConfirm: () async {
                  context.loaderOverlay.show();
                  //await Future.delayed(const Duration(seconds: 1));
                  final ok = await ref
                      .read(passwordProvider.notifier)
                      .setPassword(value);

                  if (!context.mounted) return;
                  context.loaderOverlay.hide();

                  if (!ok) return;

                  // ✅ 방금 사용자가 비밀번호를 두 번 입력/확정했으므로 세션 언락 처리
                  ref.read(unlockedProvider.notifier).state = true;

                  // ✅ 바로 직후 가드가 뜨지 않도록 최근 활동 시각 갱신
                  ref.read(lastBackgroundAtProvider.notifier).state =
                      DateTime.now();
                  GoRouter.of(context).go("/setting");
                },
                isConfirmEnabled: isConfirmEnabled,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
