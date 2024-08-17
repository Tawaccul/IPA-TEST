// import 'dart:convert';

// import 'package:firebase_database/firebase_database.dart';
// import 'package:quranapp/models/models.dart';

// class DatabaseService {
//   final DatabaseReference _database = FirebaseDatabase.instance.ref();

//   Future<DatabaseStructure> fetchLevelData(String levelId, String lang) async {
//     try {
//       DatabaseEvent event = await _database.child(levelId).once();
//       DataSnapshot snapshot = event.snapshot;
//       if (snapshot.value != null) {
//         Map<String, dynamic> data = Map<String, dynamic>.from(
//             (snapshot.value as Map).map((key, value) => MapEntry(key.toString(), value)));
//         DatabaseStructure level = DatabaseStructure.fromJson(data, lang);
//         return level;
//       } else {
//         throw Exception("No data available");
//       }
//     } catch (e) {
//       print('Error fetching level data: $e');
//       rethrow;
//     }
//   }
// }
