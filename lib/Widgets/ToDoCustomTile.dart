import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:zaki/Constants/CheckInternetConnections.dart';
import 'package:zaki/Constants/LocationGetting.dart';
import 'package:zaki/Constants/NotificationTitle.dart';
import 'package:zaki/Constants/Spacing.dart';
import 'package:zaki/Models/BalanceModel.dart';
import 'package:zaki/Services/CreaditCardApis.dart';
import 'package:zaki/Widgets/ZakiCircularButton.dart';
import 'package:zaki/Widgets/ZakiPrimaryButton.dart';
import '../Constants/AppConstants.dart';
import '../Constants/HelperFunctions.dart';
import '../Constants/Styles.dart';
import '../Services/api.dart';
import 'CustomTextButon.dart';
import 'TextHeader.dart';

class ToDoCustomTile extends StatefulWidget {
  final QueryDocumentSnapshot<Object?> snapshot;
  final String selectedUserId;
  final bool? fromHomeScreen;
  final bool? toDoIsGridView;
  final String? selectedUserName;
  final int? index;
  final int? selectedUserSubscriptionValue;
  final String? selectedUserToken;
  ToDoCustomTile(this.snapshot, this.selectedUserId,
      {this.fromHomeScreen,
      this.toDoIsGridView,
      this.selectedUserName,
      this.selectedUserSubscriptionValue,
      this.selectedUserToken,
      this.index});

  @override
  State<ToDoCustomTile> createState() => _ToDoCustomTileState();
}

class _ToDoCustomTileState extends State<ToDoCustomTile> {
  final formKey = GlobalKey<FormState>();
  TextEditingController toDoTextContoller = TextEditingController();
  bool isTextFieldClicked = false;
  // bool? isExistTwice = false;
  Color? color = grey.withOpacity(0.4);
  @override
  void initState() {
    // isExist();
    logMethod(
        title: 'Selected User Token',
        message: widget.selectedUserToken.toString());
    super.initState();
  }

  // isExist() async {
  //   bool? exist = await ApiServices().checkToDoTitleAlreadyExist(
  //       title: widget.snapshot[AppConstants.DO_Title],
  //       todoId: widget.snapshot.id,
  //       userId: widget.selectedUserId);
  //   // if (mounted)
  //   //   setState(() {
  //   //     isExistTwice = exist;
  //   //   });
  // }

