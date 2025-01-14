// ignore_for_file: file_names

import 'dart:isolate';

// import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zaki/Constants/AuthMethods.dart';
import 'package:zaki/Constants/CheckInternetConnections.dart';
import 'package:zaki/Constants/HelperFunctions.dart';
import 'package:zaki/Constants/NotificationTitle.dart';
import 'package:zaki/Screens/AddMembersWorkFlow.dart';
import 'package:zaki/Widgets/FloatingActionButton.dart';
import 'package:zaki/Widgets/ReadOnlyCustomWidget.dart';
// import 'package:zaki/Screens/TransferDone.dart';
import 'package:zaki/Widgets/TextHeader.dart';
import 'package:zaki/Widgets/WalletBalance.dart';
import 'package:zaki/Widgets/ZakiCircularButton.dart';
import 'package:zaki/Widgets/ZakiPrimaryButton.dart';
import '../Constants/AppConstants.dart';
import '../Constants/Spacing.dart';
import '../Constants/Styles.dart';
import '../Services/api.dart';
import '../Widgets/AppBars/AppBar.dart';
import '../Widgets/CustomConfermationScreen.dart';
import '../Widgets/CustomTextButon.dart';
import '../Widgets/CustomTextField.dart';
import '../Widgets/UnSelectedKidsWidget.dart';

class UpdateAllowance extends StatefulWidget {
  const UpdateAllowance({Key? key}) : super(key: key);

  @override
  State<UpdateAllowance> createState() => _UpdateAllowanceState();
}

class _UpdateAllowanceState extends State<UpdateAllowance> {
  final formGlobalKey = GlobalKey<FormState>();
  Stream<QuerySnapshot>? userKids;
  final amountController = TextEditingController();
  final spendAnyWhereController = TextEditingController();
  final savingController = TextEditingController();
  final donationsController = TextEditingController();
  String donationError = '';
  int check100Per=100;
  late bool status = true;
  int selectedIndex = -1;
  bool linkToDo = false;
  bool? hasBalance = true;
  String? error;
  String selectedKidName = '';
  String selectedKidAllowanSetById = '';
  String selectedKidBankAccountToken = '';
  String selectedKidId = '';
  bool viewScreen = false;

  var weekList = ['Daily', 'Every 5 Mins','Weekly', 'Every 2 Weeks', 'Monthly'];
  var daysList = [
    'Friday',
    'Saturday',
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
  ];

  static Function sendAllowanceToSpecficKid(String id,
      {required DateTime dateToSendAllowance,
      required String amount,
      required String allowanceSchedule,
      required String spendAnyWhereAmount,
      required String savingAmount,
      required String donationsAmount,
      required String deliveryOn,
      required String kidId,
      required bool status,
      required String parentId,
      required String donationsAmountPercent,
      required String savingAmountPercent,
      required String spendAnyWhereAmountPercent,
      required toDoLinked,
      required parentBankAccountToken,
      required kidBankAccountToken
      }) {
    try {
      
      final int isolateId = Isolate.current.hashCode;
      // UserPreferences preferences = UserPreferences();
      // int? userId = await preferences.getThemeData();
      // AppConstants.allonaceKidId;
      // print("[$now] Hello, world! isolate=${isolateId} function='$printHello'");
      logMethod(
          title: 'Background Task Added',
          message:
              "[$dateToSendAllowance] Hello, world! isolate=${isolateId} function='${id}'");
      // ApiServices services = ApiServices();
      //           await
      ApiServices().addAllowance(
          amount: double.parse(amount).toStringAsFixed(2),
          allowanceSchedule: allowanceSchedule,
          spendAnyWhereAmount: spendAnyWhereAmount,
          savingAmount: savingAmount,
          donationsAmount: donationsAmount,
          deliveryOn: deliveryOn,
          kidId: kidId,
          status: status,
          parentId: parentId,
          donationsAmountPercent: donationsAmountPercent,
          savingAmountPercent: savingAmountPercent,
          spendAnyWhereAmountPercent: spendAnyWhereAmountPercent,
          createdAt: dateToSendAllowance,
          linkedWith: toDoLinked,
          parentBankAccountToken: parentBankAccountToken,
        kidBankAccountToken: kidBankAccountToken
                
          );
      //  ApiServices().addMoneyToSelectedMainWallet(
      //         receivedUserId: AppConstants.allonaceKidId, amountSend: amount, senderId: parentId);
      //  ApiServices().addMoneyToSelectedSavingWallet(
      //         receivedUserId: AppConstants.allonaceKidId, amountSend: amount, senderId: parentId);
      // ApiServices().addMoneyToSelectedCharityWallet(
      //         receivedUserId: AppConstants.allonaceKidId, amountSend: amount, senderId: parentId);
    } catch (e) {
      logMethod(title: 'Exception', message: e.toString());
    }
    return emptyFunction;
  } 

  @override
  void dispose() {
    amountController.dispose();
    spendAnyWhereController.dispose();
    savingController.dispose();
    donationsController.dispose();
    super.dispose();
  }

  void clearFields() {
    amountController.text = '';
    spendAnyWhereController.text = '';
    savingController.text = '';
    donationsController.text = '';
  }

  @override
  void initState() {
    super.initState();
    getUserKids();
    reSetAmount(
        spendAmount: '80', amount: '', savingAmount: '17', donationAmount: '3');
    // amountController .addListener(() {
    //     final text = amountController.text;
    //     if (!text.endsWith('.00')) {
    //       amountController.text = '$text.00';
    //       amountController.selection = TextSelection.fromPosition(TextPosition(offset: amountController.text.length));
    //     }
    //   });
  }

// : amountController.text,
//                           : appConstants.allowanceSchedule,
//                           : tempSepndAllowance.toString(),
//                           : tempsavingAllowance.toString(),
//                           : tempdonationAllowance.toString(),
//                           : appConstants.allowanceDay,
//                           : AppConstants.allonaceKidId,
//                           : true,
//                           : appConstants.userRegisteredId,
//                           : donationsController.text,
//                           : savingController.text,
//                           : spendAnyWhereController.text,
//                           createdAt: date
  sendAllowanceData(
      {required DateTime dateToSendAllowance,
      required String amount,
      required String allowanceSchedule,
      required String spendAnyWhereAmount,
      required String savingAmount,
      required String donationsAmount,
      required String deliveryOn,
      required String kidId,
      required bool status,
      required String parentId,
      required String donationsAmountPercent,
      required String savingAmountPercent,
      required String spendAnyWhereAmountPercent,
      required bool toDoLinked,
      required String parentBankAccountToken,
      required String kidBankAccountToken
      }) async {
    // final int helloAlarmID = 0;
    // await AndroidAlarmManager.cancel(helloAlarmID);
    logMethod(
        title: 'Allowance', 
        message: "Allowance User Id: '${AppConstants.allonaceKidId}'");
    //////////Alaram manager
    // await AndroidAlarmManager.oneShotAt(
    //     DateTime(dateToSendAllowance.year, dateToSendAllowance.month,
    //         dateToSendAllowance.day, 12, 40),
    //     helloAlarmID,
    //     sendAllowanceToSpecficKid(AppConstants.allonaceKidId!,
    //         dateToSendAllowance: dateToSendAllowance,
    //         amount: amountController.text,
    //         allowanceSchedule: allowanceSchedule,
    //         spendAnyWhereAmount: spendAnyWhereAmount,
    //         savingAmount: savingAmount,
    //         donationsAmount: donationsAmount,
    //         deliveryOn: deliveryOn,
    //         kidId: kidId,
    //         status: status,
    //         parentId: parentId,
    //         donationsAmountPercent: donationsAmountPercent,
    //         savingAmountPercent: savingAmountPercent,
    //         spendAnyWhereAmountPercent: spendAnyWhereAmountPercent,
    //         toDoLinked: toDoLinked),
    //     alarmClock: true,
    //     wakeup: true,
    //     rescheduleOnReboot: true);

    //////////Alram manager end
    sendAllowanceToSpecficKid(AppConstants.allonaceKidId!,
        dateToSendAllowance: dateToSendAllowance,
        amount: amountController.text,
        allowanceSchedule: allowanceSchedule,
        spendAnyWhereAmount: spendAnyWhereAmount,
        savingAmount: savingAmount,
        donationsAmount: donationsAmount,
        deliveryOn: deliveryOn,
        kidId: kidId,
        status: status,
        parentId: parentId,
        donationsAmountPercent: donationsAmountPercent,
        savingAmountPercent: savingAmountPercent,
        spendAnyWhereAmountPercent: spendAnyWhereAmountPercent,
        toDoLinked: toDoLinked,
        parentBankAccountToken: parentBankAccountToken,
        kidBankAccountToken: kidBankAccountToken
        );

    // await AndroidAlarmManager.periodic(
    // const Duration(seconds: 3),
    // helloAlarmID,
    // printHello,
    // wakeup: true,
    // startAt: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 17, 19), //Start whit the specific time 5:00 am
    // );
  }

