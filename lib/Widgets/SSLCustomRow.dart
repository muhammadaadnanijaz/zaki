import 'package:flutter/material.dart';

import '../Constants/Styles.dart';

class SSLCustomRow extends StatelessWidget {
  const SSLCustomRow({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomImage(imageUrl: 'ssl.png'),
        // Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 4.0),
        //   child: Row(
        //     children: [
        //       Padding(
        //         padding: const EdgeInsets.symmetric(horizontal: 4.0),
        //         child: CustomImage(imageUrl: 'cashback.png'),
        //       ),
        //       TextValue3(
        //         title: ' Safe and Secure payments')
        //     ],
        //   ),
        // ),

        // CustomImage(imageUrl: 'shield.png'),
        
      ],
    );
  }
}

class CustomImage extends StatelessWidget {
  final String? imageUrl;
  const CustomImage({Key? key, this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      imageBaseAddress+imageUrl!, 
      height: 30,
      width: 100,
      // color: grey.withValues(alpha:0.3),
      );
  }
}