import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';
import 'package:dispacher_app/main.dart';


class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Color(MyApp().myred).withOpacity(0.9),
        child: Center(
          child:  SpinKitChasingDots(
            color: Colors.white,
            size: 50.0,
           ),
        ),
    );
  }
}