import 'package:bodysnap/core/platform/widgets/adaptive_scaffold.dart';
import 'package:bodysnap/core/widgets/number_pad.dart';
import 'package:bodysnap/features/setting/controllers/pin_controller.dart';
import 'package:bodysnap/features/setting/widgets/pin_boxes.dart';
import 'package:bodysnap/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

class PasswordSettingPage extends HookWidget {
  const PasswordSettingPage({super.key});
  static const _pinMaxLength = 4;

  @override
  Widget build(BuildContext context) {
    final pinController = usePinController(_pinMaxLength);
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
              PinBoxes(maxLength: _pinMaxLength, value: pinController.value),
              const SizedBox(height: 8),
              NumberPad(
                onDigit: (d) => pinController.tryAddDigit(d),
                onBackspace: () => pinController.tryBackspace(),
                onConfirm: () {
                  context.push(
                    '/setting/password/password_confirm',
                    extra: (
                      pin: pinController.value,
                      pinMaxLength: _pinMaxLength,
                    ),
                  );
                },
                isConfirmEnabled: pinController.length == _pinMaxLength,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
