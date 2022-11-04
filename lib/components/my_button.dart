import 'package:flutter/material.dart';


class MyButton extends StatelessWidget {
  String placeHolder;
  final Function pressed;
  
  MyButton({
    this.placeHolder, this.pressed,
  });
  

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.0),
                            child: RaisedButton(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                  onPressed: pressed,
                                  color: Color(int.parse("0xffe37029")),
                                  child: Text(
                                    placeHolder,
                                      style:TextStyle(
                                        color:Colors.white,
                                      ),

                                  ),
                                

                                ),
    );
  }
}