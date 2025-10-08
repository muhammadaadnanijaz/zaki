import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ndialog/ndialog.dart';
import 'package:provider/provider.dart';
import 'package:zaki/Constants/LocationGetting.dart';
import 'package:zaki/Constants/Whitelable.dart';
// import 'package:zaki/Constants/NotificationTitle.dart';
import 'package:zaki/Screens/RestPinCode.dart';
import 'package:zaki/Screens/WhosSettingUp.dart';
import 'package:zaki/Services/SharedPrefMnager.dart';
import 'package:zaki/Widgets/AppBars/AppBar.dart';
import 'package:zaki/Widgets/TextHeader.dart';
import 'package:zaki/Widgets/ZakiPrimaryButton.dart';
// import 'package:zaki/Constants/Whitelable.dart';
import '../Constants/AppConstants.dart';
import '../Constants/HelperFunctions.dart';
import '../Constants/Spacing.dart';
import '../Constants/Styles.dart';
import '../Models/UserModel.dart';
import '../Services/api.dart';
import '../Widgets/CustomLoadingScreen.dart';
// import 'AccountSetupAsaKid.dart';
// import 'HomeScreen.dart';
import 'WhoLogin.dart';

// geocoding, geolocator, ndialog, provider, zaki, flutter, font_awesome_flutter, flutter_local_notifications, firebase_messaging, firebase_core, firebase_auth, cloud_firestore, flutter_svg


class VerficationCodeWhatsapp extends StatefulWidget {
  final bool? fromSignUpScreen;
  final bool? fromRestPassword;
  final bool? touchEnabled;
  const VerficationCodeWhatsapp(
      {Key? key, this.fromSignUpScreen, this.fromRestPassword, this.touchEnabled})
      : super(key: key);

  @override
  _VerficationCodeWhatsappState createState() =>
      _VerficationCodeWhatsappState();
}

class _VerficationCodeWhatsappState extends State<VerficationCodeWhatsapp> {
   int _counter = 60;
  Timer? timer;
  String? userLat;
  String? userLang;

