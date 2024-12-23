// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:esys_flutter_share_plus/esys_flutter_share_plus.dart';
import 'package:feedback/feedback.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
// import 'package:flutter_braintree/flutter_braintree.dart';
import 'package:flutter_dynamic_icon/flutter_dynamic_icon.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:zaki/Constants/AuthMethods.dart';
import 'package:zaki/Constants/HelperFunctions.dart';
import 'package:zaki/Models/PayRequestsModel.dart';
import 'package:zaki/Models/UserModel.dart';
import 'package:zaki/Payment/AndroidIosPayment.dart';
// import 'package:zaki/Payment/AndroidIosPayment.dart';
import 'package:zaki/Screens/AddMembersWorkFlow.dart';
import 'package:zaki/Screens/PreviousPin.dart';
import 'package:zaki/Screens/Socialize.dart';
import 'package:zaki/Screens/AllTransactions.dart';
import 'package:zaki/Screens/ChooseImageForUpload.dart';
import 'package:zaki/Screens/EmptyWallet.dart';
import 'package:zaki/Screens/FundMyWallet.dart';
import 'package:zaki/Screens/PayOrRequestScreen.dart';
import 'package:zaki/Screens/ManageContacts.dart';
import 'package:zaki/Screens/MoveInternalMoney.dart';
import 'package:zaki/Screens/NewGoal.dart';
import 'package:zaki/Screens/Settings.dart';
import 'package:zaki/Screens/UpdateAllowance.dart';
import 'package:zaki/Screens/todo.dart';
// import 'package:zaki/Services/CreaditCardApis.dart';
import 'package:zaki/Services/api.dart';
import 'package:zaki/Widgets/CustomAllTransactionHomeScreen.dart';
import 'package:zaki/Widgets/CustomLoader.dart';
import 'package:zaki/Widgets/CustomSizedBox.dart';
import 'package:zaki/Widgets/SecondaryUserScreen.dart';
import 'package:zaki/Widgets/TextHeader.dart';
import 'package:zaki/Widgets/ZakiCircularButton.dart';
import 'package:zaki/Widgets/ZakiPrimaryButton.dart';
import '../Constants/AppConstants.dart';
import '../Constants/Spacing.dart';
import '../Constants/Styles.dart';
import '../Services/SqLiteHelper.dart';
import '../Widgets/AppBars/AppBar.dart';
// import '../Widgets/CustomAllTransaction.dart';
import '../Widgets/CustomLoadingScreen.dart';
import '../Widgets/FundsMainButton.dart';
import '../Widgets/GoalUnCompletedCustomTile.dart';
import '../Widgets/PayHomeScreen.dart';
import '../Widgets/ToDoCustomTile.dart';
import '../Widgets/TopFriendsCustomWidget.dart';
import 'AllGoals.dart';
import 'IssueDebitCard.dart';
import 'SpendingLimit.dart';
import 'InviteMainScreen.dart';
import 'dart:async';



