import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:quranapp/consts/colors.dart';
import 'package:quranapp/models/models.dart';
import 'package:quranapp/screens/lang_provider.dart';
import 'package:quranapp/utilits/utilits.dart';

class QuizGame extends StatefulWidget {
  final Level? level;
  final VoidCallback? onGameCompleted;
  final bool? isWordAlreadyUsed;
  final String? selectedLanguage;
  final Word? word;
  final List<Level> allLevels;

  QuizGame({
    this.word,
    this.level,
    this.onGameCompleted,
    this.isWordAlreadyUsed = true,
    this.selectedLanguage,
    required int currentWordIndex,
    required this.allLevels,
    Key? key,
  }) : super(key: key ?? ValueKey(word?.ar)); // Adding a key here

  @override
  _QuizGameState createState() => _QuizGameState();
}

class _QuizGameState extends State<QuizGame> {
  late List<String> options;
  late String correctWord;
  int? selectedOptionIndex;
  int correctOptionIndex = -1;

  @override
  void initState() {
    super.initState();
    initializeGame();
  }

  void initializeGame() {
    if (widget.word != null && widget.selectedLanguage != null) {
      final language = widget.selectedLanguage!;
      correctWord = TranslationUtils.getTranslation(widget.word!, language);

      // Get words from other levels
      List<String> otherLevelWords = [];
      for (var level in widget.allLevels) {
        if (level != widget.level) {
          otherLevelWords.addAll(level.words
              .map((word) => TranslationUtils.getTranslation(word, language))
              .toList());
        }
      }

      // Shuffle words and pick 3 random words from other levels
      otherLevelWords.shuffle();
      List<String> randomOtherWords = otherLevelWords.take(3).toList();

      // Form answer options
      options = [
        correctWord,
        randomOtherWords[0],
        randomOtherWords[1],
        randomOtherWords[2],
      ];
      options.shuffle();

      correctOptionIndex = options.indexOf(correctWord);

      // Print for debugging (optional)
      print('initializeGame: correctWord = $correctWord');
      print('initializeGame: options = $options');
    } else {
      // Handle null cases for word or selectedLanguage
      correctWord = 'Unknown';
      options = ["Unknown", "Wrong Translation 1", "Wrong Translation 2", "Wrong Translation 3"];
    }
  }

  void checkAnswer(int index) {
    setState(() {
      selectedOptionIndex = index;
    });
    if (options[index] == correctWord) {
      if (widget.onGameCompleted != null) {
        widget.onGameCompleted!();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.white,
      body: widget.word != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  // Displaying image
                  CachedNetworkImage(
                    imageUrl: 'https://firebasestorage.googleapis.com/v0/b/quranapp-words1123.appspot.com/o/${widget.word!.picture}?alt=media',
                    height: 120,
                    width: 120,
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                  // Displaying word on screen
                  Text(
                    widget.word!.ar,
                    style: GoogleFonts.notoSansArabic(fontSize: 30, fontWeight: FontWeight.w500, color: titleColor),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(options.length, (index) {
                      return GestureDetector(
                        onTap: () => checkAnswer(index),
                        child: Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(bottom: 10),
                          width: 300,
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: selectedOptionIndex == index
                                ? (index == correctOptionIndex ? Colors.green : Colors.red)
                                : bgForCards,
                          ),
                          child: Text(
                            options[index],
                            style: TextStyle(fontSize: 20, color: Colors.black),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            )
          : Center(
              child: Text('Word data is not available'),
            ),
    );
  }
}
