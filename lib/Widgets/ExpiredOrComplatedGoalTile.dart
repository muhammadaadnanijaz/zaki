import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Constants/AppConstants.dart';
import '../Constants/HelperFunctions.dart';
import '../Constants/Spacing.dart';
import '../Constants/Styles.dart';
import '../Models/GoalModel.dart';
import '../Screens/NewGoal.dart';
import '../Services/api.dart';

class ExpiredOrComplatedCustomTile extends StatefulWidget {
  final QueryDocumentSnapshot<Object?> snapshot;
  const ExpiredOrComplatedCustomTile({Key? key, required this.snapshot})
      : super(key: key);

  @override
  State<ExpiredOrComplatedCustomTile> createState() =>
      _ExpiredOrComplatedCustomTileState();
}

class _ExpiredOrComplatedCustomTileState
    extends State<ExpiredOrComplatedCustomTile> {
  @override
  Widget build(BuildContext context) {
    var appConstants = Provider.of<AppConstants>(context, listen: true);
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Padding(
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
              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 0),
              child: Column(
                children: [
                  spacing_small,
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${widget.snapshot[AppConstants.GOAL_name]}',
                          style:
                              heading2TextStyle(context, width, color: black),
                        ),
                        widget.snapshot[AppConstants.GOAL_Status] ==
                                AppConstants.GOAL_Status_completed
                            ? SizedBox(
                                height: 5,
                                width: 5,
                              )
                            : InkWell(
                                onTap: () {
                                  customAleartDialog(
                                      context: context,
                                      title: 'Delete Goal?',
                                      width: width,
                                      titleButton1: 'Delete Goal?',
                                      firstButtonOnPressed: () async {
                                        ApiServices service = ApiServices();
                                        // await service.moveMoney(
                                        //   amount: appConstants
                                        //       .goal.goalAmountCollected,
                                        //   fromWalletName:
                                        //       AppConstants.All_Goals_Wallet,
                                        //   toWalletName: AppConstants.Spend_Wallet,
                                        //   userId: appConstants.userRegisteredId,
                                        // );
                                        await service.deleteGoal(
                                            documentId: widget.snapshot.id);
                                        // Navigator.pop(context);
                                        Navigator.pop(context);
                                      },
                                      secondButtonOnPressed: () {
                                        Navigator.pop(context);
                                      });

                                  // return;
                                },
                                child: Icon(
                                  Icons.more_horiz,
                                  color: black,
                                )),
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
                            imageBaseAddress + 'expire_goal.png',
                          ),
                          SizedBox(height: height * 0.01),
                          appConstants.userModel.usaCountry == "Pakistan"
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
                                      padding: const EdgeInsets.only(left: 2.0),
                                      child: Text(
                                        '${getCurrencySymbol(context, appConstants: appConstants)}',
                                        style: textStyleHeading2WithTheme(
                                            context, width * 0.8,
                                            whiteColor: 0),
                                      ),
                                    )
                                  ],
                                )
                              : Text(
                                  '${getCurrencySymbol(context, appConstants: appConstants)} ${getTwoDecimalNumber(amount: widget.snapshot[AppConstants.Goal_Target_Amount])}',
                                  style: heading3TextStyle(width,
                                      color: blue, font: 14),
                                  textAlign: TextAlign.right,
                                ),
                        ],
                      ),
                      /////////////
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Image.asset(imageBaseAddress + 'goal_amount.png'),
                            SizedBox(
                              height: 7,
                            ),
                            Text(
                              '${getCurrencySymbol(context, appConstants: appConstants)} ${(widget.snapshot[AppConstants.GOAL_amount_collected].toInt())}'
                              // '${(((widget.snapshot[AppConstants.GOAL_amount_collected]).toDouble() / (widget.snapshot[AppConstants.Goal_Target_Amount]).toDouble()) * 100).toInt()}%'
                              ,
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
                          widget.snapshot[AppConstants.GOAL_Status] ==
                                  AppConstants.GOAL_Status_completed
                              ? Column(
                                  children: [
                                    SizedBox(
                                      height: 35,
                                      child: Image.asset(
                                        imageBaseAddress + 'completed.png',
                                        // width: width * 0.3,
                                        height: height * 0.065,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 7,
                                    ),
                                    // TextValue2(title: 'Completed'),
                                    Text(
                                      formatedDateWithMonth(
                                          date: widget.snapshot[AppConstants
                                                  .GOAL_Expired_Date]
                                              .toDate()),
                                      style:
                                          heading3TextStyle(width, color: blue),
                                    )
                                    // TextValue3(title: )
                                  ],
                                )
                              :
                              // Container(
                              //   // color: grey,
                              //   height: height*0.1,
                              //   width: width*0.25,
                              //   child: Image.asset(imageBaseAddress+'expired_goal_button.png'))
                              // ,
                              InkWell(
                                  onTap: () {
                                    appConstants.updateGoalModel(GoalModel(
                                        docId: widget.snapshot.id,
                                        goalDate:
                                            widget.snapshot[AppConstants.GOAL_Expired_Date]
                                                .toDate(),
                                        tokensList: widget.snapshot[AppConstants
                                            .GOAL_Invited_Token_List],
                                        goalName: widget
                                            .snapshot[AppConstants.GOAL_name],
                                        goalPrice:
                                            getTwoDecimalNumber(amount: widget.snapshot[AppConstants.Goal_Target_Amount])
                                                .toString(),
                                        topSecret: widget.snapshot[
                                            AppConstants.GOAL_isPrivate],
                                        goalAmountCollected: (widget.snapshot[
                                                AppConstants.GOAL_amount_collected])
                                            .toDouble(),
                                        userId: appConstants.userRegisteredId));
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const NewGoal()));
                                  },
                                  child: Container(
                                      // color: grey,
                                      height: height * 0.1,
                                      width: width * 0.25,
                                      child: Image.asset(imageBaseAddress +
                                          'expired_expire.png')),
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
    );
  }
}
