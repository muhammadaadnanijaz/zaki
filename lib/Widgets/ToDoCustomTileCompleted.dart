import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zaki/Constants/NotificationTitle.dart';
import 'package:zaki/Widgets/TextHeader.dart';

import '../Constants/AppConstants.dart';
import '../Constants/HelperFunctions.dart';
import '../Constants/Spacing.dart';
import '../Constants/Styles.dart';
import '../Services/api.dart';
import 'CustomTextButon.dart';

// ignore: must_be_immutable
class ToDoCustomTileCompleted extends StatefulWidget {
  DocumentSnapshot<Object?> snapshot;
  String selectedUserId;
  DateTime? completedDateTime;
  String? completedToDoId;
  ToDoCustomTileCompleted(this.snapshot, this.selectedUserId,
      {this.completedDateTime, this.completedToDoId});

  @override
  State<ToDoCustomTileCompleted> createState() =>
      _ToDoCustomTileCompletedState();
}

class _ToDoCustomTileCompletedState extends State<ToDoCustomTileCompleted> {
  // Color color = grey.withOpacity(0.4);
  bool isClicked = false;
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return
        // widget.snapshot==null?
        // SizedBox.shrink():
        Container(
      child: ListTile(
        dense: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        // minVerticalPadding: 0,
        leading: InkWell(
            onTap: () {
              setState(() {
                isClicked = true;
              });
              Future.delayed(Duration(seconds: 3), () {
                setState(() {
                  isClicked = false;
                });
                ApiServices().updateToDoStatus(
                    toDoStatus: "",
                    todoId: widget.snapshot.id,
                    userId: widget.selectedUserId,
                    nextSechduleDateTime:
                        widget.snapshot[AppConstants.DO_CreatedAt].toDate());
                ApiServices().deletedTodoFromComplted(
                  todoId: widget.completedToDoId,
                  selectedUserId: widget.selectedUserId,
                );
              });

              // DateTime nextDate = calculateNextDate(widget.snapshot[AppConstants.DO_CreatedAt].toDate(), widget.snapshot[AppConstants.ToDo_Repeat_Schedule]);
              //  && (widget.snapshot[AppConstants.DO_Allowance_Linked] ==true)
              //  if((appConstants.userModel.usaUserType!="Kid")){
              return;
              // }
              // ApiServices().updateToDoStatus(
              //     toDoStatus: widget.snapshot[AppConstants.DO_Allowance_Linked]==true ?
              //         // widget.snapshot[AppConstants.DO_Status] == ""
              //              "Kid Completed"
              //             : "Completed",
              //     todoId: widget.snapshot.id,
              //     userId: widget.selectedUserId);
            },
            child: Icon(
              Icons.circle_outlined,
              color: isClicked ? green : grey,
            )),
        horizontalTitleGap: 0,
        visualDensity: VisualDensity.compact,
        title: Text(
          widget.snapshot[AppConstants.DO_Title],
          overflow: TextOverflow.clip,
          maxLines: 1,
          style: heading2TextStyle(context, width, color: darkGrey),
        ),
        subtitle: Text(
          formatedDateWithMonth(date: widget.completedDateTime),
          style: heading4TextSmall(width),
        ),
        trailing: InkWell(
          onTap: () {
            selectTypeOFToDoBottomSheet(
              context: context,
              // height: height,
              width: width,
              // linkedAllowance: false,
              toDoId: widget.snapshot.id,
              selectedUserId: widget.selectedUserId,
              rewardAmount: widget.snapshot[AppConstants.ToDo_Reward_Amount],
            );
          },
          child: Icon(
            Icons.error_outline,
            color: grey,
          ),
        ),
      ),
    );
  }

  void selectTypeOFToDoBottomSheet({
    required BuildContext context,
    double? width,
    // double? height,
    String? toDoId,
    // required bool? linkedAllowance,
    required String selectedUserId,
    int? rewardAmount,
  }) {
    final repeatController = TextEditingController();
    repeatController.text = rewardAmount == null ? '' : rewardAmount.toString();
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
          var appConstants = Provider.of<AppConstants>(bc, listen: true);
          return StatefulBuilder(
            builder: (BuildContext context, setState) => Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25.0, vertical: 8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
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
                      Center(
                        child: Text(
                          'Completed task info',
                          style: textStyleHeading2WithTheme(context, width,
                              whiteColor: 0),
                        ),
                      ),
                      spacing_medium,
                      Row(
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextValue2(title: 'Completed Date:'),
                          TextValue2(
                              title:
                                  '${formatedDateWithMonth(date: widget.snapshot[AppConstants.DO_DUE_DATE].toDate())}')
                        ],
                      ),
                      if (widget.snapshot[AppConstants.ToDo_WithReward] == true)
                        Column(
                          children: [
                            spacing_medium,
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
                                    Icons.card_giftcard,
                                    color: green,
                                    size: 17,
                                  ),
                                  const SizedBox(width: 5),
                                  // if(reward)
                                  Expanded(
                                    flex: 3,
                                    child: TextFormField(
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      validator: null,
                                      style: heading2TextStyle(context, width,
                                          color: green),
                                      controller: repeatController,
                                      // obscureText: appConstants.passwordVissibleRegistration,
                                      keyboardType: TextInputType.number,
                                      textAlign: TextAlign.left,
                                      readOnly: true,
                                      decoration: InputDecoration(
                                        isDense: true,
                                        contentPadding: EdgeInsets.zero,
                                        // contentPadding: EdgeInsets.symmetric(vertical: 20),
                                        prefixIconConstraints:
                                            const BoxConstraints(
                                                minWidth: 0, minHeight: 0),
                                        prefixIcon: Text(
                                          "${getCurrencySymbol(context, appConstants: appConstants)}",
                                          style: heading3TextStyle(width,
                                              color: green),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(flex: 7, child: SizedBox())
                                ],
                              ),
                            ),
                          ],
                        ),
                      spacing_medium,
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
                                ApiServices().deletedTodoFromComplted(
                                  todoId: widget.completedToDoId,
                                  selectedUserId: widget.selectedUserId,
                                );
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
          );
        });
  }
}
