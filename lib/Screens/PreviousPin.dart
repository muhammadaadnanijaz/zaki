// ignore_for_file: file_names

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:zaki/Constants/AppConstants.dart';
import 'package:zaki/Constants/NotificationTitle.dart';
import 'package:zaki/Constants/Spacing.dart';
import 'package:zaki/Constants/Styles.dart';
import 'package:zaki/Screens/RestPinCode.dart';
import 'package:zaki/Services/api.dart';
import 'package:zaki/Widgets/TextHeader.dart';
// import 'package:zaki/Widgets/ZakiPrimaryButton.dart';
import '../Constants/HelperFunctions.dart';
import '../Widgets/AppBars/AppBar.dart';
import '../Widgets/SSLCustom.dart';

class PreviousPinCode extends StatefulWidget {
  const PreviousPinCode({
    Key? key,
  }) : super(key: key);

  @override
  _PreviousPinCodeState createState() => _PreviousPinCodeState();
}

class _PreviousPinCodeState extends State<PreviousPinCode> {
  // ignore: non_constant_identifier_names
  final restConfirmPinCodeCodeFormKey = GlobalKey<FormState>();
  bool obSecureFields = true;
  final pinCodeController = TextEditingController();
  @override
  void dispose() {
    pinCodeController.dispose();
    super.dispose();
  }

  void clearFields() {
    pinCodeController.text = '';
  }

  @override
  Widget build(BuildContext context) {
    var appConstants = Provider.of<AppConstants>(context, listen: true);
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
        body: SafeArea(
            child: Padding(
      padding: getCustomPadding(),
      child: SingleChildScrollView(
        child: Form(
          key: restConfirmPinCodeCodeFormKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              appBarHeader_005(
                  context: context,
                  appBarTitle: 'Current PIN Code',
                  backArrow: false,
                  height: height,
                  width: width,
                  leadingIcon: true,
                  tralingIconButton: SSLCustom()
                  ),
              spacing_medium,
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Image.asset(imageBaseAddress + "pin_code_logo.png",
                        height: 35),
                  ),
                  Text(
                    'Bulletproof Security',
                    style: heading3TextStyle( width),
                  ),
                ],
              ),
              spacing_large,

              Container(
                color: transparent,
                // margin: const EdgeInsets.all(20.0),
                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                child: Pinput(
                  length: appConstants.userModel.usaPinCodeLength!.toInt(),
                  controller: pinCodeController,
                  autofocus: true,
                  errorTextStyle: heading4TextSmall(width, color: red),
                  obscuringCharacter: '*',
                  obscureText: true,
                  pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                  validator: (String? pin) {
                    if (pin!.isEmpty) {
                      return 'Enter a PIN Code';
                    } else if ((appConstants.userModel.usaPinCodeLength!
                                    .toInt() ==
                                4 &&
                            pin.length < 4) ||
                        (appConstants.userModel.usaPinCodeLength!.toInt() ==
                                6 &&
                            pin.length < 6)) {
                      return 'Enter full PIN Code';
                    } else if (appConstants.userModel.usaPinCode !=
                        encryptedValue(value: pin)) {
                      return 'PIN Code did not match, try again.';
                    }  else {
                      return null;
                    }
                  },
                  onChanged: (String pin) {},
                  onCompleted: (String pin){
                    if(pinCodeController.text.isEmpty ||
                          (appConstants.userModel.usaPinCodeLength == 4 &&
                              pinCodeController.text.length < 4) ||
                          (appConstants.userModel.usaPinCodeLength == 6 &&
                              pinCodeController.text.length < 6) ||
                          (appConstants.userModel.usaPinCode !=
                              encryptedValue(value: pinCodeController.text))){
                                return;
                              }
                    else{
                      if (!restConfirmPinCodeCodeFormKey.currentState!
                              .validate()) {
                            showNotification(
                                error: 1,
                                icon: Icons.error,
                                message: NotificationText.ENTER_PIN);
                            return;
                          } else {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RestPinCode(
                                          fromKidsSignUpPage: 3,
                                        )));
                          }
                    }
                  },
                ),
              ),
              spacing_medium,
              if(appConstants.userModel.usaTouchEnable != null && appConstants.userModel.usaTouchEnable!)
              Row(
                // mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                // crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  InkWell(
                        onTap: () async {
                                      if (appConstants.userModel.usaTouchEnable != null &&
                                          appConstants.userModel.usaTouchEnable!) {
                                        bool isAuth =
                                            await ApiServices().userLoginBioMetric();
                                        if (isAuth) {
                                          Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => RestPinCode(
                                              fromKidsSignUpPage: 3,
                                            )));
                                        } else {
                                          // showSnackBarDialog(
                                          //     context: context,
                                          //     message: 'Ooops...Something went wrong');
                                        }
                                      } else {
                                        showSnackBarDialog(
                                            context: context,
                                            message: "You haven't enabled Biometric");
                                      }
                                    },
                        child: Container(
                          decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    border:Border.all(color: green)
                                  ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 5.0),
                                  child: InkWell(
                                    onTap: () async {
                                      if (appConstants.userModel.usaTouchEnable != null &&
                                          appConstants.userModel.usaTouchEnable!) {
                                        bool isAuth =
                                            await ApiServices().userLoginBioMetric();
                                        if (isAuth) {
                                          Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => RestPinCode(
                                                    fromKidsSignUpPage: 3,
                                                  )));
                                        } else {
                                          // showSnackBarDialog(
                                          //     context: context,
                                          //     message: 'Ooops...Something went wrong');
                                        }
                                      } else {
                                        showSnackBarDialog(
                                            context: context,
                                            message: "You haven't enabled Biometric");
                                      }
                                    },
                                    child: Icon(
                                      Platform.isAndroid?Icons.fingerprint:Icons.camera_alt,
                                      color: green,
                                      size: width * 0.08,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 5.0),
                                  child: TextValue1(
                                    title:Platform.isAndroid? 'Touch ID':'Face ID',
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                ],
              ),
                  
              // ZakiPrimaryButton(
              //     title: 'Confirm',
              //     width: width,
              //     onPressed: (pinCodeController.text.isEmpty ||
              //             (appConstants.userModel.usaPinCodeLength == 4 &&
              //                 pinCodeController.text.length < 4) ||
              //             (appConstants.userModel.usaPinCodeLength == 6 &&
              //                 pinCodeController.text.length < 6) ||
              //             (appConstants.userModel.usaPinCode !=
              //                 encryptedValue(value: pinCodeController.text)))
              //         ? null
              //         : () async {
                        
              //             if (!restConfirmPinCodeCodeFormKey.currentState!
              //                 .validate()) {
              //               showNotification(
              //                   error: 1,
              //                   icon: Icons.error,
              //                   message: NotificationText.ENTER_PIN);
              //               return;
              //             } else {
              //               Navigator.push(
              //                   context,
              //                   MaterialPageRoute(
              //                       builder: (context) => RestPinCode(
              //                             fromKidsSignUpPage: 3,
              //                           )));
              //             }
              //           })
              //   SizedBox(
              //     height: height*0.3,
              //   ),
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
              // ZakiPrimaryButton(
              //   title: 'Confirm',
              //   width: width,
              //   onPressed: (){
              //     Navigator.pop(context, pinCodeController.text);
              //   })
            ],
          ),
        ),
      ),
    )));
  }
}

