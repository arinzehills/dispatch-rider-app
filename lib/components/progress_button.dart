import 'package:dispacher_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_button/flutter_progress_button.dart';


class MyProgressButton extends StatefulWidget {
  String placeHolder;
  final Function pressed;
  
  MyProgressButton({
    this.placeHolder, this.pressed,
  });

  @override
  _MyProgressButtonState createState() => _MyProgressButtonState();
}

class _MyProgressButtonState extends State<MyProgressButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.0),
                              child: SizedBox(
                                width: double.infinity,
                                height: 50.0,
                                child:ProgressButton(
                                
                                  color: Color(int.parse("0xffe37029")),
                                  defaultWidget: Text(
                                    widget.placeHolder,
                                      style:TextStyle(
                                        color:Colors.white,
                                      ),
                                     ),
                                     progressWidget: const CircularProgressIndicator(
                                      
                                       backgroundColor: Colors.white,),
                                     width: 200,
                                      height: 40,
                                      borderRadius: 50,
                                      onPressed: () async {
                                        int score = await Future.delayed(
                                            const Duration(milliseconds: 1000), () => 42);
                                        return widget.pressed;
                                      }
                                ),

                                ),
    );
  }
}