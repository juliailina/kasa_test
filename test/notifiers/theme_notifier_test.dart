import 'package:flutter_test/flutter_test.dart';
import 'package:kasa/notifiers/theme_notifier.dart';

void main() {
  test('starts in light mode', () {
    final notifier = ThemeNotifier();

    expect(notifier.isDarkMode, isFalse);
  });

  test('toggleDarkMode flips the flag and notifies listeners', () {
    final notifier = ThemeNotifier();
    var notified = false;
    notifier.addListener(() => notified = true);

    notifier.toggleDarkMode();

    expect(notifier.isDarkMode, isTrue);
    expect(notified, isTrue);

    notifier.toggleDarkMode();
    expect(notifier.isDarkMode, isFalse);
  });
}
