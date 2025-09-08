import 'package:bodysnap/core/platform/platform_style_provider.dart';
import 'package:bodysnap/features/gallery/gallery_page.dart';
import 'package:bodysnap/features/setting/pages/backup_page.dart';
import 'package:bodysnap/features/setting/pages/password_confirm_page.dart';
import 'package:bodysnap/features/setting/pages/password_setting_page.dart';
import 'package:bodysnap/features/setting/pages/setting_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// bool fullscreenDialog = false, // 이 페이지를 전체화면 모달(dialog)처럼 취급.
// iOS(CupertinoPageRoute): 오른쪽→왼쪽이 아닌 아래→위로 뜨는 전환(모달 프레젠트) + CupertinoNavigationBar가 자동으로 Close(닫기) 스타일을 암시(leading 버튼이 뒤로가기 대신 닫기 느낌).
// Android(MaterialPageRoute): 전환 자체는 큰 차이 없지만 “풀스크린 대화상자”로 취급되므로, 디자인/행동을 모달처럼 구성하는 데 의미가 있음(닫기 아이콘을 쓰는 등).

// bool maintainState = true
// 뜻: 이 페이지가 다른 페이지에 가려졌을 때도 상태를 유지할지 여부.
// 효과:
// true(기본): 가려져도 위젯 트리/상태 유지 → 뒤로 왔을 때 스크롤 위치/입력값 그대로.
// false: 가려지면 트리에서 제거(메모리 절약) → 다시 보여질 때 처음부터 재빌드(폼/스크롤 초기화됨).
// 주의: false로 두면 Hero, 포커스, 컨트롤러 상태 등 유지 안 됨. 정말 무거운 화면에서 메모리를 아끼고 싶을 때만 선택적으로 사용하세요.

Page<T> adaptivePage<T>(
  BuildContext context,
  GoRouterState state,
  Widget child, {
  bool fullscreenDialog = false,
  bool maintainState = true,
}) {
  // Riverpod 컨테이너에서 읽기 (listen 안 함)
  final container = ProviderScope.containerOf(context, listen: false);
  final isCupertino = container.read(isCupertinoProvider);
  return isCupertino
      ? CupertinoPage<T>(
          key: state.pageKey,
          child: child,
          fullscreenDialog: fullscreenDialog,
          maintainState: maintainState,
        )
      : MaterialPage<T>(
          key: state.pageKey,
          child: child,
          fullscreenDialog: fullscreenDialog,
          maintainState: maintainState,
        );
}

final appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      name: 'gallery',
      pageBuilder: (context, state) =>
          adaptivePage(context, state, const GalleryPage()),
      routes: [
        GoRoute(
          path: 'setting',
          name: 'setting',
          pageBuilder: (context, state) =>
              adaptivePage(context, state, const SettingPage()),
          routes: [
            GoRoute(
              path: 'password', // 실제 URL: /setting/password
              name: 'passwordSetting',
              pageBuilder: (context, state) =>
                  adaptivePage(context, state, const PasswordSettingPage()),
              routes: [
                GoRoute(
                  path:
                      'password_confirm', // 실제 URL: /setting/password/password_confirm
                  name: 'passwordConfirm',
                  pageBuilder: (context, state) {
                    final (:pin, :pinMaxLength) =
                        state.extra as ({String pin, int pinMaxLength});
                    return adaptivePage(
                      context,
                      state,
                      PasswordConfirmPage(pin: pin, pinMaxLength: pinMaxLength),
                    );
                  },
                ),
              ],
            ),
            GoRoute(
              path: 'backup', // 실제 URL: /setting/backup
              name: 'backup',
              pageBuilder: (context, state) =>
                  adaptivePage(context, state, const BackupPage()),
            ),
          ],
        ),
      ],
    ),
  ],
);