class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;
  Timer? _timer;
  bool _isActive = true;
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  DateTime? _lastQuitTime = DateTime.now();
  final screens = [
    HomeScreens(),
    PayOrRequestScreen(
        leadingIconRequired: false,
        needBottomNavbar: false,
        fromHomeScreen: true),
    AllActivities(leadingIconRequired: false, needBottomNavbar: false)
  ];
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        CurvedNavigationBarState? navBarState =
            _bottomNavigationKey.currentState;
        if (navBarState!.widget.index != 0) {
          navBarState.setPage(0);
          return false;
        }
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
      },
      child: Scaffold(
        bottomNavigationBar: CurvedNavigationBar(
          key: _bottomNavigationKey,
          backgroundColor: transparent,
          color: green,
          index: selectedIndex,
          // animationDuration: Duration(milliseconds: 200),
          items: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.home,
                  size: 30,
                  color: white,
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  FontAwesomeIcons.arrowRightArrowLeft,
                  size: 25,
                  color: white,
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.people_sharp,
                  size: 30,
                  color: white,
                ),
              ],
            ),
          ],
          onTap: (index) {
            logMethod(title: 'Index', message: index.toString());
            setState(() {
              selectedIndex = index;
            });
          },
        ),
        body: screens[selectedIndex],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    FirebaseAnalytics.instance.setUserProperty(name: "testing", value: "test");
    
    getUserKids();
  }
 @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setScreenName(name: AppConstants.HOME_SCREEN);
  }
  getUserKids() async {
    ApiServices service = ApiServices();
    // await Permission.notification.request();

    Future.delayed(Duration.zero, () async {
      await FirebaseAnalytics.instance.logSelectContent(
    contentType: "image",
    itemId: "122",
);

      var appConstants = Provider.of<AppConstants>(context, listen: false);
      
      _timer = Timer(Duration(seconds: 10), () async {
        if (_isActive == true) {
          // showNotification(error: 0, icon: Icons.abc, message: '${_isActive}');
          if (appConstants.isLoginFirstTime == true &&
              appConstants.userModel.subScriptionValue! >= 2) {
            bool? hasBalance = await service.checkWalletHasAmount(
                amount: 20,
                userId: appConstants.userRegisteredId,
                fromWalletName: AppConstants.Spend_Wallet);
            appConstants.updateIsLoginFirstTime(false);
            if (hasBalance!) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const EmptyWallet()));
            }
          }
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when the widget is disposed
    _isActive = false;
    // if(mounted)
    // setState(() {

    // });

    super.dispose();
  }
}

class HomeScreens extends StatefulWidget {
  const HomeScreens({Key? key}) : super(key: key);

  @override
  _HomeScreensState createState() => _HomeScreensState();
}

class _HomeScreensState extends State<HomeScreens> {
  int selectedIndex = -1;
  int bottomBarIndex = 0;
  Stream<QuerySnapshot>? userKids;
  int kidLengths = 0;
  Stream<QuerySnapshot>? allGoals;
  Stream<QuerySnapshot>? selectedUserToDo;
  // Stream<DocumentSnapshot<Map<String, dynamic>>>? userMainWallet;
  DateTime? _lastQuitTime = DateTime.now();
  List<String> products = [
    "https://uae.microless.com/cdn/no_image.jpg",
    "https://images-na.ssl-images-amazon.com/images/I/81aF3Ob-2KL._UX679_.jpg",
    "https://www.boostmobile.com/content/dam/boostmobile/en/products/phones/apple/iphone-7/silver/device-front.png.transform/pdpCarousel/image.jpg",
  ];
  final formGlobalKey = GlobalKey<FormState>();
  final securityCodeController = TextEditingController();
  final zipCodeController = TextEditingController();
  final amountController = TextEditingController();
  final cardHolderNameController = TextEditingController();
  final cardNumberController = TextEditingController();
  final expireDateController = TextEditingController();
  // Timer? _timer;
  XFile? img;
  // bool _isActive = true;
  File? headerImage;

  @override
  void dispose() {
    securityCodeController.dispose();
    amountController.dispose();
    super.dispose();
  }

  void clearFields() {
    securityCodeController.text = '';
    amountController.text = '';
  }

  @override
  void initState() {
    super.initState();
    getUserKids();
  }
  void _showResetPinDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Reset Pin Code'),
          content: Text('Would you like to reset your pin code?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('Reset'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const PreviousPinCode())
                );
              },
            ),
          ],
        );
      },
    );
  }
  getUserKids() async {
    ApiServices service = ApiServices();
    //Fetch all tag it from a google sheet
    
    //
    Future.delayed(Duration.zero, () async {
      var appConstants = Provider.of<AppConstants>(context, listen: false);
      // service.fetchAllTags(appConstants: appConstants);
      appConstants
          .updateCurrentUserIdForBottomSheet(appConstants.userRegisteredId);
          if(appConstants.userModel.pincodeSetupDateTime!=null){
            if(DateTime.now().isAfter(appConstants.userModel.pincodeSetupDateTime!.add(Duration(days: 60)))){
              _showResetPinDialog();
            }
          }
      DatabaseHelper.instance
          .getLengthOfNotificationForBatch(appConstants: appConstants);
       appConstants.updateSignUpRole('A Kid');
      await ApiServices().getNickNames(
          context: context, userId: appConstants.userRegisteredId);

      await ApiServices().getUserPersonalizationSettings(appConstants);
      userKids = await ApiServices().fetchUserKids(
          appConstants.userModel.seeKids == true
              ? appConstants.userModel.userFamilyId!
              : appConstants.userRegisteredId,
          currentUserId: appConstants.userRegisteredId,
          subscriptionValue: false);
      
      allGoals = await ApiServices().getUncompletedGoals(
          appConstants.userRegisteredId,
          fromHomeScreen: true);
      selectedUserToDo = await service.getToDos(
          id: appConstants.userRegisteredId, condition: "", limit: 3);
      service.kidsLength(
          appConstants.userModel.seeKids == true
              ? appConstants.userModel.userFamilyId!
              : appConstants.userRegisteredId,
          currentUserId: appConstants.userRegisteredId,
          context: context);
      await service.getCardInfoFromFundMyWallet(
          userId: appConstants.userRegisteredId, context: context);
          // You can request multiple permissions at once.
      // ignore: unused_local_variable
      Map<Permission, PermissionStatus> statuses = await [
        Permission.notification,
        Permission.location,
      ].request();
      
      setState(() {});
      
    });
  }

  @override
  Widget build(BuildContext context) {
    var appConstants = Provider.of<AppConstants>(context, listen: true);
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
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
      },
      child: Scaffold(

        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            
            logMethod(title: 'User id', message: appConstants.userRegisteredId);
            print('User id: ${appConstants.userRegisteredId}');
            BetterFeedback.of(context).show((UserFeedback feedback) {
              sendEmail(feedback.screenshot, feedback.text); 

              // Do something with the feedback
            });
            throw Exception();
            },
          // highlightElevation: 5,
          backgroundColor: transparent,
          elevation: 20,
          child: Image.asset(imageBaseAddress + "zakipay_logo.png"),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Container(
              // color: white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // CustomSizedBox(height: height),
                  // spacing_small,
                  Padding(
                    padding: getCustomPadding(),
                    child: appBarHeader_002(
                        width: width,
                        height: height,
                        context: context,
                        appConstants: appConstants,
                        batch: appConstants.batchCounter),
                  ),

                  // ZakiPrimaryButton(title: 'Ad', width: width, onPressed: () {}),
                  if(appConstants.userModel.subscriptionExpired==true)
                  Container(
                    color: crimsonColor,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () async{
                          bool screenNotOpen =
                                await checkUserSubscriptionValue(appConstants, context);
                            logMethod(title: 'Data from Pay+', message: screenNotOpen.toString());
                           
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Subscription Expired, Renew Now', style: heading1TextStyle(context, width, color: white)),
                            SizedBox(
                              width: 10,
                            ),
                            Icon(FontAwesomeIcons.arrowsRotate, color: white,)
                          ],
                        ),
                      ),
                    ),
                  ),
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        height: 200,
                        child: InkWell(
                            onTap: () {},
                            child: appConstants
                                        .userModel.usaBackgroundImageUrl !=
                                    null
                                ? appConstants.userModel.usaBackgroundImageUrl!
                                        .contains('assets/images/')
                                    ? Image.asset(
                                        appConstants
                                            .userModel.usaBackgroundImageUrl
                                            .toString(),
                                        width: width,
                                        height: height * 0.42,
                                        fit: BoxFit.cover,
                                      )
                                    : appConstants.userModel
                                                .usaBackgroundImageUrl !=
                                            ''
                                        ? CachedNetworkImage(
                                            imageUrl: appConstants
                                                .userModel.usaBackgroundImageUrl
                                                .toString(),
                                            width: width,
                                            height: height * 0.42,
                                            fit: BoxFit.contain,
                                            placeholder: (context, url) =>
                                                Center(
                                                    child: CustomLoadingScreen(
                                              small: true,
                                            )),
                                            errorWidget:
                                                (context, url, error) =>
                                                    Icon(Icons.error),
                                          )
                                        : Image.asset(
                                            imageBaseAddress +
                                                '1_background.png',
                                            width: width,
                                            height: height * 0.18,
                                            fit: BoxFit.cover,
                                          )
                                : Image.asset(
                                    imageBaseAddress + 'header_background.png',
                                    width: width,
                                    height: height * 0.18,
                                    fit: BoxFit.cover,
                                  )),
                      ),
                      Positioned(
                        top: 10,
                        right: 10,
                        child: Container(
                          decoration: BoxDecoration(
                              color: white, shape: BoxShape.circle),
                          child: InkWell(
                            onTap: () {
                              appConstants.updateComeFrom(from: false);

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ChooseImageForUpload(
                                            imageUrl: appConstants.userModel
                                                .usaBackgroundImageUrl,
                                          )));
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Icon(
                                Icons.camera_alt,
                                color: grey,
                                size: width * 0.045,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: height * 0.2),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  InkWell(
                                    onTap: () async {
                                      appConstants.updateComeFrom(from: true);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ChooseImageForUpload(
                                                      imageUrl: appConstants
                                                          .userModel.usaLogo,
                                                      userType: appConstants
                                                          .userModel
                                                          .usaUserType,
                                                      gender: appConstants
                                                          .userModel
                                                          .usaGender)));
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: white,
                                        shape: BoxShape.circle,
                                        // border: Border.all(color: grey)
                                      ),
                                      width: width * 0.24,
                                      height: height * 0.13,
                                      child: Center(
                                          child: userImage(
                                              imageUrl: appConstants
                                                  .userModel.usaLogo!,
                                              userType: appConstants
                                                  .userModel.usaUserType,
                                              width: width,
                                              gender: appConstants
                                                  .userModel.usaGender,
                                              appConstants: appConstants)),
                                    ),
                                  ),
                                  Positioned(
                                    top: 6,
                                    right: -2,
                                    child: InkWell(
                                      onTap: () {
                                        appConstants.updateComeFrom(from: true);

                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ChooseImageForUpload(
                                                      imageUrl: appConstants
                                                          .userModel.usaLogo,
                                                    )));
                                      },
                                      child: Card(
                                        elevation: 10,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                        ),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: white,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      width * 0.18)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(3.0),
                                            child: Icon(
                                              Icons.camera_alt,
                                              size: width * 0.035,
                                              color: grey,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: width * 0.05,
                                ),
                                child: InkWell(
                                  onTap: () async {
                                    showNotification(
                                        error: 0,
                                        icon: Icons.screen_share_outlined,
                                        message: 'Share Button tabed');
                                    logMethod(
                                        title: 'Share Button tabed',
                                        message: 'Tabbed Success');
                                    final ByteData bytes = await rootBundle
                                        .load(imageBaseAddress + 'share.png');
                                    await Share.file(
                                      'Share My Image',
                                      'ZakiPay_Share.png',
                                      bytes.buffer.asUint8List(),
                                      'image/png',
                                      text:
                                          "${appConstants.userModel.usaFirstName} ${AppConstants.ZAKI_PAY_PROMOTIONAL_TEXT} ${AppConstants.ZAKI_PAY_APP_LINK}",
                                    );
                                    // Share.share('Download ZakiPay and Raise Smart Kids', subject: 'Download ZakiPay and Raise Smart Kids', );
                                  },
                                  child: Container(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(14),
                                      child: BackdropFilter(
                                        filter: new ImageFilter.blur(
                                            sigmaX: 20.0, sigmaY: 20.0),
                                        child: Container(
                                          height: height * 0.045,
                                          width: width * 0.5,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(14),
                                              border: Border.all(
                                                  color: grey.withOpacity(0.4))
                                              ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  
                                                  child: TextValue2(
                                                    title:
                                                        "@ ${appConstants.userModel.usaUserName.toString()}",
                                                    // maxLines: 1,
                                                  ),
                                                ),
                                                IconButton(
                                                  splashColor: green,
                                                  padding: EdgeInsets.zero,
                                                  // constraints: BoxConstraints(),
                                                  onPressed: () async {
                                                    showNotification(
                                                        error: 0,
                                                        icon: Icons
                                                            .screen_share_outlined,
                                                        message:
                                                            'Share Button tabed');
                                                    logMethod(
                                                        title:
                                                            'Share Button tabed',
                                                        message:
                                                            'Tabbed Success');
                                                    final ByteData bytes =
                                                        await rootBundle.load(
                                                            imageBaseAddress +
                                                                'share.png');
                                                    await Share.file(
                                                      'Share My Image',
                                                      'ZakiPay_Share.png',
                                                      bytes.buffer
                                                          .asUint8List(),
                                                      'image/png',
                                                      text:
                                                          "${appConstants.userModel.usaFirstName} ${AppConstants.ZAKI_PAY_PROMOTIONAL_TEXT} ${AppConstants.ZAKI_PAY_APP_LINK}",
                                                    );
                                                    // Share.share('Download ZakiPay and Raise Smart Kids', subject: 'Download ZakiPay and Raise Smart Kids', );
                                                  },
                                                  alignment:
                                                      Alignment.centerRight,
                                                  icon: Icon(
                                                    Icons.share,
                                                    color: grey,
                                                    // size: height * 0.02,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: getCustomPadding(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        spacing_medium,
                        if (appConstants.userModel.usaUserType ==
                            AppConstants.USER_TYPE_PARENT)
                          Column(
                            children: [
                              InkWell(
                                onTap: () {},
                                child: Row(
                                  children: [
                                    CustomIconsHome(
                                      color: black,
                                      icon: Icons.home,
                                    ),
                                    Text(
                                      'My Family'.tr(),
                                      style: textStyleHeading1WithTheme(
                                          context, width * 0.85,
                                          whiteColor: 0),
                                    ),
                                    const Spacer(),
                                    appConstants.familymemberlimitreached ==
                                            true
                                        ? SizedBox(
                                            width: 5,
                                            height: 5,
                                          )
                                        : addMemberWidget(appConstants, context,
                                            height, width)
                                  ],
                                ),
                              ),
                              spacing_medium,
                              userKids == null
                                  ? const SizedBox()
                                  : StreamBuilder<QuerySnapshot>(
                                      stream: userKids,
                                      builder: (BuildContext context,
                                          AsyncSnapshot<QuerySnapshot>
                                              snapshot) {
                                        if (snapshot.hasError) {
                                          return const Text(
                                              'Ooops, Something went wrong!');
                                        }

                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const Text("");
                                        }
                                        if (snapshot.data!.size == 0) {
                                          return InkWell(
                                            onTap: () async {
                                              bool screenNotOpen =
                                                  await checkUserSubscriptionValue(
                                                      appConstants, context);
                                              logMethod(
                                                  title: 'Data from Pay+',
                                                  message:
                                                      screenNotOpen.toString());
                                              if (screenNotOpen == false)
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            AddMemberWorkFlow()));
                                              // }
                                            },
                                            child: SetupWalletAndFamily(
                                              width: width,
                                              appConstants: appConstants,
                                              leadingImage:
                                                  'no_family_member.png',
                                              buttonTitle: 'Add Now',
                                              color: darkGrey,
                                              title: 'Add a Family Member',
                                              onPressed: () async {
                                                bool screenNotOpen =
                                                    await checkUserSubscriptionValue(
                                                        appConstants, context);
                                                logMethod(
                                                    title: 'Data from Pay+',
                                                    message: screenNotOpen
                                                        .toString());
                                                if (screenNotOpen == false)
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              AddMemberWorkFlow()));
                                              },
                                            ),
                                            );
                                        }
                                        return GridView(
                                          gridDelegate:
                                              const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                            crossAxisSpacing: 10,
                                            mainAxisSpacing: 10,
                                          ),
                                          primary: false,
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          children: List<Widget>.generate(
                                              snapshot.data!.docs.length,
                                              (index) {
                                            return
                                                InkWell(
                                              onTap: () async {
                                                logMethod(
                                                    title: 'Id of selected Kid',
                                                    message: snapshot
                                                        .data!.docs[index].id);
                                                bool screenNotOpens =
                                                    await checkUserSubscriptionValue(
                                                        appConstants, context);
                                                logMethod(
                                                    title: 'Data from Pay+',
                                                    message: screenNotOpens
                                                        .toString());
                                                if (screenNotOpens == false) {
                                                  ///////If secondary user
                                                  if (appConstants.userModel
                                                              .userFamilyId !=
                                                          appConstants.userModel
                                                              .usaUserId &&
                                                      appConstants.userModel
                                                              .userFamilyId !=
                                                          '' &&
                                                      snapshot.data!.docs[index]
                                                              [AppConstants
                                                                  .USER_SubscriptionValue] <=
                                                          2) {
                                                    showModalBottomSheet(
                                                      context: context,
                                                      // constraints: BoxConstraints(maxHeight: 800, maxWidth: double.infinity, minHeight: 800, minWidth: double.infinity),
                                                      isScrollControlled: true,
                                                      useSafeArea: true,
                                                      // enableDrag: false,
                                                      showDragHandle: true,
                                                      enableDrag: true,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  width * 0.09),
                                                          topRight:
                                                              Radius.circular(
                                                                  width * 0.09),
                                                        ),
                                                      ),
                                                      builder: (context) {
                                                        return Container(
                                                            height: height *
                                                                0.9,
                                                            child:
                                                                SecondaryUserScreen());
                                                      },
                                                    );
                                                    return;
                                                  }

                                                  if (snapshot.data!.docs[index]
                                                          [AppConstants
                                                              .USER_SubscriptionValue] <=
                                                      2) {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                AddMemberWorkFlow()));

                                                    return;
                                                  }
                                                  logMethod(
                                                      title: 'From My family',
                                                      message: snapshot.data!
                                                          .docs[index].id);
                                                  if (snapshot.data!.docs[index]
                                                              [AppConstants
                                                                  .NewMember_kid_isEnabled] ==
                                                          true &&
                                                      snapshot.data!.docs[index]
                                                              [AppConstants
                                                                  .NewMember_isEnabled] ==
                                                          false) {
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                              dialougeContext) =>
                                                          AlertDialog(
                                                              title: TextHeader1(
                                                                  title:
                                                                      'Access ZakiPay Account'),
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              14.0))),
                                                              content: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  TextHeader1(
                                                                    title:
                                                                        'Step 1',
                                                                  ),
                                                                  TextValue2(
                                                                    title:
                                                                        'Download the Zakipay App from App / Play Store.',
                                                                  ),
                                                                  spacing_medium,
                                                                  TextHeader1(
                                                                    title:
                                                                        'Step 2',
                                                                  ),
                                                                  TextValue2(
                                                                    title:
                                                                        '${snapshot.data!.docs[index][AppConstants.USER_first_name]} must Log In with Mobile Number ${snapshot.data!.docs[index][AppConstants.USER_phone_number]} then complete next steps.',
                                                                  ),
                                                                ],
                                                              ),
                                                              actions: [
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                ZakiPrimaryButton(
                                                                  width: 200,
                                                                  title:
                                                                      'Close',
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.of(
                                                                            dialougeContext)
                                                                        .pop();
                                                                  },
                                                                ),
                                                              ],
                                                            ),
                                                          ]
                                                              // actions
                                                              ),
                                                    );
                                                    return;
                                                  }

                                                  ///Take user to pay+ screen
                                                  bool screenNotOpen =
                                                      await checkUserSubscriptionValue(
                                                          appConstants,
                                                          context);
                                                  if (screenNotOpen == false) {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                PayOrRequestScreen(
                                                                  selectedUserModel: UserModel(
                                                                      usaLogo: snapshot
                                                                              .data!
                                                                              .docs[index]
                                                                          [
                                                                          AppConstants
                                                                              .USER_Logo],
                                                                      usaFirstName: snapshot
                                                                              .data!
                                                                              .docs[index]
                                                                          [
                                                                          AppConstants
                                                                              .USER_first_name],
                                                                      usaLastName: snapshot
                                                                          .data!
                                                                          .docs[index][AppConstants.USER_last_name],
                                                                      usaUserName: snapshot.data!.docs[index][AppConstants.USER_user_name],
                                                                      usaUserId: snapshot.data!.docs[index].id),
                                                                )));
                                                  }
                                                }
                                              },
                                              child: Container(
                                                // padding: const EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                  // color: grey,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          width * 0.04),
                                                ),
                                                child: Stack(
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              width * 0.04),
                                                      child: (snapshot.data!
                                                                      .docs[index]
                                                                  [AppConstants
                                                                      .USER_Logo] ==
                                                              '')
                                                          ? Image.asset(
                                                              getKidImage(
                                                                  userType: snapshot
                                                                          .data!
                                                                          .docs[index]
                                                                      [AppConstants.USER_UserType],
                                                                  gender: snapshot.data!.docs[index][AppConstants.USER_gender],
                                                                  imageUrl: snapshot.data!.docs[index][AppConstants.USER_Logo]),
                                                              fit: BoxFit.cover,
                                                              height: height)
                                                          : (snapshot.data!.docs[index][AppConstants.USER_Logo] != '' && snapshot.data!.docs[index][AppConstants.USER_Logo].contains('assets/images/'))
                                                              ? Image.asset(
                                                                  snapshot
                                                                      .data!
                                                                      .docs[
                                                                          index]
                                                                          [
                                                                          AppConstants
                                                                              .USER_Logo]
                                                                      .toString(),
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  height:
                                                                      height,
                                                                )
                                                              : Image.network(
                                                                  snapshot.data!
                                                                              .docs[
                                                                          index]
                                                                      [
                                                                      AppConstants
                                                                          .USER_Logo],
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  height:
                                                                      height,
                                                                ),
                                                    ),
                                                    ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              16.0),
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                                border: Border.all(
                                                                    color: grey
                                                                        .withOpacity(
                                                                            0.3)),
                                                                gradient:
                                                                    LinearGradient(
                                                                  begin: Alignment
                                                                      .topCenter,
                                                                  end: Alignment
                                                                      .bottomCenter,
                                                                  colors: [
                                                                    transparent,
                                                                    transparent,
                                                                    transparent,
                                                                    transparent,
                                                                    transparent,
                                                                    black.withOpacity(
                                                                        0.45),
                                                                    black.withOpacity(
                                                                        0.55),
                                                                    black.withOpacity(
                                                                        0.9),
                                                                  ],
                                                                )),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            // (appConstants.userModel.userFamilyId!= appConstants.userModel.usaUserId && appConstants.userModel.userFamilyId!='') ||
                                                            (checkSubscriptionValueText(
                                                                        subscriptionValue:
                                                                            snapshot.data!.docs[index][AppConstants
                                                                                .USER_SubscriptionValue],
                                                                        kidsEnabledStatus:
                                                                            snapshot.data!.docs[index][AppConstants
                                                                                .NewMember_kid_isEnabled],
                                                                        newMemberIsEnabled: snapshot
                                                                            .data!
                                                                            .docs[index][AppConstants.NewMember_isEnabled]) ==
                                                                    '')
                                                                ? SizedBox()
                                                                : Container(
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color:
                                                                          red,
                                                                      borderRadius: BorderRadius.only(
                                                                          topLeft: Radius.circular(width *
                                                                              0.04),
                                                                          topRight:
                                                                              Radius.circular(width * 0.04)),
                                                                    ),
                                                                    // width: width,
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsets
                                                                          .all(
                                                                          4.0),
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: [
                                                                          SizedBox(
                                                                            width:
                                                                                5,
                                                                          ),
                                                                          Icon(
                                                                            Icons.info_outline,
                                                                            color:
                                                                                white,
                                                                            size:
                                                                                width * 0.035,
                                                                          ),
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.all(4.0),
                                                                            child:
                                                                                Text(
                                                                              checkSubscriptionValueText(subscriptionValue: snapshot.data!.docs[index][AppConstants.USER_SubscriptionValue], kidsEnabledStatus: snapshot.data!.docs[index][AppConstants.NewMember_kid_isEnabled], newMemberIsEnabled: snapshot.data!.docs[index][AppConstants.NewMember_isEnabled]),
                                                                              style: heading4TextSmall(width, color: white),
                                                                            ),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                         
                                                            Column(
                                                              children: [
                                                                SizedBox(
                                                                  width: width,
                                                                ),
                                                                Text(
                                                                  snapshot.data!
                                                                              .docs[
                                                                          index]
                                                                      [
                                                                      AppConstants
                                                                          .USER_first_name],
                                                                  style: heading2TextStyle(
                                                                      context,
                                                                      width,
                                                                      color:
                                                                          white),
                                                                  // maxLines: 1,
                                                                  // overflow: TextOverflow.ellipsis,
                                                                ),
                                                                CustomKidWalletBalance(
                                                                    width:
                                                                        width,
                                                                    userId: snapshot
                                                                        .data!
                                                                        .docs[
                                                                            index]
                                                                        .id),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }),
                                        );
                                      },
                                    ),
                            ],
                          ),
                        spacing_large,
                        Row(
                          children: [
                            CustomIconsHome(
                              color: lightBlue,
                              icon: Icons.account_balance,
                              size: 25,
                            ),
                            Text(
                              'My Money',
                              style: textStyleHeading1WithTheme(
                                  context, width * 0.85,
                                  whiteColor: 10),
                            ),
                          ],
                        ),
                        spacing_medium,
                        appConstants.userModel.subScriptionValue! < 2
                            ? SetupWalletAndFamily(
                                width: width,
                                appConstants: appConstants,
                                leadingImage: 'noWalletSetup.png',
                                buttonTitle: 'Setup Now',
                                color: lightBlue,
                                title: 'Digital Wallet: Setup Required',
                                onPressed: () async {
                                  // bool screenNotOpen =
                                  await checkUserSubscriptionValue(
                                      appConstants, context);
                                },
                              )
                            : Row(
                                children: [
                                  Expanded(
                                    flex: 4,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 1.5),
                                      child: InkWell(
                                        onTap: () {
                                          toUpMethodsBottomSheet(
                                              context: context,
                                              height: height,
                                              width: width);
                                           },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                                width * 0.035),
                                            color: lightBlue,
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(6),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              (appConstants.nickNameModel
                                                                              .NickN_SpendWallet !=
                                                                          null &&
                                                                      appConstants
                                                                              .nickNameModel
                                                                              .NickN_SpendWallet !=
                                                                          "")
                                                                  ? appConstants
                                                                      .nickNameModel
                                                                      .NickN_SpendWallet!
                                                                  : 'Spend',
                                                              style:
                                                                  textStyleHeading2WithTheme(
                                                                      context,
                                                                      width *
                                                                          0.7,
                                                                      whiteColor:
                                                                          1),
                                                            ),
                                                          ],
                                                        ),
                                                        Text(
                                                          'Wallet',
                                                          style:
                                                              textStyleHeading2WithTheme(
                                                                  context,
                                                                  width * 0.7,
                                                                  whiteColor:
                                                                      1),
                                                        ),
                                                      ],
                                                    ),
                                                    CustomImageHolder(
                                                      imageUrl: FontAwesomeIcons
                                                          .wallet,
                                                      color: white,
                                                    )
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: height * 0.01,
                                                ),
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    StreamBuilder(
                                                        stream: FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                AppConstants
                                                                    .USER)
                                                            .doc(appConstants
                                                                .userRegisteredId)
                                                            .collection(
                                                                AppConstants
                                                                    .USER_WALLETS)
                                                            .doc(AppConstants
                                                                .Spend_Wallet)
                                                            .snapshots(),
                                                        builder: (context,
                                                            AsyncSnapshot<
                                                                    DocumentSnapshot>
                                                                snapshot) {
                                                          if (snapshot
                                                                  .connectionState ==
                                                              ConnectionState
                                                                  .waiting) {
                                                            return CustomLoader();
                                                          }

                                                          return appConstants
                                                                      .userModel
                                                                      .usaCountry ==
                                                                  "Pakistan"
                                                              ? Expanded(
                                                                  child:
                                                                      FittedBox(
                                                                    fit: BoxFit
                                                                        .cover,
                                                                    child: Row(
                                                                      children: [
                                                                        Text(
                                                                          getAmountAsFormatedIntoLetter(
                                                                              amount: double.parse(snapshot.data![AppConstants.wallet_balance].toString())),
                                                                          style: textStyleHeading1WithTheme(
                                                                              context,
                                                                              height * 0.85,
                                                                              whiteColor: 1),
                                                                        ),
                                                                        Padding(
                                                                          padding: const EdgeInsets
                                                                              .only(
                                                                              bottom: 2.0,
                                                                              left: 4),
                                                                          child:
                                                                              Text(
                                                                            '${getCurrencySymbol(context, appConstants: appConstants)}',
                                                                            style: textStyleHeading2WithTheme(context,
                                                                                height * 0.8,
                                                                                whiteColor: 1),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                )
                                                              : Expanded(
                                                                  child:
                                                                      Column(
                                                                                                                                            crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                                                                                            children: [
                                                                      Text(
                                                                        '${getCurrencySymbol(context, appConstants: appConstants)}',
                                                                        style: heading3TextStyle(
                                                                            width,
                                                                            color: white.withOpacity(0.8)),
                                                                      ),
                                                                      FittedBox(
                                                                        child: Text(
                                                                          '${getAmountAsFormatedIntoLetter(amount: double.parse(snapshot.data![AppConstants.wallet_balance].toString()))}',
                                                                          style: textStyleHeading1WithTheme(
                                                                              context,
                                                                              height * 0.85,
                                                                              whiteColor: 1),
                                                                          // overflow: TextOverflow.visible,
                                                                          // maxLines: ,
                                                                        ),
                                                                      ),
                                                                                                                                            ],
                                                                                                                                          ),
                                                                );
                                                        }),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 4.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                                width * 0.035),
                                            border: Border.all(color: borderColor)
                                            // color: green,

                                            ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: InkWell(
                                            onTap: () async {
                                              if (appConstants
                                                          .personalizationSettingModel !=
                                                      null &&
                                                  appConstants
                                                          .personalizationSettingModel!
                                                          .kidPLockSavings ==
                                                      true) {
                                                return;
                                              }

                                              appConstants
                                                  .updateCurrentUserIdForBottomSheet(
                                                      appConstants
                                                          .userRegisteredId);
// bool screenNotOpen = await checkUserSubscriptionValue(appConstants, context);
//                                   if(screenNotOpen==false){
                                              appConstants
                                                  .updateSelectFromWallet(
                                                from: (appConstants
                                                                .nickNameModel
                                                                .NickN_SavingWallet !=
                                                            null &&
                                                        appConstants
                                                                .nickNameModel
                                                                .NickN_SavingWallet !=
                                                            "")
                                                    ? appConstants.nickNameModel
                                                        .NickN_SavingWallet!
                                                    : 'Savings',
                                              );

                                              appConstants
                                                  .updateSelectFromWalletRealName(
                                                      fromRealName: 'Savings');
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const MoveInternalMoney()));
                                            },
                                            child: Column(
                                              children: [
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  // mainAxisAlignment: MainAxisAlignment.,
                                                  children: [
                                                    Text(
                                                      (appConstants.nickNameModel
                                                                      .NickN_SavingWallet !=
                                                                  null &&
                                                              appConstants
                                                                      .nickNameModel
                                                                      .NickN_SavingWallet !=
                                                                  "")
                                                          ? appConstants
                                                                  .nickNameModel
                                                                  .NickN_SavingWallet! +
                                                              '\nWallet'
                                                          : 'Savings'.tr() +
                                                              '\nWallet',
                                                      style: heading2TextStyle(
                                                          context, width,
                                                          color: black,
                                                          font: 12),
                                                    ),
                                                    Expanded(
                                                      child: Align(
                                                        alignment: Alignment
                                                            .centerRight,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                            left: 2.0,
                                                          ),
                                                          child: CustomImageHolder(
                                                              imageUrl:
                                                                  FontAwesomeIcons
                                                                      .vault),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: height * 0.028,
                                                ),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: StreamBuilder(
                                                          stream: FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  AppConstants
                                                                      .USER)
                                                              .doc(appConstants
                                                                  .userRegisteredId)
                                                              .collection(
                                                                  AppConstants
                                                                      .USER_WALLETS)
                                                              .doc(AppConstants
                                                                  .Savings_Wallet)
                                                              .snapshots(),
                                                          builder: (context,
                                                              AsyncSnapshot<
                                                                      DocumentSnapshot>
                                                                  snapshot) {
                                                            if (snapshot
                                                                    .connectionState ==
                                                                ConnectionState
                                                                    .waiting) {
                                                              return Center(
                                                                  child:
                                                                      CustomLoader());
                                                            }
                                                            return Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              // mainAxisSize: MainAxisSize.min,
                                                              children: [
                                                                Text(
                                                                  '${getCurrencySymbol(context, appConstants: appConstants)}',
                                                                  style: heading3TextStyle(
                                                                      width,
                                                                      color: grey
                                                                          .withOpacity(
                                                                              0.8)),
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                ),
                                                                SizedBox(
                                                                  width: width,
                                                                ),
                                                                StreamBuilder(
                                                                    stream: FirebaseFirestore
                                                                        .instance
                                                                        .collection(AppConstants
                                                                            .USER)
                                                                        .doc(appConstants
                                                                            .userRegisteredId)
                                                                        .collection(AppConstants
                                                                            .USER_WALLETS)
                                                                        .doc(AppConstants
                                                                            .All_Goals_Wallet)
                                                                        .snapshots(),
                                                                    builder: (context,
                                                                        AsyncSnapshot<DocumentSnapshot>
                                                                            goalSnapshot) {
                                                                      if (!goalSnapshot
                                                                          .hasData) {
                                                                        return Text(
                                                                            "");
                                                                      }
                                                                      return
                                                                          FittedBox(
                                                                        fit: BoxFit
                                                                            .cover,
                                                                        child:
                                                                            Text(
                                                                          '${getAmountAsFormatedIntoLetter(amount: double.parse(snapshot.data![AppConstants.wallet_balance].toString()) + double.parse(goalSnapshot.data![AppConstants.wallet_balance].toString()))}',
                                                                          style: textStyleHeading1WithTheme(
                                                                              context,
                                                                              height * 0.5,
                                                                              whiteColor: 0,
                                                                              bold: false),
                                                                        ),
                                                                      );
                                                                    }),
                                                              ],
                                                            );
                                                          }),
                                                    ),
                                                    (appConstants.personalizationSettingModel !=
                                                                null &&
                                                            appConstants
                                                                    .personalizationSettingModel!
                                                                    .kidPLockSavings ==
                                                                true)
                                                        ? CustomLockWidget()
                                                        : const SizedBox(
                                                            height: 10,
                                                            width: 14,
                                                          )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 4.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                                width * 0.035),
                                            border: Border.all(color: borderColor)
                  
                                            ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: InkWell(
                                            onTap: () async {
                                              if (appConstants
                                                          .personalizationSettingModel !=
                                                      null &&
                                                  appConstants
                                                          .personalizationSettingModel!
                                                          .kidPLockDonate ==
                                                      true) {
                                                return;
                                              }
                                              appConstants
                                                  .updateCurrentUserIdForBottomSheet(
                                                      appConstants
                                                          .userRegisteredId);
                                              
                                              appConstants
                                                  .updateSelectFromWallet(
                                                from: (appConstants
                                                                .nickNameModel
                                                                .NickN_DonationWallet !=
                                                            null &&
                                                        appConstants
                                                                .nickNameModel
                                                                .NickN_DonationWallet !=
                                                            "")
                                                    ? appConstants.nickNameModel
                                                        .NickN_DonationWallet!
                                                    : 'Charity',
                                              );
                                              appConstants
                                                  .updateSelectFromWalletRealName(
                                                      fromRealName: 'Charity');
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const MoveInternalMoney()));
                                            },
                                            child: Column(
                                              children: [
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      (appConstants.nickNameModel
                                                                      .NickN_DonationWallet !=
                                                                  null &&
                                                              appConstants
                                                                      .nickNameModel
                                                                      .NickN_DonationWallet !=
                                                                  "")
                                                          ? appConstants
                                                                  .nickNameModel
                                                                  .NickN_DonationWallet! +
                                                              '\nWallet'
                                                          : 'Charity'.tr() +
                                                              "\nWallet",
                                                      style: heading2TextStyle(
                                                          context, width,
                                                          color: black,
                                                          font: 12),
                                                    ),
                                                    Expanded(
                                                      child: Align(
                                                        alignment: Alignment
                                                            .centerRight,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 2.0),
                                                          child: CustomImageHolder(
                                                              imageUrl:
                                                                  FontAwesomeIcons
                                                                      .handHoldingHeart),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: height * 0.028,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      '${getCurrencySymbol(context, appConstants: appConstants)}',
                                                      style: heading3TextStyle(
                                                          width,
                                                          color:
                                                              grey.withOpacity(
                                                                  0.8)),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: StreamBuilder(
                                                          stream: FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  AppConstants
                                                                      .USER)
                                                              .doc(appConstants
                                                                  .userRegisteredId)
                                                              .collection(
                                                                  AppConstants
                                                                      .USER_WALLETS)
                                                              .doc(AppConstants
                                                                  .Donations_Wallet)
                                                              .snapshots(),
                                                          builder: (context,
                                                              AsyncSnapshot<
                                                                      DocumentSnapshot>
                                                                  snapshot) {
                                                            if (snapshot
                                                                    .connectionState ==
                                                                ConnectionState
                                                                    .waiting) {
                                                              return Center(
                                                                child:
                                                                    CustomLoader(),
                                                              );
                                                            }
                                                            return
                                                                Text(
                                                              '${getAmountAsFormatedIntoLetter(amount: double.parse(snapshot.data![AppConstants.wallet_balance].toString()))}',
                                                              style:
                                                                  textStyleHeading1WithTheme(
                                                                context,
                                                                height * 0.5,
                                                                whiteColor: 0,
                                                                bold: false,
                                                              ),
                                                            );
                                                          }),
                                                    ),
                                                    (appConstants.personalizationSettingModel !=
                                                                null &&
                                                            appConstants
                                                                .personalizationSettingModel!
                                                                .kidPLockDonate!)
                                                        ? CustomLockWidget()
                                                        : const SizedBox(
                                                            height: 10,
                                                            width: 14,
                                                          )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                        spacing_large,

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {
                                appConstants
                                    .updatePayRequestModel(PayRequestModel());
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const PayOrRequestScreen()));
                              },
                              child: Row(
                                children: [
                                  InkWell(
                                    onTap: () async {
                                      bool support = await FlutterAppBadger
                                          .isAppBadgeSupported();
                                      if (support) {
                                        logMethod(
                                            title: 'Supported',
                                            message:
                                                'Batches supports $support');
                                        FlutterAppBadger.updateBadgeCount(20);
                                      } else {
                                        logMethod(
                                            title: 'Supported',
                                            message: 'Not supports');
                                      }
                                      try {
                                        await FlutterDynamicIcon
                                            .setApplicationIconBadgeNumber(2);
                                        logMethod(
                                            title: 'Called',
                                            message: 'Successfully');
                                        logMethod(
                                            title: 'Name',
                                            message:
                                                '${await FlutterDynamicIcon.getApplicationIconBadgeNumber()}');
                                      } on PlatformException {
                                      } catch (e) {
                                        logMethod(
                                            title: 'Excetion',
                                            message: 'Exception added');
                                      }
                                    },
                                    child: CustomIconsHome(
                                      color: green,
                                      size: 20,
                                      icon:
                                          FontAwesomeIcons.arrowRightArrowLeft,
                                    ),
                                  ),
                                  Text(
                                    'Send or Request'.tr(),
                                    style: textStyleHeading1WithTheme(
                                        context, width * 0.85,
                                        whiteColor: 2),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        spacing_medium,
                        SizedBox(
                          height: height * 0.15,
                          width: width,
                          child: SingleChildScrollView(
                            physics: BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 10.0),
                                  child: 
                                      PayHomeScreen(
                                          // requestedMoney: requestedMoney,
                                          width: width,
                                          height: height),
                                ),
                                    TopFriendsBuilder(width: width),

                              ],
                            ),
                          ),
                        ),
                        spacing_medium,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Center(
                              child: ZakiCicularButton(
                                title: 'Send or Request',
                                width: width * 0.7,
                                onPressed: () async {
                                  appConstants
                                      .updateCurrentUserIdForBottomSheet(
                                          appConstants.userRegisteredId);
// bool screenNotOpen = await checkUserSubscriptionValue(appConstants, context);
//                                   if(screenNotOpen==false){
                                  appConstants
                                      .updatePayRequestModel(PayRequestModel());
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const PayOrRequestScreen()));
                                  // }
                                },
                              ),
                            ),
                          ],
                        ),
                        spacing_large,

                        Column(
                          children: [
                            Row(
                              children: [
                                CustomIconsHome(
                                  color: crimsonColor,
                                  icon: Icons.toc,
                                ),
                                Text(
                                  'To Do\'s',
                                  style: textStyleHeading1WithTheme(
                                      context, width * 0.85,
                                      whiteColor: 9),
                                ),
                              ],
                            ),
                            CustomSizedBox(height: height),
                            selectedUserToDo == null
                                ? const SizedBox()
                                : StreamBuilder<QuerySnapshot>(
                                    stream: selectedUserToDo,
                                    builder: (BuildContext context,
                                        AsyncSnapshot<QuerySnapshot> snapshot) {
                                      if (snapshot.hasError) {
                                        return const Text(
                                            'Ooops...Something went wrong :(');
                                      }

                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Center(
                                            child:
                                                const CustomLoader());
                                      }
                                      if (snapshot.data!.size == 0) {
                                        return Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Center(
                                              child: ZakiCicularButton(
                                                title:
                                                    '        Add To Do        ',
                                                width: width * 0.7,
                                                selected: 6,
                                                onPressed: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              const TodoTasks()));
                                                },
                                              ),
                                            ),
                                          ],
                                        );
                                      }
