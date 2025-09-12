import 'package:bodysnap/core/platform/adaptive_theme_extension.dart';
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SettingSectionHeader extends ConsumerWidget {
  const SettingSectionHeader({
    super.key,
    required this.label,
    this.top = 32,
    this.bottom = 16,
  });
  final String label;
  final double top;
  final double bottom;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final color = ref.acTextColorTertiaryLabel(context);
    final textStyle = ref.acTitleTextSmall(context).copyWith(color: color);
    return Padding(
      padding: EdgeInsets.fromLTRB(16, top, 16, bottom),
      child: Text(label, style: textStyle),
    );
  }
}
