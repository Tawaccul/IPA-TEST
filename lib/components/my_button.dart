import 'package:flutter/material.dart';
import 'package:quranapp/consts/colors.dart';

class MyButton extends StatelessWidget {
  final Function()? onTap;
  final String title; 


  const MyButton({super.key, required this.onTap, required this.title});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: mainGreen,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Center(
          child:  Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
