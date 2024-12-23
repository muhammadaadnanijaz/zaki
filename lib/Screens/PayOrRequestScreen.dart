import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ndialog/ndialog.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:zaki/Constants/AuthMethods.dart';
import 'package:zaki/Constants/CheckInternetConnections.dart';
import 'package:zaki/Constants/HelperFunctions.dart';
import 'package:zaki/Constants/LocationGetting.dart';
import 'package:zaki/Constants/NotificationTitle.dart';
import 'package:zaki/Models/BalanceModel.dart';
import 'package:zaki/Models/UserModel.dart';
import 'package:zaki/Screens/HomeScreen.dart';
import 'package:zaki/Screens/InviteMainScreen.dart';
import 'package:zaki/Screens/IssueAndManageCards.dart';
import 'package:zaki/Screens/SearchFriends.dart';
import 'package:zaki/Services/CreaditCardApis.dart';
import 'package:zaki/Widgets/CustomConfermationScreen.dart';
import 'package:zaki/Widgets/CustomLoadingScreen.dart';
// import 'package:zaki/Widgets/FloatingActionButton.dart';
import 'package:zaki/Widgets/SSLCustom.dart';
import 'package:zaki/Widgets/TextHeader.dart';
import 'package:zaki/Widgets/WalletBalance.dart';
import 'package:zaki/Widgets/ZakiCircularButton.dart';
import 'package:zaki/Widgets/ZakiPrimaryButton.dart';
import '../Constants/AppConstants.dart';
import '../Constants/Spacing.dart';
import '../Constants/Styles.dart';
import '../Models/ImageModels.dart';
import '../Models/PayRequestsModel.dart';
import '../Services/api.dart';
import '../Widgets/AppBars/AppBar.dart';
import '../Widgets/CustomBottomNavigationBar.dart';
import '../Widgets/CustomTextField.dart';
import '../Widgets/SSLCustomRow.dart';
import '../Widgets/TopFriendsCustomWidget.dart';
import 'PayReview.dart';
import 'package:zaki/Widgets/CustomLoader.dart';


class PayOrRequestScreen extends StatefulWidget {
  final String? fromManageContactPhoneNumber;
  final UserModel? selectedUserModel;
  final bool? leadingIconRequired;
  final bool? needBottomNavbar;
  final bool? fromHomeScreen;

  const PayOrRequestScreen(
      {Key? key,
      this.fromManageContactPhoneNumber,
      this.selectedUserModel,
      this.leadingIconRequired,
      this.needBottomNavbar,
      this.fromHomeScreen})
      : super(key: key);

  @override
  _PayOrRequestScreenState createState() => _PayOrRequestScreenState();
}

class _PayOrRequestScreenState extends State<PayOrRequestScreen> {
  final ImagePicker _picker = ImagePicker();
  XFile? img;
  UserModel? selectedUserModelFromFriend;
  bool loading = false;
  XFile? userLogo;
  int selectedIndex = -1;
  int selectedIndexTopFriends = -1;
  int selectedAllocation = -2;
  bool emojiShowing = false;
  final messageController = TextEditingController();
  final amountController = TextEditingController();
  String imageUrl = '1';
  // Stream<QuerySnapshot>? userKids;
  Stream<QuerySnapshot>? topFriends;
  String receiverGender = '';
  String selectedKidId = '';
  String selectedKidImageUrl = '';
  String selectedKidName = '';
  String selectedKidBankToken = '';
  String receiverUserType = '';
  late Icon selectedKidIcon;
  int length = 0;
  String? error = null;
  ApiServices services = ApiServices();
  bool viewScreen = false;

  List<String> userInvitedList = [];

  List<ImageModel> imageList = [
    ImageModel(id: 0, imageName: imageBaseAddress + 'Pay+1.png'),
    ImageModel(id: 1, imageName: imageBaseAddress + 'Pay+2.png'),
    ImageModel(id: 2, imageName: imageBaseAddress + 'Pay+3.png'),
    ImageModel(id: 3, imageName: imageBaseAddress + 'Pay+4.png'),
    ImageModel(id: 4, imageName: imageBaseAddress + 'Pay+5.png'),
  ];

  void _onEmojiSelected(Emoji emoji) {
    messageController
      ..text += emoji.emoji
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: messageController.text.length));
  }

  void _onBackspacePressed() {
    messageController
      ..text = messageController.text.characters.skipLast(1).toString()
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: messageController.text.length));
  }

  @override
  void dispose() {
    messageController.dispose();
    // passwordCotroller.dispose();
    super.dispose();
  }

  void clearFields() {
    messageController.text = '';
    // passwordCotroller.text = '';
    setState(() {});
  }
