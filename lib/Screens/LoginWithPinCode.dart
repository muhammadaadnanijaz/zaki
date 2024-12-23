import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:ndialog/ndialog.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:zaki/Constants/AppConstants.dart';
import 'package:zaki/Constants/HelperFunctions.dart';
import 'package:zaki/Constants/NotificationTitle.dart';
import 'package:zaki/Constants/Styles.dart';
import 'package:zaki/Screens/HomeScreen.dart';
import 'package:zaki/Screens/WhatsAppLoginScreen.dart';
import 'package:zaki/Services/api.dart';
// import 'package:zaki/Widgets/AppBars/AppBar.dart';
import 'package:zaki/Widgets/TextHeader.dart';
// import 'package:zaki/Widgets/ZakiPrimaryButton.dart';

import '../Constants/Spacing.dart';
import '../Services/SharedPrefMnager.dart';
import '../Widgets/CustomLoadingScreen.dart';
// import 'WhatsAppSignUpScreen.dart';

enum SingingCharacter { four, six }

class LoginWithPinCode extends StatefulWidget {
  final int? pinCodeLength;
  final bool? timeOut;
  final String? pinCode;
  final String? userId;
  final String? firstName;
  final bool? primaryUser;
  const LoginWithPinCode(
      {Key? key, this.userId, this.pinCodeLength, this.pinCode, this.firstName, this.primaryUser, this.timeOut})
      : super(key: key);

  @override
  _LoginWithPinCodeState createState() => _LoginWithPinCodeState();
}

class _LoginWithPinCodeState extends State<LoginWithPinCode> {
  DateTime? _lastQuitTime = DateTime.now();
  late SingingCharacter? pinLength = SingingCharacter.four;
  final LocalAuthentication auth = LocalAuthentication();
  bool canAuthenticate = true;
  bool obSecureFields = true;
  final formKeyLogin = GlobalKey<FormState>();
  final pinCodeController = TextEditingController();
  Timer? _timer;
  Duration? _remainingTime= null;

  @override
  void dispose() {
    pinCodeController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    userFirstTimeLogin();
    checkBioMetricsSupport();
    super.initState();
  }

