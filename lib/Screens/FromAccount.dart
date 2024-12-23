import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:zaki/Constants/NotificationTitle.dart';
import 'package:zaki/Widgets/TextHeader.dart';

import '../Constants/AppConstants.dart';
import '../Constants/HelperFunctions.dart';
import '../Constants/Spacing.dart';
import '../Constants/Styles.dart';
import '../Widgets/AppBars/AppBar.dart';

class FromAccount extends StatefulWidget {
  const FromAccount({Key? key}) : super(key: key);

  @override
  State<FromAccount> createState() => _FromAccountState();
}

class _FromAccountState extends State<FromAccount> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var appConstants = Provider.of<AppConstants>(context, listen: true);
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: getCustomPadding(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              appBarHeader_005(
                  context: context,
                  appBarTitle:
                      appConstants.fromAcoountOrNot == true ? 'FROM' : 'To',
                  height: height,
                  width: width),
              TextHeader1(
                title: 'Accounts',
              ),
              spacing_medium,
              if(!((appConstants.fromAcoountOrNot != true &&
                                  appConstants.selectFromWalletRealName ==
                                      "Spend Anywhere") ||
                              (appConstants.fromAcoountOrNot == true &&
                                  appConstants.selectToWalletRealName ==
                                      "Spend Anywhere")))
              Column(
                children: [
                  StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection(AppConstants.USER)
                          .doc(appConstants.userRegisteredId)
                          .collection(AppConstants.USER_WALLETS)
                          .doc(AppConstants.Spend_Wallet)
                          .snapshots(),
                      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                        if (!snapshot.hasData) {
                          return Text("");
                        }
                        return ListTile(
                          onTap: (appConstants.fromAcoountOrNot != true &&
                                      appConstants.selectFromWalletRealName ==
                                          "Spend Anywhere") ||
                                  (appConstants.fromAcoountOrNot == true &&
                                      appConstants.selectToWalletRealName ==
                                          "Spend Anywhere")
                              ? null
                              : () {
                                  if (appConstants.fromAcoountOrNot == true) {
                                    appConstants.updateSelectFromWallet(
                                      from: (appConstants.nickNameModel
                                                      .NickN_SpendWallet !=
                                                  null &&
                                              appConstants.nickNameModel
                                                      .NickN_SpendWallet !=
                                                  "")
                                          ? appConstants
                                              .nickNameModel.NickN_SpendWallet!
                                          : 'Spend',
                                    );
                                    appConstants.updateSelectFromWalletRealName(
                                        fromRealName: 'Spend Anywhere');
                                  } else {
                                    appConstants.updateSelectToWallet(
                                      to: (appConstants.nickNameModel
                                                      .NickN_SpendWallet !=
                                                  null &&
                                              appConstants.nickNameModel
                                                      .NickN_SpendWallet !=
                                                  "")
                                          ? appConstants
                                              .nickNameModel.NickN_SpendWallet!
                                          : 'Spend',
                                    );
                                    appConstants.updateSelectToWalletRealName(
                                        toRealName: 'Spend Anywhere');
                                  }
                                  Navigator.pop(context);
                                },
                          dense: true,
                          contentPadding: EdgeInsets.all(4),
                          leading: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(color: green),
                                  shape: BoxShape.circle),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Icon(
                                  FontAwesomeIcons.wallet,
                                  color: green,
                                ),
                              )),
                          title: Text(
                            (appConstants.nickNameModel.NickN_SpendWallet != null &&
                                    appConstants.nickNameModel.NickN_SpendWallet !=
                                        "")
                                ? appConstants.nickNameModel.NickN_SpendWallet! +
                                    ' Wallet'
                                : 'Spend' + ' Wallet',
                            style:
                                heading2TextStyle(context, width, color: darkGrey),
                          ),
                          subtitle: Text(
                            '${getCurrencySymbol(context, appConstants: appConstants)} ${getTwoDecimalNumber(amount: double.parse(snapshot.data![AppConstants.wallet_balance].toString()))} Balance',
                            style: heading4TextSmall(width),
                          ),
                        );
                      }),
                  const Divider(),
                
                ],
              ),
              if(!((appConstants.fromAcoountOrNot != true &&
                                  appConstants.selectFromWalletRealName ==
                                      "Savings") ||
                              (appConstants.fromAcoountOrNot == true &&
                                  appConstants.selectToWalletRealName ==
                                      "Savings"
                              // ||
                              // (appConstants.personalizationSettingModel != null && appConstants.personalizationSettingModel!.kidPLockSavings == true)
                              )))
              Column(
                children: [
                  StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection(AppConstants.USER)
                          .doc(appConstants.userRegisteredId)
                          .collection(AppConstants.USER_WALLETS)
                          .doc(AppConstants.Savings_Wallet)
                          .snapshots(),
                      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                        if (!snapshot.hasData) {
                          return Text("");
                        }
                        return ListTile(
                          onTap: (appConstants.fromAcoountOrNot != true &&
                                      appConstants.selectFromWalletRealName ==
                                          "Savings") ||
                                  (appConstants.fromAcoountOrNot == true &&
                                      appConstants.selectToWalletRealName ==
                                          "Savings"
                                  // ||
                                  // (appConstants.personalizationSettingModel != null && appConstants.personalizationSettingModel!.kidPLockSavings == true)
                                  )
                              ? null
                              : (appConstants.personalizationSettingModel != null &&
                                      appConstants.personalizationSettingModel!
                                              .kidPLockSavings ==
                                          true &&
                                      appConstants.fromAcoountOrNot == true)
                                  ? null
                                  : () {
                                      if (appConstants.fromAcoountOrNot == true) {
                                        appConstants.updateSelectFromWallet(
                                          from: (appConstants.nickNameModel
                                                          .NickN_SavingWallet !=
                                                      null &&
                                                  appConstants.nickNameModel
                                                          .NickN_SavingWallet !=
                                                      "")
                                              ? appConstants
                                                  .nickNameModel.NickN_SavingWallet!
                                              : 'Savings',
                                        );
                                        appConstants.updateSelectFromWalletRealName(
                                            fromRealName: 'Savings');
                                      } else {
                                        appConstants.updateSelectToWallet(
                                          to: (appConstants.nickNameModel
                                                          .NickN_SavingWallet !=
                                                      null &&
                                                  appConstants.nickNameModel
                                                          .NickN_SavingWallet !=
                                                      "")
                                              ? appConstants
                                                  .nickNameModel.NickN_SavingWallet!
                                              : 'Savings',
                                        );
                  
                                        appConstants.updateSelectToWalletRealName(
                                            toRealName: 'Savings');
                                      }
                                      Navigator.pop(context);
                                    },
                          trailing:
                              (appConstants.personalizationSettingModel != null &&
                                      appConstants.personalizationSettingModel!
                                              .kidPLockSavings ==
                                          true &&
                                      appConstants.fromAcoountOrNot == true)
                                  ? InkWell(
                                      onTap: () {
                                        showNotification(
                                            error: 1,
                                            icon: Icons.error,
                                            message: NotificationText.LOCK_WALLET);
                                      },
                                      child: Icon(Icons.info))
                                  : null,
                          dense: true,
                          contentPadding: EdgeInsets.all(4),
                          leading: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(color: green),
                                  shape: BoxShape.circle),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Icon(
                                  FontAwesomeIcons.vault,
                                  color: green,
                                ),
                              )),
                          title: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                (appConstants.nickNameModel.NickN_SavingWallet !=
                                            null &&
                                        appConstants
                                                .nickNameModel.NickN_SavingWallet !=
                                            "")
                                    ? appConstants
                                            .nickNameModel.NickN_SavingWallet! +
                                        ' Wallet'
                                    : 'Savings' + ' Wallet',
                                style: heading2TextStyle(
                                  context, width,
                                  color:
                                      (appConstants.personalizationSettingModel !=
                                                  null &&
                                              appConstants
                                                      .personalizationSettingModel!
                                                      .kidPLockSavings ==
                                                  true &&
                                              appConstants.fromAcoountOrNot == true)
                                          ? grey
                                          : darkGrey,
                                  // bold: false
                                ),
                              ),
                              Text(
                                '  (Except Goals)',
                                style: heading4TextSmall(
                                  width,
                                  color:
                                      (appConstants.personalizationSettingModel !=
                                                  null &&
                                              appConstants
                                                      .personalizationSettingModel!
                                                      .kidPLockSavings ==
                                                  true &&
                                              appConstants.fromAcoountOrNot == true)
                                          ? grey
                                          : darkGrey,
                                  // bold: false
                                ),
                              ),
                            ],
                          ),
                          subtitle: Text(
                            '${getCurrencySymbol(context, appConstants: appConstants)} ${getTwoDecimalNumber(amount: double.parse((snapshot.data![AppConstants.wallet_balance].toString())))} Balance',
                            style: heading4TextSmall(width),
                          ),
                        );
                        // return StreamBuilder(
                        //     stream: FirebaseFirestore.instance
                        //         .collection(AppConstants.USER)
                        //         .doc(appConstants.userRegisteredId)
                        //         .collection(AppConstants.USER_WALLETS)
                        //         .doc(AppConstants.All_Goals_Wallet)
                        //         .snapshots(),
                        //     builder: (context,
                        //         AsyncSnapshot<DocumentSnapshot> goalSnapshot) {
                        //       if (!goalSnapshot.hasData) {
                        //         return Text("");
                        //       }
                  
                        //     });
                      }),
                  const Divider(),
                
                ],
              ),
              if(!((appConstants.fromAcoountOrNot != true &&
                                  appConstants.selectFromWalletRealName ==
                                      "Charity") ||
                              (appConstants.fromAcoountOrNot == true &&
                                  appConstants.selectToWalletRealName ==
                                      "Charity")))
              Column(
                children: [
                  StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection(AppConstants.USER)
                          .doc(appConstants.userRegisteredId)
                          .collection(AppConstants.USER_WALLETS)
                          .doc(AppConstants.Donations_Wallet)
                          .snapshots(),
                      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                        if (!snapshot.hasData) {
                          return Text("");
                        }
                        return ListTile(
                          onTap: (appConstants.fromAcoountOrNot != true &&
                                      appConstants.selectFromWalletRealName ==
                                          "Charity") ||
                                  (appConstants.fromAcoountOrNot == true &&
                                      appConstants.selectToWalletRealName ==
                                          "Charity")
                              // ||
                              // (appConstants.personalizationSettingModel != null && appConstants.personalizationSettingModel!.kidPLockDonate == true)
                              ? null
                              : (appConstants.personalizationSettingModel != null &&
                                      appConstants.personalizationSettingModel!
                                              .kidPLockDonate ==
                                          true &&
                                      appConstants.fromAcoountOrNot == true)
                                  ? null
                                  : () {
                                      if (appConstants.fromAcoountOrNot == true) {
                                        appConstants.updateSelectFromWallet(
                                          from: (appConstants.nickNameModel
                                                          .NickN_DonationWallet !=
                                                      null &&
                                                  appConstants.nickNameModel
                                                          .NickN_DonationWallet !=
                                                      "")
                                              ? appConstants.nickNameModel
                                                  .NickN_DonationWallet!
                                              : 'Charity',
                                        );
                                        appConstants.updateSelectFromWalletRealName(
                                            fromRealName: 'Charity');
                                      } else {
                                        appConstants.updateSelectToWallet(
                                          to: (appConstants.nickNameModel
                                                          .NickN_DonationWallet !=
                                                      null &&
                                                  appConstants.nickNameModel
                                                          .NickN_DonationWallet !=
                                                      "")
                                              ? appConstants.nickNameModel
                                                  .NickN_DonationWallet!
                                              : 'Charity',
                                        );
                                        appConstants.updateSelectToWalletRealName(
                                            toRealName: 'Charity');
                                      }
                                      Navigator.pop(context);
                                    },
                          trailing:
                              (appConstants.personalizationSettingModel != null &&
                                      appConstants.personalizationSettingModel!
                                              .kidPLockDonate ==
                                          true &&
                                      appConstants.fromAcoountOrNot == true)
                                  ? InkWell(
                                      onTap: () {
                                        showNotification(
                                            error: 1,
                                            icon: Icons.error,
                                            message: NotificationText.LOCK_WALLET);
                                      },
                                      child: Icon(Icons.info))
                                  : null,
                          dense: true,
                          contentPadding: EdgeInsets.all(4),
                          leading: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(color: green),
                                  shape: BoxShape.circle),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Icon(
                                  FontAwesomeIcons.handHoldingHeart,
                                  color: green,
                                ),
                              )),
                          title: Text(
                            (appConstants.nickNameModel.NickN_DonationWallet !=
                                        null &&
                                    appConstants
                                            .nickNameModel.NickN_DonationWallet !=
                                        "")
                                ? appConstants.nickNameModel.NickN_DonationWallet! +
                                    ' Wallet'
                                : 'Charity' + ' Wallet',
                            style: heading2TextStyle(
                              context,
                              width,
                              color: (appConstants.fromAcoountOrNot != true &&
                                      appConstants.selectFromWalletRealName ==
                                          "Charity")
                                  ? grey
                                  : (appConstants.personalizationSettingModel !=
                                              null &&
                                          appConstants.personalizationSettingModel!
                                                  .kidPLockDonate ==
                                              true &&
                                          appConstants.fromAcoountOrNot == true)
                                      ? grey
                                      : darkGrey,
                            ),
                          ),
                          subtitle: Text(
                            '${getCurrencySymbol(context, appConstants: appConstants)} ${getTwoDecimalNumber(amount: double.parse(snapshot.data![AppConstants.wallet_balance].toString()))} Balance',
                            style: heading4TextSmall(width),
                          ),
                        );
                      }),
                ],
              ),
              SizedBox(
                height: height * 0.3,
              ),
              Text('* Money captured in Goals are stored in a separate wallet.',
                  style: heading3TextStyle(width)),
            ],
          ),
        ),
      ),
    );
  }
}
