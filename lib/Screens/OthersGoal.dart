import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zaki/Constants/BottomSheets.dart';
import 'package:zaki/Services/api.dart';
import 'package:zaki/Widgets/UserInfoForGoals.dart';
import '../Constants/AppConstants.dart';
import '../Constants/HelperFunctions.dart';
import '../Constants/Spacing.dart';
import '../Constants/Styles.dart';
import '../Widgets/ZakiCircularButton.dart';

class OthersGoal extends StatefulWidget {
  const OthersGoal({Key? key}) : super(key: key);

  @override
  State<OthersGoal> createState() => _OthersGoalState();
}

class _OthersGoalState extends State<OthersGoal> {
  Stream<QuerySnapshot>? friendsAndFamilyGoals;
  // Stream<QuerySnapshot>? userKids;
  @override
  void initState() {
    getGoals();
    super.initState();
  }

  getGoals() {
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        var appConstants = Provider.of<AppConstants>(context, listen: false);
        ApiServices service = ApiServices();
        friendsAndFamilyGoals =
            service.getFriendsAndFamilyGoals(appConstants.userRegisteredId);
        // userKids = service.fetchUserKids(appConstants.userRegisteredId);
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var appConstants = Provider.of<AppConstants>(context, listen: true);
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return friendsAndFamilyGoals == null
        ? SizedBox.shrink()
        : Container(
            child: StreamBuilder(
              stream: friendsAndFamilyGoals,
              //   stream: FirebaseFirestore.instance.collection(AppConstants.GOAL)
              // // .where(AppConstants.GOAL_user_id, isEqualTo: appConstants.userRegisteredId)
              // .where(AppConstants.GOAL_Status, isEqualTo: "AppConstants.GOAL_Status_Active")
              // .snapshots(),
              // .firestore.collection("GOAL_Invited_List")
              // .doc("userid").collection("GOAL_Invited_List").snapshots(),
              // initialData: initialData,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasError) {
                  return const Text('Ooops...Something went wrong :(');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text("");
                }
                if (snapshot.data!.docs.length == 0) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      spacing_X_large,
                      Center(
                          child: Image.asset(imageBaseAddress + 'no_goal.png')),
                      Text('No invites yet',
                          style: textStyleHeading2(
                            context,
                            width,
                          )),
                    ],
                  );
                }
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    logMethod(
                        title: 'Data',
                        message: snapshot.data!.docs[index]
                            [AppConstants.GOAL_id]);
                    return StreamBuilder<DocumentSnapshot>(
                      stream: FirebaseFirestore.instance
                      .collection(AppConstants().COUNTRY_CODE).doc(AppConstants().BANK_ID)
                      // .collection(AppConstants.USER)
                          .collection(AppConstants.GOAL)
                          .doc(snapshot.data!.docs[index][AppConstants.GOAL_id])
                          // .where(AppConstants.GOAL_Status, isNotEqualTo: AppConstants.GOAL_Status_completed)
                          .snapshots(),
                      // .collection(AppConstants.GOAL_Invited_List)
                      // .doc("")
                      // .collection(AppConstants.GOAL_Invited_List)
                      // .snapshots(),
                      // initialData: initialData,
                      builder: (BuildContext context, snapshots) {
                        if (snapshots.hasError) {
                          return const Text('Ooops...Something went wrong :(');
                        }
                        if (snapshots.connectionState ==
                            ConnectionState.waiting) {
                          return SizedBox.shrink();
                        }
                        if (!snapshots.data!.exists) {
                          return SizedBox.shrink();
                        }

                        var snapShot =
                            snapshots.data!.data() as Map<String, dynamic>;
                        if (snapShot[AppConstants.GOAL_Status] ==
                            AppConstants.GOAL_Status_completed) {
                          //If Goal Status is equal to Completed then i will remove that user from invited goal list on both sides
                          ApiServices().removeFriendAndFamilyGoal(
                              goalId: snapshot.data!.docs[index].id,
                              userId: appConstants.userRegisteredId,
                              goalSenderId: snapshot.data!.docs[index]
                                  [AppConstants.Goal_InviteSent_User_SenderId]);
                        }
                        return snapShot[AppConstants.GOAL_Status] ==
                                AppConstants.GOAL_Status_completed
                            ? SizedBox.shrink()
                            : Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  children: [
                                    UserInfoForGoals(
                                        userId: snapshot.data!.docs[index][
                                            AppConstants
                                                .Goal_InviteSent_User_SenderId]),
                                    spacing_medium,
                                    otherGoal(
                                        height,
                                        width,
                                        snapShot,
                                        appConstants,
                                        snapshot.data!.docs[index].id,
                                        sharedGoalId: snapshot.data!.docs[index]
                                            [AppConstants.GOAL_id],
                                        senderId: snapshot.data!.docs[index][
                                            AppConstants
                                                .Goal_InviteSent_User_SenderId])
                                  ],
                                ),
                              );
                      },
                    );
                  },
                );
              },
            ),
          );
  }

  otherGoal(height, width, snapshot, AppConstants appConstants, String goalId,
      {String? sharedGoalId, String? senderId}) {
    return Container(
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
                            '${snapshot[AppConstants.GOAL_name]}',
                            style:
                                heading2TextStyle(context, width, color: black),
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
                                  onTap: () {
                                    ApiServices service = ApiServices();
                                    customAleartDialog(
                                        context: context,
                                        title: 'Remove goal from your view?',
                                        width: width,
                                        firstButtonOnPressed: () {
                                          service.removeFriendAndFamilyGoal(
                                              goalId: goalId,
                                              userId:
                                                  appConstants.userRegisteredId,
                                              goalSenderId: senderId);
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                        },
                                        secondButtonOnPressed: () {
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                        });
                                    return;
                                  },
                                  leading: Icon(
                                    Icons.remove_circle_outline,
                                    color: black,
                                    size: width * 0.05,
                                  ),
                                  title: Text('Remove'),
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
                            appConstants.userModel.usaCountry == "Pakistan"
                                ? Row(
                                    children: [
                                      Text(
                                        '${getFormatedNumber(number: (snapshot[AppConstants.Goal_Target_Amount]).toDouble())}'
                                            .toString(),
                                        style: textStyleHeading1WithTheme(
                                            context, width,
                                            whiteColor: 0),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 2.0),
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
                                    '${getCurrencySymbol(context, appConstants: appConstants)} ${getTwoDecimalNumber(amount: snapshot[AppConstants.Goal_Target_Amount])}',
                                    style: heading3TextStyle(width,
                                        color: blue, font: 14),
                                    textAlign: TextAlign.right,
                                  ),
                          ],
                        ),
                        /////////////
                        // if (snapshot[AppConstants.GOAL_Status] ==AppConstants.GOAL_Status_Active)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              //  (!snapshot ['GOAL_expired_status'] && !snapshot ['GOAL_complete_status'])?
                              // (snapshot[AppConstants.GOAL_Status] =="expired" || expired)
                              (snapshot[AppConstants.GOAL_Status] ==
                                          AppConstants.GOAL_Status_expired ||
                                      snapshot[AppConstants.GOAL_Status] ==
                                          AppConstants.GOAL_Status_completed)
                                  ?
                                  // (snapshot [AppConstants.GOAL_Status]=="expired" ||checkDateExpire(dateToBeCheck:snapshot[AppConstants.GOAL_created_at].toDate())==true)?
                                  Image.asset(
                                      imageBaseAddress + 'expire_loading.png')
                                  : Image.asset(
                                      imageBaseAddress + 'loading.png'),
                              SizedBox(height: height * 0.014),
                              Text(
                                '${daysBetween(from: DateTime.now(), to: snapshot[AppConstants.GOAL_Expired_Date].toDate())}d',
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
                                    padding: const EdgeInsets.only(bottom: 4.0),
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        LinearProgressIndicator(
                                          value: (snapshot[AppConstants
                                                          .GOAL_amount_collected] ==
                                                      0 &&
                                                  snapshot[AppConstants
                                                          .Goal_Target_Amount] ==
                                                      0)
                                              ? 0
                                              : (((snapshot[AppConstants
                                                              .GOAL_amount_collected])
                                                          .toDouble() /
                                                      (snapshot[AppConstants
                                                              .Goal_Target_Amount])
                                                          .toDouble()) *
                                                  100 /
                                                  100),
                                          backgroundColor: transparent,
                                          color: goalLightGreenColor,
                                          minHeight: height * 0.043,
                                        ),
                                        Image.asset(
                                          imageBaseAddress + "goal_percent.png",
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
                                (snapshot[AppConstants.GOAL_amount_collected] ==
                                            0 &&
                                        snapshot[AppConstants
                                                .Goal_Target_Amount] ==
                                            0)
                                    ? '0%'
                                    : '${(((snapshot[AppConstants.GOAL_amount_collected]).toDouble() / (snapshot[AppConstants.Goal_Target_Amount]).toDouble()) * 100).toInt()}%',
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
                              title: snapshot[AppConstants.GOAL_Status] ==
                                      "completed"
                                  ? 'Completed'
                                  : 'Fund Me',
                              width: width * 0.7,
                              selected: 4,
                              onPressed: () {
                                logMethod(
                                    title: 'Selected Goal Id',
                                    message: sharedGoalId);
                                shareGoalBottomSheet(
                                  title: snapshot[AppConstants.GOAL_name],
                                  height: height,
                                  width: width,
                                  documentId: sharedGoalId,
                                  index: snapshot[
                                      AppConstants.GOAL_selected_index],
                                  collectedAmount: snapshot[
                                      AppConstants.GOAL_amount_collected],
                                  context: context,
                                  receiverUserId: senderId,
                                  // goalSnapshot: snapshot
                                );
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
