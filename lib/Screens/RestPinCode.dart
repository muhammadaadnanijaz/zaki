import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:zaki/Constants/AppConstants.dart';
import 'package:zaki/Constants/HelperFunctions.dart';
import 'package:zaki/Constants/Spacing.dart';
import 'package:zaki/Constants/Styles.dart';
import 'package:zaki/Screens/RestPinCodeConfirm.dart';
import 'package:zaki/Widgets/SSLCustom.dart';
import 'package:zaki/Widgets/TextHeader.dart';
// import 'package:zaki/Widgets/ZakiPrimaryButton.dart';

import '../Widgets/AppBars/AppBar.dart';

enum SingingCharacter { four, six }

class RestPinCode extends StatefulWidget {
  final int? fromKidsSignUpPage;
  final bool? fromReset;
  final String? userId;
  const RestPinCode({Key? key, this.fromKidsSignUpPage, this.fromReset, this.userId})
      : super(key: key);

  @override
  _RestPinCodeState createState() => _RestPinCodeState();
}

class _RestPinCodeState extends State<RestPinCode> {
  final pinCodeFormKey = GlobalKey<FormState>();
  late SingingCharacter? pinLength = SingingCharacter.four;

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
      padding: getCustomPadding(),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Form(
          key: pinCodeFormKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              appBarHeader_005(
                  context: context,
                  appBarTitle: 'New PIN Code',
                  backArrow: false,
                  height: height,
                  width: width,
                  leadingIcon: true,
                  tralingIconButton: SSLCustom()
                  ),
              spacing_large,
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
                    style: heading3TextStyle(width),
                  ),
                ],
              ),
              spacing_large,
              // if (widget.fromKidsSignUpPage == 3)
              //   TextValue2(
              //     title: 'Enter New Pin Code',
              //   ),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                    TextValue2(
                      title: '4 Pin Code',
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    // if(widget.fromReset!=true)
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
                    TextValue2(
                      title: '6 Pin Code',
                    ),
                  ],
                ),
              ),

              Container(
                color: transparent,
                // margin: const EdgeInsets.all(20.0),
                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                child: Pinput(
                  autofocus: true,
                  obscuringCharacter: '*',
                  errorTextStyle: heading4TextSmall(width, color: red),
                  obscureText: true,
                  pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                  validator: (String? pin) {
                    if (pin!.isEmpty) {
                      return 'Enter PIN Code';
                    } else if ((appConstants.pinLength == 4 &&
                            pin.length < 4) ||
                        (appConstants.pinLength == 6 && pin.length < 6)) {
                      return 'Enter full PIN Code';
                    } else if (appConstants.userModel.usaPinCode ==
                        encryptedValue(value: pin)) {
                      return "Can't use Current PIN Code";
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
                    appConstants.updatePin(encryptedValue(value: pin));
                  },
                  onCompleted: (String pin){
                    if (!pinCodeFormKey.currentState!.validate()) {
                            return;
                          } else {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                         RestConfirmPinCode(userId:widget.userId)));
                          }
                  },
                ),
              ),
              // SizedBox(
              //   height: height * 0.015,
              // ),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 8),
              //   child: Row(
              //     children: [
              //       IconButton(
              //         icon: Icon(
              //           Icons.fingerprint,
              //           color: green,
              //           size: width * 0.1,
              //         ),
              //         onPressed: () async {
              //           bool isAuth = await ApiServices().userLoginBioMetric();
              //           if (isAuth) {
              //             appConstants.updateToucheds(isAuth);
              //             showSnackBarDialog(
              //                 context: context,
              //                 message: 'Biomettric is enabled');
              //           } else {
              //             showSnackBarDialog(
              //                 context: context,
              //                 message: 'Ooops...Something went wrong :(');
              //           }
              //         },
              //       ),
              //       Expanded(
              //           child: Padding(
              //         padding: const EdgeInsets.only(left: 4.0),
              //         child: TextValue3(
              //           title: 'Use Biometrics',
              //         ),
              //       ))
              //     ],
              //   ),
              // ),

              spacing_medium,
              // ZakiPrimaryButton(
              //     title: 'Update',
              //     width: width,
              //     onPressed: (pinCodeController.text.isEmpty ||
              //             (appConstants.pinLength == 4 &&
              //                 pinCodeController.text.length < 4) ||
              //             (appConstants.pinLength == 6 &&
              //                 pinCodeController.text.length < 6))
              //         ? null
              //         : () {
              //             if (!pinCodeFormKey.currentState!.validate()) {
              //               return;
              //             } else {
              //               Navigator.push(
              //                   context,
              //                   MaterialPageRoute(
              //                       builder: (context) =>
              //                            RestConfirmPinCode(userId:widget.userId)));
              //             }
              //           })
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
