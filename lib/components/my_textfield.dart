import 'package:flutter/material.dart';
import 'package:quranapp/consts/colors.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final Icon icon;
  final void Function(String?) onChanged;

  const MyTextField({
    required this.controller,
    required this.hintText,
    required this.obscureText,
    required this.icon,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(10),
        prefixIcon: icon,
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: bgForCards),
          borderRadius: BorderRadius.all(Radius.circular(24)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: mainGreen, width: 1),
          borderRadius: BorderRadius.all(Radius.circular(24)),
        ),
        focusColor: mainGreen,
        prefixIconConstraints: BoxConstraints(minWidth: 40),
        prefixIconColor: mainGrey,
        fillColor: bgForCards,
        filled: true,
        hintText: hintText,
        hintStyle: TextStyle(color: mainGrey),
      ),
      textCapitalization: TextCapitalization.words,
      onChanged: onChanged,
    );
  }
}
