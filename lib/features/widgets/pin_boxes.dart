import 'package:bodysnap/core/platform/adaptive_theme_extension.dart';
import 'package:bodysnap/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PinBoxes extends ConsumerWidget {
  const PinBoxes({
    super.key,
    required this.message,
    required this.maxLength,
    required this.pin,
    this.isError = false,
  });
  final int maxLength;
  final String pin;
  final String message;
  final bool isError;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //final currentLen = pin.length;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 48, // 한 줄 또는 두 줄을 다 수용할 수 있는 고정 높이
          child: Center(
            child: Text(
              isError ? context.l10n.settings_password_input_error : message,
              style: ref.acTitleTextMedium(context),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(maxLength, (i) {
            final filled = i < pin.length;
            final isCurrent = i == pin.length && pin.length < maxLength;

            final borderColor = isError
                ? ref.acErrorContainer(context)
                : (isCurrent ? ref.acPrimary(context) : ref.acOutline(context));

            final bgColor = ref.acSurfaceSecondary(context);
            final dotColor = ref.acTextColorPrimaryLabel(context);

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
                          color: dotColor,
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
