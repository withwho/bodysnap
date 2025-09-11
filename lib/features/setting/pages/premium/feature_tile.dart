import 'package:bodysnap/core/platform/adaptive_theme_extension.dart';
import 'package:bodysnap/core/platform/widgets/adaptive_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FeatureTile extends ConsumerWidget {
  const FeatureTile({super.key, required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final iconColor = Colors.tealAccent.shade400.withValues(alpha: .9);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // check icon
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: AdaptiveIcon(
            cupertinoIconData: CupertinoIcons.check_mark_circled_solid,
            materialIconData: Icons.check_circle,
            size: 22,
            lightColor: iconColor,
            darkColor: iconColor,
          ),
        ),
        const SizedBox(width: 12),
        // text
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: ref.acTitleTextMedium(context)),
              const SizedBox(height: 4),
              Text(subtitle, style: ref.acTextSmall(context)),
            ],
          ),
        ),
      ],
    );
  }
}
