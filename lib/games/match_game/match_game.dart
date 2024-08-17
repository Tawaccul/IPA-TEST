import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:quranapp/consts/colors.dart';
import 'package:quranapp/models/models.dart';
import 'package:quranapp/providers/timer_provider.dart';
import 'package:quranapp/screens/splash_screen.dart';

class MatchGame extends StatefulWidget {
  final VoidCallback onGameCompleted;
  final Level level;
  final String selectedLanguage;

  MatchGame({
    required this.onGameCompleted,
    required this.level,
    required this.selectedLanguage,
  });

  @override
  _MatchGameState createState() => _MatchGameState();
}

class _MatchGameState extends State<MatchGame> with TickerProviderStateMixin {
  List<ItemModel> items = [];
  late AnimationController _controller;
  late Animation<double> _animation;
  int _timeElapsed = 0;

  bool _isPairBeingChecked = false;
  bool _levelCompleted = false;
  late int score;
  late bool gameOver;

  late ItemModel selectedArabicWord;
  late ItemModel selectedTranslationWord;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    initGame();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _isPairBeingChecked = false;
        });
      }
    });

    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    _controller.addListener(() {
      setState(() {}); // Redraw on each animation frame
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> playSound(String path) async {
    await _audioPlayer.play(AssetSource(path));
  }

  void completeGame() {
    playSound('assets/audios/correct2.mp3');
    _showStatisticsDialog();
  }

  void _showStatisticsDialog() {
    final timerProvider = Provider.of<TimerProvider>(context, listen: false);
    int totalWords = widget.level.words.length;
    int studiedWords = items.where((item) => item.isMatched).length ~/ 2;
    double studiedPercentage = (studiedWords / totalWords) * 100;
    int timeElapsed = timerProvider.seconds;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.only(
              top: 20.0,
              left: 20.0,
              right: 20.0,
              bottom: MediaQuery.of(context).viewInsets.bottom + 20),
          height: MediaQuery.of(context).size.height * 0.5,
          decoration: BoxDecoration(
            color: bgForGreenButtons,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Уровень завершен!',
                style: GoogleFonts.rubik(
                  fontSize: 18.0,
                  color: titleColor,
                  fontWeight: FontWeight.w600
                ),
              ),
              SizedBox(height: 20.0),
              Text(
                'Изученные слова: $studiedWords из $totalWords',
                style: GoogleFonts.rubik(
                  fontSize: 18.0,
                  color: titleColor
                ),
              ),
              Text(
                'Процент изученных слов: ${studiedPercentage.toStringAsFixed(2)}%',
                style: GoogleFonts.rubik(
                  fontSize: 18.0,
                  color: titleColor
                ),
              ),
              Text(
                'Время на изучение: $timeElapsed секунд',
                style: GoogleFonts.rubik(
                  fontSize: 18.0,
                  color: titleColor
                ),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SplashScreen()));
                  widget.onGameCompleted();
                },  style: ButtonStyle(
                                backgroundColor: MaterialStateColor.resolveWith((states) => mainGreen),
                                foregroundColor: MaterialStateColor.resolveWith((states) => Colors.white),
                                shadowColor: MaterialStateColor.resolveWith((states) => Color.fromARGB(0, 0, 0, 0)),
                              ),
                              
                child: Text('Продолжить'),
              ),
            ],
          ),
        );
      },
    );

    // Save the time elapsed and studied words to Firestore
  }

  void initGame() {
    for (var word in widget.level.words) {
      items.add(ItemModel(
        original: word.ar,
        translation:
            word.toMap()['translation'][widget.selectedLanguage] ?? "Unknown",
      ));
      items.add(ItemModel(
        original:
            word.toMap()['translation'][widget.selectedLanguage] ?? "Unknown",
        translation: word.ar,
      ));
    }

    items.shuffle();

    gameOver = false;
    score = 0;
    selectedArabicWord = ItemModel(
      original: '',
      translation: '',
      buttonColor: Colors.greenAccent,
    );
    selectedTranslationWord = ItemModel(
      original: '',
      translation: '',
      buttonColor: Colors.greenAccent,
    );

    if (items.isEmpty) {
      gameOver = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
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
              value: 17 / 18,
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
                  child: Text('${timer.seconds}', style: TextStyle(fontSize: 12)),
                ),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  const Color.fromRGBO(241, 253, 241, 100),
                  const Color.fromRGBO(241, 253, 241, 100),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              height: MediaQuery.of(context).size.height * _animation.value,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    const Color.fromRGBO(175, 210, 164, 1),
                    const Color.fromRGBO(195, 252, 186, 1),
                  ],
                ),
              ),
            ),
          ),
          Container(
            color: Colors.white,
            padding: EdgeInsets.all(22.0),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: Expanded(
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 8.0,
                      ),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        ItemModel item = items[index];
                  
                        return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            disabledBackgroundColor: bgForCards,
                            disabledForegroundColor: mainGreen,
                            shadowColor:
                                const Color.fromARGB(0, 6, 118, 64),
                            foregroundColor: item == selectedArabicWord ||
                                    item == selectedTranslationWord
                                  ? bgForGreenButtons
                                : Colors.white,
                            backgroundColor: item == selectedArabicWord ||
                                    item == selectedTranslationWord
                                ? bgForGreenButtons
                                : Colors.white,
                            elevation: 1,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(36.0),
                              side: BorderSide(
                                
                                width: 2,
                                color: item.isMatched || item.isSelected
                                    ? mainGreen
                                    : bgForCards,
                              ),
                            ),
                          ),
                          onPressed: item.isMatched
                              ? null
                              : () {
                                  _onWordClick(item);
                                },
                          child: Text(
                            item.original,
                            style: GoogleFonts.rubik(
                              fontSize: 20.0,
                              fontWeight: FontWeight.normal,
                              color: item.isMatched || item.isSelected
                                  ? mainGreen
                                  : titleColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onWordClick(ItemModel item) {
    setState(() {
      if (item.isMatched || item.isSelected) {
        return;
      }

      if (selectedArabicWord.original.isEmpty) {
        selectedArabicWord = item;
        selectedArabicWord.isSelected = true;
      } else {
        selectedTranslationWord = item;
        selectedTranslationWord.isSelected = true;

        if (selectedArabicWord.translation ==
                selectedTranslationWord.original &&
            selectedTranslationWord.translation == selectedArabicWord.original) {
          score += 10;

          selectedArabicWord.isMatched = true;
          selectedTranslationWord.isMatched = true;

          final timerProvider = Provider.of<TimerProvider>(context, listen: false);
          int timeElapsed = timerProvider.seconds;
          saveWordToFirestore(selectedArabicWord, selectedTranslationWord, timeElapsed);

          playSound('assets/audios/click.mp3'); // Play correct pair sound

          if (items.every((item) => item.isMatched)) {
            _controller.forward();
            completeGame();
            timerProvider.resetTimer();
            timerProvider.stopTimer();

            gameOver = true;
          }
        } else {
          if (selectedArabicWord.original.isNotEmpty &&
              selectedTranslationWord.original.isNotEmpty &&
              item.original == item.translation) {
            score -= 5;
          }

          selectedArabicWord.isSelected = false;
          selectedTranslationWord.isSelected = false;
        }

        selectedArabicWord = ItemModel(
            original: '', translation: '', buttonColor: Colors.greenAccent);
        selectedTranslationWord = ItemModel(
            original: '', translation: '', buttonColor: Colors.greenAccent);
      }
    });
  }

  void saveWordToFirestore(
    ItemModel arabicWord, ItemModel translationWord, int timeElapsed) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    try {
      final batch = FirebaseFirestore.instance.batch();
      final levelsCollection = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('completed_levels');

      final levelDoc = levelsCollection.doc(widget.level.id.toString());

      // Check if the level has already been completed
      final levelSnapshot = await levelDoc.get();
      if (levelSnapshot.exists) {
        print('Level already completed. Skipping save.');
        return;
      }

      batch.set(levelDoc, {
        'levelId': widget.level.id,
        'completionPercentage': widget.level.procent,
        'timeElapsed': timeElapsed,
        'timestamp': FieldValue.serverTimestamp(),
      });

      for (var word in widget.level.words) {
        final querySnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('studied_words')
            .where('ar', isEqualTo: word.ar)
            .where('che', isEqualTo: word.che)
            .where('ru', isEqualTo: word.ru)
            .where('en', isEqualTo: word.en)
            .get();

        if (querySnapshot.docs.isEmpty) {
          final docRef = FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .collection('studied_words')
              .doc();
          batch.set(docRef, {
            'ar': word.ar,
            'che': word.che,
            'ru': word.ru,
            'en': word.en,
            'percent' : widget.level.procent,
            'timeElapsed': timeElapsed, // Add the time elapsed to Firestore
            'timestamp': FieldValue.serverTimestamp(),
          });
        }
      }
      await batch.commit();
    } catch (e) {
      print('Error saving word to Firestore: $e');
    }
  } else {
    print('User is not authenticated');
  }
}


   Future<bool> _showExitConfirmationDialog() async {
    return (await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Подтверждение'),
        content: Text('Вы действительно хотите вернуться на главный экран? Уровень будет прерван, и придется начинать сначала.'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Нет'),
          ),
          TextButton(
            onPressed: () { Navigator.of(context).pop(true); 
                    Provider.of<TimerProvider>(context, listen: false).resetTimer();

            },
            child: Text('Да'),
          ),
        ],
      ),
    )) ?? false;
  }
}

class ItemModel {
  final String original;
  final String translation;
  Color buttonColor;
  bool isSelected;
  bool isMatched;

  ItemModel({
    required this.original,
    required this.translation,
    this.buttonColor = Colors.greenAccent,
    this.isSelected = false,
    this.isMatched = false,
  });
}
