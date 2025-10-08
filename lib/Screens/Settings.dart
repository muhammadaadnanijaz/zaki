// import 'package:esys_flutter_share_plus/esys_flutter_share_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:zaki/Constants/AppConstants.dart';
import 'package:zaki/Constants/AuthMethods.dart';
import 'package:zaki/Constants/HelperFunctions.dart';
import 'package:zaki/Constants/Styles.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:zaki/Screens/AddMembersWorkFlow.dart';
import 'package:zaki/Screens/EdittedProfile.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:zaki/Screens/HomeScreen.dart';
import 'package:zaki/Screens/MoveInternalMoney.dart';
import 'package:zaki/Screens/PersonalizeKidsExperience.dart';
import 'package:zaki/Screens/PreviousPin.dart';
import 'package:zaki/Screens/ReportAnIssue.dart';
import 'package:zaki/Screens/SpendingLimit.dart';
import 'package:zaki/Screens/WhatsAppLoginScreen.dart';
import 'package:zaki/Services/api.dart';
import 'package:zaki/Widgets/FloatingActionButton.dart';
import '../Constants/Spacing.dart';
import '../Services/SharedPrefMnager.dart';
import '../Widgets/AppBars/AppBar.dart';
import '../Widgets/CustomBottomNavigationBar.dart';
import '../Widgets/ProfileListTileButton.dart';
import 'AccountNickNameScreen.dart';
import 'InviteMainScreen.dart';
import 'IssueDebitCard.dart';
import 'ManageContacts.dart';

class SettingsMainScreen extends StatefulWidget {
  const SettingsMainScreen({Key? key}) : super(key: key);

  @override
  _SettingsMainScreenState createState() => _SettingsMainScreenState();
}

