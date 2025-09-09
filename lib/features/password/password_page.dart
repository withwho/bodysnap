import 'package:bodysnap/app/app_constants.dart';
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

class PasswordPage extends HookConsumerWidget {
  const PasswordPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pinController = usePinController(AppConstants.passwordLength);
    useListenable(pinController);
    final isError = useState(false);

    final isConfirmEnabled =
        pinController.length == AppConstants.passwordLength;

    return AppScaffold(
      disableBack: true,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(height: 8),
              PinBoxes(
                message: context.l10n.settings_password_input_msg,
                maxLength: AppConstants.passwordLength,
                pin: pinController.value,
                isError: isError.value,
              ),
              const SizedBox(height: 8),
              NumberPad(
                onDigit: (d) {
                  if (isError.value) {
                    isError.value = false;
                  }
                  pinController.tryAddDigit(d);
                },
                onBackspace: () {
                  if (isError.value) {
                    isError.value = false;
                  }
                  pinController.tryBackspace();
                },
                onConfirm: () async {
                  final ok = await ref
                      .read(passwordProvider.notifier)
                      .verify(pinController.value);

                  if (!context.mounted) return;

                  if (ok) {
                    ref.read(unlockedProvider.notifier).state = true;
                    GoRouter.of(context).pop();
                  } else {
                    pinController.clear();
                    isError.value = true;
                  }
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
