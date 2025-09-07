import 'package:bodysnap/core/platform/adaptive_theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PinBoxes extends ConsumerWidget {
  const PinBoxes({super.key, required this.maxLength, required this.value});
  final int maxLength;
  final String value;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int currentLen = value.length;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '4자리 숫자 비밀번호를 입력하세요',
          style: ref.acTitleMedium(context),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(maxLength, (i) {
            final filled = i < currentLen;
            final isCurrent = i == currentLen && currentLen < maxLength;

            final borderColor = isCurrent
                ? ref.acPrimary(context)
                : ref.acOutlineVariant(context);

            final bgColor = isCurrent
                ? ref.acSurfaceContainer(context)
                : ref.acSurfaceContainerHighest(context);

            return AnimatedContainer(
              key: ValueKey(i),
              width: 56,
              height: 56,
              duration: const Duration(milliseconds: 120),
              curve: Curves.easeOut,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(width: 2, color: borderColor),
                color: bgColor,
              ),
              alignment: Alignment.center,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 120),
                switchInCurve: Curves.easeOut,
                switchOutCurve: Curves.easeIn,
                transitionBuilder: (child, anim) =>
                    ScaleTransition(scale: anim, child: child),
                child: filled
                    ? Text(
                        value[i],
                        key: ValueKey('digit_$i'),
                        style: ref
                            .acHeadlineSmall(context)
                            .copyWith(fontWeight: FontWeight.w600),
                      )
                    : const SizedBox.shrink(key: ValueKey('empty')),
              ),
            );
          }),
        ),
      ],
    );
  }
}
