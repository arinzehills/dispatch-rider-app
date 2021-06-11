
import 'package:flutter/material.dart';
import 'package:dispacher_app/main.dart';

class NoAccount extends StatelessWidget {
  String title;
  String subT;
  Function pressed;
  NoAccount({
    this.title, this.pressed, this.subT
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          subT ?? subT + ' Have an Account?',
  style:TextStyle(color: Color(MyApp().myred))
        ),
        GestureDetector(
          onTap:pressed,
          child:Text(
            title,
            style:TextStyle(color: Color(MyApp().myred),
            fontWeight: FontWeight.bold
            )
          )
        )
      ],
    );
  }
}