import 'package:flutter/material.dart';
import '../Constants/Styles.dart';

class ProfileListTileButton extends StatelessWidget {
  const ProfileListTileButton(
      {Key? key, required this.width, this.icon, this.title, this.onTap, this.color, this.tralingIcon})
      : super(key: key);

  final double width;
  final IconData? icon;
  final String? title;
  final VoidCallback? onTap;
  final Color? color;
  final IconData? tralingIcon;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: InkWell(
            onTap: onTap,
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: color!=null? color: green,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Icon(
                      icon,
                      color: white,
                      // size: ,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    '$title',
                    style: heading3TextStyle(width),
                  ),
                ),
                const Spacer(),
                Icon(
                  tralingIcon ?? Icons.arrow_forward,
                  color: grey,
                  // size: width * 0.05,
                )
              ],
            ),
          ),
        ),
        // Container(
        //   color: black,
        //   height: 0.07,
        //   width: width,
        // )
      ],
    );
  }
}
