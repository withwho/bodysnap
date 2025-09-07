import 'package:flutter/foundation.dart';

/// 앱에서 사용할 3가지 스타일 모드
enum PlatformStyle { system, cupertino, material }

int platformStyleToInt(PlatformStyle v) => switch (v) {
  PlatformStyle.system => 0,
  PlatformStyle.cupertino => 1,
  PlatformStyle.material => 2,
};

PlatformStyle platformStyleFromInt(int raw) => switch (raw) {
  1 => PlatformStyle.cupertino,
  2 => PlatformStyle.material,
  _ => PlatformStyle.system,
};

/// system 모드일 때 실제 런타임 TargetPlatform을 해석
TargetPlatform resolveTargetPlatform(PlatformStyle style) {
  if (style == PlatformStyle.system) return defaultTargetPlatform;
  return style == PlatformStyle.cupertino ? TargetPlatform.iOS : TargetPlatform.android;
}