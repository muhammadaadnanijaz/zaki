import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zaki/Constants/AppConstants.dart';
import 'package:zaki/Constants/HelperFunctions.dart';
import 'package:zaki/Constants/Styles.dart';

class WalletBalance extends StatelessWidget {
  const WalletBalance({
    Key? key,
    required this.appConstants,
  }) : super(key: key);

  final AppConstants appConstants;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection(AppConstants.USER)
            .doc(
                appConstants.userRegisteredId)
            .collection(
                AppConstants.USER_WALLETS)
            .doc(AppConstants.Spend_Wallet)
            .snapshots(),
        builder: (context,
            AsyncSnapshot<DocumentSnapshot>
                snapshot) {
          if (!snapshot.hasData) {
            return Text("");
          }
          return Row(
            mainAxisAlignment:
                MainAxisAlignment.end,
            children: [
              Text(
                  '${getCurrencySymbol(context, appConstants: appConstants)} ${getTwoDecimalNumber(amount: double.parse(snapshot.data![AppConstants.wallet_balance].toString()))} ${(appConstants.nickNameModel.NickN_SpendWallet != null && appConstants.nickNameModel.NickN_SpendWallet != "") ? appConstants.nickNameModel.NickN_SpendWallet! + ' Wallet' : 'Spend' ' Wallet'}',
                  style: heading4TextSmall(
                      width)
                      ),
            ],
          );
        }
        );
  }
}