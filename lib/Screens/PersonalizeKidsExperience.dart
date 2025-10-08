import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:zaki/Constants/HelperFunctions.dart';
// import 'package:zaki/Constants/NotificationTitle.dart';
import 'package:zaki/Constants/Spacing.dart';
import 'package:zaki/Constants/Styles.dart';
import 'package:zaki/Widgets/TextHeader.dart';
import 'package:zaki/Constants/Whitelable.dart';
import '../Constants/AppConstants.dart';
import '../Services/api.dart';
import '../Widgets/AppBars/AppBar.dart';

class PersonalizeKidsExperience extends StatefulWidget {
  const PersonalizeKidsExperience({Key? key}) : super(key: key);

  @override
  _PersonalizeKidsExperienceState createState() =>
      _PersonalizeKidsExperienceState();
}

class _PersonalizeKidsExperienceState extends State<PersonalizeKidsExperience> {
  int selectedIndex = -1;
  Stream<QuerySnapshot>? userKids;
  String selectedKidId = '';

  var kidsOrNOt = [
    'Yes',
    'No',
  ];
  var pendingApprovales = [
    'Yes',
    'No',
  ];
  var kidsToPayFriends = [
    'Yes',
    'No',
  ];
  var kidsToPublish = [
    'Yes',
    'No',
  ];
  var slideToPay = [
    'Yes',
    'No',
  ];
  var lockSaving = [
    'Yes',
    'No',
  ];
  var lockCharity = [
    'Yes',
    'No',
  ];

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 200), () async {
      var appConstants = Provider.of<AppConstants>(context, listen: false);
      bool screenNotOpen =
          await checkUserSubscriptionValue(appConstants, context);
      logMethod(title: 'Data from Pay+', message: screenNotOpen.toString());
      if (screenNotOpen == true) {
        Navigator.pop(context);
      } else {
        userKids = ApiServices().fetchUserKids(
            appConstants.userModel.seeKids == true
                ? appConstants.userModel.userFamilyId!
                : appConstants.userRegisteredId,
            currentUserId: appConstants.userRegisteredId);
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var appConstants = Provider.of<AppConstants>(context, listen: true);
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: getCustomPadding(),
                child: Column(
                  children: [
                    appBarHeader_005(
                        context: context,
                        appBarTitle: 'Parental Controls',
                        height: height,
                        width: width),
                    ListTile(
                      title: TextValue2(
                        title: 'Apply same rules to all?',
                      ),
                      trailing: Switch.adaptive(
                        value: appConstants.haveKid,
                        activeColor: primaryButtonColor,
                        onChanged: (value) async {
                          appConstants.updateHaveKid(value);
                        },
                      ),
                    ),
                    spacing_medium,
                  ],
                ),
              ),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                transitionBuilder: (child, animation) {
                  return SlideTransition(
                    position: animation.drive(Tween(
                      begin: const Offset(1.0, 0.0),
                      end: const Offset(0.0, 0.0),
                    )),
                    child: child,
                  );
                },
                child: appConstants.haveKid == true
                    ? const SizedBox()
                    : userKids == null
                        ? const SizedBox()
                        : Container(
                            color: Color(0XFFF9FFF9),
                            height: height * 0.127,
                            width: width,
                            child: Padding(
                              padding: getCustomPadding(),
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
                                    return const Text("");
                                  }
                                  if (snapshot.data!.size == 0) {
                                    return const Center(child: Text(""));
                                  }
                                  //snapshot.data!.docs[index] ['USA_first_name']
                                  return ListView.builder(
                                    itemCount: snapshot.data!.docs.length,
                                    physics: const BouncingScrollPhysics(),
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      SchedulerBinding.instance
                                          .addPostFrameCallback((_) {
                                        // setState(() {
                                        //   selectedIndex=0;
                                        //   // getUserKidSpendingLimits(parentId: appConstants.userRegisteredId, kidId: snapshot.data!.docs[0].id);
                                        // });
                                        // if (selectedIndex == -1) {
                                        //   setState(() {
                                        //     selectedIndex = 0;
                                        //     // selectedKidId
                                        //     selectedKidId =
                                        //         snapshot.data!.docs[0].id;
                                        //   });
                                        //   getUserKidsPersonalizationsSettings(
                                        //       appConstants,
                                        //       kidId: snapshot.data!.docs[0].id);
                                        // }
                                      });
                                      // print(snapshot.data!.docs[index] ['USA_first_name']);
                                      return ((snapshot.data!.docs[index][
                                                  AppConstants.USER_UserType] !=
                                              AppConstants.USER_TYPE_KID))
                                          ? const SizedBox.shrink()
                                          : InkWell(
                                              onTap: () async {
                                                setState(() {
                                                  selectedIndex = index;
                                                  selectedKidId = snapshot
                                                      .data!.docs[index].id;
                                                });
                                                logMethod(
                                                    title: 'Selected Kid Id',
                                                    message: snapshot
                                                        .data!.docs[index].id);
                                                getUserKidsPersonalizationsSettings(
                                                    appConstants,
                                                    kidId: snapshot
                                                        .data!.docs[index].id);

                                                // });
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 12.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      height: 70,
                                                      width: 70,
                                                      decoration: BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          color: transparent,
                                                          border: Border.all(
                                                              width:
                                                                  selectedIndex ==
                                                                          index
                                                                      ? 2
                                                                      : 0,
                                                              color: selectedIndex ==
                                                                      index
                                                                  ? orange
                                                                  : transparent)),
                                                      child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(0.0),
                                                          child: userImage(
                                                            imageUrl: snapshot
                                                                    .data!
                                                                    .docs[index]
                                                                [AppConstants
                                                                    .USER_Logo],
                                                            userType: snapshot
                                                                    .data!
                                                                    .docs[index]
                                                                [AppConstants
                                                                    .USER_UserType],
                                                            width: width,
                                                            gender: snapshot
                                                                    .data!
                                                                    .docs[index]
                                                                [AppConstants
                                                                    .USER_gender],
                                                          )),
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
                                                                  snapshot.data!.docs[index]
                                                                          [
                                                                          AppConstants
                                                                              .USER_user_name] ==
                                                                      '')
                                                              ? snapshot.data!
                                                                      .docs[index]
                                                                  [AppConstants
                                                                      .USER_first_name]
                                                              : '@ ' +
                                                                  snapshot.data!
                                                                          .docs[index]
                                                                      [AppConstants.USER_user_name],
                                                          overflow:
                                                              TextOverflow.fade,
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
                                            );
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
              ),
              spacing_medium,
              Padding(
                padding: getCustomPadding(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      title: TextValue2(
                        title: 'Can they pay friends?',
                      ),
                      subtitle: TextValue3(
                        title:
                            'Allows them to pay their friends on ZakiPay, not just family members',
                      ),
                      trailing: Switch.adaptive(
                        value: appConstants.kidsToPayFriends,
                        activeColor: primaryButtonColor,
                        onChanged: (value) async {
                          if (selectedKidId == '' &&
                              appConstants.haveKid == false) {
                            showNotification(
                                error: 1,
                                icon: Icons.error_outline,
                                message: NotificationText.NO_USER_SELECTED);
                            return;
                          }
                          appConstants.updatekidsToPayFriends(value);
                          ApiServices services = ApiServices();

                          if (appConstants.haveKid == true) {
                            List<String> idsList = await ApiServices()
                                .fetchUserKidsIds(
                                    appConstants.userRegisteredId);
                            for (var id in idsList) {
                              await services.addUserPersonalization(
                                  userId: id,
                                  kidsToPayFriends:
                                      appConstants.kidsToPayFriends,
                                  kidsToPublish: appConstants.kidsToPublish,
                                  lockCharity: appConstants.lockCharity,
                                  lockSaving: appConstants.lockSaving,
                                  pendingApprovales:
                                      appConstants.pendingApprovales,
                                  slideToPay: appConstants.slideToPay,
                                  parentId: appConstants.userRegisteredId,
                                  disableToDo: appConstants.disableToDo);
                            }
                            showNotification(
                                error: 0,
                                icon: Icons.check,
                                message: NotificationText.ADDED_SUCCESSFULLY);
                            return;
                          }
                          // else if(){
                          //   ApiServices().fetchUserKidsIds(appConstants.userRegisteredId);

                          // }
                          await services.addUserPersonalization(
                              userId: selectedKidId == ''
                                  ? appConstants.userRegisteredId
                                  : selectedKidId,
                              kidsToPayFriends: appConstants.kidsToPayFriends,
                              kidsToPublish: appConstants.kidsToPublish,
                              lockCharity: appConstants.lockCharity,
                              lockSaving: appConstants.lockSaving,
                              pendingApprovales: appConstants.pendingApprovales,
                              slideToPay: appConstants.slideToPay,
                              parentId: appConstants.userRegisteredId,
                              disableToDo: appConstants.disableToDo);
                          showNotification(
                              error: 0,
                              icon: Icons.check,
                              message: NotificationText.ADDED_SUCCESSFULLY);
                        },
                      ),
                    ),
                    spacing_medium,
                    ListTile(
                      title: TextValue2(
                        title: 'Can share activities on Socialize tab?',
                      ),
                      subtitle: TextValue3(
                        title:
                            'Allows them to share their activity not just with immediate family members on ZakiPay, but with friends and/or others on ZakiPay.',
                      ),
                      trailing: Switch.adaptive(
                        value: appConstants.kidsToPublish,
                        activeColor: primaryButtonColor,
                        onChanged: (value) async {
                          if (selectedKidId == '' &&
                              appConstants.haveKid == false) {
                            showNotification(
                                error: 1,
                                icon: Icons.error_outline,
                                message: NotificationText.NO_USER_SELECTED);
                            return;
                          }
                          appConstants.updatekidsToPublish(value);

                          ApiServices services = ApiServices();

                          if (appConstants.haveKid == true) {
                            List<String> idsList = await ApiServices()
                                .fetchUserKidsIds(
                                    appConstants.userRegisteredId);
                            for (var id in idsList) {
                              await services.addUserPersonalization(
                                  userId: id,
                                  kidsToPayFriends:
                                      appConstants.kidsToPayFriends,
                                  kidsToPublish: appConstants.kidsToPublish,
                                  lockCharity: appConstants.lockCharity,
                                  lockSaving: appConstants.lockSaving,
                                  pendingApprovales:
                                      appConstants.pendingApprovales,
                                  slideToPay: appConstants.slideToPay,
                                  parentId: appConstants.userRegisteredId,
                                  disableToDo: appConstants.disableToDo);
                            }
                            showNotification(
                                error: 0,
                                icon: Icons.check,
                                message:
                                    '${NotificationText.ADDED_SUCCESSFULLY} for all kids');
                            return;
                          }
                          // else if(){
                          //   ApiServices().fetchUserKidsIds(appConstants.userRegisteredId);

                          // }
                          await services.addUserPersonalization(
                              userId: selectedKidId == ''
                                  ? appConstants.userRegisteredId
                                  : selectedKidId,
                              kidsToPayFriends: appConstants.kidsToPayFriends,
                              kidsToPublish: appConstants.kidsToPublish,
                              lockCharity: appConstants.lockCharity,
                              lockSaving: appConstants.lockSaving,
                              pendingApprovales: appConstants.pendingApprovales,
                              slideToPay: appConstants.slideToPay,
                              parentId: appConstants.userRegisteredId,
                              disableToDo: appConstants.disableToDo);
                          showNotification(
                              error: 0,
                              icon: Icons.check,
                              message: NotificationText.ADDED_SUCCESSFULLY);
                        },
                      ),
                    ),
                    spacing_medium,
                    ListTile(
                      title: TextValue2(
                        title: 'Add extra step, “Slide to Send” feature?',
                      ),
                      subtitle: TextValue3(
                        title:
                            'After clicking “Send” they will be asked to also “Slide to Send”,  designed to teach the importance of double checking their work, especially with finances.',
                      ),
                      trailing: Switch.adaptive(
                        value: appConstants.slideToPay,
                        activeColor: primaryButtonColor,
                        onChanged: (value) async {
                          if (selectedKidId == '' &&
                              appConstants.haveKid == false) {
                            showNotification(
                                error: 1,
                                icon: Icons.error_outline,
                                message: NotificationText.NO_USER_SELECTED);
                            return;
                          }
                          appConstants.updateslideToPay(value);

                          ApiServices services = ApiServices();

                          if (appConstants.haveKid == true) {
                            List<String> idsList = await ApiServices()
                                .fetchUserKidsIds(
                                    appConstants.userRegisteredId);
                            for (var id in idsList) {
                              await services.addUserPersonalization(
                                  userId: id,
                                  kidsToPayFriends:
                                      appConstants.kidsToPayFriends,
                                  kidsToPublish: appConstants.kidsToPublish,
                                  lockCharity: appConstants.lockCharity,
                                  lockSaving: appConstants.lockSaving,
                                  pendingApprovales:
                                      appConstants.pendingApprovales,
                                  slideToPay: appConstants.slideToPay,
                                  parentId: appConstants.userRegisteredId,
                                  disableToDo: appConstants.disableToDo);
                            }
                            showNotification(
                                error: 0,
                                icon: Icons.check,
                                message:
                                    '${NotificationText.ADDED_SUCCESSFULLY} for all kids');
                            return;
                          }
                          // else if(){
                          //   ApiServices().fetchUserKidsIds(appConstants.userRegisteredId);

                          // }
                          await services.addUserPersonalization(
                              userId: selectedKidId == ''
                                  ? appConstants.userRegisteredId
                                  : selectedKidId,
                              kidsToPayFriends: appConstants.kidsToPayFriends,
                              kidsToPublish: appConstants.kidsToPublish,
                              lockCharity: appConstants.lockCharity,
                              lockSaving: appConstants.lockSaving,
                              pendingApprovales: appConstants.pendingApprovales,
                              slideToPay: appConstants.slideToPay,
                              parentId: appConstants.userRegisteredId,
                              disableToDo: appConstants.disableToDo);
                          showNotification(
                              error: 0,
                              icon: Icons.check,
                              message: NotificationText.ADDED_SUCCESSFULLY);
                        },
                      ),
                    ),
                    spacing_medium,
                    ListTile(
                      title: TextValue2(
                        title: 'Lock Savings Wallet?',
                      ),
                      subtitle: TextValue3(
                        title:
                            'They will not be able to transfer money out of this account on their own.',
                      ),
                      trailing: Switch.adaptive(
                        value: appConstants.lockSaving,
                        activeColor: primaryButtonColor,
                        onChanged: (value) async {
                          if (selectedKidId == '' &&
                              appConstants.haveKid == false) {
                            showNotification(
                                error: 1,
                                icon: Icons.error_outline,
                                message: NotificationText.NO_USER_SELECTED);
                            return;
                          }
                          appConstants.updatelockSaving(value);
                          ApiServices services = ApiServices();

                          if (appConstants.haveKid == true) {
                            List<String> idsList = await ApiServices()
                                .fetchUserKidsIds(
                                    appConstants.userRegisteredId);
                            for (var id in idsList) {
                              await services.addUserPersonalization(
                                  userId: id,
                                  kidsToPayFriends:
                                      appConstants.kidsToPayFriends,
                                  kidsToPublish: appConstants.kidsToPublish,
                                  lockCharity: appConstants.lockCharity,
                                  lockSaving: appConstants.lockSaving,
                                  pendingApprovales:
                                      appConstants.pendingApprovales,
                                  slideToPay: appConstants.slideToPay,
                                  parentId: appConstants.userRegisteredId,
                                  disableToDo: appConstants.disableToDo);
                            }
                            showNotification(
                                error: 0,
                                icon: Icons.check,
                                message:
                                    '${NotificationText.ADDED_SUCCESSFULLY} for all kids');
                            return;
                          }
                          // else if(){
                          //   ApiServices().fetchUserKidsIds(appConstants.userRegisteredId);

                          // }
                          await services.addUserPersonalization(
                              userId: selectedKidId == ''
                                  ? appConstants.userRegisteredId
                                  : selectedKidId,
                              kidsToPayFriends: appConstants.kidsToPayFriends,
                              kidsToPublish: appConstants.kidsToPublish,
                              lockCharity: appConstants.lockCharity,
                              lockSaving: appConstants.lockSaving,
                              pendingApprovales: appConstants.pendingApprovales,
                              slideToPay: appConstants.slideToPay,
                              parentId: appConstants.userRegisteredId,
                              disableToDo: appConstants.disableToDo);
                          showNotification(
                              error: 0,
                              icon: Icons.check,
                              message: NotificationText.ADDED_SUCCESSFULLY);
                        },
                      ),
                    ),
                    spacing_medium,
                    ListTile(
                      title: TextValue2(
                        title: 'Lock Charity Wallet?',
                      ),
                      subtitle: TextValue3(
                        title:
                            'They will not be able to transfer money out of this account on their own.',
                      ),
                      trailing: Switch.adaptive(
                        value: appConstants.lockCharity,
                        activeColor: primaryButtonColor,
                        onChanged: (value) async {
                          if (selectedKidId == '' &&
                              appConstants.haveKid == false) {
                            showNotification(
                                error: 1,
                                icon: Icons.error_outline,
                                message: NotificationText.NO_USER_SELECTED);
                            return;
                          }
                          appConstants.updatelockCharity(value);

                          ApiServices services = ApiServices();

                          if (appConstants.haveKid == true) {
                            List<String> idsList = await ApiServices()
                                .fetchUserKidsIds(
                                    appConstants.userRegisteredId);
                            for (var id in idsList) {
                              await services.addUserPersonalization(
                                  userId: id,
                                  kidsToPayFriends:
                                      appConstants.kidsToPayFriends,
                                  kidsToPublish: appConstants.kidsToPublish,
                                  lockCharity: appConstants.lockCharity,
                                  lockSaving: appConstants.lockSaving,
                                  pendingApprovales:
                                      appConstants.pendingApprovales,
                                  slideToPay: appConstants.slideToPay,
                                  parentId: appConstants.userRegisteredId,
                                  disableToDo: appConstants.disableToDo);
                            }
                            showNotification(
                                error: 0,
                                icon: Icons.check,
                                message:
                                    '${NotificationText.ADDED_SUCCESSFULLY} for all kids');
                            return;
                          }
                          // else if(){
                          //   ApiServices().fetchUserKidsIds(appConstants.userRegisteredId);

                          // }
                          await services.addUserPersonalization(
                              userId: selectedKidId == ''
                                  ? appConstants.userRegisteredId
                                  : selectedKidId,
                              kidsToPayFriends: appConstants.kidsToPayFriends,
                              kidsToPublish: appConstants.kidsToPublish,
                              lockCharity: appConstants.lockCharity,
                              lockSaving: appConstants.lockSaving,
                              pendingApprovales: appConstants.pendingApprovales,
                              slideToPay: appConstants.slideToPay,
                              parentId: appConstants.userRegisteredId,
                              disableToDo: appConstants.disableToDo);
                          showNotification(
                              error: 0,
                              icon: Icons.check,
                              message: NotificationText.ADDED_SUCCESSFULLY);
                        },
                      ),
                    ),
                    spacing_medium,
                    // ListTile(
                    //   title: TextValue2(
                    //     title: 'Link allowance to “TO DO”',
                    //   ),
                    //   subtitle: TextValue3(
                    //     title:
                    //         'Allowance will not be desposited until you confirm TO DO tasks are completed',
                    //   ),
                    //   trailing: Transform.scale(
                    //     scale: 0.7,
                    //     child: Switch.adaptive(
                    //       value: appConstants.disableToDo,
                    //       activeColor: primaryButtonColor,
                    //
                    //       onChanged: (value) async {
                    //         appConstants.updateDisableToDo(value);

                    //         ApiServices services = ApiServices();

                    //         if (appConstants.haveKid == true) {
                    //           List<String> idsList = await ApiServices()
                    //               .fetchUserKidsIds(
                    //                   appConstants.userRegisteredId);
                    //           for (var id in idsList) {
                    //             await services.addUserPersonalization(
                    //                 userId: id,
                    //                 kidsToPayFriends:
                    //                     appConstants.kidsToPayFriends,
                    //                 kidsToPublish: appConstants.kidsToPublish,
                    //                 lockCharity: appConstants.lockCharity,
                    //                 lockSaving: appConstants.lockSaving,
                    //                 pendingApprovales:
                    //                     appConstants.pendingApprovales,
                    //                 slideToPay: appConstants.slideToPay,
                    //                 parentId: appConstants.userRegisteredId,
                    //                 disableToDo: appConstants.disableToDo);
                    //           }
                    //           showNotification(
                    //               error: 0,
                    //               icon: Icons.check,
                    //               message: '${NotificationText.ADDED_SUCCESSFULLY} for all kids');
                    //           return;
                    //         }
                    //         // else if(){
                    //         //   ApiServices().fetchUserKidsIds(appConstants.userRegisteredId);

                    //         // }
                    //         await services.addUserPersonalization(
                    //             userId: selectedKidId == ''
                    //                 ? appConstants.userRegisteredId
                    //                 : selectedKidId,
                    //             kidsToPayFriends: appConstants.kidsToPayFriends,
                    //             kidsToPublish: appConstants.kidsToPublish,
                    //             lockCharity: appConstants.lockCharity,
                    //             lockSaving: appConstants.lockSaving,
                    //             pendingApprovales:
                    //                 appConstants.pendingApprovales,
                    //             slideToPay: appConstants.slideToPay,
                    //             parentId: appConstants.userRegisteredId,
                    //             disableToDo: appConstants.disableToDo);
                    //         showNotification(
                    //             error: 0,
                    //             icon: Icons.check,
                    //             message: NotificationText.ADDED_SUCCESSFULLY);
                    //       },
                    //     ),
                    //   ),
                    // ),

                    spacing_medium,
                    // Padding(
                    //   padding:
                    //       EdgeInsets.symmetric(vertical: width * 0.06),
                    //   child: ZakiPrimaryButton(
                    //       title: 'Update',
                    //       width: width,
                    //       onPressed: () async{
                    //         ApiServices services = ApiServices();
                    //         if (appConstants.haveKid==true) {
                    //           List<String> idsList = await ApiServices().fetchUserKidsIds(appConstants.userRegisteredId);
                    //           for (var id in idsList) {
                    //         await services.addUserPersonalization(
                    //           userId: id,
                    //           kidsToPayFriends: appConstants.kidsToPayFriends,
                    //           kidsToPublish: appConstants.kidsToPublish,
                    //           lockCharity: appConstants.lockCharity,
                    //           lockSaving: appConstants.lockSaving,
                    //           pendingApprovales: appConstants.pendingApprovales,
                    //           slideToPay: appConstants.slideToPay,
                    //           parentId: appConstants.userRegisteredId,
                    //         );
                    //           }
                    //           showNotification(error: 0, icon: Icons.check, message: '${NotificationText.ADDED_SUCCESSFULLY} for all kids');
                    //           return;
                    //         }
                    //         // else if(){
                    //         //   ApiServices().fetchUserKidsIds(appConstants.userRegisteredId);
                    //         // }
                    //         await services.addUserPersonalization(
                    //           userId: selectedKidId=='' ? appConstants.userRegisteredId : selectedKidId,
                    //           kidsToPayFriends: appConstants.kidsToPayFriends,
                    //           kidsToPublish: appConstants.kidsToPublish,
                    //           lockCharity: appConstants.lockCharity,
                    //           lockSaving: appConstants.lockSaving,
                    //           pendingApprovales: appConstants.pendingApprovales,
                    //           slideToPay: appConstants.slideToPay,
                    //           parentId: appConstants.userRegisteredId,
                    //         );
                    //         showNotification(error: 0, icon: Icons.check, message: NotificationText.ADDED_SUCCESSFULLY);
                    //       }),
                    // )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void getUserKidsPersonalizationsSettings(AppConstants appConstants,
      {String? kidId}) async {
    Map<String, dynamic>? kidData =
        await ApiServices().getKidsPersonalizeExperience(kidId!);
    if (kidData != null) {
      appConstants
          .updatekidsToPayFriends(kidData[AppConstants.KidP_Kid2PayFriends]);
      appConstants.updatekidsToPublish(kidData[AppConstants.KidP_Kids2Publish]);
      appConstants.updateslideToPay(kidData[AppConstants.KidP_UseSlide2Pay]);
      appConstants.updatelockSaving(kidData[AppConstants.KidP_lockSavings]);
      appConstants.updatelockCharity(kidData[AppConstants.KidP_lockDonate]);
      appConstants.updateDisableToDo(kidData[AppConstants.KidP_disableTo_Do]);
      logMethod(
          title: 'Kids Settings for:',
          message: kidData['KidP_Kid2PayFriends'].toString());
      // kidData[]
    }
  }
}
