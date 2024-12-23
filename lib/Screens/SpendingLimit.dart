// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:ndialog/ndialog.dart';
import 'package:provider/provider.dart';
import 'package:zaki/Constants/AuthMethods.dart';
import 'package:zaki/Constants/CheckInternetConnections.dart';
import 'package:zaki/Constants/NotificationTitle.dart';
import 'package:zaki/Constants/Spacing.dart';
import 'package:zaki/Screens/IssueAndManageCards.dart';
import 'package:zaki/Widgets/AppBars/AppBar.dart';
import 'package:zaki/Widgets/CustomLoadingScreen.dart';
import 'package:zaki/Widgets/ReadOnlyCustomWidget.dart';
import 'package:zaki/Widgets/TextHeader.dart';

import '../Constants/AppConstants.dart';
import '../Constants/HelperFunctions.dart';
import '../Constants/Styles.dart';
import '../Services/api.dart';
import '../Widgets/CustomTextButon.dart';
import '../Widgets/CustomTextField.dart';
import '../Widgets/UnSelectedKidsWidget.dart';
import '../Widgets/ZakiPrimaryButton.dart';
import 'IssueDebitCardFields.dart';

class SpendingLimit extends StatefulWidget {
  final String? selectedId;
  SpendingLimit({Key? key, this.selectedId}) : super(key: key);

  @override
  State<SpendingLimit> createState() => _SpendingLimitState();
}

class _SpendingLimitState extends State<SpendingLimit> {
  var kidsOrNOt = [
    'Yes',
    'No',
  ];
  int selectedIndex = -1;
  Stream<QuerySnapshot>? userKids;
  String selectedUserId = '';
  List<String> listOfKidsId = [];
  bool maxSpendPerTransactionExist = false;
  String tokenOfMaxSpendControllPerTransaction = '';
  // String? totalAmount, String? appsAmount, String? charityAmount, String? educationalAmount,
  // String? electronicsAmount, String? foodAmount, String? giftsAmount,
  // String? groceriesAmount, String? gasStationAmount, String? moviesAmount,
  // String? otherStuffsAmount, String? shoppingAmount, String? videoGamesAmount
  final totalAmountController = TextEditingController();
  final TextEditingController dailyAmountController= TextEditingController();
  final appsAmountController = TextEditingController();
  final charityAmountController = TextEditingController();
  final educationalAmountController = TextEditingController();
  final electronicsAmountController = TextEditingController();
  final foodAmountController = TextEditingController();
  final giftsAmountController = TextEditingController();
  final groceriesAmountController = TextEditingController();
  final gasStationAmountController = TextEditingController();
  final moviesAmountController = TextEditingController();
  final otherStuffsAmountController = TextEditingController();
  final shoppingAmountController = TextEditingController();
  final videoGamesAmountController = TextEditingController();
  final mccAmountController = TextEditingController();
  dynamic cardAlreadyExist = false;

  @override
  void initState() {
    super.initState();
    getUserKids();
  }

  resetFields() {
    appsAmountController.text = '';
    dailyAmountController.text = '';
    charityAmountController.text = '';
    educationalAmountController.text = '';
    electronicsAmountController.text = '';
    foodAmountController.text = '';
    giftsAmountController.text = '';
    groceriesAmountController.text = '';
    gasStationAmountController.text = '';
    moviesAmountController.text = '';
    otherStuffsAmountController.text = '';
    shoppingAmountController.text = '';
    videoGamesAmountController.text = '';
  }

