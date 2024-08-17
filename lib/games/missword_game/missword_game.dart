import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quranapp/consts/colors.dart';
import 'package:quranapp/games/games_page.dart';
import 'package:quranapp/models/models.dart';
import 'package:quranapp/providers/timer_provider.dart';
import 'package:quranapp/utilits/utilits.dart';
import 'package:google_fonts/google_fonts.dart';

class MissingWordGame extends StatefulWidget {
  final VoidCallback onGameCompleted;
  final String selectedLanguage;
  final Level level;
  final List<Level> allLevels;
  final List<String> imgUrls;

  MissingWordGame({
    required this.onGameCompleted,
    required this.selectedLanguage,
    required this.level,
    required this.allLevels,
    required this.imgUrls,
  });

  @override
  _MissingWordGameState createState() => _MissingWordGameState();
}

class _MissingWordGameState extends State<MissingWordGame> {
  late List<dynamic> _gameWords;
  int currentWordIndex = 0;
  bool _levelCompleted = false;
  late String _russianSentence;
  late String _translateSentence;
  late List<dynamic> _highlightedWords;
  late String _missingWord;
  List<bool> _buttonStates = List.filled(9, false);
  int maxSteps = 15;
  late String _displayedPart;
  int currentWord = 0;
  late String _currentWord;
  late String _currentWordImage;
  final AudioPlayer _audioPlayer = AudioPlayer();
  List<int> _checkingOrder = [0, 2, 1, 3]; 
  @override
  void initState() {
    super.initState();
    _initGame();
  }

  void _initGame() {
    List<dynamic> currentLevelWords = widget.level.words
        .map((word) => word.toMap()['translation'][widget.selectedLanguage] ?? "Unknown")
        .toList();

    List<dynamic> otherLevelWords = [];
    for (var level in widget.allLevels) {
      if (level != widget.level) {
        otherLevelWords.addAll(
          level.words.map((word) => word.toMap()['translation'][widget.selectedLanguage] ?? "Unknown").toList(),
        );
      }
    }

    otherLevelWords.shuffle();
    List<dynamic> randomOtherWords = otherLevelWords.take(5).toList();

    // Combine current level words with other words without shuffling the current level words
    _gameWords = (currentLevelWords + randomOtherWords)..shuffle();
    
    print("Current Level Words: $currentLevelWords");
    print("Game Words: $_gameWords");

    _russianSentence = TranslationUtils.getTranslationForSentence(widget.level.sentence, widget.selectedLanguage);
    _translateSentence = widget.level.sentence.ar;
_highlightedWords = _checkingOrder.map((index) => widget.level.words[index].ar).toList();

    _nextStep();
  }