//snapshot.data!.docs[index] ['USA_first_name']
                                      return ReorderableListView.builder(
                                        onReorder: (oldIndex, newIndex) {
                                          DateTime oldDateTime = snapshot
                                              .data!
                                              .docs[oldIndex]
                                                  [AppConstants.DO_CreatedAt]
                                              .toDate();
                                          DateTime newDateTime = snapshot
                                              .data!
                                              .docs[newIndex]
                                                  [AppConstants.DO_CreatedAt]
                                              .toDate();
                                          DateTime updatedTime = newDateTime
                                              .subtract(const Duration(
                                                  milliseconds: 10));
                                          logMethod(
                                              title: "Time",
                                              message:
                                                  'Old date: $oldDateTime : New Date $newDateTime-->>Updated Time $updatedTime');
                                          ApiServices()
                                              .updateToDoDateAfterSwipe(
                                                  todoId: snapshot
                                                      .data!.docs[oldIndex].id,
                                                  updatedDate: updatedTime,
                                                  userId: appConstants
                                                      .userRegisteredId);
                                          // logMethod(title: "Time", message: 'Now is ::>>${DateTime.now()} <:: old time: ${snapshot.data!.docs[oldIndex][AppConstants.DO_CreatedAt].toDate()} -->>New Time: ${snapshot.data!.docs[newIndex][AppConstants.DO_CreatedAt].toDate()} -->>Updated Time $updatedTime');
                                        },
                                        // header: Text(snapshot.data!.docs.first.id.toString()),
                                        // key: ValueKey(snapshot.data!.docs[3].id),
                                        itemCount: snapshot.data!.docs.length,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        // scrollDirection: Axis.horizontal,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          // print(snapshot.data!.docs[index] ['USA_first_name']);
                                          return (snapshot.data!.docs[index][
                                                          AppConstants
                                                              .ToDo_Repeat_Schedule] ==
                                                      '' &&
                                                  snapshot.data!.docs[index][
                                                          AppConstants
                                                              .DO_Status] ==
                                                      "Completed")
                                              ? Container(
                                                  // elevation: 0,
                                                  key: ValueKey(
                                                    snapshot
                                                        .data!.docs[index].id
                                                        .toString(),
                                                  ),
                                                  child: SizedBox.shrink())
                                              :
                                              // snapshot.data!.docs[index] [AppConstants.DO_Status] != "Completed"?
                                              Container(
                                                  // elevation: 0,
                                                  key: ValueKey(
                                                    snapshot
                                                        .data!.docs[index].id
                                                        .toString(),
                                                  ),
                                                  child: ToDoCustomTile(
                                                    snapshot.data!.docs[index],
                                                    appConstants
                                                        .userRegisteredId,
                                                    index: index,
                                                    toDoIsGridView:
                                                        appConstants.isGirdView,
                                                  ));
                                        },
                                      );
                                    },
                                  ),
                            spacing_medium,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Center(
                                  child: ZakiCicularButton(
                                    title: 'All To Do’s',
                                    width: width * 0.7,
                                    selected: 6,
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const TodoTasks()));
                                    },
                                  ),
                                ),
                              ],
                            ),
                            spacing_small,
                          ],
                        ),
                        spacing_large,
                        CustomInviteImage(),
                        spacing_large,
                        Row(
                          children: [
                            CustomIconsHome(
                              color: blue,
                              icon: FontAwesomeIcons.bullseye,
                              size: 22,
                            ),
                            Text(
                              'My Goals',
                              style: textStyleHeading1WithTheme(
                                  context, width * 0.85,
                                  whiteColor: 4),
                            ),
                          ],
                        ),
                        CustomSizedBox(height: height),
                        allGoals == null
                            ? const SizedBox()
                            : StreamBuilder(
                                stream: allGoals,
                                builder: (BuildContext context,
                                    AsyncSnapshot snapshot) {
                                  if (snapshot.hasError) {
                                    return const Text(
                                        'Ooops...Something went wrong :(');
                                  }

                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Text("");
                                  }
                                  if (snapshot.data!.size == 0) {
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        ZakiCicularButton(
                                          title: 'Set a Goal',
                                          width: width * 0.7,
                                          selected: 4,
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const NewGoal()));
                                          },
                                        ),
                                      ],
                                    );
                                  }
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: ListView.builder(
                                      itemCount: snapshot.data!.docs.length,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 4.0),
                                          child: GoalCustomTile(
                                              snapshot:
                                                  snapshot.data!.docs[index]),
                                        );
                                      },
                                    ),
                                  );
                                },
                              ),
                        spacing_small,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 2.0),
                              child: ZakiCicularButton(
                                title: 'All Goals',
                                width: width * 0.7,
                                selected: 4,
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const AllGoals()));
                                },
                              ),
                            ),
                          ],
                        ),
                        spacing_large,
                        Container(
                          decoration: BoxDecoration(
                              color: orange,
                              borderRadius:
                                  BorderRadius.circular(width * 0.03)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    CustomIconsHome(
                                      color: white,
                                      icon: Icons.list_alt,
                                    ),
                                    Text(
                                      'Money Activities',
                                      style: textStyleHeading1WithTheme(
                                          context, width * 0.85,
                                          whiteColor: 1),
                                    ),
                                  ],
                                ),
                                spacing_medium,
                                ActivitiesHomeScreen(width: width),
                                spacing_medium,
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    ZakiCicularButton(
                                      title: 'All Activities',
                                      width: width * 0.7,
                                      selected: 3,
                                      onPressed: () async {
                                        appConstants
                                            .updateCurrentUserIdForBottomSheet(
                                                appConstants.userRegisteredId);

                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const AllTransaction()));
                                      
                                      },
                                    ),
                                  ],
                                ),
                                spacing_small,
                              ],
                            ),
                          ),
                        ),
                        spacing_large,
           
                        spacing_large,
                        Row(
                          children: [
                            CustomIconsHome(
                              color: green,
                              icon: Icons.settings_applications_outlined,
                            ),
                            Text(
                              'Manage'.tr(),
                              style: textStyleHeading1WithTheme(
                                  context, width * 0.85,
                                  whiteColor: 2),
                            ),
                          ],
                        ),
                        
                        spacing_medium,
                        appConstants.userModel.usaUserType ==
                                AppConstants.USER_TYPE_SINGLE
                            ? 
                            Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: FundsMainButton(
                                          height: height,
                                          width: width,
                                          color: transparent,
                                          title: 'Settings',
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const SettingsMainScreen()));
                                          },
                                        ),
                                      ),
                                      Expanded(
                                        child: FundsMainButton(
                                          height: height,
                                          width: width,
                                          color: transparent,
                                          title: 'Manage Debit \nCards',
                                          onTap: () async{
                                            bool? checkAuth = await authenticateTransactionUsingBioOrPinCode(appConstants: appConstants, context: context);
                                                  if(checkAuth==false){
                                                    return;
                                                  }
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const IssueDebitCard()));
                                          },
                                        ),
                                      ),
                                      Expanded(
                                        child: FundsMainButton(
                                          height: height,
                                          width: width,
                                          color: transparent,
                                          title: 'Invite Family \n& Friends',
                                          onTap: () async {
                                            await ApiServices().getUserData(
                                                context: context,
                                                userId: appConstants
                                                    .userRegisteredId);
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const InviteMainScreen(
                                                          fromHomeScreen: true,
                                                        )));
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: FundsMainButton(
                                          height: height,
                                          width: width,
                                          color: transparent,
                                          title: 'My Contacts',
                                          onTap: () async {
                                            await ApiServices().getUserData(
                                                context: context,
                                                userId: appConstants
                                                    .userRegisteredId);
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ManageContacts()));
                                          },
                                        ),
                                      ),
                                      Expanded(
                                        child: FundsMainButton(
                                          height: height,
                                          width: width,
                                          color: transparent,
                                          title: 'Fund My Wallet',
                                          onTap: () {
                                            toUpMethodsBottomSheet(
                                                context: context,
                                                height: height,
                                                width: width);
                                            // refillWalletBottomSheet(
                                            //     context: context, height: height, width: width);
                                          },
                                        ),
                                      ),
                                      Expanded(child: SizedBox()),
                                    ],
                                  ),
                                ],
                              )
                            : Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: FundsMainButton(
                                          height: height,
                                          width: width,
                                          color: transparent,
                                          title: 'Allowances'.tr(),
                                          onTap: () async{
                                            bool? checkAuth = await authenticateTransactionUsingBioOrPinCode(appConstants: appConstants, context: context);
                                              if(checkAuth==false){
                                                return;
                                              }
                                            appConstants
                                                .updateCurrentUserIdForBottomSheet(
                                                    appConstants
                                                        .userRegisteredId);
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const UpdateAllowance()));
//                                     }
                                          },
                                        ),
                                      ),
                                      Expanded(
                                        child: FundsMainButton(
                                          height: height,
                                          width: width,
                                          color: transparent,
                                          title: 'Spend Limits',
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        SpendingLimit()));
                                          },
                                        ),
                                      ),
                                      Expanded(
                                        child: FundsMainButton(
                                          height: height,
                                          width: width,
                                          color: transparent,
                                          title: 'Manage Debit \nCards',
                                          onTap: () async{
                                            bool? checkAuth = await authenticateTransactionUsingBioOrPinCode(appConstants: appConstants, context: context);
                                                  if(checkAuth==false){
                                                    return;
                                                  }
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const IssueDebitCard()));
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: FundsMainButton(
                                          height: height,
                                          width: width,
                                          color: transparent,
                                          title: 'Invite!',
                                          onTap: () async {
                                            await ApiServices().getUserData(
                                                context: context,
                                                userId: appConstants
                                                    .userRegisteredId);
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const InviteMainScreen(
                                                          fromHomeScreen: true,
                                                        )));
                                          },
                                        ),
                                      ),
                                      Expanded(
                                        child: FundsMainButton(
                                          height: height,
                                          width: width,
                                          color: transparent,
                                          title: 'My Contacts',
                                          onTap: () async {
                                            await ApiServices().getUserData(
                                                context: context,
                                                userId: appConstants
                                                    .userRegisteredId);
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ManageContacts()));
                                          },
                                        ),
                                      ),
                                      Expanded(
                                        child: 
                                        FundsMainButton(
                                          height: height,
                                          width: width,
                                          color: transparent,
                                          title: 'Settings',
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const SettingsMainScreen()));
                                          },
                                        ),
                                        
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: FundsMainButton(
                                          height: height,
                                          width: width,
                                          color: transparent,
                                          title: 'Fund My Wallet',
                                          onTap: () {
                                            toUpMethodsBottomSheet(
                                                context: context,
                                                height: height,
                                                width: width);
                                            // refillWalletBottomSheet(
                                            //     context: context, height: height, width: width);
                                          },
                                        ),
                                      ),
                                      Expanded(child: SizedBox()),
                                      Expanded(child: SizedBox()),
                                    ],
                                  ),
                                ],
                              ),
                        textValueHeaderAbove
                      ],
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

  Widget addMemberWidget(AppConstants appConstants, BuildContext context,
      double height, double width) {
    return appConstants.userModel.usaUserType!=AppConstants.USER_TYPE_PARENT
    // appConstants.userModel.userFamilyId !=
    //         appConstants.userModel.usaUserId 
        ? SizedBox.shrink()
        : InkWell(
            onTap: appConstants.familymemberlimitreached == true
                ? null
                : () async {
                  // bool? checkAuth = await authenticateTransactionUsingBioOrPinCode(appConstants: appConstants, context: context);
                  //                                 if(checkAuth==false){
                  //                                   return;
                  //                                 }
                    appConstants.updateDateOfBirth('dd / mm / yyyy');
                    appConstants.updateSignUpRole(AppConstants.USER_TYPE_KID);
                    appConstants.updateGenderType('Male');
                    bool screenNotOpen =
                        await checkUserSubscriptionValue(appConstants, context);
                    logMethod(
                        title: 'Data from Pay+',
                        message: screenNotOpen.toString());
                    if (screenNotOpen == false)
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddMemberWorkFlow()));
                    // }
                  },
            child: Icon(
              Icons.add_circle_outline,
              color: grey,
            ),
          );
  }

  Widget HomePageHeadingIcon() =>
      Image.asset(imageBaseAddress + 'homapage_heading_icon.png');

  void cardBottomSheet(
      {required BuildContext context, double? width, double? height}) {
    bool isCardChecked = false;
    double processingFee = 0.00;
    amountController.text = '';
    String expiredDate = '';
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(width! * 0.09),
            topRight: Radius.circular(width * 0.09),
          ),
        ),
        builder: (BuildContext bc) {
          var appConstants = Provider.of<AppConstants>(bc, listen: false);
          return StatefulBuilder(
            builder: (BuildContext context, setState) => Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: SingleChildScrollView(
                child: Form(
                  key: formGlobalKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                        child: InkWell(
                          onTap: () {},
                          child: Container(
                            width: width * 0.2,
                            height: 5,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(width * 0.08),
                                color: grey),
                          ),
                        ),
                      ),
                      Center(
                        child: Text(
                          'Fund My Wallet',
                          style: textStyleHeading2WithTheme(context, width,
                              whiteColor: 0),
                        ),
                      ),
                      SizedBox(
                        height: height! * 0.01,
                      ),
                      SizedBox(
                        height: height * 0.01,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: width * 0.08,
                          vertical: width * 0.01,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'How Much?',
                              style: textStyleHeading2WithTheme(
                                  context, width * 0.8,
                                  whiteColor: 0),
                            ),
                            TextFormField(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (String? amount) {
                                if (amount!.isEmpty) {
                                  return 'Please Enter Amount';
                                } else if (double.parse(amount) > 500) {
                                  return "Maximum ${getCurrencySymbol(context, appConstants: appConstants)}500";
                                } else {
                                  return null;
                                }
                              },
                              style: heading2TextStyle(context, width),
                              controller: amountController,
                              obscureText: false,
                              keyboardType: TextInputType.number,
                              maxLines: 1,
                              onFieldSubmitted: (String value) {
                                processingFee = double.parse(value) * 0.01;
                              },
                              decoration: InputDecoration(
                                hintText: '0.00',
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.all(1),
                                  child: Text(
                                    "${getCurrencySymbol(context, appConstants: appConstants)}",
                                    style: heading2TextStyle(context, width),
                                  ),
                                ),
                                prefixIconConstraints: const BoxConstraints(
                                    minWidth: 0, minHeight: 0),
                                ),
                            ),
                            CustomSizedBox(
                              height: height,
                            ),
                            Text(
                              'Card Number',
                              style: textStyleHeading2WithTheme(
                                  context, width * 0.8,
                                  whiteColor: 0),
                            ),
                            TextFormField(
                              inputFormatters: [
                                cardNumberMaskFormatter
                              ],
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (String? amount) {
                                return null;
                              },
                              style: textStyleHeading2WithTheme(context, width,
                                  whiteColor: 0),
                              controller: cardNumberController,
                              // obscureText: appConstants.passwordVissibleRegistration,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                isDense: true,
                              ),
                            ),
                            CustomSizedBox(
                              height: height,
                            ),
                            Text(
                              'Card Holder name',
                              style: textStyleHeading2WithTheme(
                                  context, width * 0.8,
                                  whiteColor: 0),
                            ),
                            TextFormField(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              maxLength: 40,
                              validator: (String? amount) {
                                return null;
                              },
                              style: textStyleHeading2WithTheme(context, width,
                                  whiteColor: 0),
                              controller: cardHolderNameController,
                              // obscureText: appConstants.passwordVissibleRegistration,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                  isDense: true, counterText: ''),
                            ),
                            CustomSizedBox(
                              height: height,
                            ),
                            Row(
                              children: [
                                Expanded(
                                    child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 2.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Expiration date',
                                        style: textStyleHeading2WithTheme(
                                            context, width * 0.8,
                                            whiteColor: 0),
                                      ),
                                      TextFormField(
                                        readOnly: true,
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        inputFormatters: [
                                          dateFormateMaskFormatter
                                        ],
                                        onTap: () async {
                                          setState(() {
                                            expiredDate =
                                                expireDateController.text;
                                          });
                                        },
                                        validator: (String? password) {
                                          return null;
                                        },
                                        maxLength: 8,
                                        decoration: InputDecoration(
                                          counterText: "",
                                        ), 
                                        style: textStyleHeading2WithTheme(
                                            context, width,
                                            whiteColor: 0),
                                        controller: expireDateController,
                                        // obscureText: appConstants.passwordVissibleRegistration,
                                        keyboardType: TextInputType.datetime,
                                      ),
                                    ],
                                  ),
                                )),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                    child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 2.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Zip Code',
                                            style: textStyleHeading2WithTheme(
                                                context, width * 0.8,
                                                whiteColor: 0),
                                          ),
                                        ],
                                      ),
                                      TextFormField(
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        maxLength: 5,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly
                                        ],
                                        validator: (String? password) {
                                          return null;
                                        },
                                        decoration:
                                            InputDecoration(counterText: ''),
                                        style: textStyleHeading2WithTheme(
                                            context, width,
                                            whiteColor: 0),
                                        controller: zipCodeController,
                                        // obscureText: appConstants.passwordVissibleRegistration,
                                        keyboardType: TextInputType.number,
                                      ),
                                    ],
                                  ),
                                ))
                              ],
                            ),
                            CustomSizedBox(
                              height: height,
                            ),
                            Text(
                              'Security Code',
                              style: textStyleHeading2WithTheme(
                                  context, width * 0.8,
                                  whiteColor: 0),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    maxLength: 5,
                                    validator: (String? code) {
                                      if (code!.isEmpty) {
                                        return 'Please Enter Security Code';
                                      } else if (code.length < 5) {
                                        return 'Please Enter Full code';
                                      } else {
                                        return null;
                                      }
                                    },
                                    obscureText: true,
                                    decoration:
                                        InputDecoration(counterText: ''),
                                    style: textStyleHeading2WithTheme(
                                        context, width,
                                        whiteColor: 0),
                                    controller: securityCodeController,
                                    // obscureText: appConstants.passwordVissibleRegistration,
                                    keyboardType: TextInputType.number,
                                  ),
                                ),
                                Expanded(
                                    child: SizedBox(
                                  width: width * 0.1,
                                ))
                              ],
                            ),
                            CustomSizedBox(
                              height: height,
                            ),
                            Row(
                              children: [
                                Text(
                                  'Processing Fee:  ',
                                  style: textStyleHeading2WithTheme(
                                      context, width * 0.8,
                                      whiteColor: 0),
                                ),
                                Text(
                                  '${getCurrencySymbol(context, appConstants: appConstants)} $processingFee',
                                  style: textStyleHeading2WithTheme(
                                      context, width * 0.7,
                                      whiteColor: 0),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Save my Card',
                                  style: textStyleHeading2WithTheme(
                                      context, width * 0.8,
                                      whiteColor: 0),
                                ),
                                Switch.adaptive(
                                  value: isCardChecked,
                                  activeColor: green,
                                  onChanged: (value) async {
                                    setState(() {
                                      isCardChecked = value;
                                    });
                                    if (isCardChecked) {
                                      if (!formGlobalKey.currentState!
                                          .validate()) {
                                        return;
                                      } else
                                        await ApiServices()
                                            .saveCardInfoForFuture(
                                                amount: amountController.text
                                                    .trim(),
                                                cardHolderName:
                                                    cardHolderNameController
                                                        .text,
                                                cardNumber:
                                                    cardNumberController.text,
                                                cardStatus: true,
                                                expiryDate: expiredDate,
                                                id: appConstants
                                                    .userRegisteredId);
                                    }
                                  },
                                ),
                              ],
                            ),
                            SizedBox(
                              height: height * 0.07,
                            ),
                            ZakiPrimaryButton(
                                title: 'Fund My Wallet',
                                width: width,
                                onPressed: () async {
                                  ApiServices service = ApiServices();
                                  service.addMoneyToMainWallet(
                                      amountSend: amountController.text.trim(),
                                      senderId: appConstants.userRegisteredId);
                                  service.saveProcessingFee(
                                      feeAmount: processingFee,
                                      totalAmount: double.parse(
                                          amountController.text.trim()),
                                      id: appConstants.userRegisteredId);
                                  showNotification(
                                      error: 0,
                                      icon: Icons.check,
                                      message: 'Amount Added Successfully');
                                  Navigator.pop(context);
                                }),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }


}
  void toUpMethodsBottomSheet(
      {required BuildContext context, double? width, double? height}) async {
    var appConstants = Provider.of<AppConstants>(context, listen: false);
    bool screenNotOpen =
        await checkUserSubscriptionValue(appConstants, context);
    logMethod(title: 'Data from Pay+', message: screenNotOpen.toString());
    if (screenNotOpen == true) {
      // Navigator.pop(context);
    } else
      // bool isCardChecked = false;
      showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(width! * 0.09),
              topRight: Radius.circular(width * 0.09),
            ),
          ),
          builder: (BuildContext bc) {
            var appConstants = Provider.of<AppConstants>(bc, listen: false);
            return StatefulBuilder(
              builder: (BuildContext context, setState) => Padding(
                padding: MediaQuery.of(context).viewInsets,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                        child: InkWell(
                          onTap: () {},
                          child: Container(
                            width: width * 0.2,
                            height: 5,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(width * 0.08),
                                color: grey),
                          ),
                        ),
                      ),
                      Center(
                        child: Text(
                          'Options to fund my wallet',
                          style: heading1TextStyle(context, width),
                        ),
                      ),
                      textValueHeaderbelow,
                      textValueHeaderbelow,
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: width * 0.08,
                          vertical: width * 0.01,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if(appConstants.allowApplePayAndGooglePay)
                      Platform.isIOS ? applePayButton : googlePayButton,
                //             Platform.isIOS ? applePayButton : googlePayButton,
                //             // Platform.isAndroid?
                //             // if(Platform.isIOS)
                //             // Column(
                //             //   children: [

                //             //   TopUpMethodTile(
                //             //       onTap: () {},
                //             //       icon: FontAwesomeIcons.ccApplePay,
                //             //       width: width,
                //             //       title: 'Apple Send (Coming soon)'),
                //             //   spacing_medium,

                //             //   ],
                //             // ),
                //             // TopUpMethodTile(
                //             //     onTap: () {},
                //             //     width: width,
                //             //     icon: FontAwesomeIcons.googlePay,
                //             //     title: 'Google Send (Coming soon)'),
                //             spacing_medium,
                //             TopUpMethodTile(
                //                 onTap: () async{
                //                   String token = await CreaditCardApi().getClientTokenFromYourServer();
                //                   var request = BraintreeDropInRequest(
                //   tokenizationKey: token,
                //   collectDeviceData: true,
                //   vaultManagerEnabled: true,
                //   requestThreeDSecureVerification: true,
                //   paypalEnabled: false,
                //   email: "test@email.com",
                //   amount: '4.20',
                //   billingAddress: BraintreeBillingAddress(
                //     givenName: "Jill",
                //     surname: "Doe",
                //     phoneNumber: "5551234567",
                //     streetAddress: "555 Smith St",
                //     extendedAddress: "#2",
                //     locality: "Chicago",
                //     region: "IL",
                //     postalCode: "12345",
                //     countryCodeAlpha2: "US",
                //   ),
                //   googlePaymentRequest: BraintreeGooglePaymentRequest(
                //     totalPrice: '4.20',
                //     currencyCode: 'USD',
                //     billingAddressRequired: false,
                //   ),
                //   applePayRequest: BraintreeApplePayRequest(
                //       currencyCode: 'USD',
                //       supportedNetworks: [
                //         ApplePaySupportedNetworks.visa,
                //         ApplePaySupportedNetworks.masterCard,
                //         // ApplePaySupportedNetworks.amex,
                //         // ApplePaySupportedNetworks.discover,
                //       ],
                //       countryCode: 'US',
                //       merchantIdentifier: '',
                //       displayName: '',
                //       paymentSummaryItems: []),
                //   paypalRequest: BraintreePayPalRequest(
                //     amount: '4.20',
                    
                //     displayName: 'Example company',
                //   ),
                //   cardEnabled: true,
                // );
                // final result = await BraintreeDropIn.start(request);
                
                // if (result != null) {
                //   // showNonce(result.paymentMethodNonce);
                //   logMethod(title: 'Result of Braintree transacttion', message: result.paymentMethodNonce.nonce);
                //   // var request = BraintreeDropInResult(paymentMethodNonce: result.paymentMethodNonce, deviceData: result.paymentMethodNonce.nonce);
                // }
                
                //                 },
                //                 width: width,
                //                 icon: FontAwesomeIcons.paypal,
                //                 title: 'PayPal (Coming soon)'),
                //             spacing_medium,
                            TopUpMethodTile(
                                onTap: () async {
                                  await ApiServices()
                                      .getCardInfoFromFundMyWallet(
                                          userId: appConstants.userRegisteredId,
                                          context: context);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              FundMyWallet()));

                                },
                                width: width,
                                icon: FontAwesomeIcons.creditCard,
                                title: 'Debit/Credit Card'),
                            spacing_medium,
                            TopUpMethodTile(
                                onTap: () async {
                                  appConstants
                                      .updateCurrentUserIdForBottomSheet(
                                          appConstants.userRegisteredId);
// bool screenNotOpen = await checkUserSubscriptionValue(appConstants, context);
//                                   if(screenNotOpen==false){
                                  appConstants
                                      .updatePayRequestModel(PayRequestModel());
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              PayOrRequestScreen()));
                                  // }
                                },
                                width: width,
                                icon: FontAwesomeIcons.moneyBillTransfer,
                                iconColor: green,
                                title: 'Send or Request'),
                            textValueHeaderbelow,
                            textValueHeaderbelow
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          });
  }

