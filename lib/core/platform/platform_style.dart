import 'package:flutter/foundation.dart';

enum PlatformStyle { system, cupertino, material }

extension PlatformStyleX on PlatformStyle {
  // int <-> enum
  int get asInt => switch (this) {
    PlatformStyle.system => 0,
    PlatformStyle.cupertino => 1,
    PlatformStyle.material => 2,
  };

  static PlatformStyle fromInt(int raw) => switch (raw) {
    1 => PlatformStyle.cupertino,
    2 => PlatformStyle.material,
    _ => PlatformStyle.system,
  };

  // system일 때는 런타임 플랫폼을 그대로 사용
  TargetPlatform get resolvedTarget => switch (this) {
    PlatformStyle.system => defaultTargetPlatform,
    PlatformStyle.cupertino => TargetPlatform.iOS,
    PlatformStyle.material => TargetPlatform.android,
  };
}
