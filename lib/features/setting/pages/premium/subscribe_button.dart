import 'package:bodysnap/app/app_constants.dart' show UIConstants;
import 'package:bodysnap/core/platform/adaptive_theme_extension.dart';
import 'package:bodysnap/core/platform/platform_style_provider.dart';
import 'package:flutter/cupertino.dart' show CupertinoButton;
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SubscribeButton extends ConsumerWidget {
  const SubscribeButton({
    super.key,
    required this.title,
    required this.price,
    required this.onTap,
  });

  final String title;
  final String price;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const borderRadius = UIConstants.borderRadius12;

    const padding = EdgeInsets.symmetric(horizontal: 16, vertical: 14);

    const linearGradient = LinearGradient(
      colors: [Color(0xFF5A60F8), Color(0xFF8A63F5)],
    );

    const boxDecoration = BoxDecoration(
      borderRadius: borderRadius,
      gradient: linearGradient,
    );

    final body = ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: UIConstants.maxButtonWidth, minHeight: 48),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              overflow: TextOverflow.ellipsis,
              softWrap: false,
              style: ref
                  .acTitleTextMedium(context)
                  .copyWith(color: Colors.white),
            ),
          ),
          Text(
            price,
            style: ref.acTitleTextSmall(context).copyWith(color: Colors.grey),
          ),
        ],
      ),
    );

    final isCupertino = ref.watch(isCupertinoProvider);

    return isCupertino
        ? ClipRRect(
            borderRadius: borderRadius,
            child: DecoratedBox(
              decoration: boxDecoration,
              child: CupertinoButton(
                onPressed: onTap,
                padding: padding,
                child: body,
              ),
            ),
          )
        : Material(
            color: Colors.transparent,
            child: Ink(
              // InkWell 의 배경부분을 Ink 에 작성해야 리플효과가 발생한다. 다른 위젯은 안될가능성 높다고함.
              decoration: boxDecoration,
              child: InkWell(
                customBorder: const RoundedRectangleBorder(
                  borderRadius: borderRadius,
                ),
                overlayColor: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.pressed)) {
                    return const Color(0xFFFFFFFF).withValues(alpha: 0.18);
                  }
                  if (states.contains(WidgetState.hovered) ||
                      states.contains(WidgetState.focused)) {
                    return const Color(0xFFFFFFFF).withValues(alpha: 0.06);
                  }
                  return null;
                }),
                onTap: onTap,
                child: Padding(padding: padding, child: body),
              ),
            ),
          );
  }
}
