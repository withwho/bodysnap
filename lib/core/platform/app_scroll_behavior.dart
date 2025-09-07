import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppScrollBehavior extends ScrollBehavior {
  const AppScrollBehavior(this.platform);
  final TargetPlatform platform;

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    switch (platform) {
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return const BouncingScrollPhysics();
      default:
        return const ClampingScrollPhysics();
    }
  }

  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    switch (platform) {
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        // iOS 느낌: 오버스크롤 글로우 없이
        return child;
      default:
        // Android 느낌: 스트레칭(또는 기본 글로우)
        return StretchingOverscrollIndicator(
          axisDirection: details.direction,
          child: child,
        );
    }
  }
}
