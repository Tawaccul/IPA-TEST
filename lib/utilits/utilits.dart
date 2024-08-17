import 'package:quranapp/models/models.dart';

class TranslationUtils {
  static String getTranslationForSentence(Sentence sentence, String language) {
    switch (language) {
      case 'ar':
        return sentence.ar;
      case 'che':
        return sentence.che;
      case 'ru':
        return sentence.ru;
      case 'en':
      default:
        return sentence.en;
    }
  }

  static String getTranslation(Word word, String language) {
    switch (language) {
      case 'ar':
        return word.ar;
      case 'che':
        return word.che;
      case 'ru':
        return word.ru;
      case 'en':
      default:
        return word.en;
    }
  }
}
