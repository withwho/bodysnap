import 'dart:math' as math;

import 'package:bodysnap/core/platform/adaptive_theme_extension.dart';
import 'package:bodysnap/core/platform/widgets/adaptive_fill_button.dart';
import 'package:bodysnap/core/platform/widgets/adaptive_icon.dart';
import 'package:bodysnap/core/platform/widgets/adaptive_outline_button.dart';
import 'package:bodysnap/l10n/l10n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class NumberPad extends ConsumerWidget {
  const NumberPad({
    super.key,
    required this.onDigit,
    required this.onBackspace,
    required this.onConfirm,
    required this.isConfirmEnabled,
    this.onBackspaceLongPress, // 길게 누르기 옵션
  });

  final void Function(String) onDigit;
  final VoidCallback onBackspace;
  final VoidCallback onConfirm;
  final bool isConfirmEnabled;

  final VoidCallback? onBackspaceLongPress;

  static const double _keyBtnWidth = 88.0;
  static const double _keyBtnHeight = 64.0;
  static const double _spacing = 16.0;
  static const double _confirmHeight = 52.0;
  static const double _confirmWidth = 300.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Widget keyButton({
      required Widget child,
      VoidCallback? onPressed,
      VoidCallback? onLongPress,
    }) {
      final button = AdaptiveOutlinedButton(
        onPressed: onPressed,
        onLongPress: onLongPress,
        minSize: const Size(_keyBtnWidth, _keyBtnHeight),
        child: child,
      );

      return SizedBox(
        width: _keyBtnWidth,
        height: _keyBtnHeight,
        child: button,
      );
    }

    Widget digit(String n) => keyButton(
      child: Text(n, style: ref.acTitleLarge(context)),
      onPressed: () {
        HapticFeedback.selectionClick();
        onDigit(n);
      },
    );

    // 빈칸은 버튼이 아닌 SizedBox로 처리 (접근성/포커스 노출 X)
    Widget placeholderBox() =>
        const SizedBox(width: _keyBtnWidth, height: _keyBtnHeight);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            // 한 줄에 들어갈 수 있는 버튼 개수(간격 포함)를 계산
            // 공식: floor((가용폭 + spacing) / (btnW + spacing))
            final perRow = math.max(
              1,
              ((constraints.maxWidth + _spacing) / (_keyBtnWidth + _spacing))
                  .floor(),
            );

            final children = <Widget>[
              ...['1', '2', '3', '4', '5', '6', '7', '8', '9'].map(digit),

              // 3열까지는 빈칸 삽입, 4열 이상이면 제거
              if (perRow <= 3) placeholderBox(),

              // 0
              digit('0'),

              // backspace
              keyButton(
                child: const AdaptiveIcon(
                  materialIconData: Icons.backspace_outlined,
                  cupertinoIconData: CupertinoIcons.delete_left,
                  tone: AdaptiveIconTone.onSurface,
                ),
                onPressed: () => onBackspace(),
                onLongPress: onBackspaceLongPress,
              ),
            ];

            return Wrap(
              alignment: WrapAlignment.center,
              spacing: _spacing,
              runSpacing: _spacing,
              children: children,
            );
          },
        ),
        const SizedBox(height: _spacing),
        SizedBox(
          width: _confirmWidth,
          height: _confirmHeight,
          child: AdaptiveFilledButton(
            onPressed: isConfirmEnabled ? () => onConfirm() : null,
            child: Text(
              context.l10n.common_confirm,
              style: TextStyle(fontSize: ref.acTitleMedium(context).fontSize),
              
            ),
          ),
        ),
      ],
    );
  }
}
