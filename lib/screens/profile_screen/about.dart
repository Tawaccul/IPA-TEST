import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
       children: 
       [ 
          Image.asset('assets/images/logotype.png'),

          Text(
            
            'Приложение создано для изучения арабских слов из Корана. Данные взяты с сайта Quran qorpus. Есть всего 6 типов игры, которые помогают лучше всего запомнить слова: '),
            SizedBox(height: 100,),
            Text('1-'),
            Text('2-'),
            Text('3-'),
            Text('4-'),
            Text('5-'),
            Text('6-'),

        ]
      ),
    );
  }
}