  void _startTimer() {
    Future.delayed(Duration.zero, (){
    var appConstants = Provider.of<AppConstants>(context, listen: false);
      logMethod(title: 'User fully registered', message: '${appConstants.userModel.userFullyRegistered.toString()} and ${appConstants.userModel.usaPhoneNumber} and Pin Code: ${appConstants.userModel.usaPinCode} and ${appConstants.userModel.usaUserId}');
    });
    
    _counter = 60;
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
    if(_counter<0){
      timer.cancel();
    }
    if(_counter!=0)
      setState(() {
        _counter--;
      });
    });
  }

   @override
   void initState() {
     super.initState();
     Future.delayed(Duration.zero, () async {
      // var appConstants = Provider.of<AppConstants>(context, listen: false);
      //It means that we are from signup screen
      // if(widget.fromSignUpScreen == true){
        try {
          Position userLocation =await UserLocation().determinePosition();
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

      // }
   });
     _checkUserLocation();
     _startTimer();
   }
   void _checkUserLocation() async{
  Position userLocation =await UserLocation().determinePosition();

      logMethod(title: 'User Location-------->>>', message:"Lat: ${userLocation.latitude} Lang: ${userLocation.longitude} and Full Address is: ${await getAddressFromCoordinates(latlung: "${userLocation.latitude},${userLocation.longitude}")}");

}

   @override
   void dispose() {
    timer!.cancel();
     super.dispose();
   }
  
  @override
  Widget build(BuildContext context) {
    var appConstants = Provider.of<AppConstants>(context, listen: true);
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          height: height,
          child: SingleChildScrollView(
            child: Padding(
              padding: getCustomPadding(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  appBarHeader_005(
                    appBarTitle: 'Enter Verification Code',
                    context: context,
                    backArrow: false,
                    height: height,
                    width: width,
                  ),
                  spacing_large,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextValue2(
                        title: 'Sent to ',
                      ),
                      Icon(
                        FontAwesomeIcons.whatsapp,
                        size: width * 0.05,
                        color: green,
                      ),
                      Text(
                        ' Whatsapp ',
                        style: heading3TextStyle(width, color: green),
                      ),
                      Text(
                        '${appConstants.phoneNumber}',
                        style: heading3TextStyle(width,),
                      ),
                    ],
                  ),
                  spacing_large,
                  // textValueHeaderbelow,
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.08),
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      validator: (String? email) {
                        if (email!.isEmpty) {
                          return 'Enter an email';
                        } else {
                          return null;
                        }
                      },
                      // style: TextStyle(color: primaryColor),
                      style: heading2TextStyle(context, width),
                      // controller: emailCotroller,
                      obscureText: false,
                      keyboardType: TextInputType.number,
                      maxLines: 1,
                      maxLength: 6,
                      decoration: InputDecoration(
                        hintText: 'Enter Verification Code',
                        counterText: '',
                        hintStyle: heading2TextStyle(context, width),
                        // labelText: 'Enter Email',
                        // labelStyle: textStyleHeading2WithTheme(context,width*0.8, whiteColor: 0),
                      ),
                    ),
                  ),
                  spacing_large,
                  Center(
                    child: Column(
                      children: [
                        TextValue3(
                          title: '00:$_counter',
                        ),
                        spacing_medium,
                        TextValue3(
                          title: 'Didn’t get a verification code?',
                        ),
                        TextButton(
                          child: Text(
                            'Resend Code',
                            style: heading4TextSmall(width, color: _counter==0?green:null),
                          ),
                          onPressed: _counter!=0? null: () {
                            _startTimer();
                          },
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: height * 0.3,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.08),
                    child: ZakiPrimaryButton(
                      title: 'Confirm',
                      width: width,
                      onPressed: () async {
                        // After 'Confirm' button is pressed, we are not using any service that is sending code. 
                        // AppConstants.NEED_FIX_CODE;
                        
                        CustomProgressDialog progressDialog =
                            CustomProgressDialog(context, blur: 10);
                        progressDialog.setLoadingWidget(CustomLoadingScreen());
                        progressDialog.show();

                        ApiServices service = ApiServices();


                        ///////If we are from Resset Password Scree
                        if (widget.fromRestPassword == true) { 
                        
                          if(appConstants.userModel.usaUserType==AppConstants.USER_TYPE_PARENT){
                                List<UserModel> pinCodeKidsList = await service.fetchUserPinCodeKids(appConstants.userModel.userFamilyId!, currentUserId: appConstants.userRegisteredId);
                                logMethod(title: 'User Data Length:', message: pinCodeKidsList.length.toString());
                                if(pinCodeKidsList.length==0){
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const RestPinCode()));
                                    return;
                                }
                                Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                               WhoIsLoginWithPin(fromRestPinCode: true,)));
                                  return;
                          }

                          ///Who is Siging In if user has pin code kids as
                          progressDialog.dismiss();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RestPinCode()));
                          return;
                        }
                        appConstants.updateIsLoginFirstTime(true);

                        ////////We are from Login Screen
                        if (widget.fromSignUpScreen == true) {
                          AppConstants.TEMP_CODE;
                          dynamic user = await service.loginUserThroughPhoneNumber(
                                  context: context,
                                  number: appConstants.phoneNumber);
                          if (user != null) {
                           //Now here we need to check user location and stored location is different then we have problem. 
                           //First get the dateTime to check 30 mins and then get users Latlang and check it 
                           ///with current device location latlang 
                          //  user.docs[0].data()[AppConstants.USER_LAST_LOGIN_DATE_TIME]
                          // user.docs[0].data()[AppConstants.USER_lat_lng]
                          // user.docs[0].data()[AppConstants.USER_lat_lng]
                          //If Permission denied
                          if(userLat!=null && (user.docs[0].data()[AppConstants.USER_lat_lng]!=null || user.docs[0].data()[AppConstants.USER_lat_lng]!='')){
                          Placemark? loggedInUserAddress = await getAddressFromCoordinates(latlung: user.docs[0].data()[AppConstants.USER_lat_lng]);
                          if(loggedInUserAddress!=null){
                            Placemark? deviceLoggedInUserAddress = await getAddressFromCoordinates(latlung: "$userLat,$userLang");
                          if((loggedInUserAddress.locality!=deviceLoggedInUserAddress!.locality) && hasThirtyMinutesPassed(lastLoginTime: user.docs[0].data()[AppConstants.USER_LAST_LOGIN_DATE_TIME].toDate())){
                            showNotification(error: 1, icon: Icons.error_outline, message: NotificationText.THRITY_MIN_PASSED_ERROR);
                            progressDialog.dismiss();
                            return;
                          }
                          }
                          
                        }
                        AppConstants.TEMP_CODE;
                           service.userLoginWorkFlow(user: user, appConstants: appConstants, touchEnabled: widget.touchEnabled, context: context, progressDialog: progressDialog);

                            // });
                          } else {
                            progressDialog.dismiss();
                            showNotification(
                                error: 1,
                                icon: Icons.error,
                                message:
                                   NotificationText.NO_PHONE_REGISTERED );
                          }
                          return;
                        }

                        //////////Sign Up
                        // return;
                        AppConstants.TEMP_CODE;
                        List mobileDevices = [await service.getDeviceId()];
                        String? response =
                            await service.newUserPhoneVerification(
                          zipCode: appConstants.zipCode,
                          deviceId: mobileDevices,
                          email: appConstants.email,
                          firstName: appConstants.firstName,
                          lastName: appConstants.lastName,
                          password: appConstants.password,
                          status: appConstants.signUpRole,
                          city: '',
                          country: appConstants.selectedCountry,
                          currency: appConstants.currency,
                          dob: appConstants.dateOfBirth,
                          gender: appConstants.genderType,
                          isEmailVerified: true,
                          latLng: userLat==null?'': '$userLat,$userLang',
                          locationStatus: true,
                          method: appConstants.signUpMethod,
                          notificationStatus: true,
                          phoneNumber: appConstants.phoneNumber,
                          pinCode: appConstants.pin.toString(),
                          pinEnabled: false,
                          pinLength: appConstants.pinLength,
                          userName: appConstants.userName,
                          touchEnable: appConstants.isTouchEnable,
                          isEnabled: true,
                          userStatus: false,
                          // userFullyRegistred: false,
                        );

                        /////////////////
                        // logMethod(title: 'Number exist in InvitedTable:', message: value.docs[0].data()[AppConstants.USER_Invited_By_Id].toString() );
                        QueryDocumentSnapshot<Map<String, dynamic>>? exist =
                            await service.checkUserExistInInvitedTable(
                                context: context,
                                number: appConstants.phoneNumber);

                        if (exist != null) {
                          logMethod(
                              title: 'Id Exist',
                              message: exist
                                  .data()[AppConstants.USER_Invited_By_Id]);
                          /////////Sending Notifiation to that user Who invited that person
                          Map<dynamic, dynamic>? userData =
                              await service.getFirebaseTokenAndNumber(
                                  id: exist
                                      .data()[AppConstants.USER_Invited_By_Id]);
                          // userData[AppConstants.USER_iNApp_NotifyToken]
                          logMethod(
                              title: 'After Fetching Token from firebase',
                              message: userData![
                                  AppConstants.USER_iNApp_NotifyToken]);

                          if (userData[AppConstants.USER_iNApp_NotifyToken] !=
                              null)
                            await service.sendNotification(
                                title:
                                    'Hi, ${appConstants.phoneNumber} ${NotificationText.ZAKI_PAY_JOINED_NOTIFICATION_TITLE}',
                                body:
                                    '${NotificationText.ZAKI_PAY_JOINED_NOTIFICATION_SUB_TITLE}',
                                token: userData[
                                    AppConstants.USER_iNApp_NotifyToken]);
                          //  return;
                          await service.updateFromUserInvitedListStatus(
                              exist.data()[AppConstants.USER_Invited_By_Id],
                              appConstants.phoneNumber,
                              exist.id,
                              currentUserId: response,
                              requestSenderPhoneNumber:
                                  userData[AppConstants.USER_phone_number],
                              requestSenderName:
                                  '${userData[AppConstants.USER_first_name]} ${userData[AppConstants.USER_last_name]}');
                        } else {
                          logMethod(title: 'Id Exists', message: 'Didnt exist');
                        }

                        ///////////////For Friends List Updated End

                        appConstants.updateUserId(response!);

                        UserPreferences userPref = UserPreferences();

                        await userPref.saveCurrentUserId(response);

                        await service.getUserData(
                            userId: await userPref.getCurrentUserId(),
                            context: context);
                        progressDialog.dismiss();
                        showNotification(
                            message: NotificationText.USER_REGISTERED_SUCCESS,
                            error: 0,
                            icon: Icons.check);
                        Future.delayed(const Duration(seconds: 2), () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const WhosSettingsUp()));
                        });
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


