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
    final l10n = context.l10n;
    final allowPop = useState(false); // PopScope canPop 토글
    final pinController = usePinController(_pinMaxLength);
    useListenable(pinController);
    
    return PopScope<bool>(
      // 기본 pop 막아둠, true로 하고 이전화면에서 null 처리를 하거나 true로 반환되는 값만 처리해도 된다.
      canPop: allowPop.value,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          // 시스템/제스처 뒤로가기 → 명시적으로 false 반환하고 닫기
          allowPop.value = true; // 프로그램적 pop 허용
          context.pop(false); // false 반환
        }
      },
      child: AppScaffold(
        title: l10n.settings_list_password,
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
                    final value = pinController.value;
                    if (value.length == _pinMaxLength) {
                      allowPop.value = true;
                      context.pop(true);
                    }
                  },
                  isConfirmEnabled: pinController.length == _pinMaxLength,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