  @override
  Widget build(BuildContext context) {
    var appConstants = Provider.of<AppConstants>(context, listen: true);
    var internet = Provider.of<CheckInternet>(context, listen: true);
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return
        // isExistTwice!
        //     ? SizedBox.shrink()
        //     :
        Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Slidable(
        useTextDirection: true, 
        // startActionPane: ActionPane(
        //   dismissible: ,
        //   motion: , children: children),
        // dragStartBehavior: Dr,
        // key: UniqueKey(),
        // enabled: widget.fromHomeScreen == true ? false : true,
        // closeOnScroll: true,
        startActionPane: ActionPane(
          motion: ScrollMotion(),
          extentRatio: 0.2,
          children: [
            SlidableAction(
              onPressed: (context) {
                //  && (widget.snapshot[AppConstants.ToDo_WithReward] ==true)
                /////////////If its parent Then parent can update The status
                if ((appConstants.userModel.usaUserType != "Kid")) {
                  setState(() {
                    color = green;
                  });
                  Future.delayed(Duration(seconds: 3), () {
                    DateTime nextDate = calculateNextDate(
                        widget.snapshot[AppConstants.DO_DUE_DATE].toDate(),
                        widget.snapshot[AppConstants.ToDo_Repeat_Schedule]);
                    logMethod(title: '1st function', message: 'Called');
                    ApiServices().updateToDoStatus(
                        toDoStatus: "Completed",
                        todoId: widget.snapshot.id,
                        userId: widget.selectedUserId,
                        nextSechduleDateTime: nextDate);
                    ApiServices().deletePendingParentApproavlAdding(
                        toDoId: widget.snapshot.id);
                    ApiServices().toDoCompltedTask(
                        userId: widget.selectedUserId,
                        dueDate: DateTime.now(),
                        toDoStatus: 'Completed',
                        todoId: widget.snapshot.id);
                    return;
                  });
                }
                //////////////If This todo is linked with Allowance then it should be makred as completed by kid
                // if (widget.snapshot[AppConstants.DO_parentId] != '') 
                if(widget.snapshot[AppConstants.ToDo_WithReward]==true)
                {
                  // widget.snapshot[AppConstants.ToDo_WithReward]==true
                  // 
                  ApiServices().getUserTokenAndSendNotification(
                      userId: widget.snapshot[AppConstants.DO_parentId],
                      title:
                          '${appConstants.userModel.usaUserName} ${NotificationText.GOAL_COMPLETED_NOTIFICATION_TITLE}',
                      subTitle:
                          '${NotificationText.GOAL_COMPLETED_NOTIFICATION_SUB_TITLE}');

                  ApiServices().updateKidToDoStatus(
                      toDoKidStatus: "Kid Completed",
                      todoId: widget.snapshot.id,
                      userId: widget.selectedUserId,
                      toDoWithReward: 
                                          (appConstants.userModel.usaUserType !=
                                                  AppConstants
                                                      .USER_TYPE_PARENT &&
                                              widget.snapshot[AppConstants
                                                      .ToDo_WithReward] ==
                                                  true)
                                          ? AppConstants.PendingParentApproval
                                          :  AppConstants.Active
                      );
                  ApiServices().pendingParentApproavlAdding(
                      currentUserId: appConstants.userRegisteredId,
                      receiverId: appConstants.userModel.userFamilyId,
                      toDoId: widget.snapshot.id);
                  return;
                }
                setState(() {
                  color = green;
                });
                Future.delayed(Duration(seconds: 3), () {
                  DateTime nextDate = calculateNextDate(
                      widget.snapshot[AppConstants.DO_DUE_DATE].toDate(),
                      widget.snapshot[AppConstants.ToDo_Repeat_Schedule]);
                  ApiServices().updateToDoStatus(
                      toDoStatus: "Completed",
                      todoId: widget.snapshot.id,
                      userId: widget.selectedUserId,
                      nextSechduleDateTime: nextDate);
                  ApiServices().deletePendingParentApproavlAdding(
                      toDoId: widget.snapshot.id);
                  ApiServices().toDoCompltedTask(
                      userId: widget.selectedUserId,
                      dueDate: DateTime.now(),
                      toDoStatus: 'Completed',
                      todoId: widget.snapshot.id);
                  logMethod(title: '2nd function', message: 'Called');
                  setState(() {
                    color = grey.withOpacity(0.4);
                  });
                });
              },
              backgroundColor: green,
              foregroundColor: white,
              padding: EdgeInsets.zero,
              borderRadius: BorderRadius.circular(16),
              icon: Icons.check,
              // label: 'Share',
            )
          ],
        ),
        endActionPane: ActionPane(
          motion: ScrollMotion(),
          // dismissible: Icon(Icons.delete, color: red),
          // extentRatio: 10,
          extentRatio: 0.4,
          children: [
            // widget.snapshot[AppConstants.DO_parentId] ==
            ((appConstants.userModel.usaUserType == "Kid") &&
                    (widget.snapshot[AppConstants.DO_Deleted_By] == "Kid"))
                ? SlidableAction(
                    onPressed: (context) {},
                    backgroundColor: orange,
                    foregroundColor: white,
                    icon: Icons.pending,
                    // label: 'Share',
                  )
                :
                // (appConstants.userModel.userFamilyId ==null || widget.snapshot[AppConstants.DO_parentId] == '')?
                SlidableAction(
                    onPressed: (context) {
                      // widget.snapshot[AppConstants.DO_Status]
                      if ((appConstants.userModel.usaUserType == "Kid") &&
                          (widget.snapshot[AppConstants.DO_parentId] != '')) {
                        ApiServices().updateDeletedByStatus(
                            todoId: widget.snapshot.id,
                            userId: widget.selectedUserId,
                            deletedBy: "Kid");
                        return;
                      }
                      ApiServices().deleteToDo(
                          todoId: widget.snapshot.id,
                          userId: widget.selectedUserId);
                    },
                    backgroundColor: crimsonColor,
                    foregroundColor: white,
                    padding: EdgeInsets.zero,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        bottomLeft: Radius.circular(20)),
                    // flex: 8,
                    icon: Icons.delete,
                    // label: 'Delete',
                  ),
            // : const SizedBox.shrink(),
            SlidableAction(
              onPressed: (context) async {
                // bool? personalization =
                //     await getUserKidsPersonalizationsSettings(
                //         kidId: widget.selectedUserId);

                selectTypeOFToDoBottomSheet(
                    context: context,
                    height: height,
                    width: width,
                    // linkedAllowance: personalization,
                    toDoId: widget.snapshot.id,
                    selectedUserId: widget.selectedUserId,
                    selectedDay: widget.snapshot[AppConstants.DO_Day],
                    selectedType:
                        widget.snapshot[AppConstants.ToDo_Repeat_Schedule],
                    isRepeated:
                        widget.snapshot[AppConstants.ToDo_Repeat_Schedule] == ''
                            ? false
                            : true,
                    date: widget.snapshot[AppConstants.DO_DUE_DATE].toDate());
              },
              backgroundColor: lightGrey.withOpacity(0.3),
              foregroundColor: white,
              padding: EdgeInsets.zero,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20)),
              icon: Icons.info,
              // label: 'Share',
            ),
          ],
        ),
        child: (appConstants.isGirdView != null &&
                appConstants.isGirdView == true)
            ? Container(
                height: height * 0.15,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(
                          widget.index! % 4 == 0
                              ? '$imageBaseAddress' 'todo_index_0.png'
                              : widget.index! % 4 == 1
                                  ? '$imageBaseAddress' 'todo_index_1.png'
                                  : widget.index! % 4 == 2
                                      ? '$imageBaseAddress'
                                          'todo_index_2.png'
                                      : imageBaseAddress + 'todo_index_3.png',
                        ),
                        fit: BoxFit.fitWidth)),
                child: Center(
                  child: ListTile(
                    leading: Image.asset(widget.index! % 4 == 0
                        ? imageBaseAddress + 'todo_logo_index_0.png'
                        : widget.index! % 4 == 1
                            ? imageBaseAddress + 'todo_logo_index_1.png'
                            : widget.index! % 4 == 2
                                ? imageBaseAddress + 'todo_logo_index_2.png'
                                :
                                // todo_logo_index_2
                                imageBaseAddress + 'todo_logo_index_3.png'),
                    trailing: InkWell(
                        onTap: () {
                          selectTypeOFToDoBottomSheet(
                              context: context,
                              height: height,
                              width: width,
                              // linkedAllowance: personalization,
                              toDoId: widget.snapshot.id,
                              selectedUserId: widget.selectedUserId,
                              selectedDay: widget.snapshot[AppConstants.DO_Day],
                              selectedType: widget
                                  .snapshot[AppConstants.ToDo_Repeat_Schedule],
                              isRepeated: widget.snapshot[
                                          AppConstants.ToDo_Repeat_Schedule] ==
                                      ''
                                  ? false
                                  : true,
                              date: widget.snapshot[AppConstants.DO_DUE_DATE]
                                  .toDate());
                        },
                        child: Icon(
                          Icons.info_outline,
                          color: white,
                        )),
                    title: Text(
                      widget.snapshot[AppConstants.DO_Title],
                      overflow: TextOverflow.clip,
                      maxLines: 2,
                      // textStyleHeading1WithTheme
                      style: textStyleHeading2(context, width * 0.85,
                          font: 16,
                          isLineThrough: (widget.snapshot[
                                          AppConstants.DO_Kid_Status] ==
                                      "Kid Completed" ||
                                  widget.snapshot[AppConstants.DO_Deleted_By] ==
                                      "Kid")
                              ? true
                              : false,
                          color: (widget.snapshot[AppConstants.DO_Kid_Status] ==
                                      "Kid Completed" ||
                                  widget.snapshot[AppConstants.DO_Deleted_By] ==
                                      "Kid")
                              ? orange
                              : white),
                    ),
                    subtitle: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget.snapshot[AppConstants.DO_DUE_DATE] != null)
                          Row(
                            children: [
                              if (widget
                                      .snapshot[AppConstants.ToDo_WithReward] ==
                                  true)
                                Row(
                                  children: [
                                    Icon( 
                                      FontAwesomeIcons.gift,
                                      color: white,
                                      size: 11,
                                    ),
                                    // SizedBox(
                                    //   width: 5,
                                    // ),
                                    Text(
                                      ' ${getCurrencySymbol(context, appConstants: appConstants)} ${widget.snapshot[AppConstants.ToDo_Reward_Amount]}, ',
                                      overflow: TextOverflow.clip,
                                      maxLines: 1,
                                      style: heading2TextStyle(context, width,
                                          font: 12, color: white),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                  ],
                                ),
                              Text(
                                '${formatedDateWithMonth(date: widget.snapshot[AppConstants.DO_DUE_DATE].toDate())}, ',
                                overflow: TextOverflow.clip,
                                maxLines: 1,
                                style: heading2TextStyle(context, width * 0.7,
                                    font: 12,
                                    color:
                                        // checkDateExpire(
                                        //   dateToBeCheck: widget.snapshot[AppConstants.DO_DUE_DATE].toDate()) ==true
                                        //   ?red:
                                        white),
                              ),
                              widget.snapshot[
                                          AppConstants.ToDo_Repeat_Schedule] !=
                                      ''
                                  ? Padding(
                                      padding: const EdgeInsets.only(left: 4.0),
                                      child: Icon(
                                        FontAwesomeIcons.repeat,
                                        color: white,
                                        size: 12,
                                      ),
                                    )
                                  : SizedBox.shrink(),
                              Padding(
                                padding: const EdgeInsets.only(left: 4.0),
                                child: Text(
                                  widget.snapshot[AppConstants
                                                  .ToDo_Repeat_Schedule]
                                              .toString()
                                              .length ==
                                          0
                                      ? ''
                                      : '${widget.snapshot[AppConstants.ToDo_Repeat_Schedule]}',
                                  overflow: TextOverflow.clip,
                                  maxLines: 1,
                                  style: heading2TextStyle(
                                    context,
                                    width * 0.7,
                                    font: 12,
                                    color: white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Row(
                            children: [
                              if (widget.snapshot[
                                          AppConstants.ToDo_Reward_Status] ==
                                      AppConstants.PendingParentApproval &&
                                  appConstants.userModel.usaUserType !=
                                      AppConstants.USER_TYPE_PARENT)
                                ZakiCicularButton(
                                  width: width * 0.1,
                                  title: 'Pending Parent Review',
                                  textColor: red,
                                  border: false,
                                  // iconColor: 3,
                                  textStyle: heading2TextStyle(context, width,
                                      color: orange, font: 10),
                                  backGroundColor: white,
                                  onPressed: () {},
                                ),
                              if (checkDateExpire(
                                      dateToBeCheck: widget
                                          .snapshot[AppConstants.DO_DUE_DATE]
                                          .toDate()) ==
                                  true)
                                ZakiCicularButton(
                                  width: width * 0.1,
                                  title: 'Past due',
                                  textColor: red,
                                  border: false,
                                  // iconColor: 3,
                                  textStyle: heading2TextStyle(context, width,
                                      color: red, font: 10),
                                  backGroundColor: white,
                                  onPressed: () {},
                                ),
                              Expanded(
                                  child: SizedBox(
                                width: 3,
                              ))
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
            : Column(
                children: [
                  Container(
                    decoration:
                        // widget.fromHomeScreen == true
                        //     ? BoxDecoration(
                        //         color:
                        //             widget.snapshot[AppConstants.ToDo_WithReward] ==true
                        //                 ? Color(0XFFF9FFF9)
                        //                 : transparent,
                        //         border: Border.all(color: black.withOpacity(0.1)),
                        //         borderRadius: BorderRadius.circular(width * 0.05),
                        //       )
                        //     :
                        BoxDecoration(
                            // color:
                            //     widget.snapshot[AppConstants.ToDo_WithReward] ==
                            //             true
                            //         ? Color(0XFFF9FFF9)
                            //         : transparent,
                            // ignore: unnecessary_null_comparison
                            image: (appConstants.isGirdView != null &&
                                    appConstants.isGirdView == true)
                                ? DecorationImage(
                                    image: AssetImage(imageBaseAddress +
                                        'toDoAltListTile.png'),
                                    fit: BoxFit.fitWidth)
                                : null),
                    child: InkWell(
                      onTap: () {},
                      child: Row(
                        children: [
                          InkWell(
                            onTap: internet.status ==
                                    AppConstants.INTERNET_STATUS_NOT_CONNECTED
                                ? null
                                : () async {
                                    if (widget.snapshot[
                                                AppConstants.ToDo_WithReward] ==
                                            true &&
                                        appConstants.userModel.usaUserType ==
                                            AppConstants.USER_TYPE_PARENT) {
                                      await showDialog(
                                          context: context,
                                          builder:
                                              (BuildContext dialougeContext) {
                                            return AlertDialog(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              14.0))),
                                              // title: const Text('Note'),
                                              content: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    'Send (${getCurrencySymbol(context, appConstants: appConstants)}${widget.snapshot[AppConstants.ToDo_Reward_Amount]}) Reward to ${widget.selectedUserName} for a job well done',
                                                    style: heading3TextStyle(
                                                      width,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              actions: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    ZakiCicularButton(
                                                      title:
                                                          '         Send         ',
                                                      width: width,
                                                      selected: 4,
                                                      backGroundColor: green,
                                                      border: false,
                                                      textStyle:
                                                          heading4TextSmall(
                                                              width,
                                                              color: white),
                                                      onPressed: () async {
                                                        bool? hasBalance = await ApiServices().checkBalance(
                                                            amount: double.parse(widget
                                                                .snapshot[
                                                                    AppConstants
                                                                        .ToDo_Reward_Amount]
                                                                .toString()),
                                                            selectedWalletName:
                                                                AppConstants
                                                                    .Spend_Wallet,
                                                            userId: appConstants
                                                                .userRegisteredId);
                                                        if (hasBalance ==
                                                            false) {
                                                          showNotification(
                                                              error: 1,
                                                              icon: Icons.error,
                                                              message:
                                                                  NotificationText
                                                                      .ADDED_SUCCESSFULLY);
                                                          Navigator.pop(
                                                              context);
                                                          return;
                                                        } else {
                                                          ///Parent payed reward
                                                          ApiServices().getUserTokenAndSendNotification(
                                                              userId: widget
                                                                  .selectedUserId,
                                                              title:
                                                                  '${getCurrencySymbol(context, appConstants: appConstants)}${widget.snapshot[AppConstants.ToDo_Reward_Amount]}${NotificationText.GOAL_PARENT_PAYED_REWARD_TODO_TITLE}',
                                                              subTitle:
                                                                  '${NotificationText.GOAL_PARENT_PAYED_REWARD_TODO_SUB_TITLE}');

                                                          ApiServices services =
                                                              ApiServices();
                                                          services.addMoneyToSelectedMainWallet(
                                                              amountSend: widget
                                                                  .snapshot[
                                                                      AppConstants
                                                                          .ToDo_Reward_Amount]
                                                                  .toString(),
                                                              receivedUserId: widget
                                                                  .selectedUserId,
                                                              senderId: appConstants
                                                                  .userRegisteredId);
                                                          //Transaction added on both sides, Sender and reeiver side as well
                                                          services.addTransaction(
                                                              transactionMethod:
                                                                  AppConstants
                                                                      .Transaction_Method_Payment,
                                                              tagItName: '',
                                                              tagItId: null,
                                                              selectedKidName:
                                                                  appConstants
                                                                      .userModel
                                                                      .usaFirstName,
                                                              accountHolderName:
                                                                  widget
                                                                      .selectedUserName,
                                                              amount: widget.snapshot[AppConstants.ToDo_Reward_Amount]
                                                                  .toString(),
                                                              currentUserId:
                                                                  appConstants
                                                                      .userRegisteredId,
                                                              receiverId: widget
                                                                  .selectedUserId,
                                                              requestType:
                                                                  AppConstants
                                                                      .TAG_IT_Transaction_TYPE_TODO_REWARD,
                                                              fromWallet: AppConstants
                                                                  .Spend_Wallet,
                                                              toWallet: AppConstants
                                                                  .Spend_Wallet,
                                                              senderId: appConstants
                                                                  .userRegisteredId);

                                                          ///Receiver side
                                                          services.addTransaction(
                                                              transactionMethod:
                                                                  AppConstants
                                                                      .Transaction_Method_Received,
                                                              tagItName: '',
                                                              tagItId: null,
                                                              selectedKidName: widget
                                                                  .selectedUserName,
                                                              accountHolderName:
                                                                  appConstants
                                                                      .userModel
                                                                      .usaFirstName,
                                                              amount:
                                                                  widget.snapshot[AppConstants.ToDo_Reward_Amount]
                                                                      .toString(),
                                                              currentUserId: widget
                                                                  .selectedUserId,
                                                              receiverId: widget
                                                                  .selectedUserId,
                                                              requestType: AppConstants
                                                                  .TAG_IT_Transaction_TYPE_TODO_REWARD,
                                                              fromWallet:
                                                                  AppConstants
                                                                      .Spend_Wallet,
                                                              toWallet: AppConstants
                                                                  .Spend_Wallet,
                                                              senderId: appConstants
                                                                  .userRegisteredId);
                                                          Navigator.pop(
                                                            dialougeContext,
                                                          );
                                                          // return;
                                                        }
                                                      },
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    ZakiCicularButton(
                                                      title:
                                                          '      Cancle      ',
                                                      width: width,
                                                      textStyle:
                                                          heading4TextSmall(
                                                              width,
                                                              color: green),
                                                      onPressed: () {
                                                        Navigator.pop(
                                                            dialougeContext);
                                                        return;
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            );
                                          });
                                    }
                                    //  && (widget.snapshot[AppConstants.ToDo_WithReward] ==true)
                                    /////////////If its parent Then parent can update The status
                                    if ((appConstants.userModel.usaUserType !=
                                        "Kid")) {
                                      setState(() {
                                        color = green;
                                      });
                                      Future.delayed(Duration(seconds: 3), () {
                                        DateTime nextDate = calculateNextDate(
                                            widget.snapshot[
                                                    AppConstants.DO_DUE_DATE]
                                                .toDate(),
                                            widget.snapshot[AppConstants
                                                .ToDo_Repeat_Schedule]);
                                        ApiServices().updateToDoStatus(
                                            toDoStatus: "Completed",
                                            todoId: widget.snapshot.id,
                                            userId: widget.selectedUserId,
                                            nextSechduleDateTime: nextDate);
                                        ApiServices()
                                            .deletePendingParentApproavlAdding(
                                                toDoId: widget.snapshot.id);
                                        ApiServices().toDoCompltedTask(
                                            userId: widget.selectedUserId,
                                            dueDate: DateTime.now(),
                                            toDoStatus: 'Completed',
                                            todoId: widget.snapshot.id);
                                        setState(() {
                                          color = grey.withOpacity(0.4);
                                        });
                                      });
                                      return;
                                    }
                                    //////////////If This todo is linked with Allowance then it should be makred as completed by kid
                                    // if (widget.snapshot[AppConstants.DO_parentId] != '')
                                    if(widget.snapshot[AppConstants.ToDo_WithReward]==true)
                                    {
                                      ApiServices().updateKidToDoStatus(
                                          toDoKidStatus: "Kid Completed",
                                          todoId: widget.snapshot.id,
                                          userId: widget.selectedUserId,
                                          toDoWithReward: 
                                          (appConstants.userModel.usaUserType !=
                                                  AppConstants
                                                      .USER_TYPE_PARENT &&
                                              widget.snapshot[AppConstants
                                                      .ToDo_WithReward] ==
                                                  true)
                                          ? AppConstants.PendingParentApproval
                                          :  AppConstants.Active
                                              // : AppConstants.Completed
                                          );
                                      ApiServices().pendingParentApproavlAdding(
                                          currentUserId:
                                              appConstants.userRegisteredId,
                                          receiverId: appConstants
                                              .userModel.userFamilyId,
                                          toDoId: widget.snapshot.id);
                                      return;
                                    }
                                    setState(() {
                                      color = green;
                                    });
                                    Future.delayed(Duration(seconds: 3), () {
                                      logMethod(
                                          title: 'Selected user and todo',
                                          message:
                                              '${widget.snapshot.id} and ${appConstants.userRegisteredId}');
                                      DateTime nextDate = calculateNextDate(
                                          widget.snapshot[
                                                  AppConstants.DO_DUE_DATE]
                                              .toDate(),
                                          widget.snapshot[AppConstants
                                              .ToDo_Repeat_Schedule]);
                                      ApiServices().updateToDoStatus(
                                          toDoStatus: "Completed",
                                          todoId: widget.snapshot.id,
                                          userId: widget.selectedUserId,
                                          nextSechduleDateTime: nextDate);
                                      ApiServices()
                                          .deletePendingParentApproavlAdding(
                                              toDoId: widget.snapshot.id);

                                      ApiServices().toDoCompltedTask(
                                          userId: widget.selectedUserId,
                                          dueDate: DateTime.now(),
                                          toDoStatus: 'Completed',
                                          todoId: widget.snapshot.id);
                                      setState(() {
                                        color = grey.withOpacity(0.4);
                                      });
                                    });
                                  },
                            child: Icon(
                                // (widget.snapshot[AppConstants.DO_Kid_Status] ==
                                //         "Kid Completed")
                                //     // widget.snapshot[AppConstants.DO_Status] == true
                                //     ? 
                                //     Icons.circle
                                    // : 
                                    Icons.circle_outlined
                                    ,
                                color:
                                    // widget.snapshot[AppConstants.DO_Kid_Status] ==AppConstants.Completed?
                                    // color:
                                    (widget.snapshot[AppConstants
                                                    .DO_Kid_Status] ==
                                                "Kid Completed" &&
                                            appConstants
                                                    .userModel.usaUserType ==
                                                'Kid')
                                        ? green.withOpacity(0.4)
                                        : widget.snapshot[AppConstants
                                                    .DO_Deleted_By] ==
                                                "Kid"
                                            ? grey.withOpacity(0.4)
                                            : color
                                // grey.withOpacity(0.4),
                                ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: isTextFieldClicked == true
                                            ? toDoTextField(
                                                context, width, internet)
                                            : InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    toDoTextContoller.text =
                                                        widget.snapshot[
                                                            AppConstants
                                                                .DO_Title];
                                                    isTextFieldClicked = true;
                                                  });
                                                },
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 5.0),
                                                  child: Text(
                                                    widget.snapshot[
                                                        AppConstants.DO_Title],
                                                    overflow: TextOverflow.clip,
                                                    maxLines: 2,
                                                    // textStyleHeading1WithTheme
                                                    style: textStyleHeading2(
                                                        context, width * 0.85,
                                                        font: 16,
                                                        isLineThrough: (widget.snapshot[AppConstants.DO_Kid_Status] ==
                                                                    "Kid Completed" ||
                                                                widget.snapshot[AppConstants.DO_Deleted_By] ==
                                                                    "Kid")
                                                            ? true
                                                            : false,
                                                        color: (widget.snapshot[AppConstants
                                                                        .DO_Kid_Status] ==
                                                                    "Kid Completed" ||
                                                                widget.snapshot[
                                                                        AppConstants.DO_Deleted_By] ==
                                                                    "Kid")
                                                            ? orange
                                                            : darkGrey),
                                                  ),
                                                ),
                                              ),
                                      ),
                                    ],
                                  ),
                                  spacing_small,
                                  // if (widget.fromHomeScreen != true)
                                  if (widget
                                          .snapshot[AppConstants.DO_DUE_DATE] !=
                                      null)
                                    Row(
                                      children: [
                                        if (widget.snapshot[
                                                AppConstants.ToDo_WithReward] ==
                                            true)
                                          Row(
                                            children: [
                                              Icon(
                                                FontAwesomeIcons.gift,
                                                color: green,
                                                size: 11,
                                              ),
                                              Text(
                                                ' ${getCurrencySymbol(context, appConstants: appConstants)}${widget.snapshot[AppConstants.ToDo_Reward_Amount]}, ',
                                                overflow: TextOverflow.clip,
                                                maxLines: 1,
                                                style: heading4TextSmall(
                                                  width,
                                                ),
                                              ),
                                            ],
                                          ),
                                        Text(
                                          '${formatedDateWithMonth(date: widget.snapshot[AppConstants.DO_DUE_DATE].toDate())}, ',
                                          overflow: TextOverflow.clip,
                                          maxLines: 1,
                                          style: textStyleHeading2WithTheme(
                                              context, width * 0.7,
                                              font: 12,
                                              whiteColor: checkDateExpire(
                                                          dateToBeCheck: widget
                                                              .snapshot[
                                                                  AppConstants
                                                                      .DO_DUE_DATE]
                                                              .toDate()) ==
                                                      true
                                                  ? 3
                                                  : 2),
                                        ),
                                        widget.snapshot[AppConstants
                                                    .ToDo_Repeat_Schedule] !=
                                                ''
                                            ? Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 4.0),
                                                child: Icon(
                                                  FontAwesomeIcons.repeat,
                                                  color: grey,
                                                  size: 12,
                                                ),
                                              )
                                            : SizedBox.shrink(),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 4.0),
                                          child: Text(
                                            widget.snapshot[AppConstants
                                                .ToDo_Repeat_Schedule],
                                            overflow: TextOverflow.clip,
                                            maxLines: 1,
                                            style: textStyleHeading2WithTheme(
                                                context, width * 0.7,
                                                font: 12, whiteColor: 2),
                                          ),
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                            ),
                          ),
                          // widget.snapshot[AppConstants.ToDo_Repeat_Schedule] == ''
                          // ?
                          InkWell(
                              onTap: () async {
                                logMethod(
                                    title: 'Seleted Username',
                                    message: '${widget.selectedUserName}');
                                // bool? personalization =
                                //     await getUserKidsPersonalizationsSettings(
                                //         kidId: widget.selectedUserId);
                                // logMethod(
                                //     title: "Personalization Method",
                                //     message: personalization == null
                                //         ? "Null"
                                //         : "$personalization");
                                selectTypeOFToDoBottomSheet(
                                  context: context,
                                  height: height,
                                  width: width,
                                  // linkedAllowance: false,
                                  toDoId: widget.snapshot.id,
                                  selectedUserId: widget.selectedUserId,
                                  selectedDay:
                                      widget.snapshot[AppConstants.DO_Day],
                                  selectedType: widget.snapshot[
                                      AppConstants.ToDo_Repeat_Schedule],
                                  isRepeated: widget.snapshot[AppConstants
                                              .ToDo_Repeat_Schedule] ==
                                          ''
                                      ? false
                                      : true,
                                  date: widget
                                      .snapshot[AppConstants.DO_DUE_DATE]
                                      .toDate(),
                                  // isRepeated: widget.snapshot[AppConstants.DO_DUE_DATE]
                                  isRewarded: widget
                                      .snapshot[AppConstants.ToDo_WithReward],
                                  rewardAmount: widget.snapshot[
                                      AppConstants.ToDo_Reward_Amount],
                                  rewardStatus: widget.snapshot[
                                      AppConstants.ToDo_Reward_Status],
                                );
                              },
                              child: Icon(
                                Icons.info_outline,
                                color: grey.withOpacity(0.4),
                              ))
                          // :
                          // ZakiCicularButton(
                          //     title: widget
                          //         .snapshot[AppConstants.ToDo_Repeat_Schedule],
                          //     width: width * 0.7,
                          //     selected: 3,
                          //     onPressed: () async {
                          //       // bool? personalization =
                          //       //     await getUserKidsPersonalizationsSettings(
                          //       //         kidId: widget.selectedUserId);

                          //       selectTypeOFToDoBottomSheet(
                          //           context: context,
                          //           height: height,
                          //           width: width,
                          //           // linkedAllowance: personalization,
                          //           toDoId: widget.snapshot.id,
                          //           selectedUserId: widget.selectedUserId,
                          //           selectedDay:
                          //               widget.snapshot[AppConstants.DO_Day],
                          //           selectedType: widget.snapshot[
                          //               AppConstants.ToDo_Repeat_Schedule],
                          //           allowanceLinked: widget.snapshot[
                          //               AppConstants.ToDo_WithReward],
                          //           date: widget.snapshot[AppConstants.DO_DUE_DATE].toDate(),
                          //           // isRepeated: widget.snapshot[AppConstants.DO_DUE_DATE]
                          //         isRewarded: widget.snapshot[AppConstants.ToDo_WithReward],
                          //         rewardAmount: widget.snapshot[AppConstants.ToDo_Reward_Amount],
                          //         rewardStatus: widget.snapshot[AppConstants.ToDo_Reward_Status],
                          //               );
                          //     },
                          // )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 30.0),
                    child: Divider(
                      color: grey.withOpacity(0.3),
                    ),
                  )
                ],
              ),
      ),
    );
  }

  void selectTypeOFToDoBottomSheet({
    required BuildContext context,
    double? width,
    double? height,
    String? toDoId,
    // required bool? linkedAllowance,
    required String selectedUserId,
    String? selectedDay,
    String? selectedType,
    bool? repeatSchedule,
    DateTime? date,
    bool? isRewarded,
    int? rewardAmount,
    String? rewardStatus,
    bool? isRepeated,
  }) {
    var weekList = ['Daily', 'Weekly', 'Monthly'];
    final repeatController = TextEditingController();
    String? error = null;
    repeatController.text = rewardAmount == null ? '' : rewardAmount.toString();
    var daysList = [
      'Mon',
      'Tue',
      'Wed',
      'Thu',
      'Fri',
      'Sat',
      'Sun',
    ];

    int status = -1;
    bool? repeat = isRepeated;
    bool? reward = isRewarded ?? false;
    // bool? repeatValue = false;
    int selectedToDoTypeIndex = weekList.indexWhere(
      (element) => element == selectedType,
    );
    int selectedToDoDaysIndex = daysList.indexWhere(
      (element) => element == selectedDay,
    );

    DateTime? setDate = (selectedToDoDaysIndex == 0 ||
            selectedToDoDaysIndex == 2 ||
            selectedToDoTypeIndex != -1)
        ? null
        : date;
    DateTime? weekListDate = setDate == null ? date : null;

    showModalBottomSheet(
        context: context,
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
              padding: MediaQuery.of(context).viewInsets,
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25.0, vertical: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Padding(
                            padding:
                                const EdgeInsets.only(top: 2.0, bottom: 8.0),
                            child: InkWell(
                              onTap: () {},
                              child: Container(
                                width: width * 0.2,
                                height: 5,
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(width * 0.08),
                                    color: grey),
                              ),
                            ),
                          ),
                        ),
                        spacing_medium,
                        Center(
                          child: Text(
                            widget.snapshot[AppConstants.DO_Title],
                            style: heading1TextStyle(context, width),
                          ),
                        ),
                        spacing_medium,
                        Row(
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () async {
                                // if (index == 0 || index == 3 || index == 1) {
                                DateTime? dateTime = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime(2099),
                                    builder: (context, child) {
                                      return Theme(
                                        data: Theme.of(context).copyWith(
                                          colorScheme: ColorScheme.light(
                                            primary: green,
                                          ),
                                        ),
                                        child: child!,
                                      );
                                    },
                                    initialEntryMode:
                                        DatePickerEntryMode.calendar);
                                // ignore: unnecessary_null_comparison
                                if (dateTime != null) {
                                  setState(() {
                                    setDate = dateTime;
                                    repeat = false;
                                  });
                                  // appConstants.updateDateOfBirth(
                                  //     '${dateTime.month} / ${dateTime.year}');
                                  // ApiServices().updateToDoWeek(
                                  //     doType: weekList[index],
                                  //     todoId: toDoId,
                                  //     userId: selectedUserId,
                                  //     date: dateTime);
                                  // // expireDateController.text =
                                  // //     appConstants.dateOfBirth;
                                }
                                return;
                                // }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: setDate == null ? grey : green,
                                    )),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0, vertical: 10),
                                  child: Text(
                                    'Set Date',
                                    style: heading2TextStyle(context, width,
                                        font: 12,
                                        color: setDate == null ? grey : green),
                                  ),
                                ),
                              ),
                            ),
                            setDate == null
                                ? SizedBox.shrink()
                                : TextValue1(
                                    title:
                                        '${formatedDateWithMonth(date: setDate)}')
                          ],
                        ),
                        spacing_small,

                        // linkedAllowance == false
                        //     ? SizedBox.shrink()
                        //     :
                        ListTile(
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          title: Padding(
                            padding: const EdgeInsets.only(left: 3.0),
                            child: TextValue2(
                              title: "Repeat?",
                            ),
                          ),
                          // subtitle: TextValue3(
                          //   title:
                          //       'If You Check this box this to do will be repeat',
                          // ),
                          trailing: Switch.adaptive(
                            value: repeat!,
                            activeColor: primaryButtonColor,
                            onChanged: (value) async {
                              setState(() {
                                repeat = !repeat!;
                                selectedToDoTypeIndex = -1;
                                weekListDate = null;
                                // ApiServices().updateToDoLinkAllowance(
                                //   allowanceLinked: repeat,
                                //   todoId: toDoId,
                                //   userId: selectedUserId,
                                // );
                              });
                              // }
                            },
                          ),
                        ),

                        if (repeat!)
                          Container(
                            // color: lightGreen,
                            height: height! * 0.07,
                            child: ListView.builder(
                              itemCount: weekList.length,
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (BuildContext context, int index) {
                                return InkWell(
                                  onTap: () async {
                                    setState(() {
                                      selectedToDoTypeIndex = index;
                                    });
                                    if (index == 0 || index == 2) {
                                      DateTime? dateTime = await showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime.now(),
                                          lastDate: DateTime(2099),
                                          builder: (context, child) {
                                            return Theme(
                                              data: Theme.of(context).copyWith(
                                                colorScheme: ColorScheme.light(
                                                  primary: green,
                                                ),
                                              ),
                                              child: child!,
                                            );
                                          },
                                          initialEntryMode:
                                              DatePickerEntryMode.calendar);
                                      // ignore: unnecessary_null_comparison
                                      if (dateTime != null) {
                                        weekListDate = dateTime;
                                        setState(() {
                                          setDate = null;
                                        });
                                        // appConstants.updateDateOfBirth(
                                        //     '${dateTime.month} / ${dateTime.year}');
                                        // ApiServices().updateToDoWeek(
                                        //     doType: weekList[index],
                                        //     todoId: toDoId,
                                        //     userId: selectedUserId,
                                        //     date: dateTime);
                                        // expireDateController.text =
                                        //     appConstants.dateOfBirth;
                                      }
                                      return;
                                    }
                                    // ApiServices().updateToDoWeek(
                                    //     doType: weekList[index],
                                    //     todoId: toDoId,
                                    //     userId: selectedUserId);
                                  },
                                  child: Center(
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(right: 8.0),
                                      child: Container(
                                          decoration: BoxDecoration(
                                              // color: selectedToDoTypeIndex == index
                                              //     ? green
                                              //     : transparent,
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              border: Border.all(
                                                color: selectedToDoTypeIndex ==
                                                        index
                                                    ? green
                                                    : grey,
                                              )),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 18, vertical: 10),
                                            child: Text(
                                              '${weekList[index]}',
                                              style: heading2TextStyle(
                                                  context, width * 0.75,
                                                  font: 12,
                                                  color:
                                                      selectedToDoTypeIndex ==
                                                              index
                                                          ? green
                                                          : grey),
                                            ),
                                          )),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        if (repeat == true)
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Divider(color: lightGrey.withOpacity(0.4)),
                          ),
                        (weekListDate == null ||
                                selectedToDoTypeIndex == 1 ||
                                repeat == false)
                            ? SizedBox.shrink()
                            : Center(
                                child: TextValue1(
                                    title:
                                        '${formatedDateWithMonth(date: weekListDate)}')),
                        !(selectedToDoTypeIndex == 1 && repeat == true)
                            ? SizedBox.shrink()
                            : Column(
                                children: [
                                  SizedBox(
                                    height: height! * 0.05,
                                    child: ListView.builder(
                                      itemCount: daysList.length,
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return InkWell(
                                          onTap: () async {
                                            DateTime date = DateTime.now();
                                            //
                                            logMethod(
                                                title: 'Days of week',
                                                message:
                                                    'Days Index: $index and current day index ${date.weekday}');

                                            setState(() {
                                              selectedToDoDaysIndex = index;
                                              setDate = null;
                                              weekListDate =
                                                  getNextOccurrenceOfWeekday(
                                                      daysList[index]);
                                            });
                                            logMethod(
                                                title: 'Days of week',
                                                message:
                                                    'Weekly Date: ${weekListDate}');
                                            // Navigator.pop(context);
                                            // return;
                                            // ApiServices().updateToDoDay(
                                            //     doDay: daysList[index],
                                            //     todoId: toDoId,
                                            //     userId: selectedUserId);
                                          },
                                          child: Center(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 0),
                                              child: Text(
                                                '${daysList[index]}',
                                                style: heading2TextStyle(
                                                  context,
                                                  width * 0.75,
                                                  font: 12,
                                                  color:
                                                      selectedToDoDaysIndex ==
                                                              index
                                                          ? green
                                                          : darkGrey,
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                        // ZakiPrimaryButton(),

                        // spacing_medium,
                        //
                        if (widget.snapshot[AppConstants.ToDo_WithReward] ==
                                true ||
                            appConstants.userModel.usaUserType ==
                                    AppConstants.USER_TYPE_PARENT &&
                                (selectedUserId !=
                                        appConstants.userRegisteredId &&
                                    widget.snapshot[
                                            AppConstants.ToDo_WithReward] !=
                                        true))
                          Column(
                            children: [
                              spacing_small,
                              ListTile(
                                dense: true,
                                contentPadding: EdgeInsets.zero,
                                title: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    TextValue2(
                                      title: "Reward",
                                    ),
                                    const SizedBox(width: 2),
                                    Icon(
                                      FontAwesomeIcons.gift,
                                      color: green,
                                      size: 14,
                                    ),
                                    const SizedBox(width: 5),
                                    if (reward!)
                                      Expanded(
                                        flex: 3,
                                        child: TextFormField(
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          validator: reward != true
                                              ? null
                                              : (String? amount) {
                                                  if (amount == null ||
                                                      amount.isEmpty) {
                                                    return 'Please enter some text';
                                                  }
                                                  return null;
                                                },
                                          onFieldSubmitted:
                                              (String amount) async {
                                            ///////Checkbalance first in to Spend Wallet
                                            bool? hasBalance =
                                                await ApiServices()
                                                    .checkWalletHasAmount(
                                                        amount: double.parse(
                                                            repeatController
                                                                .text
                                                                .trim()),
                                                        userId: appConstants
                                                            .userRegisteredId,
                                                        fromWalletName:
                                                            AppConstants
                                                                .Spend_Wallet);
                                            if (hasBalance == true) {
                                              // progressDialog.dismiss();
                                              setState(() {
                                                error = 'Not enough money';
                                              });
                                              //  setState(() {
                                              //     loading = false;
                                              //   });
                                              showNotification(
                                                  error: 1,
                                                  icon: Icons.error,
                                                  message: NotificationText
                                                      .ADDED_SUCCESSFULLY);
                                              return;
                                            }
                                          },
                                          style: heading2TextStyle(
                                              context, width,
                                              color: green),
                                          controller: repeatController,
                                          onChanged: (String value) {
                                            setState(() {
                                              error = null;
                                            });
                                          },
                                          // obscureText: appConstants.passwordVissibleRegistration,
                                          keyboardType: TextInputType.number,
                                          textAlign: TextAlign.left,
                                          readOnly: (appConstants.userModel
                                                          .usaUserType ==
                                                      AppConstants
                                                          .USER_TYPE_KID ||
                                                  appConstants.userModel
                                                          .usaUserType ==
                                                      AppConstants
                                                          .USER_TYPE_ADULT)
                                              ? true
                                              : false,
                                          decoration: InputDecoration(
                                            isDense: true,
                                            contentPadding: EdgeInsets.zero,
                                            errorText:
                                                error == null ? null : error,
                                            // contentPadding: EdgeInsets.symmetric(vertical: 20),
                                            prefixIconConstraints:
                                                 BoxConstraints(
                                                    minWidth: 0, minHeight: 0),
                                            prefixIcon: Text(
                                              "${getCurrencySymbol(context, appConstants: appConstants)}",
                                              style: heading4TextSmall(width,
                                                  color: green),
                                            ),
                                          ),
                                        ),
                                      ),
                                    Expanded(flex: 7, child: SizedBox())
                                  ],
                                ),
                                // subtitle: TextValue3(
                                //   title:
                                //       'If You Check this box this to do will be repeat',
                                // ),
                                trailing: appConstants.userModel.usaUserType !=
                                        AppConstants.USER_TYPE_PARENT
                                    ? const SizedBox.shrink()
                                    : Switch.adaptive(
                                        value: reward!,
                                        activeColor: primaryButtonColor,
                                        // trackColor: grey,
                                        onChanged: (value) async {
                                          // checkUserSubscriptionValue(appConstants, context, subScriptionValue: widget.selectedUserSubscriptionValue);
                                          // logMethod(title: 'selectedUserSubscriptionValue', message: widget.selectedUserSubscriptionValue.toString());
                                          appConstants
                                              .updateCurrentUserIdForBottomSheet(
                                                  widget.selectedUserId);
                                          bool screenNotOpen =
                                              await checkUserSubscriptionValue(
                                                  appConstants, context,
                                                  subScriptionValue: widget
                                                      .selectedUserSubscriptionValue);
                                          if (screenNotOpen == false) {
                                            setState(() {
                                              reward = !reward!;
                                              // ApiServices().updateToDoLinkAllowance(
                                              //   allowanceLinked: repeat,
                                              //   todoId: toDoId,
                                              //   userId: selectedUserId,
                                              // );
                                            });
                                          }
                                        },
                                      ),
                              ),
                            ],
                          ),
                          ///// Status Deny
                        (appConstants.userModel.usaUserType ==
                                    AppConstants.USER_TYPE_PARENT &&
                                rewardStatus == AppConstants.Active)
                            ? const SizedBox.shrink()
                            : (rewardStatus != null &&
                                    reward == true &&
                                    rewardStatus != '')
                                ? 
                                ListTile(
                                    dense: true,
                                    contentPadding: EdgeInsets.zero,
                                    title: TextValue2(
                                      title: "Status:",
                                    ),
                                    trailing: rewardStatus ==
                                                AppConstants
                                                    .PendingParentApproval &&
                                            appConstants
                                                    .userModel.usaUserType ==
                                                AppConstants.USER_TYPE_PARENT
                                        ? Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    status = 1;
                                                  });
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: grey),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12)),
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 12.0,
                                                        vertical: 8),
                                                    child: Text('Deny',
                                                        style:
                                                            heading2TextStyle(
                                                                context, width,
                                                                color:
                                                                    status == 1
                                                                        ? green
                                                                        : black,
                                                                font: 12)),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    status = 2;
                                                  });
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: grey),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12)),
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 12.0,
                                                        vertical: 8),
                                                    child: Text('Approve',
                                                        style:
                                                            heading2TextStyle(
                                                                context, width,
                                                                color:
                                                                    status == 2
                                                                        ? green
                                                                        : black,
                                                                font: 12)),
                                                  ),
                                                ),
                                              )
                                            ],
                                          )
                                        : rewardStatus ==
                                                    AppConstants
                                                        .PendingParentApproval &&
                                                appConstants.userModel
                                                        .usaUserType !=
                                                    AppConstants
                                                        .USER_TYPE_PARENT
                                            ? InkWell(
                                                onTap: () {
                                                  // setState(() {
                                                  //   if(status==-1){
                                                  //     status = 1;
                                                  //   }
                                                  //   else{
                                                  //     status = -1;
                                                  //   }

                                                  //       });
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: orange),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12)),
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 12.0,
                                                        vertical: 8),
                                                    child: Text(
                                                        'Pending Parent Approval',
                                                        style:
                                                            heading2TextStyle(
                                                                context, width,
                                                                color: orange,
                                                                font: 12)),
                                                  ),
                                                ),
                                              )
                                            : rewardStatus ==
                                                        AppConstants.Active &&
                                                    appConstants.userModel
                                                            .usaUserType !=
                                                        AppConstants
                                                            .USER_TYPE_PARENT
                                                ? InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        if (status == -1) {
                                                          status = 1;
                                                        } else {
                                                          status = -1;
                                                        }
                                                      });
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              color: status == 1
                                                                  ? green
                                                                  : grey),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      12)),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal:
                                                                    12.0,
                                                                vertical: 8),
                                                        child: Text(
                                                            '   I\'m Done   ',
                                                            style: heading2TextStyle(
                                                                context, width,
                                                                color:
                                                                    status == 1
                                                                        ? green
                                                                        : black,
                                                                font: 12)),
                                                      ),
                                                    ),
                                                  )
                                                : const SizedBox.shrink(),
                                  )
                                : const SizedBox.shrink(),
                        // if(rewardStatus !=null && rewardStatus == AppConstants.Active && appConstants.userModel.usaUserType==AppConstants.USER_TYPE_KID && reward==true)
                        spacing_small,
                        if (rewardStatus != AppConstants.Completed)
                          ZakiPrimaryButton(
                            title: 'Confirm',
                            width: width,
                            onPressed: () async {
                              ApiServices services = ApiServices();
                              // selectedToDoDaysIndex
                              logMethod(
                                  title: 'Confirm Button Clicked ->>>>>',
                                  message:
                                      'SetDate: $setDate - Repeat: $repeat -Monthly $selectedToDoTypeIndex - Daily$selectedToDoDaysIndex - Reward: $reward - Reward Value: ${repeatController.text.trim()} - ');
                              // return;
                              // ignore: unused_local_variable
                              final isValided =
                                  formKey.currentState?.validate();
                              // if (isValided != true && reward!=true) {
                              //   return;
                              // }
                              if (reward == true &&
                                  appConstants.userModel.usaUserType ==
                                      AppConstants.USER_TYPE_PARENT) {
                                ApiServices().getUserTokenAndSendNotification(
                                    userId: widget.selectedUserId,
                                    title:
                                        '${appConstants.userModel.usaUserName} ${NotificationText.GOAL_PARENT_ADDED_TO_TITLE}',
                                    subTitle:
                                        '${NotificationText.GOAL_PARENT_ADDED_TO_SUB_TITLE}');
                              }
                              ////Kids send notification to dad
                              if (status == 1 &&
                                  appConstants.userModel.usaUserType ==
                                      AppConstants.USER_TYPE_KID) {
                                ApiServices().getUserTokenAndSendNotification(
                                    userId:
                                        appConstants.userModel.userFamilyId,
                                    title:
                                        '${appConstants.userModel.usaUserName} ${NotificationText.GOAL_KID_COMPLTED_REWARD_TODO_TITLE}',
                                    subTitle:
                                        '${appConstants.userModel.usaUserName} ${NotificationText.GOAL_KID_COMPLTED_REWARD_TODO_SUB_TITLE} ${repeatController.text.trim()}');
                              }

                              // if (widget.snapshot[AppConstants.DO_parentId] != '') {
                              //     ApiServices().getUserTokenAndSendNotification(
                              //         userId: widget.snapshot[AppConstants.DO_parentId],
                              //         title:'${appConstants.userModel.usaUserName} ${NotificationText.GOAL_KID_COMPLTED_REWARD_TODO_TITLE}',
                              //       subTitle:'${appConstants.userModel.usaUserName} ${NotificationText.GOAL_KID_COMPLTED_REWARD_TODO_SUB_TITLE} ${repeatController.text.trim()}');

                              //     ApiServices().updateKidToDoStatus(
                              //         toDoKidStatus: "Kid Completed",
                              //         todoId: widget.snapshot.id,
                              //         userId: widget.selectedUserId
                              //     );
                              //     // return;
                              //   }

                              /////////////////////////////
                              // if ((appConstants.userModel.usaUserType !=
                              //         "Kid")) {
                              //       // setState(() {
                              //       //   color = green;
                              //       // });
                              //       Future.delayed(Duration(seconds: 3), () {
                              //         DateTime nextDate = calculateNextDate(widget.snapshot[AppConstants.DO_CreatedAt].toDate(), widget.snapshot[AppConstants.ToDo_Repeat_Schedule]);
                              //         ApiServices().updateToDoStatus(
                              //             toDoStatus: "Completed",
                              //             todoId: widget.snapshot.id,
                              //             userId: widget.selectedUserId,
                              //             nextSechduleDateTime: nextDate
                              //             );
                              //         ApiServices().toDoCompltedTask(userId: widget.selectedUserId, dueDate: DateTime.now(), toDoStatus: 'Completed', todoId: widget.snapshot.id);
                              //     //     setState(() {
                              //     //   color = grey.withOpacity(0.4);
                              //     // });
                              //       });
                              //         // return;
                              //     }
                              //     //////////////If This todo is linked with Allowance then it should be makred as completed by kid
                              //     if (widget.snapshot[
                              //             AppConstants.DO_parentId] !=
                              //         '') {
                              //           ApiServices().getUserTokenAndSendNotification(
                              //                 userId: widget.snapshot[AppConstants.DO_parentId],
                              //                 title:'${appConstants.userModel.usaUserName} ${NotificationText.GOAL_KID_COMPLTED_REWARD_TODO_TITLE}',
                              //               subTitle:'${appConstants.userModel.usaUserName} ${NotificationText.GOAL_KID_COMPLTED_REWARD_TODO_SUB_TITLE} ${repeatController.text.trim()}'
                              //               );
                              //       ApiServices().updateKidToDoStatus(
                              //           toDoKidStatus: "Kid Completed",
                              //           todoId: widget.snapshot.id,
                              //           userId: widget.selectedUserId);
                              //       // return;
                              //     }
                              //     // setState(() {
                              //     //   color = green;
                              //     // });
                              //     Future.delayed(Duration(seconds: 3), () {
                              //       logMethod(title: 'Selected user and todo', message: '${widget.snapshot.id} and ${appConstants.userRegisteredId}');
                              //       DateTime nextDate = calculateNextDate(widget.snapshot[AppConstants.DO_CreatedAt].toDate(), widget.snapshot[AppConstants.ToDo_Repeat_Schedule]);
                              //       ApiServices().updateToDoStatus(
                              //           toDoStatus: "Completed",
                              //           todoId: widget.snapshot.id,
                              //           userId: widget.selectedUserId,
                              //           nextSechduleDateTime: nextDate
                              //           );
                              //       // ApiServices().toDoCompltedTask(userId: widget.selectedUserId, dueDate: DateTime.now(), toDoStatus: 'Completed', todoId: widget.snapshot.id);
                              //     //   setState(() {
                              //     //   color = grey.withOpacity(0.4);
                              //     // });
                              //     });

                              ////////////////////////////////
                              ///widget.snapshot[AppConstants.DO_Kid_Status] =="Kid Completed" 
                              services.updateToDo(
                                  userId: widget.selectedUserId,
                                  todoId: widget.snapshot.id,
                                  dueDate: setDate ??
                                      weekListDate ??
                                      widget.snapshot[AppConstants.DO_DUE_DATE]
                                          .toDate(),
                                  toDoRewardAmount: reward == false
                                      ? 0
                                      : int.parse(repeatController.text.trim()),
                                  toDoRewardStatus:
                                      // if parent then we need to place a check on it
                                      (appConstants.userModel.usaUserType !=
                                                  AppConstants
                                                      .USER_TYPE_PARENT &&
                                              widget.snapshot[AppConstants
                                                      .ToDo_WithReward] ==
                                                  true)
                                          ? AppConstants.PendingParentApproval
                                          : (status == -1 ||
                                                  status == 1 ||
                                                  reward == false)
                                              ? AppConstants.Active
                                              : AppConstants.Completed,
                                  doStatus: (appConstants.userModel.usaUserType == AppConstants.USER_TYPE_PARENT 
                                  &&
                                              widget.snapshot[AppConstants.ToDo_WithReward] ==
                                                  true
                                                  ) ? 'Completed' :  widget.snapshot[AppConstants.DO_Status],
                                  doKidStatus: widget.snapshot[AppConstants.ToDo_WithReward]==true ? "Kid Completed":'',
                                  toDoWithReward: reward,
                                  doType: (selectedToDoTypeIndex == -1 ||
                                          repeat == false)
                                      ? ''
                                      : weekList[selectedToDoTypeIndex],
                                  doDay: (selectedToDoDaysIndex == -1 ||
                                          repeat == false)
                                      ? ''
                                      : daysList[selectedToDoDaysIndex]);

                              //////// This will change the To Do Status like
                              if (status == -1 ||
                                  status == 1 ||
                                  reward == false) {
                                Navigator.pop(context);
                                return;
                              }
                              if (appConstants.userModel.usaUserType !=
                                  AppConstants.USER_TYPE_PARENT) {
                                // if (widget.snapshot[AppConstants.DO_parentId] != '') {
                                // ApiServices().getUserTokenAndSendNotification(
                                //     userId: widget.snapshot[AppConstants.DO_parentId],
                                //     title:'${appConstants.userModel.usaUserName} ${NotificationText.GOAL_KID_COMPLTED_REWARD_TODO_TITLE}',
                                //   subTitle:'${appConstants.userModel.usaUserName} ${NotificationText.GOAL_KID_COMPLTED_REWARD_TODO_SUB_TITLE} ${repeatController.text.trim()}');
                                ApiServices()
                                          .deletePendingParentApproavlAdding(
                                              toDoId: widget.snapshot.id);
                                ApiServices().updateKidToDoStatus(
                                    toDoKidStatus: "Completed",
                                    todoId: widget.snapshot.id,
                                    userId: widget.selectedUserId,
                                    toDoWithReward: (appConstants.userModel.usaUserType !=
                                                  AppConstants
                                                      .USER_TYPE_PARENT &&
                                              widget.snapshot[AppConstants
                                                      .ToDo_WithReward] ==
                                                  true)
                                          ? AppConstants.PendingParentApproval
                                          :  AppConstants.Active
                                    );
                                return;
                                // }
                              }
                              if ((appConstants.userModel.usaUserType !=
                                  "Kid")) {
                                /////////Marqata Logic for checking Balance and pay user
                                CreaditCardApi creaditCardApi =
                                    CreaditCardApi();
                                BalanceModel? balanceModel =
                                    await creaditCardApi.checkBalance(
                                        userToken:
                                            appConstants.userModel.userTokenId);
                                if (balanceModel!.gpa.availableBalance <
                                    int.parse(repeatController.text
                                        .trim()
                                        .toString())) {
                                  setState(() {
                                    error = NotificationText.ADDED_SUCCESSFULLY;
                                  });
                                  showNotification(
                                      error: 1,
                                      icon: Icons.error,
                                      message:
                                          NotificationText.ADDED_SUCCESSFULLY);
                                  return;
                                } else {
                                  Position userLocation =await UserLocation().determinePosition();
                                  await creaditCardApi.moveMoney(
                                      amount: repeatController.text.trim(),
                                      name: appConstants.userModel.usaFirstName,
                                      senderUserToken:
                                          appConstants.userModel.userTokenId,
                                      receiverUserToken:
                                          widget.selectedUserToken,
                                      // memo: createMemo(
                                      //   fromWallet: AppConstants.Spend_Wallet,
                                      //   toWallet: AppConstants.Spend_Wallet,
                                      //   // transactionMethod:AppConstants.Transaction_Method_Received,
                                      //   // tagItName: '',
                                      //   // tagItId: "",
                                      //   // goalId: '',
                                      //   // transactionType: AppConstants.TAG_IT_Transaction_TYPE_TODO_REWARD
                                      // ),
                                      tags: createMemo(
                                        fromWallet: AppConstants.Spend_Wallet,
                                        toWallet: AppConstants.Spend_Wallet,
                                        transactionMethod: AppConstants
                                            .Transaction_Method_Received,
                                        tagItName: '',
                                        tagItId: "",
                                        goalId: '',
                                        transactionType: AppConstants
                                            .TAG_IT_Transaction_TYPE_TODO_REWARD,
                                        receiverId: widget.selectedUserId,
                                        senderId: appConstants.userRegisteredId,
                                        transactionId: '',
                                        latLng: '${userLocation.latitude},${userLocation.longitude}'
                                        // transactionId: transaction
                                      ));
                                  // showNotification(
                                  //       error: 0,
                                  //       icon: Icons.balance,
                                  //       message:
                                  //           'You have enough funds');
                                }
                                ////////// End marqata Logic for checking Balance and pay user
                                DateTime nextDate = calculateNextDate(
                                    widget.snapshot[AppConstants.DO_DUE_DATE]
                                        .toDate(),
                                    widget.snapshot[
                                        AppConstants.ToDo_Repeat_Schedule]);
                                services.updateToDoStatus(
                                    toDoStatus: "Completed",
                                    todoId: widget.snapshot.id,
                                    userId: widget.selectedUserId,
                                    nextSechduleDateTime: nextDate);
                                ApiServices().toDoCompltedTask(
                                    userId: widget.selectedUserId,
                                    dueDate: DateTime.now(),
                                    toDoStatus: 'Completed',
                                    todoId: widget.snapshot.id);
                                bool? hasBalance = await services.checkBalance(
                                    amount: double.parse(
                                        repeatController.text.trim()),
                                    selectedWalletName:
                                        AppConstants.Spend_Wallet,
                                    userId: appConstants.userRegisteredId);
                                if (hasBalance == false) {
                                  showNotification(
                                      error: 1,
                                      icon: Icons.error,
                                      message:
                                          NotificationText.ADDED_SUCCESSFULLY);
                                  Navigator.pop(context);
                                  return;
                                } else {
                                  services.addMoneyToSelectedMainWallet(
                                      amountSend: repeatController.text.trim(),
                                      receivedUserId: widget.selectedUserId,
                                      senderId: appConstants.userRegisteredId);

                                  ///Parent payed reward
                                  ApiServices().getUserTokenAndSendNotification(
                                      userId: widget.selectedUserId,
                                      title:
                                          '${getCurrencySymbol(context, appConstants: appConstants)}${widget.snapshot[AppConstants.ToDo_Reward_Amount]} ! ${NotificationText.GOAL_PARENT_PAYED_REWARD_TODO_TITLE}',
                                      subTitle:
                                          '${NotificationText.GOAL_PARENT_PAYED_REWARD_TODO_SUB_TITLE}');

                                  //Transaction added on both sides, Sender and reeiver side as well
                                  services.addTransaction(
                                      transactionMethod: AppConstants
                                          .Transaction_Method_Payment,
                                      tagItName: '',
                                      tagItId: null,
                                      selectedKidName:
                                          appConstants.userModel.usaFirstName,
                                      accountHolderName:
                                          widget.selectedUserName,
                                      amount: rewardAmount.toString(),
                                      currentUserId:
                                          appConstants.userRegisteredId,
                                      receiverId: selectedUserId,
                                      requestType: AppConstants
                                          .TAG_IT_Transaction_TYPE_TODO_REWARD,
                                      fromWallet: AppConstants.Spend_Wallet,
                                      toWallet: AppConstants.Spend_Wallet,
                                      senderId: appConstants.userRegisteredId);

                                  ///Receiver side
                                  services.addTransaction(
                                      transactionMethod: AppConstants
                                          .Transaction_Method_Received,
                                      tagItName: '',
                                      tagItId: null,
                                      selectedKidName: widget.selectedUserName,
                                      accountHolderName:
                                          appConstants.userModel.usaFirstName,
                                      amount: rewardAmount.toString(),
                                      currentUserId: selectedUserId,
                                      receiverId: selectedUserId,
                                      requestType: AppConstants
                                          .TAG_IT_Transaction_TYPE_TODO_REWARD,
                                      fromWallet: AppConstants.Spend_Wallet,
                                      toWallet: AppConstants.Spend_Wallet,
                                      senderId: appConstants.userRegisteredId);
                                  Navigator.pop(context);
                                  return;
                                }
                              } else {
                                //////////////If This todo is linked with Allowance then it should be makred as completed by kid
                                // if (widget.snapshot[AppConstants.DO_parentId] !='') {
                                //   services.updateKidToDoStatus(
                                //       toDoKidStatus: "Kid Completed",
                                //       todoId: widget.snapshot.id,
                                //       userId: widget.selectedUserId);
                                //   return;
                                // }
                                // services.updateToDoStatus(
                                //     toDoStatus: "Completed",
                                //     todoId: widget.snapshot.id,
                                //     userId: widget.selectedUserId);
                              }
                              ////////End This will change the To Do Status like

                              // DateTime? dateTime = await showDatePicker(
                              //     context: context,
                              //     initialDate: DateTime.now(),
                              //     firstDate: DateTime.now(),
                              //     lastDate: DateTime(2099),
                              //     initialEntryMode: DatePickerEntryMode.calendar);
                              // if (dateTime != null) {
                              //   ApiServices().updateRepeatTime(
                              //       userId: widget.selectedUserId,
                              //       todoId: widget.snapshot.id,
                              //       repeatDateTime: dateTime);
                              // }
                            },
                          ),
                        spacing_small,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          // crossAxisAlignment: Cr,
                          children: [
                            Expanded(
                              flex: 5,
                              child: CustomTextButton(
                                title: 'Delete',
                                width: width,
                                onPressed: () {
                                  if ((appConstants.userModel.usaUserType ==
                                          "Kid") &&
                                      (widget.snapshot[
                                              AppConstants.DO_parentId] !=
                                          '')) {
                                    ApiServices().updateDeletedByStatus(
                                        todoId: widget.snapshot.id,
                                        userId: widget.selectedUserId,
                                        deletedBy: "Kid");
                                    return;
                                  }
                                  ApiServices().deleteToDo(
                                      todoId: widget.snapshot.id,
                                      userId: widget.selectedUserId);
                                  showNotification(
                                      error: 0,
                                      icon: Icons.delete_outline,
                                      message: NotificationText.DELETED);
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                            Expanded(
                              flex: 6,
                              child: SizedBox(),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }

  Future<bool?>? getUserKidsPersonalizationsSettings({String? kidId}) async {
    Map<String, dynamic>? kidData =
        await ApiServices().getKidsPersonalizeExperience(kidId!);
    if (kidData != null) {
      return kidData[AppConstants.KidP_disableTo_Do];
      // kidData[]
    } else {
      return null;
    }
  }

  TextFormField toDoTextField(
      BuildContext context, double width, CheckInternet internet) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      textInputAction: TextInputAction.done,
      readOnly: internet.status == AppConstants.INTERNET_STATUS_NOT_CONNECTED
          ? true
          : false,
      autofocus: true,
      maxLength: 50,
      onFieldSubmitted: (String value) {
        print("Done button is clicked with text: :>>>> $value");
        if (toDoTextContoller.text.length == 0 ||
            widget.snapshot[AppConstants.ToDo_Repeat_Schedule] ==
                toDoTextContoller.text.trim()) {
          setState(() {
            isTextFieldClicked = false;
          });
          return;
        }
        ApiServices().updateToDoTitle(
            userId: widget.selectedUserId,
            todoId: widget.snapshot.id,
            title: toDoTextContoller.text.trim());
        toDoTextContoller.clear();
        setState(() {
          isTextFieldClicked = false;
        });
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
      style: heading2TextStyle(context, width, color: darkGrey),
      controller: toDoTextContoller,
      obscureText: false,
      keyboardType: TextInputType.emailAddress,
      maxLines: 1,
      // onChanged: (String? value) {
      //   setState(() {
      //     emailError = '';
      //   });
      //   print('value is: $emailError');
      // },
      decoration: InputDecoration(
        enabledBorder: InputBorder.none,
        counterText: '',
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
