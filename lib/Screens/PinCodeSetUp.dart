import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:zaki/Constants/AppConstants.dart';
import 'package:zaki/Constants/HelperFunctions.dart';
// import 'package:zaki/Constants/NotificationTitle.dart';
import 'package:zaki/Constants/Spacing.dart';
import 'package:zaki/Constants/Styles.dart';
// import 'package:zaki/Screens/AccountSetUpInformation.dart';
// import 'package:zaki/Screens/AccountSetupAsaKid.dart';
import 'package:zaki/Screens/ConfirmPin.dart';
import 'package:zaki/Widgets/EnableBioMetricWidget.dart';
import 'package:zaki/Widgets/ZakiPrimaryButton.dart';
import 'package:zaki/Constants/Whitelable.dart';

import '../Widgets/AppBars/AppBar.dart';

enum SingingCharacter { four, six }

class PinCodeSetUp extends StatefulWidget {
  final int? fromKidsSignUpPage;
  final bool? fromActivate;
  final String? userId;
  final bool? secondryPinCodeUser;
  const PinCodeSetUp(
      {Key? key, this.fromKidsSignUpPage, this.fromActivate, this.userId, this.secondryPinCodeUser})
      : super(key: key);

  @override
  _PinCodeSetUpState createState() => _PinCodeSetUpState();
}

class _PinCodeSetUpState extends State<PinCodeSetUp> {
  late SingingCharacter? pinLength = SingingCharacter.four;
  final pinCodeFormKey = GlobalKey<FormState>();
  // bool appConstants.isTouchEnable=false;

  bool obSecureFields = true;
  final pinCodeController = TextEditingController();
  //   @override
  // void dispose() {
  //   pinCodeController.dispose();
  //   super.dispose();
  // }