class ActivitiesHomeScreen extends StatefulWidget {
  const ActivitiesHomeScreen({
    Key? key,
    required this.width,
  }) : super(key: key);

  final double width;

  @override
  State<ActivitiesHomeScreen> createState() => _ActivitiesHomeScreenState();
}

class _ActivitiesHomeScreenState extends State<ActivitiesHomeScreen> {
     Stream<QuerySnapshot>? requestedMoneyActivities;

  @override
  void initState() {
    getMoney();
    super.initState();
  }

  getMoney() {
    Future.delayed(Duration.zero, () async {
      var appConstants = Provider.of<AppConstants>(context, listen: false);
      requestedMoneyActivities = await ApiServices().getRequestedMoney(
          appConstants.userRegisteredId,
          collectionName: AppConstants.Transaction,
          limit: 3);
          setState(() {
            
          });
    });
  }
  @override
  Widget build(BuildContext context) {
    return
    requestedMoneyActivities == null 
    ? const SizedBox()
    : Container(
        decoration: BoxDecoration(
            // color: white,
            borderRadius: BorderRadius.circular(
                widget.width * 0.05)),
        child: StreamBuilder<QuerySnapshot>(
          stream: requestedMoneyActivities,
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot>
                  snapshot) {
            if (snapshot.hasError) {
              return const Text(
                  'Ooops...Something went wrong :(');
            }
            if (snapshot.connectionState ==
                ConnectionState.waiting) {
              return const Text("");
            }
            if (snapshot.data!.size == 0) {
              return Row(
              mainAxisAlignment:
                  MainAxisAlignment.center,
              children: [
                ZakiCicularButton(
                  title: 'Sync Contacts',
                  width: widget.width * 0.7,
                  selected: 3,
                  icon: Icons.sync_outlined,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const InviteMainScreen(
                            fromHomeScreen:
                                true,
                          ),
                        ));
                  },
                ),
              ],
            );
            }
    
