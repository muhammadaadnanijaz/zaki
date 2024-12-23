// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:zaki/Constants/AppConstants.dart';
import 'package:zaki/Constants/NotificationTitle.dart';
import 'package:zaki/Constants/Styles.dart';
import 'package:zaki/Widgets/CustomConfermationScreen.dart';
import 'package:zaki/Widgets/EnableBioMetricWidget.dart';
import 'package:zaki/Widgets/ZakiPrimaryButton.dart';
import '../Constants/HelperFunctions.dart';
import '../Constants/IntialSetup.dart';
import '../Constants/Spacing.dart';
import '../Services/SharedPrefMnager.dart';
import '../Services/api.dart';
import '../Widgets/AppBars/AppBar.dart';

class ConfirmPin extends StatefulWidget {
  final int? fromKidsSignUpPag;
  final bool? fromActivate;
  final String? userId;
  final bool? secondryPinCodeUser;

  const ConfirmPin(
      {Key? key, this.fromKidsSignUpPag, this.fromActivate, this.userId, this.secondryPinCodeUser})
      : super(key: key);

  @override
  _ConfirmPinState createState() => _ConfirmPinState();
}

class _ConfirmPinState extends State<ConfirmPin> {
  bool obSecureFields = true;
  final restConfirmPinCodeCodeFormKey = GlobalKey<FormState>();
  // String? error = 'no error';
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
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 0),
      child: SingleChildScrollView(
        child: Form(
          // key:confirmPinGlobalKey,
          // key: formGlobalKeyPinCodeSetupConfirm,
          key: restConfirmPinCodeCodeFormKey,
          autovalidateMode: AutovalidateMode.disabled,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (widget.fromKidsSignUpPag == 0)
                appBarHeader_005(
                    context: context,
                    appBarTitle: 'Confirm PIN Code',
                    backArrow: true,
                    height: height,
                    width: width,
                    leadingIcon: true),
              SizedBox(
                height: height * 0.03,
              ),
              widget.secondryPinCodeUser==true?
              spacing_X_large:
              Column(
                children: [
                  EnableBioMetricWidget(appConstants: appConstants, width: width),
                    spacing_medium,
                    Text('-- & -- ', style: heading4TextSmall(width),),
                    // spacing_medium,
                  SizedBox(
                    height: height * 0.03,
                  ),

                ],
              ),

              Center(
                child: Container(
                  color: transparent,
                  // margin: const EdgeInsets.all(20.0),
                  padding: const EdgeInsets.symmetric(horizontal: 2.0),
                  child: Pinput(
                    length: appConstants.pinLength,
                    controller: pinCodeController,
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
                      } else if (appConstants.pin != encryptedValue(value: pin)) {
                        return 'PIN Code does not match :( ';
                      } else {
                        return null;
                      }
                    },
                    // errorText: error==''? null: error,
                    onChanged: (String pin) {
                      appConstants.updateExactFullPinConfirm(pin);
                    },
                  ),
                ),
              ),
              textValueBelow,
              if (widget.fromKidsSignUpPag == 0)
                ZakiPrimaryButton(
                    width: width,
                    title: 'Confirm',
                    onPressed: (pinCodeController.text.isEmpty ||
                            (appConstants.pinLength == 4 &&
                                pinCodeController.text.length < 4) ||
                            (appConstants.pinLength == 6 &&
                                    pinCodeController.text.length < 6 ||
                                appConstants.pin !=
                                    encryptedValue(
                                        value: pinCodeController.text)))
                        ? null
                        : () async {
                            // if (error =='' && pinCodeController.length==4) {

                            // }
                            // if (!formGlobalKeyPinCodeSetupConfirm.currentState!.validate()){
                            //   return;
                            // }
                            // else{
                            int length = pinCodeController.text.length;
                            if (pinCodeController.text.isEmpty) {
                              showNotification(
                                  error: 1,
                                  icon: Icons.check,
                                  message: 'First, enter PIN Code.');

                              return;
                            } else if ((appConstants.pinLength == 4 &&
                                    length < 4) ||
                                (appConstants.pinLength == 6 && length < 6)) {
                              showNotification(
                                  error: 1,
                                  icon: Icons.check,
                                  message: NotificationText.ENTER_PIN);
                              return;
                            } else if (appConstants.pin !=
                                encryptedValue(value: pinCodeController.text)) {
                              showNotification(
                                  error: 1,
                                  icon: Icons.check,
                                  message: NotificationText.PIN_CODE_NOT_MATCHED);
                              return;
                            }
                            appConstants.updatePinEnable(true);
                            if (widget.fromActivate == true) {
                              ApiServices().updateKidStatus(
                                  dob: appConstants.dateOfBirth,
                                  firstName: appConstants.firstName,
                                  lastName: appConstants.lastName,
                                  phoneNumber: "",
                                  zipCode: appConstants.userModel.zipCode,
                                  pinEnabled: appConstants.registrationCheckBox,
                                  isEnabled: false,
                                  kidEnabled: true,
                                  pinUser: true,
                                  userId: widget.userId,
                                  gender: appConstants.genderType,
                                  userType: appConstants.signUpRole);
                                  
                                ApiServices().addFriendsAutumatically(signedUpStatus: false, isFavorite: true, requestReceiverrId: widget.userId, currentUserId: appConstants.userRegisteredId, number: '', requestReceiverName: '${appConstants.firstName.trim()} ${appConstants.lastName.trim()}', requestSenderName: '${appConstants.userModel.usaFirstName} ${appConstants.userModel.usaLastName}', requestSenderPhoneNumber: appConstants.userModel.usaPhoneNumber);
                                if(appConstants.signUpRole==AppConstants.USER_TYPE_SINGLE  || appConstants.signUpRole == AppConstants.USER_TYPE_PARENT){

                                } else
                                IntialSetup.addDefaultPersonalozationSettings(userId: widget.userId, parentId: appConstants.userRegisteredId);
                              
                              showNotification(
                                  error: 0,
                                  icon: Icons.check,
                                  message: NotificationText.USER_UPDATED);
                                  // CustomConfermationScreen
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                          builder: (context) => CustomConfermationScreen(
                                            // title: 'Allowance Updated',
                                            subTitle: "${appConstants.firstName} is now part of your family!",
                                            )));
                              return;
                            }

                            // Navigator.pop(context, "Matched");
                            // }

                            // if (respose == "Matched") {
                            ApiServices service = ApiServices();
                            List mobileDevices = [await service.getDeviceId()];
                            UserPreferences userPref = UserPreferences();
                            String? newAddedUserId = 
                            await service.newUserPhoneVerification(
                                
                                deviceId: mobileDevices,
                                parentId: (appConstants.userModel.usaUserType ==
                                        AppConstants.USER_TYPE_PARENT)
                                    ? appConstants.userModel.userFamilyId
                                    : await userPref.getCurrentUserId(),
                                email: '',
                                zipCode: appConstants.userModel.zipCode,
                                firstName: appConstants.firstName,
                                lastName: appConstants.lastName,
                                password: '',
                                status: appConstants.signUpRole,
                                gender: appConstants.genderType,
                                city: '',
                                country: appConstants.selectedCountry,
                                currency: 'US',
                                dob: appConstants.dateOfBirth,
                                isEmailVerified: false,
                                latLng: '',
                                locationStatus: true,
                                method: appConstants.signUpMethod,
                                notificationStatus: true,
                                phoneNumber: '',
                                pinCode: appConstants.pin.toString(),
                                pinEnabled: true,
                                pinLength: appConstants.pinLength,
                                userName: '',
                                touchEnable: appConstants.isTouchEnable,
                                isEnabled: false,
                                kidEnabled: true,
                                isPinUser: true,
                                userStatus: false,
                                userFullyRegistred: false);
                            service.addFriendsAutumatically(signedUpStatus: false, isFavorite: true, requestReceiverrId: newAddedUserId, currentUserId: appConstants.userRegisteredId, number: '', requestReceiverName: '${appConstants.lastName} ${appConstants.firstName}', requestSenderName: '${appConstants.userModel.usaFirstName} ${appConstants.userModel.usaLastName}', requestSenderPhoneNumber: appConstants.userModel.usaPhoneNumber);
                            ApiServices().addFriendsAutumatically(signedUpStatus: false, isFavorite: true, requestReceiverrId: widget.userId, currentUserId: appConstants.userRegisteredId, number: '', requestReceiverName: '${appConstants.firstName.trim()} ${appConstants.lastName.trim()}', requestSenderName: '${appConstants.userModel.usaFirstName} ${appConstants.userModel.usaLastName}', requestSenderPhoneNumber: appConstants.userModel.usaPhoneNumber);
                            if(appConstants.signUpRole==AppConstants.USER_TYPE_SINGLE  || appConstants.signUpRole == AppConstants.USER_TYPE_PARENT){
                              
                            } else
                            IntialSetup.addDefaultPersonalozationSettings(userId: widget.userId, parentId: appConstants.userRegisteredId);
                            
                            showNotification(
                                error: 0,
                                icon: Icons.check,
                                message: NotificationText.USER_ADDED);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CustomConfermationScreen(
                                            // title: 'Allowance Updated',
                                            subTitle: "${appConstants.firstName} is now part of your family!",
                                            )
                                  )
                                );
                            // }
                          }),
              SizedBox(
                height: height * 0.2,
              ),

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
