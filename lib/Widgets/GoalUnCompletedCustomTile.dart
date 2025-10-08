import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:zaki/Constants/BottomSheets.dart';
// import 'package:zaki/Constants/NotificationTitle.dart';
import 'package:zaki/Constants/Whitelable.dart';
import 'package:zaki/Constants/Spacing.dart';
import 'package:zaki/Services/api.dart';
import '../Constants/AppConstants.dart';
import '../Constants/HelperFunctions.dart';
import '../Constants/Styles.dart';
import '../Models/GoalModel.dart';
import '../Screens/GaolContributionScreen.dart';
import '../Screens/NewGoal.dart';
import 'ZakiCircularButton.dart';

class GoalCustomTile extends StatefulWidget { 
  final QueryDocumentSnapshot<Object?> snapshot;
  const GoalCustomTile({Key? key, required this.snapshot}) : super(key: key);

  @override
  State<GoalCustomTile> createState() => _GoalCustomTileState();
}

class _GoalCustomTileState extends State<GoalCustomTile> {
  @override
  Widget build(BuildContext context) {
    var appConstants = Provider.of<AppConstants>(context, listen: false);
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    bool expired = checkDateExpire(
        dateToBeCheck:
            widget.snapshot[AppConstants.GOAL_Expired_Date].toDate());
    if (expired) {
      ApiServices().updateGoalStatus(
          goalId: widget.snapshot.id, status: AppConstants.GOAL_Status_expired);
      ApiServices().getUserTokenAndSendNotification(
          userId: appConstants.userRegisteredId,
          title:
              '${appConstants.userModel.usaUserName} ${NotificationText.REQUEST_NOTIFICATION_TITLE}',
          subTitle: '${NotificationText.REQUEST_NOTIFICATION_SUB_TITLE}');
    }
    return (expired ||
            widget.snapshot[AppConstants.GOAL_Status] ==
                AppConstants.GOAL_Status_completed ||
            widget.snapshot[AppConstants.GOAL_Status] ==
                AppConstants.GOAL_Status_expired)
        ? SizedBox.shrink()
        // ExpiredOrComplatedCustomTile(snapshot: widget.snapshot)
        : Container(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(width * 0.05),
                        border: Border.all(
                          color: blue,
                        )),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 2, vertical: 0),
                      child: Column(
                        children: [
                          spacing_small,
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${widget.snapshot[AppConstants.GOAL_name]}',
                                  style: heading2TextStyle(context, width,
                                      color: black),
                                ),
                                PopupMenuButton(
                                  shape: shape(),
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: Icon(
                                      Icons.more_horiz,
                                      color: blue,
                                    ),
                                  ),
                                  elevation: 20,
                                  enableFeedback: true,
                                  enabled: true,
                                  itemBuilder: (_) => <PopupMenuEntry>[
                                    PopupMenuItem(
                                      child: ListTile(
                                        onTap: () async {
                                          logMethod(
                                              title:
                                                  'Selected goal id for delete',
                                              message:
                                                  'Id: ${widget.snapshot.id.toString()}');
                                          appConstants.updateGoalModel(
                                              GoalModel(
                                                  docId: widget.snapshot.id,
                                                  goalDate:
                                                      widget.snapshot[AppConstants.GOAL_Expired_Date]
                                                          .toDate(),
                                                  goalName: widget.snapshot[
                                                      AppConstants.GOAL_name],
                                                  goalPrice:
                                                      // getTwoDecimalNumber(
                                                      // amount:
                                                      widget
                                                          .snapshot[AppConstants
                                                              .Goal_Target_Amount]
                                                          .toInt()
                                                          // )
                                                          .toString(),
                                                  topSecret: widget.snapshot[
                                                      AppConstants
                                                          .GOAL_isPrivate],
                                                  tokensList: widget.snapshot[
                                                      AppConstants
                                                          .GOAL_Invited_Token_List],
                                                  goalAmountCollected:
                                                      (widget.snapshot[AppConstants.GOAL_amount_collected])
                                                          .toDouble(),
                                                  userId: appConstants
                                                      .userRegisteredId));
                                          Navigator.pop(context);
                                          await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const NewGoal()));
                                        },
                                        leading: Icon(
                                          FontAwesomeIcons.bullseye,
                                          color: black,
                                          size: width * 0.05,
                                        ),
                                        title: Text('Edit Goal'),
                                      ),
                                    ),
                                    PopupMenuItem(
                                      child: ListTile(
                                        onTap: () {
                                          Navigator.pop(context);

                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      GaolContributter(
                                                        goalId: widget
                                                            .snapshot.id
                                                            .toString(),
                                                        goalTitle:
                                                            widget.snapshot[
                                                                AppConstants
                                                                    .GOAL_name],
                                                        amount: widget
                                                            .snapshot[AppConstants
                                                                .GOAL_amount_collected]
                                                            .toInt()
                                                            .toString(),
                                                        // contributterWalletName: widget.snapshot[AppConstants.contributor_wallet_name],
                                                      )));
                                        },
                                        leading: Icon(
                                          Icons.edit_calendar_rounded,
                                          color: black,
                                          size: width * 0.05,
                                        ),
                                        title: Text('See who paid'),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Icon(FontAwesomeIcons.bulls),
                                  Image.asset(
                                    imageBaseAddress + 'goal.png',
                                  ),
                                  SizedBox(height: height * 0.01),
                                  appConstants.userModel.usaCountry ==
                                          "Pakistan"
                                      ? Row(
                                          children: [
                                            Text(
                                              '${getFormatedNumber(number: (widget.snapshot[AppConstants.Goal_Target_Amount]).toDouble())}'
                                                  .toString(),
                                              style: textStyleHeading1WithTheme(
                                                  context, width,
                                                  whiteColor: 0),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 2.0),
                                              child: Text(
                                                '${getCurrencySymbol(context, appConstants: appConstants)}',
                                                style:
                                                    textStyleHeading2WithTheme(
                                                        context, width * 0.8,
                                                        whiteColor: 0),
                                              ),
                                            )
                                          ],
                                        )
                                      : Stack(
                                          clipBehavior: Clip.none,
                                          children: [
                                            Positioned(
                                              top: -8,
                                              left: -25,
                                              right: 0,
                                              bottom: 0,
                                              child: Text(
                                                '${getCurrencySymbol(context, appConstants: appConstants)}',
                                                style: heading3TextStyle(
                                                    width * 0.65,
                                                    color:
                                                        grey.withValues(alpha:0.8)),
                                              ),
                                            ),
                                            Text(
                                              '${widget.snapshot[AppConstants.Goal_Target_Amount].toInt()}',
                                              style: heading3TextStyle(width,
                                                  color: blue, font: 14),
                                              textAlign: TextAlign.right,
                                            ),
                                          ],
                                        ),
                                ],
                              ),
                              /////////////
                              if (widget.snapshot[AppConstants.GOAL_Status] ==
                                  AppConstants.GOAL_Status_Active)
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      //  (!widget.snapshot ['GOAL_expired_status'] && !widget.snapshot ['GOAL_complete_status'])?
                                      (widget.snapshot[AppConstants
                                                      .GOAL_Status] ==
                                                  AppConstants
                                                      .GOAL_Status_expired ||
                                              expired)
                                          ?
                                          // (widget.snapshot [AppConstants.GOAL_Status]=="expired" ||checkDateExpire(dateToBeCheck:widget.snapshot[AppConstants.GOAL_created_at].toDate())==true)?
                                          Image.asset(imageBaseAddress +
                                              'expire_loading.png')
                                          : Image.asset(
                                              imageBaseAddress + 'loading.png'),
                                      SizedBox(height: height * 0.014),
                                      Text(
                                        '${daysBetween(from: DateTime.now(), to: widget.snapshot[AppConstants.GOAL_Expired_Date].toDate())}d',
                                        style: heading3TextStyle(width,
                                            color: blue, font: 14),
                                      ),
                                    ],
                                  ),
                                ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    SizedBox(
                                        // height: height*0.1,
                                        width: width * 0.12,
                                        // alignment: Alignment.topCenter,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 4.0),
                                          child: Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              LinearProgressIndicator(
                                                value: (widget.snapshot[AppConstants
                                                                .GOAL_amount_collected] ==
                                                            0 &&
                                                        widget.snapshot[AppConstants
                                                                .Goal_Target_Amount] ==
                                                            0)
                                                    ? 0
                                                    : (((widget.snapshot[
                                                                    AppConstants
                                                                        .GOAL_amount_collected])
                                                                .toDouble() /
                                                            (widget.snapshot[
                                                                    AppConstants
                                                                        .Goal_Target_Amount])
                                                                .toDouble()) *
                                                        100 /
                                                        100),
                                                backgroundColor: transparent,
                                                color: goalLightGreenColor,
                                                minHeight: height * 0.043,
                                              ),
                                              Image.asset(
                                                imageBaseAddress +
                                                    "goal_percent.png",
                                                width: width * 0.12,
                                                height: height * 0.048,
                                                fit: BoxFit.contain,
                                              )
                                            ],
                                          ),
                                        )),
                                    // SizedBox(
                                    //     height: height * 0.01),
                                    Text(
                                      '${(((widget.snapshot[AppConstants.GOAL_amount_collected]).toDouble() ?? 0 / (widget.snapshot[AppConstants.Goal_Target_Amount]).toDouble()) ?? 0 * 100).toInt()}%',
                                      style: heading3TextStyle(width,
                                          color: blue, font: 14),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ZakiCicularButton(
                                    title: widget.snapshot[
                                                AppConstants.GOAL_Status] ==
                                            "completed"
                                        ? 'Completed'
                                        : 'Fund Me',
                                    width: width * 0.7,
                                    selected: 4,
                                    onPressed: () {
                                      shareGoalBottomSheet(
                                          title: widget
                                              .snapshot[AppConstants.GOAL_name],
                                          goalSnapshot: widget.snapshot,
                                          height: height,
                                          width: width,
                                          documentId: widget.snapshot.id,
                                          index: widget.snapshot[
                                              AppConstants.GOAL_selected_index],
                                          // collectedAmount: widget.snapshot[
                                          //     AppConstants
                                          //         .GOAL_amount_collected],
                                          context: context,
                                          goalSetterUserId: widget.snapshot[
                                              AppConstants.GOAL_user_id]);
                                    },
                                  ),
                                  spacing_small
                                  // CustomSizedBox(
                                  //   height: height + height,
                                  // )
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
