import 'package:bodysnap/app/app_constants.dart';
import 'package:bodysnap/core/platform/widgets/adaptive_scaffold.dart';
import 'package:bodysnap/features/widgets/number_pad.dart';
import 'package:bodysnap/features/widgets/pin_boxes.dart';
import 'package:bodysnap/features/widgets/pin_controller.dart';
import 'package:bodysnap/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

class PasswordSettingPage extends HookWidget {
  const PasswordSettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final pinController = usePinController(AppConstants.passwordLength);
    useListenable(pinController);

    return AppScaffold(
      title: context.l10n.settings_list_password,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(height: 8),
              PinBoxes(
                message: context.l10n.settings_password_input_new,
                maxLength: AppConstants.passwordLength,
                pin: pinController.value,
              ),
              const SizedBox(height: 8),
              NumberPad(
                onDigit: (d) => pinController.tryAddDigit(d),
                onBackspace: () => pinController.tryBackspace(),
                onConfirm: () {
                  GoRouter.of(context).push(
                    '/setting/password/password_confirm',
                    extra: (
                      pin: pinController.value,
                      pinMaxLength: AppConstants.passwordLength,
                    ),
                  );
                },
                isConfirmEnabled:
                    pinController.length == AppConstants.passwordLength,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
