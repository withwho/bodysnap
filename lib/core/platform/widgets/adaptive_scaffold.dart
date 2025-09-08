import 'package:bodysnap/core/platform/platform_style_provider.dart';
import 'package:bodysnap/core/platform/widgets/adaptive_back_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AppScaffold extends ConsumerWidget {
  const AppScaffold({
    super.key,
    this.title, // ← nullable
    required this.body,
    this.trailing,
    this.centerTitle, // Material에서만 강제 중앙정렬하고 싶을 때
    this.cupertinoBackgroundColor, // ✅ 추가
    this.cupertinoNavBarBackgroundColor, // ✅ 추가
  });

  final String? title;
  final Widget body;
  final Widget? trailing;
  final bool? centerTitle;
  final Color? cupertinoBackgroundColor;
  final Color? cupertinoNavBarBackgroundColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isCupertino = ref.watch(isCupertinoProvider);
    final canPop =
        GoRouter.of(context).canPop() || Navigator.of(context).canPop();
    final Widget? titleWidget = (title != null ? Text(title!) : null);

    if (isCupertino) {
      return CupertinoPageScaffold(
        backgroundColor: cupertinoBackgroundColor,
        navigationBar: CupertinoNavigationBar(
          automaticallyImplyLeading: false,
          padding: const EdgeInsetsDirectional.only(start: 0, end: 16),
          leading: (canPop) ? const AdaptiveBackButton() : null,
          middle: titleWidget, // ← 제목이 없으면 null로 비워둔다
          trailing: trailing,
          backgroundColor: cupertinoNavBarBackgroundColor,
        ),
        child: SafeArea(top: false, bottom: true, child: body),
      );
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: (canPop) ? const AdaptiveBackButton() : null,
        title: titleWidget, // ← null이면 가운데 비워둠
        centerTitle: centerTitle, // 필요 시 강제 중앙정렬
        actions: [if (trailing != null) trailing!],
      ),
      body: body,
    );
  }
}
