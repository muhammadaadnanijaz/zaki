import 'package:flutter/material.dart';

import '../Constants/HelperFunctions.dart';

class UnSelectedKidsWidget extends StatelessWidget {
  const UnSelectedKidsWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      width: 70,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: unSelectedKidGreadient(),
      ),
    );
  }
}