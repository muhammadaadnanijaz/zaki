import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:esys_flutter_share_plus/esys_flutter_share_plus.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:zaki/Constants/AppConstants.dart';
import 'package:zaki/Constants/Spacing.dart';
import 'package:zaki/Constants/Styles.dart';
import 'package:zaki/Constants/Whitelable.dart';
import '../Screens/GoalsContactInvitedScreen.dart';
import '../Screens/MoveMoneyForGoals.dart';
import '../Services/api.dart';
import '../Widgets/PrivacyTypeButton.dart';

// bottom

removeGoalBottomSheet(
    {String? title,
    double? width,
    double? height,
    String? documentId,
    BuildContext? context,
    String? userId}) {
  ///////vaiable
  int selectedIndex = -1;
  // ApiServices service = ApiServices();
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
        // var appConstants = Provider.of<AppConstants>(bc, listen: false);
        return StatefulBuilder(
          builder: (BuildContext context, setState) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 0),
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
                  'Goal Remove',
                  style:
                      textStyleHeading2WithTheme(context, width, whiteColor: 0),
                ),
                spacing_medium,
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: width * 0.08, vertical: width * 0.01),
                  child: PrivacyTypeButton(
                    width: width,
                    icon: Icons.account_balance_wallet,
                    selected: selectedIndex == 1 ? 1 : 0,
                    title: 'Remove From Your List',
                    subTitle: '',
                    tralingIcon: Icons.remove_circle_outline,
                    onTap: () {
                      setState(() {
                        selectedIndex = 1;
                      });

                      // appConstants.updateSlectedPrivacyTypeIndex(1);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      });
}

shareGoalBottomSheet({
  String? title,
  double? width,
  double? height,
  String? documentId,
  double? collectedAmount,
  int? index,
  BuildContext? context,
  String? receiverUserId,
  String? goalSetterUserId,
  QueryDocumentSnapshot<Object?>? goalSnapshot,
}) {
  ///////vaiable
  int selectedIndex = index!;
  ApiServices service = ApiServices();
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
        var appConstants = Provider.of<AppConstants>(bc, listen: false);
        return StatefulBuilder(
          builder: (BuildContext context, setState) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 0),
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
                  'Fund Goal From',
                  style:
                      textStyleHeading2WithTheme(context, width, whiteColor: 0),
                ),
                spacing_medium,
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: width * 0.08, vertical: width * 0.01),
                  child: PrivacyTypeButton(
                    width: width,
                    icon: Icons.account_balance_wallet,
                    selected: selectedIndex == 1 ? 1 : 0,
                    title: 'My Main Wallet',
                    subTitle: 'Zpay Wallet',
                    tralingIcon: Icons.arrow_circle_right_sharp,
                    onTap: () {
                      setState(() {
                        selectedIndex = 1;
                        service.updateGoalShareIndex(
                            documentId: documentId,
                            selectedIndex: selectedIndex);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MoveMoneyForGoals(
                                      goalTitle: title,
                                      documentId: documentId,
                                      collectedAmount: collectedAmount,
                                      receiverUserId: receiverUserId,
                                      goalSetterUserId: goalSetterUserId,
                                    )));
                      });
                      // appConstants.updateSlectedPrivacyTypeIndex(1);
                    },
                  ),
                ),
                if (goalSnapshot != null)
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: width * 0.08, vertical: width * 0.01),
                    child: PrivacyTypeButton(
                      width: width,
                      icon: Icons.family_restroom_outlined,
                      selected: selectedIndex == 2 ? 1 : 0,
                      title: 'Friends and  Family',
                      subTitle: 'Share on Zpay',
                      tralingIcon: Icons.arrow_circle_right_sharp,
                      onTap: () {
                        setState(() {
                          selectedIndex = 2;
                          service.updateGoalShareIndex(
                              documentId: documentId,
                              selectedIndex: selectedIndex);
                        });
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => GoalsContactInvitedScreen(
                                    goalId: documentId,
                                    goalSnapshot: goalSnapshot)));
                        // appConstants.updateSlectedPrivacyTypeIndex(2);
                      },
                    ),
                  ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: width * 0.08, vertical: width * 0.01),
                  child: PrivacyTypeButton(
                    width: width,
                    title: 'Share a link',
                    subTitle: 'Share on Social Media',
                    icon: FontAwesomeIcons.link,
                    tralingIcon: FontAwesomeIcons.link,
                    selected: selectedIndex == 4 ? 1 : 0,
                    onTap: () async {
                      setState(() {
                        selectedIndex = 4;
                        service.updateGoalShareIndex(
                            documentId: documentId,
                            selectedIndex: selectedIndex);
                      });
                      // final ByteData bytes = await rootBundle
                      //     .load(APPLICATION_LOGO);
                      // await Share.file(
                      //   'Share My Image',
                      //   'ZakiPay.png',
                      //   bytes.buffer.asUint8List(),
                      //   'image/png',
                      //   text:
                      //       '${appConstants.userModel.usaFirstName} ${AppConstants.ZAKI_PAY_GOAL_SHARE_TEXT_FIRST_TITLE} \n"${title}" \n${AppConstants.ZAKI_PAY_GOAL_SHARE_TEXT_LAST_TITLE}. \nDownload ZakiPay Now: ${AppConstants.ZAKI_PAY_APP_LINK}',
                      // );
                      // appConstants.updateSlectedPrivacyTypeIndex(4);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      });
}