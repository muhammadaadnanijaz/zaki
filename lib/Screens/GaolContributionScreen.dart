import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esys_flutter_share_plus/esys_flutter_share_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:zaki/Constants/HelperFunctions.dart';
import 'package:zaki/Services/api.dart';
import 'package:zaki/Widgets/TextHeader.dart';
import 'package:zaki/Widgets/CustomLoader.dart';
import '../Constants/AppConstants.dart';
import '../Constants/Spacing.dart';
import '../Constants/Styles.dart';
import '../Widgets/AppBars/AppBar.dart';
import '../Widgets/PrivacyTypeButton.dart';
import '../Widgets/UserInfoForGoals.dart';
import 'GoalsContactInvitedScreen.dart';
import 'MoveMoneyForGoals.dart';

class GaolContributter extends StatefulWidget {
  final String? goalId;
  final String? goalTitle;
  final String? amount;
  const GaolContributter(
      {Key? key, this.goalId, this.goalTitle, required this.amount})
      : super(key: key);

  @override
  State<GaolContributter> createState() => _GaolContributterState();
}

class _GaolContributterState extends State<GaolContributter> {
  Stream<QuerySnapshot>? goalSnapshot;
  @override
  void initState() {
    super.initState();
    fetchUserFriendsAndFamily();
  }

  fetchUserFriendsAndFamily() {
    Future.delayed(Duration.zero, () {
      // userFriendsAndFamily = ApiServices()
      //     .getUserFriendsAndFamilyForGoals(appConstants.userRegisteredId);
      goalSnapshot =
          ApiServices().getAllContributtionUser(goalId: widget.goalId);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    var appConstants = Provider.of<AppConstants>(context, listen: true);
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
        body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 0),
        child: Column(
          children: [
            appBarHeader_005(
              context: context,
              appBarTitle: widget.goalTitle.toString(),
              height: height,
              width: width,
              backArrow: false,
            ),
            if (goalSnapshot != null)
              Expanded(
                child: StreamBuilder(
                  stream: goalSnapshot,
                  // initialData: initialData,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasError) {
                      return const Text('Ooops...Something went wrong :(');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: const CustomLoader());
                    }
                    if (snapshot.data!.size == 0) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          spacing_large,
                          TextHeader1(
                            title: 'No one paid yet :(',
                          ),
                          spacing_X_large,
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding:  EdgeInsets.symmetric(horizontal: width*0.1),
                              child: TextHeader1(
                                title: 'Fund your goal from:',
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: width * 0.08,
                                vertical: width * 0.01),
                            child: PrivacyTypeButton(
                              width: width,
                              icon: Icons.account_balance_wallet,
                              selected: 0,
                              title: 'My Main Wallet',
                              subTitle: 'Zpay Wallet',
                              tralingIcon: Icons.arrow_circle_right_sharp,
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MoveMoneyForGoals(
                                              goalTitle: widget.goalTitle,
                                              documentId: widget.goalId,
                                              collectedAmount: double.parse(
                                                  widget.amount.toString()),
                                            )));

                                // appConstants.updateSlectedPrivacyTypeIndex(1);
                              },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: width * 0.08,
                                vertical: width * 0.01),
                            child: PrivacyTypeButton(
                              width: width,
                              icon: Icons.family_restroom_outlined,
                              selected: 0,
                              title: 'Friends and  Family',
                              subTitle: 'Share on Zpay',
                              tralingIcon: Icons.arrow_circle_right_sharp,
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            GoalsContactInvitedScreen(
                                              goalId: widget.goalId,
                                              // goalSnapshot: goalSnapshot
                                            )));
                                // appConstants.updateSlectedPrivacyTypeIndex(2);
                              },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: width * 0.08,
                                vertical: width * 0.01),
                            child: PrivacyTypeButton(
                              width: width,
                              title: 'Share a link',
                              subTitle: 'Share on Social Media',
                              icon: FontAwesomeIcons.link,
                              tralingIcon: FontAwesomeIcons.link,
                              selected: 0,
                              onTap: () async {
                                final ByteData bytes = await rootBundle
                                    .load(imageBaseAddress + 'ZakiPay.png');
                                await Share.file(
                                  'Share My Image',
                                  'ZakiPay.png',
                                  bytes.buffer.asUint8List(),
                                  'image/png',
                                  text:
                                      '${appConstants.userModel.usaFirstName} ${AppConstants.ZAKI_PAY_GOAL_SHARE_TEXT_FIRST_TITLE} \n"${widget.goalTitle}" \n${AppConstants.ZAKI_PAY_GOAL_SHARE_TEXT_LAST_TITLE}. \nDownload ZakiPay Now: ${AppConstants.ZAKI_PAY_APP_LINK}',
                                );
                                // appConstants.updateSlectedPrivacyTypeIndex(4);
                              },
                            ),
                          ),
                        ],
                      );
                    }
                    return Column(
                      children: [
                        spacing_medium,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'Total Raised: ',
                              style: heading1TextStyle(
                                context,
                                width,
                              ),
                            ),
                            Text(
                              '+${getCurrencySymbol(context, appConstants: appConstants)} ${widget.amount}',
                              style: heading4TextSmall(width, color: green),
                            ),
                          ],
                        ),
                        spacing_medium,
                        Expanded(
                          child: ListView.separated(
                            separatorBuilder: (context, index) =>
                                const Divider(),
                            itemCount: snapshot.data!.docs.length,
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index) {
                              return UserInfoForGoals(
                                userId:
                                    '${snapshot.data!.docs[index][AppConstants.contributor_user_Id]}',
                                date: formatedDateWithMonth(
                                    date: snapshot
                                        .data!
                                        .docs[index]
                                            [AppConstants.contribution_date]
                                        .toDate()),
                                amount: snapshot.data!.docs[index]
                                    [AppConstants.countributed_amount],
                                goalTitle: widget.goalTitle,
                              );
                              // Text('${snapshot.data!.docs[index][AppConstants.contributor_user_Id]}');
                              //  InviteGoalCustomTile(selectedGoalId: widget.goalId!, snapshot: snapshot.data!.docs[index], goalSnapshot:widget.goalSnapshot);
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    ));
  }
}
