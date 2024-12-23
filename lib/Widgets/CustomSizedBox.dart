import 'package:flutter/material.dart';

class SpacingMedium extends StatelessWidget {
  const SpacingMedium({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return SizedBox(height: height*0.02,);
  }
}

class SpacingLarge extends StatelessWidget {
  const SpacingLarge({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return SizedBox(height: height*0.045,);
  }
}
class SixBoxSpacing extends StatelessWidget {
  const SixBoxSpacing({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return SizedBox(height: height*0.06,);
  }
}

class CustomSizedBox extends StatelessWidget {
  const CustomSizedBox({
    Key? key,
    this.height
  }) : super(key: key);
  final double? height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: height!*0.02,);
  }
}

class CustomSizedBox001 extends StatelessWidget {
  const CustomSizedBox001({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return SizedBox(height: height*0.007,);
  }
}
class Small extends StatelessWidget {
  const Small({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return SizedBox(height: height*0.001,);
  }
}

class CustomSizedBox002 extends StatelessWidget {
  const CustomSizedBox002({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return SizedBox(height: height*0.04,);
  }
}

class CustomSizedBox006 extends StatelessWidget {
  const CustomSizedBox006({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return SizedBox(height: height*0.07,);
  }
}