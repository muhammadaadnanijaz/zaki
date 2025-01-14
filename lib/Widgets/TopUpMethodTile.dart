import 'package:flutter/material.dart';
import 'package:zaki/Constants/Styles.dart';

class TopUpMethodTile extends StatelessWidget {
  const TopUpMethodTile(
      {Key? key,
      required this.onTap,
      required this.icon,
      required this.title,
      this.width})
      : super(key: key);

  final VoidCallback? onTap;
  final IconData? icon;
  final String title;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: transparent,
          borderRadius: BorderRadius.circular(width! * 0.03),
          border: Border.all(color: grey.withValues(alpha:0.4))),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: black),
        title: Text('$title', style: heading3TextStyle(width!)),
        trailing: Icon(
          Icons.arrow_forward,
          color: grey,
          size: 20,
        ),
      ),
    );
  }
}