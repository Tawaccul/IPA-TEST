import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:quranapp/consts/colors.dart';
import 'package:quranapp/models/models.dart';
import 'package:quranapp/screens/lang_provider.dart';
import 'package:quranapp/utilits/utilits.dart';
import 'dart:math' as math;
import 'package:vibration/vibration.dart';

class PuzzleGame extends StatefulWidget {
  final VoidCallback onGameCompleted;
  final Word word;
  final String translation;

  const PuzzleGame({
    required this.onGameCompleted,
    required this.word,
    required this.translation,
    Key? key,
  }) : super(key: key);

  @override
  State<PuzzleGame> createState() => _PuzzleGameState();
}

class _PuzzleGameState extends State<PuzzleGame> {
  List<String> wordLetters = [];
  List<String> stringList = [];
  List<int> selectedLetterIndices = [];
  String finalWordFromBase = '';
  double radius = 80;
  double expandedRadius = 140;
  String? title;
  List<Offset> endLineOffsetList = [];
  List<Offset> letterOffsetList = [];
  final AudioPlayer _audioPlayer = AudioPlayer(); // Add this line
  late String _currentWordImage = '';

  List<String> additionalLetters = [
    'يَ', 'حِ', 'سُ', 'مُ', 'لَ', 'بِ', 'تَ', 'نِ', 'رَ', 'كَ',
    'وَ', 'جِ', 'عَ', 'فِ', 'قَ', 'دِ', 'شَ', 'ذَ', 'خَ', 'صَ',
    'ضَ', 'طَ', 'ظَ', 'غَ', 'ثَ', 'زَ', 'أَ', 'إِ', 'آ', 'ؤُ',
    'ئِ', 'ىَ', 'ةَ', 'ءَ', 'كِ', 'وِ', 'جَ', 'عِ', 'فَ', 'قِ',
    'دَ', 'ثِ', 'خِ', 'صِ', 'ضِ', 'طِ', 'ظِ', 'غِ', 'زِ', 'نَ',
  ];

  @override
  void initState() {
    super.initState();
    _currentWordImage = 'https://firebasestorage.googleapis.com/v0/b/quranapp-words1123.appspot.com/o/${widget.word.picture}?alt=media';
    wordLetters = widget.word.ar.characters.toList();
    final language = widget.translation;
    title = TranslationUtils.getTranslation(widget.word, language);
    finalWordFromBase = widget.word.ar;

    int extraLettersCount = 9 - wordLetters.length;
    stringList = wordLetters + _getAdditionalLetters(extraLettersCount);

    stringList.shuffle();
    _placeWordLettersNextToEachOther();
  }

  List<String> _getAdditionalLetters(int count) {
    final random = math.Random();
    List<String> additional = [];
    for (int i = 0; i < count; i++) {
      additional.add(additionalLetters[random.nextInt(additionalLetters.length)]);
    }
    return additional;
  }

  void _placeWordLettersNextToEachOther() {
    List<String> shuffledWordLetters = List.from(wordLetters);
    shuffledWordLetters.shuffle();
    for (int i = 0; i < wordLetters.length; i++) {
      stringList[i] = shuffledWordLetters[i];
    }
  }

  Offset _calculateLetterPosition(int index, int totalLetters) {
    double angle = (2 * math.pi / totalLetters) * index;
    double xOffset = expandedRadius * math.cos(angle);
    double yOffset = expandedRadius * math.sin(angle);
    return Offset(xOffset, yOffset);
  }

