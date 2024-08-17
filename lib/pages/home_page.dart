import 'package:awesome_bottom_bar/widgets/inspired/inspired.dart';
import 'package:flutter/material.dart';
import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:icons_flutter/icons_flutter.dart';
import 'package:quranapp/consts/colors.dart';
import 'package:quranapp/homed.dart';
import 'package:quranapp/models/models.dart';
import 'package:quranapp/screens/dictionary_screen/dictionary_screen.dart';
import 'package:quranapp/screens/profile_screen/settings_menu.dart';

class MyHomeScreen extends StatefulWidget {
  final List<Level> levels;
  final List<Word> studiedWords;
  final List<String> imageUrls;
  final List<int> levelIdCompleted;

  MyHomeScreen({
    required this.levels,
    required this.studiedWords,
    required this.imageUrls,
    required this.levelIdCompleted,
  });

  @override
  _MyHomeScreenState createState() => _MyHomeScreenState();
}

class _MyHomeScreenState extends State<MyHomeScreen> {
  int _page = 0;
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [];
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        print('ВОТ СЛОВА ИЗ БД${widget.levels.first.words.map((e) => e.ru)}');
        _pages = [
          HomeScreen(
            levels: widget.levels,
            imgUrl: widget.imageUrls,
            completedLevelsId: widget.levelIdCompleted,
          ),
          DictionaryScreen(studiedWords: widget.studiedWords),
          ProfileScreen(),
        ];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        color: const Color(0xffEFF6EF),
        child: Center(
          child: _pages.isNotEmpty
              ? _pages[_page]
              : CircularProgressIndicator(color: mainGreen),
        ),
      ),
      bottomNavigationBar: BottomBarInspiredInside(
        items:  [
          TabItem(
            icon: MfgLabs.home,
          ),
          TabItem(
            icon: MfgLabs.th_list,
          ),
          TabItem(
            icon:MfgLabs.user,
          ),
        ],
        backgroundColor: Colors.white,
        color: mainGreen,
        colorSelected: Colors.white,
        animated: true,
        itemStyle: ItemStyle.circle,
        indexSelected: _page,
        chipStyle:const ChipStyle(convexBridge: true, background: mainGreen),
        height: 30,
        padbottom: 0,
        padTop: 20,
        pad: -5,
        onTap: (int index) {
          setState(() {
            _page = index;
          });
        },
      ),
    );
  }
}
