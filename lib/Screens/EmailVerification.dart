import 'dart:math';

import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:zaki/Constants/AppConstants.dart';
import 'package:zaki/Constants/HelperFunctions.dart';
import 'package:zaki/Constants/NotificationTitle.dart';
import 'package:zaki/Constants/Spacing.dart';
import 'package:zaki/Constants/Styles.dart';
import 'package:zaki/Services/api.dart';
import 'package:zaki/Widgets/AppBars/AppBar.dart';
import 'package:zaki/Widgets/TextHeader.dart';
import 'package:zaki/Widgets/ZakiPrimaryButton.dart';

class EmailVerfication extends StatefulWidget {
  final String sendedCode;
  final String emailForResend;
  const EmailVerfication({Key? key, required this.sendedCode, required this.emailForResend}) : super(key: key);

  @override
  State<EmailVerfication> createState() => _EmailVerficationState();
}

class _EmailVerficationState extends State<EmailVerfication> {
  final emailVerifiedCode = TextEditingController();
  final CountDownController _controller = CountDownController();
  String sendedCode = '';
    String error = '';
    bool? resendButtonEnabled = false;

    @override
  void initState() {
    emailVerifiedCode.text = '';
    sendedCode = widget.sendedCode;
    setState(() {
      
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
   var appConstants = Provider.of<AppConstants>(context, listen: true);
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
              child: Padding(
                padding: getCustomPadding(),
                child: Column(
                  children: [
                    appBarHeader_005(
                        context: context,
                        appBarTitle: 'Verify your email',
                        backArrow: false,
                        height: height,
                        width: width,
                        leadingIcon: true),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          width*0.03,
                        ),
                        border: Border.all(
                          color: grey
                        )
                      ),
                      child: Column(
                        children: [
                              SizedBox(
                                width: width,
                              ),
                          Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextValue3(
                                    title: 
                                  'Enter verification code sent to:', 
                                  // textAlign: TextAlign.center,
                                  ),
                                  Text(
                                  '${widget.emailForResend}', 
                                  style: heading4TextSmall(width, color: black),
                                  // textAlign: TextAlign.center,
                                  ),
                                  spacing_medium,
                                  TextValue3(
                                    title: 
                                    'Tip: If you can’t find our email, please check \nyour Spam/ Junk folder.'
                                    ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                      spacing_large,
                    Pinput(
                        length: 5,
                        autofocus: false,
                        // obscuringCharacter: '*',
                        obscureText: false,
                        errorTextStyle: heading4TextSmall(width, color: red),
                        validator: (String? pin) {
                          if (pin!.isEmpty) {
                            return '';
                          } else if(pin!= sendedCode){
                            return 'Verification Failed';
                          }
                          // else {
                            return null;
                          // }
                        },
                        // onSubmit: (String pin) => _showSnackBar(pin, context),
                        // focusNode: _pinPutFocusNode,
                        controller: emailVerifiedCode,
                        errorText: error == '' ? null : error,
                        // forceErrorState: false,
                        onChanged: (String zipcode) {
                          setState(() {
                            error = '';
                             });
                        },
                      ),
                    spacing_large,
                    CircularCountDownTimer(
                        duration: 60,
                        initialDuration: 0,
                        controller:_controller,
                        width: 60,
                        height: 60,
                        ringColor: resendButtonEnabled==true ? crimsonColor: Colors.green[300]!,
                        ringGradient: null,
                        fillColor: resendButtonEnabled==true ? crimsonColor: grey.withValues(alpha:0.5),
                        fillGradient: null,
                        backgroundColor: white,
                        backgroundGradient: null,
                        strokeWidth: 10.0,
                        strokeCap: StrokeCap.round,
                        textStyle: heading1TextStyle(context, width, color: grey),
                        textFormat: CountdownTextFormat.MM_SS,
                        isReverse: true,
                        isReverseAnimation: false,
                        isTimerTextShown: true,
                        autoStart: true,
                        onStart: () {
                          setState(() {
                            resendButtonEnabled = false;
                          });
                          // _controller.start();
                            debugPrint('Countdown Started');
                        },
                        onComplete: () {
                          setState(() {
                            resendButtonEnabled = true;
                          });
                          
                            debugPrint('Countdown Ended');
                        },
                        onChange: (String timeStamp) {
                            debugPrint('Countdown Changed $timeStamp');
                        },
                        timeFormatterFunction: (defaultFormatterFunction, duration) {
                            if (duration.inSeconds == 0) {
                              return "00:00";
                            } else {
                              return Function.apply(defaultFormatterFunction, [duration]);
                            }
                        },
                    ),
                    spacing_large,
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextValue3(
                          title: 'Didn’t get a verification code?',
                        ),
                        // spacing_small,
                        // SizedBox(
                        //   width: 2,
                        // ),
                        TextButton(
                          child: Text(
                            'Resend Code',
                            style: heading4TextSmall(width, color: resendButtonEnabled == false ? null: green, underline: true),
                          ),
                          onPressed: resendButtonEnabled == false? null: () async{
                                          logMethod(title: 'Time is', message: _controller.getTime().toString());
                                          // if(_controller.getTime().toString()=='02:00'){
                                          
                                         
                                          
                                          var rng = new Random();
                                          var code = rng.nextInt(90000) + 10000;
                                          sendCustomEmail(code: code.toString(), email: widget.emailForResend);
                                  
                                          setState(() {
                                           _controller.reset();
                                           _controller.start();
                                           sendedCode = code.toString();
                                        });
                                         
                                        },
                        )
                      ],
                    ),
                    spacing_medium,
                    ZakiPrimaryButton(
                      width: width,
                      title: 'Confirm',
                      onPressed: emailVerifiedCode.text.trim() != sendedCode?null:  () async{
                                          if(_controller.getTime().toString()=='01:00'){
                                            setState(() {
                                          error = 'Code is expired';
                                        });
                                            return;
                                          }
                                          if(emailVerifiedCode.text.trim().toString()!=sendedCode){
                                            setState(() {
                                          error = 'Verification Failed';
                                        });
                                            return;
                                          }
                                          ApiServices services = ApiServices();
                                          String? verfiyEmail = await services.updateUserEmailStatus(emailStatus: true, userId: appConstants.userRegisteredId, verifiedEmail: widget.emailForResend);
                                          if(verfiyEmail!=null){
                                            await services.getUserData(userId: appConstants.userRegisteredId, context: context);
                                            showNotification(error: 0, icon: Icons.verified, message: NotificationText.EMAIL_VERIFIED);
                                            Navigator.pop(context, "Verified");
                                          }
                                        },
                    ),
                    // Row(
                    // mainAxisAlignment: MainAxisAlignment.end,
                    // children: [
                                       
                    //                    ZakiCicularButton(
                    //                     title: '   Confirm   ',
                    //                     width: width,
                    //                     selected: 4,
                    //                     backGroundColor: green,
                    //                     border: false,
                    //                     textStyle: heading4TextSmall(width, color: white),
                    //                     onPressed: () async{
                    //                       if(_controller.getTime().toString()=='01:00'){
                    //                         setState(() {
                    //                       error = 'Code is expired';
                    //                     });
                    //                         return;
                    //                       }
                    //                       if(emailVerifiedCode.text.trim().toString()!=sendedCode){
                    //                         setState(() {
                    //                       error = 'Verification Failed';
                    //                     });
                    //                         return;
                    //                       }
                    //                       ApiServices services = ApiServices();
                    //                       String? verfiyEmail = await services.updateUserEmailStatus(emailStatus: true, userId: appConstants.userRegisteredId);
                    //                       if(verfiyEmail!=null){
                    //                         services.getUserData(userId: appConstants.userRegisteredId, context: context);
                    //                         showNotification(error: 0, icon: Icons.verified, message: 'Email Verified');
                    //                         Navigator.pop(context);
                    //                       }
                    //                     },
                    //                   ),
                    //                   ],
                    //                 ),
                    spacing_medium,
                    
                  ],
                ),
              ),
            ),
      ),
    );
  }
}