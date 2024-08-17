import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider with ChangeNotifier {
  String _language = 'en';
  String get language => _language;

  Locale _locale = const Locale('en');
  Locale get locale => _locale;

  LanguageProvider() {
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _language = prefs.getString('language') ?? 'en';
    _locale = Locale(_language);
    notifyListeners();
  }

  Future<void> setLanguage(String language) async {
    _language = language;
    _locale = Locale(language);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', language);
    notifyListeners();
  }
}
