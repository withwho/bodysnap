import 'package:flutter/widgets.dart' show BorderRadius, Radius;

class AppConstants {
  static const int passwordLength = 4;
  static const Duration unlockDuration = Duration(seconds: 30); // 유예 시간
}

class UIConstants {
  static const double maxButtonWidth = 300;

  static const BorderRadius borderRadius12 = BorderRadius.all(
    Radius.circular(12),
  );

  static const BorderRadius borderRadius16 = BorderRadius.all(
    Radius.circular(16),
  );
}
