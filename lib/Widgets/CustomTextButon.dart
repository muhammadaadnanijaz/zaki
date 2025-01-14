
import 'package:flutter/material.dart';
import '../Constants/Styles.dart';
import 'TextHeader.dart';

class CustomTextButton extends StatelessWidget {
  const CustomTextButton(
      {Key? key, required this.width, this.title, this.onPressed})
      : super(key: key);

  final double width;
  final String? title;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: TextValue3(
            title: '$title',
          ),
        ),
      ),
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(grey.withValues(alpha:0.2)),
        shape: WidgetStateProperty.all(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14.0),
          // side: BorderSide(color: black),
        )),
      ),
      onPressed: onPressed,
    );
  }
}