import 'package:flutter/material.dart';
import 'package:zaki/Constants/HelperFunctions.dart';
import 'package:zaki/Constants/Styles.dart';

class TermsAndConditionsSmallText extends StatelessWidget {
  const TermsAndConditionsSmallText({
    Key? key,
    required this.width,
  }) : super(key: key);

  final double width;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return InkWell(
      onTap: () async{
        await teamViewMethod(context: context , height: height,width: width, url: "https://zakipay.com/terms-conditions/");
      },
      child: Text(
        '*Terms & Conditions Applied ',
        style: heading4TextSmall(width, underline: true),
        textAlign: TextAlign.justify,
      ),
    );
  }


}