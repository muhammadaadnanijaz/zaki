import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_pagination/firebase_pagination.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zaki/Constants/CheckInternetConnections.dart';
import 'package:zaki/Constants/HelperFunctions.dart';
import 'package:zaki/Constants/NotificationTitle.dart';
import 'package:zaki/Constants/Spacing.dart';
// import 'package:zaki/Models/Items.dart';
// import 'package:zaki/Models/ToDoModelWithQuery.dart';
import 'package:zaki/Screens/ToDoCompleted.dart';
// import 'package:zaki/Widgets/CustomAllTransaction.dart';
import 'package:zaki/Widgets/CustomBottomNavigationBar.dart';
import 'package:zaki/Widgets/FloatingActionButton.dart';
// import 'package:zaki/Widgets/TextHeader.dart';
import 'package:zaki/Widgets/ToDoCustomTile.dart';
import 'package:zaki/Widgets/CustomLoader.dart';
import '../Constants/AppConstants.dart';
import '../Constants/Styles.dart';
import '../Services/api.dart';
import '../Widgets/AppBars/AppBar.dart';
import '../Widgets/UnSelectedKidsWidget.dart';

class TodoTasks extends StatefulWidget {
  const TodoTasks({Key? key}) : super(key: key);

  @override
  State<TodoTasks> createState() => _TodoTasksState();
}

class _TodoTasksState extends State<TodoTasks> {
  Query? selectedUserToDoQuery;
  Stream<QuerySnapshot>? userKids;
  Stream<QuerySnapshot>? selectedUserToDo;
  Stream<QuerySnapshot>? nextWeekToDo;
  // bool appConstants.isGirdView = false;
  int selectedIndex = -1;
  String selectedUserId = '';
  int? selectedUserSubscriptionValue = -1;
  String selectedUserToken = '';
  String selectedUserName = '';
  String? selectedUserParentId = '';
  final toDoTextContoller = TextEditingController();
  @override
  void initState() {
    getUserKids();
    super.initState();
  }

  @override
  void dispose() {
    toDoTextContoller.dispose();
    super.dispose();
  }

