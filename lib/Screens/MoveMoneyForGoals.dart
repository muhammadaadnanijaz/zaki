import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:zaki/Constants/AuthMethods.dart';
import 'package:zaki/Constants/CheckInternetConnections.dart';
import 'package:zaki/Constants/HelperFunctions.dart';
import 'package:zaki/Constants/LocationGetting.dart';
import 'package:zaki/Constants/NotificationTitle.dart';
import 'package:zaki/Constants/Spacing.dart';
import 'package:zaki/Constants/Styles.dart';
import 'package:zaki/Models/BalanceModel.dart';
import 'package:zaki/Screens/FromAccount.dart';
import 'package:zaki/Services/CreaditCardApis.dart';
import 'package:zaki/Services/api.dart';
import 'package:zaki/Widgets/TextHeader.dart';
import '../Constants/AppConstants.dart';
import '../Widgets/AppBars/AppBar.dart';
import '../Widgets/CustomConfermationScreen.dart';
import '../Widgets/CustomTextField.dart';
import '../Widgets/ZakiPrimaryButton.dart';

class MoveMoneyForGoals extends StatefulWidget {
  final String? documentId;
  final double? collectedAmount;
  final String? receiverUserId;
  final String? goalSetterUserId;
  final String? goalTitle;
  const MoveMoneyForGoals(
      {Key? key,
      required this.goalTitle,
      this.documentId,
      this.collectedAmount,
      this.receiverUserId,
      this.goalSetterUserId})
      : super(key: key);

  @override
  _MoveMoneyForGoalsState createState() => _MoveMoneyForGoalsState();
}

