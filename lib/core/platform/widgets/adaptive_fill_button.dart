import 'package:bodysnap/core/platform/platform_style_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AdaptiveFilledButton extends ConsumerWidget {
  const AdaptiveFilledButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.fullWidth = false,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final bool fullWidth;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isCupertino = ref.watch(isCupertinoProvider);

    final button = isCupertino
        ? CupertinoButton.filled(
            onPressed: onPressed,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: child,
          )
        : FilledButton(
            onPressed: onPressed,
            style: fullWidth
                ? FilledButton.styleFrom(minimumSize: const Size.fromHeight(44))
                : null,
            child: child,
          );

    return fullWidth ? SizedBox(width: double.infinity, child: button) : button;
  }
}
