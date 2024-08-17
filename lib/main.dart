import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';

import 'l10n/app_locale.dart';
import 'providers/timer_provider.dart';
import 'auth/pages/login.dart';
import 'pages/home_page.dart';
import 'screens/data_provider.dart';
import 'screens/lang_provider.dart';
import 'screens/profile_screen/providers.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Ensure Firebase is initialized

  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  runApp(
    MyApp(isFirstLaunch: isFirstLaunch, isLoggedIn: isLoggedIn),
  );
}

class MyApp extends StatelessWidget {
  final bool isFirstLaunch;
  final bool isLoggedIn;

  MyApp({required this.isFirstLaunch, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ChangeNotifierProvider(create: (context) => DataProvider()),
        ChangeNotifierProvider(create: (_) => TimerProvider()),
      ],
      child: Consumer<LanguageProvider>(
        builder: (context, languageProvider, child) {
          return MaterialApp(
            title: 'Quran App',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: isLoggedIn ? SplashScreen() : LoginPage(),
            locale: Locale(languageProvider.language),
            supportedLocales: [
              Locale('en', ''),
              Locale('ru', ''),
              Locale('che', ''),
            ],
            localizationsDelegates: [
              AppLocalizations.delegate, // Custom localization delegate
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            localeResolutionCallback: (locale, supportedLocales) {
              // Check if the selected locale is supported
              if (locale != null) {
                for (var supportedLocale in supportedLocales) {
                  if (supportedLocale.languageCode == locale.languageCode) {
                    return supportedLocale;
                  }
                }
              }
              // Fallback to English if not supported
              return supportedLocales.first;
            },
            builder: (context, child) {
              return GlobalLoaderOverlay(
                child: child!,
              );
            },
          );
        },
      ),
    );
  }
}
