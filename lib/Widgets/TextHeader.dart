import 'package:flutter/material.dart';

import '../Constants/Styles.dart';

class TextHeader1 extends StatelessWidget {
  const TextHeader1({
    Key? key,
    this.title
  }) : super(key: key);
  final String? title;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Text(
      '$title',
      style: heading1TextStyle(context, width),
      textAlign: TextAlign.center,
      );
  }
}

class TextValue1 extends StatelessWidget {
  const TextValue1({
    Key? key,
    this.title
  }) : super(key: key);
  final String? title;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Text(
      '$title',
      style: heading2TextStyle(context, width),
      textAlign: TextAlign.center,
      );
  }
}

class TextValue2 extends StatelessWidget {
  const TextValue2({
    Key? key,
    this.title,
    this.color
  }) : super(key: key);
  final String? title;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Text(
      '$title',
      style: heading3TextStyle(width, color: color),
      // textAlign: TextAlign.center,
      );
  }
}

class TextValue3 extends StatelessWidget {
  const TextValue3({
    Key? key,
    this.title
  }) : super(key: key);
  final String? title;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Text(
      '$title',
      style: heading4TextSmall(width),
      
      );
  }
}