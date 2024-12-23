import 'package:flutter/material.dart';
import 'package:zaki/Constants/Styles.dart';
class StateSuffixIcon extends StatelessWidget {
  const StateSuffixIcon({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.arrow_downward, color: grey,)
        ],
      ),
    );
  }
}