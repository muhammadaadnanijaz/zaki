import 'package:flutter/material.dart';
import 'package:zaki/Constants/Styles.dart';

class LoginCircularButton extends StatelessWidget {
  const LoginCircularButton(
      {Key? key,
      this.width,
      this.title,
      this.iconData,
      this.border,
      required this.onPressed})
      : super(key: key);

  final double? width;
  final String? title;
  final IconData? iconData;
  final VoidCallback onPressed;
  final int? border;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        child: Row(
          children: [
            Icon(
              iconData,
              color: border == 1 ? black : white,
            ),
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text("$title",
                      style: textStyleHeading1WithTheme(context, width! * 0.8,
                          whiteColor: border == 1 ? 0 : 1,
                          isUnderline: border == 1 ? 0 : 1)),
                ),
              ),
            ),
          ],
        ),
        style: ElevatedButton.styleFrom(
            backgroundColor: border == 1 ? white : black.withValues(alpha:0.2),
            //  side: BorderSide(width: 2, color: black)
            shape: StadiumBorder(
                side: BorderSide(
              color: border == 1 ? black : transparent,
            ))),
        onPressed: onPressed);
  }
}
