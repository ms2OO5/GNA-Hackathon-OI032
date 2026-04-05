// lib/main.dart

import 'package:flutter/material.dart';
import 'localization/localization.dart';
import 'splash_screen.dart';
import 'main_shell.dart';

void main() {
  runApp(const EcoBuddyApp());
}

class EcoBuddyApp extends StatefulWidget {
  const EcoBuddyApp({super.key});

  @override
  State<EcoBuddyApp> createState() => _EcoBuddyAppState();
}

class _EcoBuddyAppState extends State<EcoBuddyApp> {
  AppLanguage _language = AppLanguage.en;

  void _changeLanguage(AppLanguage lang) {
    setState(() => _language = lang);
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalization(_language);

    return MaterialApp(
      title: loc.t(LocKeys.appName),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF020910),
        fontFamily: 'SF Pro Display',
        useMaterial3: true,
      ),

      // IMPORTANT FIX: Builder se innerContext lo
      home: Builder(
        builder: (innerContext) {
          return SplashScreen(
            loc: loc,
            onFinished: () {
              Navigator.of(innerContext).pushReplacement(
                MaterialPageRoute(
                  builder: (_) => MainShell(
                    language: _language,
                    onLanguageChanged: _changeLanguage,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}