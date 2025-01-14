// ignore_for_file: file_names, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:ndialog/ndialog.dart';
import 'package:provider/provider.dart';
import 'package:zaki/Constants/HelperFunctions.dart';
import 'package:zaki/Constants/NotificationTitle.dart';
import 'package:zaki/Constants/Spacing.dart';
import 'package:zaki/Screens/ConfirmPin.dart';
import 'package:zaki/Screens/InviteMainScreen.dart';
import 'package:zaki/Screens/PinCodeSetUp.dart';
import 'package:zaki/Screens/YourSelf.dart';
import 'package:zaki/Widgets/AppBars/AppBar.dart';
import 'package:zaki/Widgets/CustomSizedBox.dart';
import 'package:zaki/Widgets/LoginTypesList.dart';
import 'package:zaki/Widgets/ZakiPrimaryButton.dart';
import '../Constants/AppConstants.dart';
import '../Constants/Styles.dart';
import '../Services/SharedPrefMnager.dart';
import '../Services/api.dart';
import '../Widgets/CustomLoadingScreen.dart';
import '../Widgets/SSLCustom.dart';
import 'AskYourParent.dart';
 
PageController pageControllerParent = PageController(initialPage: 0);
enum SingingCharacter { yes, no }

class AccountSetupInformation extends StatefulWidget {
  const AccountSetupInformation({Key? key}) : super(key: key);

  @override
  _AccountSetupInformationState createState() =>
      _AccountSetupInformationState();
}

class _AccountSetupInformationState extends State<AccountSetupInformation> {
  // late PageController pageControllerParent;
  // int appConstants.selectedIndex = 0;
  // int selectedIndexMe = 0;
  ApiServices service = ApiServices();

