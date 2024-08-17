import 'dart:async';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quranapp/consts/colors.dart';
import 'package:quranapp/games/collect_game.dart';
import 'package:quranapp/games/match_game/match_game.dart';
import 'package:quranapp/games/puzzle_game.dart';
import 'package:quranapp/games/quiz_game.dart';
import 'package:quranapp/games/swipe_game.dart';
import 'package:quranapp/models/models.dart';
import 'package:quranapp/providers/timer_provider.dart';

class GamesMainPage extends StatefulWidget {
  final Level level;
  final String selectedLanguage;
  final double initialProgress;
  final List<Level> levels;
  GamesMainPage({
    required this.level,
    required this.selectedLanguage,
    required this.initialProgress,
    required this.levels
  });

  @override
  _GamesMainPageState createState() => _GamesMainPageState();
}

class _GamesMainPageState extends State<GamesMainPage> {
  List<int> gameOrder = [];
  int currentStep = 0;
  List<int> wordOrder = [];
  int totalWords = 0;
  Set<int> usedWords = Set<int>();
  List<Level> _levels = [];
  
  double progressValue = 0.0;
  bool _loading = false;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    totalWords = 4;
    initializeGameAndWordOrder();
    progressValue = widget.initialProgress;
  }

  void initializeGameAndWordOrder() {
    if (totalWords > 0) {
      wordOrder = List<int>.generate(totalWords, (index) => index);
      wordOrder.shuffle(Random());

      gameOrder = List<int>.generate(4, (index) => index);
      gameOrder = List<int>.generate(totalWords * 4, (index) => gameOrder[index % 4]);
      gameOrder.shuffle(Random());
    } else {
      throw Exception('No words available in the level.');
    }
  }

  bool isAllGamesCompleted() {
    return _loading || currentStep >= gameOrder.length;
  }

  Future<void> playSound() async {
    // Play a sound when a game is completed
    await _audioPlayer.play(AssetSource('/audios/correct1.mp3'));
  }

  void onGameCompleted() async {
    await playSound(); // Play sound on game completion
    await Future.delayed(Duration(milliseconds: 300)); // Add 1-second delay

    setState(() {
      currentStep++;
      progressValue = (currentStep + 1) / gameOrder.length;
    });
    _checkCompletionAndNavigate();
  }

  void _checkCompletionAndNavigate() async {
    if (isAllGamesCompleted()) {
      await Future.delayed(Duration(seconds: 1)); // Add 1-second delay before navigation
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MatchGame(
              onGameCompleted: () {},
              level: widget.level,
              selectedLanguage: widget.selectedLanguage,
            ),
          ),
        );
      });
    }
  }

  Future<bool> _showExitConfirmationDialog() async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Confirm Exit'),
              content: Text('Are you sure you want to exit?'),
              actions: <Widget>[
                TextButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
                TextButton(
                  child: Text('Exit'),
                  onPressed: () {
                    Provider.of<TimerProvider>(context, listen: false).resetTimer();

                    Navigator.of(context).pop(true);
                  },
                ),
              ],
            );
          },
        ) ??
        false;
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (isAllGamesCompleted()) {
      return Container(); 
    }

    int currentGameType = gameOrder[currentStep];
    int wordIndex = wordOrder[currentStep % wordOrder.length];

    Widget currentGameWidget;

    switch (currentGameType) {
      case 0:
        currentGameWidget = QuizGame(
          key: UniqueKey(), 
          word: widget.level.words[wordIndex],
          onGameCompleted: onGameCompleted,
          selectedLanguage: widget.selectedLanguage,
          currentWordIndex: wordIndex,
          allLevels: widget.levels,
        );
        break;
      case 1:
        currentGameWidget = CollectGame(
          key: UniqueKey(), 
          word: widget.level.words[wordIndex],
          onGameCompleted: onGameCompleted,
          selectedLanguage: widget.selectedLanguage,
          isWordAlreadyUsed: false,
        );
        break;
      case 2:
        currentGameWidget = SwipeGame(
          key: UniqueKey(), 
          word: widget.level.words[wordIndex],
          onGameCompleted: onGameCompleted,
          allLevels: widget.levels,
        );
        break;
      case 3:
        currentGameWidget = PuzzleGame(
          key: UniqueKey(), 
          onGameCompleted: onGameCompleted,
          word: widget.level.words[wordIndex],
          translation: widget.selectedLanguage,
        );
        break;
      default:
        currentGameWidget = Center(child: Text('Unknown game type'));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0), 
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
                value: (currentStep + 1)/ 18,
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

          centerTitle: true,
        ),
      ),
      body: currentGameWidget,
      
    );
  }

  @override
  void dispose() {
    _audioPlayer.dispose(); // Dispose the audio player
    super.dispose();
  }
}