    //snapshot.data!.docs[index] ['USER_first_name']
            if (snapshot.hasData &&
                snapshot.data!.docs.isNotEmpty)
              return Container(
                decoration: BoxDecoration(
                    color: white,
                    borderRadius:
                        BorderRadius.circular(
                            widget.width * 0.05)),
                child: ListView.separated(
                  separatorBuilder:
                      (context, index) =>
                          const Divider(),
                  itemCount: snapshot
                      .data!.docs.length,
                  physics:
                      const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder:
                      (BuildContext context,
                          int index) {
                    // print(snapshot.data!.docs[index] ['USER_first_name']);
                    return AllActivitiesCustomTileHomeScreen(
                      data: snapshot
                          .data!.docs[index],
                      onTap: null,
                    );
                  },
                ),
              );
            // if(snapshot.hasData && snapshot.data!.docs.isNotEmpty)
            return Row(
              mainAxisAlignment:
                  MainAxisAlignment.center,
              children: [
                ZakiCicularButton(
                  title: 'Sync Contacts',
                  width: widget.width * 0.7,
                  selected: 3,
                  icon: Icons.sync_outlined,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const InviteMainScreen(
                            fromHomeScreen:
                                true,
                          ),
                        ));
                  },
                ),
              ],
            );
          },
        ),
      );
  }
}



