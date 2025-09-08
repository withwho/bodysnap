import 'package:flutter/foundation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

PinController usePinController(int maxLen) {
  final controller = useMemoized(() => PinController(maxLen), [maxLen]);
  useEffect(() {
    return () => controller.dispose();
  }, [controller]);
  return controller;
}

class PinController extends ChangeNotifier {
  PinController(this.maxLen);

  final int maxLen;
  String _value = '';
  String get value => _value;
  int get length => _value.length;
  bool get isComplete => _value.length >= maxLen;

  bool tryAddDigit(String d) {
    if (_value.length >= maxLen) return false;
    if (d.length != 1) return false;
    final c = d.codeUnitAt(0);
    if (c < 0x30 || c > 0x39) return false;
    _value = '$_value$d';
    notifyListeners();
    return true;
  }

  bool paste(String s) {
    if (s.isEmpty || _value.length >= maxLen) return false;
    final buf = StringBuffer(_value);
    for (final r in s.runes) {
      if (buf.length >= maxLen) break;
      if (r >= 0x30 && r <= 0x39) buf.writeCharCode(r);
    }
    final next = buf.toString();
    if (next == _value) return false;
    _value = next;
    notifyListeners();
    return true;
  }

  bool tryBackspace() {
    if (_value.isEmpty) return false;
    _value = _value.substring(0, _value.length - 1);
    notifyListeners();
    return true;
  }

  void clear() {
    if (_value.isEmpty) return;
    _value = '';
    notifyListeners();
  }
}
