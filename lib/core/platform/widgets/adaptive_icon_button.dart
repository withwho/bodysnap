import 'package:bodysnap/core/platform/platform_style_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AdaptiveIconButton extends ConsumerWidget {
  const AdaptiveIconButton({
    super.key,
    required this.onPressed,
    required this.cupertinoIcon,
    required this.materialIcon,
    this.padding,
    this.cupertinoIconSize, // ← 추가: iOS 전용 아이콘 크기
    this.materialIconSize, // ← 추가: Material 전용 아이콘 크기(옵션)
    this.color,
  });

  final VoidCallback onPressed;
  final IconData cupertinoIcon;
  final IconData materialIcon;
  final EdgeInsetsGeometry? padding;
  final double? cupertinoIconSize;
  final double? materialIconSize;
  final Color? color;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isCupertino = ref.watch(isCupertinoProvider);

    if (isCupertino) {
      return CupertinoButton(
        padding: padding ?? EdgeInsets.zero,
        minimumSize: const Size(44, 44), // iOS 권장 터치 타깃
        onPressed: onPressed,
        child: Icon(cupertinoIcon, size: cupertinoIconSize ?? 28, color: color),
      );
    }

    return IconButton(
      icon: Icon(materialIcon, size: materialIconSize ?? 24, color: color),
      onPressed: onPressed,
      // 필요하면 constraints로 터치타깃 보장
      // constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
    );
  }
}
