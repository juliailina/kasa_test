import 'package:flutter/material.dart';

import 'data/expense_repository.dart';
import 'notifiers/app_notifier.dart';
import 'notifiers/theme_notifier.dart';
import 'screens/expense_list_screen.dart';

void main() {
  runApp(const KasaApp());
}

class KasaApp extends StatefulWidget {
  const KasaApp({super.key});

  @override
  State<KasaApp> createState() => _KasaAppState();
}

class _KasaAppState extends State<KasaApp> {
  final AppNotifier notifier = AppNotifier(ExpenseRepository());
  final ThemeNotifier themeNotifier = ThemeNotifier();

  @override
  void dispose() {
    notifier.dispose();
    themeNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: themeNotifier,
      builder: (context, _) {
        return MaterialApp(
          title: 'Kasa',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
          ),
          darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.teal,
              brightness: Brightness.dark,
            ),
          ),
          themeMode:
              themeNotifier.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          home: ExpenseListScreen(
            notifier: notifier,
            themeNotifier: themeNotifier,
          ),
        );
      },
    );
  }
}
