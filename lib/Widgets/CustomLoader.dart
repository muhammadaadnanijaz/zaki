import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:zaki/Constants/Styles.dart';
class CustomLoader extends StatelessWidget {
  const CustomLoader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LoadingAnimationWidget.threeRotatingDots(
      color: green,
      size: 50
    );
  }
}