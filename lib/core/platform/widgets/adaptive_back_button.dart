import 'package:bodysnap/core/platform/platform_style_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AdaptiveBackButton extends ConsumerWidget {
  const AdaptiveBackButton({super.key});

  void _handleBack(BuildContext context) {
    final nav = Navigator.maybeOf(context);
    final canPop = nav?.canPop() ?? false;
    if (canPop) {
      // 실제 스택이 있을 때만 pop
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isCupertino = ref.watch(isCupertinoProvider);

    // 현재 라우트가 모달(fullscreenDialog)인지
    final isModal = ModalRoute.of(context)?.fullscreenDialog ?? false;

    if (isCupertino) {
      if (isModal) {
        return CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => _handleBack(context),
          child: const Icon(CupertinoIcons.xmark),
        );
      }
      return CupertinoNavigationBarBackButton(
        onPressed: () => _handleBack(context),
      );
    }

    if (isModal) {
      return CloseButton(onPressed: () => _handleBack(context));
    }
    // 머티리얼 기본 Back 버튼
    return BackButton(onPressed: () => _handleBack(context));
  }
}