  getUserKids() {
    Future.delayed(const Duration(milliseconds: 200), () async {
      var appConstants = Provider.of<AppConstants>(context, listen: false);
      bool screenNotOpen =
          await checkUserSubscriptionValue(appConstants, context);
      logMethod(title: 'Data from Pay+', message: screenNotOpen.toString());
      if (screenNotOpen == true) {
        Navigator.pop(context);
      } else {
        // setState(() {

        // if(widget.selectedId!=null){
        //   setState(() {
        //   selectedIndex = 0;
        //   selectedUserId=widget.selectedId.toString();
        //   // cardAlreadyExist = cardExist;
        //   getUserKidSpendingLimits(
        //     parentId:appConstants.userRegisteredId,
        //     kidId: widget.selectedId);

        //   });
        //   // });
        // }
        appConstants.updateMaximunSpendTransaction(true);
        if (appConstants.userModel.usaUserType !=
            AppConstants.USER_TYPE_PARENT) {
          getUserKidSpendingLimits(
              parentId: appConstants.userModel.userFamilyId,
              kidId: appConstants.userRegisteredId);
        }
        setState(() {
          // appConstants.updateHaveKid(true);
          if (appConstants.userModel.usaUserType ==
              AppConstants.USER_TYPE_PARENT)
            userKids = ApiServices().fetchUserKids(
                appConstants.userModel.seeKids == true
                    ? appConstants.userModel.userFamilyId!
                    : appConstants.userRegisteredId,
                currentUserId: appConstants.userRegisteredId);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var appConstants = Provider.of<AppConstants>(context, listen: true);
    var internet = Provider.of<CheckInternet>(context, listen: true);
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Stack(
            children: [
              if(appConstants.userModel.usaUserType !=
                    AppConstants.USER_TYPE_PARENT)
              ReadOnlyCustomWidget(width: width, height: height),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: getCustomPadding(),
                    child: appBarHeader_005(
                      context: context,
                      appBarTitle: 'Spend Limits',
                      height: height,
                      width: width, 
                    ),
                  ),
                  (appConstants.userModel.usaUserType !=
                          AppConstants.USER_TYPE_PARENT)
                      ? const SizedBox.shrink()
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: getCustomPadding(),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  TextHeader1( 
                                    title: 'Apply spend limits to all kids?',
                                  ),
                                  Switch.adaptive(
                                    // value: appConstants.touchIdAllowOrNot,
                                    activeColor: green,
                                    value: appConstants.applyToKids,
                                    // activeColor: primaryButtonColor,
                                    // trackColor: grey,
                                    onChanged: (appConstants
                                                    .userModel.usaUserType ==
                                                AppConstants.USER_TYPE_KID ||
                                            appConstants.userModel.usaUserType ==
                                                AppConstants.USER_TYPE_ADULT)
                                        ? null
                                        : (value) async {
                                            appConstants.updateApplyToKids(value);
                                          },
                                  ),
                                ],
                              ),
                            ),
                            if (!appConstants.applyToKids) spacing_large,
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 400),
                              transitionBuilder: (child, animation) {
                                return SlideTransition(
                                  position: animation.drive(Tween(
                                    begin: const Offset(1.0, 0.0),
                                    end: const Offset(0.0, 0.0),
                                  )),
                                  child: child,
                                );
                              },
                              child: appConstants.applyToKids == true
                                  ? const SizedBox()
                                  : userKids == null
                                      ? const SizedBox()
                                      : Container(
                                          width: width,
                                          height: height * 0.127,
                                          color: green.withOpacity(0.05),
                                          child: Padding(
                                            padding: getCustomPadding(),
                                            child: StreamBuilder<QuerySnapshot>(
                                              stream: userKids,
                                              builder: (BuildContext context,
                                                  AsyncSnapshot<QuerySnapshot>
                                                      snapshot) {
                                                if (snapshot.hasError) {
                                                  return const Text(
                                                      'Ooops...Something went wrong');
                                                }
              
                                                if (snapshot.connectionState ==
                                                    ConnectionState.waiting) {
                                                  return const Text("");
                                                }
                                                if (snapshot.data!.size == 0) {
                                                  return const Center(
                                                      child: Text(""));
                                                }
                                                //snapshot.data!.docs[index] ['USA_first_name']
                                                return ListView.builder(
                                                  itemCount:
                                                      snapshot.data!.docs.length,
                                                  physics:
                                                      const BouncingScrollPhysics(),
                                                  shrinkWrap: true,
                                                  scrollDirection: Axis.horizontal,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    // List<String> ids =[];
                                                    SchedulerBinding.instance
                                                        .addPostFrameCallback(
                                                            (_) async {
                                                      // if(widget.selectedId!=null && snapshot.data!.docs[index].id==widget.selectedId){
                                                      //   selectedUserId=widget.selectedId.toString();
              
                                                      //   ApiServices
                                                      //         apiServices =
                                                      //         ApiServices();
                                                      //     dynamic cardExist =
                                                      //         await apiServices
                                                      //             .checkCardExist(
                                                      //                 parentId:
                                                      //                     appConstants
                                                      //                         .userRegisteredId,
                                                      //                 id: snapshot
                                                      //                     .data!
                                                      //                     .docs[
                                                      //                         0]
                                                      //                     .id);
                                                      //     setState(() {
                                                      //       selectedIndex = 0;
                                                      //       cardAlreadyExist =
                                                      //           cardExist;
                                                      //       getUserKidSpendingLimits(
                                                      //           parentId:
                                                      //               appConstants
                                                      //                   .userRegisteredId,
                                                      //           kidId: snapshot
                                                      //               .data!
                                                      //               .docs[0]
                                                      //               .id);
                                                      //     });
                                                      // }
                                                      // else
                                                      if (
                                                          // snapshot.data!.docs[
                                                          //               index][
                                                          //           AppConstants
                                                          //               .NewMember_isEnabled] ==
                                                          //       false ||
                                                          (snapshot.data!
                                                                      .docs[index][
                                                                  AppConstants
                                                                      .USER_UserType] ==
                                                              AppConstants
                                                                  .USER_TYPE_KID)) {
                                                        if (!listOfKidsId.contains(
                                                            snapshot.data!
                                                                .docs[index].id)) {
                                                          listOfKidsId.add(snapshot
                                                              .data!
                                                              .docs[index]
                                                              .id);
                                                          ApiServices apiServices =
                                                              ApiServices();
                                                          dynamic cardExist =
                                                              await apiServices
                                                                  .checkCardExist(
                                                                      parentId: appConstants
                                                                          .userModel
                                                                          .userFamilyId,
                                                                      id: snapshot
                                                                          .data!
                                                                          .docs[0]
                                                                          .id);
                                                          setState(() {
                                                            selectedIndex = 0;
                                                            cardAlreadyExist =
                                                                cardExist;
                                                            getUserKidSpendingLimits(
                                                                parentId: appConstants
                                                                    .userModel
                                                                    .userFamilyId??appConstants.userRegisteredId,
                                                                kidId: snapshot
                                                                    .data!
                                                                    .docs[0]
                                                                    .id);
                                                          });
                                                        }
                                                        logMethod(
                                                            title: "Id is:",
                                                            message: snapshot.data!
                                                                .docs[index].id);
                                                      }
                                                    });
                                                    // print(snapshot.data!.docs[index] ['USA_first_name']);
                                                    return (
                                                            // snapshot.data!.docs[
                                                            //                   index][
                                                            //               AppConstants
                                                            //                   .NewMember_isEnabled] ==
                                                            //           false ||
                                                            (snapshot.data!
                                                                        .docs[index]
                                                                    [AppConstants
                                                                        .USER_UserType] !=
                                                                AppConstants
                                                                    .USER_TYPE_KID))
                                                        ? const SizedBox.shrink()
                                                        : InkWell(
                                                            onTap: () async {
                                                              if (selectedUserId !=
                                                                  snapshot
                                                                      .data!
                                                                      .docs[index]
                                                                      .id) {
                                                                dynamic cardExist = await ApiServices()
                                                                    .checkCardExist(
                                                                        parentId: appConstants
                                                                            .userModel
                                                                            .userFamilyId,
                                                                        id: snapshot
                                                                            .data!
                                                                            .docs[
                                                                                index]
                                                                            .id);
                                                                setState(() {
                                                                  selectedIndex =
                                                                      index;
                                                                  cardAlreadyExist =
                                                                      cardExist;
                                                                  selectedUserId =
                                                                      snapshot
                                                                          .data!
                                                                          .docs[
                                                                              index]
                                                                          .id;
                                                                });
                                                                logMethod(
                                                                    title:
                                                                        'Selected Kid Id: ',
                                                                    message:
                                                                        selectedUserId);
                                                                getUserKidSpendingLimits(
                                                                    parentId: appConstants
                                                                        .userModel
                                                                        .userFamilyId??appConstants.userRegisteredId,
                                                                    kidId: snapshot
                                                                        .data!
                                                                        .docs[index]
                                                                        .id);
                                                              }
                                                            },
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      right: 12.0),
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Stack(
                                                                    children: [
                                                                      Container(
                                                                        height: 70,
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
                                                                              imageUrl: snapshot
                                                                                  .data!
                                                                                  .docs[index][AppConstants.USER_Logo],
                                                                              userType: snapshot
                                                                                  .data!
                                                                                  .docs[index][AppConstants.USER_UserType],
                                                                              width:
                                                                                  width,
                                                                              gender: snapshot
                                                                                  .data!
                                                                                  .docs[index][AppConstants.USER_gender],
                                                                            )),
                                                                      ),
                                                                      if (selectedIndex !=
                                                                          index)
                                                                        UnSelectedKidsWidget()
                                                                    ],
                                                                  ),
                                                                  SizedBox(
                                                                    height: 5,
                                                                  ),
                                                                  SizedBox(
                                                                    // width: height * 0.065,
                                                                    child: Center(
                                                                      child: Text(
                                                                        (snapshot.data!.docs[index][AppConstants.USER_user_name] ==
                                                                                    null ||
                                                                                snapshot.data!.docs[index][AppConstants.USER_user_name] ==
                                                                                    '')
                                                                            ? snapshot.data!.docs[index]
                                                                                [
                                                                                AppConstants
                                                                                    .USER_first_name]
                                                                            : '@ ' +
                                                                                snapshot.data!.docs[index][AppConstants.USER_user_name],
                                                                        overflow:
                                                                            TextOverflow
                                                                                .fade,
                                                                        maxLines: 1,
                                                                        style: heading5TextSmall(
                                                                            width),
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
                            ),
                            spacing_large,
                            // (cardAlreadyExist == false && selectedUserId != '')
                            //     ? const SizedBox.shrink()
                            //     :
                          ],
                        ),
                  Padding(
                    padding: getCustomPadding(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextHeader1(
                              title: 'Max spend per transaction:',
                            ),
                            (appConstants.userModel.usaUserType !=
                                    AppConstants.USER_TYPE_PARENT)
                                ? const SizedBox.shrink()
                                : Switch.adaptive(
                                    value: appConstants.setMaxSpendTransaction,
                                    activeColor: primaryButtonColor,
                                    onChanged: (value) async {
                                      appConstants
                                          .updateMaximunSpendTransaction(value);
                                    },
                                  ),
                          ],
                        ),
              
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 400),
                          transitionBuilder: (child, animation) {
                            return SlideTransition(
                              position: animation.drive(Tween(
                                begin: const Offset(1.0, 0.0),
                                end: const Offset(0.0, 0.0),
                              )),
                              child: child,
                            );
                          },
                          child: !appConstants.setMaxSpendTransaction
                              ? const SizedBox()
                              :
                              // (cardAlreadyExist == false && selectedUserId != '')
                              //     ? const SizedBox.shrink()
                              //     :
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                child: CustomTextField(
                                    amountController: totalAmountController,
                                    readOnly: (appConstants.userModel.usaUserType !=
                                            AppConstants.USER_TYPE_PARENT)
                                        ? true
                                        : false,
                                    textFieldColor: (appConstants.userModel.usaUserType !=
                    AppConstants.USER_TYPE_PARENT)?grey.withOpacity(0.5): green,
                                  ),
                              ),
                        ),
                        // cardAlreadyExist == false ? SizedBox.shrink() :
                        spacing_large,
                        TextHeader1(
                              title: 'Max spend per day:',
                            ),
                        Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                child: CustomTextField(
                                    amountController: dailyAmountController,
                                    readOnly: (appConstants.userModel.usaUserType !=
                                            AppConstants.USER_TYPE_PARENT)
                                        ? true
                                        : false,
                                    textFieldColor: (appConstants.userModel.usaUserType !=
                    AppConstants.USER_TYPE_PARENT)?grey.withOpacity(0.5): green,
                                  ),
                              ),
                        spacing_large,
                        // cardAlreadyExist == false
                        //     ? const SizedBox.shrink()
                        //     :
                        TextHeader1(
                          title: 'Monthly spend limit per category:',
                        ),
                        spacing_medium,
                        // (cardAlreadyExist == false && selectedUserId != '')
                        //     ? NoCardFound(
                        //         selectedUserId: selectedUserId,
                        //       )
                        //     :
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppConstants.TAGID0005,
                                style: heading3TextStyle(width),
                              ),
                              AllocationCustomFields(
                                  width: width, controller: foodAmountController),
                              spacing_medium,
                              Text(
                                AppConstants.TAGID0003,
                                style: heading3TextStyle(width),
                              ),
                              AllocationCustomFields(
                                width: width,
                                controller: charityAmountController,
                              ),
                              spacing_medium,
                              Text(
                                AppConstants.TAGID0006,
                                style: heading3TextStyle(width),
                              ),
                              AllocationCustomFields(
                                  width: width, controller: giftsAmountController),
                              spacing_medium,
                              Text(
                                AppConstants.TAGID0007,
                                style: heading3TextStyle(width),
                              ),
                              AllocationCustomFields(
                                  width: width,
                                  controller: groceriesAmountController),
                              spacing_medium,
                              Text(
                                AppConstants.TAGID0001,
                                style: heading3TextStyle(width),
                              ),
                              AllocationCustomFields(
                                width: width,
                                controller: appsAmountController,
                              ),
                              spacing_medium,
                              Text(
                                AppConstants.TAGID0008,
                                style: heading3TextStyle(width),
                              ),
                              AllocationCustomFields(
                                  width: width,
                                  controller: gasStationAmountController),
                              spacing_medium,
                              Text(
                                AppConstants.TAGID0009,
                                style: heading3TextStyle(width),
                              ),
                              AllocationCustomFields(
                                  width: width, controller: moviesAmountController),
                              spacing_medium,
                              Text(
                                AppConstants.TAGID0002,
                                style: heading3TextStyle(width),
                              ),
                              AllocationCustomFields(
                                  width: width,
                                  controller: educationalAmountController),
                              spacing_medium,
                              // Text(
                              //   AppConstants.TAGID0004,
                              //   style: heading3TextStyle(width),
                              // ),
                              // AllocationCustomFields(
                              //     width: width,
                              //     controller: electronicsAmountController),
                              // spacing_medium,
                              Text(
                                AppConstants.TAGID0010,
                                style: heading3TextStyle(width),
                              ),
                              AllocationCustomFields(
                                  width: width,
                                  controller: otherStuffsAmountController),
                              spacing_medium,
                              Text(
                                AppConstants.TAGID0011,
                                style: heading3TextStyle(width),
                              ),
                              AllocationCustomFields(
                                  width: width,
                                  controller: shoppingAmountController),
                              // spacing_medium,
                              // Text(
                              //   AppConstants.TAGID0012,
                              //   style: heading3TextStyle(width),
                              // ),
                              // AllocationCustomFields(
                              //     width: width, controller: videoGamesAmountController),
              
                              spacing_large,
                            ],
                          ),
                        ),
                        // (cardAlreadyExist == false && selectedUserId != '')
                        //     ? const SizedBox.shrink()
                        //     :
                        (appConstants.userModel.usaUserType !=
                                AppConstants.USER_TYPE_PARENT)
                            ? const SizedBox.shrink()
                            : Column(
                                children: [
                                  ZakiPrimaryButton(
                                    title: 'Save',
                                    width: width,
                                    onPressed: internet.status ==
                                            AppConstants
                                                .INTERNET_STATUS_NOT_CONNECTED
                                        ? null
                                        : () async {
                                          bool? checkAuth = await authenticateTransactionUsingBioOrPinCode(appConstants: appConstants, context: context);
                                                      if(checkAuth==false){
                                                        return;
                                                      }
                                            CustomProgressDialog progressDialog =
                                                CustomProgressDialog(context,
                                                    blur: 6);
                                            progressDialog.setLoadingWidget(
                                                CustomLoadingScreen());
                                            progressDialog.show();
              
                                            // CreaditCardApi creaditCardApi = CreaditCardApi();
                                            // String? selectedUserAccountNumber =
                                            //     await ApiServices().getAccountNumberFromId(
                                            //         userId:selectedUserId);
                                            // //If maxSpendPerTransactionExist == true then it means that its exist in marqata
              
                                            // String? tokenOfMaxSpendControll =
                                            //   maxSpendPerTransactionExist?
                                            //     await creaditCardApi.upDateSpendControllPerTransaction(
                                            //         userToken: selectedUserAccountNumber,
                                            //         amount: totalAmountController.text.trim().toString(),
                                            //         maxSpendControllToken: tokenOfMaxSpendControllPerTransaction,
                                            //         mcc: "as"):
              
                                            //     await creaditCardApi.spendControll(
                                            //         userToken: selectedUserAccountNumber,
                                            //         amount: totalAmountController.text
                                            //             .trim()
                                            //             .toString(),
                                            //         mcc: "as");
                                            // TAGID0003 = Charity
                                            // TAGID0002 = Education
                                            // TAGID0004 = Electronics
                                            // TAGID0005 = Fast Food
                                            // TAGID0006 = Gifts
                                            // TAGID0007 = Groceries
                                            // TAGID0008 = Gas Station
                                            // TAGID0009 = Movies
                                            // TAGID0010 = Other Stuff
                                            // TAGID0011 = Shopping
                                            // TAGID0012 = Video Games
                                            ApiServices services = ApiServices();
                                            if (appConstants.applyToKids == true) {
                                              
                                              listOfKidsId.forEach((element) async {
                                                logMethod(title: "Id of the user in list is:", message: element);
                                                await services
                                                    .addCardSpendingLimits(
                                                  parentId: appConstants
                                                    .userModel.userFamilyId??appConstants.userRegisteredId,
                                                  userId: element,
                                                  tAGID0001Amount:
                                                      appsAmountController.text,
                                                  tAGID0003Amount:
                                                      charityAmountController.text,
                                                  tAGID0002Amount:
                                                      educationalAmountController
                                                          .text,
                                                  // tAGID0004Amount:
                                                  //     electronicsAmountController.text,
                                                  tAGID0005Amount:
                                                      foodAmountController.text,
                                                  tAGID0008Amount:
                                                      gasStationAmountController
                                                          .text,
                                                  tAGID0006Amount:
                                                      giftsAmountController.text,
                                                  tAGID0007Amount:
                                                      groceriesAmountController
                                                          .text,
                                                  tAGID0009Amount:
                                                      moviesAmountController.text,
                                                  tAGID0010Amount:
                                                      otherStuffsAmountController
                                                          .text,
                                                  tAGID0011Amount:
                                                      shoppingAmountController.text,
                                                  // tAGID0012Amount:
                                                  //     videoGamesAmountController.text,
                                                  totalAmount:
                                                      totalAmountController.text,
                                                  dailyAmount: dailyAmountController.text
                                                  // tokenOfMaxSpendControll: tokenOfMaxSpendControll.toString(),
                                                );
                                              });
                                            } else {
                                              await services.addCardSpendingLimits(
                                                parentId: appConstants
                                                    .userModel.userFamilyId??appConstants.userRegisteredId,
                                                userId: selectedUserId,
                                                tAGID0001Amount:
                                                    appsAmountController.text,
                                                tAGID0003Amount:
                                                    charityAmountController.text,
                                                tAGID0002Amount:
                                                    educationalAmountController
                                                        .text,
                                                // tAGID0004Amount:
                                                //     electronicsAmountController.text,
                                                tAGID0005Amount:
                                                    foodAmountController.text,
                                                tAGID0008Amount:
                                                    gasStationAmountController.text,
                                                tAGID0006Amount:
                                                    giftsAmountController.text,
                                                tAGID0007Amount:
                                                    groceriesAmountController.text,
                                                tAGID0009Amount:
                                                    moviesAmountController.text,
                                                tAGID0010Amount:
                                                    otherStuffsAmountController
                                                        .text,
                                                tAGID0011Amount:
                                                    shoppingAmountController.text,
                                                // tAGID0012Amount:
                                                //     videoGamesAmountController.text,
                                                totalAmount:
                                                    totalAmountController.text,
                                                dailyAmount: dailyAmountController.text
                                                // tokenOfMaxSpendControll: tokenOfMaxSpendControll.toString(),
                                              );
                                            }
                                            progressDialog.dismiss();
                                            showNotification(
                                                error: 0,
                                                icon: Icons.check,
                                                message: NotificationText
                                                    .ADDED_SUCCESSFULLY);
                                            Navigator.pop(context);
                                          },
                                  ),
                                  spacing_medium,
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 6,
                                        child: CustomTextButton(
                                          width: width,
                                          title: 'Reset',
                                          onPressed: internet.status ==
                                                  AppConstants
                                                      .INTERNET_STATUS_NOT_CONNECTED
                                              ? null
                                              : () {
                                                  resetFields();
                                                },
                                        ),
                                      ),
                                      Expanded(
                                        flex: 4,
                                        child: SizedBox(),
                                      )
                                    ],
                                  )
                                ],
                              ),
                        // spacing_medium,
                        // Text(
                        //   'MCC',
                        //   style: heading3TextStyle(width),
                        // ),
                        // AllocationCustomFields(
                        //     width: width, controller: mccAmountController),
                        // spacing_large,
                        // ZakiPrimaryButton(
                        //   title: 'Card Spend Limit',
                        //   width: width,
                        //   onPressed: () {
                        //     CreaditCardApi creaditCardApi = CreaditCardApi();
                        //     creaditCardApi.spendControll(
                        //         amount: int.parse(mccAmountController.text.trim()),
                        //         mcc: '1700');
                        //     creaditCardApi.addCardSpendingLimits(
                        //         parentId: appConstants.userRegisteredId,
                        //         userId: selectedUserId,
                        //         amount: int.parse(mccAmountController.text.trim()),
                        //         mcc: '1700');
                        //   },
                        // )
                        //
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void getUserKidSpendingLimits({String? parentId, String? kidId}) async {
    logMethod(title: "Spend limit method called", message: "Parent Id: $parentId and Kid Id: $kidId");
    Map<String, dynamic>? data =
        await ApiServices().getKidSpendingLimit(parentId!, kidId!);
    if (data != null) {
      totalAmountController.text =
          data[AppConstants.SpendL_Transaction_Amount_Max].toString();
      dailyAmountController.text =
          data[AppConstants.SpendL_daily_Amount_Max].toString();
      appsAmountController.text =
          data[AppConstants.SpendL_TAGID0001_Max].toString();
      charityAmountController.text =
          data[AppConstants.SpendL_TAGID0003_Max].toString();
      educationalAmountController.text =
          data[AppConstants.SpendL_TAGID0002_Max].toString();
      electronicsAmountController.text =
          data[AppConstants.SpendL_TAGID0004_Max].toString();
      foodAmountController.text =
          data[AppConstants.SpendL_TAGID0005_Max].toString();
      giftsAmountController.text =
          data[AppConstants.SpendL_TAGID0006_Max].toString();
      groceriesAmountController.text =
          data[AppConstants.SpendL_TAGID0007_Max].toString();
      gasStationAmountController.text =
          data[AppConstants.SpendL_TAGID0008_Max].toString();
      moviesAmountController.text =
          data[AppConstants.SpendL_TAGID0009_Max].toString();
      otherStuffsAmountController.text =
          data[AppConstants.SpendL_TAGID0010_Max].toString();
      shoppingAmountController.text =
          data[AppConstants.SpendL_TAGID0011_Max].toString();
      videoGamesAmountController.text =
          data[AppConstants.SpendL_TAGID0012_Max].toString();
      logMethod(
          title: "Per transaction Spend Limit:",
          message: data[AppConstants.SpendL_TokenOfMaxSpendControllPerTran]
              .toString());
      tokenOfMaxSpendControllPerTransaction =
          data[AppConstants.SpendL_TokenOfMaxSpendControllPerTran].toString();
      maxSpendPerTransactionExist = true;
    } else {
      // appsAmountController.clear();
      // charityAmountController.clear();
      // educationalAmountController.clear();
      // electronicsAmountController.clear();
      // foodAmountController.clear();
      // giftsAmountController.clear();
      // groceriesAmountController.clear();
      // gasStationAmountController.clear();
      // moviesAmountController.clear();
      // otherStuffsAmountController.clear();
      // shoppingAmountController.clear();
      // videoGamesAmountController.clear();
      //
      appsAmountController.text = '';
      charityAmountController.text = '';
      educationalAmountController.text = '';
      electronicsAmountController.text = '';
      foodAmountController.text = '';
      giftsAmountController.text = '';
      groceriesAmountController.text = '';
      gasStationAmountController.text = '';
      moviesAmountController.text = '';
      otherStuffsAmountController.text = '';
      shoppingAmountController.text = '';
      videoGamesAmountController.text = '';
      tokenOfMaxSpendControllPerTransaction = '';
      maxSpendPerTransactionExist = false;
    }
    setState(() {});
  }
}



