
import 'package:flutter/material.dart';

import '../Constants/Styles.dart';

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
          imageBaseAddress+'loading_screen_transparent.gif',
          height: small!=null ? 100: 200,
          )),
    );
  }
}