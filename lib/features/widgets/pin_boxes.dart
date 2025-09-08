import 'package:bodysnap/core/platform/adaptive_theme_extension.dart';
import 'package:bodysnap/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PinBoxes extends ConsumerWidget {
  const PinBoxes({
    super.key,
    required this.maxLength,
    required this.value,
    this.isEqual,
  });
  final int maxLength;
  final String value;
  final bool? isEqual;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int currentLen = value.length;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          switch (isEqual) {
            null => context.l10n.settings_password_input_msg,
            true => context.l10n.settings_password_input_msg2,
            false => context.l10n.settings_password_input_msg3,
          },
          style: ref.acTitleMedium(context),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(maxLength, (i) {
            final filled = i < currentLen;
            final isCurrent = i == currentLen && currentLen < maxLength;
            final ok = isEqual != false; // null/true -> ok, false -> fail

            final borderColor = ok
                ? (isCurrent
                      ? ref.acPrimary(context)
                      : ref.acOutlineVariant(context))
                : ref.acError(context);

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
                    ? AnimatedContainer(
                        key: ValueKey('dot_$i'),
                        duration: const Duration(milliseconds: 120),
                        curve: Curves.easeOut,
                        width: isCurrent ? 12 : 10,
                        height: isCurrent ? 12 : 10,
                        decoration: BoxDecoration(
                          color: ref.acPrimary(context),
                          shape: BoxShape.circle,
                        ),
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
