import 'package:flutter/material.dart';

import '../Constants/Styles.dart';

class SSLCustom extends StatelessWidget {
  const SSLCustom({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Row(
      children: [
        Icon(Icons.lock_outline, color: green,size: 20,),
        Text('SSL\nSecure', style: heading5TextSmall(width*0.7, font: 8),)
      ],
    );
  }
}