  LinearGradient _backgroundGradient = LinearGradient(
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
    colors: [
      Color.fromRGBO(241, 253, 241, 100),
      Color.fromRGBO(241, 253, 241, 100),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
       
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // CachedNetworkImage(
            //       imageUrl: _currentWordImage,
            //       height: 120,
            //       width: 120,
            //       placeholder: (context, url) => CircularProgressIndicator(color: titleColor,),
            //       errorWidget: (context, url, error) {
            //         print("Error loading image: $error"); // Debugging print
            //         return Icon(Icons.error);
            //       },
            //     ),
           
          
            Container(
              height: 100,
              child: Center(
                child: Container(
                  width: 340,
                  height: 100,
                  alignment: Alignment.center,
                  padding: selectedLetterIndices.isNotEmpty
                      ? EdgeInsets.fromLTRB(8, 8, 8, 0)
                      : EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: bgForCards, width: 4)
                  ),
                  child: Text(
                    selectedLetterIndices.map((index) => stringList[index]).join(),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.notoSansArabic(
                      color: mainGreen,
                      letterSpacing: 0,
                      fontSize: 40,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
             SizedBox(height: 50,),
             Container(
              height: 100,
              child: Center(
                child: Text(
                  title!,
                  style: GoogleFonts.rubik(
                    color: titleColor,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: 120,),
            GestureDetector(
              onPanStart: _onPanStart,
              onPanUpdate: _onPanUpdate,
              onPanEnd: _onPanEnd,
              child: Container(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircleAvatar(
                      backgroundColor: Color.fromRGBO(241, 253, 241, 0.341),
                      radius: radius + 60,
                    ),
                    CustomPaint(
                      painter: LinePainter(endLineOffsetList: endLineOffsetList),
                    ),
                    ...List.generate(
                      stringList.length,
                      (i) {
                        Offset letterPosition = _calculateLetterPosition(i, stringList.length);
                        letterOffsetList.add(letterPosition);
                        return Transform.translate(
                          offset: letterPosition,
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: bgForCards, width: 2),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: CircleAvatar(
                              radius: radius - 40,
                              backgroundColor: selectedLetterIndices.contains(i)
                                  ? const Color.fromRGBO(195, 252, 186, 1)
                                  : Colors.white,
                              child: Center(
                                child: Container(
                                  width: 60,
                                  height: 60,
                                  child: Text(
                                    stringList[i],
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.notoSansArabic(
                                      color: mainGreen,
                                      fontSize: 24,
                                      height: 2.5,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onPanStart(DragStartDetails details) {
    Offset correctedOffset = Offset(details.localPosition.dx - 120, details.localPosition.dy - 120);
    for (var i = 0; i < letterOffsetList.length; i++) {
      if ((correctedOffset - letterOffsetList[i]).distance < 60 && !selectedLetterIndices.contains(i)) {
        selectedLetterIndices.add(i);
        _audioPlayer.play(AssetSource('audios/click.mp3'));
        endLineOffsetList..add(letterOffsetList[i])..add(letterOffsetList[i]);
        setState(() {});
        letterOffsetList = [];
        break;
      }
    }
  }

  void _onPanUpdate(DragUpdateDetails details) {
  if (endLineOffsetList.isNotEmpty && selectedLetterIndices.length < stringList.length) {
    Offset correctedOffset = Offset(details.localPosition.dx - expandedRadius, details.localPosition.dy - expandedRadius); // Adjust offset correction
    endLineOffsetList[endLineOffsetList.length - 1] = correctedOffset;
    for (var i = 0; i < letterOffsetList.length; i++) {
      if ((correctedOffset - letterOffsetList[i]).distance < 60 && !selectedLetterIndices.contains(i)) {
        endLineOffsetList[endLineOffsetList.length - 1] = letterOffsetList[i];
        selectedLetterIndices.add(i);

        // Play the sound
        _audioPlayer.play(AssetSource('audios/click.mp3'));

        endLineOffsetList.add(letterOffsetList[i]);
        Feedback.forTap(context);
        break;
      }
    }
    setState(() {});
    letterOffsetList = [];
  }
}

  void _onPanEnd(DragEndDetails details) {
    setState(() {
      String finalWord = selectedLetterIndices.map((index) => stringList[index]).join();
      if (finalWord == finalWordFromBase) {
        widget.onGameCompleted();
      }
      selectedLetterIndices = [];
      endLineOffsetList = [];
    });
  }
}

class LinePainter extends CustomPainter {
  final List<Offset>? endLineOffsetList;
  LinePainter({this.endLineOffsetList});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = bgForGreenButtons
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;
    if (endLineOffsetList != null && endLineOffsetList!.length >= 2) {
      for (var i = 0; i < endLineOffsetList!.length - 1; ++i) {
        canvas.drawLine(endLineOffsetList![i], endLineOffsetList![i + 1], paint);
      }
    }
  }

  @override
  bool shouldRepaint(LinePainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(LinePainter oldDelegate) => true;
}
