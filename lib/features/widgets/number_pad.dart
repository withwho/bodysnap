import 'dart:math' as math;

import 'package:bodysnap/core/platform/adaptive_theme_extension.dart';
import 'package:bodysnap/core/platform/widgets/adaptive_fill_button.dart';
import 'package:bodysnap/core/platform/widgets/adaptive_icon.dart';
import 'package:bodysnap/core/platform/widgets/adaptive_outline_button.dart';
import 'package:bodysnap/l10n/l10n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Widget keyButton({
      required Widget child,
      VoidCallback? onPressed,
      VoidCallback? onLongPress,
    }) => SizedBox(
      width: _keyBtnWidth,
      height: _keyBtnHeight,
      child: AdaptiveOutlinedButton(
        onPressed: onPressed,
        onLongPress: onLongPress,
        // minSize: const Size(_keyBtnWidth, _keyBtnHeight), // 제거
        child: child,
      ),
    );

    Widget digit(String n) => keyButton(
      child: Text(n, style: ref.acTitleTextLarge(context)),
      onPressed: () => onDigit(n),
    );

    // 빈칸은 버튼이 아닌 SizedBox로 처리 (접근성/포커스 노출 X)
    Widget placeholderBox() =>
        const SizedBox(width: _keyBtnWidth, height: _keyBtnHeight);

    final keyColor = ref.acTextColorPrimaryLabel(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        const keyAreaWidth = _keyBtnWidth * 3 + _spacing * 2;
        final maxW = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : keyAreaWidth;
        final perRow = math.max(
          1,
          ((maxW + _spacing) / (_keyBtnWidth + _spacing)).floor(),
        );

        final digits = List<Widget>.generate(9, (i) => digit('${i + 1}'));
        final keyBtns = <Widget>[
          ...digits,
          if (perRow <= 3) placeholderBox(),
          digit('0'),
          keyButton(
            child: AdaptiveIcon(
              materialIconData: Icons.backspace_outlined,
              cupertinoIconData: CupertinoIcons.delete_left,
              customColor: keyColor,
            ),
            onPressed: () {
              onBackspace();
            },
            onLongPress: onBackspaceLongPress,
          ),
        ];

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Wrap(
              alignment: WrapAlignment.center,
              spacing: _spacing,
              runSpacing: _spacing,
              children: keyBtns,
            ),
            const SizedBox(height: _spacing),
            SizedBox(
              width: keyAreaWidth,
              height: _confirmHeight,
              child: AdaptiveFilledButton(
                onPressed: isConfirmEnabled ? onConfirm : null,
                child: Text(context.l10n.common_confirm),
              ),
            ),
          ],
        );
      },
    );
  }
}