class _MoveMoneyForGoalsState extends State<MoveMoneyForGoals> {
  final amountController = TextEditingController();
  String? error = null;

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      logMethod(title: 'Fund My Wallet Screen', message: 'Called');
      var appConstants = Provider.of<AppConstants>(context, listen: false);
      bool screenNotOpen =
          await checkUserSubscriptionValue(appConstants, context);
      logMethod(title: 'Data from Pay+', message: screenNotOpen.toString());
      if (screenNotOpen == true) {
        Navigator.pop(context);
      } else {
        logMethod(
            title: 'Selected USER Id in Move Money',
            message: widget.receiverUserId.toString());
      }
    });
    super.initState();
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
          child: Padding(
            padding: getCustomPadding(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                appBarHeader_005(
                    context: context,
                    appBarTitle: 'Move Money',
                    height: height,
                    width: width),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextHeader1(
                      title: 'Enter Amount',
                    ),
                    CustomTextField(
                      amountController: amountController,
                      error: error == null ? null : error,
                      onChanged: (String value) {
                        // if(error!=null)
                        setState(() {
                          error = null;
                          logMethod(
                              title: 'Error message onchange',
                              message: error.toString());
                        });
                      },
                      onFieldSubmitted: (String value) {
                        if (error != null)
                          setState(() {
                            error = null;
                            logMethod(
                                title: 'Error message onFieldSubmitted',
                                message: error.toString());
                          });
                      },
                    ),
                    spacing_large,
                    TextHeader1(
                      title: 'From',
                    ),
                    spacing_medium,
                    InkWell(
                      onTap: () async {
                        bool screenNotOpen = await checkUserSubscriptionValue(
                            appConstants, context);
                        if (screenNotOpen == false) {
                          appConstants.updateIItfromAcoountOrNot(true);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const FromAccount()));
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextValue1(
                            title: appConstants.selectFromWallet,
                          ),
                          Icon(
                            Icons.keyboard_arrow_down_outlined,
                            color: green,
                          )
                        ],
                      ),
                    ),
                    Divider(
                      color: black,
                    ),
                    SizedBox(
                      height: height * 0.4,
                    ),
                    ZakiPrimaryButton(
                        width: width,
                        title: 'Move',
                        onPressed: (appConstants.isLoading ||
                                amountController.text.isEmpty ||
                                int.tryParse(amountController.text.trim())! >
                                    500 ||
                                appConstants.selectFromWallet == 'Select')
                            ? null
                            : internet.status ==AppConstants.INTERNET_STATUS_NOT_CONNECTED ? null :() async {
                              bool? checkAuth = await authenticateTransactionUsingBioOrPinCode(appConstants: appConstants, context: context);
                                                  if(checkAuth==false){
                                                    return;
                                                  }
                                ApiServices service = ApiServices();
                                // logMethod(title: 'Memo', message: createMemo(
                                //                       fromWallet: appConstants.selectFromWalletRealName,
                                //                       toWallet: AppConstants.All_Goals_Wallet,
                                //                       transactionMethod:AppConstants.Transaction_Method_Received,
                                //                       tagItName: AppConstants.GOAL,
                                //                       tagItId: "8",
                                //                       goalId: widget.documentId,
                                //                       transactionType: AppConstants.TAG_IT_Transaction_TYPE_GOALS
                                //                       ).length.toString());
                                // return;
                                logMethod(
                                    title:
                                        'Receiver User Id and goal Setter User id',
                                    message:
                                        'R: ${widget.receiverUserId} GS: ${widget.goalSetterUserId} and GID: ${widget.documentId} and ${appConstants.selectFromWalletRealName}');
                                /////////Marqata Logic for checking Balance and pay user
                                if (widget.receiverUserId != null) {
                                  CreaditCardApi creaditCardApi =
                                      CreaditCardApi();
                                  BalanceModel? balanceModel =
                                      await creaditCardApi.checkBalance(
                                          userToken: appConstants
                                              .userModel.userTokenId);
                                  if (balanceModel!.gpa.availableBalance <
                                      int.parse(amountController.text
                                          .trim()
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
                                    Position userLocation =await UserLocation().determinePosition();
                                    // selectedUserToken

                                    String? selectedUserAccountNumber =
                                        await service.getAccountNumberFromId(
                                            userId: widget.receiverUserId);
                                    await creaditCardApi.moveMoney(
                                        amount: amountController.text.trim(),
                                        name:
                                            appConstants.userModel.usaFirstName,
                                        senderUserToken:
                                            appConstants.userModel.userTokenId,
                                        receiverUserToken:
                                            selectedUserAccountNumber,
                                        // memo: createMemo(
                                        //     // fromWallet: appConstants.selectFromWalletRealName,
                                        //     // toWallet: AppConstants.All_Goals_Wallet,
                                        //     // transactionMethod:AppConstants.Transaction_Method_Received,
                                        //     // tagItName: AppConstants.GOAL,
                                        //     // tagItId: "8",
                                        //     // goalId: widget.documentId,
                                        //     // transactionType: AppConstants.TAG_IT_Transaction_TYPE_GOALS
                                        //     ),
                                        tags: createMemo(
                                          fromWallet: appConstants
                                              .selectFromWalletRealName,
                                          toWallet:
                                              AppConstants.All_Goals_Wallet,
                                          transactionMethod: AppConstants
                                              .Transaction_Method_Received,
                                          tagItName: AppConstants.GOAL,
                                          tagItId: "10",
                                          goalId: widget.documentId,
                                          transactionType: AppConstants
                                              .TAG_IT_Transaction_TYPE_GOALS,
                                          receiverId: widget.receiverUserId,
                                          senderId:
                                              appConstants.userRegisteredId,
                                          transactionId: '',
                                          latLng: '${userLocation.latitude},${userLocation.longitude}'
                                          // transactionId: transaction
                                        )

                                        // memo: "TT=02 , To:Go01, GoalID:1234, TM=P"
                                        // receiverUserToken: widget.receiverUserId
                                        );
                                    // showNotification(
                                    //       error: 0,
                                    //       icon: Icons.balance,
                                    //       message:
                                    //           'You have enough funds');
                                  }
                                }
                                ////////// End marqata Logic for checking Balance and pay user
                                ///
                                // return;

                                bool? hasBalance = await service.checkBalance(
                                    amount: double.parse(
                                        amountController.text.trim()),
                                    selectedWalletName: appConstants
                                                .selectFromWalletRealName ==
                                            'Spend Anywhere'
                                        ? AppConstants.Spend_Wallet
                                        : appConstants
                                                    .selectFromWalletRealName ==
                                                'Savings'
                                            ? AppConstants.Savings_Wallet
                                            : AppConstants.Donations_Wallet,
                                    userId: appConstants.userRegisteredId);
                                if (hasBalance == false) {
                                  setState(() {
                                    error =
                                        'Not enough money :(  add funds to your wallet first';
                                  });
                                  showNotification(
                                      error: 1,
                                      icon: Icons.error,
                                      message:
                                          NotificationText.NOT_ENOUGH_BALANCE);
                                  return;
                                }
                                appConstants.updateLoading(true);
                                logMethod(
                                    title: 'Wallet selected from',
                                    message:
                                        '${appConstants.selectFromWalletRealName}');
                                // return;
                                // if (appConstants.personalizationSettingModel != null &&
                                //     appConstants.personalizationSettingModel!.kidPLockSavings ==
                                //         true) {
                                //   showNotification(
                                //       error: 1,
                                //       icon: Icons.error,
                                //       message: 'Your Wallet is Locked');
                                //   return;
                                // }
                                // ///////
                                service.moveyMoneyForGoals(
                                  amount: double.parse(amountController.text),
                                  documentId: appConstants.userRegisteredId,
                                  receiverId: widget.receiverUserId != null
                                      ? widget.receiverUserId
                                      : null,
                                  /////////Selected Wallet name Where we need to remove mmoney from
                                  selectedWalletName: appConstants
                                              .selectFromWalletRealName ==
                                          'Spend Anywhere'
                                      ? AppConstants.Spend_Wallet
                                      : appConstants.selectFromWalletRealName ==
                                              'Savings'
                                          ? AppConstants.Savings_Wallet
                                          : AppConstants.Donations_Wallet,
                                );
                                ///////////
                                ///////////Now we need to add amount to that particular goal
                                await service.moveMoneyToSelectedGoal(
                                  amount: double.parse(amountController.text),
                                  documentId: widget.documentId,
                                  // collectedAmount: widget.collectedAmount
                                );
                                service.addContribution(
                                    contribution_amount_currency:
                                        "${getCurrencySymbol(context, appConstants: appConstants)}",
                                    contributor_user_Id:
                                        appConstants.userRegisteredId,
                                    countributed_amount:
                                        amountController.text.trim(),
                                    goalId: widget.documentId,
                                    contributor_wallet_name: widget
                                                .goalSetterUserId ==
                                            appConstants.userRegisteredId
                                        ? appConstants
                                                    .selectFromWalletRealName ==
                                                'Spend Anywhere'
                                            ? AppConstants.Spend_Wallet
                                            : appConstants
                                                        .selectFromWalletRealName ==
                                                    'Savings'
                                                ? AppConstants.Savings_Wallet
                                                : AppConstants.Donations_Wallet
                                        : '');
                                if (widget.receiverUserId != null) {
                                  service.addTransaction(
                                      transactionMethod: AppConstants
                                          .Transaction_Method_Payment,
                                      tagItName: AppConstants.GOAL,
                                      tagItId: "10",
                                      selectedKidName:
                                          appConstants.userModel.usaFirstName,
                                      accountHolderName:
                                          appConstants.userModel.usaFirstName,
                                      amount: amountController.text.trim(),
                                      currentUserId:
                                          appConstants.userRegisteredId,
                                      receiverId: appConstants.userRegisteredId,
                                      requestType:
                                          AppConstants.TAG_IT_Transaction_TYPE_GOALS,
                                      senderId: appConstants.userRegisteredId,
                                      message: widget.goalTitle,
                                      fromWallet:
                                          appConstants.selectFromWalletRealName,
                                      toWallet: AppConstants.All_Goals_Wallet);

                                  service.addTransaction(
                                      transactionMethod: AppConstants
                                          .Transaction_Method_Received,
                                      tagItName: AppConstants.GOAL,
                                      tagItId: "10",
                                      selectedKidName:
                                          appConstants.userModel.usaFirstName,
                                      accountHolderName:
                                          appConstants.userModel.usaFirstName,
                                      amount: amountController.text.trim(),
                                      currentUserId: widget.receiverUserId,
                                      receiverId: appConstants.userRegisteredId,
                                      requestType:
                                          AppConstants.TAG_IT_Transaction_TYPE_GOALS,
                                      senderId: appConstants.userRegisteredId,
                                      message: widget.goalTitle,
                                      fromWallet:
                                          appConstants.selectFromWalletRealName,
                                      toWallet: AppConstants.All_Goals_Wallet);
                                } else {
                                  service.addTransaction(
                                      transactionMethod: AppConstants
                                          .Transaction_Method_Payment,
                                      tagItName: AppConstants.GOAL,
                                      tagItId: "10",
                                      selectedKidName:
                                          appConstants.userModel.usaFirstName,
                                      accountHolderName:
                                          appConstants.userModel.usaFirstName,
                                      amount: amountController.text.trim(),
                                      currentUserId:
                                          widget.receiverUserId != null
                                              ? widget.receiverUserId
                                              : appConstants.userRegisteredId,
                                      receiverId: appConstants.userRegisteredId,
                                      requestType:
                                          AppConstants.TAG_IT_Transaction_TYPE_GOALS,
                                      senderId: appConstants.userRegisteredId,
                                      message: widget.goalTitle,
                                      fromWallet:
                                          appConstants.selectFromWalletRealName,
                                      toWallet: AppConstants.All_Goals_Wallet);

                                  service.addTransaction(
                                      transactionMethod:
                                          widget.receiverUserId != null
                                              ? AppConstants
                                                  .Transaction_Method_Payment
                                              : AppConstants
                                                  .Transaction_Method_Received,
                                      tagItName: AppConstants.GOAL,
                                      tagItId: "10",
                                      selectedKidName:
                                          appConstants.userModel.usaFirstName,
                                      accountHolderName:
                                          appConstants.userModel.usaFirstName,
                                      amount: amountController.text.trim(),
                                      currentUserId:
                                          appConstants.userRegisteredId,
                                      receiverId: appConstants.userRegisteredId,
                                      requestType:
                                          AppConstants.TAG_IT_Transaction_TYPE_GOALS,
                                      senderId: appConstants.userRegisteredId,
                                      message: widget.goalTitle,
                                      fromWallet:
                                          appConstants.selectFromWalletRealName,
                                      toWallet: AppConstants.All_Goals_Wallet);
                                }
                                await service.getUserTokenAndSendNotification(
                                    userId: widget.receiverUserId,
                                    title:
                                        '${appConstants.userModel.usaUserName} ${NotificationText.REQUEST_NOTIFICATION_TITLE}',
                                    subTitle:
                                        '${NotificationText.REQUEST_NOTIFICATION_SUB_TITLE}',
                                    checkParent: true,
                                    parentTitle: '${appConstants.userModel.usaUserName} sent ${getCurrencySymbol(context, appConstants: appConstants)} ${amountController.text}',
                                    parentSubtitle: 'See Details in ZakiPay'
                                        );
                                // if (appConstants.selectFromWallet == 'Spend Anywhere' &&
                                //     appConstants.selectToWallet == 'Spend Anywhere') {
                                //   // await service.moveMoneyBetweenWallet(
                                //   //     walletName: AppConstants.USER_Main_Wallet,
                                //   //     walletNameFrom: AppConstants.USER_Main_Wallet,
                                //   //     amountSend: amountController.text,
                                //   //     senderId: appConstants.userRegisteredId,
                                //   //     receivedUserId: appConstants.userRegisteredId);
                                // }  else {

                                showNotification(
                                    error: 0,
                                    icon: Icons.check,
                                    message:
                                        NotificationText.GOAL_AMOUNT_ADDED);
                                appConstants.updateLoading(false);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            CustomConfermationScreen(
                                              // title: 'Mission Accomplished!',
                                              subTitle:
                                                  "${getCurrencySymbol(context, appConstants: appConstants)} ${amountController.text} added to Goal",
                                            )));
                                // }
                              })
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