     void _nextStep() {
    setState(() {
      print("Current Word Index: $currentWord");

      if (currentWord < _checkingOrder.length) {
        int checkingIndex = _checkingOrder[currentWord];
        _currentWord = widget.level.words[checkingIndex].toMap()['translation'][widget.selectedLanguage] ?? "Unknown";
        var word = widget.level.words[checkingIndex];
        _missingWord = word.toMap()['translation'][widget.selectedLanguage] ?? "Unknown";
        _currentWordImage = 'https://firebasestorage.googleapis.com/v0/b/quranapp-words1123.appspot.com/o/${word.picture}?alt=media';
        print("Loading image from URL: $_currentWordImage"); // Debugging print
        print("Current Word: $_currentWord");
        print("Missing Word: $_missingWord");

        _displayedPart = _russianSentence.split(_missingWord)[0] + '...';
        currentWord++;
      } else {
        _levelCompleted = true;
        widget.onGameCompleted();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => GamesMainPage(
              level: widget.level,
              selectedLanguage: widget.selectedLanguage,
              initialProgress: 2,
              levels: widget.allLevels,
            ),
          ),
        );
      }
    });
  }

  void _checkAnswer(String selectedOption) async {
    int checkingIndex = _checkingOrder[currentWord - 1];
    String correctAnswer = widget.level.words[checkingIndex].toMap()['translation'][widget.selectedLanguage] ?? "Unknown";

    if (_missingWord.isNotEmpty && selectedOption == correctAnswer) {
      await _audioPlayer.play(AssetSource('audios/click.mp3'));
      setState(() {
        _highlightedWords.removeAt(0);

        if (_highlightedWords.isNotEmpty) {
          _displayedPart = _highlightedWords.join(' ');
        } else {
          _displayedPart = _russianSentence;
          _levelCompleted = true;
        }

        _buttonStates[_gameWords.indexOf(selectedOption)] = true;
        if (!_levelCompleted) {
          currentWordIndex++;
          _nextStep();
        } else {
          playSound();
          Future.delayed(Duration(seconds: 1)).then((_) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => GamesMainPage(
                  levels: widget.allLevels,
                  level: widget.level,
                  selectedLanguage: widget.selectedLanguage,
                  initialProgress: 2,
                ),
              ),
            );
          });
        }
      });
    }
  }


  Widget _highlightWord(String text, List<dynamic> wordsToHighlight) {
    final List<String> words = text.split(' ');

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        width: 300,
        child: Column(
          children: [
            if (_highlightedWords.isNotEmpty && wordsToHighlight.first == _highlightedWords.first)
              Padding(
                padding: const EdgeInsets.only(top: 6.0),
                child: CachedNetworkImage(
                  imageUrl: _currentWordImage,
                  height: 50,
                  width: 50,
                  placeholder: (context, url) => CircularProgressIndicator(color: titleColor,),
                  errorWidget: (context, url, error) {
                    print("Error loading image: $error"); // Debugging print
                    return Icon(Icons.error);
                  },
                ),
              ),
            SizedBox(height: 40,),
            Wrap(
              runSpacing: 12,
              alignment: WrapAlignment.start,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: words.map((word) {
                final bool shouldHighlight = wordsToHighlight.isNotEmpty && wordsToHighlight.first == word;

                return Tooltip(
                  triggerMode: TooltipTriggerMode.tap,
                  message: shouldHighlight ? _missingWord : '',
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 1.0),
                    child: Text(
                      word,
                      style: GoogleFonts.notoSansArabic (
                        fontSize: 24,
                        color: shouldHighlight ? mainGreen : mainGrey,
                        fontWeight: shouldHighlight ? FontWeight.w500 : FontWeight.normal,
                        decorationStyle: TextDecorationStyle.dashed,
                        decorationThickness: 1,
                        decorationColor: shouldHighlight ? mainGreen : mainGrey,
                        textBaseline: TextBaseline.ideographic,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> playSound() async {
    await _audioPlayer.play(AssetSource('audios/correct1.mp3'));
  }

  

  Widget _buildButton(String word, int index) {
    return GestureDetector(
      onTap: () {
        if (_highlightedWords.isNotEmpty) {
          _checkAnswer(word);
        }
      },
      child: Container(
        padding: EdgeInsets.all(10),
        width: 110,
        height: 56,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: _buttonStates[index] ? mainGreen : bgForCards,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          word,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: _buttonStates[index] ? Colors.white : mainGrey,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<TimerProvider>(context, listen: false).startTimer();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(120.0),
        child: AppBar(
          foregroundColor: Color(0xff4B4B4B),
          backgroundColor: Colors.transparent,
          leading: Padding(
            padding: const EdgeInsets.only(top: 15),
            child: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () async {
                bool exitConfirmed = await _showExitConfirmationDialog();
                if (exitConfirmed) {
                  Navigator.of(context).pop();
                }
              },
            ),
          ),
          title: Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Center(
              child: LinearProgressIndicator(
                value: 0 / 18,
                color: Color(0xff58CC02),
                backgroundColor: Color(0xff4B4B4B),
                minHeight: 5,
              ),
            ),
          ),
          actions: [
          Consumer<TimerProvider>(
            builder: (context, timer, child) {
              return Padding(
              padding: EdgeInsets.only(top: 15, right: 15),
              child: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(1000),
                  border: Border.fromBorderSide(
                    BorderSide(
                      color: mainGreen,
                      style: BorderStyle.solid,
                      width: 1.0,
                    ),
                  ),
                ),
                alignment: Alignment.center,
                child: Text('${timer.seconds}', style: TextStyle(fontSize: 12),)),
            );
            },
          ),
        ],
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              child: _highlightWord(_translateSentence, _highlightedWords),
              alignment: Alignment.center,
            ),
            Center(
              child: Container(
                padding: EdgeInsets.all(16),
                width: 330,
                height: 200,
                decoration: BoxDecoration(
                  color: bgForCards,
                  boxShadow: [],
                  borderRadius: BorderRadius.circular(30),
                ),
                child: 
                 Text(
                    _displayedPart,
                    style: TextStyle(fontSize: 12, color: mainGrey, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: List.generate(
                _gameWords.length,
                (index) => _buildButton(_gameWords[index], index),
              ),
            ),
            SizedBox(height: 40,)
          ],
        ),
      ),
    );
  }

  Future<bool> _showExitConfirmationDialog() async {
    return (await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text('Вы действительно хотите вернуться на главный экран? Уровень будет прерван, и придется начинать сначала', style: GoogleFonts.rubik(color: titleColor, fontSize: 16)),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Нет', style: GoogleFonts.rubik(color: mainGreen, fontSize: 18),),
          ),
          TextButton(
            onPressed: () { Navigator.of(context).pop(true); 
                    Provider.of<TimerProvider>(context, listen: false).resetTimer();

            },
            child: Text('Да', style: GoogleFonts.rubik(color: mainGreen, fontSize: 18)),
          ),
        ],
      ),
    )) ?? false;
  }
}
