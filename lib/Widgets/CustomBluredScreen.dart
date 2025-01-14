import 'package:flutter/material.dart';
import 'package:zaki/Constants/Styles.dart';

class CustomBluredScreen extends StatelessWidget {
  const CustomBluredScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
        var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Container(
      height: height*0.9,
      color: grey.withValues(alpha:0.7),
      width: width,
      child: Icon(
        Icons.lock, 
        size: 200,
        color: darkGrey,
        ),
    );
  }
}