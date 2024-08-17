import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quranapp/consts/colors.dart';
import 'package:quranapp/l10n/app_locale.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';
import 'package:quranapp/screens/profile_screen/about.dart';
import 'package:quranapp/screens/profile_screen/providers.dart';
import 'package:quranapp/screens/lang_provider.dart';
import 'package:quranapp/auth/pages/login.dart';

class ProfileScreen extends StatefulWidget {
  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  final user = FirebaseAuth.instance.currentUser;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> _foundUsers = [];
  int _studiedWordsCount = 0;
  static const int _maxWords = 100;
  bool _isVibrationEnabled = true;
  bool _isNotificationsEnabled = true;
  num _totalStudyTime = 0; // Total time spent
  num _totalStudyPercentage = 0.0; // Total percentage of studied words
  List<int> _weeklyUsage = [1, 3, 2, 0, 1, 2, 3]; // Mock data for weekly usage

  @override
  void initState() {
    super.initState();
    fetchStudiedWords();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void fetchStudiedWords() async {
    final prefs = await SharedPreferences.getInstance();
    final String? storedWords = prefs.getString('studiedWords');

    num totalTime = 0;
    num totalPercentage = 0.0;

    if (user != null) {
      final snapshot = await _firestore
          .collection('users')
          .doc(user!.uid)
          .collection('studied_words')
          .get();

      List<Map<String, dynamic>> words = snapshot.docs.map((doc) {
        return doc.data() as Map<String, dynamic>;
      }).toList();

      for (var word in words) {
        totalTime += word['timeElapsed'] ?? 0;
        totalPercentage += word['percent'] ?? 0.0;
      }

      setState(() {
        _foundUsers = words;
        _studiedWordsCount = words.length;
        _totalStudyTime = (totalTime / 4).round()  ;
        _totalStudyPercentage = (totalPercentage /4).round();
      });
    }
  }

  Future<void> logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    await FirebaseAuth.instance.signOut();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  void _toggleVibration(bool isEnabled) async {
    setState(() {
      _isVibrationEnabled = isEnabled;
    });
    if (isEnabled) {
      if (await Vibration.hasVibrator() ?? false) {
        Vibration.vibrate(duration: 100);
      }
    } else {
      Vibration.cancel();
    }
  }

  void _toggleNotifications(bool isEnabled) {
    setState(() {
      _isNotificationsEnabled = isEnabled;
    });
    // Implement notification logic
  }

  void _showStatisticsDialog(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:  Text(appLocalizations!.statistics, style: GoogleFonts.rubik(color: mainGreen),),
          content:  Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
            alignment: Alignment.centerLeft,
            child: Text('${appLocalizations.spendsTime}: ${formatTime(_totalStudyTime)}', style: GoogleFonts.rubik(color: titleColor), textAlign: TextAlign.left,),),
                const SizedBox(height: 10),
                Container(
            alignment: Alignment.centerLeft,
            child:
                Text('${appLocalizations.studiedWords}: $_studiedWordsCount', style: GoogleFonts.rubik(color: titleColor), textAlign: TextAlign.left,),),
                const SizedBox(height: 10),
                Container(
            alignment: Alignment.centerLeft,
            child:
                 Text('${appLocalizations.percentOfQuran}: ${_totalStudyPercentage.toStringAsFixed(2)}%', style: GoogleFonts.rubik(color: titleColor), textAlign: TextAlign.left,),),
                const SizedBox(height: 10),
              ],
            ),
          
          actions: [
            TextButton(
              child:  Text(appLocalizations.close, style: GoogleFonts.rubik(color: mainGreen, fontSize: 18),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
String formatTime(num seconds) {
  int minutes = seconds ~/ 60;
  num remainingSeconds = seconds % 60;
  String formattedMinutes = minutes.toString().padLeft(2, '0');
  String formattedSeconds = remainingSeconds.toString().padLeft(2, '0');
  return "$formattedMinutes:$formattedSeconds";
}




  @override
  Widget build(BuildContext context) {
    final userName = Provider.of<UserProvider>(context).userName;
    final languageProvider = Provider.of<LanguageProvider>(context);
    double progress = _studiedWordsCount / _maxWords;

    final appLocalizations = AppLocalizations.of(context);
    if (appLocalizations == null) {
      return Center(child: Text('Localization not found'));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(28.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 150,),
              SizedBox(
                width: 120,
                height: 120,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.asset('assets/images/account.png'),
                ),
              ),
              const SizedBox(height: 20),
              userName != null
                  ? Text(
                      userName.toUpperCase(),
                      style: GoogleFonts.rubik(fontSize: 17, color: const Color(0xff113356), fontWeight: FontWeight.w500),
                    )
                  : const Text(''),
              const SizedBox(height: 50),
              Container(
                height: 20,
                decoration: BoxDecoration(
                  color: const Color(0xffF1F1F1),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xff8DD88D)),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.transparent,
                    valueColor: const AlwaysStoppedAnimation<Color>(const Color(0xff4CAF50)),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ProfileMenuWidget(
                title: appLocalizations.statistics,
                icon: Icons.star,
                onPress: () => _showStatisticsDialog(context),
              ),
              ProfileMenuSwitch(
                title: appLocalizations.notifications,
                icon: Icons.notifications,
                isSwitchOn: _isNotificationsEnabled,
                onToggle: _toggleNotifications,
              ),
              ProfileMenuSwitch(
                title: appLocalizations.vibration,
                icon: Icons.vibration,
                isSwitchOn: _isVibrationEnabled,
                onToggle: _toggleVibration,
              ),
              ProfileMenuWidget(
                title: appLocalizations.changeLanguage,
                icon: Icons.language,
                onPress: () => _showLanguageDialog(context, languageProvider),
              ),
              const SizedBox(height: 20),
              ProfileMenuWidget(
                title: appLocalizations.about,
                icon: Icons.info,
                onPress: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AboutScreen()));
                },
              ),
              ProfileMenuWidget(
                title: appLocalizations.logout,
                icon: Icons.logout,
                textColor: Colors.red,
                endIcon: false,
                onPress: () {
                  logout(context);
                },
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context, LanguageProvider languageProvider) {
  final appLocalizations = AppLocalizations.of(context);
  
 
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        insetPadding: EdgeInsets.zero, // Removes default padding around the dialog
        child: Scaffold(
          appBar: AppBar(
            title: Text(appLocalizations!.changeLanguage),
            backgroundColor: Colors.green, // Customize the AppBar color if needed
          ),
          body: Center(
            child: ListView(
              padding: EdgeInsets.all(20),
              children: [
                _buildLanguageItem(
                  context,
                  languageProvider,
                  languageCode: 'ru',
                  languageName: appLocalizations.rus,
                  iconPath: 'assets/images/russia.png',
                ),
                _buildLanguageItem(
                  context,
                  languageProvider,
                  languageCode: 'en',
                  languageName: appLocalizations.en,
                  iconPath: 'assets/images/united-kingdom.png',
                ),
                _buildLanguageItem(
                  context,
                  languageProvider,
                  languageCode: 'che',
                  languageName: appLocalizations.che,
                  iconPath: 'assets/images/chechnya.png',
                ),
              ],
            ),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(appLocalizations.close),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, // Customize button color if needed
              ),
            ),
          ),
        ),
      );
    },
  );
}


