import 'package:flutter/foundation.dart';

/// Holds the app's theme preference, kept separate from [AppNotifier] so
/// that theme-dependent widgets don't rebuild on unrelated state changes
/// (e.g. every keystroke while drafting an expense).
class ThemeNotifier extends ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  void toggleDarkMode() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
}
