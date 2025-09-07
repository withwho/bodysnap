// lib/core/platform/widgets/adaptive_list_tile.dart
import 'package:bodysnap/core/platform/platform_style_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// 플랫폼에 맞는 ListTile을 그려주는 어댑터.
/// - iOS/macOS: CupertinoListTile
/// - 그 외: Material ListTile
class AdaptiveListTile extends ConsumerWidget {
  const AdaptiveListTile({
    super.key,
    this.leading,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.onLongPress,
    this.enabled = true,
    this.contentPadding,
    this.dense,
    this.minLeadingWidth,
    this.showChevron =
        false, // iOS에선 기본 chevron, Material에선 Icons.chevron_right
  });

  /// 내비게이션 행에서 자주 쓰는 프리셋(chevron 표시)
  const AdaptiveListTile.nav({
    super.key,
    this.leading,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.onLongPress,
    this.enabled = true,
    this.contentPadding,
    this.dense,
    this.minLeadingWidth,
  }) : showChevron = true;

  final Widget? leading;
  final Widget title;
  final Widget? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final VoidCallback?
  onLongPress; // Cupertino에선 무시됨(필요하면 GestureDetector로 감싸세요)
  final bool enabled;
  final EdgeInsetsGeometry? contentPadding;
  final bool? dense;
  final double? minLeadingWidth;
  final bool showChevron;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isCupertino = ref.watch(isCupertinoProvider);

    if (isCupertino) {
      // 참고: iOS 스타일로 묶으려면 상위에 CupertinoListSection을 두는 걸 권장
      return CupertinoListTile(
        leading: leading,
        title: title,
        subtitle: subtitle,
        additionalInfo: trailing,
        trailing: showChevron ? const CupertinoListTileChevron() : null,
        onTap: enabled ? onTap : null,
        // iOS 기본 패딩과 유사한 값(필요시 조정)
        padding: contentPadding,
        // CupertinoListTile에는 onLongPress가 없음
      );
    }

    return ListTile(
      leading: leading,
      title: title,
      subtitle: subtitle,
      trailing:
          trailing ?? (showChevron ? const Icon(Icons.chevron_right) : null),
      leadingAndTrailingTextStyle: Theme.of(context).textTheme.bodySmall,
      onTap: enabled ? onTap : null,
      onLongPress: enabled ? onLongPress : null,
      enabled: enabled,
      contentPadding: contentPadding,
      dense: dense,
      minLeadingWidth: minLeadingWidth,
    );
  }
}
