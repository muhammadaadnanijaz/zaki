// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zaki/Constants/AppConstants.dart';
import 'package:zaki/Constants/HelperFunctions.dart';
import 'package:zaki/Screens/ManageContacts.dart';
import 'package:zaki/Widgets/TextHeader.dart';
import '../Constants/Styles.dart';
import '../Services/api.dart';
import '../Widgets/AppBars/AppBar.dart';
import '../Widgets/InviteGoalCustomTile.dart';
import '../Widgets/ZakiCircularButton.dart';
import 'package:zaki/Widgets/CustomLoader.dart';

class GoalsContactInvitedScreen extends StatefulWidget {
  final String? goalId;
  final QueryDocumentSnapshot<Object?>? goalSnapshot;
  const GoalsContactInvitedScreen({Key? key, this.goalId, this.goalSnapshot})
      : super(key: key);

  @override
  _GoalsContactInvitedScreenState createState() =>
      _GoalsContactInvitedScreenState();
}

class _GoalsContactInvitedScreenState extends State<GoalsContactInvitedScreen> {
  Stream<QuerySnapshot>? userFriendsAndFamily;

  ApiServices services = ApiServices();
  Stream<QuerySnapshot>? allFriends;

  @override
  void initState() {
    super.initState();
    fetchUserFriendsAndFamily();
  }

  fetchUserFriendsAndFamily() {
    Future.delayed(const Duration(milliseconds: 200), () async {
      var appConstants = Provider.of<AppConstants>(context, listen: false);
      bool screenNotOpen =
          await checkUserSubscriptionValue(appConstants, context);
      logMethod(title: 'Data from Pay+', message: screenNotOpen.toString());
      if (screenNotOpen == true) {
        Navigator.pop(context);
      } else {
        // userFriendsAndFamily = ApiServices()
        //     .getUserFriendsAndFamilyForGoals(appConstants.userRegisteredId);
        allFriends = services.selectedUserAllFriendList(
            conditionStatus: true, id: appConstants.userRegisteredId);
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // var appConstants = Provider.of<AppConstants>(context, listen: true);
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
              appBarTitle: ' Goal',
              height: height,
              width: width,
              backArrow: true,
            ),
            if (allFriends != null)
              Expanded(
                child: StreamBuilder(
                  stream: allFriends,
                  // initialData: initialData,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasError) {
                      return const Text('Ooops...Something went wrong :(');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: const CustomLoader());
                    }
                    if (snapshot.data!.size == 0) {
                      return CustomInviteImage(
                        buttonColor: blue,
                        headingText: 'Add your Friends to ZakiPay to help reach your Goals!'
                      );
                    }
                    return ListView.separated(
                      separatorBuilder: (context, index) => const Divider(),
                      itemCount: snapshot.data!.docs.length,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        return InviteGoalCustomTile(
                            selectedGoalId: widget.goalId!,
                            snapshot: snapshot.data!.docs[index],
                            goalSnapshot: widget.goalSnapshot);
                      },
                    );
                  },
                ),
              ),
            // if (allFriends != null)
            //   Column(
            //     children: [
            //       spacing_medium,
            //       ZakiPrimaryButton(
            //         title: "Invite All",
            //         backGroundColor: blue,
            //         width: width,
            //         onPressed: () {
            //           // showNotification(icon: Icons.child_friendly_sharp, error: 1, message: 'Length::');
            //           ApiServices().inviteAllFriendsAndFamilyToGoal(
            //               userId: appConstants.userRegisteredId,
            //               goalId: widget.goalId,
            //               context: context,
            //               tokenList: widget.goalSnapshot![AppConstants.GOAL_Invited_Token_List],
            //               userName: appConstants.userModel.usaUserName
            //             );
            //         },
            //       ),
            //       spacing_medium,
            //     ],
            //   )
          ],
        ),
      ),
    ));
  }
}

class GoalFriendAndFamilyCustomTile extends StatelessWidget {
  final QueryDocumentSnapshot? snapshot;
  final String? goalId;
  const GoalFriendAndFamilyCustomTile({Key? key, this.snapshot, this.goalId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var appConstants = Provider.of<AppConstants>(context, listen: true);
    return ListTile(
        leading: CircleAvatar(child: Icon(Icons.person)),
        title: TextHeader1(
          title: snapshot![AppConstants.USER_contact_invitedphone],
        ),
        trailing: !snapshot![AppConstants.USER_invited_signedup]
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ZakiCicularButton(
                    title: 'Invite',
                    width: width * 0.7,
                    selected: 4,
                    icon: Icons.add,
                    onPressed: () {
                      ApiServices().updateGoalinviteStatus(
                          invitedId: snapshot!.id,
                          status: true,
                          userId: appConstants.userRegisteredId);
                      logMethod(
                          title: "user id and goal id",
                          message:
                              "${snapshot![AppConstants.USER_contact_invitedphone]} and ${goalId}");
                      ApiServices().addInvitedGoalToUserCollection(
                          goalId: goalId,
                          userId: snapshot![
                              AppConstants.USER_contact_invitedphone]);
                    },
                  ),
                ],
              )
            : IconButton(
                onPressed: () {
                  ApiServices().updateGoalinviteStatus(
                      invitedId: snapshot!.id,
                      status: false,
                      userId: appConstants.userRegisteredId);
                },
                icon: Icon(
                  Icons.check_circle_rounded,
                  color: blue,
                ),
              ));
  }
}
                // ContactListTileWidget(contacts: _contacts![index], image: image, width: width, data: data, userModel: appConstants.userModel,);


