import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:quranapp/consts/colors.dart';
import 'package:quranapp/l10n/app_locale.dart';
import 'package:quranapp/models/models.dart';
import 'package:quranapp/screens/lang_provider.dart';
import 'dart:async';

class DictionaryScreen extends StatefulWidget {
  final List<Word> studiedWords;

  const DictionaryScreen({Key? key, required this.studiedWords}) : super(key: key);

  @override
  State<DictionaryScreen> createState() => _DictionaryScreenState();
}

class _DictionaryScreenState extends State<DictionaryScreen> {
  List<Word> _foundWords = [];
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _foundWords = widget.studiedWords;
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _runFilter(String enteredKeyword) {
    List<Word> results = [];
    if (enteredKeyword.isEmpty) {
      results = widget.studiedWords;
    } else {
      final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
      String selectedLanguage = languageProvider.language;
      
      results = widget.studiedWords.where((word) {
        String translation = _getTranslation(word, selectedLanguage);
        return translation.toLowerCase().contains(enteredKeyword.toLowerCase());
      }).toList();
    }
    setState(() {
      _foundWords = results;
    });
  }

  String _getTranslation(Word word, String language) {
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

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      _runFilter(_searchController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final String language = languageProvider.language;
    final appLocalizations = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            const SizedBox(height: 60),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: TextField(
                onChanged: (value) {
                  _onSearchChanged();
                },
                controller: _searchController,
                decoration: InputDecoration(
                  filled: true,
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xffC3FCBA)),
                    borderRadius: BorderRadius.circular(33),
                  ),
                  prefixIcon: const Icon(Icons.search),
                  iconColor: titleColor,
                  enabledBorder: UnderlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(33),
                  ),
                  fillColor: const Color(0xffEFF6EF),
                  focusColor: const Color(0xffDFFDDB),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: _foundWords.isNotEmpty
                    ? ListView.builder(
                        padding: const EdgeInsets.only(top: 10),
                        itemCount: _foundWords.length,
                        itemBuilder: (BuildContext context, int index) {
                          final word = _foundWords[index];
                          return Container(
                            key: ValueKey(word.ar),
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: ListTileTheme(
                              tileColor: bgForGreenButtons,
                              child: ExpansionTile(
                                tilePadding: const EdgeInsets.only(left: 15, top: 10, right: 15, bottom: 10),
                                collapsedShape: const ContinuousRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(36)),
                                ),
                                shape: const ContinuousRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(36)),
                                ),
                                title: Text(
                                  word.ar,
                                  style:  GoogleFonts.notoSansArabic (color: titleColor, fontSize: 24),
                                ),
                                children: [
                                  ListTile(
                                    title: Text(
                                      _getTranslation(word, language),
                                      style: GoogleFonts.rubik(color: titleColor, fontSize: 24),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      )
                    : Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                             Text(
                              appLocalizations!.emptyList,
                              style: GoogleFonts.rubik(fontSize: 24, color: titleColor),
                            ),
                            const SizedBox(height: 10),
                            Image.asset('assets/images/Quran.png', scale: 3),
                          ],
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
