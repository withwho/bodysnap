import 'package:bodysnap/core/platform/platform_style_provider.dart';
import 'package:bodysnap/core/platform/widgets/adaptive_back_button.dart';
import 'package:bodysnap/core/util/app_log.dart';
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
    this.cupertinoBackgroundColor,
    this.cupertinoNavBarBackgroundColor,
    this.disableBack = false,
  });

  final String? title;
  final Widget body;
  final Widget? trailing;
  final bool? centerTitle;
  final Color? cupertinoBackgroundColor;
  final Color? cupertinoNavBarBackgroundColor;
  final bool disableBack;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isCupertino = ref.watch(isCupertinoProvider);

    final currentUri = GoRouterState.of(context).uri; // e.g. '/', '/setting'
    AppLog.d('AppScaffold current path : ${currentUri.path}');

    final isRoot = currentUri.path == '/';

    // 실제 네비게이터가 pop 가능한지 (go_router의 canPop 대신)
    final navCanPop = Navigator.maybeOf(context)?.canPop() ?? false;
    AppLog.d('AppScaffold navCanPop : $navCanPop');
    final routerCanPop = GoRouter.of(context).canPop();
    AppLog.d('AppScaffold routerCanPop : $routerCanPop');

    // 표시 규칙: 루트면 숨김. 루트가 아니면 보이되, pop이 안 되면 '대체 동작'으로 처리(아래 2) 참고)
    final showBack = !disableBack && !isRoot && navCanPop;

    final Widget? titleWidget = (title != null ? Text(title!) : null);

    Widget scaffold;
    if (isCupertino) {
      scaffold = CupertinoPageScaffold(
        backgroundColor: cupertinoBackgroundColor,
        navigationBar: CupertinoNavigationBar(
          automaticallyImplyLeading: false,
          padding: const EdgeInsetsDirectional.only(start: 0, end: 16),
          leading: showBack ? const AdaptiveBackButton() : null,
          middle: titleWidget, // ← 제목이 없으면 null로 비워둔다
          trailing: trailing,
          backgroundColor: cupertinoNavBarBackgroundColor,
        ),
        child: SafeArea(top: true, bottom: true, child: body),
      );
    } else {
      scaffold = Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: showBack ? const AdaptiveBackButton() : null,
          title: titleWidget, // ← null이면 가운데 비워둠
          centerTitle: centerTitle, // 필요 시 강제 중앙정렬
          actions: [if (trailing != null) trailing!],
        ),
        body: body,
      );
    }
    return PopScope(
      canPop: !disableBack,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          // disableBack = true → pop 차단됨
          AppLog.d("Disable Back!");
        }
      },
      child: scaffold,
    );
  }
}
