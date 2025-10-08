import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:zaki/Constants/AppConstants.dart';
import 'package:zaki/Constants/Spacing.dart';
import 'package:zaki/Constants/Styles.dart';
import 'package:zaki/Models/NotificationModel.dart';
import 'package:zaki/Services/SqLiteHelper.dart';
import 'package:zaki/Widgets/TextHeader.dart';
import 'package:zaki/Widgets/CustomLoader.dart';
import '../Constants/HelperFunctions.dart';
import '../Widgets/AppBars/AppBar.dart';

// flutter_slidable, sqflite, path_provider, intl, flutter_local_notifications, flutter_native_timezone, flutter_launcher_icons

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    super.initState();
    
  }

  @override
  Widget build(BuildContext context) {
    var appConstants = Provider.of<AppConstants>(context, listen: true);
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
                  appBarTitle: 'Notifications',
                  height: height,
                  width: width),
              Expanded(
                child: FutureBuilder<List<NotificationModel>>(
                    future: DatabaseHelper.instance
                        .getAllNotifications(appConstants: appConstants),
                    builder: (context, snapShot) {
                      if (snapShot.connectionState == ConnectionState.waiting) {
                        return CustomLoader();
                      }
                      if (snapShot.data == null || snapShot.data!.length == 0) {
                        //print('project snapshot data is: ${projectSnap.data}');
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                  imageBaseAddress + 'no_notification.png'),
                              spacing_large,
                              TextHeader1(
                                title: 'Nothing to see right now',
                              )
                            ],
                          ),
                        );
                      }

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: ListView.separated(
                          separatorBuilder: ((context, index) =>
                              const Divider()),
                          itemCount: snapShot.data!.length,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            return Slidable(
        useTextDirection: true,
        // startActionPane: ActionPane(
        //   dismissible: ,
        //   motion: , children: children),
        // dragStartBehavior: Dr,
        // key: UniqueKey(),
        // enabled: widget.fromHomeScreen == true ? false : true,
        // closeOnScroll: true,
        endActionPane: ActionPane(
          motion: ScrollMotion(),
          // dismissible: Icon(Icons.delete, color: red),
          // extentRatio: 10,
          extentRatio: 0.4,
          children: [
                // (appConstants.userModel.userFamilyId ==null || widget.snapshot[AppConstants.DO_parentId] == '')?
                SlidableAction(
                    onPressed: (context) async{
                      await DatabaseHelper.instance
                                              .deleteNotification(
                                                  id: snapShot.data![index].id);
                                          await DatabaseHelper.instance
                                              .getAllNotifications(
                                                  appConstants: appConstants);
                                          DatabaseHelper.instance
                                              .getLengthOfNotificationForBatch(
                                                  appConstants: appConstants);
                                          setState(() {});
                    },
                    backgroundColor: crimsonColor,
                    foregroundColor: white,
                    padding: EdgeInsets.zero,
                    borderRadius: BorderRadius.circular(20),
                    // flex: 8,
                    icon: Icons.delete,
                    // label: 'Delete',
                  ),
            // : const SizedBox.shrink(),
            
          ],
        ),
                              child: 
                                Container(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: ListTile(
                                        dense: true,
                                        enableFeedback: true,
                                        // minLeadingWidth: 20,
                                        horizontalTitleGap: 8,
                                        contentPadding: EdgeInsets.zero,
                                        leading:
                                            Icon(Icons.notifications_on_sharp),
                                        title: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            TextValue2(
                                              title:
                                                  '${snapShot.data![index].notificationTitle}',
                                            ),
                                            TextValue2(
                                              title: timeBetween(
                                                          from: DateTime.now(),
                                                          to: DateTime.parse(
                                                              snapShot
                                                                  .data![index]
                                                                  .notificationTime
                                                                  .toString())) ==
                                                      0
                                                  ? ''
                                                  : '${timeBetween(from: DateTime.now(), to: DateTime.parse(snapShot.data![index].notificationTime.toString()))}',
                                            )
                                          ],
                                        ),
                                        subtitle: TextValue3(
                                          title:
                                              '\n${snapShot.data![index].notificationDescription}',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              
                              
                            );
                          },
                        ),
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
