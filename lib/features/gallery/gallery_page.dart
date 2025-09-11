import 'package:bodysnap/core/platform/widgets/adaptive_icon_button.dart';
import 'package:bodysnap/core/platform/widgets/adaptive_scaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class GalleryPage extends ConsumerWidget {
  const GalleryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppScaffold(
      trailing: AdaptiveIconButton(
        cupertinoIcon: CupertinoIcons.gear_solid,
        materialIcon: Icons.settings,
        onPressed: () => GoRouter.of(context).push('/setting'),
        padding: EdgeInsets.zero,
      ),
      body: const Center(child: Text('body')),
    );
  }
}