@override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // add setCurrentScreeninstead of initState because might not always give you the
    // expected results because initState() is called before the widget
    // is fully initialized, so the screen might not be visible yet.
    setScreenName(name: AppConstants.PAY_OR_REQUEST);
  }

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 200), () async {
      var appConstants = Provider.of<AppConstants>(context, listen: false);
      appConstants.updateLoading(false);
      // bool screenNotOpen = await checkUserSubscriptionValue(appConstants, context);
      // userKids = services.fetchUserKids(appConstants.userRegisteredId,
      //     currentUserId: appConstants.userRegisteredId);
      bool screenNotOpen =
          await checkUserSubscriptionValue(appConstants, context);
      logMethod(title: 'Data from Pay+', message: screenNotOpen.toString());
      if (screenNotOpen == true) {
        if (widget.fromHomeScreen == true) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => HomeScreen()));
        } else {
          Navigator.pop(context);
        }
      }
      // viewScreen = screenNotOpen;
      topFriends = services.fetchUserTopFriends(context,
          id: appConstants.userRegisteredId);
      imageUrl = imageList[0].imageName!;
      ////////Upading If kid has lock publish
      appConstants.updateSlectedPrivacyTypeIndex(
          (appConstants.personalizationSettingModel != null &&
                  appConstants.personalizationSettingModel!.kidPKids2Publish ==
                      false)
              ? 3
              : 1);
      //       String imageUrl = '';
      // String firstNmae = '';
      // String lastName = '';
      // String userName = '';
      // String userId = '';
      if (widget.selectedUserModel != null) {
        // String? userId = await services.getUserIdFromPhoneNumber(
        //     number: widget.fromManageContactPhoneNumber);
        selectedKidId = widget.selectedUserModel!.usaUserId!;
        selectedUserModelFromFriend = widget.selectedUserModel;
        selectedKidName = widget.selectedUserModel!.usaUserName!;
        selectedKidImageUrl = widget.selectedUserModel!.usaLogo!;
        receiverGender = '';
        receiverUserType = '';
      }
      setState(() {});
    });
    // amountController.addListener(() {
    //   bool isButtonActive = amountController.text.isNotEmpty;
    //   setState(() {
    //     if (isButtonActive) {
    //       length = 1;
    //     } else {
    //       length = 0;
    //     }
    //   });
    // });
    super.initState();
  }

  // ignore: body_might_complete_normally_nullable
  Future<String?> getUserKidSpendingLimits(
      {String? parentId,
      String? kidId,
      required AppConstants appConstants}) async {
        logMethod(title: "Get Spending Limit", message: "Parent id: $parentId and Kid Id: $kidId");
    String getSpendLimitName = '';
    Map<String, dynamic>? data =
        await ApiServices().getKidSpendingLimit(parentId!, kidId!);
    if (data != null) {
      // static List<ImageModelTagIt> tagItList = [
      //   ImageModelTagIt(id: 0, icon: Icons.phone_iphone_sharp, title: ''),
      //   ImageModelTagIt(id: 1, icon: FontAwesomeIcons.moneyBillTransfer, title: 'Allowance'),
      //   ImageModelTagIt(id: 2, icon: FontAwesomeIcons.tv, title: ''),
      //   ImageModelTagIt(id: 3, icon: FontAwesomeIcons.handHolding, title: ''),
      //   ImageModelTagIt(id: 4, icon: FontAwesomeIcons.graduationCap, title: ''),
      //   ImageModelTagIt(id: 5, icon: FontAwesomeIcons.burger, title: ''),
      //   ImageModelTagIt(id: 6, icon: FontAwesomeIcons.gift, title: ''),
      //   ImageModelTagIt(id: 7, icon: FontAwesomeIcons.bullseye, title: 'Goals'),
      //   ImageModelTagIt(id: 8, icon: FontAwesomeIcons.basketShopping, title: ''),
      //   ImageModelTagIt(id: 9, icon: FontAwesomeIcons.gasPump, title: ''),
      //   ImageModelTagIt(id: 10, icon: FontAwesomeIcons.exchange,title: ''),
      //   ImageModelTagIt(id: 11, icon: FontAwesomeIcons.video, title: ''),
      //   ImageModelTagIt(id: 12, icon: Icons.receipt_long_rounded, title: ''),
      //   ImageModelTagIt(id: 13, icon: FontAwesomeIcons.cartShopping, title: 'Shopping'),
      //   ImageModelTagIt(id: 14, icon: FontAwesomeIcons.gamepad, title: 'Video Games'),
      // ];

      ////////Check Max limit transaction
      if (int.parse(amountController.text) >
          data[AppConstants.SpendL_Transaction_Amount_Remain]) {
        // customAleartDialog(
        //     context: context,
        //     title: 'Wow! Monthly Spend Limit Reached!',
        //     width: 140,
        //     titleButton1: 'Fund Wallet Now',
        //     firstButtonOnPressed: () {},
        //     secondButtonOnPressed: () {
        //       Navigator.pop(context);
        //     });
        showDialog(
            context: context,
            builder: (BuildContext dialougeContext) {
              var width = MediaQuery.of(context).size.width;
              return AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(14.0))),
                  content: TextValue2(
                    title: 'Wow! Monthly Spend Limit Reached!',
                  ),
                  actions: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ZakiCicularButton(
                          title: 'Fund Wallet Now',
                          width: width,
                          textStyle: heading4TextSmall(width, color: green),
                          onPressed: () {
                            Navigator.pop(dialougeContext);
                          },
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        ZakiCicularButton(
                          title: '      No      ',
                          width: width,
                          selected: 4,
                          backGroundColor: green,
                          border: false,
                          textStyle: heading4TextSmall(width, color: white),
                          onPressed: () {
                            Navigator.pop(dialougeContext);
                          },
                        ),
                      ],
                    ),
                  ]
                  // actions
                  );
            });
        appConstants.updateLoading(false);
        return 'Monthly limit reached!';
      }
      //       static String  = 'Apps';
      // static String  = 'Charity';
      // static String  = 'Education';
      // static String  = 'Electronics';
      // static String  = 'Fast Food';
      // static String  = 'Gifts';
      // static String  = 'Groceries';
      // static String  = 'Gas Station';
      // static String  = 'Movies';
      // static String TAGID0010 = 'Other Stuff';
      // static String  = 'Shopping';
      // static String  = 'Video Games';
      // static String  = 'Reward';

      if (AppConstants.tagItList[selectedAllocation].title ==
          AppConstants.TAGID0012) {
        getSpendLimitName = AppConstants.SpendL_TAGID0012_Remain;
      } else if (AppConstants.tagItList[selectedAllocation].title ==
          AppConstants.TAGID0011) {
        getSpendLimitName = AppConstants.SpendL_TAGID0011_Remain;
      } else if (AppConstants.tagItList[selectedAllocation].title ==
          AppConstants.TAGID9997) {
        getSpendLimitName = AppConstants.SpendL_TAGID0011_Remain;
      } else if (AppConstants.tagItList[selectedAllocation].title ==
          AppConstants.TAGID0009) {
        getSpendLimitName = AppConstants.SpendL_TAGID0009_Remain;
      }
      // else if (AppConstants.tagItList[selectedAllocation].title ==
      //     "Internal Transfer") {
      //   getSpendLimitName = AppConstants.SpendL_Transaction_Amount_Remain;
      // }
      else if (AppConstants.tagItList[selectedAllocation].title ==
          AppConstants.TAGID0008) {
        getSpendLimitName = AppConstants.SpendL_TAGID0008_Remain;
      } else if (AppConstants.tagItList[selectedAllocation].title ==
          AppConstants.TAGID0007) {
        getSpendLimitName = AppConstants.SpendL_TAGID0007_Remain;
      } else if (AppConstants.tagItList[selectedAllocation].title ==
          AppConstants.TAGID0006) {
        getSpendLimitName = AppConstants.SpendL_TAGID0006_Remain;
      } else if (AppConstants.tagItList[selectedAllocation].title ==
          AppConstants.TAGID0005) {
        getSpendLimitName = AppConstants.SpendL_TAGID0005_Remain;
      } else if (AppConstants.tagItList[selectedAllocation].title ==
          AppConstants.TAGID0002) {
        getSpendLimitName = AppConstants.SpendL_TAGID0002_Remain;
      } else if (AppConstants.tagItList[selectedAllocation].title ==
          AppConstants.TAGID0003) {
        getSpendLimitName = AppConstants.SpendL_TAGID0003_Remain;
      } else if (AppConstants.tagItList[selectedAllocation].title ==
          AppConstants.TAGID0004) {
        getSpendLimitName = AppConstants.SpendL_TAGID0004_Remain;
      } else if (AppConstants.tagItList[selectedAllocation].title ==
          AppConstants.TAGID0001) {
        getSpendLimitName = AppConstants.SpendL_TAGID0001_Remain;
      } else {}

      logMethod(
          title: "Spend Limit for selected Tag it.",
          message:
              " and ${getSpendLimitName} value is: ${data[getSpendLimitName]}");
      if (int.parse(amountController.text) >
          data[AppConstants.SpendL_Transaction_Amount_Remain]) {
        // customAleartDialog(
        //     context: context,
        //     title: "Wow! Monthly Spend Limit Reached!",
        //     width: 140,
        //     titleButton1: 'Fund Wallet Now',
        //     firstButtonOnPressed: () {},
        //     secondButtonOnPressed: () {
        //       Navigator.pop(context);
        //     });
        showDialog(
            context: context,
            builder: (BuildContext dialougeContext) {
              var width = MediaQuery.of(context).size.width;
              return AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(14.0))),
                  content: TextValue2(
                    title: 'Wow! Monthly Spend Limit Reached!',
                  ),
                  actions: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ZakiCicularButton(
                          title: 'Fund Wallet Now',
                          width: width,
                          textStyle: heading4TextSmall(width, color: green),
                          onPressed: () {
                            Navigator.pop(dialougeContext);
                          },
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        ZakiCicularButton(
                          title: '      No      ',
                          width: width,
                          selected: 4,
                          backGroundColor: green,
                          border: false,
                          textStyle: heading4TextSmall(width, color: white),
                          onPressed: () {
                            Navigator.pop(dialougeContext);
                          },
                        ),
                      ],
                    ),
                  ]
                  // actions
                  );
            });
        appConstants.updateLoading(false);
        return 'Monthly limit reached!';
      } else {
        if (int.parse(amountController.text) > data[getSpendLimitName]) {
          // customAleartDialog(
          //     context: context,
          //     title:
          //         "Wow! Monthly Spend Limit reached for ${AppConstants.tagItList[selectedAllocation].title}",
          //     width: 140,
          //     titleButton1: 'Fund Wallet Now',
          //     firstButtonOnPressed: () {},
          //     secondButtonOnPressed: () {
          //       Navigator.pop(context);
          //     });
          showDialog(
            context: context,
            builder: (BuildContext dialougeContext) {
              var width = MediaQuery.of(context).size.width;
              return AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(14.0))),
                  content: TextValue2(
                    title:
                        "Wow! Monthly Spend Limit reached for ${AppConstants.tagItList[selectedAllocation].title}",
                  ),
                  actions: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ZakiCicularButton(
                          title: 'Fund Wallet Now',
                          width: width,
                          textStyle: heading4TextSmall(width, color: green),
                          onPressed: () {
                            Navigator.pop(dialougeContext);
                          },
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        ZakiCicularButton(
                          title: '      No      ',
                          width: width,
                          selected: 4,
                          backGroundColor: green,
                          border: false,
                          textStyle: heading4TextSmall(width, color: white),
                          onPressed: () {
                            Navigator.pop(dialougeContext);
                          },
                        ),
                      ],
                    ),
                  ]
                  // actions
                  );
            },
          );
          appConstants.updateLoading(false);
          return 'Monthly limit reached!';
        } else {
          ApiServices().updateSpendingRemain(
              parentId: parentId,
              id: kidId,
              amount: int.parse(amountController.text),
              fieldName: getSpendLimitName);
          // showNotification(error: 0, icon: Icons.check, message: 'Tag it hits');
        }
      }
    } else {
      logMethod(title: "Spending limit found", message: "sorry not found");
    }
  }

  @override
  Widget build(BuildContext context) {
    var appConstants = Provider.of<AppConstants>(context, listen: true);
    var internet = Provider.of<CheckInternet>(context, listen: true);
    // var CheckInternet
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // floatingActionButton: Padding(
      //   padding: EdgeInsets.only(bottom: height * 0.085),
      //   child: CustomFloadtingActionButton(),
      // ),
      bottomNavigationBar: widget.needBottomNavbar == false
          ? null
          : CustomBottomNavigationBar(index: 1),
      // backgroundColor: grey.withOpacity(0.98),
      body: SafeArea(
        child: loading == true
            ? CustomLoadingScreen()
            : Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      physics: viewScreen
                          ? NeverScrollableScrollPhysics()
                          : BouncingScrollPhysics(),
                      child: SingleChildScrollView(
                        physics: viewScreen
                            ? NeverScrollableScrollPhysics()
                            : BouncingScrollPhysics(),
                        child: Padding(
                          padding: getCustomPadding(),
                          child: Column(
                            children: [
                              appBarHeader_005(
                                  context: context,
                                  appBarTitle: 'Send or Request',
                                  backArrow: true,
                                  rightSideAppbarIcon:
                                      FontAwesomeIcons.arrowRightArrowLeft,
                                  height: height,
                                  width: width,
                                  leadingIcon:
                                      // widget.leadingIconRequired == false
                                      //     ? false
                                      // :
                                      widget.fromHomeScreen == true
                                          ? false
                                          : true,
                                  tralingIconButton: SSLCustom()),
                              Stack(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // spacing_medium,
                                      // spacing_small,
                                      Text(
                                        'How Much?',
                                        style:
                                            heading1TextStyle(context, width),
                                      ),
                                      CustomTextField(
                                        amountController: amountController,
                                        // error: error == null ? null : error,
                                        // onChanged: (String value) {
                                        //   if(error!=null)
                                        //   setState(() {
                                        //     error = null;
                                        //     logMethod(
                                        //         title: 'Error message onchange',
                                        //         message: error.toString());
                                        //   });
                                        // },
                                      ),
                                      spacing_small,
                                      WalletBalance(appConstants: appConstants),
                                      spacing_large,
                                      Text('To/From',
                                          style: heading1TextStyle(
                                              context, width)),
                                      spacing_medium,
                                      selectedUserModelFromFriend != null
                                          ? Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  height: height * 0.085,
                                                  width: height * 0.085,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                        color: green),
                                                    boxShadow: [
                                                      customBoxShadow(
                                                          color: green)
                                                    ],
                                                  ),
                                                  child: userImage(
                                                      imageUrl:
                                                          selectedUserModelFromFriend!
                                                              .usaLogo
                                                              .toString(),
                                                      userType:
                                                          selectedUserModelFromFriend!
                                                              .usaUserType,
                                                      width: width,
                                                      gender:
                                                          selectedUserModelFromFriend!
                                                              .usaGender),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  '${selectedUserModelFromFriend!.usaUserName.toString()}',
                                                  overflow: TextOverflow.clip,
                                                  maxLines: 1,
                                                  style:
                                                      heading4TextSmall(width),
                                                )
                                              ],
                                            )
                                          : SizedBox(
                                              height: height * 0.125,
                                              width: width,
                                              child: SingleChildScrollView(
                                                physics:
                                                    BouncingScrollPhysics(),
                                                scrollDirection:
                                                    Axis.horizontal,
                                                child: Row(
                                                  children: [
//                                       userKids == null
//                                           ? const SizedBox()
//                                           : StreamBuilder<QuerySnapshot>(
//                                               stream: userKids,
//                                               builder: (BuildContext context,
//                                                   AsyncSnapshot<QuerySnapshot>
//                                                       snapshot) {
//                                                 if (snapshot.hasError) {
//                                                   return const Text(
//                                                       'Ooops...Something went wrong :(');
//                                                 }

//                                                 if (snapshot.connectionState ==
//                                                     ConnectionState.waiting) {
//                                                   return const Text("");
//                                                 }
//                                                 if (snapshot.data!.size == 0) {
//                                                   return SizedBox.shrink();
//                                                 }
// //snapshot.data!.docs[index] ['USER_first_name']
//                                                 return ListView.builder(
//                                                   itemCount: snapshot
//                                                       .data!.docs.length,
//                                                   physics:
//                                                       const NeverScrollableScrollPhysics(),
//                                                   shrinkWrap: true,
//                                                   scrollDirection:
//                                                       Axis.horizontal,
//                                                   itemBuilder:
//                                                       (BuildContext context,
//                                                           int index) {
//                                                     // print(snapshot.data!.docs[index] ['USER_first_name']);
//                                                     return (snapshot.data!.docs[
//                                                                         index][
//                                                                     AppConstants
//                                                                         .NewMember_isEnabled] ==
//                                                                 false ||
//                                                             (snapshot.data!.docs[
//                                                                         index][
//                                                                     AppConstants
//                                                                         .USER_UserType] !=
//                                                                 AppConstants
//                                                                     .USER_TYPE_KID))
//                                                         ? SizedBox.shrink()
//                                                         : InkWell(
//                                                             onTap: () async {
//                                                               // appConstants.updateAllowanceSchedule(snapshot.data!.docs[index]['USER_allowance_schedule']);
//                                                               // ApiServices services = ApiServices();
//                                                               // // dynamic kidData =
//                                                               // await services.fetchUserKidWithFuture(
//                                                               //     snapshot.data!.docs[index].id);
//                                                               // UserModel userModel;
//                                                               print(
//                                                                   "This document id: ${snapshot.data!.docs[index].id}");
//                                                               setState(() {
//                                                                 selectedIndexTopFriends =
//                                                                     -1;
//                                                                 selectedIndex =
//                                                                     index;
//                                                                 // selectedUserModelFromFriend
//                                                                 selectedKidId =
//                                                                     snapshot
//                                                                         .data!
//                                                                         .docs[
//                                                                             index]
//                                                                         .id;
//                                                                 selectedUserModelFromFriend = UserModel(
//                                                                     usaUserName: snapshot
//                                                                             .data!
//                                                                             .docs[index]
//                                                                         [
//                                                                         AppConstants
//                                                                             .USER_user_name],
//                                                                     usaLogo: snapshot
//                                                                             .data!
//                                                                             .docs[index]
//                                                                         [
//                                                                         AppConstants
//                                                                             .USER_Logo],
//                                                                     usaUserType:
//                                                                         snapshot
//                                                                             .data!
//                                                                             .docs[index][AppConstants.USER_UserType],
//                                                                     usaGender: snapshot.data!.docs[index][AppConstants.USER_gender],
//                                                                     usaFirstName: snapshot.data!.docs[index][AppConstants.USER_first_name],
//                                                                     usaLastName: snapshot.data!.docs[index][AppConstants.USER_last_name]);

//                                                                 selectedKidName = snapshot
//                                                                         .data!
//                                                                         .docs[index]
//                                                                     [
//                                                                     AppConstants
//                                                                         .USER_user_name];
//                                                                 selectedKidImageUrl = snapshot
//                                                                         .data!
//                                                                         .docs[index]
//                                                                     [
//                                                                     AppConstants
//                                                                         .USER_Logo];
//                                                                 receiverGender = snapshot
//                                                                         .data!
//                                                                         .docs[index]
//                                                                     [
//                                                                     AppConstants
//                                                                         .USER_gender];
//                                                                 receiverUserType = snapshot
//                                                                         .data!
//                                                                         .docs[index]
//                                                                     [
//                                                                     AppConstants
//                                                                         .USER_UserType];
//                                                               });
//                                                               // ApiServices().addMoneyToSelectedMainWallet(receivedUserId: selectedKidId, senderId: appConstants.userRegisteredId);
//                                                               // });
//                                                             },
//                                                             child: Padding(
//                                                               padding:
//                                                                   const EdgeInsets
//                                                                           .only(
//                                                                       right:
//                                                                           12.0),
//                                                               child: Column(
//                                                                 children: [
//                                                                   Container(
//                                                                     height: 70,
//                                                                     width: 70,
//                                                                     decoration: BoxDecoration(
//                                                                         shape: BoxShape
//                                                                             .circle,
//                                                                         color:
//                                                                             transparent,
//                                                                         border: Border.all(
//                                                                             width: selectedIndex == index
//                                                                                 ? 2
//                                                                                 : 0,
//                                                                             color: selectedIndex == index
//                                                                                 ? orange
//                                                                                 : transparent)),
//                                                                     child: Padding(
//                                                                         padding: const EdgeInsets.all(0.0),
//                                                                         child: userImage(
//                                                                           imageUrl: snapshot
//                                                                               .data!
//                                                                               .docs[index][AppConstants.USER_Logo],
//                                                                           userType: snapshot
//                                                                               .data!
//                                                                               .docs[index][AppConstants.USER_UserType],
//                                                                           width:
//                                                                               width,
//                                                                           gender: snapshot
//                                                                               .data!
//                                                                               .docs[index][AppConstants.USER_gender],
//                                                                         )),
//                                                                   ),
//                                                                   SizedBox(
//                                                                     height: 5,
//                                                                   ),
//                                                                   SizedBox(
//                                                                     // width: height * 0.065,
//                                                                     child:
//                                                                         Center(
//                                                                       child: Text(
//                                                                           '@ ' +
//                                                                               snapshot.data!.docs[index][AppConstants
//                                                                                   .USER_user_name],
//                                                                           overflow: TextOverflow
//                                                                               .fade,
//                                                                           maxLines:
//                                                                               1,
//                                                                           style:
//                                                                               heading4TextSmall(width)),
//                                                                     ),
//                                                                   )
//                                                                 ],
//                                                               ),
//                                                             ),
//                                                           );
//                                                   },
//                                                 );
//                                               },
//                                             ),

                                                    ////////User Friends
                                                    topFriends == null
                                                        ? const SizedBox()
                                                        : StreamBuilder<
                                                                QuerySnapshot>(
                                                            stream: topFriends,
                                                            builder: (BuildContext
                                                                    context,
                                                                AsyncSnapshot<
                                                                        QuerySnapshot>
                                                                    snapshot) {
                                                              if (snapshot
                                                                  .hasError) {
                                                                return const Text(
                                                                    'Ooops...Something went wrong :(');
                                                              }

                                                              // if (snapshot
                                                              //         .connectionState ==
                                                              //     ConnectionState
                                                              //         .waiting) {
                                                              //   return const Text("");
                                                              // }
                                                              if (!snapshot
                                                                  .hasData) {
                                                                return const Center(
                                                                  child:
                                                                      CustomLoader(),
                                                                );
                                                              }
                                                               if (snapshot.data!.size == 0) {
              return Row(
              mainAxisAlignment:
                  MainAxisAlignment.center,
              children: [
                ZakiCicularButton(
                  title: 'Sync Contacts',
                  width: width * 0.7,
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
                                                              return ListView
                                                                  .builder(
                                                                itemCount:
                                                                    snapshot
                                                                        .data!
                                                                        .docs
                                                                        .length,
                                                                physics:
                                                                    const NeverScrollableScrollPhysics(),
                                                                shrinkWrap:
                                                                    true,
                                                                scrollDirection:
                                                                    Axis.horizontal,
                                                                itemBuilder:
                                                                    (BuildContext
                                                                            context,
                                                                        int index) {
                                                                  // print(snapshot.data!.docs[index] ['USER_first_name']);
                                                                  return InkWell(
                                                                              onTap: () async {
                                                                                //
                                                                                // appConstants.updateAllowanceSchedule(snapshot.data!.docs[index]['USER_allowance_schedule']);
                                                                                // ApiServices services = ApiServices();
                                                                                // // dynamic kidData =
                                                                                // await services.fetchUserKidWithFuture(
                                                                                //     snapshot.data!.docs[index].id);
                                                                                // UserModel userModel;
                                                                                // var newSnapShot = snapshots.data as DocumentSnapshot;
                                                                                try {
                                                                                  appConstants.updateCurrentUserIdForBottomSheet(snapshot.data!.docs[index][AppConstants.USER_UserID]);
                                                                                  // logMethod(title: 'Clicked = ', message: '${snapshot.data!.docs[index][AppConstants.USER_UserID]} and id ${newSnapShot[AppConstants.USER_SubscriptionValue] ?? 'No data'}');
                                                                                  
                                                                                } catch (e) {
                                                                                  logMethod(title: 'exception', message: e.toString());
                                                                                }
                                                                                // return;

                                                                                QueryDocumentSnapshot<Map<String, dynamic>>? userData = await services.getUserDataFromPhoneNumber(id: snapshot.data!.docs[index][AppConstants.USER_UserID]);
                                                                                logMethod(title: 'Selected User Top Friend Id', message: userData!.id);
                                                                                setState(() {
                                                                                  selectedIndex = -1;
                                                                                  selectedIndexTopFriends = index;
                                                                                  // selectedUserModelFromFriend
                                                                                  selectedKidId = userData.id;
                                                                                  selectedUserModelFromFriend = UserModel(
                                                                                    usaUserName: userData[AppConstants.USER_user_name] == '' ? userData[AppConstants.USER_first_name] : '@ ${userData[AppConstants.USER_user_name]}', usaLogo: userData[AppConstants.USER_Logo], usaUserType: userData[AppConstants.USER_UserType], usaGender: userData[AppConstants.USER_gender], usaFirstName: userData[AppConstants.USER_first_name], usaLastName: userData[AppConstants.USER_last_name]);
                                                                                  selectedKidName = userData[AppConstants.USER_user_name] ?? userData[AppConstants.USER_first_name];
                                                                                  selectedKidImageUrl = userData[AppConstants.USER_Logo];
                                                                                  receiverGender = '';
                                                                                  receiverUserType = '';
                                                                                  selectedKidBankToken = userData[AppConstants.USER_BankAccountID];
                                                                                });

                                                                                // ApiServices().addMoneyToSelectedMainWallet(receivedUserId: selectedKidId, senderId: appConstants.userRegisteredId);
                                                                                // });
                                                                              },
                                                                              child: TopFriendsCustomWidget(
                                                                                selectedIndexTopFriends: selectedIndexTopFriends,
                                                                                width: width,
                                                                                index: index,
                                                                                snapshot: snapshot.data!.docs[index],
                                                                              ),
                                                                            );
                                                                  
                                                                  // StreamBuilder(
                                                                  //   stream:  ApiServices().fetchSingleUserWithStream(
                                                                  //       id: snapshot
                                                                  //           .data!
                                                                  //           .docs[index][AppConstants.USER_UserID]),
                                                                  //   builder: (BuildContext
                                                                  //           context,
                                                                  //       snapshots) {
                                                                  //     if (snapshots
                                                                  //         .hasError) {
                                                                  //       return const Text(
                                                                  //           'Ooops...Something went wrong :(');
                                                                  //     }

                                                                  //     // if (snapshots
                                                                  //     //         .connectionState ==
                                                                  //     //     ConnectionState
                                                                  //     //         .waiting) {
                                                                  //     //   return const Text("");
                                                                  //     // }
                                                                  //     // if (snapshots.data ==
                                                                  //     //     0) {}
                                                                  //     if (!snapshots
                                                                  //         .hasData) {
                                                                  //       return const Center(
                                                                  //         child:
                                                                  //             CustomLoader(),
                                                                  //       );
                                                                  //     }
                                                                  //     var newSnapShot =
                                                                  //         snapshots.data
                                                                  //             as DocumentSnapshot;
                                                                  //     // logMethod(title: 'USER ID', message: '${snapshot.data!.docs[index][AppConstants.USER_UserID]} and ${(newSnapShot[AppConstants.USER_SubscriptionValue])??}');
                                                                  //     return (
                                                                  //       // (newSnapShot[AppConstants.USER_Family_Id]??'') != appConstants.userModel.userFamilyId &&
                                                                  //             (newSnapShot[AppConstants.USER_SubscriptionValue] < 2 || newSnapShot[AppConstants.USER_SubscriptionValue] == null))
                                                                  //         ?
                                                                  //         // (checkUserValue(appConstants: appConstants, parentId: newSnapShot[AppConstants.USER_Family_Id]??'', subscriptionValue:(newSnapShot[AppConstants.USER_SubscriptionValue]==0 || newSnapShot[AppConstants.USER_SubscriptionValue]==null)?0:newSnapShot[AppConstants.USER_SubscriptionValue]))?

                                                                  //         SizedBox.shrink()
                                                                  //         : 
                                                                  //         InkWell(
                                                                  //             onTap: () async {
                                                                  //               //
                                                                  //               // appConstants.updateAllowanceSchedule(snapshot.data!.docs[index]['USER_allowance_schedule']);
                                                                  //               // ApiServices services = ApiServices();
                                                                  //               // // dynamic kidData =
                                                                  //               // await services.fetchUserKidWithFuture(
                                                                  //               //     snapshot.data!.docs[index].id);
                                                                  //               // UserModel userModel;
                                                                  //               // var newSnapShot = snapshots.data as DocumentSnapshot;
                                                                  //               try {
                                                                  //                 appConstants.updateCurrentUserIdForBottomSheet(snapshot.data!.docs[index][AppConstants.USER_UserID]);
                                                                  //                 logMethod(title: 'Clicked = ', message: '${snapshot.data!.docs[index][AppConstants.USER_UserID]} and id ${newSnapShot[AppConstants.USER_SubscriptionValue] ?? 'No data'}');
                                                                  //                 //         if(newSnapShot[AppConstants.USER_SubscriptionValue]==0 || newSnapShot[AppConstants.USER_SubscriptionValue]==null){
                                                                  //                 //         showModalBottomSheet(
                                                                  //                 //           context: context,
                                                                  //                 //           // constraints: BoxConstraints(maxHeight: 800, maxWidth: double.infinity, minHeight: 800, minWidth: double.infinity),
                                                                  //                 //           isScrollControlled: true,
                                                                  //                 //           useSafeArea: true,
                                                                  //                 //           // enableDrag: false,
                                                                  //                 //           showDragHandle: true,
                                                                  //                 //           enableDrag: true,
                                                                  //                 //           shape: RoundedRectangleBorder(
                                                                  //                 //   borderRadius: BorderRadius.only(
                                                                  //                 //     topLeft: Radius.circular(width * 0.09),
                                                                  //                 //     topRight: Radius.circular(width * 0.09),
                                                                  //                 //   ),
                                                                  //                 // ),
                                                                  //                 //           builder: (context) {
                                                                  //                 //             return Container(
                                                                  //                 //             height: height*0.8,
                                                                  //                 //               child: CreateUser(height: height*0.8));
                                                                  //                 //           },
                                                                  //                 //         );
                                                                  //                 //         return;
                                                                  //                 //       }
                                                                  //               } catch (e) {
                                                                  //                 //         print(e.toString());
                                                                  //                 //         appConstants.updateCurrentUserIdForBottomSheet(snapshot.data!.docs[index][AppConstants.USER_UserID]);
                                                                  //                 //         showModalBottomSheet(
                                                                  //                 //           context: context,
                                                                  //                 //           // constraints: BoxConstraints(maxHeight: 800, maxWidth: double.infinity, minHeight: 800, minWidth: double.infinity),
                                                                  //                 //           isScrollControlled: true,
                                                                  //                 //           useSafeArea: true,
                                                                  //                 //           // enableDrag: false,
                                                                  //                 //           showDragHandle: true,
                                                                  //                 //           enableDrag: true,
                                                                  //                 //           shape: RoundedRectangleBorder(
                                                                  //                 //   borderRadius: BorderRadius.only(
                                                                  //                 //     topLeft: Radius.circular(width * 0.09),
                                                                  //                 //     topRight: Radius.circular(width * 0.09),
                                                                  //                 //   ),
                                                                  //                 // ),
                                                                  //                 //           builder: (context) {
                                                                  //                 //             return Container(
                                                                  //                 //             height: height*0.8,
                                                                  //                 //               child: CreateUser(height: height*0.8));
                                                                  //                 //           },
                                                                  //                 //         );
                                                                  //                 //         return;
                                                                  //               }
                                                                  //               // return;

                                                                  //               QueryDocumentSnapshot<Map<String, dynamic>>? userData = await services.getUserDataFromPhoneNumber(id: snapshot.data!.docs[index][AppConstants.USER_UserID]);
                                                                  //               logMethod(title: 'Selected User Top Friend Id', message: userData!.id);
                                                                  //               setState(() {
                                                                  //                 selectedIndex = -1;
                                                                  //                 selectedIndexTopFriends = index;
                                                                  //                 // selectedUserModelFromFriend
                                                                  //                 selectedKidId = userData.id;
                                                                  //                 selectedUserModelFromFriend = UserModel(usaUserName: userData[AppConstants.USER_user_name] == '' ? userData[AppConstants.USER_first_name] : userData[AppConstants.USER_user_name], usaLogo: userData[AppConstants.USER_Logo], usaUserType: userData[AppConstants.USER_UserType], usaGender: userData[AppConstants.USER_gender], usaFirstName: userData[AppConstants.USER_first_name], usaLastName: userData[AppConstants.USER_last_name]);
                                                                  //                 selectedKidName = userData[AppConstants.USER_user_name] ?? userData[AppConstants.USER_first_name];
                                                                  //                 selectedKidImageUrl = userData[AppConstants.USER_Logo];
                                                                  //                 receiverGender = '';
                                                                  //                 receiverUserType = '';
                                                                  //                 selectedKidBankToken = userData[AppConstants.USER_BankAccountID];
                                                                  //               });

                                                                  //               // ApiServices().addMoneyToSelectedMainWallet(receivedUserId: selectedKidId, senderId: appConstants.userRegisteredId);
                                                                  //               // });
                                                                  //             },
                                                                  //             child: TopFriendsCustomWidget(
                                                                  //               selectedIndexTopFriends: selectedIndexTopFriends,
                                                                  //               width: width,
                                                                  //               index: index,
                                                                  //               snapshot: snapshot.data!.docs[index],
                                                                  //             ),
                                                                  //           );
                                                                  //   },
                                                                  // );
                                                                
                                                                },
                                                              );
                                                            })
                                                  ],
                                                ),
                                              ),
                                            ),
                                      selectedUserModelFromFriend != null
                                          ? Column(
                                              children: [
                                                textValueBelow,
                                                Stack(
                                                  clipBehavior: Clip.none,
                                                  children: [
                                                    Container(
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      width *
                                                                          0.1),
                                                          border: Border.all(
                                                              color: green)),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 6.0,
                                                                vertical: 4.0),
                                                        child: Text(
                                                          '${selectedUserModelFromFriend!.usaUserName}',
                                                          style:
                                                              heading4TextSmall(
                                                                  width),
                                                        ),
                                                      ),
                                                    ),
                                                    Positioned(
                                                        top: -8,
                                                        right: -8,
                                                        child: InkWell(
                                                          onTap: () {
                                                            setState(() {
                                                              selectedUserModelFromFriend =
                                                                  null;
                                                              selectedKidId =
                                                                  '';
                                                              selectedKidName =
                                                                  '';
                                                              selectedKidImageUrl =
                                                                  '';
                                                              selectedIndex =
                                                                  -1;
                                                              selectedIndexTopFriends =
                                                                  -1;
                                                              receiverGender =
                                                                  '';
                                                              receiverUserType =
                                                                  '';
                                                            });
                                                          },
                                                          child: Container(
                                                            decoration: BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                color: white,
                                                                border: Border.all(
                                                                    color:
                                                                        grey)),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(3.0),
                                                              child: InkWell(
                                                                onTap: () {
                                                                  setState(() {
                                                                    selectedUserModelFromFriend =
                                                                        null;
                                                                    selectedKidId =
                                                                        '';
                                                                    selectedKidName =
                                                                        '';
                                                                    selectedKidImageUrl =
                                                                        '';
                                                                    selectedIndex =
                                                                        -1;
                                                                    selectedIndexTopFriends =
                                                                        -1;
                                                                    receiverGender =
                                                                        '';
                                                                    receiverUserType =
                                                                        '';
                                                                  });
                                                                },
                                                                child: Icon(
                                                                  Icons.clear,
                                                                  color: grey,
                                                                  size: 10,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ))
                                                  ],
                                                ),
                                              ],
                                            )
                                          :
                                          // : (appConstants.userModel.usaUserType ==
                                          //             AppConstants.USER_TYPE_KID ||
                                          //         appConstants.userModel.usaUserType ==
                                          //             AppConstants.USER_TYPE_ADULT)
                                          //     ? const SizedBox.shrink()
                                          //     :
                                          InkWell(
                                              onTap: () async {
                                                UserModel? user =
                                                    await Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                SearchFriends()));
                                                if (user != null) {
                                                  logMethod(
                                                      title: 'Selected User',
                                                      message:
                                                          user.usaUserName);
                                                  selectedUserModelFromFriend =
                                                      user;
                                                  selectedKidId =
                                                      user.usaUserId.toString();
                                                  selectedKidName = user
                                                      .usaFirstName
                                                      .toString();
                                                  selectedKidImageUrl =
                                                      user.usaLogo.toString();
                                                  receiverGender =
                                                      user.usaGender.toString();
                                                  receiverUserType = user
                                                      .usaUserType
                                                      .toString();
                                                  setState(() {});
                                                }
                                              },
                                              child: Container(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    spacing_medium,
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 4.0),
                                                      child: Row(
                                                        children: [
                                                          Icon(
                                                            Icons.search,
                                                          ),
                                                          SizedBox(
                                                            width: 5,
                                                          ),
                                                          Text(
                                                            selectedKidId == ''
                                                                ? 'Search'
                                                                : selectedKidName,
                                                            style:
                                                                heading2TextStyle(
                                                                    context,
                                                                    width),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    CustomDivider(),
                                                  ],
                                                ),
                                              ),
                                            ),
                                      // (appConstants.userModel.usaUserType == AppConstants.USER_TYPE_KID || appConstants.userModel.usaUserType == AppConstants.USER_TYPE_ADULT) ? const SizedBox.shrink():
                                      spacing_large,
                                      Text(
                                        'Make it Fun',
                                        style:
                                            heading1TextStyle(context, width),
                                      ),
                                      Text(
                                        'Select or upload an image',
                                        style: heading4TextSmall(width),
                                      ),
                                      spacing_medium,
                                      SizedBox(
                                        height: height * 0.1,
                                        width: width,
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          physics:
                                              const BouncingScrollPhysics(),
                                          child: Row(
                                            children: [
                                              ImageSelector(
                                                  icon: Icons.camera_alt,
                                                  onTap: () async {
                                                    // Pick an image
                                                    final XFile? image =
                                                        await _picker.pickImage(
                                                            maxWidth: 500,
                                                            maxHeight: 600,
                                                            imageQuality: 80,
                                                            source: ImageSource
                                                                .camera);
                                                    if (image != null) {
                                                      setState(() {
                                                        imageList.add(
                                                            ImageModel(
                                                                id: 6,
                                                                imageName: image
                                                                    .path));
                                                        imageUrl = imageList
                                                            .last.imageName!;
                                                      });
                                                    }
                                                  }),
                                              SizedBox(width: 6),
                                              ImageSelector(
                                                  icon: Icons.image,
                                                  onTap: () async {
                                                    // Pick an image
                                                    final XFile? image =
                                                        await _picker.pickImage(
                                                            maxWidth: 500,
                                                            maxHeight: 600,
                                                            imageQuality: 80,
                                                            source: ImageSource
                                                                .gallery);
                                                    if (image != null) {
                                                      setState(() {
                                                        imageList.add(
                                                            ImageModel(
                                                                id: 7,
                                                                imageName: image
                                                                    .path));
                                                        imageUrl = imageList
                                                            .last.imageName!;
                                                      });
                                                    }
                                                  }),
                                              ListView.builder(
                                                  itemCount: imageList.length,
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  shrinkWrap: true,
                                                  physics:
                                                      const BouncingScrollPhysics(),
                                                  itemBuilder:
                                                      (context, index) {
                                                    return Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              4.0),
                                                      child: InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            imageUrl =
                                                                imageList[index]
                                                                    .imageName!;
                                                          });
                                                          print(
                                                              'Name is: ${imageList[index].imageName}');
                                                        },
                                                        child: Container(
                                                          height: height * 0.13,
                                                          width: width * 0.25,
                                                          decoration:
                                                              BoxDecoration(
                                                            // shape: BoxShape.circle,
                                                            color: Colors.grey
                                                                .withOpacity(
                                                                    0.005),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        width *
                                                                            0.03),
                                                            border: Border.all(
                                                                color: grey
                                                                    .withOpacity(
                                                                        0.005)),
                                                          ),
                                                          child: imageList[index]
                                                                  .imageName!
                                                                  .contains(
                                                                      'com.zakipay.teencard')
                                                              ? Container(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    // shape: BoxShape.circle,
                                                                    border: Border.all(
                                                                        color: grey
                                                                            .withOpacity(0.5)),
                                                                    borderRadius:
                                                                        BorderRadius.circular(width *
                                                                            0.03),
                                                                  ),
                                                                  child: Image
                                                                      .file(
                                                                    File(imageList[
                                                                            index]
                                                                        .imageName!),
                                                                    // height: 150,
                                                                    // width: double.infinity,
                                                                    // fit: BoxFit.fill,
                                                                  ),
                                                                )
                                                              : Container(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    // shape: BoxShape.circle,
                                                                    border: Border.all(
                                                                        color: grey
                                                                            .withOpacity(0.5)),
                                                                    borderRadius:
                                                                        BorderRadius.circular(width *
                                                                            0.03),
                                                                  ),
                                                                  child: Image.asset(
                                                                      imageList[
                                                                              index]
                                                                          .imageName!)),
                                                        ),
                                                      ),
                                                    );
                                                  }),
                                            ],
                                          ),
                                        ),
                                      ),
                                      spacing_medium,
                                      Container(
                                        width: double.infinity,
                                        height: height * 0.24,
                                        decoration: BoxDecoration(
                                          // shape: BoxShape.circle,
                                          border: Border.all(
                                              color: grey.withOpacity(0.25)),
                                          borderRadius: BorderRadius.circular(
                                              width * 0.03),
                                        ),
                                        child: Stack(
                                          fit: StackFit.expand,
                                          children: [
                                            imageUrl == '1'
                                                ? Image.asset(
                                                    imageBaseAddress +
                                                        'image_upload.png',
                                                    // height: height*0.2,
                                                    // width: width,
                                                    fit: BoxFit.contain,
                                                  )
                                                : imageUrl.contains(
                                                        'com.zakipay.teencard')
                                                    ? Image.file(
                                                        File(imageUrl),
                                                        fit: BoxFit.contain,
                                                        // height: 150,
                                                        // width: double.infinity,
                                                        // fit: BoxFit.fill,
                                                      )
                                                    : Image.asset(
                                                        imageUrl,
                                                        fit: BoxFit.contain,
                                                      ),
                                            // Positioned(
                                            //     right: 5,
                                            //     top: 5,
                                            //     child: IconButton(
                                            //       icon: Icon(
                                            //         Icons.camera_alt,
                                            //         color: grey,
                                            //       ),
                                            //       onPressed: () async {
                                            //         // Pick an image
                                            //         final XFile? image =
                                            //             await _picker.pickImage(
                                            //                 maxWidth: 500,
                                            //                 maxHeight: 600,
                                            //                 imageQuality: 80,
                                            //                 source: ImageSource.gallery);
                                            //         if (image != null) {
                                            //           setState(() {
                                            //             imageList.add(ImageModel(
                                            //                 id: 6, imageName: image.path));
                                            //           });
                                            //         }
                                            //       },
                                            //     )
                                            //     )
                                          ],
                                        ),
                                      ),
                                      spacing_large,
                                      Row(
                                        children: [
                                          Text(
                                            'Message',
                                            style: heading1TextStyle(
                                                context, width),
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            '(optional)',
                                            style: heading3TextStyle(width),
                                          ),
                                        ],
                                      ),

                                      TextFormField(
                                        style:
                                            heading3TextStyle(width, font: 14),
                                        controller: messageController,
                                        obscureText: false,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        maxLines: null,
                                        maxLength: 140,
                                        decoration: InputDecoration(
                                          // counterText: '',
                                          isDense: true,
                                          hintText: 'Add a Note...Make it Fun!',
                                          hintStyle: heading3TextStyle(width,
                                              font: 14),
                                          // enabledBorder: UnderlineInputBorder( //<-- SEE HERE
                                          //   borderSide: BorderSide(
                                          //       width: 1, color: green),
                                          // ),
                                          focusedBorder: UnderlineInputBorder(
                                            //<-- SEE HERE
                                            borderSide: BorderSide(
                                                width: 1, color: green),
                                          ),
                                          // suffix: Text(
                                          //   '${messageController.text.length} / 400 words',
                                          //   style: heading4TextSmall(width),
                                          //   ),
                                          // suffixText: ,
                                          // suffixStyle: heading4TextSmall(width)
                                          // labelText: 'Enter Email',

                                          // labelStyle: textStyleHeading2WithTheme(context,width*0.8, whiteColor: 0),
                                        ),
                                      ),
                                      spacing_medium,
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    emojiShowing =
                                                        !emojiShowing;
                                                  });
                                                },
                                                child: Icon(
                                                  emojiShowing
                                                      ? Icons.emoji_emotions
                                                      : Icons
                                                          .emoji_emotions_outlined,
                                                  color: green,
                                                ),
                                              )
                                            ],
                                          ),
                                          InkWell(
                                            onTap: () {
                                              privacyBottomSheet(
                                                  context: context,
                                                  height: height,
                                                  width: width);
                                            },
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Image.asset(
                                                  appConstants.selectedPrivacyType ==
                                                          1
                                                      ? imageBaseAddress +
                                                          'public.png'
                                                      : appConstants
                                                                  .selectedPrivacyType ==
                                                              2
                                                          ? imageBaseAddress +
                                                              'friends.png'
                                                          : appConstants
                                                                      .selectedPrivacyType ==
                                                                  3
                                                              ? imageBaseAddress +
                                                                  'family.png'
                                                              : appConstants
                                                                          .selectedPrivacyType ==
                                                                      4
                                                                  ? imageBaseAddress +
                                                                      'you_me.png'
                                                                  : imageBaseAddress +
                                                                      'you_me.png',
                                                  height: 30,
                                                  width: 20,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 4.0),
                                                  child: Text(
                                                      appConstants.selectedPrivacyType ==
                                                              1
                                                          ? 'Public'
                                                          : appConstants
                                                                      .selectedPrivacyType ==
                                                                  2
                                                              ? 'Friends'
                                                              : appConstants
                                                                          .selectedPrivacyType ==
                                                                      3
                                                                  ? 'Family'
                                                                  : 'You & Me',
                                                      style: heading3TextStyle(
                                                          width)),
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                      spacing_large,
                                      //////////////Emojei Settings
                                      Offstage(
                                        offstage: !emojiShowing,
                                        child: SizedBox(
                                          height: 250,
                                          child: EmojiPicker(
                                              onEmojiSelected:
                                                  (Category? category,
                                                      Emoji? emoji) {
                                                _onEmojiSelected(emoji!);
                                              },
                                              onBackspacePressed:
                                                  _onBackspacePressed,
                                              config: Config(

                                                  // columns: 7,
                                                  // // Issue: https://github.com/flutter/flutter/issues/28894
                                                  // emojiSizeMax: 32 *
                                                  //     (Platform.isIOS
                                                  //         ? 1.30
                                                  //         : 1.0),
                                                  // verticalSpacing: 0,
                                                  // horizontalSpacing: 0,
                                                  // initCategory: Category.RECENT,
                                                  // bgColor:
                                                  //     const Color(0xFFF2F2F2),
                                                  // indicatorColor: Colors.blue,
                                                  // iconColor: Colors.grey,
                                                  // iconColorSelected:
                                                  //     Colors.blue,
                                                  // // progressIndicatorColor: Colors.blue,
                                                  // backspaceColor: Colors.blue,
                                                  // skinToneDialogBgColor:
                                                  //     Colors.white,
                                                  // skinToneIndicatorColor:
                                                  //     Colors.grey,
                                                  // enableSkinTones: true,
                                                  // // showRecentsTab: true,
                                                  // recentsLimit: 28,
                                                  // // noRecentsText: 'No Recents',
                                                  // // noRecentsStyle: const TextStyle(
                                                  // //     fontSize: 20, color: Colors.black26),
                                                  // tabIndicatorAnimDuration:
                                                  //     kTabScrollDuration,
                                                  // categoryIcons:
                                                  //     const CategoryIcons(),
                                                  // buttonMode:
                                                  //     ButtonMode.MATERIAL
                                                      )),
                                        ),
                                      ),
                                      /////////
                                      Text('Tag-It',
                                          style: heading1TextStyle(
                                              context, width)),
                                      spacing_medium,
                                      SizedBox(
                                        height: height * 0.1,
                                        child: ListView.builder(
                                          itemCount:
                                              AppConstants.tagItList.length,
                                          physics:
                                              const BouncingScrollPhysics(),
                                          shrinkWrap: true,
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return AppConstants.tagItList[index]
                                                        .publicTag_it ==
                                                    false
                                                ? SizedBox.shrink()
                                                :
                                                // index==4? IconButton(onPressed: (){}, icon: Icon(Icons.arrow_drop_down, size: width*0.1,)) :
                                                Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 4.0),
                                                    child: InkWell(
                                                      onTap: () async {
                                                        setState(() {
                                                          selectedAllocation =
                                                              index;
                                                          // selectedKidIcon =
                                                        });
                                                        Map<String, dynamic>?
                                                            data =
                                                            await ApiServices()
                                                                .getKidSpendingLimit(
                                                                    appConstants
                                                                        .userModel
                                                                        .userFamilyId!,
                                                                    appConstants
                                                                        .userRegisteredId);
                                                        if (data != null) {
                                                          showNotification(
                                                              icon: AppConstants
                                                                  .tagItList[
                                                                      selectedAllocation]
                                                                  .icon,
                                                              error: 0,
                                                              message: AppConstants
                                                                  .tagItList[
                                                                      selectedAllocation]
                                                                  .title
                                                                  .toString());

                                                          logMethod(
                                                              title:
                                                                  'Spend Limit::::>>>',
                                                              message:
                                                                  'Remaining Transaction amount:>> ${data[AppConstants.SpendL_Transaction_Amount_Remain]}, Selected Tag it remaing: ${data}');
                                                        }
                                                      },
                                                      child: Column(
                                                        children: [
                                                          Container(
                                                              height:
                                                                  height * 0.07,
                                                              width:
                                                                  height * 0.07,
                                                              decoration: BoxDecoration(
                                                                  shape: BoxShape
                                                                      .circle,
                                                                  border: Border.all(
                                                                      color: selectedAllocation ==
                                                                              index
                                                                          ? green
                                                                          : grey)),
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        12.0),
                                                                child: Icon(
                                                                    AppConstants
                                                                        .tagItList[
                                                                            index]
                                                                        .icon,
                                                                    color: selectedAllocation ==
                                                                            index
                                                                        ? green
                                                                        : grey,
                                                                    size: width *
                                                                        0.06),
                                                              )),
                                                          if (selectedAllocation ==
                                                              index)
                                                            Text(
                                                              '${AppConstants.tagItList[index].title}',
                                                              style: heading3TextStyle(
                                                                  width,
                                                                  color:
                                                                      lightGrey,
                                                                  font: 10),
                                                            )
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                          },
                                        ),
                                      ),
                                      spacing_medium
                                    ],
                                  ),
                                  //               if(viewScreen)
                                  // CustomBluredScreen()
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  spacing_medium,
                  Padding(
                    padding: getCustomPadding(),
                    child: Column(
                      children: [
                        Center(child: SSLCustomRow()),
                        spacing_small,
                        Row(
                          children: [
                            Expanded(
                                // flex: 5,
                                child: ZakiPrimaryButton(
                              title: 'Request',
                              width: width * 0.7,
                              backgroundTransparent: 1,
                              borderColor: (amountController.text.isEmpty ||
                                      selectedKidId == '' ||
                                      (int.parse(amountController.text) >
                                          500) ||
                                      appConstants.isLoading || selectedAllocation==-2)
                                  ? grey.withOpacity(0.6)
                                  : green,
                              textColor: (amountController.text.isEmpty ||
                                      selectedKidId == '' || selectedAllocation==-2 ||
                                      (int.parse(amountController.text) > 500))
                                  ? white
                                  : green,
                              onPressed:
                              //  amountController.text.isEmpty
                              //     ? null
                              //     : internet.status ==
                              //             AppConstants
                              //                 .INTERNET_STATUS_NOT_CONNECTED
                              //         ? null
                              //         : (selectedKidId == '' || selectedAllocation==-2)
                              //             ? null
                              //             : ((int.parse(amountController.text) >
                              //                         500) ||
                              //                     appConstants.isLoading)
                              //                 ? null
                              //                 : 
                                         canPressButton(appConstants: appConstants, internetStatus: internet.status)==false?null: () async {
                                                bool? checkAuth = await authenticateTransactionUsingBioOrPinCode(appConstants: appConstants, context: context);
                                                  if(checkAuth==false){
                                                    return;
                                                  }
                                                  appConstants
                                                      .updateLoading(true);
                                                  ApiServices services =
                                                      ApiServices();
                                                  CustomProgressDialog
                                                      progressDialog =
                                                      CustomProgressDialog(
                                                          context,
                                                          blur: 10);
                                                  progressDialog
                                                      .setLoadingWidget(
                                                          CustomLoadingScreen());
                                                  progressDialog.show();

                                                  if (imageUrl.contains(
                                                      'com.zakipay.teencard')) {
                                                    String? pathImage =
                                                        await services
                                                            .uploadImage(
                                                                path: imageUrl
                                                                , userId: appConstants.userRegisteredId
                                                                
                                                                );
                                                    showNotification(
                                                        error: 0,
                                                        icon: Icons.check,
                                                        message: pathImage);

                                                    /// Current User
                                                    /// We need id for this so we can delete that request
                                                    String? id = await services
                                                        .requestMoney(
                                                      selectedKidName:
                                                          '${appConstants.userModel.usaUserName}',
                                                      senderImageUrl:
                                                          selectedKidImageUrl,
                                                      selectedKidImageUrl:
                                                          appConstants.userModel
                                                              .usaLogo,
                                                      requestType: 'Request',
                                                      privacy: appConstants
                                                          .selectedPrivacyType,
                                                      accountHolderName:
                                                          selectedKidName,
                                                      message: messageController
                                                          .text,
                                                      accountType: '',
                                                      tagItId:
                                                          selectedAllocation
                                                              .toString(),
                                                      tagItName: AppConstants
                                                          .tagItList[
                                                              selectedAllocation]
                                                          .title,
                                                      amount:
                                                          amountController.text,
                                                      imageUrl: pathImage,
                                                      toUserId: appConstants
                                                          .userRegisteredId,
                                                      currentUserId:
                                                          appConstants
                                                              .userRegisteredId,
                                                    );

                                                    await services.requestMoney(
                                                      selectedKidName:
                                                          selectedKidName,
                                                      selectedKidImageUrl:
                                                          selectedKidImageUrl,
                                                      senderImageUrl:
                                                          appConstants.userModel
                                                              .usaLogo,
                                                      requestType: 'Request',
                                                      privacy: appConstants
                                                          .selectedPrivacyType,
                                                      accountHolderName:
                                                          '${appConstants.userModel.usaUserName}',
                                                      message: messageController
                                                          .text,
                                                      accountType: '',
                                                      tagItId:
                                                          selectedAllocation
                                                              .toString(),
                                                      tagItName: AppConstants
                                                          .tagItList[
                                                              selectedAllocation]
                                                          .title,
                                                      amount:
                                                          amountController.text,
                                                      imageUrl: pathImage,
                                                      toUserId: selectedKidId,
                                                      currentUserId:
                                                          appConstants
                                                              .userRegisteredId,
                                                      requestDocumentId: id,
                                                    );
                                                  } else {
                                                    /// Current User
                                                    /// We need id for this so we can delete that request
                                                    String? id = await services
                                                        .requestMoney(
                                                      selectedKidName:
                                                          '${appConstants.userModel.usaUserName}',
                                                      senderImageUrl:
                                                          selectedKidImageUrl,
                                                      selectedKidImageUrl:
                                                          appConstants.userModel
                                                              .usaLogo,
                                                      requestType: 'Request',
                                                      privacy: appConstants
                                                          .selectedPrivacyType,
                                                      accountHolderName:
                                                          selectedKidName,
                                                      message: messageController
                                                          .text,
                                                      accountType: '',
                                                      tagItId:
                                                          selectedAllocation
                                                              .toString(),
                                                      tagItName: AppConstants
                                                          .tagItList[
                                                              selectedAllocation]
                                                          .title,
                                                      amount:
                                                          amountController.text,
                                                      imageUrl: imageUrl,
                                                      toUserId: appConstants
                                                          .userRegisteredId,
                                                      currentUserId:
                                                          appConstants
                                                              .userRegisteredId,
                                                    );

                                                    await services.requestMoney(
                                                      requestType: 'Request',
                                                      senderImageUrl:
                                                          appConstants.userModel
                                                              .usaLogo,
                                                      selectedKidName:
                                                          selectedKidName,
                                                      selectedKidImageUrl:
                                                          selectedKidImageUrl,
                                                      privacy: appConstants
                                                          .selectedPrivacyType,
                                                      accountHolderName:
                                                          '${appConstants.userModel.usaUserName}',
                                                      message: messageController
                                                          .text,
                                                      accountType: '',
                                                      tagItId:
                                                          selectedAllocation
                                                              .toString(),
                                                      tagItName: AppConstants
                                                          .tagItList[
                                                              selectedAllocation]
                                                          .title,
                                                      amount:
                                                          amountController.text,
                                                      imageUrl: imageUrl,
                                                      toUserId: selectedKidId,
                                                      currentUserId:
                                                          appConstants
                                                              .userRegisteredId,
                                                      requestDocumentId: id,
                                                    );
                                                  }
                                                  showNotification(
                                                      error: 0,
                                                      icon: Icons.check,
                                                      message: NotificationText
                                                          .REQUEST_SEND);
                                                  progressDialog.dismiss();
                                                  // String? userToken =
                                                  await services
                                                      .getUserTokenAndSendNotification(
                                                          userId: selectedKidId,
                                                          title: '${NotificationText.REQUEST_NOTIFICATION_TITLE} ${appConstants.userModel.usaUserName}',
                                                          subTitle: ' ${NotificationText.REQUEST_NOTIFICATION_SUB_TITLE} ${getCurrencySymbol(context, appConstants: appConstants)} ${amountController.text}',
                                                          // checkParent: true,
                                                          // parentTitle: '${appConstants.userModel.usaUserName} sent ${getCurrencySymbol(context, appConstants: appConstants)} ${amountController.text}',
                                                          // parentSubtitle: 'See Details in ZakiPay'
                                                        );
                                                  // if(userToken!=null)
                                                  // await services.sendNotification(
                                                  //   title: AppConstants.REQUEST_NOTIFICATION_TITLE,
                                                  //   body: AppConstants.,
                                                  //   token: userToken
                                                  // );
                                                  appConstants
                                                      .updateLoading(false);
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              CustomConfermationScreen(
                                                                title:
                                                                    'Mission Accomplished!',
                                                                subTitle:
                                                                    "${getCurrencySymbol(context, appConstants: appConstants)} ${amountController.text} Requst has been sent",
                                                                imageUrl:
                                                                    selectedKidImageUrl,
                                                               )));
                                                },

                              // backgroundTransparent: ,
                            )),
                            const SizedBox(
                              width: 10,
                            ),
                            // internet.status==''?
                            // SizedBox():
                            Expanded(
                                // flex: 5,
                                child: ZakiPrimaryButton(
                              onPressed: canPressButton(appConstants: appConstants, internetStatus: internet.status)==false?null: () async {
                                                  if (appConstants .personalizationSettingModel != null && 
                                                      appConstants.personalizationSettingModel!.kidPKid2PayFriends == false) {
                                                    showNotification(
                                                        error: 1,
                                                        icon: Icons.error,
                                                        message: NotificationText
                                                            .PAYMENT_LOCKED);
                                                    return;
                                                  }
                                                bool? checkAuth = await authenticateTransactionUsingBioOrPinCode(appConstants: appConstants, context: context);
                                                  if(checkAuth==false){
                                                    return;
                                                  }
                                                  Position userLocation =await UserLocation().determinePosition();

                                                  var uuid = Uuid();
                                                  String transactionId =
                                                      uuid.v1();
                                                  // logMethod(
                                                  //     title:
                                                  //         'Transaction From UUid',
                                                  //     message: transactionId);
                                                  // return;
                                                  if (appConstants.testMode !=
                                                      false) {
                                                    CreaditCardApi
                                                        creaditCardApi =
                                                        CreaditCardApi();
                                                    BalanceModel? balanceModel =
                                                        await creaditCardApi
                                                            .checkBalance(
                                                                userToken:
                                                                    appConstants
                                                                        .userModel
                                                                        .userTokenId);
                                                    if (balanceModel!.gpa
                                                            .availableBalance <
                                                        int.parse(
                                                            amountController
                                                                .text
                                                                .toString())) {
                                                      setState(() {
                                                        error =
                                                            'Not enough money :(  add funds to your wallet first';
                                                      });
                                                      showNotification(
                                                          error: 1,
                                                          icon: Icons.error,
                                                          message: NotificationText
                                                              .NOT_ENOUGH_BALANCE);
                                                      return;
                                                    } else {
                                                      Map<String, dynamic>?
                                                          data =
                                                          await ApiServices()
                                                              .getKidSpendingLimit(
                                                                  appConstants
                                                                      .userModel
                                                                      .userFamilyId
                                                                      .toString(),
                                                                  appConstants
                                                                      .userRegisteredId);
                                                      // if () {
                                                      //   return;
                                                      // }
                                                      if (data != null &&
                                                          int.parse(
                                                                  amountController
                                                                      .text
                                                                      .trim()) >
                                                              data[AppConstants
                                                                  .SpendL_Transaction_Amount_Max]) {
                                                        showNotification(
                                                            error: 1,
                                                            icon: Icons.error,
                                                            message:
                                                                NotificationText
                                                                    .LIMIT_REACHED);

                                                        setState(() {
                                                          error =
                                                              NotificationText
                                                                  .LIMIT_REACHED;
                                                        });
                                                        return;
                                                      }

                                                      await creaditCardApi
                                                          .moveMoney(
                                                              amount: amountController
                                                                  .text
                                                                  .trim(),
                                                              name: appConstants
                                                                  .userModel
                                                                  .usaFirstName,
                                                              senderUserToken:
                                                                  appConstants
                                                                      .userModel
                                                                      .userTokenId,
                                                              receiverUserToken:
                                                                  selectedKidBankToken,
                                                              // memo: createMemo(
                                                              //   fromWallet:
                                                              //       AppConstants
                                                              //           .Spend_Wallet,
                                                              //   toWallet:
                                                              //       AppConstants
                                                              //           .Spend_Wallet,
                                                              //   // transactionMethod:AppConstants.Transaction_Method_Received,
                                                              //   // tagItId: selectedAllocation.toString(),
                                                              //   // tagItName: AppConstants.tagItList[selectedAllocation].title,
                                                              //   // goalId: '',
                                                              //   // transactionType: AppConstants.TAG_IT_Transaction_TYPE_SEND_OR_REQUEST
                                                              // ),
                                                              tags: createMemo(
                                                                fromWallet: AppConstants.Spend_Wallet,
                                                                toWallet: AppConstants.Spend_Wallet,
                                                                transactionMethod: AppConstants
                                                                    .Transaction_Method_Received,
                                                                 tagItId: selectedAllocation
                                                                      .toString(),
                                                                  tagItName: AppConstants
                                                                      .tagItList[
                                                                          selectedAllocation]
                                                                      .title,
                                                                  goalId: '',
                                                                  transactionType:
                                                                      AppConstants
                                                                          .TAG_IT_Transaction_TYPE_SEND_OR_REQUEST,
                                                                  receiverId:
                                                                      selectedKidId,
                                                                  senderId:
                                                                      appConstants.userRegisteredId,
                                                                  transactionId: transactionId,
                                                                  latLng: '${userLocation.latitude},${userLocation.longitude}'
                                                                // transactionId: transaction
                                                              )
                                                              // tags: createMemo(
                                                              //     fromWallet: AppConstants
                                                              //         .Spend_Wallet,
                                                              //     toWallet: AppConstants
                                                              //         .Spend_Wallet,
                                                              //     transactionMethod:
                                                              //         AppConstants
                                                              //             .Transaction_Method_Received,
                                                              //     tagItId: selectedAllocation
                                                              //         .toString(),
                                                              //     tagItName: AppConstants
                                                              //         .tagItList[
                                                              //             selectedAllocation]
                                                              //         .title,
                                                              //     goalId: '',
                                                              //     transactionType:
                                                              //         AppConstants
                                                              //             .TAG_IT_Transaction_TYPE_SEND_OR_REQUEST,
                                                              //     receiverId:
                                                              //         selectedKidId,
                                                              //     senderId:
                                                              //         appConstants.userRegisteredId,
                                                              //     transactionId: transactionId
                                                              //     // transactionId: transaction
                                                              //     )
                                                                  );
                                                      // showNotification(
                                                      //     error: 0,
                                                      //     icon: Icons.balance,
                                                      //     message: NotificationText
                                                      //         .NOT_ENOUGH_BALANCE);
                                                    }
                                                  }
                                                  // setState(() {
                                                  //   loading = true;
                                                  // });
                                                  // return;
                                                  ApiServices services =
                                                      ApiServices();

                                                  CustomProgressDialog
                                                      progressDialog =
                                                      CustomProgressDialog(
                                                          context,
                                                          blur: 6);
                                                  progressDialog
                                                      .setLoadingWidget(
                                                          CustomLoadingScreen());
                                                  progressDialog.show();
                                                  ///////Checkbalance first in to Spend Wallet
                                                  bool? hasBalance = await services
                                                      .checkWalletHasAmount(
                                                          amount: double.parse(
                                                              amountController
                                                                  .text
                                                                  .trim()),
                                                          userId: appConstants
                                                              .userRegisteredId,
                                                          fromWalletName:
                                                              AppConstants
                                                                  .Spend_Wallet);
                                                  if (hasBalance == true) {
                                                    progressDialog.dismiss();
                                                    setState(() {
                                                      error =
                                                          'Not enough money :(  add funds to your wallet first';
                                                    });
                                                    showNotification(
                                                        error: 1,
                                                        icon: Icons.error,
                                                        message: NotificationText
                                                            .NOT_ENOUGH_BALANCE);
                                                    return;
                                                  }
                                                  // dynamic cardExist =
                                                  //     await services.checkCardExist(
                                                  //         parentId: appConstants
                                                  //             .userModel
                                                  //             .userFamilyId!,
                                                  //         id: appConstants
                                                  //             .userRegisteredId);
                                                  // if (cardExist == false) {
                                                  // } else {
                                                  //   if (appConstants.testMode !=
                                                  //       false){ 
                                                  //     // CreaditCardApi()
                                                  //     //     .addAmountFromCardToBank(
                                                  //     //         amount:
                                                  //     //             amountController
                                                  //     //                 .text
                                                  //     //                 .trim(),
                                                  //     //         name: appConstants
                                                  //     //             .userName,
                                                  //     //         userToken: cardExist[
                                                  //     //             AppConstants
                                                  //     //                 .ICard_User_Token]);
                                                  //       }
                                                  // }
                                                  // return;
                                                  appConstants
                                                      .updateLoading(true);

                                                  PayRequestModel model = PayRequestModel(
                                                      isFromReview: false,
                                                      senderImageUrl:
                                                          appConstants.userModel
                                                              .usaLogo,
                                                      receiverGender:
                                                          receiverGender,
                                                      selectedKidName:
                                                          selectedKidName,
                                                      receiverUserType:
                                                          receiverUserType,
                                                      selectedKidImageUrl:
                                                          selectedKidImageUrl,
                                                      accountHolderName:
                                                          appConstants.userModel
                                                              .usaFirstName,
                                                      accountType: '',
                                                      tagItId:
                                                          selectedAllocation
                                                              .toString(),
                                                      tagItName: AppConstants
                                                          .tagItList[
                                                              selectedAllocation]
                                                          .title,
                                                      amount:
                                                          amountController.text,
                                                      fromUserId: appConstants
                                                          .userRegisteredId,
                                                      imageUrl: imageUrl,
                                                      message: messageController
                                                          .text,
                                                      requestType: AppConstants
                                                          .TAG_IT_Transaction_TYPE_SEND_OR_REQUEST,
                                                      toUserId: selectedKidId);
                                                  appConstants
                                                      .updatePayRequestModel(
                                                          model);

                                                  ////////////// This is for Privacy Selection

                                                  if (appConstants
                                                          .selectedPrivacyType ==
                                                      2) {
                                                    //This is Friend
                                                    List<String> friendsList =
                                                        await services
                                                            .getUserFriendsList(
                                                                appConstants
                                                                    .userRegisteredId);
                                                    List<String>
                                                        selectedKidFriend =
                                                        await services
                                                            .getUserFriendsList(
                                                                selectedKidId);
                                                    userInvitedList =
                                                        friendsList +
                                                            [
                                                              appConstants
                                                                  .userRegisteredId
                                                            ];
                                                    userInvitedList.addAll(
                                                        selectedKidFriend);
                                                  } else if (appConstants
                                                          .selectedPrivacyType ==
                                                      3) {
                                                    //This is for Family
                                                    List<String> userKidsIds =
                                                        await services.getUserKids(
                                                            appConstants
                                                                .userRegisteredId);
                                                    userInvitedList =
                                                        userKidsIds +
                                                            [
                                                              appConstants
                                                                  .userRegisteredId
                                                            ];
                                                  } else if (appConstants
                                                          .selectedPrivacyType ==
                                                      4) {
                                                    userInvitedList = [
                                                      selectedKidId,
                                                      appConstants
                                                          .userRegisteredId
                                                    ];
                                                  } else {
                                                    userInvitedList = [];
                                                  }

                                                  setState(() {});

                                                  ////////////// End for Privacy Selection

                                                  ///////Now check if i am parent then i dont have any spending limit
                                                  if (appConstants
                                                          .userRegisteredId ==
                                                      appConstants.userModel
                                                          .userFamilyId) {
                                                    setState(() {
                                                      loading = true;
                                                    });
                                                    ApiServices services =
                                                        ApiServices();
                                                    List<dynamic> likes = [];

                                                    if (appConstants
                                                        .payRequestModel
                                                        .imageUrl!
                                                        .contains(
                                                            'com.zakipay.teencard')) {
                                                      String? pathImage =
                                                          await services.uploadImage(
                                                              path: appConstants
                                                                  .payRequestModel
                                                                  .imageUrl,
                                                                  userId: appConstants.userRegisteredId
                                                                  );
                                                      appConstants
                                                          .payRequestModel
                                                          .imageUrl = pathImage;
                                                      logMethod(
                                                          title:
                                                              'Image Uploaded successfully',
                                                          message: appConstants
                                                              .payRequestModel
                                                              .imageUrl);
                                                      showNotification(
                                                          error: 0,
                                                          icon: Icons.check,
                                                          message: pathImage);
                                                    }

                                                    // String? transactionId =
                                                    await services.payPlusMoney(
                                                        likesList: likes,
                                                        selectedKidImageUrl:
                                                            appConstants
                                                                .payRequestModel
                                                                .selectedKidImageUrl,
                                                        selectedKidName: appConstants
                                                            .payRequestModel
                                                            .selectedKidName,
                                                        senderImageUrl:
                                                            appConstants
                                                                .payRequestModel
                                                                .senderImageUrl,
                                                        requestType: AppConstants
                                                            .TAG_IT_Transaction_TYPE_SEND_OR_REQUEST,
                                                        privacy: appConstants
                                                            .selectedPrivacyType,
                                                        accountHolderName:
                                                            '${appConstants.userModel.usaUserName}',
                                                        message: appConstants
                                                            .payRequestModel
                                                            .message,
                                                        accountType: '',
                                                        tagItId: appConstants
                                                            .payRequestModel
                                                            .tagItId,
                                                        tagItName: appConstants
                                                            .payRequestModel
                                                            .tagItName,
                                                        amount: amountController
                                                            .text,
                                                        imageUrl: appConstants
                                                            .payRequestModel
                                                            .imageUrl,
                                                        toUserId: appConstants.payRequestModel.toUserId,
                                                        currentUserId: appConstants.userRegisteredId,
                                                        transactionId: transactionId);
                                                    await services.addSocialFeed(
                                                        likesList: likes,
                                                        usersList:
                                                            userInvitedList,
                                                        selectedKidImageUrl:
                                                            appConstants
                                                                .payRequestModel
                                                                .selectedKidImageUrl,
                                                        selectedKidName: appConstants
                                                            .payRequestModel
                                                            .selectedKidName,
                                                        senderImageUrl:
                                                            appConstants
                                                                .payRequestModel
                                                                .senderImageUrl,
                                                        requestType: AppConstants
                                                            .TAG_IT_Transaction_TYPE_SEND_OR_REQUEST,
                                                        privacy: appConstants
                                                            .selectedPrivacyType,
                                                        accountHolderName:
                                                            '${appConstants.userModel.usaUserName}',
                                                        message: appConstants
                                                            .payRequestModel
                                                            .message,
                                                        accountType: '',
                                                        tagItId: appConstants
                                                            .payRequestModel
                                                            .tagItId,
                                                        tagItName: appConstants
                                                            .payRequestModel
                                                            .tagItName,
                                                        amount: amountController
                                                            .text,
                                                        imageUrl: appConstants
                                                            .payRequestModel
                                                            .imageUrl,
                                                        receiverId: appConstants.payRequestModel.toUserId,
                                                        senderId: appConstants.userRegisteredId,
                                                        transactionId: transactionId);
                                                    // } else {
                                                    //   await services.payPlusMoney(
                                                    //     likesList: likes,
                                                    //     selectedKidImageUrl: appConstants
                                                    //         .payRequestModel.selectedKidImageUrl,
                                                    //     selectedKidName: appConstants
                                                    //         .payRequestModel.selectedKidName,
                                                    //     senderImageUrl: appConstants
                                                    //         .payRequestModel.senderImageUrl,
                                                    //     requestType: AppConstants
                                                    //         .TAG_IT_Transaction_TYPE_SEND_OR_REQUEST,
                                                    //     privacy: appConstants.selectedPrivacyType,
                                                    //     accountHolderName:
                                                    //         '${appConstants.userModel.usaFirstName} ${appConstants.userModel.usaLastName}',
                                                    //     message:
                                                    //         appConstants.payRequestModel.message,
                                                    //     accountType: '',
                                                    //     tagItId : appConstants
                                                    //         .payRequestModel.tagItId ,
                                                    //     tagItName: appConstants
                                                    //         .payRequestModel.tagItName,
                                                    //     amount: amountController.text,
                                                    //     imageUrl:
                                                    //         appConstants.payRequestModel.imageUrl,
                                                    //     toUserId:
                                                    //         appConstants.payRequestModel.toUserId,
                                                    //     currentUserId:
                                                    //         appConstants.userRegisteredId,
                                                    //   );
                                                    // }
                                                    // await services.addMoveMoney(message: appConstants.payRequestModel.message, accountHolderName: '${appConstants.userModel.usaFirstName}+${appConstants.userModel.usaLastName}', accountType: 'Spending', tagItId : appConstants.payRequestModel.tagItId .toString(), tagItName: appConstants.payRequestModel.tagItName, amount: amountController.text, imageUrl: appConstants.payRequestModel.imageUrl, parentId: appConstants.userModel.userFamilyId, senderId: appConstants.userRegisteredId, userId: appConstants.payRequestModel.toUserId, senderUserId: appConstants.userRegisteredId);
                                                    // await services.addMoveMoney(message: appConstants.payRequestModel.message, accountHolderName: '${appConstants.userModel.usaFirstName}+${appConstants.userModel.usaLastName}', accountType: 'Spending', tagItId : appConstants.payRequestModel.tagItId , tagItName: appConstants.payRequestModel.tagItName, amount: amountController.text, imageUrl: appConstants.payRequestModel.imageUrl, parentId: appConstants.userModel.userFamilyId, senderId: '1234', userId: appConstants.payRequestModel.id, senderUserId: appConstants.userRegisteredId);
                                                    // Navigator.push(
                                                    //     context,
                                                    //     MaterialPageRoute(
                                                    //         builder: (context) =>
                                                    //             const FriendsActivities()));
                                                    // Future.delayed(
                                                    //     const Duration(milliseconds: 1000), () {
                                                    setState(() {
                                                      loading = false;
                                                    });
                                                    await services
                                                        .getUserTokenAndSendNotification(
                                                            userId:
                                                                selectedKidId,
                                                            title:
                                                                  '${NotificationText.PAY_NOTIFICATION_TITLE} ${appConstants.userModel.usaUserName}',
                                                              subTitle:
                                                                  '${NotificationText.PAY_NOTIFICATION_SUB_TITLE} ${getCurrencySymbol(context, appConstants: appConstants)} ${amountController.text}',
                                                            checkParent: true,
                                                            parentTitle: '${appConstants.userModel.usaUserName} sent ${getCurrencySymbol(context, appConstants: appConstants)} ${amountController.text}',
                                                             parentSubtitle: 'See Details in ZakiPay'
                                                          );
                                                    progressDialog.dismiss();
                                                    appConstants
                                                        .updateLoading(false);
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                CustomConfermationScreen(
                                                                  title:
                                                                      'Great Job!',
                                                                  subTitle:
                                                                      "$selectedKidName received ${getCurrencySymbol(context, appConstants: appConstants)} ${amountController.text}",
                                                                  imageUrl:
                                                                      selectedKidImageUrl,
                                                                )));
                                                    return;
                                                  }

                                                  /////////End for checking that i am parent

                                                  /////////First check if user has more money in spending limit or not
                                                  String? limitReached =
                                                      await getUserKidSpendingLimits(
                                                          parentId: appConstants
                                                              .userModel
                                                              .userFamilyId??appConstants.userRegisteredId,
                                                          kidId: appConstants
                                                              .userRegisteredId,
                                                          appConstants:
                                                              appConstants);
                                                  if (limitReached ==
                                                      "Monthly limit reached!") {
                                                    progressDialog.dismiss();
                                                    // showDialog(
                                                    //   context: context,
                                                    //   builder: (BuildContext dialougeContext) {
                                                    //     var width = MediaQuery.of(context).size.width;
                                                    //     return AlertDialog(
                                                    //       shape: RoundedRectangleBorder(
                                                    //           borderRadius: BorderRadius.all(Radius.circular(14.0))),
                                                    //       content: TextValue2(
                                                    //         title: 'Wow! Monthly Spend Limit Reached!',
                                                    //       ),
                                                    //       actions: [
                                                    //         Row(
                                                    //           mainAxisAlignment: MainAxisAlignment.end,
                                                    //           children: [ZakiCicularButton(
                                                    //                     title:'Fund Wallet Now',
                                                    //                     width: width,
                                                    //                     textStyle: heading4TextSmall(width, color: green),
                                                    //                     onPressed: (){
                                                    //                       Navigator.pop(dialougeContext);
                                                    //                     },
                                                    //                   ),
                                                    //             const SizedBox(
                                                    //               width: 10,
                                                    //             ),ZakiCicularButton(
                                                    //                     title:'      No      ',
                                                    //                     width: width,
                                                    //                     selected: 4,
                                                    //                     backGroundColor: green,
                                                    //                     border: false,
                                                    //                     textStyle: heading4TextSmall(width, color: white),
                                                    //                     onPressed: (){
                                                    //                       Navigator.pop(dialougeContext);
                                                    //                     },
                                                    //                   ),
                                                    //           ],
                                                    //         ),
                                                    //       ]
                                                    //       // actions
                                                    //   );
                                                    //   }
                                                    // );
                                                    // customAleartDialog(
                                                    //     context: context,
                                                    //     title:
                                                    //         'Wow! Monthly Spend Limit Reached!',
                                                    //     width: width,
                                                    //     titleButton1: 'Fund Wallet Now',
                                                    //     firstButtonOnPressed: () {},
                                                    //     secondButtonOnPressed: () {
                                                    //       Navigator.pop(context);
                                                    //     });
                                                    appConstants
                                                        .updateLoading(false);
                                                    return;
                                                  } else {
                                                    if (appConstants
                                                                .personalizationSettingModel !=
                                                            null &&
                                                        appConstants
                                                                .personalizationSettingModel!
                                                                .kidPUseSlide2Pay ==
                                                            true) {
                                                      logMethod(
                                                          title:
                                                              'Invited Users',
                                                          message:
                                                              userInvitedList
                                                                  .toString());
                                                      progressDialog.dismiss();
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  PayReview(
                                                                      userInvitedList:
                                                                          userInvitedList)));
                                                    } else {
                                                      setState(() {
                                                        loading = true;
                                                      });
                                                      ApiServices services =
                                                          ApiServices();
                                                      List<dynamic> likes = [];

                                                      if (appConstants
                                                          .payRequestModel
                                                          .imageUrl!
                                                          .contains(
                                                              'com.zakipay.teencard')) {
                                                        String? pathImage =
                                                            await services.uploadImage(
                                                                path: appConstants
                                                                    .payRequestModel
                                                                    .imageUrl, userId: appConstants.userRegisteredId);
                                                        appConstants
                                                                .payRequestModel
                                                                .imageUrl =
                                                            pathImage;
                                                        logMethod(
                                                            title:
                                                                'Image Uploaded',
                                                            message: appConstants
                                                                .payRequestModel
                                                                .imageUrl);
                                                        showNotification(
                                                            error: 0,
                                                            icon: Icons.check,
                                                            message: appConstants
                                                                .payRequestModel
                                                                .imageUrl);
                                                      }

                                                      //   await services.payPlusMoney(
                                                      //     likesList: likes,
                                                      //     selectedKidImageUrl: appConstants
                                                      //         .payRequestModel
                                                      //         .selectedKidImageUrl,
                                                      //     selectedKidName: appConstants
                                                      //         .payRequestModel.selectedKidName,
                                                      //     senderImageUrl: appConstants
                                                      //         .payRequestModel.senderImageUrl,
                                                      //     requestType: 'Send',
                                                      //     privacy:
                                                      //         appConstants.selectedPrivacyType,
                                                      //     accountHolderName:
                                                      //         '${appConstants.userModel.usaFirstName} ${appConstants.userModel.usaLastName}',
                                                      //     message: appConstants
                                                      //         .payRequestModel.message,
                                                      //     accountType: '',
                                                      //     tagItId : appConstants
                                                      //         .payRequestModel.tagItId ,
                                                      //     tagItName: appConstants
                                                      //         .payRequestModel.tagItName,
                                                      //     amount: amountController.text,
                                                      //     imageUrl: pathImage,
                                                      //     toUserId: appConstants
                                                      //         .payRequestModel.toUserId,
                                                      //     currentUserId:
                                                      //         appConstants.userRegisteredId,
                                                      //   );
                                                      // } else {
                                                      // String? transactionId =
                                                      await services.payPlusMoney(
                                                          likesList: likes,
                                                          selectedKidImageUrl:
                                                              appConstants
                                                                  .payRequestModel
                                                                  .selectedKidImageUrl,
                                                          selectedKidName: appConstants
                                                              .payRequestModel
                                                              .selectedKidName,
                                                          senderImageUrl: appConstants
                                                              .payRequestModel
                                                              .senderImageUrl,
                                                          requestType: AppConstants
                                                              .TAG_IT_Transaction_TYPE_SEND_OR_REQUEST,
                                                          privacy: appConstants
                                                              .selectedPrivacyType,
                                                          accountHolderName:
                                                              '${appConstants.userModel.usaUserName}',
                                                          message: appConstants
                                                              .payRequestModel
                                                              .message,
                                                          accountType: '',
                                                          tagItId: appConstants
                                                              .payRequestModel
                                                              .tagItId,
                                                          tagItName: appConstants
                                                              .payRequestModel
                                                              .tagItName,
                                                          amount: amountController
                                                              .text,
                                                          imageUrl: appConstants
                                                              .payRequestModel
                                                              .imageUrl,
                                                          toUserId: appConstants.payRequestModel.toUserId,
                                                          currentUserId: appConstants.userRegisteredId,
                                                          transactionId: transactionId);

                                                      await services.addSocialFeed(
                                                          likesList: likes,
                                                          usersList:
                                                              userInvitedList,
                                                          selectedKidImageUrl:
                                                              appConstants
                                                                  .payRequestModel
                                                                  .selectedKidImageUrl,
                                                          selectedKidName: appConstants
                                                              .payRequestModel
                                                              .selectedKidName,
                                                          senderImageUrl: appConstants
                                                              .payRequestModel
                                                              .senderImageUrl,
                                                          requestType: AppConstants
                                                              .TAG_IT_Transaction_TYPE_SEND_OR_REQUEST,
                                                          privacy: appConstants
                                                              .selectedPrivacyType,
                                                          accountHolderName:
                                                              '${appConstants.userModel.usaUserName}',
                                                          message: appConstants
                                                              .payRequestModel
                                                              .message,
                                                          accountType: '',
                                                          tagItId: appConstants
                                                              .payRequestModel
                                                              .tagItId,
                                                          tagItName: appConstants
                                                              .payRequestModel
                                                              .tagItName,
                                                          amount: amountController
                                                              .text,
                                                          imageUrl: appConstants
                                                              .payRequestModel
                                                              .imageUrl,
                                                          receiverId: appConstants.payRequestModel.toUserId,
                                                          senderId: appConstants.userRegisteredId,
                                                          transactionId: transactionId);

                                                      // }
                                                      // await services.addMoveMoney(message: appConstants.payRequestModel.message, accountHolderName: '${appConstants.userModel.usaFirstName}+${appConstants.userModel.usaLastName}', accountType: 'Spending', tagItId : appConstants.payRequestModel.tagItId .toString(), tagItName: appConstants.payRequestModel.tagItName, amount: amountController.text, imageUrl: appConstants.payRequestModel.imageUrl, parentId: appConstants.userModel.userFamilyId, senderId: appConstants.userRegisteredId, userId: appConstants.payRequestModel.toUserId, senderUserId: appConstants.userRegisteredId);
                                                      // await services.addMoveMoney(message: appConstants.payRequestModel.message, accountHolderName: '${appConstants.userModel.usaFirstName}+${appConstants.userModel.usaLastName}', accountType: 'Spending', tagItId : appConstants.payRequestModel.tagItId , tagItName: appConstants.payRequestModel.tagItName, amount: amountController.text, imageUrl: appConstants.payRequestModel.imageUrl, parentId: appConstants.userModel.userFamilyId, senderId: '1234', userId: appConstants.payRequestModel.id, senderUserId: appConstants.userRegisteredId);
                                                      // Navigator.push(
                                                      //     context,
                                                      //     MaterialPageRoute(
                                                      //         builder: (context) =>
                                                      //             const FriendsActivities()));
                                                      // Future.delayed(
                                                      //     const Duration(milliseconds: 1000), () {
                                                      setState(() {
                                                        loading = false;
                                                      });
                                                      await services
                                                          .getUserTokenAndSendNotification(
                                                              userId:
                                                                  selectedKidId,
                                                              title:
                                                                  '${NotificationText.PAY_NOTIFICATION_TITLE} ${appConstants.userModel.usaUserName}',
                                                              subTitle:
                                                                  '${NotificationText.PAY_NOTIFICATION_SUB_TITLE} ${getCurrencySymbol(context, appConstants: appConstants)} ${amountController.text}',
                                                              checkParent: true,
                                                             parentTitle: '${appConstants.userModel.usaUserName} sent ${getCurrencySymbol(context, appConstants: appConstants)} ${amountController.text}',
                                                             parentSubtitle: 'See Details in ZakiPay'
                                                                  );
                                                      progressDialog.dismiss();
                                                      appConstants
                                                          .updateLoading(false);
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  CustomConfermationScreen(
                                                                    title:
                                                                        'Mission Accomplished!',
                                                                    subTitle:
                                                                        "$selectedKidName received \n${getCurrencySymbol(context, appConstants: appConstants)} ${amountController.text}",
                                                                    imageUrl:
                                                                        selectedKidImageUrl,
                                                                  )));
                                                    }
                                                  }
                                                },
                              title: 'Send',
                              width: width,
                            )
                            )
                          ],
                        ),
                        // spacing_small,
                        
                      ],
                    ),
                  ),
                  spacing_small,
                ],
              ),
      ),
    );
  }
  bool canPressButton({required String internetStatus, required AppConstants appConstants}) {
  if (amountController.text.isEmpty) return false;
  if (selectedKidId == '' || selectedAllocation == -2) return false;
  if (internetStatus == AppConstants.INTERNET_STATUS_NOT_CONNECTED) return false;
  if (int.parse(amountController.text) > 500 || appConstants.isLoading) return false;
  return true;
}

  void privacyBottomSheet(
      {required BuildContext context, double? width, double? height}) {
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
                              borderRadius: BorderRadius.circular(width * 0.08),
                              color: grey),
                        ),
                      ),
                    ),
                    Text(
                      'Who can see this?',
                      style: heading1TextStyle(context, width),
                    ),
                    spacing_large,
                    (appConstants.personalizationSettingModel != null &&
                            appConstants.personalizationSettingModel!
                                    .kidPKids2Publish ==
                                false)
                        ? Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: width * 0.08,
                                    vertical: width * 0.01),
                                child: PrivacyTypeButton(
                                  width: width,
                                  title: 'Family',
                                  subTitle:
                                      'Your immediate family on ZakiPay can see it.',
                                  icon: "family.png",
                                  selected:
                                      appConstants.selectedPrivacyType == 3
                                          ? 1
                                          : 0,
                                  onTap: () {
                                    appConstants
                                        .updateSlectedPrivacyTypeIndex(3);
                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: width * 0.08,
                                    vertical: width * 0.01),
                                child: PrivacyTypeButton(
                                  width: width,
                                  title: 'You & Me',
                                  subTitle: 'Just You & Me.',
                                  icon: "you_me.png",
                                  selected:
                                      appConstants.selectedPrivacyType == 4
                                          ? 1
                                          : 0,
                                  onTap: () {
                                    appConstants
                                        .updateSlectedPrivacyTypeIndex(4);
                                    Navigator.pop(context);
                                  },
                                ),
                              )
                            ],
                          )
                        : Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: width * 0.08,
                                    vertical: width * 0.01),
                                child: PrivacyTypeButton(
                                  width: width,
                                  // ignore: deprecated_member_use
                                  icon: 'public.png',
                                  selected:
                                      appConstants.selectedPrivacyType == 1
                                          ? 1
                                          : 0,
                                  title: 'Public',
                                  subTitle: 'All ZakiPay Users',
                                  onTap: () {
                                    appConstants
                                        .updateSlectedPrivacyTypeIndex(1);
                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: width * 0.08,
                                    vertical: width * 0.01),
                                child: PrivacyTypeButton(
                                  width: width,
                                  title: 'Friends',
                                  subTitle:
                                      'ZakiPay Friends and Family Memebers',
                                  // ignore: deprecated_member_use
                                  icon: "friends.png",
                                  selected:
                                      appConstants.selectedPrivacyType == 2
                                          ? 1
                                          : 0,
                                  onTap: () {
                                    appConstants
                                        .updateSlectedPrivacyTypeIndex(2);
                                    Navigator.pop(context);
                                  },
                                ),
                              ), 
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: width * 0.08,
                                    vertical: width * 0.01),
                                child: PrivacyTypeButton(
                                  width: width,
                                  title: 'Family',
                                  subTitle:
                                      'Your ZakiPay Family Members Only',
                                  icon: "family.png",
                                  selected:
                                      appConstants.selectedPrivacyType == 3
                                          ? 1
                                          : 0,
                                  onTap: () {
                                    appConstants
                                        .updateSlectedPrivacyTypeIndex(3);
                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: width * 0.08,
                                    vertical: width * 0.01),
                                child: PrivacyTypeButton(
                                  width: width,
                                  title: 'You & Me',
                                  subTitle: 'Just You & Me.',
                                  icon: "you_me.png",
                                  selected:
                                      appConstants.selectedPrivacyType == 4
                                          ? 1
                                          : 0,
                                  onTap: () {
                                    appConstants
                                        .updateSlectedPrivacyTypeIndex(4);
                                    Navigator.pop(context);
                                  },
                                ),
                              )
                            ],
                          ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}