class NoCardFound extends StatelessWidget {
  final String? selectedUserId;
  const NoCardFound({Key? key, this.selectedUserId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var appConstants = Provider.of<AppConstants>(context, listen: true);
    return Column(
      children: [
        // spacing_medium,
        Image.asset(imageBaseAddress + 'ZakiPayNoDebitCard.png'),
        spacing_medium,
        ZakiPrimaryButton(
          title: 'Issue a Debit Card',
          width: double.infinity,
          onPressed: () async {
            String? cardAssigned = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        IssueDebitCardFields(selectedUserId: selectedUserId)));

            if (cardAssigned == "success") {
              ApiServices apiServices = ApiServices();
              // dynamic cardExist =
              await apiServices.checkCardExist(
                  parentId: appConstants.userModel.userFamilyId,
                  id: selectedUserId);
              // setState(() {
              //   cardAlreadyExist = cardExist;
              // });
            }
          },
        )
      ],
    );
  }
}

class AllocationCustomFields extends StatefulWidget {
  const AllocationCustomFields({
    Key? key,
    required this.width,
    required this.controller,
  }) : super(key: key);

  final double width;
  final TextEditingController controller;

  @override
  State<AllocationCustomFields> createState() => _AllocationCustomFieldsState();
}

class _AllocationCustomFieldsState extends State<AllocationCustomFields> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var appConstants = Provider.of<AppConstants>(context, listen: false);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: CustomTextField(
            amountController: widget.controller,
            validator: null,
            hintText: false,
            readOnly: (appConstants.userModel.usaUserType !=
                    AppConstants.USER_TYPE_PARENT)
                ? true
                : false,
             textFieldColor: (appConstants.userModel.usaUserType !=
                    AppConstants.USER_TYPE_PARENT)?grey.withOpacity(0.5): green,
          ),
          // TextFormField(
          //                 autovalidateMode: AutovalidateMode.onUserInteraction,
          //                 validator: (String? password) {
          //                   return null;

          //                   // if(password!.isEmpty){
          //                   //   return 'Please Enter Password';
          //                   // } else if (password!=passwordCotroller.text) {
          //                   //   return 'Password doesn’t match :( Try again';
          //                   // }
          //                   // else{
          //                   //   return null;
          //                   // }
          //                 },
          //                 style: textStyleHeading2WithTheme(context, width,
          //                     whiteColor: 0),
          //                 controller: controller,
          //                 textInputAction: TextInputAction.next,
          //                 // obscureText: appConstants.passwordVissibleRegistration,
          //                 keyboardType: TextInputType.number,
          //                 decoration: InputDecoration(
          //                   contentPadding: const EdgeInsets.only(top: 25),
          //                     prefixIcon: Padding(
          //                   padding: const EdgeInsets.only(top: 25.0),
          //                   child: Text(
          //                     '${getCurrencySymbol(context, appConstants: appConstants )}',
          //                     style: textStyleHeading2WithTheme(
          //                         context, width * 0.8,
          //                         whiteColor: 2),
          //                   ),
          //                 ))
          //               ),
        ),
        Expanded(flex: 7, child: SizedBox())
        // Text(
        //   'SAR    100.000',
        //   style: textStyleHeading2WithTheme(context, width, whiteColor: 0),
        // ),
        // const EditCardCustomDivider(),
      ],
    );
  }
}

class EditCardCustomDivider extends StatelessWidget {
  const EditCardCustomDivider({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(flex: 6, child: CustomDivider()),
        Expanded(flex: 4, child: SizedBox()),
      ],
    );
  }
}