  void clearFields() {
    pinCodeController.text = '';
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 200), () {
      setState(() {
        var appConstants = Provider.of<AppConstants>(context, listen: false);
        if (appConstants.pinLength == 4) {
          pinLength = SingingCharacter.four;
        } else {
          pinLength = SingingCharacter.six;
        }
        setState(() {});
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var appConstants = Provider.of<AppConstants>(context, listen: true);
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
        body: SafeArea(
            child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 0),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Form(
          key: pinCodeFormKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (widget.fromKidsSignUpPage == 0)
                appBarHeader_005(
                    context: context,
                    appBarTitle: 'Enter PIN Code',
                    backArrow: true,
                    height: height,
                    width: width,
                    leadingIcon: true),
              // SizedBox(
              //   height: height * 0.01,
              // ),
              // Row(
              //   crossAxisAlignment: CrossAxisAlignment.center,
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     Padding(
              //       padding: const EdgeInsets.all(4.0),
              //       child: Image.asset(imageBaseAddress + "pin_code_logo.png",
              //           height: 35),
              //     ),
              //     Text(
              //       'Bulletproof Security',
              //       style: heading2TextStyle(context, width),
              //     ),
              //   ],
              // ),
              widget.secondryPinCodeUser==true?
              spacing_X_large:
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (widget.fromKidsSignUpPage != 0)
                  Column(
                    children: [
                      spacing_medium,
                    EnableBioMetricWidget(appConstants: appConstants, width: width),
                    ],
                  ),
                    spacing_medium,
                    Text('-- & -- ', style: heading4TextSmall(width),),
                    spacing_medium,

                ],
              ),
              // SizedBox(
              //   height: height * 0.02,
              // ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Radio(
                      value: SingingCharacter.four,
                      groupValue: pinLength,
                      onChanged: (SingingCharacter? caha) {
                        clearFields();
                        appConstants.updatePinLength(4);
                        FocusScopeNode currentFocus = FocusScope.of(context);
                        if (!currentFocus.hasPrimaryFocus) {
                          currentFocus.unfocus();
                        }
                        setState(() {
                          pinLength = caha;
                        });
                      }),
                  Text(
                    '4-Digit PIN',
                    style: heading3TextStyle(width),
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  Radio(
                      value: SingingCharacter.six,
                      groupValue: pinLength,
                      onChanged: (SingingCharacter? caha) {
                        clearFields();
                        appConstants.updatePinLength(6);
                        FocusScopeNode currentFocus = FocusScope.of(context);
                        if (!currentFocus.hasPrimaryFocus) {
                          currentFocus.unfocus();
                        }
                        setState(() {
                          pinLength = caha;
                        });
                      }),
                  Text(
                    '6-Digit PIN',
                    style: heading3TextStyle(width),
                  ),
                ],
              ),

              Container(
                color: transparent,
                // margin: const EdgeInsets.all(20.0),
                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                child: Pinput(
                  autofocus: true,
                  errorTextStyle: heading4TextSmall(width, color: red),
                  pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                  obscuringCharacter: '*',
                  obscureText: true,
                  validator: (String? pin) {
                    if (pin!.isEmpty) {
                      return 'Enter a PIN Code';
                    } else if ((appConstants.pinLength == 4 &&
                            pin.length < 4) ||
                        (appConstants.pinLength == 6 && pin.length < 6)) {
                      return 'Enter full PIN Code';
                    } else {
                      return null;
                    }
                  },
                  // obscureText: appConstants.obSecurePin?null:'*',
                  // onSubmit: (String pin) => _showSnackBar(pin, context),
                  // focusNode: _pinPutFocusNode,
                  length: appConstants.pinLength,
                  controller: pinCodeController,
                  onChanged: (String pin) {
                    appConstants.updateExactPinCode(pin);
                    appConstants.updatePin(encryptedValue(value: pin));
                  },
                  onCompleted: (complete) async {
                    if (widget.fromKidsSignUpPage == 0) {
                      var respose = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ConfirmPin(
                                    fromKidsSignUpPag: 0,
                                    fromActivate: widget.fromActivate == true
                                        ? true
                                        : false,
                                    userId: widget.userId,
                                  )));
                      if (respose == "Matched") {
                        Navigator.pop(context, "Matched");
                      }
                    } else{
                      try {
                        // appConstants.updateIndex(appConstants.selectedIndex+1);
                        // Future.delayed(Duration(milliseconds: 500), (){
                        //   pageControllerParent.jumpToPage(appConstants.selectedIndex);
                        //   pageController.jumpToPage(appConstants.selectedIndex);
                        // });
                        
                      } catch (e) {
                        appConstants.updateIndex(appConstants.selectedIndex+1);
                        logMethod(title: 'Exception is thrown', message: e.toString());
                      }
                      
                    }
                  },
                ),
              ),
              textValueBelow,
              if (widget.fromKidsSignUpPage == 0)
                ZakiPrimaryButton(
                    width: width,
                    title: 'Next',
                    onPressed: (pinCodeController.text.isEmpty ||
                            (appConstants.pinLength == 4 &&
                                pinCodeController.text.length < 4) ||
                            (appConstants.pinLength == 6 &&
                                pinCodeController.text.length < 6))
                        ? null
                        : () async {
                            if (pinCodeFormKey.currentState!.validate()) {
                              return;
                            }
                            int length = pinCodeController.text.length;
                            if (pinCodeController.text.isEmpty) {
                              showNotification(
                                  error: 1,
                                  icon: Icons.check,
                                  message: NotificationText.ENTER_PIN);

                              return;
                            } else if ((appConstants.pinLength == 4 &&
                                    length < 4) ||
                                (appConstants.pinLength == 6 && length < 6)) {
                              showNotification(
                                  error: 1,
                                  icon: Icons.check,
                                  message: NotificationText.ENTER_PIN);
                              return;
                            }
                            var respose = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ConfirmPin(
                                          fromKidsSignUpPag: 0,
                                          fromActivate:
                                              widget.fromActivate == true
                                                  ? true
                                                  : false,
                                          userId: widget.userId,
                                        )));
                            if (respose == "Matched") {
                              Navigator.pop(context, "Matched");
                            }
                          }),
              spacing_large,
              
              SizedBox(
                height: height * 0.2,
              ),

              // TextButton(
              //   onPressed: (){
              //     appConstants.updatePinObsecure(appConstants.obSecurePin);
              //   },
              // child: Center(
              //   child: Text(
              //     'Show Pin',
              //     style: textStyleHeading2WithTheme(context,width, whiteColor: 0),
              //     ),
              // ),
              // ),
              /////
              /////////////////////Confermation button
              ///
              // ZakiPrimaryButton(
              //   title: 'Next',
              //   width: width,
              //   onPressed: ()async{
              //     print('length of code: ${pinCodeController.text.length} and pin lenght: ${appConstants.pinLength}');
              //     if (appConstants.pinLength== pinCodeController.text.length) {
              //     var response = await Navigator.push(context, MaterialPageRoute(builder: (context)=>const ConfirmPin()));
              //     print('After response pin: $response');
              //     if (response!=null) {
              //       if (response==pinCodeController.text) {
              //         showSnackBarDialog(context: context, message: 'Pin Matched Successfully');
              //         Future.delayed(const Duration(milliseconds: 500),(){
              //           Navigator.push(context, MaterialPageRoute(builder: (context)=>const FingerPrintAuth()));
              //         });
              //       }
              //       else{
              //         showSnackBarDialog(context: context, message: 'Pin not matched');
              //       }
              //     }
              //     else{
              //       showSnackBarDialog(context: context, message: 'Pin not matched');
              //     }
              //     return;
              //     } else{
              //       showSnackBarDialog(context: context, message: 'Fill all the fields');
              //     }
              //   })
            ],
          ),
        ),
      ),
    )));
  }
}

