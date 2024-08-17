import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:quranapp/auth/pages/login.dart';
import 'package:quranapp/pages/home_page.dart';
import 'package:quranapp/screens/splash_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GlobalLoaderOverlay(
            child: MaterialApp( 
              home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) =>
                snapshot.data != null ? LoginPage() : SplashScreen(),
                    ),)
    );
  }
}