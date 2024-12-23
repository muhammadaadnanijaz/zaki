import '../Constants/Styles.dart';
import 'package:flutter/material.dart';
class PrivacyTypeButton extends StatelessWidget {
  const PrivacyTypeButton(
      {Key? key,
      required this.width,
      this.onTap,
      this.selected,
      this.icon,
      this.title,
      this.subTitle,
      this.tralingIcon})
      : super(key: key);

  final double width;
  final VoidCallback? onTap;
  final int? selected;
  final IconData? icon;
  final String? title;
  final String? subTitle;
  final IconData? tralingIcon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            color: selected == 1 ? blue : transparent,
            border: Border.all(
              color: selected == 1 ? black : grey,
            ),
            borderRadius: BorderRadius.circular(20)
            ),
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: ListTile(
            leading: Icon(icon, color: selected == 1?white: blue),
            title: Text(
              title!,
              style: textStyleHeading2WithTheme(context, width * 0.9,
                  whiteColor: selected == 1 ? 1 : 0),
            ),
            // subtitle: Text(
            //   subTitle!,
            //   style: textStyleHeading2WithTheme(context, width * 0.6,
            //       whiteColor: selected == 1 ? 1 : 2),
            // ),
            trailing: tralingIcon != null
                ? Icon(
                    Icons.arrow_forward,
                    color: selected == 1 ?white: selected == 2 ? green: blue,
                  )
                : null,
          ),
        ),
      ),
    );
  }
}
