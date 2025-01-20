// ignore_for_file: unnecessary_null_comparison

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:local_auth/local_auth.dart';
import 'package:ndialog/ndialog.dart';
import 'package:provider/provider.dart';
import 'package:zaki/Constants/AuthMethods.dart';
import 'package:zaki/Constants/HelperFunctions.dart';
import 'package:zaki/Constants/LocationGetting.dart';
import 'package:zaki/Constants/NotificationTitle.dart';
import 'package:zaki/Constants/Styles.dart';
import 'package:zaki/Screens/LoginWithPinCode.dart';
import 'package:zaki/Screens/WhatsAppSignUpScreen.dart';
import 'package:zaki/Services/api.dart';
import 'package:zaki/Widgets/TextHeader.dart';
import 'package:zaki/Widgets/ZakiCircularButton.dart';
import 'package:zaki/Widgets/ZakiPrimaryButton.dart';
import '../Constants/AppConstants.dart';
import '../Constants/Spacing.dart';
import '../Services/SharedPrefMnager.dart';
import '../Widgets/CustomLoadingScreen.dart';
import 'HomeScreen.dart';
import 'VerificationCodeWhatsapp.dart';

class WhatsAppLoginScreen extends StatefulWidget {
  final bool? fromForgetPassword;
  const WhatsAppLoginScreen({Key? key, this.fromForgetPassword})
      : super(key: key);

  @override
  _WhatsAppLoginScreenState createState() => _WhatsAppLoginScreenState();
}

class _WhatsAppLoginScreenState extends State<WhatsAppLoginScreen> {
  final formGlobalKey = GlobalKey<FormState>();
  DateTime? _lastQuitTime = DateTime.now();
  final numberController = TextEditingController();
  String? numberExist = '';
  final LocalAuthentication auth = LocalAuthentication();
  bool canAuthenticate = true;
  bool? touchEnabled=false;
  final ExpansionTileController expansionTileController =
      ExpansionTileController();
  
  String? userLat;
  String? userLang;

  @override
  void dispose() {
    numberController.dispose();
    super.dispose();
  }

