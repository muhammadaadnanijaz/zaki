// ignore_for_file: file_names, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:ndialog/ndialog.dart';
import 'package:provider/provider.dart';
import 'package:zaki/Constants/HelperFunctions.dart';
// import 'package:zaki/Constants/NotificationTitle.dart';
import 'package:zaki/Constants/Whitelable.dart';
import 'package:zaki/Screens/ConfirmPin.dart';
import 'package:zaki/Screens/PinCodeSetUp.dart';
import 'package:zaki/Widgets/LoginTypesList.dart';
import 'package:zaki/Widgets/ZakiPrimaryButton.dart';
import '../Constants/AppConstants.dart';
import '../Constants/Spacing.dart';
import '../Constants/Styles.dart';
import '../Services/SharedPrefMnager.dart';
import '../Services/api.dart';
import '../Widgets/AppBars/AppBar.dart';
import '../Widgets/CustomLoadingScreen.dart';
import '../Widgets/SSLCustom.dart';
import 'InviteMainScreen.dart';
import 'YourSelf.dart';

enum SingingCharacter { yes, no }
PageController pageController = PageController(initialPage: 0);

class AccountSetupAsAkid extends StatefulWidget {
  final bool? secondryPinCodeUser; 
  const AccountSetupAsAkid({Key? key, this.secondryPinCodeUser}) : super(key: key);

  @override
  _AccountSetupAsAkidState createState() => _AccountSetupAsAkidState();
}

