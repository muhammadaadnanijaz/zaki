import 'package:feedback/feedback.dart';
import 'package:flutter/material.dart';
import 'package:zaki/Constants/HelperFunctions.dart';
import 'package:zaki/Constants/Styles.dart';
class CustomFloadtingActionButton extends StatelessWidget {
  const CustomFloadtingActionButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        onPressed: () async{
          BetterFeedback.of(context).show((UserFeedback feedback) {
            
            sendEmail(feedback.screenshot, feedback.text);    
            });
        },
        // highlightElevation: 5,
        backgroundColor: transparent,
        elevation: 20,
        child: Image.asset(imageBaseAddress + "zakipay_logo.png"),
      );
  }
}