  void clearFields() {
    numberController.text = '';
    setState(() {});
  }
    void _showDisclosureDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        var width = MediaQuery.of(context).size.width;
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(14.0))),
          title: Text('Location Permission Required'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'ZakiPay collects location data to enable personalized experiences.',
              ),
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
            ZakiCicularButton(
                      title:'     Yes     ',
                      width: width,
                      textStyle: heading4TextSmall(width, color: green),
                      onPressed: (){
                        Navigator.of(context).pop();
                        getUserLocationFromInitState();
                      },
                    ),
            SizedBox(
              width: 10,
            ),
            ZakiCicularButton(
                      title: '      No      ',
                      width: width,
                      selected: 4,
                      backGroundColor: green,
                      border: false,
                      textStyle: heading4TextSmall(width, color: white),
                      onPressed: (){
                        Navigator.of(context).pop();
                      },
                    )
          ],)
            ],
          ),
        );
      },
    );
  }

  getUserLocationFromInitState() async{
     // var appConstants = Provider.of<AppConstants>(context, listen: false);
      //It means that we are from signup screen
        try {
          Position userLocation =await UserLocation().determinePosition();
          UserPreferences userPref = UserPreferences();
           await userPref.userPermssionStatusSave(true);
          setState(() {
          userLat = userLocation.latitude.toString();
          userLang = userLocation.longitude.toString();
          logMethod(title: '---->>Lat and long', message: '$userLat,$userLang');
        
      });
        } catch (e) {
          setState(() {
          userLat = null;
          userLang =null;
          logMethod(title: '---->>Lat and long', message: '$userLat,$userLang');
          });

        }
  }
  String? currentUserTouchId;
  @override
  void initState() {
     Future.delayed(Duration.zero, () async {
      if(Platform.isAndroid){
        UserPreferences userPref = UserPreferences();
      bool? userStatusSaved = await userPref.getUserPermssionStatusSave();
      if(userStatusSaved==false||userStatusSaved==null){
        _showDisclosureDialog(context);
      }   
      }

       
   });
    checkUserTouchId();
    super.initState();
  }

  checkUserTouchId() async {
   

    //////////////////First if we are here on that screen screen should not load
    ///One variable should be added so if we are on that screen it will not
    ///reload like 
    final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
    canAuthenticate =
        canAuthenticateWithBiometrics || await auth.isDeviceSupported();
    UserPreferences userPref = UserPreferences();
    String? userId = await userPref.getCurrentUserIdForLoginTouch();
    if (userId != null) {
      setState(() {
        currentUserTouchId = userId;
      });
    }
    Future.delayed(Duration.zero, (){
      if(widget.fromForgetPassword == true){
        expansionTileController.expand();
      }

    });
  }
  bool canPop = false;


  @override
  Widget build(BuildContext context) {
    var appConstants = Provider.of<AppConstants>(context, listen: true);
    // var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return PopScope(
    canPop: false,
      onPopInvoked: (bool value) {

          if (DateTime.now().difference(_lastQuitTime!).inSeconds > 1) {
          showSnackBarDialog(
              context: context, message: 'Press back button to exit');
          // Scaffold.of(context)
          //     .showSnackBar(SnackBar(content: Text('Press again Back Button exit')));
          _lastQuitTime = DateTime.now();
          // return false;
        } else {
          SystemChannels.platform.invokeMethod('SystemNavigator.pop');
          return;
        }
        setState(() {
          canPop= !value;
        });

        if (canPop) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Click once more to go back"),
              duration: Duration(milliseconds: 1500),
            ),
          );
        }
      // },
      // onWillPop: () async {
      //   if (DateTime.now().difference(_lastQuitTime!).inSeconds > 1) {
      //     showSnackBarDialog(
      //         context: context, message: 'Press back button to exit');
      //     // Scaffold.of(context)
      //     //     .showSnackBar(SnackBar(content: Text('Press again Back Button exit')));
      //     _lastQuitTime = DateTime.now();
      //     return false;
      //   } else {
      //     SystemChannels.platform.invokeMethod('SystemNavigator.pop');
      //     return true;
      //   }
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: getCustomPadding(),
              child: Form(
                key: formGlobalKey,
                autovalidateMode: AutovalidateMode.disabled,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    
                    if(widget.fromForgetPassword == true)
                    Column(
                      children: [
                        spacing_medium,
                    IconButton(
                      padding: EdgeInsets.zero,
                      visualDensity: VisualDensity.compact,
                      // constraints: BoxConstraints.tight(Size.zero),
                      icon: Icon(
                        Icons.clear),
                      onPressed: (){
                        Navigator.pop(context);
                      },
                      ),
                    spacing_medium,
                      ],
                    ),
                    Center(
                        child: Image.asset(
                            imageBaseAddress + 'zakipay_logo_signUp.png')),
                    spacing_small,
                    (widget.fromForgetPassword != true)
                    
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Log In:',
                                style: appBarTextStyle(context, width,
                                    color: darkGrey),
                              ),
                              Row(
                                children: [
                                  if(currentUserTouchId != null)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(color: green.withValues(alpha:0.3)),
                                        borderRadius: BorderRadius.circular(6)
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: InkWell( 
                                          // constraints: BoxConstraints.loose(Size.zero),
                                          // padding: EdgeInsets.zero,
                                          // visualDensity: VisualDensity.compact,
                                            onTap: () async {
                                              DocumentSnapshot<Map<String, dynamic>>? userData = await ApiServices().getUserDataFromId(id: currentUserTouchId);
                                              if(userData!=null)
                                              Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                   LoginWithPinCode(firstName: userData[AppConstants.USER_first_name].toString(), pinCode: userData[AppConstants.USER_pin_code],userId: currentUserTouchId.toString(), pinCodeLength: userData[AppConstants.USER_pin_code_length])));
                                            },
                                            child: Icon(
                                              Icons.pin_outlined,
                                              color: green,
                                              // size: ,
                                            )),
                                      ),
                                    ),
                                  ),
                                if (currentUserTouchId != null && canAuthenticate)
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(color: green.withValues(alpha:0.3)),
                                      borderRadius: BorderRadius.circular(6)
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: InkWell( 
                                        // padding: EdgeInsets.zero,
                                        // visualDensity: VisualDensity.compact,
                                          onTap: () async {
                                            setState(() {
                                              touchEnabled = true;
                                            });
                                            UserPreferences userPref = UserPreferences();
                                            String? userId = await userPref.getCurrentUserIdForLoginTouch();
                                            logMethod(title: 'LogOut User id:', message: userId.toString());
                                            if(userId!=null){
                                                bool isAuth =
                                                    await ApiServices().userLoginBioMetric();
                                              CustomProgressDialog progressDialog =
                                                  CustomProgressDialog(context, blur: 6);
                                                if (isAuth) {
                                              progressDialog.setLoadingWidget(CustomLoadingScreen());
                                              progressDialog.show();
                                      
                                                  await ApiServices().getNickNames(
                                                      context: context, userId: currentUserTouchId);
                                                  appConstants.updateUserId(currentUserTouchId!);
                                                  await ApiServices().getUserData(
                                                      userId: currentUserTouchId, context: context);
                                                  // showSnackBarDialog(
                                                  //     context: context,
                                                  //     message: 'Authenticated successfully');
                                                  Future.delayed(const Duration(seconds: 1), () {
                                                    FocusManager.instance.primaryFocus?.unfocus();
                                                    progressDialog.dismiss();
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                const HomeScreen()));
                                                  });
                                                } else {
                                                  progressDialog.dismiss();
                                                  
                                                }
                                                              
                                            }
                                                          // await userPref.clearLoggedInUser();
                                                          // if(appConstants.userModel.usaTouchEnable!=null && appConstants.userModel.usaTouchEnable==true){
                                                          //   await userPref.saveCurrentUserIdForLoginTouch(appConstants.userRegisteredId);
                                                          //   String? userId = await userPref.getCurrentUserIdForLoginTouch();
                                                          //   logMethod(title: 'LogOut User id:', message: userId.toString());
                                                          // } else{
                                                          //   userPref.clearCurrentUserIdForLoginTouch();
                                                          // }
                                                          
                                            // ApiServices services = ApiServices();
                                            //         await services.updateUserTouchStatus(
                                            //             appConstants.userRegisteredId, value);
                                          },
                                          child: Icon(
                                            Icons.fingerprint,
                                            color: green,
                                          )),
                                    ),
                                  ),
                                ],
                              )
                            
                            ],
                          )
                        : Center(
                            child: Text(
                            'Reset Your PIN Code',
                            style: appBarTextStyle(context, width),
                          )),
                    
                    if(widget.fromForgetPassword != true)
                    Column(
                      children: [
                        spacing_medium,
                        if(Platform.isAndroid)
                        LoginTypesButton(
                          width: width,
                          title: 'Continue with Google',
                          iconColor: green,
                          icon: FontAwesomeIcons.google,
                          onPressed: () async{
                            UserCredential? info = await ApiServices()
                                .signInWithGoogle(googleSignIn);
                            if (info != null) {

                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text(info.additionalUserInfo!.isNewUser
                                      ? 'New user Register successfully'
                                      : 'Successfully Logged in email: ${info.user?.email}')));
                              if(!info.additionalUserInfo!.isNewUser){
                                CustomProgressDialog progressDialog =
                            CustomProgressDialog(context, blur: 10);
                        progressDialog.setLoadingWidget(CustomLoadingScreen());
                        progressDialog.show();

                                ApiServices service = ApiServices();
                                    dynamic user = await service.loginUserThroughEmail(
                                  context: context,
                                  email: info.user!.email.toString());
                          if (user != null) {
                            if(userLat!=null){
                            Placemark? loggedInUserAddress = await getAddressFromCoordinates(latlung: user.docs[0].data()[AppConstants.USER_lat_lng]);
                          Placemark? deviceLoggedInUserAddress = await getAddressFromCoordinates(latlung: "$userLat,$userLang");
                          if((loggedInUserAddress!.locality!=deviceLoggedInUserAddress!.locality) && hasThirtyMinutesPassed(lastLoginTime: user.docs[0].data()[AppConstants.USER_LAST_LOGIN_DATE_TIME].toDate())){
                            showNotification(error: 1, icon: Icons.error_outline, message: NotificationText.THRITY_MIN_PASSED_ERROR);
                            progressDialog.dismiss();
                            return;
                          }
                            }
                           service.userLoginWorkFlow(user: user, appConstants: appConstants, context: context, progressDialog: progressDialog);

                            // });
                          } else {
                            progressDialog.dismiss();
                            showNotification(
                                error: 1,
                                icon: Icons.error,
                                message:
                                   NotificationText.NO_USER_REGISTERED );
                          }
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
                                UserCredential? info = await ApiServices()
                                .signInWithApple();
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
                            if (info != null) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text(info.additionalUserInfo!.isNewUser
                                      ? 'New user Register successfully'
                                      : 'Successfully Logged in email: ${info.user?.email}')));
                              if(!info.additionalUserInfo!.isNewUser){
                                CustomProgressDialog progressDialog =
                            CustomProgressDialog(context, blur: 10);
                        progressDialog.setLoadingWidget(CustomLoadingScreen());
                        progressDialog.show();

                                ApiServices service = ApiServices();
                                    dynamic user = await service.loginUserThroughEmail(
                                  context: context,
                                  email: info.user!.email.toString());
                          if (user != null) {
                            if(userLat!=null){
                            Placemark? loggedInUserAddress = await getAddressFromCoordinates(latlung: user.docs[0].data()[AppConstants.USER_lat_lng]);
                          Placemark? deviceLoggedInUserAddress = await getAddressFromCoordinates(latlung: "$userLat,$userLang");
                          if((loggedInUserAddress!.locality!=deviceLoggedInUserAddress!.locality) && hasThirtyMinutesPassed(lastLoginTime: user.docs[0].data()[AppConstants.USER_LAST_LOGIN_DATE_TIME].toDate())){
                            showNotification(error: 1, icon: Icons.error_outline, message: NotificationText.THRITY_MIN_PASSED_ERROR);
                            progressDialog.dismiss();
                            return;
                          }
                            }
                           service.userLoginWorkFlow(user: user, appConstants: appConstants, context: context, progressDialog: progressDialog);

                            // });
                          } else {
                            progressDialog.dismiss();
                            showNotification(
                                error: 1,
                                icon: Icons.error,
                                message:
                                   NotificationText.NO_USER_REGISTERED );
                          }
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
                          spacing_medium,
                          LoginTypesButton(
                          width: width,
                          title: 'Continue with X',
                          iconColor: blue,
                          icon: FontAwesomeIcons.xTwitter,
                          onPressed: () async{
                            UserCredential? info = await signInWithTwitter();
                            if (info != null) {

                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text(info.additionalUserInfo!.isNewUser
                                      ? 'New user Register successfully'
                                      : 'Successfully Logged in email: ${info.user?.email}')));
                              if(!info.additionalUserInfo!.isNewUser){
                                CustomProgressDialog progressDialog =
                            CustomProgressDialog(context, blur: 10);
                        progressDialog.setLoadingWidget(CustomLoadingScreen());
                        progressDialog.show();

                                ApiServices service = ApiServices();
                                    dynamic user = await service.loginUserThroughEmail(
                                  context: context,
                                  email: info.user!.email.toString());
                          if (user != null) {
                            if(userLat!=null){
                              Placemark? loggedInUserAddress = await getAddressFromCoordinates(latlung: user.docs[0].data()[AppConstants.USER_lat_lng]);
                              Placemark? deviceLoggedInUserAddress = await getAddressFromCoordinates(latlung: "$userLat,$userLang");
                              if((loggedInUserAddress!.locality!=deviceLoggedInUserAddress!.locality) && hasThirtyMinutesPassed(lastLoginTime: user.docs[0].data()[AppConstants.USER_LAST_LOGIN_DATE_TIME].toDate())){
                                showNotification(error: 1, icon: Icons.error_outline, message: NotificationText.THRITY_MIN_PASSED_ERROR);
                              progressDialog.dismiss();
                                return;
                              }
                            }
                           service.userLoginWorkFlow(user: user, appConstants: appConstants, context: context, progressDialog: progressDialog);

                            // });
                          } else {
                            progressDialog.dismiss();
                            showNotification(
                                error: 1,
                                icon: Icons.error,
                                message:
                                   NotificationText.NO_USER_REGISTERED );
                          }
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
                    spacing_medium,
                      ],
                    ),
                    if(widget.fromForgetPassword != true)
                    Center(
                        child: TextValue3(
                      title: '--OR--',
                    )),
                    spacing_medium,
                    // TextHeader1(
                    //   title:
                    //   'Enter your Mobile Number',
                    // ),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                              color: borderColor, 
                              width:  1)),
                      child: Theme(
                        data:
                            Theme.of(context).copyWith(dividerColor: transparent),
                            child: ExpansionTile(
                                // key: UniqueKey(),
                                // initiallyExpanded: _isExpanded,
                                controller: expansionTileController,
                            
                                maintainState: true,
                                // backgroundColor: Colors.red,
                                // collapsedBackgroundColor: Colors.yellow,
                                // shape: roundedBorderCustom(sunscriptionValue: appConstants.userModel.subScriptionValue),
                                // collapsedShape: roundedBorderCustom(sunscriptionValue: appConstants.userModel.subScriptionValue),
                                onExpansionChanged: (value) {},
                                childrenPadding: getCustomPadding(),
                                iconColor: green,
                                // initiallyExpanded: appConstants.userModel.subScriptionValue==2?false:true ,
                                title:  Text(
                                  (widget.fromForgetPassword == true)? '':'New Family Member / Login via Mobile #',
                                  style: heading3TextStyle(width)
                                  ),
                              children:[
                                 TextFormField(
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                inputFormatters: [
                                  // CardFormatter(sample: "XXX-XXX-XXX", separator: "-")
                                  // maskFormatter
                                  appConstants.selectedCountry==AppConstants.COUNTRY_SAUDIA? saudiaMaskFormatter:qatarMaskFormatter
                                ],
                                validator: (number){
                                      if (number!.isEmpty) {
                                        return 'Enter a Number';
                                      } else if ((number.length  < (appConstants.selectedCountry==AppConstants.COUNTRY_SAUDIA? 11 : 10))) {
                                        return 'Enter Full Mobile Number';
                                      }
                                      return null;
                                    },
                                // style: TextStyle(color: primaryColor),
                                style:
                                    heading2TextStyle(context, width, color: lightGrey),
                                controller: numberController,
                                obscureText: false,
                                keyboardType: TextInputType.number,
                                maxLines: 1,
                                onChanged: (String number) {
                                  if(numberExist!=''){
                                  setState(() {
                                    numberExist = '';
                                  });
                                  }
                                   
                                },
                                decoration: InputDecoration(
                                  hintText: 'Enter your Mobile #',
                                  errorText: numberExist == '' ? null : numberExist,
                                  hintStyle:
                                      heading2TextStyle(context, width, color: lightGrey),
                                  contentPadding: const EdgeInsets.only(top: 18),
                                  prefixIcon: customCountryPicker(appConstants, width),
                                //       prefixIcon: CountryCodePicker(
                                //         onChanged: print,
                                //         enabled: false,
                                //         textStyle: heading3TextStyle(width, color: grey),
                                //         // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                                //         initialSelection: 'US',
                                //         // favorite: ['+39','FR'],
                                //         // optional. Shows only country name and flag
                                //         showCountryOnly: false,
                                //         showFlag: false,
                                //         countryFilter: const ['US'],
                                //         // optional. Shows only country name and flag when popup is closed.
                                //         showOnlyCountryWhenClosed: false,
                                //         // optional. aligns the flag and the Text left
                                //         alignLeft: false,
                                // )
                                ),
                              ),
                              spacing_small,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Verification code will be sent to ',
                            style: heading4TextSmall(width),
                          ),
                          Icon(
                            FontAwesomeIcons.whatsapp,
                            color: green,
                            size: width * 0.05,
                          ),
                          Text(
                            ' Whatsapp ',
                            style: heading4TextSmall(width, color: green),
                          ),
                        ],
                      ),
                      spacing_large,
                      ZakiPrimaryButton(
                          title: widget.fromForgetPassword == true
                              ? 'Reset PIN Code'
                              : 'Log in',
                          width: width,
                          onPressed: 
                          // numberController.text.length < (appConstants.selectedCountry==AppConstants.COUNTRY_SAUDIA? 11: 10)
                          //     ? null
                          //     : 
                              () async { 
                                  resetPreviousData(appConstants);
                                  if (formGlobalKey.currentState!.validate()) {
                                    logMethod(title: 'Dial Code', message: appConstants.selectedCountryDialCode.toString());
                                    bool userExist = await ApiServices()
                                        .isUserExist(
                                            // context: context,
                                            number: '${appConstants.selectedCountryDialCode}${getPhoneNumber(number: numberController.text)}');
                                    if (!userExist) {
                                      setState(() {
                                        numberExist =
                                            "Mobile number not registered, try a different number.";
                                      });
                                      return;
                                    }
                                    // var userData = await ApiServices().checkUserSubscriptionValue(
                                    //   number: getPhoneNumber(number: numberController.text)
                                    //   );
                                    //   if(userData!=null){
                                    //   logMethod(title: 'User kids', message: 'Subscription Value:: ${userData[AppConstants.USER_SubscriptionValue]}, parent id: ${userData[AppConstants.USER_Family_Id]} and User Id: ${userData[AppConstants.USER_UserID]}');
                                    // if(userData[AppConstants.USER_SubscriptionValue] <2 && userData[AppConstants.USER_Family_Id]!=userData[AppConstants.USER_UserID]){
                                    //   setState(() {
                                    //     numberExist =
                                    //         "Please Ask your parent to setup your wallet.";
                                    //   });
                                    //   return;
                                    //     }
                                    //   }
                                      // return;
                    
                                    // appConstants.updateSignUpMethod('WhatsApp');
                                    appConstants.updatePhoneNumber('${appConstants.selectedCountryDialCode}${getPhoneNumber(number: numberController.text)}');
                                    
                                    ////////If from Forget Password
                                    if (widget.fromForgetPassword == true) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const VerficationCodeWhatsapp(
                                                  fromRestPassword: true),
                                        ),
                                      );
                                      return;
                                    }
                                    // appConstants
                                    //     .updateFirstName(numberController.text);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                             VerficationCodeWhatsapp(
                                                fromSignUpScreen: true,
                                                touchEnabled: touchEnabled
                                                ),
                                      ),
                                    );
                                  }
                                }),
                      spacing_medium,
                              ]                  
                            ),
                          ),
                        ),
                    
                    
                    spacing_medium,
                    if(widget.fromForgetPassword != true)
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                              color: borderColor, 
                              width:  1)),
                      child: Theme(
                        data:
                            Theme.of(context).copyWith(dividerColor: transparent),
                            child: ExpansionTile(
                                // key: UniqueKey(),
                                // initiallyExpanded: _isExpanded,
                                // controller: expansionTileController,
                            
                                maintainState: true,
                                // backgroundColor: Colors.red,
                                // collapsedBackgroundColor: Colors.yellow,
                                // shape: roundedBorderCustom(sunscriptionValue: appConstants.userModel.subScriptionValue),
                                // collapsedShape: roundedBorderCustom(sunscriptionValue: appConstants.userModel.subScriptionValue),
                                onExpansionChanged: (value) {
                                },
                                childrenPadding: getCustomPadding(),
                                iconColor: green,
                                // initiallyExpanded: appConstants.userModel.subScriptionValue==2?false:true ,
                                title: (widget.fromForgetPassword == true)
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Got an account? ',
                                  style: heading3TextStyle(width),
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const WhatsAppLoginScreen()));
                                  },
                                  child: Text(
                                    'Log In',
                                    style: heading3TextStyle(width,
                                        color: green, underLine: true),
                                  ),
                                ),
                              ],
                            )
                          : Center(
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Want to Raise Smart Kids? Sign Up for FREE Now',
                                    style: heading3TextStyle(width),
                                  ),
                                  spacing_small,
                                  // InkWell(
                                  //   onTap: () {
                                  //     Navigator.of(context).pushAndRemoveUntil(
                                  //       MaterialPageRoute(
                                  //         builder: (context) =>
                                  //             const WhatsAppSignUpScreen(),
                                  //       ),
                                  //       (_) => false,
                                  //     );
                          
                                  //     // Navigator.push(
                                  //     //     context,
                                  //     //     MaterialPageRoute(
                                  //     //         builder: (context) =>
                                  //     //             const WhatsAppSignUpScreen()));
                                  //   },
                                  //   child: Text(
                                  //     'Sign Up for FREE Now!',
                                  //     style: heading3TextStyle(width,
                                  //         underLine: true, color: green),
                                  //   ),
                                  // ),
                                ],
                              ),
                          ),
                              children:[
                      spacing_large,
                      ZakiPrimaryButton(
                          title: 'Signup',
                          width: width,
                          onPressed: () async { 
                                    // appConstants
                                    //     .updateFirstName(numberController.text);
                                    Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const WhatsAppSignUpScreen(),
                                        ),
                                        (_) => false,
                                      );
                                  
                                }),
                      spacing_medium,
                              ]                  
                            ),
                          ),
                        ),
                    spacing_large,
                    // if (currentUserTouchId != null && canAuthenticate)
                    //   Center(
                    //       child: InkWell(
                    //     onTap: () async {
                    //       bool isAuth =
                    //           await ApiServices().userLoginBioMetric();
                    //       if (isAuth) {
                    //         await ApiServices().getNickNames(
                    //             context: context, userId: currentUserTouchId);
                    //         appConstants.updateUserId(currentUserTouchId!);
                    //         await ApiServices().getUserData(
                    //             userId: currentUserTouchId, context: context);
                    //         showSnackBarDialog(
                    //             context: context,
                    //             message: 'Authenticated successfully');
                    //         Future.delayed(const Duration(seconds: 1), () {
                    //           FocusManager.instance.primaryFocus?.unfocus();
                    //           Navigator.push(
                    //               context,
                    //               MaterialPageRoute(
                    //                   builder: (context) =>
                    //                       const HomeScreen()));
                    //         });
                    //       } else {
                    //         showSnackBarDialog(
                    //             context: context,
                    //             message: 'Ooops...Something went wrong');
                    //       }
                    //     },
                    //     child: Platform.isIOS
                    //         ? Image.asset(
                    //             imageBaseAddress + "face_icon.png",
                    //             width: 60,
                    //             height: 60,
                    //           )
                    //         : Icon(
                    //             Icons.fingerprint,
                    //             color: green,
                    //             size: 50,
                    //           ),
                    //   ))
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class LoginTypesButton extends StatelessWidget {
  const LoginTypesButton({
    Key? key,
    required this.width,
    this.title,
    required this.onPressed,
    this.icon,
    this.iconColor,

  }) : super(key: key);

  final double width;
  final String? title;
  final Function()? onPressed;
  final Color? iconColor;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: OutlinedButton.icon(
        style:  OutlinedButton.styleFrom(
          side: BorderSide(
            color: borderColor, 
            width: 1,
            ),
          shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // <-- Radius
        ),
        ),
        icon: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
          child: Icon(
            icon,
            color: iconColor?? green,
            ),
        ), 
        label: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            title.toString(),
            style: heading3TextStyle(width, bold: true),
            )),
        onPressed:onPressed, 
        ),
    );
  }
}
