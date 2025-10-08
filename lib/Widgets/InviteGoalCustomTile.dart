import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:zaki/Constants/NotificationTitle.dart';
import 'package:zaki/Constants/Whitelable.dart';
import 'package:zaki/Services/api.dart';
import 'package:zaki/Widgets/CustomLoader.dart';
import '../Constants/AppConstants.dart';
import '../Constants/HelperFunctions.dart';
import '../Constants/Styles.dart';
import 'TextHeader.dart';
import 'ZakiCircularButton.dart';

class InviteGoalCustomTile extends StatefulWidget {
  const InviteGoalCustomTile(
      {Key? key,
      required this.selectedGoalId,
      this.snapshot,
      this.goalSnapshot})
      : super(key: key);
  final String selectedGoalId;
  final QueryDocumentSnapshot<Object?>? goalSnapshot;
  final QueryDocumentSnapshot<Object?>? snapshot;

  @override
  State<InviteGoalCustomTile> createState() => _InviteGoalCustomTileState();
}

class _InviteGoalCustomTileState extends State<InviteGoalCustomTile> {
  ApiServices services = ApiServices();
  String imageUrl = '';
  String firstNmae = '';
  String lastName = '';
  String userName = '';
  String userId = '';
  int subscriptionValue = 0;

  @override
  void initState() {
    userData();
    super.initState();
  }

  userData() {
    Future.delayed(Duration.zero, () async {
      DocumentSnapshot<Map<String, dynamic>>? userData = await services
          .getUserDataFromId(id: widget.snapshot![AppConstants.USER_UserID]);
      if (userData != null) {
        imageUrl = userData.data()![AppConstants.USER_Logo];
        firstNmae = userData.data()![AppConstants.USER_first_name];
        lastName = userData.data()![AppConstants.USER_last_name];
        userName = userData.data()![AppConstants.USER_user_name];
        subscriptionValue =
            userData.data()![AppConstants.USER_SubscriptionValue];
        userId = userData.id;
        if (mounted) setState(() {});
      }
      // String number = '';
      // var appConstants = Provider.of<AppConstants>(context, listen: false);
    });
  }

  @override
  Widget build(BuildContext context) {
    var appConstants = Provider.of<AppConstants>(context, listen: true);
    // var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return subscriptionValue < 2
        ? SizedBox.shrink()
        : Padding(
            padding: const EdgeInsets.all(2.0),
            child: ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              leading: ClipOval(
                child: Container(
                  height: 60,
                  width: 60,
                  decoration:
                      BoxDecoration(shape: BoxShape.circle, color: grey),
                  child: imageUrl == ''
                      ? SizedBox()
                      : imageUrl.contains('assets/images/')
                          ? CircleAvatar(
                              backgroundColor: transparent,
                              child: Image.asset(imageUrl))
                          : CircleAvatar(
                              backgroundColor: transparent,
                              child: CachedNetworkImage(
                                imageUrl: imageUrl,
                                placeholder: (context, url) => CustomLoader(),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              )),
                ),
              ),
              title: TextValue2(
                title: (firstNmae == '' && lastName == '')
                    ? '${widget.snapshot![AppConstants.USER_first_name]}'
                    : '$firstNmae $lastName',
                //  title: 'abasdbsdbnasnmdbasnmbd',
              ),
              subtitle: TextValue3(
                title: userName == ''
                    ? '${widget.snapshot![AppConstants.USER_contact_invitedphone]}'
                    : '@ $userName',
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection(AppConstants().COUNTRY_CODE).doc(AppConstants().BANK_ID).collection(AppConstants.USER)
                          .doc(appConstants.userRegisteredId)
                          .collection(AppConstants.Goal_InviteSentTo_UserID)
                          .where(AppConstants.Goal_InviteSent_User_ReceiverId,
                              isEqualTo: userId)
                          .where(AppConstants.GOAL_id,
                              isEqualTo: widget.selectedGoalId)
                          .snapshots(),
                      // services.invitedToGoal(goalId: widget.selectedGoalId, selectedUserId: userId, userId: appConstants.userRegisteredId),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return SizedBox.shrink();
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return SizedBox.shrink();
                        }
                        if (snapshot.data!.docs.isEmpty) {
                          return ZakiCicularButton(
                            title: 'Invite',
                            width: width * 0.7,
                            selected: 4,
                            icon: Icons.add,
                            onPressed: () async {
                              String? token = await services
                                  .getUserTokenAndSendNotification(
                                      userId: userId,
                                      title:
                                          '${appConstants.userModel.usaUserName} ${NotificationText.GOAL_INVITED_NOTIFICATION_TITLE}',
                                      subTitle:
                                          '${NotificationText.GOAL_INVITED_NOTIFICATION_SUB_TITLE}');
                              // ApiServices().updateGoalinviteStatus(
                              //     invitedId: widget.snapshot!.id,
                              //     status: true,
                              //     userId: appConstants.userRegisteredId);
                              // if(token!=null){
                              logMethod(
                                  title: "user id and goal id",
                                  message:
                                      "${userId} and ${widget.selectedGoalId} and date:${widget.goalSnapshot![AppConstants.GOAL_Expired_Date]} and ${widget.goalSnapshot![AppConstants.GOAL_Invited_Token_List]}");
                              await services.addTokenToGoal(
                                  token: token,
                                  goalId: widget.selectedGoalId,
                                  tokenList: widget.goalSnapshot![
                                      AppConstants.GOAL_Invited_Token_List]);
                              // }

                              services.addInvitedGoalToUserCollection(
                                  goalId: widget.selectedGoalId,
                                  userId: appConstants.userRegisteredId,
                                  invitedToUserId: userId);
                            },
                          );
                        }
                        // var snapShot = snapshot.data!.docs.first.data() as Map<String, dynamic>;
                        return IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.check_circle_rounded,
                            color: blue,
                          ),
                        );
                      }),
                ],
              ),
            ),
          );
  }
}
