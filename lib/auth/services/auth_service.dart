import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:quranapp/auth/pages/login.dart';
import 'package:quranapp/screens/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quranapp/screens/main_screen.dart';

class AuthServices {
  static final auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> createUser(
    BuildContext context,
    String name,
    String email,
    String pass,
  ) async {
    if (!context.mounted) return;
    context.loaderOverlay.show();
    try {
      final userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: pass,
      );

      User? user = userCredential.user;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'name': name,
          'email': user.email,
        });

        await user.updateDisplayName(name);

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);

        if (!context.mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SplashScreen()),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        if (!context.mounted) return;
        showMsg(context, 'The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        if (!context.mounted) return;
        showMsg(context, 'The account already exists for that email.');
      } else {
        if (!context.mounted) return;
        showMsg(context, e.message.toString());
      }
    } catch (e) {
      if (!context.mounted) return;
      showMsg(context, e.toString());
    } finally {
      if (!context.mounted) return;
      context.loaderOverlay.hide();
    }
  }

  static Future<void> login(BuildContext context, String email, String pass) async {
    if (!context.mounted) return;
    context.loaderOverlay.show();
    try {
      await auth.signInWithEmailAndPassword(
        email: email,
        password: pass,
      );

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);

      if (!context.mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SplashScreen()),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email' || e.code == 'wrong-password') {
        if (!context.mounted) return;
        showMsg(context, 'Invalid Email & Password');
      } else {
        if (!context.mounted) return;
        showMsg(context, e.message.toString());
      }
    } catch (e) {
      if (!context.mounted) return;
      showMsg(context, e.toString());
    } finally {
      if (!context.mounted) return;
      context.loaderOverlay.hide();
    }
  }

  static Future<void> logout(BuildContext context) async {
    await auth.signOut();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);

    if (!context.mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  static void showMsg(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}
