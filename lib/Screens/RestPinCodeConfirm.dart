// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:zaki/Constants/AppConstants.dart';
// import 'package:zaki/Constants/NotificationTitle.dart';
import 'package:zaki/Constants/Styles.dart';
import 'package:zaki/Widgets/SSLCustom.dart';
// import 'package:zaki/Widgets/ZakiPrimaryButton.dart';
import 'package:zaki/Constants/Whitelable.dart';
import '../Constants/HelperFunctions.dart';
import '../Constants/Spacing.dart';
import '../Services/api.dart';
import '../Widgets/AppBars/AppBar.dart';
import 'HomeScreen.dart';

class RestConfirmPinCode extends StatefulWidget {
  final int? fromKidsSignUpPag;
  final String? userId;
  const RestConfirmPinCode({Key? key, this.fromKidsSignUpPag, this.userId})
      : super(key: key);

  @override
  _RestConfirmPinCodeState createState() => _RestConfirmPinCodeState();
}

class _RestConfirmPinCodeState extends State<RestConfirmPinCode> {
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
                  appBarTitle: 'Confirm PIN Code',
                  backArrow: true,
                  height: height,
                  width: width,
                  leadingIcon: true,
                  tralingIconButton: SSLCustom()),
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

              Container(
                color: transparent,
                // margin: const EdgeInsets.all(20.0),
                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                child: Pinput(
                  length: appConstants.pinLength,
                  controller: pinCodeController,
                  autofocus: true,
                  errorTextStyle: heading4TextSmall(width, color: red),
                  obscuringCharacter: '*',
                  obscureText: true,
                  pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                  validator: (String? pin) {
                    if (pin!.isEmpty) {
                      return 'Please Enter pin';
                    } else if ((appConstants.pinLength == 4 &&
                            pin.length < 4) ||
                        (appConstants.pinLength == 6 && pin.length < 6)) {
                      return 'Please Enter full pin';
                    } else if (appConstants.pin != encryptedValue(value: pin)) {
                      return 'Pin Didn’t matched';
                    } else {
                      return null;
                    }
                  },
                  onChanged: (String pin) async{
                    if (!restConfirmPinCodeCodeFormKey.currentState!
                              .validate()) {
                            return;
                          } else {
                            if(widget.userId!=null){
                              appConstants.updateUserId(widget.userId.toString());
                            }
                            ApiServices services = ApiServices();
                            await services.updateUserPinCode(
                                widget.userId!=null? widget.userId.toString() : appConstants.userRegisteredId,
                                pinCodeController.text.trim(),
                                appConstants.pinLength,
                                DateTime.now()
                                );
                            await services.getUserData(
                                userId:  widget.userId!=null? widget.userId.toString() : appConstants.userRegisteredId,
                                context: context);
                            showNotification(
                                error: 0,
                                icon: Icons.check,
                                message: NotificationText.UPDATED_SUCCESSFULLY);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomeScreen()));
                          }
                  },
                ),
              ),
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
              //         : () async {
              //             if (!restConfirmPinCodeCodeFormKey.currentState!
              //                 .validate()) {
              //               return;
              //             } else {
              //               if(widget.userId!=null){
              //                 appConstants.updateUserId(widget.userId.toString());
              //               }
              //               ApiServices services = ApiServices();
              //               await services.updateUserPinCode(
              //                    widget.userId!=null? widget.userId.toString() : appConstants.userRegisteredId,
              //                   pinCodeController.text.trim(),
              //                   appConstants.pinLength
              //                   );
              //               await services.getUserData(
              //                   userId:  widget.userId!=null? widget.userId.toString() : appConstants.userRegisteredId,
              //                   context: context);
              //               showNotification(
              //                   error: 0,
              //                   icon: Icons.check,
              //                   message: NotificationText.UPDATED_SUCCESSFULLY);
              //               Navigator.push(
              //                   context,
              //                   MaterialPageRoute(
              //                       builder: (context) => HomeScreen()));
              //             }
              //           })
              // //   SizedBox(
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
