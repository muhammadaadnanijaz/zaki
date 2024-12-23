import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zaki/Constants/AppConstants.dart';
import 'package:zaki/Constants/HelperFunctions.dart';
import 'package:provider/provider.dart';
import 'package:zaki/Widgets/TextHeader.dart';
import '../Constants/Styles.dart';
import 'package:zaki/Widgets/CustomLoader.dart';

class UserInfoForGoals extends StatelessWidget {
  final String? userId;
  final String? amount;
  final String? date;
  final String? goalTitle;
  final bool? fromTransactionDetailPage;
  final bool? onlyUserName;
  const UserInfoForGoals(
      {Key? key,
      this.userId,
      this.amount,
      this.date,
      this.goalTitle,
      this.fromTransactionDetailPage,
      this.onlyUserName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var appConstants = Provider.of<AppConstants>(context, listen: true);
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection(AppConstants.USER)
          .doc(userId)
          .snapshots(),
      // .collection(AppConstants.GOAL_Invited_List)
      // .doc("")
      // .collection(AppConstants.GOAL_Invited_List)
      // .snapshots(),
      // initialData: initialData,
      builder: (BuildContext context, snapshots) {
        var width = MediaQuery.of(context).size.width;
        if (snapshots.hasError) {
          return const Text(':(');
        }
        if (snapshots.connectionState == ConnectionState.waiting) {
          return SizedBox.shrink();
        }
        if (!snapshots.data!.exists) {
          return SizedBox.shrink();
        }
        var snapShot = snapshots.data!.data() as Map<String, dynamic>;
        return fromTransactionDetailPage == true
            ? Column(
                children: [
                  // UserLogo(snapShot: snapShot),
                  // spacing_small,
                  TextHeader1(
                    title: snapShot[AppConstants.USER_user_name],
                  ),
                ],
              )
            : onlyUserName == true
                ? Text(
                    snapShot[AppConstants.USER_first_name],
                    style: heading3TextStyle(width * 0.9),
                  )
                : Row(
                    children: [
                      UserLogo(snapShot: snapShot),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            date != null
                                ? appConstants.userRegisteredId == userId
                                    ? 'My Contribution'
                                    : 'Contribution from ${snapShot[AppConstants.USER_first_name]}'
                                : '@ ${snapShot[AppConstants.USER_user_name]}',
                            style: heading3TextStyle(width),
                          ),
                          // spacing_small,
                          SizedBox(
                            height: 5,
                          ),
                          if (date != null)
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //  if(goalTitle!=null) Text('$goalTitle',
                                //         style: heading4TextSmall(width),
                                //       ),
                                // ListTile(
                                //   contentPadding: EdgeInsets.zero,
                                //   title: Text('$date',
                                //         style: heading4TextSmall(width),
                                //       ),
                                //   trailing: Text('+${getCurrencySymbol(context, appConstants: appConstants )} $amount',
                                //         style: heading4TextSmall(width, color: green),
                                //       ),
                                // ),
                                Row(
                                  children: [
                                    Text(
                                      '$date',
                                      style: heading4TextSmall(width),
                                    ),
                                    SizedBox(
                                      width: width * 0.4,
                                    ),
                                    Text(
                                      '+${getCurrencySymbol(context, appConstants: appConstants)} $amount',
                                      style: heading4TextSmall(width,
                                          color: green),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                        ],
                      ),
                    ],
                  );
      },
    );
  }

  getWalletName({String? walletName}) {
    return walletName == 'Spend Anywhere'
        ? AppConstants.Spend_Wallet
        : walletName == 'Savings'
            ? AppConstants.Savings_Wallet
            : AppConstants.Donations_Wallet;
  }
}

class UserLogo extends StatelessWidget {
  const UserLogo({
    Key? key,
    required this.snapShot,
  }) : super(key: key);

  final Map<String, dynamic> snapShot;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Container(
        height: 60,
        width: 60,
        decoration: BoxDecoration(shape: BoxShape.circle, color: grey),
        child: snapShot[AppConstants.USER_Logo] == ''
            ? SizedBox()
            : snapShot[AppConstants.USER_Logo].contains('assets/images/')
                ? CircleAvatar(
                    backgroundColor: transparent,
                    child: Image.asset(snapShot[AppConstants.USER_Logo]))
                : CircleAvatar(
                    backgroundColor: transparent,
                    child: CachedNetworkImage(
                      imageUrl: snapShot[AppConstants.USER_Logo],
                      placeholder: (context, url) => CustomLoader(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    )),
      ),
    );
  }
}
