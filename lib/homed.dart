import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:quranapp/consts/colors.dart';
import 'package:quranapp/games/missword_game/missword_game.dart';
import 'package:quranapp/models/models.dart';
import 'package:quranapp/screens/lang_provider.dart';

class HomeScreen extends StatefulWidget {
  final List<Level> levels;
  final List<String> imgUrl;
  final List<int> completedLevelsId;
  HomeScreen({required this.levels, required this.imgUrl, required this.completedLevelsId});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _textAnimationController;
  late Animation<double> _textOpacityAnimation;
  late Animation<Offset> _textSlideAnimation;
  List<AnimationController> _controllers = [];
  List<Animation<Offset>> _slideAnimations = [];
  List<Animation<double>> _fadeAnimations = [];
  List<num> completedLevels = []; // Track completed levels

  @override
  void initState() {
    super.initState();
      print('Initial Completed Levels: $completedLevels');
      completedLevels = widget.completedLevelsId;
            print('Initial Completed Levels: ${widget.completedLevelsId}');

    _textAnimationController = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );
    _textOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _textAnimationController, curve: Curves.easeInOut),
    );
    _textSlideAnimation = Tween<Offset>(
      begin: Offset(-15.0, 0.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _textAnimationController, curve: Curves.easeInOut),
    );
    _startTextAnimation();
    _initializeAnimations();
  }

  void _startTextAnimation() async {
    await Future.delayed(Duration(seconds: 4));
    if (mounted) {
      _textAnimationController.forward();
    }
  }

  void _initializeAnimations() {
    _controllers = List.generate(
      widget.levels.length,
      (index) => AnimationController(
        duration: Duration(milliseconds: 500),
        vsync: this,
      ),
    );
    _slideAnimations = _controllers.map((controller) {
      return Tween<Offset>(
        begin: Offset(0, 1),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeInOut),
      );
    }).toList();
    _fadeAnimations = _controllers.map((controller) {
      return Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeInOut),
      );
    }).toList();
    _startAnimations();
  }

  void _startAnimations() async {
    for (int i = 0; i < _controllers.length; i++) {
      await Future.delayed(Duration(milliseconds: 200 * i));
      if (mounted) {
        _controllers[i].forward();
      }
    }
  }

  String _getTranslation(Categories category, String language) {
    switch (language) {
      case 'che':
        return category.che;
      case 'ru':
        return category.ru;
      case 'en':
      default:
        return category.en;
    }
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final String language = languageProvider.language;

    if (widget.levels.isEmpty) {
      return Scaffold(
        body: Center(
          child: Container(),
        ),
      );
    }

    final randomIndex = Random().nextInt(widget.levels.length);
    final Map<String, List<Level>> categorizedLevels = {};

    for (var level in widget.levels) {
      final category = _getTranslation(level.category, language);
      if (!categorizedLevels.containsKey(category)) {
        categorizedLevels[category] = [];
      }
      categorizedLevels[category]!.add(level);
    }

    return Scaffold(
      appBar: AppBar( title: Text(widget.levels.length.toString()),),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              alignment: Alignment.bottomLeft,
              padding: EdgeInsets.only(left: 30, top: 50),
              child: Padding(
                padding: const EdgeInsets.only(right: 30, top: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              children: [
                              Container(
                                width: 200,
                                child: Text(
                                  
                                        '${widget.levels[randomIndex].procent}%',
                                        textAlign: TextAlign.left,
                                        style: GoogleFonts.rubik(
                                            color: titleColor,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500),
                                  ),
                              ),
                                Container(
                                  width: 200,
                                  child: Text(
                                    _getTranslation(widget.levels[randomIndex].category, language),
                                    style: GoogleFonts.rubik(
                                        color: titleColor,
                                        fontSize: 24,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          SizedBox(
                            height: 55,
                            child: ElevatedButton.icon(
                              icon: Icon(Icons.play_arrow),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) => MissingWordGame(
                                      level: widget.levels[randomIndex],
                                      selectedLanguage: language,
                                     onGameCompleted: () {
  setState(() {
    completedLevels.add(widget.levels[randomIndex].id.toInt());
    print('Level Completed: ${widget.levels[randomIndex].id.toString()}');
    print('Completed Levels: $completedLevels');
  });
},

                                      allLevels: widget.levels,
                                      imgUrls: widget.imgUrl,
                                    ),
                                  ),
                                );
                              },
                              style: ButtonStyle(
                                backgroundColor: MaterialStateColor.resolveWith((states) => mainGreen),
                                foregroundColor: MaterialStateColor.resolveWith((states) => Colors.white),
                                shadowColor: MaterialStateColor.resolveWith((states) => Color.fromARGB(0, 0, 0, 0)),
                              ),
                              label: Text('ПРОЙТИ УРОВЕНЬ', style: GoogleFonts.rubik(fontWeight: FontWeight.w700)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    CachedNetworkImage(
                      imageUrl: 'https://firebasestorage.googleapis.com/v0/b/quranapp-words1123.appspot.com/o/${widget.levels[randomIndex].words.first.picture}?alt=media',
                      height: 120,
                      width: 120,
                      placeholder: (context, url) => CircularProgressIndicator(color: titleColor,),
                      errorWidget: (context, url, error) {
                        print("Error loading image: $error"); // Debugging print
                        return Icon(Icons.error);
                      },
                    ),
                  ],
                ),
              ),
            ),
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: categorizedLevels.keys.length,
                itemBuilder: (context, categoryIndex) {
                  final category = categorizedLevels.keys.elementAt(categoryIndex);
                  final levels = categorizedLevels[category]!;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 30),
                      Padding(
                        padding: const EdgeInsets.only(left: 30.0, top: 10.0),
                        child: Text(
                          category,
                          style: GoogleFonts.rubik(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: titleColor,
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      Container(
                        height: 200,
                        child: ListView.builder(
                          padding: EdgeInsets.only(left: 30, right: 30),
                          scrollDirection: Axis.horizontal,
                          itemCount: levels.length,
                          itemBuilder: (context, index) {
                            final level = levels[index];
                            final words = level.words;
                            
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) => MissingWordGame(
                                      level: level,
                                      selectedLanguage: language,
                                      onGameCompleted: () {
                                        setState(() {
                                          completedLevels.add(level.id.toInt());
                                          print('Completed Levels: $completedLevels'); // Debugging print
                                        });
                                      },
                                      allLevels: widget.levels,
                                      imgUrls: widget.imgUrl,
                                    ),
                                  ),
                                );
                              },
                              child: SlideTransition(
                                position: _slideAnimations[index],
                                child: FadeTransition(
                                  opacity: _fadeAnimations[index],
                                  child: Stack(
                                    children: [
                                      Container(
                                        width: 170,
                                        margin: EdgeInsets.symmetric(horizontal: 5),
                                        padding: EdgeInsets.only(left:14, top: 10),
                                        decoration: BoxDecoration(
                                          color: bgForGreenButtons,
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(height: 10.0),
                                            Positioned(
                                              top: 20,
                                              left: 10,
                                              child: Text(
                                                words.map((e) => e.ar).join('\n'),
                                                style: GoogleFonts.notoSansArabic(
                                                  height: 1.5,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w400,
                                                  color: mainGreen,
                                                ),
                                              ),
                                            ),
                                            Spacer(),
                                            Padding(
                                              padding: EdgeInsets.only(bottom: 14),
                                              child: Text(
                                                '${level.procent?.toStringAsFixed(2) ?? 'N/A'}%',
                                                style: GoogleFonts.rubik(
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.w600,
                                                  color: titleColor,
                                                  
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 5.0),
                                          ],
                                        ),
                                      ),
                                     
                                        Positioned(
                                          top: 24,
                                          right: 18,
                                          child: CachedNetworkImage(
                                                                  imageUrl: 'https://firebasestorage.googleapis.com/v0/b/quranapp-words1123.appspot.com/o/${level.words.first.picture}?alt=media',
                                                                  height: 50,
                                                                  width:50,
                                                                  placeholder: (context, url) => CircularProgressIndicator(color: titleColor,),
                                                                  errorWidget: (context, url, error) {
                                                                    print("Error loading image: $error"); // Debugging print
                                                                    return Icon(Icons.error);
                                                                  },
                                                                ),
                                          
                                        ),
                                         widget.completedLevelsId.contains(level.id) ? 
                                          Positioned(
                                            bottom: 18,
                                            right: 18,
                                            child: Icon(Icons.check_circle_outline_rounded, color: mainGreen, size: 28,),
                                          )
                                          : 
                                          Positioned(
                                            bottom: 18,
                                            right: 18,
                                            child: Icon(Icons.question_mark_rounded, color: titleColor, size: 28,
                                          ))
                                          ,
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
              SizedBox(height: 50,)
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _textAnimationController.dispose();
    _controllers.forEach((controller) => controller.dispose());
    super.dispose();
  }
}
