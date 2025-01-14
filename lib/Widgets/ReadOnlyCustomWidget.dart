import 'package:flutter/material.dart';
import 'package:zaki/Constants/Spacing.dart';
import 'package:zaki/Constants/Styles.dart';

class ReadOnlyCustomWidget extends StatelessWidget {
  const ReadOnlyCustomWidget({
    Key? key,
    required this.width,
    required this.height,
  }) : super(key: key);

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.lock_outline_sharp,
              color: borderColor,
              size: width*0.4,
              ), 
              spacing_small,
              Text(
                'You can\'t edit',
                style: heading1TextStyle(context, width, color: grey.withValues(alpha:0.5)),
                )
          ],
        ),
      ),
    );
  }
}