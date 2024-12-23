import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zaki/Constants/CheckInternetConnections.dart';
import 'package:zaki/Constants/HelperFunctions.dart';
import 'package:zaki/Constants/NotificationTitle.dart';
import 'package:zaki/Constants/Spacing.dart';
import 'package:zaki/Constants/Styles.dart';
import 'package:zaki/Screens/FromAccount.dart';
import 'package:zaki/Services/api.dart';
import '../Constants/AppConstants.dart';
import '../Widgets/AppBars/AppBar.dart';
import '../Widgets/CustomConfermationScreen.dart';
import '../Widgets/CustomTextField.dart';
import '../Widgets/ZakiPrimaryButton.dart';

class MoveInternalMoney extends StatefulWidget {
  const MoveInternalMoney({Key? key}) : super(key: key);

  @override
  _MoveInternalMoneyState createState() => _MoveInternalMoneyState();
}

class _MoveInternalMoneyState extends State<MoveInternalMoney> {
  final amountController = TextEditingController();
  final messageController = TextEditingController();
  bool? isSuccessfull = false;
  String? error = null;

  @override
  void dispose() {
    amountController.dispose();
    messageController.dispose();
    super.dispose();
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setScreenName(name: AppConstants.MOVE_MONEY_INTERNALLY);
  }

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      var appConstants = Provider.of<AppConstants>(context, listen: false);