  @override
  void initState() {
    // pageControllerParent = PageController(initialPage: appConstants.selectedIndex);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    pageControllerParent.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var appConstants = Provider.of<AppConstants>(context, listen: true);
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        // if (appConstants.accountSettingUpFor == "Me") {
        //   if (selectedIndexMe != 0) {
        //     setState(() {
        //       selectedIndexMe = selectedIndexMe - 1;
        //       pageControllerParent.jumpToPage(selectedIndexMe);

        //       // print('slected Index is: ${_tabController.index}');
        //     });

        //     return false;
        //   }
        // } else 
        if (appConstants.selectedIndex != 0) {
          appConstants.updateIndex(appConstants.selectedIndex - 1);
          setState(() {
            // appConstants.selectedIndex = appConstants.selectedIndex - 1;
            pageControllerParent.jumpToPage(appConstants.selectedIndex);

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
        //          pageControllerParent.jumpToPage(appConstants.selectedIndex);

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
            padding: getCustomPadding(),
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                appBarHeader_001(
                  context: context,
                  height: height,
                  width: width,
                  leadingIcon: false,
                ),
                // appConstants.accountSettingUpFor == 'Me '
                //     ? Text(
                //         selectedIndexMe == 0
                //             ? 'Tell Us About Yourself'
                //             : selectedIndexMe == 1
                //                 ? 'Quick Access Setup'
                //                 : 'Confirm PIN Code',
                //         style: appBarTextStyle(context, width),
                //       )
                //     : 
                    Row(
                        children: [
                          appConstants.selectedIndex<=1?
                            SizedBox(width: 10,):
                          InkWell(
                              onTap: () {
                                // if (appConstants.accountSettingUpFor == "Me") {
                                //   if (selectedIndexMe != 0) {
                                //     setState(() {
                                //       selectedIndexMe = selectedIndexMe - 1;
                                //       pageControllerParent
                                //           .jumpToPage(selectedIndexMe);

                                //       // print('slected Index is: ${_tabController.index}');
                                //     });

                                //     // return false;
                                //   }
                                // } else 
                                if (appConstants.selectedIndex != 1) {
                                  appConstants.updateIndex(appConstants.selectedIndex - 1);
                                  setState(() {
                                    // appConstants.selectedIndex = appConstants.selectedIndex - 1;
                                    pageControllerParent.jumpToPage(appConstants.selectedIndex);

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
                                    // : appConstants.selectedIndex == 1
                                    //     ? 'What about your Family?'
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
                        ],
                      ),
                CustomSizedBox(height: height),
                // appConstants.accountSettingUpFor == 'Me'
                //     ? 
                //     Padding(
                //         padding: const EdgeInsets.symmetric(horizontal: 20.0),
                //         child: Row(
                //           children: [
                //             Expanded(
                //               child: CustomStepper(
                //                 color: selectedIndexMe >= 0
                //                     ? primaryButtonColor
                //                     : grey.withValues(alpha:0.3),
                //               ),
                //             ),
                //             Expanded(
                //               child: CustomStepper(
                //                 color: selectedIndexMe >= 1
                //                     ? primaryButtonColor
                //                     : grey.withValues(alpha:0.3),
                //               ),
                //             ),
                //             Expanded(
                //               child: CustomStepper(
                //                 color: selectedIndexMe >= 2
                //                     ? primaryButtonColor
                //                     : grey.withValues(alpha:0.3),
                //               ),
                //             ),
                //           ],
                //         ),
                //       )
                //     : 
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
                                color: appConstants.selectedIndex >= 1
                                    ? primaryButtonColor
                                    : grey.withValues(alpha:0.3),
                              ),
                            ),
                            // if (appConstants.accountSettingUpFor != "Me")
                              Expanded(
                                child: CustomStepper(
                                  color: appConstants.selectedIndex >= 2
                                      ? primaryButtonColor
                                      : grey.withValues(alpha:0.3),
                                ),
                              ),
                            Expanded(
                              child: CustomStepper(
                                color: appConstants.selectedIndex >= 3
                                    ? primaryButtonColor
                                    : grey.withValues(alpha:0.3),
                              ),
                            ),
                            // Expanded(
                            //   child: CustomStepper(
                            //     color: appConstants.selectedIndex >= 3
                            //         ? primaryButtonColor
                            //         : grey.withValues(alpha:0.3),
                            //   ),
                            // )
                          ],
                        ),
                      ),
                spacing_medium,
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 25.0),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.end,
                //     children: [
                //       SSLCustom(),
                //     ],
                //   ),
                // ),
                Expanded(
                  child: PageView(
                    controller: pageControllerParent,
                    // onPageChanged: (index){

                    // },
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      LoginTypesList(),
                      YouSelfInformation(),
                      // if (appConstants.accountSettingUpFor != "Me")
                      //   FamilyInformation(),
                      PinCodeSetUp(),
                      ConfirmPin()
                    ],
                  ),
                ),
                (appConstants.selectedIndex == 3)
                    ? ZakiPrimaryButton(
                        title: 'Confirm',
                        width: width,
                        onPressed: (appConstants.fullPinConfirm.length <
                                    appConstants.pinLength ||
                                appConstants.fullPinConfirm !=
                                    appConstants.fullPin)
                            ? null
                            : () async {
                                //////////////Validation comment
                                // if (!confirmPinGlobalKey.currentState!.validate()) {
                                //     showNotification(
                                //       error: 1,
                                //       icon: Icons.error,
                                //       message: 'Pin code error'
                                //     );
                                //     return;
                                //   }
                                //////////////Validation comment
                                logMethod(
                                    title: 'Confirm PIN Code Length',
                                    message:
                                        ' Pin : ${appConstants.fullPin} length: ${appConstants.pinLength}');
                                if (appConstants.fullPinConfirm.length <
                                        appConstants.pinLength ||
                                    appConstants.fullPinConfirm !=
                                        appConstants.fullPin) {
                                  // showNotification(
                                  //     error: 1,
                                  //     icon: Icons.pin,
                                  //     message: NotificationText.ENTER_PIN_CODE);
                                  return;
                                }
                                // else{
                                showNotification(
                                    message:
                                        'User Type: ${appConstants.signUpRole} and Gender: ${appConstants.genderType}',
                                    error: 0,
                                    icon: Icons.check);
 
                                ////////////
                                CustomProgressDialog progressDialog =
                                    CustomProgressDialog(context, blur: 10);
                                progressDialog
                                    .setLoadingWidget(CustomLoadingScreen());
                                progressDialog.show();
                                UserPreferences userPref = UserPreferences();
                                ApiServices service = ApiServices();
                                List mobileDevices = [
                                  await service.getDeviceId()
                                ];
                                service.newUserUpdatedAfterConfirmPin(
                                    deviceId: mobileDevices,
                                    zipCode: appConstants.zipCode,
                                    currentUserid:
                                        await userPref.getCurrentUserId(),
                                    email: appConstants.email,
                                    firstName: appConstants.firstName,
                                    lastName: appConstants.lastName,
                                    password: appConstants.password,
                                    firstLegalName: appConstants.userModel.usaLegalFirstName,
                                    lastLegalName: appConstants.userModel.usaLegalLastName,
                                    city: '',
                                    country: appConstants.selectedCountry,
                                    currency: appConstants.currency,
                                    dob: appConstants.dateOfBirth,
                                    status: appConstants.signUpRole,
                                    gender: appConstants.genderType,
                                    isEmailVerified: true,
                                    latLng: '',
                                    locationStatus: true,
                                    method: appConstants.signUpMethod,
                                    notificationStatus: true,
                                    phoneNumber: appConstants.phoneNumber,
                                    pinCode: appConstants.pin.toString(),
                                    pinEnabled: true,
                                    pinLength: appConstants.pinLength,
                                    userName: appConstants.userName,
                                    parentId: (appConstants.userModel.userFamilyId!=null||appConstants.userModel.userFamilyId!='')? appConstants.userModel.userFamilyId : 
                                        appConstants.signUpRole == 'Parent'
                                            ? appConstants.userRegisteredId
                                            : '',
                                    isEnabled: true,
                                    userStatus: true,
                                    userFullyRegistred: true,
                                    touchEnable: appConstants.isTouchEnable,
                                    pincodeSetupDateTime: DateTime.now(),
                                    seeKids: appConstants.userModel.seeKids,
                                    subscriptionValue: appConstants.userModel.subScriptionValue??0
                                    );
                                // appConstants.signUpRole
 
                                await service.newUserCreateDbDefault(
                                    gender: appConstants.genderType,
                                    parentId: appConstants.userRegisteredId,
                                    status: appConstants.signUpRole,
                                    userId: await userPref.getCurrentUserId());
                                // return;
                                await service.getUserData(
                                    userId: appConstants.userRegisteredId,
                                    context: context);
                                // await service.updateUserParentId(id: appConstants.userRegisteredId, parentId: appConstants.userRegisteredId);
                                progressDialog.dismiss();
                                showNotification(
                                    message: NotificationText.ADDED_SUCCESSFULLY,
                                    error: 0,
                                    icon: Icons.check);

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
                        onPressed:(appConstants.alreadyExistEmailErrorMessage !=''|| (appConstants.signUpMethod=='')) 
                                || ((appConstants.selectedIndex == 1) &&
                                (appConstants.firstName.isEmpty ||
                                    appConstants.lastName.isEmpty ||
                                    // appConstants.zipCode.isEmpty ||
                                    // appConstants.zipCode.length < 5 ||
                                    appConstants.dateOfBirth ==
                                        'mm / dd / yyyy' ||
                                    appConstants.email.isEmpty ||
                                    appConstants.userName.isEmpty ||
                                    appConstants
                                            .alreadyExistEmailErrorMessage !=
                                        '' ||
                                    appConstants
                                            .alreadyExistUserNameErrorMessage !=
                                        '' 
                                        // ||
                                    // appConstants.selectedCountrySate ==
                                    //     'Select State'
                                        ))
                            ? null
                            : ((appConstants.selectedIndex == 3 ) &&
                                    appConstants.fullPin.length <
                                        appConstants.pinLength)
                                ? null
                                :
                                // ((appConstants.selectedIndex==0 || selectedIndexMe==0) && (formGlobalKey.currentState!=null && !formGlobalKey.currentState!.validate()))? null:
                                () async {
                                    if ((appConstants.selectedIndex == 1) &&
                                        (appConstants.accountSettingUpFor !=
                                                "Me" ||
                                            appConstants.accountSettingUpFor ==
                                                "Me")) {
                                      // if(formGlobalKey.currentState!=null)
                                      // if (!formGlobalKey.currentState!.validate()) {

                                      //   showNotification(
                                      //       error: 1,
                                      //       icon: Icons.error,
                                      //       message: 'Enter Fields first');
                                      //   return;
                                      // } else{
                                      //   if (appConstants.dateOfBirth ==
                                      //       'mm / dd / yyyy') {
                                      //     showNotification(
                                      //         error: 1,
                                      //         icon: Icons.error,
                                      //         message: 'Select Data of birth');
                                      //     return;
                                      //   }
                                      // }
                                      if (appConstants.dateOfBirthWithDate !=
                                          null) {
                                        await service.updateUserType(
                                            id: appConstants.userRegisteredId);
                                        // appConstants.updateUserId(id);
                                        //Remove email
                                        await service 
                                            .updateUserAfterYourSelfInfo(
                                                zipCode: appConstants.zipCode,
                                                dob: appConstants.dateOfBirth,
                                                // email: appConstants.email,
                                                email: '',
                                                firstName:
                                                    appConstants.firstName,
                                                lastName: appConstants.lastName,
                                                gender: appConstants.genderType,
                                                phoneNumber:
                                                    appConstants.phoneNumber,
                                                userId: appConstants
                                                    .userRegisteredId,
                                                userName: appConstants.userName,
                                                userType:
                                                    appConstants.signUpRole,
                                                userState: appConstants
                                                    .selectedCountrySate);
                                        logMethod(
                                            title: 'Selected State',
                                            message:
                                                ' State : ${appConstants.selectedCountrySate}');
                                        // return;
                                        if (calculateAge(
                                                birthDate: appConstants
                                                    .dateOfBirthWithDate) <
                                            18) {
                                          Navigator.push(context,
                                              MaterialPageRoute(
                                                  builder: (context) {
                                            return AskYourParent();
                                          }));
                                          return;
                                        }
                                        // showNotification(
                                        //     error: 0,
                                        //     icon: Icons.check,
                                        //     message: appConstants.userRegisteredId);
                                      }
                                    }

                                    // if (appConstants.selectedIndex == 1 &&
                                    //     appConstants.haveKids == 'Yes') {
                                    //   CustomProgressDialog progressDialog =
                                    //       CustomProgressDialog(context,
                                    //           blur: 10);
                                    //   progressDialog.setLoadingWidget(
                                    //       CustomLoadingScreen());
                                    //   progressDialog.show();

                                    //   ApiServices service = ApiServices();
                                    //   List mobileDevices = [
                                    //     await service.getDeviceId()
                                    //   ];
                                    //   for (var i = 0;
                                    //       i <
                                    //           appConstants
                                    //               .kidsRegistrationList.length;
                                    //       i++) {
                                    //     service.newUserPhoneVerification(
                                    //         deviceId: mobileDevices,
                                    //         parentId:
                                    //             appConstants.userRegisteredId,
                                    //         email: '',
                                    //         zipCode: '',
                                    //         firstName: appConstants
                                    //                 .kidsRegistrationList[i]
                                    //             ['value'],
                                    //         lastName: '',
                                    //         password: appConstants.password,
                                    //         status: 'Kid',
                                    //         city: '',
                                    //         country:
                                    //             appConstants.selectedCountry,
                                    //         currency: 'US',
                                    //         dob: '',
                                    //         gender: '',
                                    //         isEmailVerified: true,
                                    //         latLng: '',
                                    //         locationStatus: true,
                                    //         method: appConstants.signUpMethod,
                                    //         notificationStatus: true,
                                    //         phoneNumber: '',
                                    //         pinCode:
                                    //             appConstants.pin.toString(),
                                    //         pinEnabled: false,
                                    //         pinLength: appConstants.pinLength,
                                    //         userName: '',
                                    //         isEnabled: false,
                                    //         userStatus: false,
                                    //         userFullyRegistred: false);
                                    //   }
                                    //   progressDialog.dismiss();
                                    //   showNotification(
                                    //       message: 'Woohooo ... User Added!',
                                    //       error: 0,
                                    //       icon: Icons.check);
                                    // }
                                    if (appConstants.selectedIndex == 2) {
                                      //////////////Validation comment
                                      // if(formGlobalKeyPinCodeSetup.currentState!=null)
                                      // if (!formGlobalKeyPinCodeSetup.currentState!
                                      //     .validate()) {
                                      logMethod(
                                          title: 'Length of PIN Code',
                                          message:
                                              ' Pin : ${appConstants.fullPin} lenght: ${appConstants.pinLength}');
                                      if (appConstants.fullPin.length <
                                          appConstants.pinLength) {
                                        // showNotification(
                                        //     error: 1,
                                        //     icon: Icons.pin,
                                        //     message: NotificationText.ENTER_PIN);
                                        return;
                                      }
                                      //////////////Validation comment
                                    }
                                    // if (selectedIndexMe == 1) {
                                    //   //////////////Validation comment
                                    //   logMethod(
                                    //       title: 'Pin Length',
                                    //       message:
                                    //           ' Pin : ${appConstants.fullPin} lenght: ${appConstants.pinLength}');
                                    //   if (appConstants.fullPin.length <
                                    //       appConstants.pinLength) {
                                    //     showNotification(
                                    //         error: 1,
                                    //         icon: Icons.pin,
                                    //         message: 'Quick Access Setup');
                                    //     return;
                                    //   }

                                      // if (!formGlobalKeyPinCodeSetup.currentState!
                                      //     .validate()) {
                                      //   showNotification(
                                      //       error: 1,
                                      //       icon: Icons.pin,
                                      //       message: 'Enter Pin');
                                      //   return;
                                      // }
                                      //////////////Validation comment
                                    // }
                                    // if (appConstants.accountSettingUpFor ==
                                    //     "Me") {
                                    //   selectedIndexMe = selectedIndexMe + 1;
                                    //   setState(() {});
                                    //   pageControllerParent
                                    //       .jumpToPage(selectedIndexMe);
                                    //   return;
                                    // }

                                    appConstants.selectedIndex = appConstants.selectedIndex + 1;
                                    setState(() {});
                                    pageControllerParent.jumpToPage(appConstants.selectedIndex);
                                    showNotification(
                                        message:
                                            'User Type: ${appConstants.signUpRole} and Gender: ${appConstants.genderType}',
                                        error: 0,
                                        icon: Icons.check);
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
