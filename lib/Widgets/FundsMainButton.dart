import 'package:flutter/material.dart';

import '../Constants/Styles.dart';

class FundsMainButton extends StatelessWidget {
  const FundsMainButton(
      {Key? key,
      required this.height,
      required this.width,
      required this.color,
      this.title,
      this.onTap})
      : super(key: key);

  final double height;
  final double width;
  final Color color;
  final String? title;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Container(
          height: height * 0.14,
          decoration: BoxDecoration(
            color: green.withValues(alpha:0.02),
            borderRadius: BorderRadius.circular(width*0.04),
            border: Border.all(color: green.withValues(alpha:0.3)),
              // image: DecorationImage(
              //     image: AssetImage(imageBaseAddress + 'manage_home.png'))
                  ),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.all(8),
                  child: Text(
                    '$title',
                    style: heading3TextStyle(width),
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