  getUserKids() {
    Future.delayed(const Duration(milliseconds: 200), () {
      ApiServices service = ApiServices();
      setState(() {
        var appConstants = Provider.of<AppConstants>(context, listen: false);
        selectedUserId = appConstants.userRegisteredId;
        selectedUserName = appConstants.userModel.usaFirstName!;
        selectedUserSubscriptionValue = -1;
        selectedUserParentId = '';
        if (appConstants.userModel.usaUserType ==
            AppConstants.USER_TYPE_PARENT) {
          userKids = ApiServices().fetchUserKids(
              appConstants.userModel.seeKids == true
                  ? appConstants.userModel.userFamilyId!
                  : appConstants.userRegisteredId,
              currentUserId: appConstants.userRegisteredId);
        }
        selectedUserToDo = service.getToDos(
            id: appConstants.userRegisteredId, condition: "", limit: 1);
        selectedUserToDoQuery = service.getToDosQuery(
            id: appConstants.userRegisteredId, condition: "", limit: 1);
        // nextWeekToDo = service.getToDos(
        //     id: appConstants.userRegisteredId,
        //     selectedDateTime: DateTime.now()
        //     );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var appConstants = Provider.of<AppConstants>(context, listen: true);
    var internet = Provider.of<CheckInternet>(context, listen: true);
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      floatingActionButton: CustomFloadtingActionButton(),
      bottomNavigationBar: CustomBottomNavigationBar(index: 0),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: getCustomPadding(),
              child: appBarHeader_005(
                context: context,
                appBarTitle: 'To Do\'s',
                backArrow: true,
                height: height,
                width: width,
                leadingIcon: true,
                ownBackArrowTakeHomeScreen: true,
                menuButton: PopupMenuButton(
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
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const ToDoCompleted()));
                        },
                        leading: Icon(
                          Icons.list_alt,
                          color: black,
                          size: width * 0.05,
                        ),
                        title: Text('Completed To Do\'s'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (appConstants.userModel.usaUserType ==
                AppConstants.USER_TYPE_PARENT)
              Container(
                color: orange.withValues(alpha:0.05),
                width: width,
                child: Padding(
                  padding: getCustomPadding(),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Row(
                      children: [
                        Container(
                          height: height * 0.127,
                          child: Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: InkWell(
                              onTap: () {
                                ApiServices service = ApiServices();
                                setState(() {
                                  selectedIndex = -1;
                                  selectedUserId =
                                      appConstants.userRegisteredId;
                                  selectedUserParentId =
                                      // appConstants.userModel.userFamilyId ==selectedUserId?'':
                                      "";
                                  selectedUserName =
                                      appConstants.userModel.usaFirstName!;
                                  try {
                                    selectedUserToken =
                                        appConstants.userModel.userTokenId ??
                                            '';
                                    selectedUserSubscriptionValue = -1;
                                  } catch (e) {
                                    selectedUserToken = '';
                                    selectedUserSubscriptionValue = -1;
                                  }
                                  logMethod(
                                      title: "parent Id",
                                      message: selectedUserParentId);
                                  selectedUserToDo = service.getToDos(
                                      id: appConstants.userRegisteredId,
                                      condition: "",
                                      limit: 1);
                                  // nextWeekToDo = service.getToDos(
                                  //     id: appConstants.userRegisteredId,
                                  //     selectedDateTime: DateTime.now());
                                });
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Stack(
                                    children: [
                                      Container(
                                        height: 70,
                                        width: 70,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: transparent,
                                          border: Border.all(
                                              width:
                                                  selectedIndex == -1 ? 2 : 0,
                                              color: selectedIndex == -1
                                                  ? orange
                                                  : transparent),
                                          boxShadow: selectedIndex != -1
                                              ? null
                                              : [
                                                  customBoxShadow(
                                                      color: orange)
                                                ],
                                        ),
                                        child: Padding(
                                            padding:
                                                const EdgeInsets.all(0.0),
                                            child: userImage(
                                                imageUrl: appConstants
                                                    .userModel.usaLogo!,
                                                userType: appConstants
                                                    .userModel.usaUserType,
                                                width: width * 0.6,
                                                gender: appConstants
                                                    .userModel.usaGender)),
                                      ),
                                      if (selectedIndex != -1)
                                        UnSelectedKidsWidget()
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    '@ ' +
                                        appConstants.userModel.usaUserName
                                            .toString(),
                                    // overflow: TextOverflow.clip,
                                    // maxLines: 1,
                                    style: heading5TextSmall(width),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        userKids == null
                            ? const SizedBox()
                            : Container(
                                // color: Color(0XFFF9FFF9),
                                height: height * 0.127,
                                // width: width,
                                child: StreamBuilder<QuerySnapshot>(
                                  stream: userKids,
                                  builder: (BuildContext context,
                                      AsyncSnapshot<QuerySnapshot> snapshot) {
                                    if (snapshot.hasError) {
                                      return const Text(
                                          'Ooops...Something went wrong :(');
                                    }
        
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Center(
                                          child: CustomLoader(
                                        // color: green,
                                      ));
                                    }
                                    if (snapshot.data!.size == 0) {}
                                    //snapshot.data!.docs[index] ['USA_first_name']
                                    return ListView.builder(
                                      itemCount: snapshot.data!.docs.length,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        // print(snapshot.data!.docs[index] ['USA_first_name']);
                                        return (
                                                // snapshot.data!.docs[index][
                                                //               AppConstants
                                                //                   .NewMember_isEnabled] ==
                                                //           false ||
                                                (snapshot.data!.docs[index][
                                                        AppConstants
                                                            .USER_UserType] !=
                                                    AppConstants
                                                        .USER_TYPE_KID))
                                            ? SizedBox.shrink()
                                            : Stack(
                                                clipBehavior: Clip.none,
                                                children: [
                                                  InkWell(
                                                    onTap: () async {
                                                      ApiServices service =
                                                          ApiServices();
                                                      setState(() {
                                                        selectedIndex = index;
                                                        // selectedUserToken = snapshot.data!.docs[index][AppConstants.USER_BankAccountID]??'';
                                                        selectedUserName =
                                                            snapshot.data!
                                                                        .docs[
                                                                    index][
                                                                AppConstants
                                                                    .USER_first_name];
                                                        try {
                                                          logMethod(
                                                              title:
                                                                  'Token in main Todo',
                                                              message:
                                                                  '${snapshot.data!.docs[index][AppConstants.USER_BankAccountID]} :::::$selectedUserToken');
                                                          selectedUserToken =
                                                              (snapshot.data!
                                                                          .docs[
                                                                      index][
                                                                  AppConstants
                                                                      .USER_BankAccountID]);
                                                          selectedUserSubscriptionValue =
                                                              snapshot.data!
                                                                          .docs[
                                                                      index][
                                                                  AppConstants
                                                                      .USER_SubscriptionValue];
                                                        } catch (e) {
                                                          selectedUserSubscriptionValue =
                                                              0;
                                                          selectedUserToken =
                                                              '';
                                                        }
        
                                                        selectedUserId =
                                                            snapshot
                                                                .data!
                                                                .docs[index]
                                                                .id;
                                                        selectedUserParentId =
                                                            snapshot.data!.docs[
                                                                        index]
                                                                    [
                                                                    AppConstants
                                                                        .USER_Family_Id] ??
                                                                '';
                                                        logMethod(
                                                            title:
                                                                "parent Id",
                                                            message:
                                                                selectedUserParentId);
                                                        selectedUserToDo =
                                                            service.getToDos(
                                                                id: snapshot
                                                                    .data!
                                                                    .docs[
                                                                        index]
                                                                    .id,
                                                                condition: "",
                                                                limit: 1);
                                                        // nextWeekToDo = service
                                                        //     .getToDos(
                                                        //         id: snapshot.data!
                                                        //             .docs[index].id,
                                                        //         selectedDateTime:
                                                        //             DateTime.now());
                                                      });
        
                                                      // });
                                                    },
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets
                                                              .only(
                                                              right: 12.0),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Stack(
                                                            children: [
                                                              Container(
                                                                height: 70,
                                                                width: 70,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  shape: BoxShape
                                                                      .circle,
                                                                  color:
                                                                      transparent,
                                                                  border: Border.all(
                                                                      width: selectedIndex ==
                                                                              index
                                                                          ? 2
                                                                          : 0,
                                                                      color: selectedIndex ==
                                                                              index
                                                                          ? orange
                                                                          : transparent),
                                                                  boxShadow:
                                                                      selectedIndex !=
                                                                              index
                                                                          ? null
                                                                          : [
                                                                              customBoxShadow(color: orange)
                                                                            ],
                                                                ),
                                                                child: Padding(
                                                                    padding: const EdgeInsets.all(0.0),
                                                                    child: userImage(
                                                                      imageUrl: snapshot
                                                                          .data!
                                                                          .docs[index][AppConstants.USER_Logo],
                                                                      userType: snapshot
                                                                          .data!
                                                                          .docs[index][AppConstants.USER_UserType],
                                                                      width:
                                                                          width,
                                                                      gender: snapshot
                                                                          .data!
                                                                          .docs[index][AppConstants.USER_gender],
                                                                    )),
                                                              ),
                                                              if (selectedIndex !=
                                                                  index)
                                                                UnSelectedKidsWidget()
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            height: 5,
                                                          ),
                                                          SizedBox(
                                                            // width: height * 0.065,
                                                            child: Center(
                                                              child: Text(
                                                                (snapshot.data!.docs[index][AppConstants.USER_user_name] ==
                                                                            null ||
                                                                        snapshot.data!.docs[index][AppConstants.USER_user_name] ==
                                                                            '')
                                                                    ? snapshot
                                                                            .data!
                                                                            .docs[index]
                                                                        [
                                                                        AppConstants
                                                                            .USER_first_name]
                                                                    : '@ ' +
                                                                        snapshot
                                                                            .data!
                                                                            .docs[index][AppConstants.USER_user_name],
                                                                overflow:
                                                                    TextOverflow
                                                                        .fade,
                                                                maxLines: 1,
                                                                style:
                                                                    heading5TextSmall(
                                                                        width),
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  StreamBuilder(
                                                      stream: FirebaseFirestore
                                                          .instance
                                                          .collection(AppConstants
                                                              .To_Do_Pending_Approval)
                                                          // .doc()
                                                          .where(
                                                              AppConstants
                                                                  .DO_UserId,
                                                              isEqualTo:
                                                                  snapshot
                                                                      .data!
                                                                      .docs[
                                                                          index]
                                                                      .id)
                                                          // .collection(AppConstants.Goal_InviteReceivedFrom_UserID)
                                                          .snapshots(),
                                                      builder: (BuildContext
                                                              context,
                                                          AsyncSnapshot
                                                              snapshots) {
                                                        var width =
                                                            MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width;
                                                        if (snapshots
                                                            .hasError) {
                                                          return const Text(
                                                              ':(');
                                                        }
                                                        if (snapshots
                                                                .connectionState ==
                                                            ConnectionState
                                                                .waiting) {
                                                          return SizedBox
                                                              .shrink();
                                                        }
                                                        if (snapshots
                                                                .data!
                                                                .docs
                                                                .length ==
                                                            0) {
                                                          return SizedBox
                                                              .shrink();
                                                        }
                                                        // var snapShot = snapshots.data!.data() as Map<String, dynamic>;
                                                        return Positioned(
                                                            top: 5,
                                                            right: 0.5,
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                  color:
                                                                      white,
                                                                  border: Border.all(
                                                                      color:
                                                                          orange,
                                                                      width:
                                                                          2),
                                                                  shape: BoxShape
                                                                      .circle),
                                                              child: Padding(
                                                                padding: const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        14,
                                                                    vertical:
                                                                        0),
                                                                child: Text(
                                                                  '${snapshots.data!.docs.length}',
                                                                  style: heading4TextSmall(
                                                                      width,
                                                                      color:
                                                                          orange),
                                                                ),
                                                              ),
                                                            ));
                                                      })
                                                ],
                                              );
                                      },
                                    );
                                  },
                                ),
                              ),
                        // SizedBox(width: width*0.2,)
                      ],
                    ),
                  ),
                ),
              ),
            Padding(
              padding: getCustomPadding(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // appConstants.userModel.usaUserType==AppConstants.USER_TYPE_PARENT?
                  // spacing_large
                  // :
                  spacing_medium,
        
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // TextHeader1(
                      //   title: 'This Week:',
                      // ),
                      Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                            color: lightGrey.withValues(alpha:0.3),
                            borderRadius: BorderRadius.circular(20)),
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () {
                                appConstants.updateIsGridView();
                              },
                              child: AnimatedContainer(
                                duration: Duration(milliseconds: 200),
                                decoration: BoxDecoration(
                                    color: appConstants.isGirdView == false
                                        ? white
                                        : transparent,
                                    borderRadius: BorderRadius.circular(20)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4, vertical: 2.0),
                                  child: Icon(
                                    Icons.list,
                                    size: 16,
                                    color: appConstants.isGirdView == false
                                        ? lightGrey.withValues(alpha:0.3)
                                        : white,
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  appConstants.isGirdView =
                                      !appConstants.isGirdView!;
                                });
                              },
                              child: AnimatedContainer(
                                duration: Duration(milliseconds: 200),
                                decoration: BoxDecoration(
                                    color: appConstants.isGirdView == true
                                        ? white
                                        : transparent,
                                    borderRadius: BorderRadius.circular(20)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4, vertical: 2.0),
                                  child: Icon(
                                    Icons.grid_view,
                                    size: 16,
                                    color: appConstants.isGirdView == true
                                        ? lightGrey.withValues(alpha:0.3)
                                        : white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  spacing_medium,
                  // CustomSizedBox(
                  //           height: height,
                  //         ),
                  // if(selectedUserToDoQuery!=null)
                              
                  // selectedUserToDo == null
                  //     ? const SizedBox()
                  //     : StreamBuilder<QuerySnapshot>(
                  //         stream: selectedUserToDo,
                  //         builder: (BuildContext context,
                  //             AsyncSnapshot<QuerySnapshot> snapshot) {
                  //           if (snapshot.hasError) {
                  //             return const Text(
                  //                 'Ooops...Something went wrong :(');
                  //           }
        
                  //           if (snapshot.connectionState ==
                  //               ConnectionState.waiting) {
                  //             return Center(
                  //                 child: CustomLoader(
                  //               // color: green,
                  //             ));
                  //           }
                  //           if (snapshot.data!.size == 0) {}
                  //           //snapshot.data!.docs[index] ['USA_first_name']
                  //           return
                  //               // ?
                  //               // // toDoAltListTile
                  //               // :
                  //               ReorderableListView.builder(
                  //             onReorder: (oldIndex, newIndex) {
                  //               DateTime oldDateTime = snapshot.data!
                  //                   .docs[oldIndex][AppConstants.DO_CreatedAt]
                  //                   .toDate();
                  //               DateTime newDateTime = snapshot.data!
                  //                   .docs[newIndex][AppConstants.DO_CreatedAt]
                  //                   .toDate();
                  //               DateTime updatedTime = newDateTime.subtract(
                  //                   const Duration(milliseconds: 10));
                  //               logMethod(
                  //                   title: "Time",
                  //                   message:
                  //                       'Old date: $oldDateTime : New Date $newDateTime-->>Updated Time $updatedTime');
                  //               ApiServices().updateToDoDateAfterSwipe(
                  //                   todoId: snapshot.data!.docs[oldIndex].id,
                  //                   updatedDate: updatedTime,
                  //                   userId: selectedUserId);
                  //               // logMethod(title: "Time", message: 'Now is ::>>${DateTime.now()} <:: old time: ${snapshot.data!.docs[oldIndex][AppConstants.DO_CreatedAt].toDate()} -->>New Time: ${snapshot.data!.docs[newIndex][AppConstants.DO_CreatedAt].toDate()} -->>Updated Time $updatedTime');
                  //             },
                  //             // header: Text(snapshot.data!.docs.first.id.toString()),
                  //             // key: ValueKey(snapshot.data!.docs[3].id),
                  //             itemCount: snapshot.data!.docs.length,
                  //             physics: const NeverScrollableScrollPhysics(),
                  //             shrinkWrap: true,
                  //             // scrollDirection: Axis.horizontal,
                  //             itemBuilder: (BuildContext context, int index) {
                  //               // print(snapshot.data!.docs[index] ['USA_first_name']);
                  //               return (snapshot.data!.docs[index][
                  //                               AppConstants
                  //                                   .ToDo_Repeat_Schedule] ==
                  //                           '' &&
                  //                       snapshot.data!.docs[index]
                  //                               [AppConstants.DO_Status] ==
                  //                           "Completed")
                  //                   ? Container(
                  //                       // elevation: 0,
                  //                       key: ValueKey(
                  //                         snapshot.data!.docs[index].id
                  //                             .toString(),
                  //                       ),
                  //                       child: SizedBox.shrink())
                  //                   :
                  //                   // snapshot.data!.docs[index] [AppConstants.DO_Status] != "Completed"?
                  //                   Container(
                  //                       // elevation: 0,
                  //                       key: ValueKey(
                  //                         snapshot.data!.docs[index].id
                  //                             .toString(),
                  //                       ),
                  //                       child: ToDoCustomTile(
                  //                         snapshot.data!.docs[index],
                  //                         selectedUserId,
                  //                         index: index,
                  //                         selectedUserSubscriptionValue:
                  //                             selectedUserSubscriptionValue,
                  //                         selectedUserName: selectedUserName,
                  //                         toDoIsGridView:
                  //                             appConstants.isGirdView,
                  //                         selectedUserToken:
                  //                             selectedUserToken,
                  //                       ));
                  //               //  : SizedBox.shrink();
                  //             },
                  //           );
                  //         },
                  //       ),
                  // Row(
                  //   crossAxisAlignment: CrossAxisAlignment.center,
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     Icon(
                  //       Icons.circle_outlined,
                  //       color: grey.withValues(alpha:0.4),
                  //     ),
                  //     Expanded(
                  //       child: Padding(
                  //         padding:
                  //             const EdgeInsets.only(bottom: 12.0, left: 12),
                  //         child: toDoTextField(
                  //             context, width, appConstants, internet),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  
                  // spacing_medium,
                  //     Text(
                  //       'Coming Weeks:',
                  //       overflow: TextOverflow.clip,
                  //       maxLines: 1,
                  //       style: heading1TextStyle(context, width),
                  //     ),
                  //     // CustomSizedBox(
                  //     //           height: height,
                  //     //         ),
                  //     nextWeekToDo == null
                  //         ? const SizedBox()
                  //         : StreamBuilder<QuerySnapshot>(
                  //             stream: nextWeekToDo,
                  //             builder: (BuildContext context,
                  //                 AsyncSnapshot<QuerySnapshot> snapshot) {
                  //               if (snapshot.hasError) {
                  //                 return const Text(
                  //                     'Ooops...Something went wrong :(');
                  //               }
        
                  //               if (snapshot.connectionState ==
                  //                   ConnectionState.waiting) {
                  //                 return Center(
                  //                     child: CustomLoader(
                  //                   color: green,
                  //                 ));
                  //               }
                  //               if (snapshot.data!.size == 0) {}
                  // //snapshot.data!.docs[index] ['USA_first_name']
                  //               return ListView.builder(
                  //                 itemCount: snapshot.data!.docs.length,
                  //                 physics: const NeverScrollableScrollPhysics(),
                  //                 shrinkWrap: true,
                  //                 // scrollDirection: Axis.horizontal,
                  //                 itemBuilder: (BuildContext context, int index) {
                  //                   // print(snapshot.data!.docs[index] ['USA_first_name']);
                  //                   return
                  //                       // snapshot.data!.docs[index] [AppConstants.DO_Status] != "Completed"?
                  //                       ToDoCustomTile(
                  //                     snapshot.data!.docs[index],
                  //                     selectedUserId,
                  //                     selectedUserName: selectedUserName,
                  //                     toDoIsGridView: appConstants.isGirdView,
                  //                     selectedUserToken: selectedUserToken
        
                  //                   );
                  //                   //  : SizedBox.shrink();
                  //                 },
                  //               );
                  //             },
                  //           ),
                ],
              ),
            ),
            if(selectedUserToDoQuery!=null)
            Expanded(
              child: FirestorePagination(
                                // query: allTransactions,
                                // query: FirebaseFirestore.instance.collection('${AppConstants.USER}/${appConstants.userRegisteredId}/${AppConstants.Transaction}').orderBy(AppConstants.created_at, descending: true),
                                query: selectedUserToDoQuery!,
                                // query: FirebaseFirestore.instance.collection(AppConstants.USER).doc(userId).collection(AppConstants.Transaction),
                                  // query: FirebaseFirestore.instance.collection(AppConstants.USER).orderBy(AppConstants.USER_created_at),
                                  isLive: true,
                                  physics: AlwaysScrollableScrollPhysics(),
                                  scrollDirection: Axis.vertical,
                                  limit: 10,
                                  shrinkWrap: true,
                                  onEmpty: Center(child: Text('Add New todo')),
                                  bottomLoader: Center(child: CircularProgressIndicator()),
                                  itemBuilder: (context, documentSnapshot, index) {
                                    // final data = documentSnapshot.data() as Map<String, dynamic>;
                                    // final item = TodoModelWithQuery.fromFirestore(data);
                                    final documentSnapshotss = documentSnapshot[index];
  if (documentSnapshotss is QueryDocumentSnapshot) {
    final queryDocumentSnapshot = documentSnapshotss;
    // final queryDocumentSnapshot = documentSnapshot as QueryDocumentSnapshot<Object?>;
                                    // Do something cool with the data
                                    return  Padding(
                                      padding: getCustomPadding(),
                                      child: ToDoCustomTile(
                                            queryDocumentSnapshot,
                                            selectedUserId,
                                            index: index,
                                            selectedUserSubscriptionValue:
                                                selectedUserSubscriptionValue,
                                            selectedUserName: selectedUserName,
                                            toDoIsGridView:
                                                appConstants.isGirdView,
                                            selectedUserToken:
                                                selectedUserToken,
                                          ),
                                    );
  } else {
    return const SizedBox.shrink(); // or handle the case appropriately
  }
                                    
                                    // Text('Users names are: ${data[AppConstants.USER_first_name]}');
                                    // AllActivitiesCustomTile(data: item, onTap: (){},);
                                    // AllActivitiesCustomTileHomeScreen(
                                    //             data: data[index],
                                    //             onTap: () {
                                    //               // selectAnAlocationBottomSheet(
                                    //               //     context: context,
                                    //               //     height: height,
                                    //               //     width: width,
                                    //               //     selectedUserId: selectedUserId,
                                    //               //     transactionId:
                                    //               //         snapshot.data!.docs[index].id,
                                    //               //     previousSelected: snapshot
                                    //               //             .data!.docs[index]
                                    //               //         [AppConstants.Transaction_TAGIT_code]
                                    //               //     // appConstants: appConstants
                                    //               //     );
                                    //             },
                                    //           );
                                },
                              ),),
                // spacing_medium,
                Padding(
                  padding: getCustomPadding(),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.circle_outlined,
                          color: grey.withValues(alpha:0.4),
                        ),
                        Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.only(bottom: 12.0, left: 12),
                            child: toDoTextField(
                                context, width, appConstants, internet),
                          ),
                        ),
                      ],
                    ),
                ),
                spacing_medium
          ],
        ),
      ),
    );
  }

  TextFormField toDoTextField(BuildContext context, double width,
      AppConstants appConstants, CheckInternet internet) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      textInputAction: TextInputAction.done,
      readOnly: internet.status == AppConstants.INTERNET_STATUS_NOT_CONNECTED
          ? true
          : false,
      onFieldSubmitted: (String value) async {
        print("Done button is clicked with text: $value");
        if (toDoTextContoller.text.length == 0) {
          return;
        }
        ApiServices().addToDo(
            newCreatedAt: DateTime.now(),
            createdAt: DateTime.now(),
            doDay: '',
            doStatus: '',
            doTitle: toDoTextContoller.text,
            doType: '',
            parentId: selectedUserParentId,
            userId: selectedUserId,
            linkedAllowance: false);
        if (selectedUserParentId != '') {
          ApiServices().getUserTokenAndSendNotification(
              userId: selectedUserId,
              title: '${NotificationText.GOAL_PARENT_ADDED_TO_TITLE}',
              subTitle:
                  '${appConstants.userModel.usaUserName} ${NotificationText.GOAL_PARENT_ADDED_TO_SUB_TITLE}');
        }
        toDoTextContoller.clear();
        // selectedUserToDo = await ApiServices().getToDos(id: appConstants.userRegisteredId, condition: "", limit: 1);
        // setState(() {

        // });
      },
      // validator: (String? email) {
      // if (email!.isEmpty) {
      //   return 'Please Enter Email';
      // } else if (!RegExp(
      //         r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      //     .hasMatch(email)) {
      //   return 'Please enter a valid email address';
      // } else {
      //   return null;
      // }
      // },
      // style: TextStyle(color: primaryColor),
      style: textStyleHeading2WithTheme(context, width * 0.8, whiteColor: 0),
      controller: toDoTextContoller,
      obscureText: false,
      keyboardType: TextInputType.emailAddress,
      maxLines: 1,
      maxLength: 50,
      // onChanged: (String? value) {
      //   setState(() {
      //     emailError = '';
      //   });
      //   print('value is: $emailError');
      // },
      decoration: InputDecoration(
          // enabledBorder: InputBorder,
          counterText: ''
          // errorText: emailError == '' ? null : emailError,
          // hintText: 'Enter Email',
          // hintStyle: textStyleHeading2WithTheme(context, width * 0.8,
          //     whiteColor: 2),
          // labelText: 'Enter Email',
          // labelStyle: textStyleHeading2WithTheme(context,width*0.8, whiteColor: 0),
          ),
    );
  }
}
