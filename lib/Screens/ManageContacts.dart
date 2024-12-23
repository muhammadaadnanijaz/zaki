import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_pagination/firebase_pagination.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zaki/Constants/Spacing.dart';
import 'package:zaki/Models/NickNameModel.dart';
import 'package:zaki/Screens/InviteMainScreen.dart';
import 'package:zaki/Screens/IssueAndManageCards.dart';
import 'package:zaki/Services/api.dart';
import 'package:zaki/Widgets/CustomLoader.dart';
import 'package:zaki/Widgets/CustomSizedBox.dart';
import 'package:zaki/Widgets/TextHeader.dart';
import 'package:zaki/Widgets/ZakiPrimaryButton.dart';
import '../Constants/AppConstants.dart';
import '../Constants/Styles.dart';
import '../Widgets/AppBars/AppBar.dart';
import '../Widgets/ManageContactsCustomTile.dart';
import '../Widgets/ZakiCircularButton.dart';

class ManageContacts extends StatefulWidget {
  const ManageContacts({Key? key}) : super(key: key);

  @override
  _ManageContactsState createState() => _ManageContactsState();
}

class _ManageContactsState extends State<ManageContacts> {
  int selectedIndex = -1;
  String selectedUserId = '';
  ApiServices services = ApiServices();
  NickNameModel? nickNameModel = NickNameModel();

  Query? favoriteFriendsQuery;
  Query? allFriendsQuery;

  @override
  void initState() {
    super.initState();
    ApiServices service = ApiServices();
    Future.delayed(Duration.zero, () async {
      var appConstants = Provider.of<AppConstants>(context, listen: false);
      favoriteFriendsQuery = service.selectedUserFavoriteFriendList(
          favoriteCondition: true, id: appConstants.userRegisteredId);
      allFriendsQuery = service.selectedUserAllFriendListWithQuery(
          conditionStatus: true, id: appConstants.userRegisteredId);
      selectedUserId = appConstants.userRegisteredId;
      getNickName(appConstants.userRegisteredId);
      setState(() {});
    });
  }

  getNickName(String userId) async {
    nickNameModel = await ApiServices()
        .getNickNameOfFavorit(context: context, userId: userId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var appConstants = Provider.of<AppConstants>(context, listen: true);
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: getCustomPadding(),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                appBarHeader_005(
                    context: context,
                    appBarTitle: 'ZakiPay Contacts',
                    backArrow: false,
                    height: height,
                    width: width,
                    leadingIcon: true),
                Stack(
                  children: [
                    Column(
                      children: [
                        spacing_medium,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextHeader1(
                              title: (nickNameModel != null &&
                                      nickNameModel!.NickN_TopFriends != null &&
                                      nickNameModel!.NickN_TopFriends != "")
                                  ? appConstants.nickNameModel.NickN_TopFriends!
                                  : 'Favorite',
                            ),
                            ZakiCicularButton(
                              title: 'Sync Contacts',
                              width: width * 0.7,
                              icon: Icons.sync_outlined,
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => InviteMainScreen(
                                              fromHomeScreen: true,
                                            )));
                              },
                            ),
                          ],
                        ),
                        spacing_medium,
                        if (favoriteFriendsQuery != null)
                          FirestorePagination(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            query: favoriteFriendsQuery!,
                            initialLoader: CustomLoader(),
                            bottomLoader: Center(child: CircularProgressIndicator(),),
                            itemBuilder: (context, snapshot, index) {
                              final documentSnapshotss = snapshot[index];
  if (documentSnapshotss is QueryDocumentSnapshot) {
    final queryDocumentSnapshot = documentSnapshotss;
    return ManageContactCustomTile(
                                  selectedUserId: selectedUserId,
                                  snapshot: queryDocumentSnapshot);
    
    } else {
    return const SizedBox.shrink(); // or handle the case appropriately
  }
                              // final queryDocumentSnapshot = snapshot as QueryDocumentSnapshot<Object?>;
                              // return ManageContactCustomTile(
                              //     selectedUserId: selectedUserId,
                              //     snapshot: queryDocumentSnapshot);
                            },
                            isLive: true,
                            onEmpty: Center(
                              child: Column(
                                children: [
                                  spacing_medium,
                                  TextValue2(
                                    title: 'To + click ❤️',
                                  ),
                                ],
                              ),
                            ),
                          ),
                        spacing_large,
                        CustomInviteImage(),
                        spacing_large,
                        TextHeader1(
                          title: 'ZakiPay Friends',
                        ),
                        spacing_medium,
                        if (allFriendsQuery != null)
                          FirestorePagination(
                            query: allFriendsQuery!,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            initialLoader: CustomLoader(),
                            bottomLoader: Center(child: CircularProgressIndicator(),),
                            itemBuilder: (context, snapshot, index) {
                             final documentSnapshotss = snapshot[index];
  if (documentSnapshotss is QueryDocumentSnapshot) {
    final queryDocumentSnapshot = documentSnapshotss;
    return ManageContactCustomTile(
                                  selectedUserId: selectedUserId,
                                  snapshot: queryDocumentSnapshot);
    
    } else {
    return const SizedBox.shrink(); // or handle the case appropriately
  }
    
                              // return ManageContactCustomTile(
                              //     selectedUserId: selectedUserId,
                              //     snapshot: queryDocumentSnapshot);
                            },
                            isLive: true,
                            onEmpty: Center(
                              child: Column(
                                children: [
                                  spacing_medium,
                                  TextValue2(
                                    title: 'No friends found',
                                  ),
                                ],
                              ),
                            ),
                          ),
                        CustomSizedBox(
                          height: height,
                        ),
                        CustomSizedBox(
                          height: height,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // int lengthForFavorite(List<UserInvited> _list) {
  //   List<UserInvited> tasksLeft = _list
  //       .where((task) => task.isFavorite ?? false)
  //       .toList(); //where returns an iterable so we convert it back to a list
  //   return tasksLeft.length;
  // }

  // int lengthForZakiPayFriends(List<UserInvited> _list) {
  //   List<UserInvited> tasksLeft = _list
  //       .where((task) => task.isFavorite ?? false)
  //       .toList(); //where returns an iterable so we convert it back to a list
  //   return tasksLeft.length;
  // }
}

class CustomInviteImage extends StatelessWidget {
  final Color? buttonColor;
  final String? headingText;
  const CustomInviteImage({Key? key, this.buttonColor, this.headingText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomDivider(),
        spacing_medium,
        InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => InviteMainScreen(
                            fromHomeScreen: true,
                          )));
            },
            child: Image.asset(
              imageBaseAddress + 'invite_to.png',
              // invite_screen
              // width: MediaQuery.of(context).size.width,
              // color: green,
              // fit: BoxFit.cover,
            )),
        spacing_medium,
        if(headingText!=null)
        Column(
          children: [
            TextHeader1(title: headingText,),
            spacing_medium
          ],
         
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ZakiPrimaryButton(
              title: 'Invite Now',
              width: 40,
              backGroundColor: buttonColor != null ? buttonColor : null,
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => InviteMainScreen(
                              fromHomeScreen: true,
                            )));
              },
            ),
          ],
        ),
        spacing_medium,
        CustomDivider(),
      ],
    );
  }
}
