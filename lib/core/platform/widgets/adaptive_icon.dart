import 'package:bodysnap/core/platform/platform_style_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AdaptiveIcon extends ConsumerWidget {
  const AdaptiveIcon({
    super.key,
    required this.cupertinoIconData,
    required this.materialIconData,
    this.size,
    this.customColor,
    this.lightColor, // 라이트 모드 전용 커스텀 색
    this.darkColor, // 다크 모드 전용 커스텀 색
  });

  final IconData cupertinoIconData;
  final IconData materialIconData;

  /// 명시 크기(없으면 IconTheme로부터 상속)
  final double? size;

  /// 라이트/다크에 서로 다른 색을 직접 주고 싶을 때
  final Color? lightColor;
  final Color? darkColor;

  final Color? customColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isCupertino = ref.watch(isCupertinoProvider);
    final iconData = isCupertino ? cupertinoIconData : materialIconData;
    final color = _resolveColor(context, isCupertino);

    return Icon(
      iconData,
      size: size,
      color: color, // null이면 IconTheme/기본 테마에 맡김
    );
  }

  Color? _resolveColor(BuildContext context, bool isCupertino) {
    if (lightColor != null || darkColor != null) {
      if (isCupertino) {
        return CupertinoDynamicColor.withBrightness(
          color: lightColor!, // Light
          darkColor: darkColor!, // Dark
        );
      }
      return Theme.of(context).brightness == Brightness.light
          ? lightColor
          : darkColor;
    }
    return customColor;
  }
}