class TopFriendsBuilder extends StatefulWidget {
  const TopFriendsBuilder({
    Key? key,
    required this.width,
  }) : super(key: key);

  final double width;

  @override
  State<TopFriendsBuilder> createState() => _TopFriendsBuilderState();
}

class _TopFriendsBuilderState extends State<TopFriendsBuilder> {
  Stream<QuerySnapshot<Object?>>? topFriends;
    @override
  void initState() {
    super.initState();
    // securityCodeController.text = '7775';
    // amountController.text = '0.00';
    getUserKids();
  }

  getUserKids() async {

    Future.delayed(Duration.zero, () async {
      var appConstants = Provider.of<AppConstants>(context, listen: false);
      
      topFriends = await ApiServices()
          .fetchUserTopFriends(context, id: appConstants.userRegisteredId);
      

      setState(() {});
    });
  }
  @override
  Widget build(BuildContext context) {
    // var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return
    topFriends==null ? SizedBox.shrink():
     StreamBuilder<QuerySnapshot>(
      stream: topFriends,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Ooops...Something went wrong :(');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("");
        }
        if (snapshot.data!.size == 0) {
          return SizedBox(
            width: width*0.85,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ZakiCicularButton(
                  title: 'Sync Contacts',
                  width: widget.width * 0.7,
                  selected: 3,
                  icon: Icons.sync_outlined,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const InviteMainScreen(
                            fromHomeScreen:
                                true,
                          ),
                        ));
                  },
                ),
              ],
            ),
          );
      
        }
        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemBuilder: (BuildContext context, int index) {
            // print(snapshot.data!.docs[index] ['USER_first_name']);
            return InkWell(
              onTap: () async {
              },
              child: TopFriendsCustomWidget(
                selectedIndexTopFriends: 0,
                width: widget.width,
                index: index,
                snapshot: snapshot.data!.docs[index],
                enableOnTap: true,
              ),
            );
          },
        );
      },
    );
  }
}