class _AccountSetupAsAkidState extends State<AccountSetupAsAkid> {
  // int appConstants.selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    // pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var appConstants = Provider.of<AppConstants>(context, listen: true);
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () async {
        if (appConstants.selectedIndex != 0) {
          appConstants.updateIndex(appConstants.selectedIndex - 1);
          setState(() {
            // appConstants.selectedIndex = appConstants.selectedIndex - 1;
            pageController.jumpToPage(appConstants.selectedIndex);

            // print('slected Index is: ${_tabController.index}');
          });

          return false;
        } else {
          // return true;
          return false;
        }
        // return true;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        // appBar: AppBar(
        //   leading: IconButton(
        //     onPressed: (){
        //       if (appConstants.selectedIndex!=0) {
        //         setState(() {
        //           appConstants.selectedIndex = appConstants.selectedIndex-1;
        //          pageController.jumpToPage(appConstants.selectedIndex);
    
        //         // print('slected Index is: ${_tabController.index}');
        //       });
        //       }
        //     },
        //     icon: Icon(Icons.arrow_back, color: appConstants.selectedIndex==0?transparent:black,)),
        //   backgroundColor: transparent,
        //     elevation: 0,
        // ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.05),
            child: Column(
              children: [
                appBarHeader_001(
                    context: context,
                    height: height,
                    width: width,
                    leadingIcon: false),
                Row(
                  children: [
                    appConstants.selectedIndex<=1?
                    SizedBox(width: 10,):
                    InkWell(
                      onTap: (){
                        // if(appConstants.selectedIndex==0 || appConstants.selectedIndex<0){
                        //   Navigator.pop(context);
                        //   // return;
                        // }
                        if (appConstants.selectedIndex != 0) {
                          appConstants.updateIndex(appConstants.selectedIndex - 1);
                                  setState(() {
                                    // appConstants.selectedIndex = appConstants.selectedIndex - 1;
                                    pageController.jumpToPage(appConstants.selectedIndex);

                                    // print('slected Index is: ${_tabController.index}');
                                  });

                                  // return false;
                                }
                        // else {
                        //   return true;
                        // }
                        // return true;
                        },
                      child: Icon(Icons.arrow_back)),

                    Expanded(
                      child: Center(
                        child: Text(
                          appConstants.selectedIndex == 0
                                  ? 'Sign Up with':
                          appConstants.selectedIndex == 1
                              ? 'Tell Us About Yourself'
                              : appConstants.selectedIndex == 2
                                  ? 'Quick Access Setup'
                                        : 'Confirm PIN Code',
                          style: appBarTextStyle(context, width),
                        ),
                      ),
                    ),
                    Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SSLCustom(),
                            ],
                          ),
                //     Padding(
                //   padding: const EdgeInsets.only(left: 25.0),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.end,
                //     children: [
                //       SSLCustom(),
                //     ],
                //   ),
                // ),
                  ],
                ),
                appConstants.selectedIndex == 0?
                SizedBox(
                  height: 50,
                ):
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: CustomStepper(
                          color: appConstants.selectedIndex >= 1 ? green : grey,
                        ),
                      ),
                      Expanded(
                        child: CustomStepper(
                          color: appConstants.selectedIndex >= 2 ? green : grey,
                        ),
                      ),
                      Expanded(
                        child: CustomStepper(
                          color: appConstants.selectedIndex >= 3 ? green : grey,
                        ),
                      ),
                    ],
                  ),
                ),
                spacing_medium,
                
                Expanded(
                  child: PageView(
                    controller: pageController,
                    // onPageChanged: (index){
                    // },
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      LoginTypesList(secondryUser: true),
                      YouSelfInformation(secondaryUser: true),
                      PinCodeSetUp(secondryPinCodeUser: widget.secondryPinCodeUser),
                      ConfirmPin(secondryPinCodeUser: widget.secondryPinCodeUser)
                    ],
                  ),
                ),
                appConstants.selectedIndex == 3
                    ? ZakiPrimaryButton(
                        title: 'Confirm',
                        width: width,
                        onPressed:  (appConstants.fullPinConfirm.length <appConstants.pinLength || appConstants.fullPinConfirm!=appConstants.fullPin)? null:
                         () async {
                          logMethod(title: 'Current User and Parent User', message: 'Current User: ${await UserPreferences().getCurrentUserId()} and Parent user${await UserPreferences().getCurrentUserId()}');
                          // return;
                          
                          // if (!formGlobalKeyPinCodeSetupConfirm.currentState!
                          //     .validate()) {
                          //   showNotification(
                          //       error: 1,
                          //       icon: Icons.error,
                          //       message: 'Enter Fields first');
                          //   return;
                          // }
     
                          //     else{
                          appConstants.updatePinEnable(true);
                          CustomProgressDialog progressDialog =
                              CustomProgressDialog(context, blur: 10);
                          progressDialog.setLoadingWidget(
                            CustomLoadingScreen()
                          );
                          progressDialog.show();
                          ApiServices service = ApiServices();
                          // UserPreferences userPref = UserPreferences();
                          // List mobileDevices = [
                          //   await service.getDeviceId()
                          // ];
    
                          await service.updateKidForFirstTime(
                            dob: appConstants.userModel.usaDob,
                            email: appConstants.email,
                            firstName: appConstants.userModel.usaFirstName,
                            lastName: appConstants.userModel.usaLastName,
                            isEnabled: true,
                            phoneNumber: appConstants.phoneNumber,
                            pinCode: appConstants.pin,
                            pinEnabled: appConstants.pinEnable,
                            pinLength: appConstants.pinLength,
                            userId: appConstants.userRegisteredId,
                            userFullyRegistred: true,
                            pincodeSetupDateTime: DateTime.now()
                          );
                          await service.newUserCreateDbDefault(gender: appConstants.genderType, parentId: appConstants.userRegisteredId, status: appConstants.signUpRole, userId: appConstants.userRegisteredId);
                          // return;
                          ///For Current User Upgrade
                          await service.kidAddedIntoFriendListUpdatedStatus(currentUserId:appConstants.userRegisteredId, requestSenderId: appConstants.userModel.userFamilyId);
                          ///For Other user upgrade
                          // service.kidAddedIntoFriendListUpdatedStatus(requestSenderId: await userPref.getCurrentUserId(), currentUserId: appConstants.userModel.userFamilyId);
                          if(appConstants.userModel.usaUserType!=AppConstants.USER_TYPE_PARENT){
                           service.getUserTokenAndSendNotification(
                                              userId: appConstants.userModel.userFamilyId, 
                                              title: '${appConstants.userModel.usaUserName} ${NotificationText.ZAKI_PAY_JOINED_NOTIFICATION_TITLE}', 
                                              subTitle: '${NotificationText.ZAKI_PAY_JOINED_NOTIFICATION_SUB_TITLE}');
                          }
                          // await service.updateFromUserInvitedListStatus(
                          //     exist.data()[AppConstants.USER_Invited_By_Id],
                          //     appConstants.phoneNumber,
                          //     exist.id,
                          //     currentUserId: response,
                          //     requestSenderPhoneNumber: userData[AppConstants.USER_phone_number],
                          //     requestSenderName: '${userData[AppConstants.USER_first_name]} ${userData[AppConstants.USER_last_name]}'
                          //     );
                          progressDialog.dismiss();
                          showNotification(
                              message: '${NotificationText.ADDED_SUCCESSFULLY} ${appConstants.firstName }',
                              error: 0,
                              icon: Icons.check);
                          appConstants.updateKidsSignUpFirstTime(true);
                          Future.delayed(const Duration(seconds: 2), () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const InviteMainScreen()));
                          });
                          // clearFields();
                          // //Navigator.push(context, MaterialPageRoute(builder: (context)=>const LoginPersonType()));
                          // }
                        })
                    : 
                    (appConstants.selectedIndex == 0)?
                    SizedBox():
                    ZakiPrimaryButton(
                        title: 'Next',
                        width: width,
                        onPressed: (appConstants.alreadyExistEmailErrorMessage !=''|| appConstants.signUpMethod=='') 
                        || ((appConstants.selectedIndex==1) && (appConstants.firstName.isEmpty||appConstants.lastName.isEmpty
                        || appConstants.dateOfBirth=='mm / dd / yyyy' 
                        // || appConstants.userName.isEmpty || appConstants.alreadyExistEmailErrorMessage!='' || appConstants.alreadyExistUserNameErrorMessage!='' 
                        || ((DateTime.now().year - (int.parse(appConstants.userModel.usaDob!.split('/').last.trim().toString())) > 13
                        //  && appConstants.userModel.usaUserType!=AppConstants.USER_TYPE_KID 
                         && ( appConstants.alreadyExistEmailErrorMessage!='' || appConstants.alreadyExistUserNameErrorMessage!='' || appConstants.email.isEmpty)))
                        // ||appConstants.zipCode.isEmpty||appConstants.zipCode.length<5
                        // || appConstants.selectedCountrySate=='Select State'
                        ))? null:
                          ((appConstants.selectedIndex==2) && appConstants.fullPin.length <appConstants.pinLength)? null
                          :() async {
                          ApiServices service = ApiServices();
                          if (appConstants.selectedIndex == 1) {
                            // if (!formGlobalKey.currentState!
                            //     .validate()) {
                              //  if (appConstants.dateOfBirth ==
                              //       'mm / dd / yyyy') {
                              //     showNotification(
                              //         error: 1,
                              //         icon: Icons.error,
                              //         message: 'Select Data of birth');
                              //     return;
                              //   }
                              //   showNotification(
                              //       error: 1,
                              //       icon: Icons.error,
                              //       message: 'Enter Fields first');
                              //   return;
                              // }
                            await service.updateUserAfterYourSelfInfo(
                                    zipCode: appConstants.zipCode,
                                    dob: appConstants.dateOfBirth,
                                    // email: appConstants.email,
                                    email: '',
                                    firstName: appConstants.userModel.usaFirstName,
                                    lastName: appConstants.userModel.usaLastName,
                                    gender: appConstants.genderType,
                                    phoneNumber: appConstants.phoneNumber,
                                    userId: appConstants.userRegisteredId,
                                    userName: appConstants.userName,
                                    userType: appConstants.signUpRole,
                                    userState: appConstants.selectedCountrySate
                                  );
                          }
                          // if (appConstants.selectedIndex==1) {
    
                          //   if (!formGlobalKeyPinCodeSetup.currentState!.validate()) {
                          //     showNotification(
                          //       error: 1,
                          //       icon: Icons.pin,
                          //       message: 'Enter Pin'
                          //     );
                          //     return;
                          //   }
    
                          // }
                          if (appConstants.selectedIndex == 2) {
                            // if (!formGlobalKeyPinCodeSetupConfirm.currentState!.validate()) {
                            //   showNotification(
                            //     error: 1,
                            //     icon: Icons.pin,
                            //     message: 'Enter Pin'
                            //   );
                            //   return;
                            // } else{
    
                            // }
                          }
                          appConstants.updateIndex(appConstants.selectedIndex + 1);
                          // appConstants.selectedIndex = appConstants.selectedIndex + 1;
                          setState(() {});
                          pageController.jumpToPage(appConstants.selectedIndex);
                        })
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomStepper extends StatelessWidget {
  const CustomStepper({Key? key, required this.color}) : super(key: key);
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        height: 3.5,
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