      bool screenNotOpen =
          await checkUserSubscriptionValue(appConstants, context);
      logMethod(title: 'Data from', message: screenNotOpen.toString());
      if (screenNotOpen == true) {
        Navigator.pop(context);
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
                    Text(
                      'Move money between your accounts, a.k.a: Internal Transfer',
                      style: heading3TextStyle(width),
                    ),
                    spacing_large,
                    Text(
                      'From:',
                      style: heading1TextStyle(context, width),
                    ),
                    spacing_small,
                    InkWell(
                      onTap: () {
                        appConstants.updateIItfromAcoountOrNot(true);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const FromAccount()));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            appConstants.selectFromWallet,
                            style: heading2TextStyle(context, width),
                          ),
                          Icon(
                            Icons.keyboard_arrow_down_outlined,
                            color: green,
                          )
                        ],
                      ),
                    ),
                    Divider(
                      color: black.withOpacity(0.35),
                    ),
                    spacing_medium,
                    Text(
                      'To:',
                      style: heading1TextStyle(context, width),
                    ),
                    spacing_small,
                    InkWell(
                      onTap: () {
                        appConstants.updateIItfromAcoountOrNot(false);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const FromAccount()));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            appConstants.selectToWallet,
                            style: heading2TextStyle(context, width),
                          ),
                          Icon(
                            Icons.keyboard_arrow_down_outlined,
                            color: green,
                          )
                        ],
                      ),
                    ),
                    Divider(
                      color: black.withOpacity(0.35),
                    ),
                    spacing_medium,
                    Text(
                      'Enter Amount:',
                      style: heading1TextStyle(context, width),
                    ),
                    CustomTextField(
                      amountController: amountController,
                      // validator: (String? amount){
                      //   if (amount!.isEmpty) {
                      //     return 'Please Enter Amount';
                      //   }else if(double.parse(amount)>500) {
                      //     return "Please enter less than 500";
                      //   }  else {
                      //     return null;
                      //   }
                      // },
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
                        setState(() {
                          isSuccessfull = true;
                        });
                      },
                    ),
                    spacing_large,
                    Text(
                      'Reason:',
                      style: heading1TextStyle(context, width),
                    ),
                    TextFormField(
                      style: heading3TextStyle(width, font: 14, color: green),
                      controller: messageController,
                      obscureText: false,
                      keyboardType: TextInputType.emailAddress,
                      maxLines: null,
                      maxLength: 40,
                      decoration: InputDecoration(
                        // counterText: '',
                        isDense: true,
                        hintText: 'Optional',
                        hintStyle:
                            heading3TextStyle(width, font: 14, color: green),
                        // enabledBorder: UnderlineInputBorder( //<-- SEE HERE
                        //   borderSide: BorderSide(
                        //       width: 1, color: green),
                        // ),
                        focusedBorder: UnderlineInputBorder(
                          //<-- SEE HERE
                          borderSide: BorderSide(width: 1, color: green),
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
                    SizedBox(height: height * 0.1),
                    ZakiPrimaryButton( 
                      width: width,
                      title: 'Move',
                      onPressed: (internet.status ==
                                  AppConstants.INTERNET_STATUS_NOT_CONNECTED ||
                              amountController.text.isEmpty ||
                              int.tryParse(amountController.text.trim())! >
                                  500 ||
                              appConstants.selectFromWalletRealName ==
                                  appConstants.selectToWalletRealName)
                          ? null
                          : isSuccessfull == false
                              ? null
                              : () async {
                                  ApiServices service = ApiServices();
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
                                        message: NotificationText
                                            .NOT_ENOUGH_BALANCE);
                                    return;
                                  }
                                  appConstants.updateLoading(true);
                                  if (appConstants.selectFromWalletRealName ==
                                          'Spend Anywhere' &&
                                      appConstants.selectToWalletRealName ==
                                          'Spend Anywhere') {
                                    isSuccessfull = await service.moveMoney(
                                      amount: double.parse(
                                          amountController.text.trim()),
                                      fromWalletName: AppConstants.Spend_Wallet,
                                      toWalletName: AppConstants.Spend_Wallet,
                                      userId: appConstants.userRegisteredId,
                                    );
                                    logMethod(
                                        title: "IsSuccessful message",
                                        message: isSuccessfull.toString());
                                  } else if (appConstants.selectFromWalletRealName ==
                                          'Charity' &&
                                      appConstants.selectToWalletRealName ==
                                          'Charity') {
                                    isSuccessfull = await service.moveMoney(
                                      amount: double.parse(
                                          amountController.text.trim()),
                                      fromWalletName:
                                          AppConstants.Donations_Wallet,
                                      toWalletName:
                                          AppConstants.Donations_Wallet,
                                      userId: appConstants.userRegisteredId,
                                    );
                                    // await service.moveMoneyBetweenWallet(
                                    //     walletName: 'USER_Charity_wallet',
                                    //     walletNameFrom: 'USER_Charity_wallet',
                                    //     amountSend: amountController.text,
                                    //     senderId: appConstants.userRegisteredId,
                                    //     receivedUserId: appConstants.userRegisteredId);
                                  } else if (appConstants.selectFromWalletRealName ==
                                          'Savings' &&
                                      appConstants.selectToWalletRealName ==
                                          'Savings') {
                                    isSuccessfull = await service.moveMoney(
                                      amount: double.parse(
                                          amountController.text.trim()),
                                      fromWalletName:
                                          AppConstants.Savings_Wallet,
                                      toWalletName: AppConstants.Savings_Wallet,
                                      userId: appConstants.userRegisteredId,
                                    );

                                    // await service.moveMoneyBetweenWallet(
                                    //     walletName: 'USER_Savings_wallet',
                                    //     walletNameFrom: 'USER_Savings_wallet',
                                    //     amountSend: amountController.text,
                                    //     senderId: appConstants.userRegisteredId,
                                    //     receivedUserId: appConstants.userRegisteredId);
                                  } else if (appConstants.selectFromWalletRealName ==
                                          'Savings' &&
                                      appConstants.selectToWalletRealName ==
                                          'Charity') {
                                    isSuccessfull ==
                                        await service.moveMoney(
                                          amount: double.parse(
                                              amountController.text.trim()),
                                          fromWalletName:
                                              AppConstants.Savings_Wallet,
                                          toWalletName:
                                              AppConstants.Donations_Wallet,
                                          userId: appConstants.userRegisteredId,
                                        );
                                    // await service.moveMoneyBetweenWallet(
                                    //     walletName: 'USER_Savings_wallet',
                                    //     walletNameFrom: 'USER_Charity_wallet',
                                    //     amountSend: amountController.text,
                                    //     senderId: appConstants.userRegisteredId,
                                    //     receivedUserId: appConstants.userRegisteredId);
                                  } else if (appConstants.selectFromWalletRealName ==
                                          'Charity' &&
                                      appConstants.selectToWalletRealName ==
                                          'Savings') {
                                    isSuccessfull = await service.moveMoney(
                                      amount: double.parse(
                                          amountController.text.trim()),
                                      fromWalletName:
                                          AppConstants.Donations_Wallet,
                                      toWalletName: AppConstants.Savings_Wallet,
                                      userId: appConstants.userRegisteredId,
                                    );

                                    // await service.moveMoneyBetweenWallet(
                                    //     walletName: 'USER_Charity_wallet',
                                    //     walletNameFrom: 'USER_Savings_wallet',
                                    //     amountSend: amountController.text,
                                    //     senderId: appConstants.userRegisteredId,
                                    //     receivedUserId: appConstants.userRegisteredId);
                                  } else if (appConstants.selectFromWalletRealName ==
                                          'Savings' &&
                                      appConstants.selectToWalletRealName ==
                                          'Spend Anywhere') {
                                    isSuccessfull = await service.moveMoney(
                                      amount: double.parse(
                                          amountController.text.trim()),
                                      fromWalletName:
                                          AppConstants.Savings_Wallet,
                                      toWalletName: AppConstants.Spend_Wallet,
                                      userId: appConstants.userRegisteredId,
                                    );

                                    // await service.moveMoneyBetweenWallet(
                                    //     walletName: 'USER_Savings_wallet',
                                    //     walletNameFrom: AppConstants.USER_Main_Wallet,
                                    //     amountSend: amountController.text,
                                    //     senderId: appConstants.userRegisteredId,
                                    //     receivedUserId: appConstants.userRegisteredId);

                                    //This
                                  } else if (appConstants.selectFromWalletRealName ==
                                          'Spend Anywhere' &&
                                      appConstants.selectToWalletRealName ==
                                          'Savings') {
                                    isSuccessfull = await service.moveMoney(
                                      amount: double.parse(
                                          amountController.text.trim()),
                                      fromWalletName: AppConstants.Spend_Wallet,
                                      toWalletName: AppConstants.Savings_Wallet,
                                      userId: appConstants.userRegisteredId,
                                    );

                                    // await service.moveMoneyBetweenWallet(
                                    //     walletName: AppConstants.USER_Main_Wallet,
                                    //     walletNameFrom: 'USER_Savings_wallet',
                                    //     amountSend: amountController.text,
                                    //     senderId: appConstants.userRegisteredId,
                                    //     receivedUserId: appConstants.userRegisteredId);
                                  } else if (appConstants.selectFromWalletRealName ==
                                          'Charity' &&
                                      appConstants.selectToWalletRealName ==
                                          'Spend Anywhere') {
                                    isSuccessfull = await service.moveMoney(
                                      amount: double.parse(
                                          amountController.text.trim()),
                                      fromWalletName:
                                          AppConstants.Donations_Wallet,
                                      toWalletName: AppConstants.Spend_Wallet,
                                      userId: appConstants.userRegisteredId,
                                    );
                                    // await service.moveMoneyBetweenWallet(
                                    //     walletName: 'USER_Charity_wallet',
                                    //     walletNameFrom: AppConstants.USER_Main_Wallet,
                                    //     amountSend: amountController.text,
                                    //     senderId: appConstants.userRegisteredId,
                                    //     receivedUserId: appConstants.userRegisteredId);
                                  } else if (appConstants.selectFromWalletRealName ==
                                          'Spend Anywhere' &&
                                      appConstants.selectToWalletRealName ==
                                          'Charity') {
                                    isSuccessfull = await service.moveMoney(
                                      amount: double.parse(
                                          amountController.text.trim()),
                                      fromWalletName: AppConstants.Spend_Wallet,
                                      toWalletName:
                                          AppConstants.Donations_Wallet,
                                      userId: appConstants.userRegisteredId,
                                    );
                                    // await service.moveMoneyBetweenWallet(
                                    //     walletName: AppConstants.USER_Main_Wallet,
                                    //     walletNameFrom: 'USER_Charity_wallet',
                                    //     amountSend: amountController.text,
                                    //     senderId: appConstants.userRegisteredId,
                                    //     receivedUserId: appConstants.userRegisteredId);
                                  } else if (appConstants.selectFromWalletRealName ==
                                          'Charity' &&
                                      appConstants.selectToWalletRealName ==
                                          'Savings') {
                                    isSuccessfull = await service.moveMoney(
                                      amount: double.parse(
                                          amountController.text.trim()),
                                      fromWalletName:
                                          AppConstants.Donations_Wallet,
                                      toWalletName: AppConstants.Savings_Wallet,
                                      userId: appConstants.userRegisteredId,
                                    );
                                    // await service.moveMoneyBetweenWallet(
                                    //     walletName: 'USER_Charity_wallet',
                                    //     walletNameFrom: 'USER_Savings_wallet',
                                    //     amountSend: amountController.text,
                                    //     senderId: appConstants.userRegisteredId,
                                    //     receivedUserId: appConstants.userRegisteredId);
                                  } else {
                                    showNotification(
                                        error: 1,
                                        icon: Icons.error,
                                        message: NotificationText.ENTER_AMOUNT);
                                    return;
                                  }
                                  setState(() {});
                                  if (isSuccessfull == true) {
                                    String toWalletName = (appConstants
                                                    .selectFromWalletRealName ==
                                                'Savings' &&
                                            appConstants.selectToWalletRealName ==
                                                'Savings')
                                        ? AppConstants.Savings_Wallet
                                        : (appConstants.selectFromWalletRealName ==
                                                    'Savings' &&
                                                appConstants.selectToWalletRealName ==
                                                    'Charity')
                                            ? AppConstants.Donations_Wallet
                                            : (appConstants.selectFromWalletRealName ==
                                                        'Charity' &&
                                                    appConstants.selectToWalletRealName ==
                                                        'Savings')
                                                ? AppConstants.Savings_Wallet
                                                : (appConstants.selectFromWalletRealName ==
                                                            'Savings' &&
                                                        appConstants.selectToWalletRealName ==
                                                            'Spend Anywhere')
                                                    ? AppConstants.Spend_Wallet
                                                    : (appConstants.selectFromWalletRealName ==
                                                                'Spend Anywhere' &&
                                                            appConstants.selectToWalletRealName ==
                                                                'Savings')
                                                        ? AppConstants
                                                            .Savings_Wallet
                                                        : (appConstants.selectFromWalletRealName ==
                                                                    'Charity' &&
                                                                appConstants
                                                                        .selectToWalletRealName ==
                                                                    'Savings')
                                                            ? AppConstants.Savings_Wallet
                                                            : (appConstants.selectFromWalletRealName == 'Spend Anywhere' && appConstants.selectToWalletRealName == 'Charity')
                                                                ? AppConstants.Donations_Wallet
                                                                : (appConstants.selectFromWalletRealName == 'Charity' && appConstants.selectToWalletRealName == 'Spend Anywhere')
                                                                    ? AppConstants.Spend_Wallet
                                                                    : '';
                                    String fromWalletName = (appConstants
                                                    .selectFromWalletRealName ==
                                                'Savings' &&
                                            appConstants.selectToWalletRealName ==
                                                'Savings')
                                        ? AppConstants.Savings_Wallet
                                        : (appConstants.selectFromWalletRealName ==
                                                    'Savings' &&
                                                appConstants.selectToWalletRealName ==
                                                    'Charity')
                                            ? AppConstants.Savings_Wallet
                                            : (appConstants.selectFromWalletRealName ==
                                                        'Charity' &&
                                                    appConstants.selectToWalletRealName ==
                                                        'Savings')
                                                ? AppConstants.Donations_Wallet
                                                : (appConstants.selectFromWalletRealName ==
                                                            'Savings' &&
                                                        appConstants.selectToWalletRealName ==
                                                            'Spend Anywhere')
                                                    ? AppConstants
                                                        .Savings_Wallet
                                                    : (appConstants.selectFromWalletRealName ==
                                                                'Spend Anywhere' &&
                                                            appConstants.selectToWalletRealName ==
                                                                'Savings')
                                                        ? AppConstants
                                                            .Spend_Wallet
                                                        : (appConstants.selectFromWalletRealName ==
                                                                    'Charity' &&
                                                                appConstants.selectToWalletRealName ==
                                                                    'Savings')
                                                            ? AppConstants.Donations_Wallet
                                                            : (appConstants.selectFromWalletRealName == 'Spend Anywhere' && appConstants.selectToWalletRealName == 'Charity')
                                                                ? AppConstants.Spend_Wallet
                                                                : (appConstants.selectFromWalletRealName == 'Charity' && appConstants.selectToWalletRealName == 'Spend Anywhere')
                                                                    ? AppConstants.Donations_Wallet
                                                                    : '';
                                    // String transactionId = await
                                    service.addTransaction(
                                        transactionMethod: AppConstants
                                            .Transaction_Method_Received,
                                        tagItId: AppConstants.TAGID9998,
                                        tagItName: "-2",
                                        selectedKidName:
                                            appConstants.userModel.usaUserName,
                                        accountHolderName:
                                            appConstants.userModel.usaUserName,
                                        amount: amountController.text.trim(),
                                        currentUserId:
                                            appConstants.userRegisteredId,
                                        receiverId:
                                            appConstants.userRegisteredId,
                                        requestType: AppConstants
                                            .TAG_IT_Transaction_TYPE_INTERNAL_TRANSFER,
                                        senderId: appConstants.userRegisteredId,
                                        message: messageController.text.trim(),
                                        fromWallet: fromWalletName,
                                        toWallet: toWalletName);

                                    service.addTransaction(
                                        transactionMethod: AppConstants
                                            .Transaction_Method_Payment,
                                        tagItId: AppConstants.TAGID9998,
                                        tagItName: "-2",
                                        selectedKidName:
                                            appConstants.userModel.usaUserName,
                                        accountHolderName:
                                            appConstants.userModel.usaUserName,
                                        amount: amountController.text.trim(),
                                        currentUserId:
                                            appConstants.userRegisteredId,
                                        receiverId:
                                            appConstants.userRegisteredId,
                                        requestType: AppConstants
                                            .TAG_IT_Transaction_TYPE_INTERNAL_TRANSFER,
                                        senderId: appConstants.userRegisteredId,
                                        message: messageController.text.trim(),
                                        fromWallet: toWalletName,
                                        toWallet: fromWalletName);

                                    showNotification(
                                        error: 0,
                                        icon: Icons.check,
                                        message: NotificationText.AMOUNT_ADDED);
                                    appConstants.updateLoading(false);

                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                CustomConfermationScreen(
                                                  title:
                                                      'Mission Accomplished!',
                                                  subTitle:
                                                      "${getCurrencySymbol(context, appConstants: appConstants)} ${amountController.text} added to your \n${appConstants.selectToWallet} Wallet",
                                                )));
                                    // Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //         builder: (context) =>
                                    //             ConfirmedScreen(
                                    //               amount: amountController
                                    //                   .text
                                    //                   .toString()
                                    //                   .trim(),
                                    //               walletImageUrl: appConstants
                                    //                           .selectToWalletRealName ==
                                    //                       'Spend Anywhere'
                                    //                   ? imageBaseAddress +
                                    //                       'spending_act.png'
                                    //                   : appConstants
                                    //                               .selectToWalletRealName ==
                                    //                           'Savings'
                                    //                       ? imageBaseAddress +
                                    //                           'saving_act.png'
                                    //                       : imageBaseAddress +
                                    //                           'charity_act.png',
                                    //             )));
                                  } else {
                                    showNotification(
                                        error: 1,
                                        icon: Icons.error,
                                        message: NotificationText
                                            .NOT_ENOUGH_BALANCE);
                                  }
                                  //  Navigator.pop(context);
                                },
                    ),
                    spacing_medium
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
