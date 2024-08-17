import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:quranapp/models/models.dart';

class DataProvider with ChangeNotifier {
  List<Level> _levels = [];

  List<Level> get levels => _levels;

  void setLevels(List<Level> levels) {
    _levels = levels;
    notifyListeners();
  }

  Future<void> loadLevels() async {
    try {
      final DatabaseReference ref = FirebaseDatabase.instance.ref('levels');
      final DataSnapshot snapshot = await ref.get();

      if (snapshot.exists) {
        final Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
        _levels = data.values.map((json) => Level.fromJson(json)).toList();
        print('Loaded levels: $_levels');
      } else {
        print('No data found at \'levels\' path in Realtime Database');
        _levels = [];
      }
    } catch (e) {
      print('Error fetching levels: $e');
      _levels = [];
    }
    notifyListeners();
  }
}
