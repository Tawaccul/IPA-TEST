import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quranapp/consts/colors.dart';
import 'package:quranapp/models/models.dart';

class CollectGame extends StatefulWidget {
  final Word word;
  final VoidCallback onGameCompleted;
  final bool isWordAlreadyUsed;
  final String selectedLanguage;

  CollectGame({
    required this.word,
    required this.onGameCompleted,
    required this.isWordAlreadyUsed,
    required this.selectedLanguage,
    Key? key,
  }) : super(key: key ?? ValueKey(word.ar));

  @override
  _CollectGameState createState() => _CollectGameState();
}
class _CollectGameState extends State<CollectGame> {
  String word = '';
  List<String> letters = [];
  late List<String>? words;
  bool isWordLearnedInCollectGame = false;
  late List<bool> dragged;
  late List<bool> dragging;
  String currentWord = '';
  String message = '';
  late List<Offset> lastPositions;
  bool isDraggedIntoTarget = false;
  bool shake = false;
  final containerKey = GlobalKey();
  late List<Offset> positions;
  final Random random = Random();
  double containerWidth = 0;
  int currentWordIndex = 0;
  late AudioPlayer audioPlayer;

  Offset normalize(Offset offset) {
    double length = offset.distance;
    if (length == 0) return Offset.zero;
    return Offset(offset.dx / length, offset.dy / length);
  }

  @override
  void initState() {
    super.initState();
    loadWords();
    word = widget.word.ar;
    letters = widget.word.ar.characters.toList();
    positions = [];
    audioPlayer = AudioPlayer();

  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Call randomPositionWithinContainer here
    positions = List.generate(letters.length, (index) => randomPositionWithinContainer());
  }
Offset randomPositionWithinContainer() {
  // Получаем размеры контейнера
  final containerWidth = 340.0; // Ширина контейнера
  final containerHeight = 360.0; // Высота контейнера

  // Генерируем случайные координаты в пределах контейнера
  final dx = random.nextDouble() * (containerWidth - 60);
  final dy = random.nextDouble() * (containerHeight - 60);

  // Возвращаем сгенерированные координаты
  return Offset(dx, dy);
}

  Future<void> loadWords() async {
    letters = widget.word.ar.characters.toList();
    dragged = List.generate(letters.length, (index) => false);
    dragging = List.generate(letters.length, (index) => false);
    positions = List.generate(letters.length, (index) => randomPositionWithinContainer());
    lastPositions = List.generate(letters.length, (index) => Offset.zero);
    setState(() {});
  }

 @override
  Widget build(BuildContext context) {
    if (letters.isEmpty) {
      return CircularProgressIndicator();
    }
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 150,
              child:  CachedNetworkImage(
                  imageUrl: 'https://firebasestorage.googleapis.com/v0/b/quranapp-words1123.appspot.com/o/${widget.word.picture}?alt=media',
                  height: 120,
                  width: 120,
                  placeholder: (context, url) => CircularProgressIndicator(color: titleColor,),
                  errorWidget: (context, url, error) {
                    print("Error loading image: $error"); // Debugging print
                    return Icon(Icons.error);
                  },
                ),
            ),
            LayoutBuilder(
              builder: (context, constraints) {
                containerWidth = constraints.maxWidth;
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: bgForCards, width: 6)
                  ),
                  key: containerKey,
                  width: 340,
                  height: 360,
                  child: Stack(
                    children: letters.asMap().entries.map((entry) {
                      int index = entry.key;
                      String letter = entry.value;
                      if (dragged[index]) {
                        return Container();
                      } else {
                        return Positioned(
                          left: positions[index].dx,
                          top: positions[index].dy,
                          child: Draggable<String>(
                            data: letter,
                            child: dragging[index]
                                ? Container()
                                : Container(
                                    width: 60,
                                    height: 60,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: bgForGreenButtons,
                                        border: Border.all(color: mainGreen, width: 1),
                                        borderRadius: BorderRadius.circular(48)),
                                    child: Text(
                                      letter,
                                      style: GoogleFonts.notoSansArabic(fontSize: 26, color: mainGreen, height: 0),
                                    ),
                                  ),
                            childWhenDragging: Container(),
                            feedback: Container(
                              width: 55,
                              height: 55,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: mainGreen,
                                  border: Border.all(color: mainGreen, width: 1),
                                  borderRadius: BorderRadius.circular(48)),
                              child: Text(
                                letter,
                                style: GoogleFonts.notoSansArabic(
                                    fontSize: 22,
                                    color: Colors.white,
                                    decoration: TextDecoration.none,
                                    fontWeight: FontWeight.normal),
                              ),
                            ),
                            onDragStarted: () {
                              setState(() {
                                dragging[index] = true;
                                lastPositions[index] = positions[index];
                              });
                            },
                                   onDraggableCanceled: (velocity, offset) {
  setState(() {
    dragging[index] = false;
    isDraggedIntoTarget = false;
  });
},

        onDragEnd: (details) {
  setState(() {
    dragging[index] = false;
    final RenderBox renderBox = containerKey.currentContext!.findRenderObject() as RenderBox;
    final Offset localOffset = renderBox.globalToLocal(details.offset);
    final double letterWidth = 60.0;  // Ширина буквы
    final double letterHeight = 60.0;  // Высота буквы
    // Проверяем, что буква останется в пределах контейнера после перемещения
    if (localOffset.dx >= 0 &&
        localOffset.dy >= 0 &&
        localOffset.dx + letterWidth <= renderBox.size.width &&
        localOffset.dy + letterHeight <= renderBox.size.height) {
      positions[index] = localOffset;
    } else {
      // Если буква выходит за пределы контейнера, оставляем ее на последней позиции
      positions[index] = lastPositions[index];
    }
  });
},

                          ),
                        );
                      }
                    }).toList(),
                  ),
                );
              },
            ),
            DragTarget<String>(
              builder: (context, candidateData, rejectedData) {
                return AnimatedContainer(
                  duration: Duration(milliseconds: 100),
                  transform: shake ? Matrix4.skew(0.1, 0.1) : null,
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: 80,
                  decoration: BoxDecoration(
                    color: bgForCards,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Center(child: Text('$currentWord', style: GoogleFonts.notoSansArabic(fontSize: 32, color: mainGreen))),
                );
              },
                onWillAccept: (data) {
    return true;  // Принимаем все буквы
  },

  onAccept: (data) {
    int index = letters.indexOf(data);
    if (letters[currentWord.characters.length] == data) {
      setState(() {
        audioPlayer.play(AssetSource('audios/click.mp3'));

        currentWord += data;
        dragged[index] = true;
        isDraggedIntoTarget = true;
        if (currentWord.characters.length == letters.length) {
          setState(() {
            widget.onGameCompleted();
          });
        }
      });
    }
  },

  onLeave: (data) {
    int index = letters.indexOf(data!);
    if (letters[currentWord.characters.length] != data) {
      setState(() {
        positions[index] = lastPositions[index];
      });
    }
  },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Освобождаем ресурсы AudioPlayer при уничтожении состояния
    audioPlayer.dispose();
    super.dispose();
  }
}

