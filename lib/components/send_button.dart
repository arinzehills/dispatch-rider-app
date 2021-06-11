import 'package:flutter/material.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';
import 'dart:math';

class MySendButton extends StatefulWidget {
  String placeHolder;
  final int id;
    final Function pressed;
     MySendButton({
       this.placeHolder,this.pressed,this.id
     });
  @override
  _MySendButtonState createState() => _MySendButtonState();
}

class _MySendButtonState extends State<MySendButton> {
  ButtonState stateOnlyText = ButtonState.idle;
  ButtonState stateTextWithIcon = ButtonState.idle;
    
  @override
  Widget build(BuildContext context) {
    return Container(
              padding: EdgeInsets.all(20.0),
                              child: SizedBox(
                                width: double.infinity,
                                height: 50.0,
                                child: ProgressButton.icon(iconedButtons: {
          ButtonState.idle: IconedButton(
              text: widget.placeHolder,
              icon: Icon(Icons.send, color: Colors.white),
              color: Color(int.parse("0xffe37029"))
              ),
          ButtonState.loading:
              IconedButton(text: 'Loading', color: Colors.deepPurple.shade700),
          ButtonState.fail: IconedButton(
              text: 'Failed',
              icon: Icon(Icons.cancel, color: Colors.white),
              color: Colors.red.shade300),
          ButtonState.success: IconedButton(
              text: 'Success',
              icon: Icon(
                Icons.check_circle,
                color: Colors.white,
              ),
              color: Colors.green.shade400)
        }, onPressed: onPressedIconWithText, state: stateTextWithIcon,
        ),
      ),
    );
  }

    // onPressedIconWithText(Function pressed){
    //     stateTextWithIcon = ButtonState.idle;
    //   if(pressed==null){
    //     setState(() {
    //       stateTextWithIcon = ButtonState.idle;
    //     });
    //   }
    //   else if(pressed!=null){
    //     setState(() {
    //       stateTextWithIcon = ButtonState.loading;
    //       if(pressed==widget.pressed){
    //         setState(() {
    //             stateTextWithIcon = ButtonState.success;
    //             return pressed;
    //         });
    //       }
    //     });
    //   }
    // }
  onPressedIconWithText() {
    switch (stateTextWithIcon) {
      case ButtonState.idle:
        stateTextWithIcon = ButtonState.loading;
        Future.delayed(
          Duration(seconds: 1),
          () {
            setState(
              () {
                
                widget.pressed ==null ? stateTextWithIcon =  ButtonState.success
                    :stateTextWithIcon= ButtonState.fail;
              },
            );
          },
        );

        break;
      case ButtonState.loading:
        break;
      case ButtonState.success:
        return widget.pressed;
         stateTextWithIcon = ButtonState.idle;
                
        break;
      case ButtonState.fail:
        stateTextWithIcon = ButtonState.idle;
        break;
    }
    setState(
      () {
        stateTextWithIcon = stateTextWithIcon;
       
      },
    );
    return widget.pressed;
  }
}