class ImageSelector extends StatelessWidget {
  const ImageSelector({
    Key? key,
    this.icon,
    this.onTap,
  }) : super(key: key);

  final IconData? icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Container(
        height: height * 0.09,
        width: width * 0.26,
        decoration: BoxDecoration(
          // shape: BoxShape.circle,
          color: Colors.grey.withOpacity(0.005),
          borderRadius: BorderRadius.circular(width * 0.03),
          border: Border.all(color: grey.withOpacity(0.3)),
        ),
        child: IconButton(
          onPressed: onTap,
          icon: Icon(icon),
        ));
  }
}

class PrivacyTypeButton extends StatelessWidget {
  const PrivacyTypeButton(
      {Key? key,
      required this.width,
      this.onTap,
      this.selected,
      this.icon,
      this.title,
      this.subTitle,
      this.tralingIcon})
      : super(key: key);

  final double width;
  final VoidCallback? onTap;
  final int? selected;
  final String? icon;
  final String? title;
  final String? subTitle;
  final IconData? tralingIcon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            color: selected == 1 ? green : transparent,
            borderRadius: BorderRadius.circular(width * 0.05),
            border: Border.all(
              color: selected == 1 ? transparent : grey,
            )),
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: ListTile(
            leading: Image.asset(imageBaseAddress + icon!),
            title: Text(
              title!,
              style: textStyleHeading2WithTheme(context, width * 0.9,
                  whiteColor: selected == 1 ? 1 : 0),
            ),
            subtitle: subTitle == null
                ? null
                : Text(
                    subTitle!,
                    style: textStyleHeading2WithTheme(context, width * 0.6,
                        whiteColor: selected == 1 ? 1 : 2),
                  ),
            trailing: tralingIcon != null
                ? Icon(
                    Icons.arrow_circle_right,
                    color: selected == 1
                        ? white
                        : selected == 2
                            ? green
                            : blue,
                  )
                : null,
          ),
        ),
      ),
    );
  }
}
