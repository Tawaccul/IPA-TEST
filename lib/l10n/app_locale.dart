import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl_standalone.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<String> supportedLanguages = ['en', 'ru', 'ar', 'che'];

  static final Map<String, Map<String, String>> _localizedStrings = {
    'en': {
  "statistics": "Statistics",
  "notifications": "Notifications",
  "vibration": "Vibration",
  "changeLanguage": "Change Language",
  "about": "About",
  "logout": "Logout",
  "emptyList": "The list of learned words is empty",
  "chooseLang": "Choose language",
  "close": "Close",
  "yes": "Yes",
  "no": "No",
  "returnBack": "Are you sure you want to go back to the home screen? The level will be interrupted and you will have to start over",
  "spendsTime": "Total study time",
  "percentOfQuran": "Percentage of the entire Quran",
  "studiedWords": "Words learned",
  "congrag": "Congratulations!",
  "completedWords": "Words learned",
  "timeOfLevel": "Completed level in",
  "rus": "Russian",
  "en": "English",
  "che": "Chechen"
    },
    'ru': {
      'statistics': 'Статистика',
      'notifications': 'Уведомления',
      'vibration': 'Вибрация',
      'changeLanguage': 'Сменить язык',
      'about': 'О приложении',
      'logout': 'Выйти',
        "emptyList": "Список изученных слов пуст",
  "chooseLang": "Выберите язык",
  "close": "Закрыть",
  "yes": "Да",
  "no": "Нет",
  "returnBack": "Вы действительно хотите вернуться на главный экран? Уровень будет прерван, и придется начинать сначала",
  "spendsTime": "Общее время изучения",
  "percentOfQuran": "Процент от всего Корана",
  "studiedWords": "Изучено слов",
  "congrag": "Поздравляем!",
  "completedWords": "Изученные слова",
  "timeOfLevel": "Уровень пройден за",
  "rus": "Русский",
  "en": "Английский",
  "che": "Чеченский"
    },

    'che': {
  
    "statistics": "Статистик",
    "notifications": "ГӀара",
    "vibration": "Вибраци",
    "changeLanguage": "Мотт хийца",
    "about": "Приложених лаьцна",
    "logout": "Аравала",
  "emptyList": "Ӏамийначу дешнийн тептар даьсса ду",
  "chooseLang": "Мотт харжа",
  "close": "ДӀачӀагӀа",
  "yes": "ХӀаъ",
  "no": "ХӀан-хӀа",
  "returnBack": "Хьо тешна вуй хьайна хьалхара экран тӀе юхаверза лаьий? ТӀегӀа юкъахдоккхур ду, юха дӀадоло дезар ду",
  "spendsTime": "Дерриге а дешаран хан",
  "percentOfQuran": "Дерриге а Къуръанан процент",
  "studiedWords": "Ӏамийна дешнаш",
  "congrag": "Маршалла ду!",
  "completedWords": "Ӏамийна дешнаш",
  "timeOfLevel": "Чекхдаккха хан",
  "rus": "Оьрсийн мотт",
  "en": "Ингалсан мотт",
  "che": "Нохчийн мотт"
    },
  };
String get statistics => _localizedStrings[locale.languageCode]!['statistics']!;
  String get notifications => _localizedStrings[locale.languageCode]!['notifications']!;
  String get vibration => _localizedStrings[locale.languageCode]!['vibration']!;
  String get changeLanguage => _localizedStrings[locale.languageCode]!['changeLanguage']!;
  String get about => _localizedStrings[locale.languageCode]!['about']!;
  String get logout => _localizedStrings[locale.languageCode]!['logout']!;
  String get emptyList => _localizedStrings[locale.languageCode]!['emptyList']!;
  String get chooseLang => _localizedStrings[locale.languageCode]!['chooseLang']!;
  String get close => _localizedStrings[locale.languageCode]!['close']!;
  String get yes => _localizedStrings[locale.languageCode]!['yes']!;
  String get no => _localizedStrings[locale.languageCode]!['no']!;
  String get returnBack => _localizedStrings[locale.languageCode]!['returnBack']!;
  String get spendsTime => _localizedStrings[locale.languageCode]!['spendsTime']!;
  String get percentOfQuran => _localizedStrings[locale.languageCode]!['percentOfQuran']!;
  String get studiedWords => _localizedStrings[locale.languageCode]!['studiedWords']!;
  String get congrag => _localizedStrings[locale.languageCode]!['congrag']!;
  String get completedWords => _localizedStrings[locale.languageCode]!['completedWords']!;
  String get timeOfLevel => _localizedStrings[locale.languageCode]!['timeOfLevel']!;
  String get rus => _localizedStrings[locale.languageCode]!['rus']!;
  String get en => _localizedStrings[locale.languageCode]!['en']!;
  String get che => _localizedStrings[locale.languageCode]!['che']!;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return AppLocalizations.supportedLanguages.contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(LocalizationsDelegate<AppLocalizations> old) {
    return false;
  }
}
