import 'package:bodysnap/core/platform/widgets/adaptive_scaffold.dart';
import 'package:bodysnap/features/widgets/number_pad.dart';
import 'package:bodysnap/features/widgets/pin_controller.dart';
import 'package:bodysnap/features/setting/providers/password_enabled_provider.dart';
import 'package:bodysnap/features/widgets/pin_boxes.dart';
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
                maxLength: pinMaxLength,
                value: pinController.value,
                isEqual: isEqual,
              ),
              const SizedBox(height: 8),
              NumberPad(
                onDigit: (d) => pinController.tryAddDigit(d),
                onBackspace: () => pinController.tryBackspace(),
                onConfirm: () async {
                  context.loaderOverlay.show();
                  await Future.delayed(const Duration(seconds: 5));
                  final ok = await ref
                      .read(passwordProvider.notifier)
                      .setPassword(value);

                  if (!context.mounted) return;
                  context.loaderOverlay.hide();

                  if (!ok) return;
                  context.go('/setting');
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
