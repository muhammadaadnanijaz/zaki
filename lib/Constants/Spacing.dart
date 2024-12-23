import 'package:flutter/material.dart';
import '../Widgets/CustomSizedBox.dart';

Widget spacing_small = CustomSizedBox001();
Widget spacing_medium = SpacingMedium();
Widget spacing_large = SpacingLarge();
Widget spacing_X_large =  CustomSizedBox006();


Widget textValueHeaderbelow = CustomSizedBox001();
Widget textValueBelow = spacing_large;
Widget textValueHeaderAbove = CustomSizedBox006();

EdgeInsets getCustomPadding(){
 return EdgeInsets.symmetric(horizontal: 18, vertical: 0);

}




