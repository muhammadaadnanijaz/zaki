
import 'package:flutter/material.dart';
import 'package:zaki/Constants/Whitelable.dart';

class CustomLoadingScreen extends StatelessWidget {
  const CustomLoadingScreen({
    Key? key,
    this.small
  }) : super(key: key);
  final bool? small;

  @override
  Widget build(BuildContext context) {
    return Container(
      //  decoration: BoxDecoration(
      //     image: DecorationImage(
      //   image: AssetImage(
      //     imageBaseAddress + "blur.png",
      //   ),
      //   // filterQuality: FilterQuality.high,
      //   fit: BoxFit.contain,
      // )
      // ),
      child: Center(
        child: Image.asset(
          APPLICATION_LOADING_IMAGE,
          height: small!=null ? 100: 200,
          )),
    );
  }
}