Widget _buildLanguageItem(
  BuildContext context,
  LanguageProvider languageProvider, {
  required String languageCode,
  required String languageName,
  required String iconPath,
}) {
  bool isSelected = languageProvider.locale.languageCode == languageCode;

  return Container(
     decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3),
              ),
            ],
          ),
    padding: const EdgeInsets.all(8.0),
    child: ListTile(
      leading: Image.asset(
        iconPath,
        width: 30,
        height: 30,
      ),
      tileColor: Colors.white,
      
      title: Text(languageName),
      trailing: isSelected
          ? Icon(
              Icons.check,
              color: Colors.green, // Checkmark color
            )
          : null,
      onTap: () {
        languageProvider.setLanguage(languageCode);
      },
    ),
  );
}}


class ProfileMenuWidget extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onPress;
  final Color? textColor;
  final bool endIcon;

  ProfileMenuWidget({
    required this.title,
    required this.icon,
    required this.onPress,
    this.textColor,
    this.endIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xff113356)),
      title: Text(title, style: GoogleFonts.rubik(color: textColor ?? Colors.black)),
      trailing: endIcon ? const Icon(Icons.chevron_right, color: const Color(0xff113356)) : null,
      onTap: onPress,
    );
  }
}

class ProfileMenuSwitch extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isSwitchOn;
  final ValueChanged<bool> onToggle;
  final Color? textColor;
  final bool endIcon;

  ProfileMenuSwitch({
    required this.title,
    required this.icon,
    required this.isSwitchOn,
    required this.onToggle,
    this.textColor,
    this.endIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xff113356)),
      title: Text(title, style: GoogleFonts.rubik(color: textColor ?? Colors.black)),
      trailing: Switch(
        value: isSwitchOn,
        activeColor: const Color(0xff113356),
        onChanged: onToggle,
      ),
      onTap: () => onToggle(!isSwitchOn),
    );
  }
}
