import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zaki/Constants/HelperFunctions.dart';
import 'package:zaki/Constants/NotificationTitle.dart';
import 'package:zaki/Constants/Spacing.dart';
import 'package:zaki/Screens/AddMembersWorkFlow.dart';
import 'package:zaki/Screens/IssueAndManageCards.dart';
// import 'package:zaki/Screens/RequestDebitCard.dart';
import 'package:zaki/Screens/SpendingLimit.dart';
import 'package:zaki/Services/CloudFunctions.dart';
import 'package:zaki/Widgets/TextHeader.dart';
import 'package:zaki/Widgets/ZakiPrimaryButton.dart';

import '../Constants/AppConstants.dart';
import '../Constants/Styles.dart';
import '../Services/api.dart';
import '../Widgets/AppBars/AppBar.dart';
import '../Widgets/BackgroundConatiner.dart';
import '../Widgets/CustomConfermationScreen.dart';
import '../Widgets/CustomSizedBox.dart';

class SecretDebitCard extends StatefulWidget {
  const SecretDebitCard({Key? key}) : super(key: key);

  @override
  _IssueDebitCardState createState() => _IssueDebitCardState();
}

class _IssueDebitCardState extends State<SecretDebitCard> {
  Stream<QuerySnapshot>? requestedMoneyActivities;
  Stream<QuerySnapshot>? userKids;
  int selectedIndex = -1;
  dynamic cardAlreadyExist = false;
  String selectedUserId = '';
  final formGlobalKey = GlobalKey<FormState>();
  final mccAmountController = TextEditingController();
  final lastNameController = TextEditingController();
  final appsController = TextEditingController();
  final allowanceController = TextEditingController();
  final electronicsController = TextEditingController();
  final mc_id_004Controller = TextEditingController();
  final mc_id_005Controller = TextEditingController();
  final mc_id_006Controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    getUserKids();
  }

  getUserKids() {
    Future.delayed(const Duration(milliseconds: 200), () {
      setState(() {
        var appConstants = Provider.of<AppConstants>(context, listen: false);
        userKids = ApiServices().fetchUserKids(
            appConstants.userModel.seeKids == true
                ? appConstants.userModel.userFamilyId!
                : appConstants.userRegisteredId,
            currentUserId: appConstants.userRegisteredId);
        appConstants.updateDateOfBirth('dd / mm / yyyy');
        userCardInfo(appConstants.userRegisteredId,
            appConstants.userModel.userFamilyId!);
      });
    });
  }

  userCardInfo(String seletedUser, String parentId) async {
    ApiServices apiServices = ApiServices();
    dynamic cardExist =
        await apiServices.checkCardExist(parentId: parentId, id: seletedUser);
    setState(() {
      cardAlreadyExist = cardExist;
      logMethod(title: 'Card exist', message: cardAlreadyExist.toString());
    });
  }

  void setSelectedUserData(
      {String? firstName,
      String? lastName,
      String? dateOfBirth,
      String? gouvernmentId,
      String? phoneNumber}) {
    var appConstants = Provider.of<AppConstants>(context, listen: false);
    appConstants.updateDateOfBirth(dateOfBirth!);
    lastNameController.text = lastName!;
  }

  @override
  Widget build(BuildContext context) {
    var appConstants = Provider.of<AppConstants>(context, listen: true);
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Form(
                key: formGlobalKey,
                child: Padding(
                  padding: getCustomPadding(),
                  child: Column(
                    children: [
                      appBarHeader_005(
                          width: width,
                          height: height,
                          context: context,
                          appBarTitle: 'Adnans Test Screen'),
                          spacing_medium,
                          Card(
                            child: Padding(
                              padding: getCustomPadding(),
                              child: Column(
                                children: [
                                  ListTile(
                                                          title: TextValue2(
                                                            title: 'Turn ON/OFF payfort for Fund My Wallet Screen?',
                                                          ),
                                                          trailing: Switch.adaptive(
                                                            value: appConstants.payFortTestingModeForFundMyWallet,
                                                            activeColor: primaryButtonColor,
                                                            onChanged: (value) async {
                                                              appConstants.payfortTestingModeStatusForFundMyWallet(value);
                                                            },
                                                          ),
                                                        ),
                                  ListTile(
                                                          title: TextValue2(
                                                            title: 'Turn ON/OFF payfort for Subscription Screen?',
                                                          ),
                                                          trailing: Switch.adaptive(
                                                            value: appConstants.payFortTestingModeForSubscription,
                                                            activeColor: primaryButtonColor,
                                                            onChanged: (value) async {
                                                              appConstants.payfortTestingModeStatusForSubscription(value);
                                                            },
                                                          ),
                                                        ),
                        ListTile(
                        title: TextValue2(
                          title: "Turn ON/OFF Google or Apple Pay",
                        ),
                        trailing: Switch.adaptive(
                          value: appConstants.allowApplePayAndGooglePay,
                          activeColor: primaryButtonColor,
                          onChanged: (value) async {
                            appConstants.allowApplePayAndGooglePayMode(value);
                          },
                        ),
                      ),
                      ListTile(
                        title: TextValue2(
                          title: 'Turn Bank API on for testing',
                        ),
                        trailing: Switch.adaptive(
                          value: appConstants.testMode,
                          activeColor: primaryButtonColor,
                          onChanged: (value) async {
                            appConstants.updateTestMode(value);
                          },
                        ),
                      ),
                                ],
                              ),
                              ),
                          ),
                          spacing_medium,
                      ZakiPrimaryButton(
                        width: width,
                        title: 'Send Notification',
                        onPressed: () async{
                          // CloudFunctions().callFunction(
                          //   expression: '30 1 1,15 * *'
                          // );
                          ApiServices().sendNotification(
                            token: "fSzALXYPSPWs6CQHjQkETV:APA91bGUgH6UOqVbgenu9RF3tEUkDoczkfRwLMsUoReEI2ktLj4PzP4GbMNhC7ilhQL5WEb3wtqxn077eNXbqSd7AwXw5JkSv8Dn5wkFBpIfp3W5KjwHACrVnDzbg7gmosA-AiedcF-J",
                            title: "From mobile notification title",
                            body: "From mobile notification body with all the detail"
                          );
                        //   await CloudFunctions().sendUserNotification(
                        //   userToken: appConstants.userModel.deviceToken,
                        //   userCardToken: appConstants.userModel.userTokenId,
                        //   userId: appConstants.userRegisteredId
                        //  );
                        //   DateTime date = DateTime.now();
                        //  CloudFunctions().sendNotification(
                        //   userToken: appConstants.userModel.deviceToken,
                        //   notificationTitle: NotificationText.ALLOWANCE_ADDED_TITLE,
                        //   notificationSubTitle: NotificationText.ALLOWANCE_ADDED_SUBTITLE,
                        //   cownExpression: '30 1 1,15 * *'
                        //  );
                                  }),
                      spacing_X_large,
                      ZakiPrimaryButton(
                        width: width,
                        title: 'New Work Flow',
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddMemberWorkFlow()));
                        },
                      ),
                      // spacing_medium,
                      
                      SizedBox(
                        height: height * 0.2,
                      ),
                      Center(
                        child: ZakiPrimaryButton(
                          title: 'Extract ',
                          width: width,
                          onPressed: () {
                            extractMemo(memo: '');
                          },
                        ),
                      ),
                      appConstants.userModel.usaUserType == "Kid"
                          ? cardAlreadyExist != false
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // cardAlreadyExist.data()[AppConstants.ICard_physical_card] == true
                                  ],
                                )
                              : Column(
                                  children: [
                                    // spacing_X_large,
                                    Image.asset(imageBaseAddress +
                                        'no_card_assigned.png'),
                                    // spacing_X_large,
                                    Container(
                                      decoration: BoxDecoration(
                                          color: Colors.blueAccent
                                              .withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(14)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(14.0),
                                        child: Text(
                                          'Oh Oh...Your parents did not issue \nyou a  Debit Card Yet! 😢',
                                          style:
                                              heading1TextStyle(context, width),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    spacing_large,
                                    ZakiPrimaryButton(
                                      title: 'Ask Them Now!',
                                      width: width,
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    CustomConfermationScreen(
                                                      title:
                                                          'Parent Has Been Informed!',
                                                      // imageUrl: selectedKidImageUrl,
                                                    )));
                                      },
                                    )
                                  ],
                                )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    InkWell(
                                      onTap: () async {
                                        if (selectedUserId !=
                                            appConstants.userRegisteredId) {
                                          setState(() {
                                            selectedIndex = -1;
                                            selectedUserId =
                                                appConstants.userRegisteredId;
                                          });
                                          setSelectedUserData(
                                            dateOfBirth:
                                                appConstants.userModel.usaDob,
                                            firstName: appConstants
                                                .userModel.usaFirstName,
                                            gouvernmentId: '',
                                            lastName: appConstants
                                                .userModel.usaLastName,
                                            phoneNumber: appConstants
                                                .userModel.usaPhoneNumber,
                                          );
                                          ApiServices apiServices =
                                              ApiServices();
                                          dynamic cardExist =
                                              await apiServices.checkCardExist(
                                                  parentId: appConstants
                                                      .userRegisteredId,
                                                  id: selectedUserId);
                                          setState(() {
                                            cardAlreadyExist = cardExist;
                                          });
                                        }
                                      },
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            height: 70,
                                            width: 70,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: transparent,
                                              border: Border.all(
                                                  width: selectedIndex == -1
                                                      ? 2
                                                      : 0,
                                                  color: selectedIndex == -1
                                                      ? green
                                                      : transparent),
                                              boxShadow: selectedIndex != -1
                                                  ? null
                                                  : [
                                                      customBoxShadow(
                                                          color: green)
                                                    ],
                                            ),
                                            child: Padding(
                                                padding:
                                                    const EdgeInsets.all(0.0),
                                                child: userImage(
                                                    imageUrl: appConstants
                                                        .userModel.usaLogo!,
                                                    userType: appConstants
                                                        .userModel.usaUserType,
                                                    width: width * 0.6,
                                                    gender: appConstants
                                                        .userModel.usaGender)),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Center(
                                            child: Text(
                                              '@ ' +
                                                  appConstants
                                                      .userModel.usaUserName
                                                      .toString(),
                                              // overflow: TextOverflow.clip,
                                              // maxLines: 1,
                                              style: heading5TextSmall(width),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 12,
                                    ),
                                    Expanded(
                                      child: userKids == null
                                          ? const SizedBox()
                                          : Container(
                                              // color: Color(0XFFF9FFF9),
                                              height: height * 0.123,
                                              width: width,
                                              child:
                                                  StreamBuilder<QuerySnapshot>(
                                                stream: userKids,
                                                builder: (BuildContext context,
                                                    AsyncSnapshot<QuerySnapshot>
                                                        snapshot) {
                                                  if (snapshot.hasError) {
                                                    return const Text(
                                                        'Ooops...Something went wrong :(');
                                                  }

                                                  if (snapshot
                                                          .connectionState ==
                                                      ConnectionState.waiting) {
                                                    return const Text("");
                                                  }
                                                  if (snapshot.data!.size ==
                                                      0) {
                                                    return const Center(
                                                        child: Text(""));
                                                  }
//snapshot.data!.docs[index] ['USA_first_name']
                                                  return ListView.builder(
                                                    itemCount: snapshot
                                                        .data!.docs.length,
                                                    physics:
                                                        const NeverScrollableScrollPhysics(),
                                                    shrinkWrap: true,
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      // SchedulerBinding.instance!.addPostFrameCallback((_) {
                                                      //       // setState(() {
                                                      //       //   selectedIndex=0;
                                                      //       //   // getUserKidSpendingLimits(parentId: appConstants.userRegisteredId, kidId: snapshot.data!.docs[0].id);
                                                      //       // });
                                                      //     if (selectedIndex ==-1 ) {
                                                      //       setState(() {
                                                      //       selectedIndex = 0;
                                                      //       // selectedKidId =snapshot.data!.docs[0].id;
                                                      //     });
                                                      //     getUserKidsPersonalizationsSettings(appConstants, kidId: snapshot.data!.docs[0].id);
                                                      //     }
                                                      //     });
                                                      // print(snapshot.data!.docs[index] ['USA_first_name']);
                                                      return (snapshot.data!.docs[
                                                                          index]
                                                                      [
                                                                      AppConstants
                                                                          .NewMember_isEnabled] ==
                                                                  false ||
                                                              (snapshot.data!.docs[
                                                                          index]
                                                                      [
                                                                      AppConstants
                                                                          .USER_UserType] !=
                                                                  AppConstants
                                                                      .USER_TYPE_KID))
                                                          ? const SizedBox
                                                              .shrink()
                                                          : InkWell(
                                                              onTap: () async {
                                                                if (selectedUserId !=
                                                                    snapshot
                                                                        .data!
                                                                        .docs[
                                                                            index]
                                                                        .id) {
                                                                  setState(() {
                                                                    selectedIndex =
                                                                        index;
                                                                    selectedUserId =
                                                                        snapshot
                                                                            .data!
                                                                            .docs[index]
                                                                            .id;
                                                                    // selectedKidId = snapshot.data!.docs[index].id;
                                                                  });
                                                                  setSelectedUserData(
                                                                    dateOfBirth: snapshot
                                                                            .data!
                                                                            .docs[index]
                                                                        [
                                                                        AppConstants
                                                                            .USER_dob],
                                                                    firstName: snapshot
                                                                            .data!
                                                                            .docs[index]
                                                                        [
                                                                        AppConstants
                                                                            .USER_first_name],
                                                                    gouvernmentId:
                                                                        '',
                                                                    lastName: snapshot
                                                                            .data!
                                                                            .docs[index]
                                                                        [
                                                                        AppConstants
                                                                            .USER_last_name],
                                                                    phoneNumber: snapshot
                                                                            .data!
                                                                            .docs[index]
                                                                        [
                                                                        AppConstants
                                                                            .USER_phone_number],
                                                                  );
                                                                }

                                                                ApiServices
                                                                    apiServices =
                                                                    ApiServices();
                                                                dynamic cardExist =
                                                                    await apiServices.checkCardExist(
                                                                        parentId:
                                                                            appConstants.userRegisteredId,
                                                                        id: selectedUserId);
                                                                setState(() {
                                                                  cardAlreadyExist =
                                                                      cardExist;
                                                                });
                                                              },
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        right:
                                                                            12.0),
                                                                child: Column(
                                                                  children: [
                                                                    Container(
                                                                      height:
                                                                          70,
                                                                      width: 70,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        shape: BoxShape
                                                                            .circle,
                                                                        color:
                                                                            transparent,
                                                                        border: Border.all(
                                                                            width: selectedIndex == index
                                                                                ? 2
                                                                                : 0,
                                                                            color: selectedIndex == index
                                                                                ? green
                                                                                : transparent),
                                                                        boxShadow: selectedIndex !=
                                                                                index
                                                                            ? null
                                                                            : [
                                                                                customBoxShadow(color: green)
                                                                              ],
                                                                      ),
                                                                      child: Padding(
                                                                          padding: const EdgeInsets.all(0.0),
                                                                          child: userImage(
                                                                            imageUrl:
                                                                                snapshot.data!.docs[index][AppConstants.USER_Logo],
                                                                            userType:
                                                                                snapshot.data!.docs[index][AppConstants.USER_UserType],
                                                                            width:
                                                                                width,
                                                                            gender:
                                                                                snapshot.data!.docs[index][AppConstants.USER_gender],
                                                                          )),
                                                                    ),
                                                                    SizedBox(
                                                                      height: 5,
                                                                    ),
                                                                    SizedBox(
                                                                      // width: height * 0.065,
                                                                      child:
                                                                          Center(
                                                                        child:
                                                                            Text(
                                                                          '@ ' +
                                                                              snapshot.data!.docs[index][AppConstants.USER_user_name],
                                                                          overflow:
                                                                              TextOverflow.fade,
                                                                          maxLines:
                                                                              1,
                                                                          style:
                                                                              heading5TextSmall(width),
                                                                        ),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            );
                                                    },
                                                  );
                                                },
                                              ),
                                            ),
                                    ),
                                  ],
                                ),
                                spacing_medium,
                                cardAlreadyExist == false
                                    ? Column(
                                        children: [
                                          // spacing_large,
                                          Image.asset(imageBaseAddress +
                                              "no_card_assigned.png"),
                                          // spacing_large,
                                          ZakiPrimaryButton(
                                            title: 'Issue a Debit Card',
                                            width: width,
                                            onPressed: () async {},
                                          )
                                        ],
                                      )
                                    : Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                            // cardAlreadyExist.data()[AppConstants
                                            //             .ICard_physical_card] ==
                                            //         true
                                            spacing_medium,
                                            //                                       ImageModelTagIt(id: -1, icon: Icons.grid_view_rounded, title: 'Stuff', mccId: 'MCC_1731'),
                                            // ImageModelTagIt(id: 0, icon: Icons.phone_iphone_sharp, title: Apps, mccId: 'MCC_1732'),
                                            // ImageModelTagIt(
                                            //     id: 1, icon: FontAwesomeIcons.moneyBillTransfer, title: , mccId: 'MCC_1733'),
                                            // ImageModelTagIt(id: 2, icon: FontAwesomeIcons.tv, title: '' , mccId: 'MCC_1734'),
                                            Text(
                                              'MCC ID: 004',
                                              style: heading3TextStyle(width),
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  'Food',
                                                  style:
                                                      heading3TextStyle(width),
                                                ),
                                                Expanded(
                                                  child: AllocationCustomFields(
                                                      width: width,
                                                      controller:
                                                          mc_id_004Controller),
                                                ),
                                              ],
                                            ),
                                            spacing_large,
                                            ZakiPrimaryButton(
                                              title: 'Send',
                                              width: width,
                                              onPressed: () async {
                                                ApiServices().addTransaction(
                                                    transactionMethod: AppConstants
                                                        .Transaction_Method_Payment,
                                                    tagItId: "2",
                                                    tagItName: AppConstants
                                                        .TAG_IT_Transaction_TYPE_DEBIT_CARD_V,
                                                    selectedKidName: 'food',
                                                    accountHolderName: 'food',
                                                    amount: appsController.text
                                                        .trim(),
                                                    currentUserId: appConstants
                                                        .userRegisteredId,
                                                    receiverId: appConstants
                                                        .userRegisteredId,
                                                    requestType: AppConstants
                                                        .TAG_IT_Transaction_TYPE_DEBIT_CARD_V,
                                                    senderId: appConstants
                                                        .userRegisteredId,
                                                    message: '',
                                                    fromWallet: AppConstants
                                                        .Spend_Wallet,
                                                    toWallet: AppConstants
                                                        .Spend_Wallet);

                                                Map<String, dynamic>? data =
                                                    await ApiServices()
                                                        .getKidSpendingLimit(
                                                            appConstants
                                                                .userModel
                                                                .userFamilyId!,
                                                            selectedUserId);
                                                if (data != null) {
                                                  ApiServices().updateSpendingRemain(
                                                      amount: int.parse(
                                                          allowanceController
                                                              .text),
                                                      fieldName: AppConstants
                                                          .SpendL_TAGID0001_Remain,
                                                      id: selectedUserId,
                                                      parentId: appConstants
                                                          .userModel
                                                          .userFamilyId);
                                                  // logMethod(title: 'Secreat Debit Card', message: '${data[AppConstants.SpendL_company_id_100]}');
                                                }
                                                return;
                                              },
                                            ),

                                            spacing_medium,
                                            Text(
                                              'MCC ID: 005',
                                              style: heading3TextStyle(width),
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  'Electronics',
                                                  style:
                                                      heading3TextStyle(width),
                                                ),
                                                Expanded(
                                                  child: AllocationCustomFields(
                                                      width: width,
                                                      controller:
                                                          mc_id_005Controller),
                                                ),
                                              ],
                                            ),
                                            spacing_large,
                                            ZakiPrimaryButton(
                                              title: 'Send',
                                              width: width,
                                              onPressed: () async {
                                                ApiServices().addTransaction(
                                                    transactionMethod: AppConstants
                                                        .Transaction_Method_Payment,
                                                    tagItId: "2",
                                                    tagItName: AppConstants
                                                        .TAG_IT_Transaction_TYPE_DEBIT_CARD_V,
                                                    selectedKidName:
                                                        'Electronics',
                                                    accountHolderName:
                                                        'Electronics',
                                                    amount: appsController.text
                                                        .trim(),
                                                    currentUserId: appConstants
                                                        .userRegisteredId,
                                                    receiverId: appConstants
                                                        .userRegisteredId,
                                                    requestType: AppConstants
                                                        .TAG_IT_Transaction_TYPE_DEBIT_CARD_V,
                                                    senderId: appConstants
                                                        .userRegisteredId,
                                                    message: '',
                                                    fromWallet: AppConstants
                                                        .Spend_Wallet,
                                                    toWallet: AppConstants
                                                        .Spend_Wallet);

                                                Map<String, dynamic>? data =
                                                    await ApiServices()
                                                        .getKidSpendingLimit(
                                                            appConstants
                                                                .userModel
                                                                .userFamilyId!,
                                                            selectedUserId);
                                                if (data != null) {
                                                  ApiServices().updateSpendingRemain(
                                                      amount: int.parse(
                                                          allowanceController
                                                              .text),
                                                      fieldName: AppConstants
                                                          .SpendL_TAGID0001_Remain,
                                                      id: selectedUserId,
                                                      parentId: appConstants
                                                          .userModel
                                                          .userFamilyId);
                                                  // logMethod(title: 'Secreat Debit Card', message: '${data[AppConstants.SpendL_company_id_002]}');
                                                }
                                                return;
                                              },
                                            ),

                                            spacing_medium,

                                            Text(
                                              'MCC ID: 006',
                                              style: heading3TextStyle(width),
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  'Video Games',
                                                  style:
                                                      heading3TextStyle(width),
                                                ),
                                                Expanded(
                                                  child: AllocationCustomFields(
                                                      width: width,
                                                      controller:
                                                          mc_id_006Controller),
                                                ),
                                              ],
                                            ),
                                            spacing_large,
                                            ZakiPrimaryButton(
                                              title: 'Send',
                                              width: width,
                                              onPressed: () async {
                                                ApiServices().addTransaction(
                                                    transactionMethod: AppConstants
                                                        .Transaction_Method_Payment,
                                                    tagItId: "2",
                                                    tagItName: AppConstants
                                                        .TAG_IT_Transaction_TYPE_DEBIT_CARD_V,
                                                    selectedKidName:
                                                        'Video Games',
                                                    accountHolderName:
                                                        'Video Games',
                                                    amount: appsController.text
                                                        .trim(),
                                                    currentUserId: appConstants
                                                        .userRegisteredId,
                                                    receiverId: appConstants
                                                        .userRegisteredId,
                                                    requestType: AppConstants
                                                        .TAG_IT_Transaction_TYPE_DEBIT_CARD_V,
                                                    senderId: appConstants
                                                        .userRegisteredId,
                                                    message: '',
                                                    fromWallet: AppConstants
                                                        .Spend_Wallet,
                                                    toWallet: AppConstants
                                                        .Spend_Wallet);

                                                Map<String, dynamic>? data =
                                                    await ApiServices()
                                                        .getKidSpendingLimit(
                                                            appConstants
                                                                .userModel
                                                                .userFamilyId!,
                                                            selectedUserId);
                                                if (data != null) {
                                                  ApiServices().updateSpendingRemain(
                                                      amount: int.parse(
                                                          allowanceController
                                                              .text),
                                                      fieldName: AppConstants
                                                          .SpendL_TAGID0001_Remain,
                                                      id: selectedUserId,
                                                      parentId: appConstants
                                                          .userModel
                                                          .userFamilyId);
                                                  // logMethod(title: 'Secreat Debit Card', message: '${data[AppConstants.SpendL_company_id_300]}');
                                                }
                                                return;
                                              },
                                            ),

                                            spacing_medium,

                                            Text(
                                              'MCC ID: 001',
                                              style: heading3TextStyle(width),
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  'Mcdonald',
                                                  style:
                                                      heading3TextStyle(width),
                                                ),
                                                Expanded(
                                                  child: AllocationCustomFields(
                                                      width: width,
                                                      controller:
                                                          appsController),
                                                ),
                                              ],
                                            ),
                                            spacing_large,
                                            ZakiPrimaryButton(
                                              title: 'Send',
                                              width: width,
                                              onPressed: () async {
                                                ApiServices().addTransaction(
                                                    transactionMethod: AppConstants
                                                        .Transaction_Method_Payment,
                                                    tagItId: "2",
                                                    tagItName: AppConstants
                                                        .TAG_IT_Transaction_TYPE_DEBIT_CARD_V,
                                                    selectedKidName: 'mcdonald',
                                                    accountHolderName:
                                                        'mcdonald',
                                                    amount: appsController.text
                                                        .trim(),
                                                    currentUserId: appConstants
                                                        .userRegisteredId,
                                                    receiverId: appConstants
                                                        .userRegisteredId,
                                                    requestType: AppConstants
                                                        .TAG_IT_Transaction_TYPE_DEBIT_CARD_V,
                                                    senderId: appConstants
                                                        .userRegisteredId,
                                                    message: '',
                                                    fromWallet: AppConstants
                                                        .Spend_Wallet,
                                                    toWallet: AppConstants
                                                        .Spend_Wallet);

                                                Map<String, dynamic>? data =
                                                    await ApiServices()
                                                        .getKidSpendingLimit(
                                                            appConstants
                                                                .userModel
                                                                .userFamilyId!,
                                                            selectedUserId);
                                                if (data != null) {
                                                  ApiServices().updateSpendingRemain(
                                                      amount: int.parse(
                                                          allowanceController
                                                              .text),
                                                      fieldName: AppConstants
                                                          .SpendL_TAGID0001_Remain,
                                                      id: selectedUserId,
                                                      parentId: appConstants
                                                          .userModel
                                                          .userFamilyId);
                                                  logMethod(
                                                      title:
                                                          'Secreat Debit Card',
                                                      message:
                                                          '${data[AppConstants.SpendL_TAGID0001_mcc_id]}');
                                                }
                                                return;

                                                // ApiServices().addTransaction(
                                                //   transactionMethod: AppConstants.Transaction_Method_Payment,
                                                //   tagItId: "2",
                                                //   tagItName:AppConstants.TAG_IT_Transaction_TYPE_DEBIT_CARD_P,
                                                //   selectedKidName: 'Dominos',
                                                //   accountHolderName: 'Dominos',
                                                //   amount: appsController.text.trim(),
                                                //   currentUserId: appConstants.userRegisteredId,
                                                //   receiverId: appConstants.userRegisteredId,
                                                //   requestType: AppConstants.TAG_IT_Transaction_TYPE_DEBIT_CARD_P,
                                                //   senderId: appConstants.userRegisteredId,
                                                //   message: '',
                                                //   fromWallet: AppConstants.Spend_Wallet,
                                                //   toWallet: AppConstants.Spend_Wallet
                                                //   );

                                                // CreaditCardApi creaditCardApi = CreaditCardApi();
                                                // creaditCardApi.spendControll(
                                                //   amount:appsController.text.trim(),
                                                //   mcc: '1700'
                                                // );
                                                // creaditCardApi.addCardSpendingLimits(
                                                //         parentId: appConstants.userRegisteredId,
                                                //         userId: selectedUserId,
                                                //         amount: int.parse(appsController.text.trim()),
                                                //         mcc: '1700');
                                              },
                                            ),

                                            spacing_medium,
                                            Text(
                                              'MCC ID: 002',
                                              style: heading3TextStyle(width),
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  'Pizza Hut',
                                                  style:
                                                      heading3TextStyle(width),
                                                ),
                                                Expanded(
                                                  child: AllocationCustomFields(
                                                      width: width,
                                                      controller:
                                                          allowanceController),
                                                ),
                                              ],
                                            ),
                                            spacing_large,
                                            ZakiPrimaryButton(
                                              title: 'Send',
                                              width: width,
                                              onPressed: () async {
                                                ApiServices().addTransaction(
                                                    transactionMethod: AppConstants
                                                        .Transaction_Method_Payment,
                                                    tagItId: "2",
                                                    tagItName: AppConstants
                                                        .TAG_IT_Transaction_TYPE_DEBIT_CARD_V,
                                                    selectedKidName:
                                                        'Pizza Hut',
                                                    accountHolderName:
                                                        'Pizza Hut',
                                                    amount: appsController.text
                                                        .trim(),
                                                    currentUserId: appConstants
                                                        .userRegisteredId,
                                                    receiverId: appConstants
                                                        .userRegisteredId,
                                                    requestType: AppConstants
                                                        .TAG_IT_Transaction_TYPE_DEBIT_CARD_V,
                                                    senderId: appConstants
                                                        .userRegisteredId,
                                                    message: '',
                                                    fromWallet: AppConstants
                                                        .Spend_Wallet,
                                                    toWallet: AppConstants
                                                        .Spend_Wallet);

                                                Map<String, dynamic>? data =
                                                    await ApiServices()
                                                        .getKidSpendingLimit(
                                                            appConstants
                                                                .userModel
                                                                .userFamilyId!,
                                                            selectedUserId);
                                                if (data != null) {
                                                  ApiServices().updateSpendingRemain(
                                                      amount: int.parse(
                                                          allowanceController
                                                              .text),
                                                      fieldName: AppConstants
                                                          .SpendL_TAGID0001_Remain,
                                                      id: selectedUserId,
                                                      parentId: appConstants
                                                          .userModel
                                                          .userFamilyId);
                                                  logMethod(
                                                      title:
                                                          'Secreat Debit Card',
                                                      message:
                                                          '${data[AppConstants.SpendL_company_id_001]}');
                                                }
                                                return;
                                                // CreaditCardApi creaditCardApi = CreaditCardApi();
                                                // creaditCardApi.spendControll(
                                                //   amount:allowanceController.text.trim(),
                                                //   mcc: '1700'
                                                // );
                                                // creaditCardApi.addCardSpendingLimits(
                                                //         parentId: appConstants.userRegisteredId,
                                                //         userId: selectedUserId,
                                                //         amount: int.parse(allowanceController.text.trim()),
                                                //         mcc: '1700');
                                              },
                                            ),
                                            spacing_medium,
                                            Text(
                                              'MCC ID: 003',
                                              style: heading3TextStyle(width),
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  'KFC',
                                                  style:
                                                      heading3TextStyle(width),
                                                ),
                                                Expanded(
                                                  child: AllocationCustomFields(
                                                      width: width,
                                                      controller:
                                                          electronicsController),
                                                ),
                                              ],
                                            ),
                                            spacing_large,
                                            ZakiPrimaryButton(
                                              title: 'Send',
                                              width: width,
                                              onPressed: () async {
                                                ApiServices().addTransaction(
                                                    transactionMethod: AppConstants
                                                        .Transaction_Method_Payment,
                                                    tagItId: "2",
                                                    tagItName: AppConstants
                                                        .TAG_IT_Transaction_TYPE_DEBIT_CARD_V,
                                                    selectedKidName:
                                                        'Zara Cloth',
                                                    accountHolderName: 'Zara',
                                                    amount: appsController.text
                                                        .trim(),
                                                    currentUserId: appConstants
                                                        .userRegisteredId,
                                                    receiverId: appConstants
                                                        .userRegisteredId,
                                                    requestType: AppConstants
                                                        .TAG_IT_Transaction_TYPE_DEBIT_CARD_V,
                                                    senderId: appConstants
                                                        .userRegisteredId,
                                                    message: '',
                                                    fromWallet: AppConstants
                                                        .Spend_Wallet,
                                                    toWallet: AppConstants
                                                        .Spend_Wallet);

                                                Map<String, dynamic>? data =
                                                    await ApiServices()
                                                        .getKidSpendingLimit(
                                                            appConstants
                                                                .userModel
                                                                .userFamilyId!,
                                                            selectedUserId);
                                                if (data != null) {
                                                  ApiServices().updateSpendingRemain(
                                                      amount: int.parse(
                                                          allowanceController
                                                              .text),
                                                      fieldName: AppConstants
                                                          .SpendL_TAGID0001_Remain,
                                                      id: selectedUserId,
                                                      parentId: appConstants
                                                          .userModel
                                                          .userFamilyId);
                                                  logMethod(
                                                      title:
                                                          'Secreat Debit Card',
                                                      message:
                                                          '${data[AppConstants.SpendL_company_id_002]}');
                                                }
                                                return;
                                                // CreaditCardApi creaditCardApi = CreaditCardApi();
                                                // creaditCardApi.spendControll(
                                                //   amount:electronicsController.text.trim(),
                                                //   mcc: '1700'
                                                // );
                                                // creaditCardApi.addCardSpendingLimits(
                                                //         parentId: appConstants.userRegisteredId,
                                                //         userId: selectedUserId,
                                                //         amount: int.parse(electronicsController.text.trim()),
                                                //         mcc: '1700');
                                              },
                                            )
                                          ]),
                              ],
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (cardAlreadyExist == true)
            Align(
              alignment: Alignment.center,
              child: Icon(
                Icons.lock_outline,
                color: grey.withOpacity(0.4),
                size: height * 0.2,
              ),
            )
        ],
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Container CreaditCard(double width, AppConstants appConstants, double height,
      {dynamic snapshot, String? selectedUserId}) {
    return Container(
      // Color(0XFF9831F5)
      height: height * 0.26,
      width: width,
      decoration: cardBackgroundConatiner(width, black,
          backgroundImageUrl: snapshot![AppConstants.ICard_backGroundImage]),
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              '${snapshot[AppConstants.ICard_firstName]} ${snapshot[AppConstants.ICard_lastName]}',
              style: heading2TextStyle(context, width, color: white),
            )
            // Column(
            //   crossAxisAlignment: CrossAxisAlignment.end,
            //   children: [
            //     Row(
            //       mainAxisAlignment: MainAxisAlignment.start,
            //       children: [

            //         // Transform.scale(
            //         //   scale: 0.7,
            //         //   child: CupertinoSwitch(
            //         //     value: snapshot[AppConstants.ICard_cardStatus],
            //         //     activeColor: white,
            //         //     thumbColor:
            //         //         snapshot[AppConstants.ICard_cardStatus] == false
            //         //             ? red
            //         //             : green,
            //         //     trackColor: white,
            //         //     onChanged: (value) async {
            //         //       appConstants.updateForCardLockStatus(from: false);
            //         //       var response = await Navigator.push(
            //         //           context,
            //         //           MaterialPageRoute(
            //         //               builder: (context) => ActivateCard(
            //         //                     snapShot: snapshot,
            //         //                   )));
            //         //       logMethod(
            //         //           title: 'PIN Code match status:',
            //         //           message: response ?? 'Not');
            //         //       if (response != null) {
            //         //         ApiServices apiServices = ApiServices();
            //         //         await apiServices.updateCardStatus(
            //         //             id: cardAlreadyExist.id,
            //         //             parentId: appConstants.userRegisteredId,
            //         //             status: value);
            //         //       }
            //         //     },
            //         //   ),
            //         // ),
            //       ],
            //     ),
            //     // TextValue2(
            //     //   title: 'Balance: \n50.00 ${getCurrencySymbol(context, appConstants: appConstants )}',
            //     // ),
            //   ],
            // ),
            // spacing_medium,
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     TextValue2(
            //       title: '**** 1289',
            //     ),
            //     TextHeader1(
            //       title: '09/25',
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }

  void cardInformation(
      BuildContext? context, double? width, double? height, String? name) {
    showModalBottomSheet(
        context: context!,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(width! * 0.09),
            topRight: Radius.circular(width * 0.09),
          ),
        ),
        builder: (BuildContext bc) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(bc);
                      },
                      child: Container(
                        width: width * 0.2,
                        height: 5,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(width * 0.08),
                            color: grey),
                      ),
                    ),
                  ),
                  TextHeader1(
                    title: 'ZakiPay Card Info',
                  ),
                  spacing_large,
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: width * 0.08,
                      vertical: width * 0.01,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Card Holder name',
                          style: heading1TextStyle(
                            context,
                            width,
                          ),
                        ),
                        CustomSizedBox(
                          height: height,
                        ),
                        Text(
                          name ?? '',
                          style: heading3TextStyle(width),
                        ),
                        const CustomDivider(),
                        Text(
                          'Card Number',
                          style: heading1TextStyle(
                            context,
                            width,
                          ),
                        ),
                        CustomSizedBox(
                          height: height,
                        ),
                        Text(
                          '',
                          style: heading3TextStyle(width),
                        ),
                        const CustomDivider(),
                        Row(
                          children: [
                            Expanded(
                                child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 2.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Expiration date',
                                    style: heading1TextStyle(
                                      context,
                                      width,
                                    ),
                                  ),
                                  CustomSizedBox(
                                    height: height,
                                  ),
                                  Text(
                                    '03/22',
                                    style: heading3TextStyle(
                                      width,
                                    ),
                                  ),
                                  const CustomDivider(),
                                ],
                              ),
                            )),
                            Expanded(
                              child: const SizedBox(
                                width: 10,
                              ),
                            )
                            // const SizedBox(
                            //   width: 10,
                            // ),
                            // Expanded(
                            //     child: Padding(
                            //   padding:
                            //       const EdgeInsets.symmetric(horizontal: 2.0),
                            //   child: Column(
                            //     crossAxisAlignment: CrossAxisAlignment.start,
                            //     children: [
                            //       Text(
                            //         'Security Code',
                            //         style: heading1TextStyle(
                            //   context, width,),
                            //       ),
                            //       CustomSizedBox(
                            //         height: height,
                            //       ),
                            //       Text(
                            //         '****',
                            //         style: heading3TextStyle(width,),
                            //       ),
                            //       const CustomDivider(),
                            //     ],
                            //   ),
                            // )
                            // )
                          ],
                        ),
                        spacing_medium
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}

class WalletCustomWidget extends StatelessWidget {
  const WalletCustomWidget(
      {Key? key, required this.width, this.imageUrl, this.subTitle, this.title})
      : super(key: key);

  final double width;
  final String? title;
  final String? subTitle;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(10), color: black),
      child: Padding(
        padding: const EdgeInsets.all(6.5),
        child: Row(
          children: [
            Image.asset(
              imageBaseAddress + '$imageUrl.png',
              height: 38,
              width: 38,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 4.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$title',
                    style: heading2TextStyle(context, width,
                        color: white, font: 11),
                  ),
                  Text('$subTitle',
                      style: heading1TextStyle(context, width,
                          color: white, font: 13)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ManageDebitCardTile extends StatelessWidget {
  const ManageDebitCardTile({Key? key, this.title, this.onTap, this.imageUrl})
      : super(key: key);
  final String? title;
  final VoidCallback? onTap;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          // Icon(Icons.add_card, color: black),
          Image.asset(
            imageBaseAddress + '$imageUrl.png',
            height: 30,
            width: 30,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Text(
              '$title',
              style: heading3TextStyle(width),
            ),
          ),
          const Spacer(),
          Icon(
            Icons.arrow_forward,
            color: grey,
          )
        ],
      ),
    );
  }
}