  userFirstTimeLogin() {
    Future.delayed(Duration.zero, () async{
      var appConstants = Provider.of<AppConstants>(context, listen: false);
      appConstants.updateUserOnLoginWithPinCodeScreen(true);
      appConstants.updateIsLoginFirstTime(false);
      logMethod(
          title: 'ID OF LOGED IN USER====>>>>' ,
          message: widget.userId ?? 'No Id');
      logMethod(
          title: 'Login First Time',
          message: appConstants.isLoginFirstTime.toString());
    ////We need to check that where user is coming from 
    ///1): From Start login with pin code or 2): From Pin code kid screen
    ///Means Login with pin code screen first time
    if(widget.userId == null){
      try {
        if(appConstants.userModel.userBlockTime!=null)
        {
      _remainingTime = appConstants.userModel.userBlockTime!.difference(DateTime.now());
      if (_remainingTime!.isNegative) {
        appConstants.resetAttempts();
        return;
      }
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _remainingTime = appConstants.userModel.userBlockTime!.difference(DateTime.now());
        if (_remainingTime!.isNegative) {
          timer.cancel();
          ApiServices().addUserBlockTime(id: widget.userId?? appConstants.userRegisteredId, blockDatetTime: null);

          appConstants.resetAttempts();
        }
      });
    });

          logMethod(title: 'Date Time of logged in user', message: '${DateTime.now().hour} and ${appConstants.userModel.userBlockTime!.hour}');
        // showNotification(autoDismiss: false, error: 1, icon: Icons.error_outline, message: '${NotificationText.PIN_TO_MANY_ATTEMPTS_ERROR}, Blocked for:${(DateTime.now().hour-appConstants.userModel.userBlockTime!.hour)}:${(DateTime.now().minute-appConstants.userModel.userBlockTime!.minute)}');
        }
        logMethod(title: 'User Block time----->>>>>> and duration: ${_remainingTime}', message: appConstants.userModel.userBlockTime.toString());
      } catch (e) {
        logMethod(title: 'User Block time----->>>>>>Catch', message: "No User data");
      }
      //Checking user that already enabled the bio metric than show that for login
      if(appConstants.userModel.usaTouchEnable != null &&appConstants.userModel.usaTouchEnable!){
        bool isAuth = await ApiServices().userLoginBioMetric();
                                if (isAuth) {
                                  appConstants.updateUserOnLoginWithPinCodeScreen(false);
                                  if(widget.timeOut==true){
                                    Navigator.pop(context);
                                    return;
                                  }
                                  CustomProgressDialog progressDialog =
                                  CustomProgressDialog(context, blur: 10);
                                    progressDialog
                                        .setLoadingWidget(CustomLoadingScreen());
                                    progressDialog.show();
                                    
                                  await ApiServices().getNickNames(
                                      context: context,
                                      userId: appConstants.userRegisteredId);
                                  // showSnackBarDialog(
                                  //     context: context,
                                  //     message: 'Authenticated successfully');
                                  Future.delayed(const Duration(seconds: 1), () {
                                    progressDialog.dismiss();
                                    FocusManager.instance.primaryFocus?.unfocus();
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => HomeScreen()));
                                  });
                                } 
      }
    }
    });
  }

  void clearFields() {
    pinCodeController.text = '';
  }

  checkBioMetricsSupport() async {
    final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
    canAuthenticate =
        canAuthenticateWithBiometrics || await auth.isDeviceSupported();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var appConstants = Provider.of<AppConstants>(context, listen: true);
    // var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async{ 
        if(widget.timeOut==true){
          if (DateTime.now().difference(_lastQuitTime!).inSeconds > 1) {
          showSnackBarDialog(
              context: context, message: 'Press back button to exit');
          // Scaffold.of(context)
          //     .showSnackBar(SnackBar(content: Text('Press again Back Button exit')));
          _lastQuitTime = DateTime.now();
          return false;
          } else {
            SystemChannels.platform.invokeMethod('SystemNavigator.pop');
            return true;
          }
        }
        else{
          return false;
        }
      },
      child: Scaffold(
          body: SafeArea(
              child: Padding(
        padding: getCustomPadding(),
        child: Form(
          autovalidateMode: AutovalidateMode.disabled,
          key: formKeyLogin,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // if(widget.userId != null)
                Column(
                  children: [
                    // appBarHeader_001(
                    //     context: context,
                    //     height: height,
                    //     width: width,
                    //     leadingIcon: widget.userId != null ? true : false,
                    //     // needLogo: false
                    //     ),
                    // if(widget.userId != null)
                    spacing_large,
                    Center(
                        child: Image.asset(
                            imageBaseAddress + 'header_zakipay_real.png')),
      
                  ],
                ),
                spacing_large,
                /////Means Login with pin code Screen
                // if(widget.userId == null)
                // Column(
                //   children: [
                //     spacing_large,
                //     Row(
                //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //       children: [
                //         Row(
                //           children: [
                //             if(widget.userId != null)
                //             InkWell(
                //               onTap: (){
                //                 Navigator.pop(context);
                //               },
                //               child: Icon(Icons.close)),
                //             Padding(
                //               padding: (widget.userId == null)? EdgeInsets.zero : const EdgeInsets.symmetric(horizontal: 8.0),
                //               child: AppBarImageHeader(),
                //             ),
                //           ],
                //         ),
                //         if(widget.userId == null)
                //         IconButton(
                //           visualDensity: VisualDensity.compact,
                //           padding: EdgeInsets.zero,
                //           icon: Icon(Icons.person_outline),
                //           onPressed: (){
                //             Navigator.push(
                //                     context,
                //                     MaterialPageRoute(
                //                         builder: (context) => const WhatsAppLoginScreen()));
                //           }, 
                //           )
                //       ],
                //     ),
                //   ],
                // ),
                /////Means Login with pin code Screen
                
                // spacing_large,
                      Row( 
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              TextValue2(
                                title: 'Welcome,  ',
                              ),
                              TextHeader1(
                                title: widget.firstName==null? '${appConstants.userModel.usaFirstName}': widget.firstName,
                              ),
                            ],
                          ),
                          if(widget.userId == null)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                      visualDensity: VisualDensity.compact,
                                      padding: EdgeInsets.zero,
                                      icon: Icon(
                                        Icons.person_outline, 
                                        color: grey,
                                        ),
                                      onPressed: (){
                                        appConstants.updateUserOnLoginWithPinCodeScreen(false);
                                        Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => const WhatsAppLoginScreen()));
                                      }, 
                                      )
                              ],
                            ),
                        ],
                      ),
                spacing_large,
                // Text(
                //   'Prefer 4 or 6 Pin Code?',
                //   style: textStyleHeading2WithTheme(context,width*0.7, whiteColor: 0),
                //   ),
                // SizedBox(height: height*0.02,),
                //     Row(
                //       mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     Radio(
                //       value: SingingCharacter.four , groupValue: pinLength, onChanged: (SingingCharacter? caha){
                //         clearFields();
                //               appConstants.updatePinLength(4);
                //               setState(() {
      
                //               });
                //         setState(() {
                //     pinLength = caha;
                //   });
                //     }),
                //     Text('4 Pin Code', style: textStyleHeading2WithTheme(context,width*0.7, whiteColor: 0),),
                //     const SizedBox(width: 10),
                //     Radio(
                //       value: SingingCharacter.six , groupValue: pinLength, onChanged: (SingingCharacter? caha){
                //         clearFields();
                //         appConstants.updatePinLength(6);
                //         setState(() {
                //     pinLength = caha;
                //   });
                //     }),
                //     Text('6 Pin Code', style: textStyleHeading2WithTheme(context,width*0.7, whiteColor: 0),),
      
                //   ],
                // ),
      
                Center(
                  child: Container(
                    color: transparent,
                    // margin: const EdgeInsets.all(20.0),
                    padding: const EdgeInsets.symmetric(horizontal: 2.0),
                    child: Pinput(
                      // scrollPadding: const EdgeInsets.all(80.0),
                      length: widget.userId != null
                          ? widget.pinCodeLength!
                          : appConstants.userModel.usaPinCodeLength ?? 4,
                      autofocus: appConstants.userModel.usaPinEnable == null
                          ? false
                          : appConstants.userModel.usaPinEnable!
                              ? true
                              : false,
                      obscuringCharacter: '*',
                      obscureText: true,

                      onTap: () {
                        if (pinCodeController.text.length <
                            (widget.userId != null
                                ? widget.pinCodeLength!
                                : appConstants.userModel.usaPinCodeLength!)) {
                        } else if (encryptedValue(
                                value: pinCodeController.text) !=
                            (widget.userId != null
                                ? widget.pinCode
                                : appConstants.userModel.usaPinCode)) {
                          pinCodeController.text = '';
                        }
                      },
                      errorTextStyle: heading4TextSmall(width, color: red),
                      validator: (String? pin) {
                        if (pin!.isEmpty) {
                          return 'Enter PIN Code';
                        } else if (pin.length <
                            (widget.userId != null
                                ? widget.pinCodeLength!
                                : appConstants.userModel.usaPinCodeLength!)) {
                          return 'Enter all PIN Code Digits';
                        } else if (encryptedValue(value: pin) !=
                            (widget.userId != null
                                ? widget.pinCode
                                : appConstants.userModel.usaPinCode)) {
                          // formKeyLogin.currentState!.reset();
                          // pinCodeController.text='';
                          logMethod(
                              title: 'PinCode',
                              message:
                                  'Entered Pin Code: ${encryptedValue(value: '2222')} && ${encryptedValue(value: '2222')}Saved Pin Code: ${appConstants.userModel.usaPinCode}');
                          logMethod(
                              title: 'PinCode',
                              message:
                                  '2nd Entered Pin Code: ${encryptPin('2222')} && ${encryptPin('2222')} Saved Pin Code: ${decryptPin('XTitzei7/GxXBtQeKpj+2A==')}');
                          //////////Create Logic for Multitple Attempts
                          // if (appConstants.attempts >= AppConstants.ATTEMPTS_COUNT) {
                          //   // _logout(context);
                          //   showNotification(error: 1, icon: Icons.error_outline, message: NotificationText.PIN_TO_MANY_ATTEMPTS_ERROR);
                          // } else {
                          // showNotification(error: 1, icon: Icons.error_outline, message: '${NotificationText.PIN_MULTIPLE_ATTEMPTS_ERROR} ${appConstants.attempts}/${AppConstants.ATTEMPTS_COUNT}');
                          // appConstants.incrementAttempts(appConstants.attempts+1);
                          // }
                          return 'PIN Code did not match, try again.';
                        } else {
                          
                          return null;
                        }
                      },
      
                      // onSubmit: (String pin) => _showSnackBar(pin, context),
                      // focusNode: _pinPutFocusNode,
                      controller: pinCodeController,
                      onCompleted: (String value) async {
                        if (encryptedValue(value: value) !=
                            (widget.userId != null
                                ? widget.pinCode
                                : appConstants.userModel.usaPinCode)){
                        if (appConstants.attempts >= AppConstants.ATTEMPTS_COUNT) {
                            // _logout(context);
                            showNotification(error: 1, icon: Icons.error_outline, message: NotificationText.PIN_TO_MANY_ATTEMPTS_ERROR);
                            if (appConstants.attempts >= AppConstants.ATTEMPTS_COUNT){
                            await ApiServices().addUserBlockTime(id: widget.userId?? appConstants.userRegisteredId, blockDatetTime: DateTime.now().add(Duration(hours: 2)));
                            Future.delayed(Duration(seconds: 2), ()async{
                              await ApiServices().getUserData(
                                  context: context, userId: widget.userId??appConstants.userRegisteredId);
                            });
                          }
                            return;
                          } else {
                          appConstants.incrementAttempts(appConstants.attempts+1);
                          showNotification(error: 1, icon: Icons.error_outline, message: '${NotificationText.PIN_MULTIPLE_ATTEMPTS_ERROR} ${appConstants.attempts}/${AppConstants.ATTEMPTS_COUNT}');
                          return;
                          }
                          
                          }

                        if (!formKeyLogin.currentState!.validate()) {
                          return;
                        } 
                        else if (appConstants.attempts >= AppConstants.ATTEMPTS_COUNT){
                          if (appConstants.attempts >= AppConstants.ATTEMPTS_COUNT){
                            ApiServices().addUserBlockTime(id: widget.userId?? appConstants.userRegisteredId, blockDatetTime: DateTime.now().add(Duration(hours: 2)));
                            Future.delayed(Duration(seconds: 2), ()async{
                              await ApiServices().getUserData(
                                  context: context, userId: widget.userId??appConstants.userRegisteredId);
                            });
                          }
                          logMethod(title: 'This is Attempt count', message: 'Attempt count---->>>>${appConstants.attempts}');
                          showNotification(error: 1, icon: Icons.error_outline, message: NotificationText.PIN_TO_MANY_ATTEMPTS_ERROR);
                          return;
                        }
                        else {
                          
                          appConstants.resetAttempts();
                          ApiServices().addUserBlockTime(id: widget.userId?? appConstants.userRegisteredId, blockDatetTime: null);

                          // if(appConstants.attempts >= AppConstants.ATTEMPTS_COUNT){
                          //   showNotification(error: 1, icon: Icons.error_outline, message: NotificationText.PIN_TO_MANY_ATTEMPTS_ERROR);
                          //   return;
                          // }
                          CustomProgressDialog progressDialog =
                              CustomProgressDialog(context, blur: 10);
                          progressDialog.setLoadingWidget(CustomLoadingScreen());
                          progressDialog.show();
                          // appConstants.updateIsLoginFirstTime(true);
      
                          if (encryptedValue(value: pinCodeController.text) ==
                              (widget.userId != null
                                  ? widget.pinCode
                                  : appConstants.userModel.usaPinCode)) {
                                    appConstants.updateUserOnLoginWithPinCodeScreen(false);

                                  if(widget.timeOut==true){
                                    progressDialog.dismiss();
                                    Navigator.pop(context);
                                    return;
                                  }
                            FocusManager.instance.primaryFocus?.unfocus();
                            await ApiServices().getNickNames(
                                context: context,
                                userId: widget.userId != null
                                    ? widget.userId
                                    : appConstants.userRegisteredId);
                            if (widget.userId != null) {
                              UserPreferences userPref = UserPreferences();
                              await userPref.saveCurrentUserId(widget.userId!);
                              appConstants.updateUserId(widget.userId.toString());
                              await ApiServices().getUserData(
                                  context: context, userId: widget.userId!);
                              Future.delayed(Duration(milliseconds: 1500), () {
                                pinCodeController.text = '';
                                progressDialog.dismiss();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomeScreen()));
                                return;
                              });
                            }
                            progressDialog.dismiss();
                            pinCodeController.text = '';
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomeScreen()));
                          } else {
                            progressDialog.dismiss();
                            showNotification(
                                error: 1,
                                icon: Icons.error,
                                message: NotificationText.PIN_CODE_NOT_MATCHED);
                          }
                        }
                      },
                    ),
                  ),
                ),
                spacing_small,
                // ZakiPrimaryButton(
                //     title: 'Log In',
                //     width: width,
                //     onPressed: (pinCodeController.text.isEmpty ||
                //             (appConstants.userModel.usaPinCodeLength == 4 &&
                //                 pinCodeController.text.length < 4) ||
                //             (appConstants.userModel.usaPinCodeLength == 6 &&
                //                 pinCodeController.text.length < 6) ||
                //             (encryptedValue(value: pinCodeController.text) !=
                //                 (widget.userId != null
                //                     ? widget.pinCode
                //                     : appConstants.userModel.usaPinCode)))
                //         ? null
                //         : () async {
                //             if (!formKeyLogin.currentState!.validate()) {
                //               return;
                //             } else {
      
                //               if (widget.userId != null) {
                //                 CustomProgressDialog progressDialog =
                //                     CustomProgressDialog(context, blur: 10);
                //                 progressDialog
                //                     .setLoadingWidget(CustomLoadingScreen());
                //                 progressDialog.show();
                //                 UserPreferences userPref = UserPreferences();
                //                 await userPref.saveCurrentUserId(widget.userId!);
                //                 await ApiServices().getUserData(
                //                     context: context, userId: widget.userId!);
                //                 appConstants
                //                     .updateUserId(widget.userId.toString());
                //                 Future.delayed(Duration(milliseconds: 1500), () {
                //                   pinCodeController.clear();
                //                   progressDialog.dismiss();
                //                   appConstants.updateUserOnLoginWithPinCodeScreen(false);
                //                   Navigator.push(
                //                       context,
                //                       MaterialPageRoute(
                //                           builder: (context) => HomeScreen()));
                //                   return;
                //                 });
                //               }
                //               if (encryptedValue(value: pinCodeController.text) ==
                //                   appConstants.userModel.usaPinCode) {
                //                     appConstants.updateUserOnLoginWithPinCodeScreen(false);
                //                 if(widget.timeOut==true){
                //                     Navigator.pop(context);
                //                     return;
                //                   }
      
                //                 FocusManager.instance.primaryFocus?.unfocus();
                //                 await ApiServices().getNickNames(
                //                     context: context,
                //                     userId: appConstants.userRegisteredId);
                //                 pinCodeController.text = '';
                //                 Navigator.push(
                //                     context,
                //                     MaterialPageRoute(
                //                         builder: (context) => HomeScreen()));
                //               } else {
                //                 showNotification(
                //                     error: 1,
                //                     icon: Icons.error,
                //                     message: NotificationText.PIN_CODE_NOT_MATCHED);
                //               }
                //             }
                //           }),
      
                spacing_medium,
                if ((appConstants.userModel.userBlockTime!=null||appConstants.userModel.userBlockTime!='') && _remainingTime!=null)
              Text(
                '${NotificationText.TEMP_LOCKED} \n${NotificationText.TEMP_BLOCKED_TEXT} ${_remainingTime!.inHours}:${(_remainingTime!.inMinutes % 60).toString().padLeft(2, '0')}:${(_remainingTime!.inSeconds % 60).toString().padLeft(2, '0')}',
                style: TextStyle(color: Colors.red, ),
                textAlign: TextAlign.center,
              ),
                spacing_medium,
                // textValueHeaderbelow,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          appConstants.updateUserOnLoginWithPinCodeScreen(false);
                          Navigator.push(
                              context,
                              MaterialPageRoute( 
                                  builder: (context) => const WhatsAppLoginScreen(
                                        fromForgetPassword: true,
                                      )));
                        },
                        child: TextValue3(
                          title: 'Forgot PIN Code?',
                        ),
                      ),
                      //Means Login with pin code screen
                      if ((canAuthenticate && widget.userId == null)|| widget.primaryUser==true)
                      if(appConstants.userModel.isUserPinUser!=true)
                    InkWell(
                      onTap: () async {
                                    if (appConstants.userModel.usaTouchEnable != null &&
                                        appConstants.userModel.usaTouchEnable!) {
                                      bool isAuth =
                                          await ApiServices().userLoginBioMetric();
                                      if (isAuth) {
                                        appConstants.updateUserOnLoginWithPinCodeScreen(false);
                                        if(widget.timeOut==true){
                                          Navigator.pop(context);
                                          return;
                                        }
                                        CustomProgressDialog progressDialog =
                                        CustomProgressDialog(context, blur: 10);
                                          progressDialog
                                              .setLoadingWidget(CustomLoadingScreen());
                                          progressDialog.show();
                                          
                                        await ApiServices().getNickNames(
                                            context: context,
                                            userId: appConstants.userRegisteredId);
                                        // showSnackBarDialog(
                                        //     context: context,
                                        //     message: 'Authenticated successfully');
                                        Future.delayed(const Duration(seconds: 1), () {
                                          progressDialog.dismiss();
                                          FocusManager.instance.primaryFocus?.unfocus();
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => HomeScreen()));
                                        });
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
                                  border:Border.all(color: green.withOpacity(0.3))
                                ),
                        child: Padding(
                          padding: EdgeInsets.all(0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: InkWell(
                                  onTap: () async {
                                    if (appConstants.userModel.usaTouchEnable != null &&
                                        appConstants.userModel.usaTouchEnable!) {
                                      bool isAuth =
                                          await ApiServices().userLoginBioMetric();
                                      if (isAuth) {
                                        appConstants.updateUserOnLoginWithPinCodeScreen(false);
                                        if(widget.timeOut==true){
                                      Navigator.pop(context);
                                      return;
                                    }
                                        CustomProgressDialog progressDialog =
                                        CustomProgressDialog(context, blur: 10);
                                          progressDialog
                                              .setLoadingWidget(CustomLoadingScreen());
                                          progressDialog.show();
                                          
                                        await ApiServices().getNickNames(
                                            context: context,
                                            userId: appConstants.userRegisteredId);
                                        // showSnackBarDialog(
                                        //     context: context,
                                        //     message: 'Authenticated successfully');
                                        Future.delayed(const Duration(seconds: 1), () {
                                          progressDialog.dismiss();
                                          FocusManager.instance.primaryFocus?.unfocus();
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => HomeScreen()));
                                        });
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
                              // Padding(
                              //   padding: const EdgeInsets.only(right: 5.0),
                              //   child: TextValue1(
                              //     title:Platform.isAndroid? 'Touch ID':'Face ID',
                              //   ),
                              // )
                            ],
                          ),
                        ),
                      ),
                    ),
                    ],
                  ),
                ),
                // spacing_medium,
                //     Center(child: TextValue3(title: '--OR--',)),
                // spacing_medium,
                // Row(
                //         mainAxisAlignment: MainAxisAlignment.center,
                //         crossAxisAlignment: CrossAxisAlignment.center,
                //         children: [
                //           TextValue2(
                //             title:
                //             'Want a account? ',
                //           ),
                //           InkWell(
                //             onTap: () {
                //               Navigator.push(
                //                   context,
                //                   MaterialPageRoute(
                //                       builder: (context) =>
                //                           const WhatsAppSignUpScreen()));
                //             },
                //             child: Text(
                //             'Sign Up',
                //             style: heading3TextStyle(width, underLine: true, color: green),
                //           ),
                //           ),
                //         ],
                //       ),
                
                spacing_X_large,
                Image.asset(imageBaseAddress+"pin_code.png")
                // SizedBox(
                //   height: height * 0.02,
                // ),
      
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
      ))),
    );
  }
}