class SetupWalletAndFamily extends StatelessWidget {
  const SetupWalletAndFamily({
    Key? key,
    required this.width,
    required this.appConstants,
    this.title,
    this.onPressed,
    this.color,
    this.leadingImage,
    this.buttonTitle,
  }) : super(key: key);

  final double width;
  final AppConstants appConstants;
  final String? title;
  final String? buttonTitle;
  final VoidCallback? onPressed;
  final Color? color;
  final String? leadingImage;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(width * 0.04),
        border: Border.all(color: borderColor)
      ),
      child: Row(
        children: [
          Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Image.asset(imageBaseAddress + '$leadingImage'),
              )),
          Expanded(
              flex: 8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: Text(
                      '$title',
                      style: heading2TextStyle(context, width, color: color),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  spacing_medium,
                  SizedBox(
                    width: width * 0.38,
                    child: ZakiCicularButton(
                        width: width,
                        title: '$buttonTitle',
                        borderColor: color,
                        backGroundColor: color,
                        textStyle: heading3TextStyle(width, color: white),
                        onPressed: onPressed),
                  )
                ],
              )),
        ],
      ),
    );
  }
}

class CustomKidWalletBalance extends StatelessWidget {
  const CustomKidWalletBalance(
      {Key? key, required this.width, required this.userId})
      : super(key: key);

