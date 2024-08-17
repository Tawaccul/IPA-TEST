// import 'package:flutter/material.dart';
// import 'package:quranapp/pages/home_page.dart';

// class GameOver extends StatelessWidget {
//   final List<String> words;
//   const GameOver({required this.words, super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             Text(
//               'Game Over',
//               style: TextStyle(
//                 fontSize: ThemeData.dark().textTheme.headlineLarge!.fontSize,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             SizedBox(height: 16),
//             Text(
//               'Words: ${words.join(', ')}', style: TextStyle(fontSize: 30))
//               ,
//               ElevatedButton(onPressed: () { 
//                 WidgetsBinding.instance!.addPostFrameCallback((_) {
//   Navigator.pushReplacement(
//     context,
//     MaterialPageRoute(
//       builder: (context) => MyHomeScreen(
//       ),
//     ),
//   );
// });
//               }, child: Text('Back to main Page', style: TextStyle(fontSize: 30)),)
//               ])),);
//   }
// }