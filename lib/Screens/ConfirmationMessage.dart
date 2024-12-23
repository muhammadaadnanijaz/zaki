import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zaki/Constants/HelperFunctions.dart';
import 'package:zaki/Widgets/ZakiPrimaryButton.dart';
import '../Constants/Spacing.dart';
import '../Constants/Styles.dart';
import '../Widgets/AppBars/AppBar.dart';

class ConfirmationMessage extends StatefulWidget {
  const ConfirmationMessage({ Key? key }) : super(key: key);

  @override
  State<ConfirmationMessage> createState() => _ConfirmationMessageState();
}

class _ConfirmationMessageState extends State<ConfirmationMessage> {
  @override
  Widget build(BuildContext context) {
    // var appConstants = Provider.of<AppConstants>(context, listen: true);
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              appBarHeader_005(context: context, appBarTitle: 'Mission Accomplished!', height: height, width: width, leadingIcon: false),
              // SizedBox(height: height*0.1,),
              Image.asset(imageBaseAddress+'send_message.png' ),
              Text(
                'Text Message sent to your Parent!',
                style: heading1TextStyle(context, width),
                ),
              Divider(height: 0.01,color: grey,),
              Text(
                'Make sure to nag them every 2 & 1/2 hours :)',
                style: heading3TextStyle(width),
                textAlign: TextAlign.center,
                ),
                Column(
                  children: [
                    ZakiPrimaryButton(
                      title: 'Become Financially Smart!',
                      width: width,
                      onPressed: (){
                        openUrl(url: 'https://zakipay.com/blog');
                      },
                    ),
                  spacing_medium,
                  ZakiPrimaryButton(
                    title: 'Close ZakiPay',
                    width: width,
                    onPressed:(){
                      SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                              // getPhoneNumber(number: numberController.text)
                          
                          },
                  )
                  ],
                ),
                SizedBox(height: height*0.05,)
              // 
            ],
          ),
        ),
      ),
    );
  }
}