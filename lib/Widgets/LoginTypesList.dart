import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:ndialog/ndialog.dart';
import 'package:provider/provider.dart';
import 'package:zaki/Constants/AppConstants.dart';
import 'package:zaki/Constants/AuthMethods.dart';
import 'package:zaki/Constants/HelperFunctions.dart';
import 'package:zaki/Constants/NotificationTitle.dart';
import 'package:zaki/Constants/Spacing.dart';
import 'package:zaki/Constants/Styles.dart';
import 'package:zaki/Screens/AccountSetUpInformation.dart';
import 'package:zaki/Screens/AccountSetupAsaKid.dart';
import 'package:zaki/Screens/WhatsAppLoginScreen.dart';
import 'package:zaki/Services/api.dart';
// import 'package:zaki/Widgets/CustomLoadingScreen.dart';


class LoginTypesList extends StatefulWidget {
  final bool? secondryUser;
  const LoginTypesList({Key? key, this.secondryUser}) : super(key: key);

  @override
  State<LoginTypesList> createState() => _LoginTypesListState();
}

class _LoginTypesListState extends State<LoginTypesList> {
  @override
  Widget build(BuildContext context) {
        var appConstants = Provider.of<AppConstants>(context, listen: true);
    // var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body:
      appConstants.selectedIndex==1?
      Center(child: CircularProgressIndicator()):
       Column(
        children: [
          
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: grey.withOpacity(0.3)),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                              children: [
                                spacing_medium,
                                  Text(
                                    'Please Select one of the following accounts to login with in the future:',
                                    style: heading4TextSmall(width, color: grey),
                                    ),
                                    spacing_medium,
                                LoginTypesButton(
                                  width: width,
                                  title: 'Continue with Google',
                                  iconColor: green,
                                  icon: FontAwesomeIcons.google,
                                  onPressed: () async{
                                    UserCredential? info = await ApiServices()
                                        .signInWithGoogle(googleSignIn);
                                    if (info != null) {
                                      bool? isEmailExist =
                                            await ApiServices().checkEmailExist(email: info.user!.email);
                                          if (isEmailExist! 
                                          // && info.user!.email != appConstants.userModel.usaEmail
                                              ) {
                                                appConstants.alreadyExistEmailErrorMessageUpdate('This email is already taken, search for another one');
                                                showNotification(error: 1, icon:Icons.email_outlined, message: 'Already Registered');
                                            return;
                                          } 
                                      appConstants.updateEmailUsed(false);
                                      appConstants.alreadyExistEmailErrorMessageUpdate('');
                                      appConstants.userModel.usaEmail=info.user!.email.toString();
                                      appConstants.updateSignUpMethod(AppConstants.LOGIN_TYPE_GOOGLE);
                                      appConstants.updateEmail(info.user!.email);
                                      //For going to nect page with user cheking Secondry user
                                      checkUserTypeAndGoNext(appConstants: appConstants);


                                      if(info.additionalUserInfo!.isNewUser){
                                        appConstants.updateSignUpMethod(AppConstants.LOGIN_TYPE_GOOGLE);
                                        appConstants.userModel.usaEmail=info.user!.email.toString();
                                      }else{
                                        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                        //   content: Text(info.additionalUserInfo!.isNewUser
                                        //       ? 'New user Register successfully'
                                        //       : 'Already Used: ${info.user?.email}')));
                                      }
                                      return;
                                    } else {
                                      // ScaffoldMessenger.of(context).showSnackBar(
                                      //     const SnackBar(
                                      //         content: Text('Logged in failed')));
                                      return;
                                    }
                                  },
                                  ),
                                  if(Platform.isIOS)
                                  Column(
                                    children: [
                                      spacing_medium,
                                      LoginTypesButton(
                                      width: width,
                                      title: 'Continue with Apple',
                                      iconColor: black,
                                      icon: FontAwesomeIcons.apple,
                                      onPressed: () async{
                                        appConstants.updateEmailUsed(false);
                                        appConstants.updateSignUpMethod(AppConstants.LOGIN_TYPE_APPLE);
                                        //For going to nect page with user cheking Secondry user
                                          checkUserTypeAndGoNext(appConstants: appConstants);
                                      },
                                      ),
                                    ],
                                  ),
                                  spacing_medium,
                                  LoginTypesButton(
                                  width: width,
                                  title: 'Continue with Facebook',
                                  iconColor: blue,
                                  icon: FontAwesomeIcons.facebookF,
                                  onPressed: () async{
              
                                    UserCredential? info = await signInWithFacebook();
                                    // ignore: unnecessary_null_comparison
                                    if (info != null) {
                                      bool? isEmailExist =
                                            await ApiServices().checkEmailExist(email: info.user!.email);
                                          if (isEmailExist! &&
                                              info.user!.email != appConstants.userModel.usaEmail) {
                                                appConstants.alreadyExistEmailErrorMessageUpdate('This email is already taken, search for another one');
                                                showNotification(error: 1, icon:Icons.email_outlined, message: 'Already Registered');
                                            return;
                                          } 
                                      appConstants.alreadyExistEmailErrorMessageUpdate('');
                                      appConstants.updateEmailUsed(false);
                                      appConstants.userModel.usaEmail=info.user!.email.toString();
                                      appConstants.updateSignUpMethod(AppConstants.LOGIN_TYPE_FACEBOOK);
                                      appConstants.updateEmail(info.user!.email);
                                      //For going to nect page with user cheking Secondry user
                                      checkUserTypeAndGoNext(appConstants: appConstants);

                                      

                                      if(info.additionalUserInfo!.isNewUser){
                                        appConstants.updateSignUpMethod(AppConstants.LOGIN_TYPE_FACEBOOK);
                                        appConstants.userModel.usaEmail=info.user!.email.toString();
                                      }else{
                                        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                        //   content: Text(info.additionalUserInfo!.isNewUser
                                        //       ? 'New user Register successfully'
                                        //       : 'Already Used: ${info.user?.email}')));
                                      }
              
                                //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                //           content: Text(info.additionalUserInfo!.isNewUser
                                //               ? 'New user Register successfully'
                                //               : 'Successfully Logged in email: ${info.user?.email}')));
                                //       if(!info.additionalUserInfo!.isNewUser){
                                //         CustomProgressDialog progressDialog =
                                //     CustomProgressDialog(context, blur: 10);
                                // progressDialog.setLoadingWidget(CustomLoadingScreen());
                                // progressDialog.show();
              
                                //         ApiServices service = ApiServices();
                                //             dynamic user = await service.loginUserThroughEmail(
                                //           context: context,
                                //           email: info.user!.email.toString());
                                //   if (user != null) {
                                //    service.userLoginWorkFlow(user: user, appConstants: appConstants, context: context, progressDialog: progressDialog);
              
                                //     // });
                                  } else {
                                    showNotification(
                                        error: 1,
                                        icon: Icons.error,
                                        message:
                                           NotificationText.NO_USER_REGISTERED );
                                  }
                                //       }
                                  
                                //       return;
                                //     } else {
                                //       ScaffoldMessenger.of(context).showSnackBar(
                                //           const SnackBar(
                                //               content: Text('Logged in failed')));
                                //       return;
                                //     }
                                  },
                                  ),
                                  spacing_medium,
                                  LoginTypesButton(
                                  width: width,
                                  title: 'Continue with X',
                                  iconColor: blue,
                                  icon: FontAwesomeIcons.xTwitter,
                                  onPressed: () async{
                                    // appConstants.updateSignUpMethod(AppConstants.LOGIN_TYPE_X);
                                    UserCredential? info = await signInWithTwitter();
                                    // ignore: unnecessary_null_comparison
                                    if (info != null) {
                                      bool? isEmailExist =
                                            await ApiServices().checkEmailExist(email: info.user!.email);
                                          if (isEmailExist! &&
                                              info.user!.email != appConstants.userModel.usaEmail) {
                                                appConstants.alreadyExistEmailErrorMessageUpdate('This email is already taken, search for another one');
                                                showNotification(error: 1, icon:Icons.email_outlined, message: 'Already Registered');
                                            return;
                                          } 
                                      appConstants.alreadyExistEmailErrorMessageUpdate('');
                                      appConstants.updateEmailUsed(false);
                                      appConstants.userModel.usaEmail=info.user!.email.toString();
                                      appConstants.updateSignUpMethod(AppConstants.LOGIN_TYPE_X);
                                      appConstants.updateEmail(info.user!.email);
                                      //For going to nect page with user cheking Secondry user
                                      checkUserTypeAndGoNext(appConstants: appConstants);

                                      if(info.additionalUserInfo!.isNewUser){
                                        appConstants.updateSignUpMethod(AppConstants.LOGIN_TYPE_X);
                                        appConstants.userModel.usaEmail=info.user!.email.toString();
                                      }else{
                                        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                        //   content: Text(info.additionalUserInfo!.isNewUser
                                        //       ? 'New user Register successfully'
                                        //       : 'Already Used: ${info.user?.email}')));
                                      }
              
                                //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                //           content: Text(info.additionalUserInfo!.isNewUser
                                //               ? 'New user Register successfully'
                                //               : 'Successfully Logged in email: ${info.user?.email}')));
                                //       if(!info.additionalUserInfo!.isNewUser){
                                //         CustomProgressDialog progressDialog =
                                //     CustomProgressDialog(context, blur: 10);
                                // progressDialog.setLoadingWidget(CustomLoadingScreen());
                                // progressDialog.show();
              
                                //         ApiServices service = ApiServices();
                                //             dynamic user = await service.loginUserThroughEmail(
                                //           context: context,
                                //           email: info.user!.email.toString());
                                //   if (user != null) {
                                //    service.userLoginWorkFlow(user: user, appConstants: appConstants, context: context, progressDialog: progressDialog);
              
                                //     // });
                                  } else {
                                    showNotification(
                                        error: 1,
                                        icon: Icons.error,
                                        message:
                                           NotificationText.NO_USER_REGISTERED );
                                  }
                                  },
                                  ),
                                  spacing_medium
                              ],
                            ),
            ),
          ),
          spacing_medium,
                                  InkWell(
                                    onTap: (){
                                      appConstants.updateEmailUsed(true);
                                      appConstants.userModel.usaEmail='';
                                      appConstants.updateSignUpMethod(AppConstants.LOGIN_TYPE_EMAIL);
                                      appConstants.updateEmail('');
                                      checkUserTypeAndGoNext(appConstants: appConstants);

                                    },
                                    child: Text(
                                      'I prefer to use my email',
                                      style: heading4TextSmall(width, color: grey),
                                      ),
                                  ),
        ],
      ),
    );
  }
  void checkUserTypeAndGoNext({required AppConstants appConstants}){
    appConstants.alreadyExistEmailErrorMessageUpdate('');
    appConstants.updateIndex(appConstants.selectedIndex + 1);
    // CustomProgressDialog progressDialog =
    //                               CustomProgressDialog(context, blur: 10);
    //                                 progressDialog
    //                                     .setLoadingWidget(CustomLoadingScreen());
    //                                 progressDialog.show();
    Future.delayed(Duration(seconds: 1),
     (){
      try {
        if (widget.secondryUser==true) {
          logMethod(title: "Parent Section", message: ' Outside');
          // progressDialog.dismiss();
          pageController.jumpToPage(appConstants.selectedIndex);
          
          } else {
            logMethod(title: "Parent Section", message: 'Parent Inside');
            // progressDialog.dismiss();
            pageControllerParent.jumpToPage(appConstants.selectedIndex);
          }
          } catch (e) {
        // progressDialog.dismiss();
      }

     }
     );
  }
}