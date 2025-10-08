import 'package:flutter/material.dart';
import 'package:zaki/Constants/HelperFunctions.dart';

import '../Constants/Styles.dart'; 
 
 BoxDecoration cardBackgroundConatiner(double width, Color backGroundColor, { required String? backgroundImageUrl}) {
  logMethod(message: "image: $backgroundImageUrl", title: "image");

    return BoxDecoration(
              // color: backGroundColor,
              borderRadius: BorderRadius.circular(width*0.03),
              image: 
              (backgroundImageUrl!.contains('assets/images/') || (backgroundImageUrl==""))?
              DecorationImage(
                image: 
                AssetImage(  backgroundImageUrl=="" ? cardImagesBaseAddress+"ZakiPayNoDebitCard.png" : backgroundImageUrl),
                fit: BoxFit.fill,
                // scale: 1
              ):
              DecorationImage(image: NetworkImage(backgroundImageUrl), fit: BoxFit.fill,)
              ,
             );
  }