class _SettingsMainScreenState extends State<SettingsMainScreen> {
  int selectedIndex = -1;
  double circularSpacing= 15;
  double verticallyPadding= 8;
  String version = '';
  String buildNumber = '';
  // Stream<QuerySnapshot>? userKids;
  @override
  void initState() {
    super.initState();
    checkPermissions();
    checkVersion();
  }
  checkVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

// String appName = packageInfo.appName;
// String packageName = packageInfo.packageName;
String latestVersion = packageInfo.version;
String latestBuildNumber = packageInfo.buildNumber;
setState(() {
  version = latestVersion;
  buildNumber = latestBuildNumber;
});
  }

  void checkPermissions() async {
    bool isPermission = await Permission.location.status.isDenied;
    Future.delayed(const Duration(milliseconds: 200), () {
      var appConstants = Provider.of<AppConstants>(context, listen: false);
      logMethod(title: 'Enable Face or touch id', message: appConstants.userModel.usaTouchEnable.toString());
      appConstants.updateLocationAllow(!isPermission);
      appConstants.updateTouchIdAllowOrNot(
          appConstants.userModel.usaTouchEnable ?? false);
      // userKids = ApiServices().fetchUserKids(
      //     appConstants.userModel.seeKids == true
      //         ? appConstants.userModel.userFamilyId!
      //         : appConstants.userRegisteredId,
      //     currentUserId: appConstants.userRegisteredId);
      // getUserKidsPersonalizationsSettings(kidId: appConstants.userRegisteredId );
    });
  }

  @override
  Widget build(BuildContext context) {
    var appConstants = Provider.of<AppConstants>(context, listen: true);
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      bottomNavigationBar: CustomBottomNavigationBar(),
      floatingActionButton: CustomFloadtingActionButton(),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                appBarHeader_005(
                    width: width,
                    height: height,
                    context: context,
                    appBarTitle: 'Settings'.tr(),
                    backArrow: true),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: blue),
                    borderRadius: BorderRadius.circular(circularSpacing),
                  ),
                  child: Padding(
                    padding:  EdgeInsets.symmetric(vertical: verticallyPadding),
                    child: ProfileListTileButton( 
                      color: blue,
                      width: width,
                      icon: Icons.person_outline,
                      title: 'Edit Profile',
                      onTap: () {
                        // Navigator.push(context, MaterialPageRoute(builder: (context)=>const Profile()));
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const EdittedProfile()));
                        // Navigator.push(context, MaterialPageRoute(builder: (context)=>const ProfileSettings()));
                      },
                    ),
                  ),
                ),
                spacing_large,

                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: green),
                    borderRadius: BorderRadius.circular(circularSpacing),
                  ),
                  child: Padding(
                    padding:  EdgeInsets.symmetric(vertical: verticallyPadding),
                    child: Column(
                      children: [
                        ProfileListTileButton( color: green,
                          width: width,
                          icon: Icons.phone_outlined,
                          title: 'Manage Contacts',
                          onTap: () async {
                            await ApiServices().getUserData(
                                context: context,
                                userId: appConstants.userRegisteredId);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const ManageContacts()));
                          },
                        ),
                        spacing_medium,
                ProfileListTileButton( color: green,
                  width: width,
                  icon: Icons.send,
                  title: 'Invite Friends & Family',
                  onTap: () async {
                    await ApiServices().getUserData(
                        context: context,
                        userId: appConstants.userRegisteredId);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const InviteMainScreen(
                                  fromHomeScreen: true,
                                )));
                  },
                ),
                if(appConstants.isShareFeature)
                Column(
                  children: [
                spacing_medium,
                ProfileListTileButton( color: green,
                  width: width,
                  icon: Icons.share,
                  title: 'Share My Username',
                  onTap: () async {
                    // final ByteData bytes =
                    //     await rootBundle.load(imageBaseAddress + 'share.png');
                    // await Share.file(
                    //   'Share My Image',
                    //   'esys.png',
                    //   bytes.buffer.asUint8List(),
                    //   'image/png',
                    //   text:
                    //       "${appConstants.userModel.usaUserName} ${AppConstants.ZAKI_PAY_PROMOTIONAL_TEXT}",
                    // );
                    // Share.share('Download ZakiPay and Raise Smart Kids', subject: 'Download ZakiPay and Raise Smart Kids', );
                  },
                ),]
                )
                      ],
                    ),
                  ),
                ),
                
                
                spacing_large,
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: orange),
                    borderRadius: BorderRadius.circular(circularSpacing),
                  ),
                  child: Padding(
                    padding:  EdgeInsets.symmetric(vertical: verticallyPadding),
                    child: Column(
                      children: [
                        ProfileListTileButton( color: orange,
                          width: width,
                          icon: Icons.pin,
                          title: 'Reset PIN Code',
                          onTap: () async{
                             bool? checkAuth = await authenticateTransactionUsingBioOrPinCode(appConstants: appConstants, context: context);
                              if(checkAuth==false){
                                return;
                              }
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const PreviousPinCode()));
                          },
                        ),
                    // if(!checkPrimaryUser(appConstants) && (appConstants.userModel.isUserPinUser!=true))
                    if(appConstants.userModel.isUserPinUser!=true)
                    Column(
                      children: [
                      spacing_medium,
                        Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 2),
                          child: InkWell(
                            onTap: null,
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Container(
                                          decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: orange,
                                          ),
                                          child: Padding(
                        padding: const EdgeInsets.all(4.0),
                                      child: Icon(
                                        Icons.fingerprint,
                                        color: white,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Text(
                                    'Enable Face ID / Touch ID',
                                    style: heading3TextStyle(width),
                                  ),
                                ),
                                const Spacer(),
                                SizedBox(
                                  // width: 30,
                                  // height: 30,
                                  
                                  child: Switch.adaptive(
                                  value: appConstants.touchIdAllowOrNot,
                                  activeColor: green,
                                  // trackColor: grey,
                                    onChanged: (value) async {
                                      bool isAuth = await ApiServices().userLoginBioMetric();
                                      logMethod(title: 'Enabled task', message: isAuth.toString());
                                      if (isAuth) {
                                        appConstants.updateToucheds(value);
                                        ApiServices services = ApiServices();
                                        await services.updateUserTouchStatus(
                                            appConstants.userRegisteredId, value);
                                        await services.getUserData(
                                            userId: appConstants.userRegisteredId,
                                            context: context);
                                        appConstants.updateTouchIdAllowOrNot(value);
                                        // setState(() {
                                        //   appConstants.isTouchEnable = true;
                                        // });
                                        // showSnackBarDialog(
                                        //     context: context, message: 'Biomettric enabled');
                                      } else {
                                        // appConstants.isTouchEnable = false;
                                        // appConstants.updateToucheds(isAuth);
                                        // showSnackBarDialog(
                                        //     context: context,
                                        //     message: 'Ooops...Something went wrong :(');
                                      }
                                      
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    // spacing_medium,
                  //   spacing_small,
                  //   Padding(
                  //     padding:
                  //         const EdgeInsets.symmetric(horizontal: 2),
                  //     child: InkWell(
                  //       onTap: null,
                  //       child: Row(
                  //         children: [
                  //           Padding(
                  //             padding: const EdgeInsets.only(left: 8.0),
                  //             child: Container(
                  // decoration: BoxDecoration(
                  //   borderRadius: BorderRadius.circular(8),
                  //   color: orange,
                  // ),
                  // child: Padding(
                  //   padding: const EdgeInsets.all(4.0),
                  //                 child: Icon(
                  //                   Icons.notifications,
                  //                   color: white,
                  //                 ),
                  //               ),
                  //             ),
                  //           ),
                  //           Padding(
                  //             padding: const EdgeInsets.all(8),
                  //             child: Text(
                  //               'Notification Allow or Not',
                  //               style: heading3TextStyle(width),
                  //             ),
                  //           ),
                  //           const Spacer(),
                  //           Padding(
                  //             padding: const EdgeInsets.only(right: 8.0),
                  //             child: SizedBox(
                  //               width: 30,
                  //               height: 30,
                  //               child: Transform.scale(
                  //                 scale: 0.65,
                  //                 child: CupertinoSwitch(
                  //                   value: appConstants.notificationAllow,
                  //                   activeColor: green,
                  //                   trackColor: grey,
                  //                   onChanged: (value) async {
                  //                     // ApiServices services = ApiServices();
                  //                     // await services.updateUserTouchStatus(
                  //                     //     appConstants.userRegisteredId, value);
                  //                     // await services.getUserData(
                  //                     //     userId: appConstants.userRegisteredId,
                  //                     //     context: context);
                  //                     appConstants.updateNotificationAllow(value);
                  //                   },
                  //                 ),
                  //               ),
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                    // Container(
                    //   color: black,
                    //   height: 0.07,
                    //   width: width,
                    // ),
                      ],
                    ),
                  ),
                ),
                spacing_large,
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: crimsonColor),
                    borderRadius: BorderRadius.circular(circularSpacing),
                  ),
                  child: Padding(
                    padding:  EdgeInsets.symmetric(vertical: verticallyPadding),
                    child: Column(
                      children: [
                        appConstants.appMode!= true
                                          ? SizedBox.shrink()
                                          :
                        Column(
                          children: [
                            ProfileListTileButton( 
                          color: crimsonColor,
                          width: width,
                          icon: Icons.payment,
                          title: 'Manage Debit Cards',
                          onTap: () async{
                            bool? checkAuth = await authenticateTransactionUsingBioOrPinCode(appConstants: appConstants, context: context);
                              if(checkAuth==false){
                                return;
                              }
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const IssueDebitCard()));
                          },
                        ),
                        spacing_medium,
                          ],
                        ),
                        
                ProfileListTileButton( color: crimsonColor,
                  width: width,
                  icon: Icons.credit_score_rounded,
                  title: 'Fund My Wallet',
                  onTap: () async {
                    // bool screenNotOpen = await checkUserSubscriptionValue(appConstants, context);
                    //               if(screenNotOpen==false){
                    // bool? isExist = 
                    await ApiServices()
                        .getCardInfoFromFundMyWallet(
                            userId: appConstants.userRegisteredId,
                            context: context);
                    toUpMethodsBottomSheet(
                                                context: context,
                                                height: height,
                                                width: width);
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => FundMyWallet()));
                    // if (isExist!) {
                    //   Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //           builder: (context) => const ManageLinkedCards()));
                    //   return;
                    // }
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => FundMyWallet()));
                  // }
                  },
                ),
                spacing_medium,
                ProfileListTileButton( color: crimsonColor,
                  width: width,
                  icon: Icons.money,
                  title: 'Move Money (Internal Transfer)',
                  onTap: () async{
                    // bool screenNotOpen = await checkUserSubscriptionValue(appConstants, context);
                    //               if(screenNotOpen==false){
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MoveInternalMoney()));
                  // }
                  },
                ),
                spacing_medium,
                ProfileListTileButton( color: crimsonColor,
                            width: width,
                            icon: Icons.account_circle_outlined,
                            title: 'Wallet Nick Names',
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const AccountNickNameScreen()));
                            },
                          ),
                      ],
                    ),
                  ),
                ),
                spacing_large,
                (appConstants.userModel.usaUserType == AppConstants.USER_TYPE_KID || appConstants.userModel.usaUserType == AppConstants.USER_TYPE_ADULT || appConstants.userModel.usaUserType == AppConstants.USER_TYPE_SINGLE
                // || 
                // appConstants.userModel.userFamilyId!= appConstants.userModel.usaUserId
                )
                    ? const SizedBox()
                    : Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: blue),
                    borderRadius: BorderRadius.circular(circularSpacing),
                  ),
                  child: Padding(
                    padding:  EdgeInsets.symmetric(vertical: verticallyPadding),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ProfileListTileButton( color: blue,
                                width: width,
                                icon: 
                                Icons.person_add,
                                title: 'Add a Family Member',
                                tralingIcon:appConstants.familymemberlimitreached == true? 
                                Icons.check : null,
                                onTap: appConstants.familymemberlimitreached==true? null:  () async{
                                  // bool? checkAuth = await authenticateTransactionUsingBioOrPinCode(appConstants: appConstants, context: context);
                                  //                 if(checkAuth==false){
                                  //                   return;
                                  //                 }
                                  appConstants.updateDateOfBirth('dd / mm / yyyy');
                                  appConstants.updateSignUpRole(AppConstants.USER_TYPE_KID);
                                  appConstants.updateGenderType('Male');
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const AddMemberWorkFlow()));
                                },
                              ),
                              spacing_medium,
                              ProfileListTileButton( color: blue,
                                width: width,
                                icon: Icons.edit,
                                title: 'Parental Controls',
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const PersonalizeKidsExperience()));
                                },
                              ),
                              // 
                              spacing_medium,
                              ProfileListTileButton( color: blue,
                                width: width,
                                icon: Icons.speed_rounded,
                                title: 'Spend Limits',
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                               SpendingLimit()));
                                },
                              ),
                              
                            ],
                          ),
                      ),
                    ),
                    spacing_large,

                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: green),
                    borderRadius: BorderRadius.circular(circularSpacing),
                  ),
                  child: Padding(
                    padding:  EdgeInsets.symmetric(vertical: verticallyPadding),
                    child: Column(
                      children: [
                        ProfileListTileButton( color: green,
                          width: width,
                          icon: Icons.help,
                          title: 'Help Center',
                          onTap: () async{
                            await teamViewMethod(context: context , height: height,width: width, url: "https://zakipay.com/faq/");
                            // openUrl(url: '');
                          },
                        ),
                        spacing_medium,
                    ProfileListTileButton( color: green,
                      width: width,
                      icon: Icons.report,
                      title: 'Report an Issue',
                      onTap: () {
                        appConstants.updateFromReportAnIssue(true);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ReportAnIssue()));
                      },
                    ),
                    spacing_medium,
                    ProfileListTileButton( color: green,
                      width: width,
                      icon: FontAwesomeIcons.lightbulb,
                      title: 'Give us ideas to improve!',
                      onTap: () {
                        appConstants.updateFromReportAnIssue(false);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ReportAnIssue()));
                      },
                    ),
                    // spacing_medium,
                    // Padding(
                    //   padding:
                    //       const EdgeInsets.symmetric(horizontal: 18, vertical: 0),
                    //   child: InkWell(
                    //     onTap: null,
                    //     child: Row(
                    //       children: [
                    //         Icon(
                    //           FontAwesomeIcons.language,
                    //           color: green,
                    //         ),
                    //         Padding(
                    //           padding: const EdgeInsets.only(left: 8.0),
                    //           child: Text(
                    //             'Language',
                    //             style: heading3TextStyle(width),
                    //           ),
                    //         ),
                    //         const Spacer(),
                    //         Row(
                    //           mainAxisSize: MainAxisSize.min,
                    //           children: [
                    //             InkWell(
                    //               onTap: () {
                    //                 // ignore: deprecated_member_use
                    //                 context.locale =
                    //                     context.locale.languageCode == 'ar'
                    //                         ? const Locale('en', 'EN')
                    //                         : const Locale('ar', 'AR');
                    //               },
                    //               child: Text(
                    //                 'Arabic',
                    //                 style: textStyleHeading2WithTheme(
                    //                     context, width * 0.7,
                    //                     whiteColor:
                    //                         context.locale.languageCode == 'ar'
                    //                             ? 2
                    //                             : 0),
                    //               ),
                    //             ),
                    //             Padding(
                    //               padding:
                    //                   const EdgeInsets.symmetric(horizontal: 3.0),
                    //               child: Container(
                    //                 height: 20,
                    //                 width: 1,
                    //                 color: black,
                    //               ),
                    //             ),
                    //             InkWell(
                    //               onTap: () {
                    //                 // ignore: deprecated_member_use
                    //                 context.locale =
                    //                     context.locale.languageCode == 'ar'
                    //                         ? const Locale('en', 'EN')
                    //                         : const Locale('ar', 'AR');
                    //               },
                    //               child: Text(
                    //                 'English',
                    //                 style: textStyleHeading2WithTheme(
                    //                     context, width * 0.7,
                    //                     whiteColor:
                    //                         context.locale.languageCode != 'ar'
                    //                             ? 2
                    //                             : 0),
                    //               ),
                    //             ),
                    //           ],
                    //         )
                    //       ],
                    //     ),
                    //   ),
                    // ),
                      ],
                    ),
                  ),
                ),
                
                spacing_large,
                CustomTextButton(
                  width: width * 0.8,
                  title: 'Privacy policy',
                  onPressed: () async{
                    await teamViewMethod(context: context , height: height,width: width, url: "https://zakipay.com/privacy-policy/");
                    // await showDialog(
                    // context: context,
                    // builder:(BuildContext context) {
                    //   return TermsView(url: 'https://zakipay.com/privacy-policy/',);
                    //   },
                    // );
                    // openUrl(url: 'https://zakipay.com/privacy-policy/');
                  },
                ),
                spacing_medium,
                CustomTextButton(
                  width: width * 0.8,
                  title: 'User Terms & Conditions',
                  onPressed: () async{
                    await teamViewMethod(context: context , height: height,width: width, url: "https://zakipay.com/terms-conditions/");
                    // await showDialog(
                    // context: context,
                    // builder:(BuildContext context) {
                    //   return TermsView(url: 'https://zakipay.com/',);
                    //   },
                    // );
                  },
                    // openUrl(url: 'https://zakipay.com/');
                  
                ),
                spacing_medium,
                CustomTextButton(
                  width: width * 0.85,
                  title: 'Log Out',
                  onPressed: () async {
                    // appConstants.updateUserId('');
                    UserPreferences userPref = UserPreferences();
                    await userPref.clearLoggedInUser();
                    if(appConstants.userModel.usaTouchEnable!=null && appConstants.userModel.usaTouchEnable==true){
                      await userPref.saveCurrentUserIdForLoginTouch(appConstants.userRegisteredId);
                      String? userId = await userPref.getCurrentUserIdForLoginTouch();
                      logMethod(title: 'LogOut User id:', message: userId.toString());
                    } else{
                      userPref.clearCurrentUserIdForLoginTouch();
                    }
                    
                    // appConstants.updateUserModel(UserModel());
                    // Future.delayed(const Duration(seconds: 1), (){
                    // PersistentNavBarNavigator.
            //         PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
            //     context,
            //     settings: RouteSettings(),
            //     screen: const WhatsAppLoginScreen(),
            //     withNavBar: false,
            //     pageTransitionAnimation: PageTransitionAnimation.cupertino,
            // );
            // Navigator.pushAndRemoveUntil(context,
            //       MaterialPageRoute(builder: (BuildContext context) => WhatsAppLoginScreen()),
            //       (Route<dynamic> route) => route is WhatsAppLoginScreen
            //   );
                    Navigator.of(context).pushAndRemoveUntil(
                      CupertinoPageRoute(
                        builder: (context) => const WhatsAppLoginScreen(),
                      ),
                      (_) => false,
                    );
                    // });
                  },
                ),
                spacing_medium,
                CustomTextButton(
                  width: width * 0.8,
                  title: '$version.$buildNumber',
                  onPressed: () async{
                  },
                ),
                spacing_large
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class CustomTextButton extends StatelessWidget {
  const CustomTextButton(
      {Key? key, required this.width, this.onPressed, this.title})
      : super(key: key);

  final double width;
  final String? title;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Text(
        '$title',
        style: heading4TextSmall(width),
      ),
    );
  }
}
