import 'package:flutter/material.dart';

class WidgetsOnHomeScreen extends StatelessWidget {
  final String _title;

  const WidgetsOnHomeScreen(this._title, String s);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
    child:   Row( 
        children: [
          SizedBox(width: 10,),
       Container( 
      child: Container (
   child: Stack(
    children: [
      // Background Image
        Container( 
          child: 
            Image.asset(
              'assets/images/Frame.png', 
       height: 120,
        width: 140,
          )
      ),
      // Content Container
      SizedBox(
        height: 120,
        width: 140,

        child: Column(
          children: <Widget>[
            SizedBox(height: 10),
            Container( 
              height: 100,
              child: Text(
              textAlign: TextAlign.left,
              _title,
              style: TextStyle(fontSize: 16, color: Color.fromRGBO(17, 51, 86, 1) ),
              key: Key('title_key'),
            )),
          ],
        ),
      ),
    ],
  ),
      ))]));

    
  }
}


