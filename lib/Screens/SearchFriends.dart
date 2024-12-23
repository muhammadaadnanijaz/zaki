import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zaki/Constants/HelperFunctions.dart';
import 'package:zaki/Constants/Styles.dart';
import 'package:zaki/Models/UserModel.dart';
import 'package:zaki/Services/api.dart';
import 'package:zaki/Widgets/AppBars/AppBar.dart';
import 'package:zaki/Widgets/CustomLoader.dart';
import '../Constants/AppConstants.dart';
import '../Constants/Spacing.dart';
import '../Widgets/ZakiCircularButton.dart';
import 'InviteMainScreen.dart';

class SearchFriends extends StatefulWidget {
  @override
  _SearchFriendsState createState() => _SearchFriendsState();
}

class _SearchFriendsState extends State<SearchFriends> {
  List<UserModel> friendsList = [];
  List<UserModel> friendsListFiltered = [];
  final searchNameController = TextEditingController();
  ApiServices services = ApiServices();
  bool loading = true;
  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 200), () {
      var appConstants = Provider.of<AppConstants>(context, listen: false);
      fetchUserKidsWithFuture(
          parentId: appConstants.userRegisteredId,
          currentUserId: appConstants.userRegisteredId);
    });
    super.initState();
  }

  fetchUserKidsWithFuture({String? parentId, String? currentUserId}) async {
    List<UserModel> list = [];
    // QuerySnapshot family =  await FirebaseFirestore.instance
    //   .collection(AppConstants.USER)
    //   // .where(AppConstants.USER_Family_Id, isEqualTo: parentId)
    //   .where(AppConstants.USER_Family_Id, isEqualTo: parentId)
    //   .where(AppConstants.USER_UserID, isNotEqualTo: currentUserId)
    //   .get();
    QuerySnapshot friends = await FirebaseFirestore.instance
        .collection(AppConstants.USER)
        .doc(currentUserId)
        .collection(AppConstants.USER_contacts)
        .where(AppConstants.USER_invited_signedup, isEqualTo: true)
        // .where(AppConstants.USER_UserID, isNotEqualTo: id)
        .get();
    friends.docs.forEach((element) async {
      Map<dynamic, dynamic> userMap = (element.data()! as Map);
      logMethod(title: 'Id', message: '${userMap[AppConstants.USER_UserID]}');
      DocumentSnapshot<Map<String, dynamic>>? userData = await services
          .getUserDataFromId(id: userMap[AppConstants.USER_UserID]);
      logMethod(
          title: 'Id', message: '${userData![AppConstants.USER_user_name]}');
      UserModel userModel = UserModel(
          usaIsenable: userData[AppConstants.NewMember_isEnabled],
          usaUserType: '${userData[AppConstants.USER_UserType]}',
          usaGender: '${userData[AppConstants.USER_gender]}',
          usaUserName: '${userData[AppConstants.USER_user_name]}',
          usaFirstName: '${userData[AppConstants.USER_first_name]}',
          usaLastName: '${userData[AppConstants.USER_last_name]}',
          usaUserId: userMap[AppConstants.USER_UserID],
          usaLogo: '${userData[AppConstants.USER_Logo]}');
      list.add(userModel);
      // element.data()[AppConstants.USER_first_name];
    });
    // family.docs.forEach((element) {
    //   Map<dynamic, dynamic> userMap = (element.data()! as Map);
    //   UserModel userModel = UserModel( usaIsenable: userMap [AppConstants.NewMember_isEnabled] , usaUserType: '${userMap [AppConstants.USER_UserType]}' ,usaGender: '${userMap [AppConstants.USER_gender]}', usaUserName: '${userMap [AppConstants.USER_user_name]}', usaFirstName: '${userMap [AppConstants.USER_first_name]}',usaLastName: '${userMap [AppConstants.USER_last_name]}', usaUserId: element.id, usaLogo: '${userMap [AppConstants.USER_Logo]}');
    //   list.add(userModel);
    //   // element.data()[AppConstants.USER_first_name];

    // });

    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        friendsList = list;
        friendsListFiltered = list;
        loading = false;
      });
    });

    // return userSearch;
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: getCustomPadding(),
          child: Column(
            children: [
              appBarHeader_005(
                  context: context,
                  appBarTitle: 'Select a ZakiPay Friend',
                  backArrow: true,
                  height: height,
                  width: width),
              // textValueBelow,
              // Padding(
              //   padding: EdgeInsets.only(left: width*0.05, right: width*0.2),
              //   child: TextFormField(
              //     controller: searchNameController,
              //     onChanged: (value) {
              //           setState(() {
              //             friendsList = friendsListFiltered
              //                 .where((element) => element.usaFirstName!.toLowerCase()
              //                     .contains(value.toLowerCase())
              //                     || element.usaLastName!.toLowerCase().contains(value.toLowerCase())
              //                     || element.usaUserName!.toLowerCase().contains(value.toLowerCase() ) )
              //                 .toList();
              //           });
              //         },
              //     // maxLength: 1,
              //     decoration: InputDecoration(
              //           hintText: 'Search',
              //           hintStyle: heading2TextStyle(
              //               context, width),
              //         prefixIcon: Padding(
              //           padding: const EdgeInsets.all(8),
              //           child: Icon(Icons.search)
              //         ),
              //         prefixIconConstraints:
              //             const BoxConstraints(minWidth: 0, minHeight: 0),
              //         ),
              //   ),
              // ),
              if (loading)
                SizedBox(
                  height: height * 0.4,
                  width: width,
                  child: Center(
                    child: CustomLoader(),
                  ),
                ),
              Expanded(
                child: (friendsList.length == 0 && !loading)
                    ? Center(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ZakiCicularButton(
                              title: 'Sync Contacts',
                              width: width * 0.7,
                              icon: Icons.sync_outlined,
                              // selected: 0,
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
                      )
                    : ListView.separated(
                        itemCount: friendsList.length,
                        shrinkWrap: true,
                        separatorBuilder: (context, index) => Container(
                          height: 0.5,
                          color: grey,
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          return (friendsList[index].usaIsenable == false)
                              ? SizedBox.shrink()
                              : ListTile(
                                  onTap: () {
                                    Navigator.pop(context, friendsList[index]);
                                  },
                                  leading: Container(
                                      height: height * 0.075,
                                      width: height * 0.075,
                                      decoration:
                                          BoxDecoration(shape: BoxShape.circle),
                                      child: userImage(
                                          imageUrl: friendsList[index].usaLogo,
                                          userType:
                                              friendsList[index].usaUserType,
                                          width: width,
                                          gender:
                                              friendsList[index].usaGender)),
                                  title: Text(
                                    '${friendsList[index].usaFirstName} ${friendsList[index].usaLastName}',
                                    style: heading1TextStyle(context, width),
                                  ),
                                  subtitle: Text(
                                    '@ ${friendsList[index].usaUserName}',
                                    style: heading4TextSmall(width),
                                  ),
                                );
                        },
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
