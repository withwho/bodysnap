import 'package:bodysnap/core/platform/platform_style_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AdaptiveOutlinedButton extends ConsumerWidget {
  const AdaptiveOutlinedButton({
    super.key,
    required this.child,
    this.onPressed,
    this.onLongPress,
    this.width, // <- 있으면 외부에서 고정, 없으면 내용크기 + minSize
    this.height,
    this.radius = 12,
    this.minSize = const Size(48, 48), // 접근성 최소 터치 타겟
  });

  final Widget child;
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final double? width;
  final double? height;
  final double radius;
  final Size minSize;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isCupertino = ref.watch(isCupertinoProvider);

    Widget buildMaterial() {
      final btn = OutlinedButton(
        onPressed: onPressed,
        onLongPress: onLongPress,
        style: OutlinedButton.styleFrom(
          minimumSize: minSize, // 내부 고정 사이즈 제거 → 최소 크기만 보장
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
          // 고정 사이즈를 외부에서 줄 때 불필요한 여백 줄이려면:
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: child,
      );
      if (width != null || height != null) {
        return SizedBox(width: width, height: height, child: btn);
      }
      return btn;
    }

    Widget buildCupertino() {
      final borderColor = CupertinoDynamicColor.resolve(
        CupertinoColors.opaqueSeparator,
        context,
      );
      final disabledColor = CupertinoDynamicColor.resolve(
        CupertinoColors.separator,
        context,
      );
      final bg = CupertinoDynamicColor.resolve(
        CupertinoColors.systemBackground,
        context,
      );
      final bool hasLong = onLongPress != null;
      final bool hasTap = onPressed != null;
      final bool isDisabled = !hasLong && !hasTap;

      Widget content = DecoratedBox(
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(color: isDisabled ? disabledColor : borderColor),
        ),
        child: Center(child: child),
      );

      // 최소 터치 타겟 보장
      content = ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: minSize.width,
          minHeight: minSize.height,
        ),
        child: content,
      );

      Widget button = CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: onPressed,
        child: content,
      );

      // ✅ long-press 전달 안정화
      if (hasLong) {
        button = GestureDetector(
          behavior: HitTestBehavior.opaque, // ← 추가
          onLongPress: onLongPress,
          child: button,
        );
      }

      if (width != null || height != null) {
        button = SizedBox(width: width, height: height, child: button);
      }
      if (onLongPress != null) {
        button = GestureDetector(onLongPress: onLongPress, child: button);
      }
      return button;
    }

    return isCupertino ? buildCupertino() : buildMaterial();
  }
}