  final double width;
  final String userId;

  @override
  Widget build(BuildContext context) {
    var appConstants = Provider.of<AppConstants>(context, listen: true);
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection(AppConstants.USER)
            .doc(userId)
            .collection(AppConstants.USER_WALLETS)
            .doc(AppConstants.Spend_Wallet)
            .snapshots(),
        builder:
            (context, AsyncSnapshot<DocumentSnapshot> snapshotSpendWallet) {
          if (!snapshotSpendWallet.hasData) {
            return Text("");
          }
          return StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection(AppConstants.USER)
                  .doc(userId)
                  .collection(AppConstants.USER_WALLETS)
                  .doc(AppConstants.Savings_Wallet)
                  .snapshots(),
              builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Text("");
                }
                return StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection(AppConstants.USER)
                        .doc(userId)
                        .collection(AppConstants.USER_WALLETS)
                        .doc(AppConstants.All_Goals_Wallet)
                        .snapshots(),
                    builder: (context,
                        AsyncSnapshot<DocumentSnapshot> goalSnapshot) {
                      if (!goalSnapshot.hasData) {
                        return Text("");
                      }
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            // '${getCurrencySymbol(context, appConstants: appConstants)}99999',
                            '${getCurrencySymbol(context, appConstants: appConstants)} ',
                            style: heading2TextStyle(context, width,
                                color: white),
                          ),
                          Text(
                            // '${getCurrencySymbol(context, appConstants: appConstants)}99999',
                            '${getAmountAsFormatedIntoLetter(amount: double.parse((snapshotSpendWallet.data![AppConstants.wallet_balance] ?? 0).toString()) + double.parse((snapshot.data![AppConstants.wallet_balance] ?? 0).toString()) + double.parse((goalSnapshot.data![AppConstants.wallet_balance] ?? 0).toString()))}',
                            style: heading1TextStyle(context, width + width * 0.2,
                                color: white),
                          ),
                        ],
                      );
                    });
              });
        });
  }
}

class CustomLockWidget extends StatelessWidget {
  const CustomLockWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.lock_outline,
      color: grey,
      size: 14,
    );
  }
}

class CustomImageHolder extends StatelessWidget {
  const CustomImageHolder({Key? key, required this.imageUrl, this.color})
      : super(key: key);
  final IconData imageUrl;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 4.0),
      child: Icon(
        imageUrl,
        size: 18,
        color: color != null ? color : black.withOpacity(0.7),
      ),
    );
  }
}

class CustomIconsHome extends StatelessWidget {
  const CustomIconsHome({Key? key, this.icon, this.color, this.size})
      : super(key: key);
  final IconData? icon;
  final Color? color;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 4.0),
      child: Icon(
        icon,
        color: color,
        size: size == null ? 30 : size,
      ),
    );
  }
}

class TopUpMethodTile extends StatelessWidget {
  const TopUpMethodTile(
      {Key? key,
      required this.onTap,
      required this.icon,
      required this.title,
      this.iconColor,
      this.width})
      : super(key: key);

  final VoidCallback? onTap;
  final IconData? icon;
  final String title;
  final double? width;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: transparent,
          borderRadius: BorderRadius.circular(width! * 0.03),
          border: Border.all(color: grey.withOpacity(0.4))),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: iconColor ?? green),
        title: Text('$title', style: heading3TextStyle(width!)),
        trailing: Icon(
          Icons.arrow_forward,
          color: grey,
          size: 20,
        ),
      ),
    );
  }
}

class PaymentTypeButton extends StatelessWidget {
  const PaymentTypeButton(
      {Key? key, required this.width, required this.onTap, this.title})
      : super(key: key);

  final double width;
  final VoidCallback onTap;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: width,
        decoration: BoxDecoration(
            color: grey, borderRadius: BorderRadius.circular(width * 0.03)),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: FittedBox(
              child: Text(
                title!,
                style: textStyleHeading2WithTheme(context, width * 0.8,
                    whiteColor: 0),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
