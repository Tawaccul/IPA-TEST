import 'package:flutter/material.dart';

class BottomMenu extends StatefulWidget {
  const BottomMenu({super.key});

  @override 
  State<BottomMenu> createState() => _BottomMenuState();

}

class _BottomMenuState extends State<BottomMenu> {


    int _selectedIndex = 0; 
    
    void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
         @override
  Widget build(BuildContext context) {
    return  BottomNavigationBar(
    items: const <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Icon(Icons.school),
        label: 'Study',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.camera),
        label: 'Words',
      ),
     
    ],
    currentIndex: _selectedIndex,
    onTap:  _onItemTapped,
  
    );
  }
  } 