  getUserKids() {
    Future.delayed(const Duration(milliseconds: 200), () async {
      var appConstants = Provider.of<AppConstants>(context, listen: false);
      bool screenNotOpen =
          await checkUserSubscriptionValue(appConstants, context);
      appConstants.updateAllonaceKidId('');
      logMethod(title: 'Data from Pay+', message: screenNotOpen.toString());
      if (screenNotOpen == true) {
        Navigator.pop(context);
      } else {
        
        if (appConstants.userModel.usaUserType !=
              AppConstants.USER_TYPE_PARENT){
                ApiServices services = ApiServices();
          dynamic kidData = await services.fetchUserKidWithFuture(appConstants.userRegisteredId);
          print("This document id: $kidData");
          // showNotification(error: 0, icon: Icons.clear, message: kidData);
          // Future.delayed(const Duration(milliseconds: 500),(){
          if (kidData != null) {
            appConstants
                .updateAllowanceDay(kidData[AppConstants.USER_delivery_on]);
            reSetAmount(
                spendAmount: kidData[AppConstants.USER_Main_amount_percent],
                amount: kidData[AppConstants.USER_Allow1_amount],
                savingAmount: kidData[AppConstants.USER_saving_amount_percent],
                donationAmount:
                    kidData[AppConstants.USER_donate_amount_percent]);
            setState(() {
              selectedIndex = 0;
              status = kidData[AppConstants.USER_allowance_status];
            });
          } else {
            reSetAmount(
                spendAmount: '80',
                amount: '',
                savingAmount: '17',
                donationAmount: '3');
          }              
              }
            if (appConstants.userModel.usaUserType ==
              AppConstants.USER_TYPE_PARENT)
        checkForKids(familyId: appConstants.userModel.userFamilyId?? appConstants.userRegisteredId, parentId: appConstants.userModel.userFamilyId ?? appConstants.userRegisteredId);
        bool? balance = await ApiServices().checkWalletHasAmount(
            amount: 0,
            userId: appConstants.userRegisteredId,
            fromWalletName: AppConstants.Spend_Wallet,
            requiredOnlyBalance: true);

        setState(() {
          if (balance == true) {
            hasBalance = false;
          }
          if (appConstants.userModel.usaUserType ==
              AppConstants.USER_TYPE_PARENT)
            userKids = ApiServices().fetchUserKids(
                appConstants.userModel.seeKids == true
                    ? appConstants.userModel.userFamilyId!
                    : appConstants.userRegisteredId,
                currentUserId: appConstants.userRegisteredId);
        });

        if (userKids != null) {
          String? userData = await ApiServices().fetchFirstUserId(
              appConstants.userModel.seeKids == true
                  ? appConstants.userModel.userFamilyId!
                  : appConstants.userRegisteredId,
              currentUserId: appConstants.userRegisteredId);
          String? userId = userData!.split('_').first;
          String? userNameFormId = userData.split('_')[1];
          appConstants.updateKidSelectedIndex(0);
          appConstants.updateAllonaceKidId(userId);
          setState(() {
            selectedIndex = 0;
            selectedKidName = userNameFormId;
            selectedKidId = userData.split('_').first;
            selectedKidBankAccountToken = userData.split('_').last;
          });
          logMethod(
              title: "ID and userName is:",
              message: '${userId} and $selectedKidName');
          ApiServices services = ApiServices();
          dynamic kidData = await services.fetchUserKidWithFuture(userId);
          print("This document id: $kidData");
          // showNotification(error: 0, icon: Icons.clear, message: kidData);
          // Future.delayed(const Duration(milliseconds: 500),(){
          if (kidData != null) {
            appConstants
                .updateAllowanceDay(kidData[AppConstants.USER_delivery_on]);
            reSetAmount(
                spendAmount: kidData[AppConstants.USER_Main_amount_percent],
                amount: kidData[AppConstants.USER_Allow1_amount],
                savingAmount: kidData[AppConstants.USER_saving_amount_percent],
                donationAmount:
                    kidData[AppConstants.USER_donate_amount_percent]);
            setState(() {
              selectedIndex = 0;
              status = kidData[AppConstants.USER_allowance_status];
            });
          } else {
            reSetAmount(
                spendAmount: '80',
                amount: '',
                savingAmount: '17',
                donationAmount: '3');
          }
        }
      }
    });
  }
void checkForKids({required String parentId, required String familyId}) async {

  bool noKids = await ApiServices().checkIfNoKids(parentId, familyId);

  if (noKids) {
    print("No kids added yet.");
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              const AddMemberWorkFlow()));
  } else {
    print("Kids are already added.");
  }
}
  void reSetAmount(
      {String? amount,
      String? spendAmount,
      String? savingAmount,
      String? donationAmount}) {
    logMethod(title: "Amount", message: amount.toString());
    amountController.text = amount!;
    spendAnyWhereController.text = spendAmount!;
    savingController.text = savingAmount!;
    donationsController.text = donationAmount!;
  }

  @override
  Widget build(BuildContext context) {
    var appConstants = Provider.of<AppConstants>(context, listen: true);
    var internet = Provider.of<CheckInternet>(context, listen: true);
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      floatingActionButton: CustomFloadtingActionButton(),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Form(
          key: formGlobalKey,
          child: Stack(
            children: [
              if( appConstants.userModel.usaUserType != AppConstants.USER_TYPE_PARENT)
              ReadOnlyCustomWidget(width: width, height: height),
              if(
                // appConstants.userModel.usaUserType !=
                //     AppConstants.USER_TYPE_PARENT &&  
                    //
                    (
                      // selectedKidAllowanSetById !="" && selectedKidAllowanSetById != appConstants.userRegisteredId && 
                      !checkPrimaryUserWithParent(appConstants, appConstants.userModel.usaUserType))  
                    )
              ReadOnlyCustomWidget(width: width, height: height),
              Column(
                children: [
                Padding(
                  padding: getCustomPadding(),
                  child: appBarHeader_005(
                      width: width,
                      height: height,
                      context: context,
                      appBarTitle: 'Allowance',
                      backArrow: true),
                ),
                Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        
                        (appConstants.userModel.usaUserType !=
                                AppConstants.USER_TYPE_PARENT)
                            ? const SizedBox.shrink()
                            : userKids == null
                                ? const SizedBox()
                                : Container(
                                    color: green.withValues(alpha:0.05),
                                    height: height * 0.127,
                                    width: width,
                                    child: StreamBuilder<QuerySnapshot>(
                                      stream: userKids,
                                      builder: (BuildContext context,
                                          AsyncSnapshot<QuerySnapshot> snapshot) {
                                        if (snapshot.hasError) {
                                          return const Text(
                                              'Ooops...Something went wrong :(');
                                        }
              
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const Text("");
                                        }
                                        if (snapshot.data!.size == 0) {
                                          return Column(
                                            children: [
                                              Container(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: SizedBox(width: 10,height: 10,)
                                                  // Image.asset(imageBaseAddress+"add_member.png"),
                                                )
                                                ),
                                                spacing_small,
                                                Text(
                                                  'Add Family',
                                                  style: heading4TextSmall(width),
                                                  )
                                            ],
                                          );
                                        }
                                        //snapshot.data!.docs[index] ['USA_first_name']
                                        return Padding(
                                          padding: getCustomPadding(),
                                          child: ListView.builder(
                                            itemCount: snapshot.data!.docs.length,
                                            physics: const BouncingScrollPhysics(),
                                            shrinkWrap: true,
                                            scrollDirection: Axis.horizontal,
                                            itemBuilder:
                                                (BuildContext context, int index) {
                                              // SchedulerBinding.instance
                                              //     .addPostFrameCallback((_) async {
                                              //   if (selectedIndex == -1) {
                                              //     appConstants
                                              //         .updateKidSelectedIndex(0);
                                              //     appConstants.updateAllonaceKidId(
                                              //         snapshot.data!.docs[0].id);
                                              //     ApiServices services = ApiServices();
                                              //     dynamic kidData = await services
                                              //         .fetchUserKidWithFuture(
                                              //             snapshot.data!.docs[0].id);
                                              //     print("This document id: $kidData");
                                              //     // showNotification(error: 0, icon: Icons.clear, message: kidData);
                                              //     // Future.delayed(const Duration(milliseconds: 500),(){
                                              //     if (kidData != null) {
                                              //       appConstants.updateAllowanceDay(
                                              //           kidData[AppConstants
                                              //               .USER_delivery_on]);
                                              //       reSetAmount(
                                              //           spendAmount: kidData[AppConstants
                                              //               .USER_Main_amount_percent],
                                              //           amount: kidData[AppConstants
                                              //               .USER_Allow1_amount],
                                              //           savingAmount: kidData[AppConstants
                                              //               .USER_saving_amount_percent],
                                              //           donationAmount: kidData[AppConstants
                                              //               .USER_donate_amount_percent]);
                                              //       setState(() {
                                              //         selectedIndex = 0;
                                              //         status = kidData[AppConstants
                                              //             .USER_allowance_status];
              
                                              //       });
                                              //     } else {
                                              //       setState(() {
                                              //         selectedIndex = 0;
                                              //         selectedKidName = snapshot.data!.docs[index][AppConstants.USER_user_name];
                                              //       });
                                              //       reSetAmount(
                                              //           spendAmount: '90.0',
                                              //           amount: '',
                                              //           savingAmount: '7.5',
                                              //           donationAmount: '2.5');
                                              //     }
                                              //     logMethod(
                                              //         title: "ID is:",
                                              //         message: snapshot
                                              //             .data!.docs[index].id);
                                              //   }
                                              // });
                                              // print(snapshot.data!.docs[index] ['USA_first_name']);
                                              return 
                                              (
                                                      // snapshot.data!.docs[index][
                                                      //               AppConstants
                                                      //                   .NewMember_isEnabled] ==
                                                      //           false ||
                                                      (snapshot.data!.docs[index][
                                                              AppConstants
                                                                  .USER_UserType] !=
                                                          AppConstants
                                                              .USER_TYPE_KID))
                                                  ? const SizedBox.shrink()
                                                  : 
                                                  InkWell(
                                                      onTap: () async {
                                                        appConstants
                                                            .updateKidSelectedIndex(
                                                                index);
                                                        appConstants
                                                            .updateAllonaceKidId(
                                                                snapshot
                                                                    .data!
                                                                    .docs[index]
                                                                    .id);
                                                        setState(() {
                                                          selectedIndex = 0;
                                                          selectedKidId = snapshot
                                                              .data!.docs[index].id;
                                                          selectedKidName = snapshot
                                                                  .data!.docs[index]
                                                              [AppConstants
                                                                  .USER_user_name];
                                                          selectedKidBankAccountToken = snapshot
                                                                  .data!.docs[index]
                                                              [AppConstants
                                                                  .USER_BankAccountID];
                                                        });
                                                        // appConstants.updateAllowanceSchedule(snapshot.data!.docs[index]['USA_allowance_schedule']);
                                                        ApiServices services =
                                                            ApiServices();
                                                        dynamic kidData = await services
                                                            .fetchUserKidWithFuture(
                                                                snapshot
                                                                    .data!
                                                                    .docs[index]
                                                                    .id);
                                                        print(
                                                            "Document ID: $kidData");
                                                        // showNotification(error: 0, icon: Icons.clear, message: kidData);
                                                        // Future.delayed(const Duration(milliseconds: 500),(){
                                                        if (kidData != null) {

                                                          appConstants.updateAllowanceDay(
                                                              kidData[AppConstants
                                                                  .USER_delivery_on]);
                                                          reSetAmount(
                                                              spendAmount: kidData[
                                                                  AppConstants
                                                                      .USER_Main_amount_percent],
                                                              amount: kidData[
                                                                  AppConstants
                                                                      .USER_Allow1_amount],
                                                              savingAmount: kidData[
                                                                  AppConstants
                                                                      .USER_saving_amount_percent],
                                                              donationAmount: kidData[
                                                                  AppConstants
                                                                      .USER_donate_amount_percent]);
                                                          setState(() {
                                                            selectedKidAllowanSetById= kidData[AppConstants.USER_parent_id];
                                                            status = kidData[
                                                                AppConstants
                                                                    .USER_allowance_status];
                                                          });
                                                        } else {
                                                          selectedKidAllowanSetById= "";
                                                          reSetAmount(
                                                              spendAmount: '80',
                                                              amount: '',
                                                              savingAmount: '17',
                                                              donationAmount: '3');
                                                        }
              
                                                        // });
                                                      },
                                                      child: 
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets.only(
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
                                                                        width: appConstants.kidSelectedIndex ==
                                                                                index
                                                                            ? 2
                                                                            : 0,
                                                                        color: appConstants.kidSelectedIndex ==
                                                                                index
                                                                            ? green
                                                                            : transparent),
                                                                    boxShadow:
                                                                        appConstants.kidSelectedIndex !=
                                                                                index
                                                                            ? null
                                                                            : [
                                                                                customBoxShadow(color: green)
                                                                              ],
                                                                  ),
                                                                  child: Padding(
                                                                      padding:
                                                                          const EdgeInsets
                                                                              .all(
                                                                              0.0),
                                                                      child:
                                                                          userImage(
                                                                        imageUrl: snapshot
                                                                                .data!
                                                                                .docs[index]
                                                                            [
                                                                            AppConstants
                                                                                .USER_Logo],
                                                                        userType: snapshot
                                                                                .data!
                                                                                .docs[index]
                                                                            [
                                                                            AppConstants
                                                                                .USER_UserType],
                                                                        width:
                                                                            width,
                                                                        gender: snapshot
                                                                                .data!
                                                                                .docs[index]
                                                                            [
                                                                            AppConstants
                                                                                .USER_gender],
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
                                                                          snapshot.data!.docs[index][AppConstants
                                                                                  .USER_user_name] ==
                                                                              '')
                                                                      ? snapshot
                                                                              .data!
                                                                              .docs[index]
                                                                          [
                                                                          AppConstants
                                                                              .USER_first_name]
                                                                      : '@ ' +
                                                                          snapshot
                                                                              .data!
                                                                              .docs[index][AppConstants.USER_user_name],
                                                                  overflow:
                                                                      TextOverflow
                                                                          .fade,
                                                                  maxLines: 1,
                                                                  style:
                                                                      heading5TextSmall(
                                                                          width),
                                                                ),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                            },
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                        spacing_large,
              
                        Padding(
                          padding: getCustomPadding(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Enter Amount:',
                                style: heading1TextStyle(context, width),
                              ),
                              CustomTextField(
                                amountController: amountController,
                                textFieldLimit: 3,
                                hintText: false,
                                textFieldColor: (appConstants.userModel.usaUserType !=
                    AppConstants.USER_TYPE_PARENT || ( !checkPrimaryUserWithParent(appConstants, appConstants.userModel.usaUserType)))?grey.withValues(alpha:0.5): green,
                                readOnly: appConstants.userModel.usaUserType !=
                                        AppConstants.USER_TYPE_PARENT
                                    ? true
                                    : ( !checkPrimaryUserWithParent(appConstants, appConstants.userModel.usaUserType)) ? true : false,
                                onFieldSubmitted: (String amount) async {
                                  bool? balance =
                                      await ApiServices().checkWalletHasAmount(
                                    amount:
                                        double.parse(amountController.text.trim()),
                                    userId: appConstants.userRegisteredId,
                                    fromWalletName: AppConstants.Spend_Wallet, 
                                  );
                                  if (balance == true) {
                                    setState(() {
                                      error =
                                          'Not Enouch Money Please added amount';
                                    });
                                  }
                                },
                                error: error == null ? null : error,
                                onChanged: (String amount) {
                                  setState(() {
                                    error = null;
                                  });
                                },
                                onTap: () {
                                  amountController.text = '';
                                },
                              ),
                              spacing_small,
                              WalletBalance(appConstants: appConstants),
                              spacing_large,
                              Text(
                                'Schedule:',
                                style: heading1TextStyle(context, width),
                              ),
                              DropdownButtonHideUnderline(
                                child: DropdownButton(
                                  isExpanded: false,
                                  // Initial Value
                                  value: appConstants.allowanceSchedule,
                                  style: heading2TextStyle(context, width, color: ( !checkPrimaryUserWithParent(appConstants, appConstants.userModel.usaUserType))?grey:null),
              
                                  // Down Arrow Icon
                                  icon: Icon(
                                    Icons.keyboard_arrow_down,
                                    color: (appConstants.userModel.usaUserType !=
                    AppConstants.USER_TYPE_PARENT || ( !checkPrimaryUserWithParent(appConstants, appConstants.userModel.usaUserType)))? grey.withValues(alpha:0.5) : green,
                                  ),
              
                                  // Array list of items
                                  items: weekList.map((String items) {
                                    return DropdownMenuItem(
                                      value: items,
                                      child: Text(items),
                                    );
                                  }).toList(),
                                  // After selecting the desired option,it will
                                  // change button value to selected value
                                  onChanged: appConstants.userModel.usaUserType !=
                                          AppConstants.USER_TYPE_PARENT|| ( !checkPrimaryUserWithParent(appConstants, appConstants.userModel.usaUserType))
                                      ? null
                                      : (String? newValue) {
                                          appConstants
                                              .updateAllowanceSchedule(newValue!);
                                        },
                                ),
                              ),
                              Divider(
                                color: black,
                                height: 0.005,
                                thickness: 0.3,
                              ),
                              spacing_large,
                              Text(
                                'Allocation:',
                                style: heading1TextStyle(context, width),
                              ),
                              spacing_medium,
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Column(
                                  children: [
                                    Row(
                                      // mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          flex: 7,
                                          child: TextValue2(
                                            title:
                                                (appConstants.nickNameModel
                                                                .NickN_SpendWallet !=
                                                            null &&
                                                        appConstants.nickNameModel
                                                                .NickN_SpendWallet !=
                                                            "")
                                                    ? appConstants.nickNameModel
                                                            .NickN_SpendWallet! +
                                                        ' Wallet'
                                                    : 'Spend' + ' Wallet',
                                             
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 4.0),
                                            child: TextFormField(
                                              autovalidateMode: AutovalidateMode
                                                  .onUserInteraction,
                                              validator: (String? password) {
                                                return null;
                                              },
                                              style:
                                                  heading2TextStyle(context, width, color: (appConstants.userModel.usaUserType !=
                    AppConstants.USER_TYPE_PARENT || ( !checkPrimaryUserWithParent(appConstants, appConstants.userModel.usaUserType)))?grey.withValues(alpha:0.5): null,),
                                              controller: spendAnyWhereController,
                                              // obscureText: appConstants.passwordVissibleRegistration,
                                              keyboardType: TextInputType.number,
                                              textAlign: TextAlign.right,
                                              readOnly: appConstants
                                                          .userModel.usaUserType !=
                                                      AppConstants.USER_TYPE_PARENT
                                                  ? true
                                                  : ( !checkPrimaryUserWithParent(appConstants, appConstants.userModel.usaUserType)) ? true : false,
                                                onFieldSubmitted: (String value){
                                                  check100Per = int.parse(donationsController.text.toString())+(int.parse(savingController.text.toString())+(int.parse(spendAnyWhereController.text.toString())));
                                                  setState(() {
                                                    
                                                  });
                                                },
                                              decoration: InputDecoration(
                                                  isDense: true,
                                                  suffix: Icon(
                                                    Icons.percent,
                                                    color:(appConstants.userModel.usaUserType !=
                    AppConstants.USER_TYPE_PARENT|| ( !checkPrimaryUserWithParent(appConstants, appConstants.userModel.usaUserType)))?grey.withValues(alpha:0.5): green,
                                                    size: width * 0.042,
                                                  )),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 7,
                                          child: TextValue2(
                                            title:
                                                (appConstants.nickNameModel
                                                                .NickN_SavingWallet !=
                                                            null &&
                                                        appConstants.nickNameModel
                                                                .NickN_SavingWallet !=
                                                            "")
                                                    ? appConstants.nickNameModel
                                                            .NickN_SavingWallet! +
                                                        ' Wallet'
                                                    : 'Savings' + ' Wallet',
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 4.0),
                                            child: TextFormField(
                                              autovalidateMode: AutovalidateMode
                                                  .onUserInteraction,
                                              validator: (String? password) {
                                                return null;
                                              },
                                              style:
                                                  heading2TextStyle(context, width,color: (appConstants.userModel.usaUserType !=
                    AppConstants.USER_TYPE_PARENT|| ( !checkPrimaryUserWithParent(appConstants, appConstants.userModel.usaUserType)))?grey.withValues(alpha:0.5): null,),
                                            onFieldSubmitted: (String value){
                                              check100Per = int.parse(donationsController.text.toString())+(int.parse(savingController.text.toString())+(int.parse(spendAnyWhereController.text.toString())));
                                              setState(() {});
                                              },
                                              controller: savingController,
                                              // obscureText: appConstants.passwordVissibleRegistration,
                                              keyboardType: TextInputType.number,
                                              textAlign: TextAlign.right,
                                              
                                              readOnly: (appConstants
                                                          .userModel.usaUserType !=
                                                      AppConstants.USER_TYPE_PARENT)
                                                  ? true
                                                  : (selectedKidAllowanSetById!="" && selectedKidAllowanSetById != appConstants.userRegisteredId&& !checkPrimaryUserWithParent(appConstants, appConstants.userModel.usaUserType)) ? true : false,
                                              decoration: InputDecoration(
                                                  isDense: true,
                                                  suffix: Icon(
                                                    Icons.percent,
                                                    color:(appConstants.userModel.usaUserType !=
                    AppConstants.USER_TYPE_PARENT|| ( !checkPrimaryUserWithParent(appConstants, appConstants.userModel.usaUserType)))?grey.withValues(alpha:0.5): green,
                                                    size: width * 0.042,
                                                  )),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    ///////Charity
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 7,
                                          child: TextValue2(
                                            title:
                                                (appConstants.nickNameModel
                                                                .NickN_DonationWallet !=
                                                            null &&
                                                        appConstants.nickNameModel
                                                                .NickN_DonationWallet !=
                                                            "")
                                                    ? appConstants.nickNameModel
                                                            .NickN_DonationWallet! +
                                                        ' Wallet'
                                                    : 'Charity' + ' Wallet',
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 4.0),
                                            child: TextFormField(
                                              autovalidateMode: AutovalidateMode
                                                  .onUserInteraction,
                                              validator: (String? password) {
                                                return null;
                                              },
                                              onFieldSubmitted: (String value){
                                            check100Per = int.parse(donationsController.text.toString())+(int.parse(savingController.text.toString())+(int.parse(spendAnyWhereController.text.toString())));
                                              setState(() {});
                                              },
                                              onChanged: (String vlaue) {
                                                setState(() {
                                                  donationError = '';
                                                });
                                              },
                                              style:
                                                  heading2TextStyle(context, width, color:(appConstants.userModel.usaUserType !=
                    AppConstants.USER_TYPE_PARENT|| ( !checkPrimaryUserWithParent(appConstants, appConstants.userModel.usaUserType)))?grey.withValues(alpha:0.5): green),
                                              controller: donationsController,
                                              readOnly: (appConstants
                                                          .userModel.usaUserType !=
                                                      AppConstants.USER_TYPE_PARENT)
                                                  ? true
                                                  : (selectedKidAllowanSetById!="" && selectedKidAllowanSetById != appConstants.userRegisteredId&& !checkPrimaryUserWithParent(appConstants, appConstants.userModel.usaUserType)) ? true : false,
                                              // obscureText: appConstants.passwordVissibleRegistration,
                                              keyboardType: TextInputType.number,
                                              textAlign: TextAlign.right,
                                              decoration: InputDecoration(
                                                  isDense: true,
                                                  // errorText: donationError == ''
                                                  //     ? null
                                                  //     : donationError,
                                                  suffix: Icon(
                                                    Icons.percent,
                                                    color:(appConstants.userModel.usaUserType !=
                    AppConstants.USER_TYPE_PARENT|| ( !checkPrimaryUserWithParent(appConstants, appConstants.userModel.usaUserType)))?grey.withValues(alpha:0.5): green,
                                                    size: width * 0.042,
                                                  )),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              // if(donationError!='')
                              // Row(
                              //   mainAxisAlignment: MainAxisAlignment.end,
                              //   children: [
                              //     Text(
                              //       donationError, 
                              //       style: heading5TextSmall(width, bold: false, color:  red),
                              //       textAlign: TextAlign.end,
                              //       ),
                              //   ],
                              // ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0, right: 12),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(color: grey.withValues(alpha:0.5))
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          '${check100Per.toString()} %', 
                                          style: heading2TextStyle(context, width, color:(appConstants.userModel.usaUserType !=
                    AppConstants.USER_TYPE_PARENT|| ( !checkPrimaryUserWithParent(appConstants, appConstants.userModel.usaUserType)))?grey.withValues(alpha:0.5): check100Per==100 ? green : red),
                                          textAlign: TextAlign.end,
                                          ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              spacing_large,
                              Text(
                                'Deliver On:',
                                style: heading1TextStyle(context, width),
                              ),
                              DropdownButtonHideUnderline(
                                child: DropdownButton(
                                  isExpanded: false,
                                  // Initial Value
                                  value: appConstants.allowanceDay,
                                  style: heading2TextStyle(context, width, color: ( !checkPrimaryUserWithParent(appConstants, appConstants.userModel.usaUserType))?grey:null),
                                  // Down Arrow Icon
                                  icon: Icon(
                                    Icons.keyboard_arrow_down,
                                    color: grey,
                                  ),
              
                                  // Array list of items
                                  items: daysList.map((String items) {
                                    return DropdownMenuItem(
                                      value: items,
                                      child: Text(items),
                                    );
                                  }).toList(),
                                  // After selecting the desired option,it will
                                  // change button value to selected value
                                  onChanged: (appConstants.userModel.usaUserType !=
                                          AppConstants.USER_TYPE_PARENT)
                                      ? null
                                      : (
                                        // selectedKidAllowanSetById!="" && selectedKidAllowanSetById != appConstants.userRegisteredId
                                       (!checkPrimaryUserWithParent(appConstants, appConstants.userModel.usaUserType))
                                        ) ? null : (String? newValue) {
                                          appConstants
                                              .updateAllowanceDay(newValue!);
                                        },
                                ),
                              ),
                              Divider(
                                color: black,
                                height: 0.3,
                              ),
                              spacing_small,
                              Text(
                                'Funds will automatically deposit on delivery day',
                                style: heading4TextSmall(width),
                              ),
                              // spacing_large,
                              // ListTile(
                              //   title: Text(
                              //     'Link allowance to “TO DO”:',
                              //     style: heading1TextStyle(context, width),
                              //   ),
                              //   subtitle: Text(
                              //     'Allowance will not be desposited until you confirm TO DO tasks are completed',
                              //     style: heading4TextSmall(width),
                              //   ),
                              //   trailing: Transform.scale(
                              //     scale: 0.7,
                              //     child: CupertinoSwitch(
                              //       value: linkToDo,
                              //       activeColor: primaryButtonColor,
                              //       trackColor: grey,
                              //       onChanged: (value) async {
                              //         setState(() {
                              //           linkToDo = !linkToDo;
                              //         });
                              //       },
                              //     ),
                              //   ),
                              // ),
                              spacing_large,
                              (appConstants.userModel.usaUserType !=
                                      AppConstants.USER_TYPE_PARENT)
                                  ? SizedBox.shrink()
                                  : ZakiPrimaryButton(
                                      title: status == true
                                          ? 'Deliver on Schedule'
                                          : 'Activate Allowance',
                                      width:     width,
                                      onPressed: internet.status ==
                                              AppConstants
                                                  .INTERNET_STATUS_NOT_CONNECTED
                                          ? null
                                          : (check100Per!=100 || hasBalance == false ||
                                                  error != null ||
                                                  appConstants.isLoading == true ||
                                                  selectedKidId == '')
                                              ? null
                                              : (amountController.text
                                                          .trim()
                                                          .isEmpty ||
                                                      AppConstants.allonaceKidId ==
                                                          '')
                                                  ? null
                                                  : ( !checkPrimaryUserWithParent(appConstants, appConstants.userModel.usaUserType)) ? null : () async {
                                                    bool? checkAuth = await authenticateTransactionUsingBioOrPinCode(appConstants: appConstants, context: context);
                                                      if(checkAuth==false){
                                                        return;
                                                      }
                                                      double tempSepndAllowance,
                                                          tempsavingAllowance,
                                                          tempdonationAllowance;
                                                      ///////////Start Of Update Allowance
                                                      if (status == false) {
                                                        ApiServices services =
                                                            ApiServices();
                                                        setState(() {
                                                          status = !status;
                                                        });
                                                        services
                                                            .updateAllowanceStatus(
                                                                kidId: AppConstants
                                                                    .allonaceKidId,
                                                                status: status);
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) =>
                                                                    CustomConfermationScreen(
                                                                      title:
                                                                          'Allowance Updated',
                                                                      // subTitle: "${getCurrencySymbol(context, appConstants: appConstants)} ${amountController.text} added to your \n${appConstants.nickNameModel.NickN_SpendWallet?? 'Spend'} Wallet",
                                                                    )));
                                                        return;
                                                      }
                                                      if (!formGlobalKey
                                                          .currentState!
                                                          .validate()) {
                                                        return;
                                                      }
                                                      
                                                      /////////Marqata Logic for checking Balance and pay user
                                                      if (appConstants.testMode !=
                                                          false) {
                                                        // CreaditCardApi
                                                        //     creaditCardApi =
                                                        //     CreaditCardApi();
                                                        // BalanceModel? balanceModel =
                                                        //     await creaditCardApi
                                                        //         .checkBalance(
                                                        //             userToken:
                                                        //                 appConstants
                                                        //                     .userModel
                                                        //                     .userTokenId);
                                                        // if (balanceModel!.gpa
                                                        //         .availableBalance <
                                                        //     double.parse(
                                                        //         amountController
                                                        //             .text
                                                        //             .trim()
                                                        //             .toString())) {
                                                        //   setState(() {
                                                        //     error = NotificationText
                                                        //         .ADDED_SUCCESSFULLY;
                                                        //   });
                                                        //   showNotification(
                                                        //       error: 1,
                                                        //       icon: Icons.error,
                                                        //       message: NotificationText
                                                        //           .ADDED_SUCCESSFULLY);
                                                        //   return;
                                                        // } 
                                                        // else {
                                                          // selectedUserToken
                                                          // Position userLocation =await UserLocation().determinePosition();
              
                                                          // String?
                                                          //     selectedUserAccountNumber =
                                                          //     await ApiServices()
                                                          //         .getAccountNumberFromId(
                                                          //             userId: AppConstants
                                                          //                 .allonaceKidId);
                                                          // await creaditCardApi
                                                          //     .moveMoney(
                                                          //         amount:
                                                          //             amountController
                                                          //                 .text
                                                          //                 .trim(),
                                                          //         name: appConstants
                                                          //             .userModel
                                                          //             .usaFirstName,
                                                          //         senderUserToken:
                                                          //             appConstants
                                                          //                 .userModel
                                                          //                 .userTokenId,
                                                          //         receiverUserToken:
                                                          //             selectedUserAccountNumber,
                                                          //         // memo: createMemo(
                                                          //         //   fromWallet:
                                                          //         //       AppConstants
                                                          //         //           .Spend_Wallet,
                                                          //         //   // toWallet: AppConstants.Spend_Wallet,
                                                          //         //   // transactionMethod:AppConstants.Transaction_Method_Received,
                                                          //         //   // tagItName: '',
                                                          //         //   // tagItId: "",
                                                          //         //   // goalId: '',
                                                          //         //   // transactionType: AppConstants.TAG_IT_Transaction_TYPE_ALLOWANCE
                                                          //         // ),
                                                          //         tags: createMemo(
                                                          //           fromWallet:
                                                          //               AppConstants
                                                          //                   .Spend_Wallet,
                                                          //           toWallet:
                                                          //               AppConstants
                                                          //                   .Spend_Wallet,
                                                          //           transactionMethod:
                                                          //               AppConstants
                                                          //                   .Transaction_Method_Received,
                                                          //           tagItId: '13',
                                                          //           tagItName:
                                                          //               AppConstants
                                                          //                   .Allowance,
                                                          //           goalId: '',
                                                          //           transactionType:
                                                          //               AppConstants
                                                          //                   .TAG_IT_Transaction_TYPE_ALLOWANCE,
                                                          //           receiverId:
                                                          //               AppConstants
                                                          //                   .allonaceKidId,
                                                          //           senderId:
                                                          //               appConstants
                                                          //                   .userRegisteredId,
                                                          //           transactionId:
                                                          //               '',
                                                          //           latLng: '${userLocation.latitude},${userLocation.longitude}'
                                                          //           // transactionId: transaction
                                                          //         )
                                                          //         // receiverUserToken: widget.receiverUserId
                                                          //         );
                                                          // showNotification(
                                                          //     error: 0,
                                                          //     icon: Icons.balance,
                                                          //     message: NotificationText
                                                          //         .NOT_ENOUGH_BALANCE);
                                                        // }
                                                      }
                                                      /////////End Marqata Logic for checking Balance and pay user
              
                                                      // int total =  (int.tryParse(spendAnyWhereController.text.trim())??0) +
                                                      //          (int.tryParse(savingController.text.trim())??0) +
                                                      //           (int.tryParse(donationsController.text.trim())??0)
                                                      //         ;
                                                      // print('Total is: $total');
                                                      //   return;
                                                      if (((double.tryParse(
                                                                      spendAnyWhereController
                                                                          .text
                                                                          .trim()) ??
                                                                  0) +
                                                              (double.tryParse(
                                                                      savingController
                                                                          .text
                                                                          .trim()) ??
                                                                  0) +
                                                              (double.tryParse(
                                                                      donationsController
                                                                          .text
                                                                          .trim()) ??
                                                                  0)) !=
                                                          100.0) {
                                                        // print(
                                                        //     'Spend ${spendAnyWhereController.text.isEmpty} ${spendAnyWhereController.text.length}, Savings${savingController.text.isEmpty} and ${savingController.text.isEmpty ? 0 : int.parse(savingController.text.trim())}');
                                                        showNotification(
                                                            error: 1,
                                                            icon: Icons.error,
                                                            message: NotificationText
                                                                .ALLOWANCE_100_PER_ERROR);
                                                        setState(() {
                                                          donationError =
                                                              'Not 100%';
                                                        });
                                                        return;
                                                      } else {
                                                        ///////It will run if we dont have any errors
                                                        // If we dont have balance then.
                                                        logMethod(
                                                            title: 'Amount after deliver button pressed',
                                                            message: amountController.text.toString());
                                                        // bool? balance =
                                                        //     await ApiServices()
                                                        //         .checkWalletHasAmount(
                                                        //   amount: double.parse(
                                                        //       amountController.text
                                                        //           .trim()),
                                                        //   userId: appConstants
                                                        //       .userRegisteredId,
                                                        //   fromWalletName:
                                                        //       AppConstants
                                                        //           .Spend_Wallet,
                                                        // );
                                                        // if (balance == true) {
                                                        //   setState(() {
                                                        //     error =
                                                        //         'Not Enouch Money Please added amount';
                                                        //   });
                                                        //   return;
                                                        // }
              
                                                        appConstants
                                                            .updateLoading(true);
                                                        // Dont have balance end
                                                        tempSepndAllowance = ((double
                                                                        .tryParse(
                                                                            spendAnyWhereController
                                                                                .text
                                                                                .trim()) ??
                                                                    0) /
                                                                100) *
                                                            (double.tryParse(
                                                                    amountController
                                                                        .text
                                                                        .trim()) ??
                                                                0);
                                                        tempsavingAllowance = ((double
                                                                        .tryParse(
                                                                            savingController
                                                                                .text
                                                                                .trim()) ??
                                                                    0) /
                                                                100) *
                                                            (double.tryParse(
                                                                    amountController
                                                                        .text
                                                                        .trim()) ??
                                                                0);
                                                        tempdonationAllowance =
                                                            ((double.tryParse(donationsController
                                                                            .text
                                                                            .trim()) ??
                                                                        0) /
                                                                    100) *
                                                                (double.tryParse(
                                                                        amountController
                                                                            .text
                                                                            .trim()) ??
                                                                    0);
                                                        print(
                                                            "SVINGS, SPEND, DONAION : $tempSepndAllowance, $tempsavingAllowance, $tempdonationAllowance");
                                                        // return;
                                                        ///////////Getting next day
                                                        ///['Friday', '', '','', '', '', '',];
                                                        DateTime date =
                                                            DateTime.now();
                                                        var today = DateTime.now();
                                                        if (appConstants
                                                                .allowanceDay ==
                                                            'Friday') {
                                                          date = today.next(
                                                              DateTime.friday);
                                                        } else if (appConstants
                                                                .allowanceDay ==
                                                            'Saturday') {
                                                          date = today.next(
                                                              DateTime.saturday);
                                                        } else if (appConstants
                                                                .allowanceDay ==
                                                            'Sunday') {
                                                          date = today.next(
                                                              DateTime.sunday);
                                                        } else if (appConstants
                                                                .allowanceDay ==
                                                            'Monday') {
                                                          date = today.next(
                                                              DateTime.monday);
                                                        } else if (appConstants
                                                                .allowanceDay ==
                                                            'Tuesday') {
                                                          date = today.next(
                                                              DateTime.tuesday);
                                                        } else if (appConstants
                                                                .allowanceDay ==
                                                            'Wednesday') {
                                                          date = today.next(
                                                              DateTime.wednesday);
                                                        } else if (appConstants
                                                                .allowanceDay ==
                                                            'Thursday') {
                                                          date = today.next(
                                                              DateTime.thursday);
                                                        }
                                                        setState(() {});
                                                        //////////If
                                                        //////////////Add Allowance to Particular User
                                                        logMethod(
                                                            title: 'User Id',
                                                            message: appConstants
                                                                .userRegisteredId);
                                                        DateTime time =
                                                            DateTime.now();
                                                        logMethod(
                                                            title: 'Selected Time',
                                                            message:
                                                                time.toString());
                                                        String? crownString;
                                                        if (appConstants
                                                                .allowanceSchedule ==
                                                            'Daily') {
                                                          crownString = '* * * * *';
                                                        } else if(appConstants.allowanceSchedule=="Every 5 Mins"){
                                                          DateTime currentDate=DateTime.now();
                                                          date = DateTime(currentDate.year, currentDate.month, currentDate.day, currentDate.hour, currentDate.minute+5, currentDate.second);
                                                          crownString = '5 * * * *';
                                                        }else if (appConstants
                                                                .allowanceSchedule ==
                                                            'Weekly') {
                                                          crownString =
                                                              '${date.minute} ${date.hour} * * ${allowanceDay(day: appConstants.allowanceDay)}';
                                                        } else if (appConstants
                                                                .allowanceSchedule ==
                                                            'Every 2 Weeks') {
                                                          crownString =
                                                              '30 1 1,15 * *';
                                                        } else if (appConstants
                                                                .allowanceSchedule ==
                                                            'Monthly') {
                                                          crownString =
                                                              '${date.minute} ${date.hour} * ${date.month} *';
                                                        }
                                                        logMethod(
                                                            title:
                                                                'crown job string',
                                                            message: crownString
                                                                .toString());
                                                        // Monday at every day
                                                        // '59 23 * * 1'
              
                                                        // var weekList = ['Daily', '', '', ''];
                                                        // return;
                                                        
                                                        appConstants
                                                          .updateLoading(false);
                                                          
                                                        // String? responseNew = await CloudFunctions().updateAlloanceForUser(
                                                        //     userSenderId: appConstants
                                                        //         .userRegisteredId, 
                                                        //     useReceiverId:AppConstants.allonaceKidId,
                                                        //     userToken: appConstants
                                                        //         .userModel
                                                        //         .deviceToken,
                                                        //     amount: amountController.text.trim(),
                                                        //     notificationTitle: '${NotificationText.ALLOWANCE_ADDED_TITLE} ${getCurrencySymbol(context, appConstants: appConstants)}${amountController.text.trim()}',
                                                                
                                                        //     notificationSubTitle: NotificationText.ALLOWANCE_ADDED_SUBTITLE,
                                                        //     expression:
                                                        //         crownString);
                                                        //   // return;
                                                        // if(responseNew==null){
                                                          
                                                        //   return;
                                                        // }

                                                        // String? response = await CloudFunctions().callFunction(
                                                        //     userSenderId: appConstants
                                                        //         .userRegisteredId,
                                                        //     useReceiverId:AppConstants.allonaceKidId,
                                                        //     userToken: appConstants
                                                        //         .userModel
                                                        //         .deviceToken,
                                                        //     amount: amountController.text.trim(),
                                                        //     notificationTitle: '${NotificationText.ALLOWANCE_ADDED_TITLE} ${getCurrencySymbol(context, appConstants: appConstants)}${amountController.text.trim()}',
                                                                
                                                        //     notificationSubTitle: NotificationText.ALLOWANCE_ADDED_SUBTITLE,
                                                        //     expression:
                                                        //         crownString);
                                                        //   // return;
                                                        // if(response==null){
                                                        //   // return;
                                                        // }
                                                        // if(selectedKidAllowanSetById!=""){
                                                          //// Update logic here
                                                          // Sending the notification to kid
                                                          ApiServices().getUserTokenAndSendNotification(
                                                            userId: AppConstants.allonaceKidId,
                                                             title: selectedKidAllowanSetById!=""? NotificationText.ALLOWANCE_UPDATED : NotificationText.ALLOWANCE_ADDED_TITLE,
                                                            subTitle: selectedKidAllowanSetById!=""? "Your allowance amount has been updated by: ${appConstants.userModel.usaFirstName} ${appConstants.userModel.usaLastName}" : NotificationText.ALLOWANCE_ADDED_SUBTITLE
                                                          );
                                                          //Send secondry parent notification as well
                                                          String? secondryParentId = await ApiServices().fetchSecondryParent(appConstants.userRegisteredId);
                                                          ApiServices().getUserTokenAndSendNotification(
                                                            userId: secondryParentId,
                                                            title: "Allowance Updated for your kid",
                                                            subTitle: "Your kid allowance amount has been updated by: ${appConstants.userModel.usaFirstName} ${appConstants.userModel.usaLastName}"
                                                            );
                                                        // }
          
                                                        sendAllowanceData(
                                                            dateToSendAllowance:
                                                                date,
                                                            amount: amountController
                                                                .text,
                                                            allowanceSchedule:
                                                                appConstants
                                                                    .allowanceSchedule,
                                                            spendAnyWhereAmount: tempSepndAllowance
                                                                .toStringAsFixed(2),
                                                            savingAmount: tempsavingAllowance
                                                                .toStringAsFixed(2),
                                                            donationsAmount: tempdonationAllowance
                                                                .toStringAsFixed(2),
                                                            deliveryOn: appConstants
                                                                .allowanceDay,
                                                            kidId: AppConstants
                                                                .allonaceKidId!,
                                                            status: true,
                                                            parentId: selectedKidAllowanSetById!=""?selectedKidAllowanSetById : appConstants
                                                                .userRegisteredId,
                                                            donationsAmountPercent:
                                                                donationsController
                                                                    .text,
                                                            savingAmountPercent:
                                                                savingController
                                                                    .text,
                                                            spendAnyWhereAmountPercent:
                                                                spendAnyWhereController
                                                                    .text,
                                                            toDoLinked: linkToDo,
                                                            parentBankAccountToken: appConstants.userModel.userTokenId.toString(),
                                                            kidBankAccountToken: selectedKidBankAccountToken
                                                            );
                                                      }
              
                                                      //////////Hussams logic Start for transactions
              
                                                      if (spendAnyWhereController
                                                          .text.isNotEmpty) {
                                                        // ApiServices().addMoneyToSelectedMainWallet(
                                                        //     receivedUserId:
                                                        //         AppConstants
                                                        //             .allonaceKidId,
                                                        //     amountSend:
                                                        //         tempSepndAllowance
                                                        //             .toStringAsFixed(
                                                        //                 2),
                                                        //     senderId: appConstants
                                                        //         .userRegisteredId);
              
                                                        // In This Case only 2 transaction beacuse other wallets didnt have information
                                                        // // 1) Sender Side
                                                        // customTransactionAllowance(
                                                        //     amount: tempSepndAllowance
                                                        //         .toStringAsFixed(2),
                                                        //     senderName:
                                                        //         selectedKidName,
                                                        //     receiverName:
                                                        //         appConstants
                                                        //             .userModel
                                                        //             .usaUserName,
                                                        //     senderId: appConstants
                                                        //         .userRegisteredId,
                                                        //     receiverId: AppConstants
                                                        //         .allonaceKidId,
                                                        //     transationMethod:
                                                        //         AppConstants
                                                        //             .Transaction_Method_Payment,
                                                        //     appConstants:
                                                        //         appConstants,
                                                        //     fromWalletName:
                                                        //         AppConstants
                                                        //             .Spend_Wallet,
                                                        //     toWalletName:
                                                        //         AppConstants
                                                        //             .Spend_Wallet);
                                                        // // 2)Receiver Side
                                                        // customTransactionAllowance(
                                                        //     amount: tempSepndAllowance
                                                        //         .toStringAsFixed(2),
                                                        //     receiverName:
                                                        //         selectedKidName,
                                                        //     senderName: appConstants
                                                        //         .userModel
                                                        //         .usaUserName,
                                                        //     receiverId: appConstants
                                                        //         .userRegisteredId,
                                                        //     senderId: AppConstants
                                                        //         .allonaceKidId,
                                                        //     transationMethod:
                                                        //         AppConstants
                                                        //             .Transaction_Method_Received,
                                                        //     appConstants:
                                                        //         appConstants,
                                                        //     fromWalletName:
                                                        //         AppConstants
                                                        //             .Spend_Wallet,
                                                        //     toWalletName:
                                                        //         AppConstants
                                                        //             .Spend_Wallet);
                                                      }
                                                      if (savingController
                                                          .text.isNotEmpty) {
                                                        // Remove money To SAVINGS_WALLET this is users who is sending money
              
                                                        // await ApiServices().addMoneyToMainWallet(
                                                        //     amountSend:
                                                        //         tempsavingAllowance
                                                        //             .toStringAsFixed(
                                                        //                 2),
                                                        //     senderId: appConstants
                                                        //         .userRegisteredId,
                                                        //     walletName: AppConstants
                                                        //         .Spend_Wallet,
                                                        //     removeMoney: true);
                                                        // // Add Money to Savings wallet for slected User
                                                        // await ApiServices()
                                                        //     .addMoneyToMainWallet(
                                                        //   amountSend:
                                                        //       tempsavingAllowance
                                                        //           .toStringAsFixed(
                                                        //               2),
                                                        //   senderId: AppConstants
                                                        //       .allonaceKidId,
                                                        //   walletName: AppConstants
                                                        //       .Savings_Wallet,
                                                        // );
                                                        // // In This Case only 2 transaction beacuse other wallets didnt have information
                                                        // // 1) Sender Side
                                                        // customTransactionAllowance(
                                                        //     amount: tempsavingAllowance
                                                        //         .toStringAsFixed(2),
                                                        //     senderName:
                                                        //         selectedKidName,
                                                        //     receiverName:
                                                        //         appConstants
                                                        //             .userModel
                                                        //             .usaUserName,
                                                        //     senderId: appConstants
                                                        //         .userRegisteredId,
                                                        //     receiverId: AppConstants
                                                        //         .allonaceKidId,
                                                        //     transationMethod:
                                                        //         AppConstants
                                                        //             .Transaction_Method_Payment,
                                                        //     appConstants:
                                                        //         appConstants,
                                                        //     fromWalletName:
                                                        //         AppConstants
                                                        //             .Spend_Wallet,
                                                        //     toWalletName:
                                                        //         AppConstants
                                                        //             .Savings_Wallet);
                                                        // // 2)Receiver Side
                                                        // customTransactionAllowance(
                                                        //     amount: tempsavingAllowance
                                                        //         .toStringAsFixed(2),
                                                        //     receiverName:
                                                        //         selectedKidName,
                                                        //     senderName: appConstants
                                                        //         .userModel
                                                        //         .usaUserName,
                                                        //     receiverId: appConstants
                                                        //         .userRegisteredId,
                                                        //     senderId: AppConstants
                                                        //         .allonaceKidId,
                                                        //     transationMethod:
                                                        //         AppConstants
                                                        //             .Transaction_Method_Received,
                                                        //     appConstants:
                                                        //         appConstants,
                                                        //     fromWalletName:
                                                        //         AppConstants
                                                        //             .Spend_Wallet,
                                                        //     toWalletName:
                                                        //         AppConstants
                                                        //             .Savings_Wallet);
                                                      }
                                                      if (donationsController
                                                          .text.isNotEmpty) {
                                                        // await ApiServices().addMoneyToMainWallet(
                                                        //     amountSend:
                                                        //         tempdonationAllowance
                                                        //             .toStringAsFixed(
                                                        //                 2),
                                                        //     senderId: appConstants
                                                        //         .userRegisteredId,
                                                        //     walletName: AppConstants
                                                        //         .Spend_Wallet,
                                                        //     removeMoney: true);
                                                        // // Add Money to Savings wallet for slected User
                                                        // await ApiServices()
                                                        //     .addMoneyToMainWallet(
                                                        //   amountSend:
                                                        //       tempdonationAllowance
                                                        //           .toStringAsFixed(
                                                        //               2),
                                                        //   senderId: AppConstants
                                                        //       .allonaceKidId,
                                                        //   walletName: AppConstants
                                                        //       .Donations_Wallet,
                                                        // );
              
                                                        // // In This Case only 2 transaction beacuse other wallets didnt have information
                                                        // // 1) Sender Side
                                                        // customTransactionAllowance(
                                                        //     amount: tempdonationAllowance
                                                        //         .toStringAsFixed(2),
                                                        //     senderName:
                                                        //         selectedKidName,
                                                        //     receiverName:
                                                        //         appConstants
                                                        //             .userModel
                                                        //             .usaUserName,
                                                        //     senderId: appConstants
                                                        //         .userRegisteredId,
                                                        //     receiverId: AppConstants
                                                        //         .allonaceKidId,
                                                        //     transationMethod:
                                                        //         AppConstants
                                                        //             .Transaction_Method_Payment,
                                                        //     appConstants:
                                                        //         appConstants,
                                                        //     fromWalletName:
                                                        //         AppConstants
                                                        //             .Spend_Wallet,
                                                        //     toWalletName: AppConstants
                                                        //         .Donations_Wallet);
                                                        // // 2)Receiver Side
                                                        // customTransactionAllowance(
                                                        //     amount: tempdonationAllowance
                                                        //         .toStringAsFixed(2),
                                                        //     receiverName:
                                                        //         selectedKidName,
                                                        //     senderName: appConstants
                                                        //         .userModel
                                                        //         .usaUserName,
                                                        //     receiverId: appConstants
                                                        //         .userRegisteredId,
                                                        //     senderId: AppConstants
                                                        //         .allonaceKidId,
                                                        //     transationMethod:
                                                        //         AppConstants
                                                        //             .Transaction_Method_Received,
                                                        //     appConstants:
                                                        //         appConstants,
                                                        //     fromWalletName:
                                                        //         AppConstants
                                                        //             .Spend_Wallet,
                                                        //     toWalletName: AppConstants
                                                        //         .Donations_Wallet);
                                                      }
              
                                                      // ApiServices()
                                                      //     .getUserTokenAndSendNotification(
                                                      //         userId: AppConstants
                                                      //             .allonaceKidId,
                                                      //         title: '${NotificationText.ALLOWANCE_ADDED_TITLE} ${getCurrencySymbol(context, appConstants: appConstants)}${amountController.text.trim()}',
                                                      //             // '${getCurrencySymbol(context, appConstants: appConstants)}${amountController.text.trim()} allowance received from ${appConstants.userModel.usaFirstName}',
                                                      //         subTitle: NotificationText.ALLOWANCE_ADDED_SUBTITLE );
                                                                  // 'Allowance breakdown is: Spend Wallet: ${getCurrencySymbol(context, appConstants: appConstants)} ${tempSepndAllowance.toStringAsFixed(2)}, Savings Waller: ${getCurrencySymbol(context, appConstants: appConstants)} ${tempsavingAllowance.toStringAsFixed(2)}, Charity Wallet: ${getCurrencySymbol(context, appConstants: appConstants)} ${tempdonationAllowance.toStringAsFixed(2)}');
              
                                                      //////////Hussams logic end
              
                                                      ////////////////Comment my logic start
                                                      // if(spendAnyWhereController.text.isNotEmpty && savingController.text.isEmpty && donationsController.text.isEmpty){
                                                      // ApiServices().addMoneyToSelectedMainWallet(receivedUserId:AppConstants.allonaceKidId,
                                                      //         amountSend: amountController.text,
                                                      //         senderId: appConstants.userRegisteredId);
              
                                                      //   // In This Case only 2 transaction beacuse other wallets didnt have information
                                                      //   // 1) Sender Side
                                                      //   customTransactionAllowance(senderName: selectedKidName, receiverName: appConstants.userModel.usaUserName, senderId: appConstants.userRegisteredId, receiverId: AppConstants.allonaceKidId, transationMethod: AppConstants.Transaction_Method_Payment, appConstants: appConstants, fromWalletName: AppConstants.Spend_Wallet, toWalletName: AppConstants.Spend_Wallet);
                                                      //   // 2)Receiver Side
                                                      //   customTransactionAllowance(receiverName: selectedKidName, senderName: appConstants.userModel.usaUserName, receiverId: appConstants.userRegisteredId, senderId: AppConstants.allonaceKidId, transationMethod: AppConstants.Transaction_Method_Received, appConstants: appConstants, fromWalletName: AppConstants.Spend_Wallet, toWalletName: AppConstants.Spend_Wallet);
              
                                                      // } else if(spendAnyWhereController.text.isEmpty && savingController.text.isNotEmpty && donationsController.text.isEmpty){
                                                      //   // Remove money To SAVINGS_WALLET this is users who is sending money
              
                                                      //   ApiServices().addMoneyToMainWallet(amountSend: amountController.text.trim(), senderId: appConstants.userRegisteredId, walletName: AppConstants.Savings_Wallet, removeMoney: true);
                                                      //   // Add Money to Savings wallet for slected User
                                                      //   ApiServices().addMoneyToMainWallet(amountSend: amountController.text.trim(), senderId: appConstants.userRegisteredId, walletName: AppConstants.Savings_Wallet,);
                                                      //                                           // In This Case only 2 transaction beacuse other wallets didnt have information
                                                      //   // 1) Sender Side
                                                      //   customTransactionAllowance(senderName: selectedKidName, receiverName: appConstants.userModel.usaUserName, senderId: appConstants.userRegisteredId, receiverId: AppConstants.allonaceKidId, transationMethod: AppConstants.Transaction_Method_Payment, appConstants: appConstants, fromWalletName: AppConstants.Spend_Wallet, toWalletName: AppConstants.Savings_Wallet);
                                                      //   // 2)Receiver Side
                                                      //   customTransactionAllowance(receiverName: selectedKidName, senderName: appConstants.userModel.usaUserName, receiverId: appConstants.userRegisteredId, senderId: AppConstants.allonaceKidId, transationMethod: AppConstants.Transaction_Method_Received, appConstants: appConstants, fromWalletName: AppConstants.Spend_Wallet, toWalletName: AppConstants.Savings_Wallet);
                                                      // } else if(spendAnyWhereController.text.isEmpty && savingController.text.isEmpty && donationsController.text.isNotEmpty){
                                                      //   // Remove money To SAVINGS_WALLET this is users who is sending money
              
                                                      //   ApiServices().addMoneyToMainWallet(amountSend: amountController.text.trim(), senderId: appConstants.userRegisteredId, walletName: AppConstants.Donations_Wallet, removeMoney: true);
                                                      //   // Add Money to Savings wallet for slected User
                                                      //   ApiServices().addMoneyToMainWallet(amountSend: amountController.text.trim(), senderId: appConstants.userRegisteredId, walletName: AppConstants.Donations_Wallet,);
              
                                                      //   // In This Case only 2 transaction beacuse other wallets didnt have information
                                                      //   // 1) Sender Side
                                                      //   customTransactionAllowance(senderName: selectedKidName, receiverName: appConstants.userModel.usaUserName, senderId: appConstants.userRegisteredId, receiverId: AppConstants.allonaceKidId, transationMethod: AppConstants.Transaction_Method_Payment, appConstants: appConstants, fromWalletName: AppConstants.Spend_Wallet, toWalletName: AppConstants.Donations_Wallet);
                                                      //   // 2)Receiver Side
                                                      //   customTransactionAllowance(receiverName: selectedKidName, senderName: appConstants.userModel.usaUserName, receiverId: appConstants.userRegisteredId, senderId: AppConstants.allonaceKidId, transationMethod: AppConstants.Transaction_Method_Received, appConstants: appConstants, fromWalletName: AppConstants.Spend_Wallet, toWalletName: AppConstants.Donations_Wallet);
              
                                                      // }
              
                                                      ////////////////////Comment my logic end
                                                      //////////Commented Now have to change For new implementation
                                                      // ApiServices()
                                                      //     .addMoneyToSelectedSavingWallet(
                                                      //         receivedUserId:
                                                      //             AppConstants.allonaceKidId,
                                                      //         amountSend: amountController.text,
                                                      //         senderId: appConstants
                                                      //             .userRegisteredId);
                                                      // ApiServices()
                                                      //     .addMoneyToSelectedCharityWallet(
                                                      //         receivedUserId:
                                                      //             AppConstants.allonaceKidId,
                                                      //         amountSend: amountController.text,
                                                      //         senderId: appConstants
                                                      //             .userRegisteredId);
                                                      appConstants
                                                          .updateLoading(false);
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  CustomConfermationScreen(
                                                                    title:
                                                                        'Allowance Updated',
                                                                    // subTitle: "${getCurrencySymbol(context, appConstants: appConstants)} ${amountController.text} added to your \n${appConstants.nickNameModel.NickN_SpendWallet?? 'Spend'} Wallet",
                                                                  )));
                                                      ///////////End Of Update Allowaance
                                                    }),
                              spacing_medium,
                              // CustomTextButton(width: width, onPressed: (){}, title: 'text'),
                              // spacing_medium,
                              (appConstants.userModel.usaUserType !=
                                      AppConstants.USER_TYPE_PARENT)
                                  ? SizedBox.shrink()
                                  : Row(
                                      children: [
                                        Expanded(
                                          child: CustomTextButton(
                                              width: width,
                                              title: 'Reset',
                                              onPressed: internet.status ==
                                              AppConstants
                                                  .INTERNET_STATUS_NOT_CONNECTED
                                          ? null
                                          : (check100Per!=100 || hasBalance == false ||
                                                  error != null ||
                                                  appConstants.isLoading == true ||
                                                  selectedKidId == '')
                                              ? null
                                              : (amountController.text
                                                          .trim()
                                                          .isEmpty ||
                                                      AppConstants.allonaceKidId ==
                                                          '')
                                                  ? null
                                                  : () async{
                                                    showDialog(
                                context: context,
                                builder: (BuildContext dialougeContext) =>
                                                     AlertDialog(
                                        // title: TextHeader1(title: ''),
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(14.0))),
                                        content: TextValue2(
                                          title:
                                              'Are you sure you want to Reset?',
                                        ),
                                        actions: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          ZakiCicularButton(
                                            title: '     Yes     ',
                                            width: width,
                                            textStyle: heading4TextSmall(width,
                                                color: green),
                                            onPressed: () async {
                                              bool? checkAuth = await authenticateTransactionUsingBioOrPinCode(appConstants: appConstants, context: context);
                                                      if(checkAuth==false){
                                                        return;
                                                      }
                                                      reSetAmount(
                                                          spendAmount: '80',
                                                          amount: '',
                                                          savingAmount: '17',
                                                          donationAmount: '3');
                                                        
                                              Navigator.pop(dialougeContext);
                                              //  Navigator.pop(dialougeContext);
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
                                            textStyle: heading4TextSmall(width,
                                                color: white),
                                            onPressed: () {
                                              Navigator.pop(dialougeContext);
                                            },
                                          ),
                                        ],
                                      ),
                                    ]
                                        // actions
                                        ));

                                                    
                                                    }),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: status != true
                                              ? const SizedBox()
                                              : CustomTextButton(
                                                  width: width,
                                                  title: 'Pause',
                                                  onPressed: internet.status ==
                                              AppConstants
                                                  .INTERNET_STATUS_NOT_CONNECTED
                                          ? null
                                          : (check100Per!=100 || hasBalance == false ||
                                                  error != null ||
                                                  appConstants.isLoading == true ||
                                                  selectedKidId == '')
                                              ? null
                                              : (amountController.text
                                                          .trim()
                                                          .isEmpty ||
                                                      AppConstants.allonaceKidId ==
                                                          '')
                                                  ? null
                                                  : () async{
                                                    showDialog(
                                context: context,
                                builder: (BuildContext dialougeContext) =>AlertDialog(
                                        // title: TextHeader1(title: ''),
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(14.0))),
                                        content: TextValue2(
                                          title:
                                              'Are you sure you want to Pause?',
                                        ),
                                        actions: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          ZakiCicularButton(
                                            title: '     Yes     ',
                                            width: width,
                                            textStyle: heading4TextSmall(width,
                                                color: green),
                                            onPressed: () async {
                                               bool? checkAuth = await authenticateTransactionUsingBioOrPinCode(appConstants: appConstants, context: context);
                                                      if(checkAuth==false){
                                                        return;
                                                      }

                                                          ApiServices services =
                                                              ApiServices();
                                                          setState(() {
                                                            status = !status;
                                                          });
                                                          services
                                                              .updateAllowanceStatus(
                                                                  kidId: AppConstants
                                                                      .allonaceKidId,
                                                                  status: status);
                                                          services.getUserTokenAndSendNotification(
                                                              userId: AppConstants
                                                                  .allonaceKidId,
                                                              title:
                                                                  '${appConstants.userModel.usaUserName} ${NotificationText.ALLOWANCE_UPDATED}',
                                                              subTitle:
                                                                  '${NotificationText.ALLOWANCE_UPDATED}');
                                                        
                                              Navigator.pop(dialougeContext);
                                              //  Navigator.pop(dialougeContext);
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
                                            textStyle: heading4TextSmall(width,
                                                color: white),
                                            onPressed: () {
                                              Navigator.pop(dialougeContext);
                                            },
                                          ),
                                        ],
                                      ),
                                    ]
                                        // actions
                                        ));
                                                       },
                                                ),
                                        )
                                      ],
                                    ),
                              spacing_medium,
                            ],
                          ),
                        ),
              
                        //   if(viewScreen)
                        // CustomBluredScreen()
                      ],
                    ),
                  ],
                ),
              ]),
            ],
          ),
        ),
      )),
    );
  }

  Future<String> customTransactionAllowance(
      {required String? amount,
      String? senderName,
      String? receiverName,
      String? senderId,
      String? receiverId,
      String? transationMethod,
      AppConstants? appConstants,
      String? fromWalletName,
      String? toWalletName}) {
    logMethod(title: 'transaction Amount', message: amount);
    return ApiServices().addTransaction(
        transactionMethod: transationMethod,
        tagItId: '11',
        tagItName: AppConstants.Allowance,
        selectedKidName: receiverName,
        accountHolderName: senderName,
        amount: amount,
        currentUserId: senderId,
        receiverId: receiverId,
        requestType: AppConstants.TAG_IT_Transaction_TYPE_ALLOWANCE,
        senderId: senderId,
        message: '',
        fromWallet: fromWalletName,
        toWallet: toWalletName);
  }

  int allowanceDay({String? day}) {
    if (day == 'Monday') {
      return 1;
    } else if (day == 'Tuesday') {
      return 2;
    } else if (day == 'Wednesday') {
      return 3;
    } else if (day == 'Thursday') {
      return 4;
    } else if (day == 'Friday') {
      return 5;
    } else if (day == 'Saturday') {
      return 6;
    } else if (day == 'Sunday') {
      return 7;
    } else {
      return 0;
    }
  }
}

extension DateTimeExtension on DateTime {
  DateTime next(int day) {
    return add(
      Duration(
        days: (day - weekday) % DateTime.daysPerWeek,
      ),
    );
  }
}
