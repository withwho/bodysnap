import 'package:bodysnap/core/platform/platform_style_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

enum AdaptiveIconTone { primary, secondary, error, onSurface, onSurfaceVariant }

class AdaptiveIcon extends ConsumerWidget {
  const AdaptiveIcon({
    super.key,
    required this.cupertinoIconData,
    required this.materialIconData,
    this.size,
    this.tone,
    this.lightColor, // 라이트 모드 전용 커스텀 색
    this.darkColor, // 다크 모드 전용 커스텀 색
    this.semanticLabel,
  }) : assert(
         !(tone != null && (lightColor != null || darkColor != null)),
         'tone과 light/dark 커스텀 색은 동시에 쓰지 않는 것을 권장합니다. '
         '커스텀 색이 tone을 덮어씁니다.',
       );

  final IconData cupertinoIconData;
  final IconData materialIconData;

  /// 명시 크기(없으면 IconTheme로부터 상속)
  final double? size;

  /// 플랫폼별 기본 팔레트에서 가져오고 싶을 때 사용
  final AdaptiveIconTone? tone;

  /// 라이트/다크에 서로 다른 색을 직접 주고 싶을 때
  final Color? lightColor;
  final Color? darkColor;

  final String? semanticLabel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isCupertino = ref.watch(isCupertinoProvider);
    final iconData = isCupertino ? cupertinoIconData : materialIconData;

    // 1) 라이트/다크 전용 커스텀 색이 들어오면 그걸 우선 사용
    final color = _resolveColor(context, isCupertino);

    return Icon(
      iconData,
      size: size,
      color: color, // null이면 IconTheme/기본 테마에 맡김
      semanticLabel: semanticLabel,
    );
  }

  Color? _resolveColor(BuildContext context, bool isCupertino) {
    // 커스텀 라이트/다크 색 우선
    if (lightColor != null || darkColor != null) {
      final brightness = _currentBrightness(context, isCupertino);
      return brightness == Brightness.dark
          ? (darkColor ?? lightColor)
          : (lightColor ?? darkColor);
    }

    // 톤 기반 자동 색상
    if (tone != null) {
      return isCupertino
          ? _cupertinoColorFromTone(context, tone!)
          : _materialColorFromTone(context, tone!);
    }

    // 아무것도 지정 안 함 => IconTheme/테마에 맡김
    return null;
  }

  Brightness _currentBrightness(BuildContext context, bool isCupertino) {
    if (isCupertino) {
      // CupertinoTheme가 null brightness일 수 있어 fallback
      return CupertinoTheme.of(context).brightness ??
          MediaQuery.platformBrightnessOf(context);
    } else {
      return Theme.of(context).brightness;
    }
  }

  // Material 팔레트 매핑 (Material 3 ColorScheme 가정)
  Color _materialColorFromTone(BuildContext context, AdaptiveIconTone tone) {
    final cs = Theme.of(context).colorScheme;
    switch (tone) {
      case AdaptiveIconTone.primary:
        return cs.primary;
      case AdaptiveIconTone.secondary:
        return cs.secondary;
      case AdaptiveIconTone.error:
        return cs.error;
      case AdaptiveIconTone.onSurface:
        return cs.onSurface;
      case AdaptiveIconTone.onSurfaceVariant:
        return cs.onSurfaceVariant;
    }
  }

  // Cupertino 팔레트 매핑 (DynamicColor는 resolveFrom에 맡김)
  Color _cupertinoColorFromTone(BuildContext context, AdaptiveIconTone tone) {
    switch (tone) {
      case AdaptiveIconTone.primary:
        // CupertinoTheme.primaryColor는 테마 기반으로 다크/라이트 대응
        return CupertinoTheme.of(context).primaryColor;
      case AdaptiveIconTone.secondary:
        // 아이콘 대비가 너무 약하면 label로 교체 고려
        return CupertinoColors.secondaryLabel.resolveFrom(context);
      case AdaptiveIconTone.error:
        return CupertinoColors.systemRed.resolveFrom(context);
      case AdaptiveIconTone.onSurface:
        return CupertinoColors.label.resolveFrom(context);
      case AdaptiveIconTone.onSurfaceVariant:
        return CupertinoColors.tertiaryLabel.resolveFrom(context);
    }
  }
}
