import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zaki/Constants/CheckInternetConnections.dart';
import 'package:zaki/Constants/NotificationTitle.dart';
import 'package:zaki/Constants/Spacing.dart';
import 'package:zaki/Services/api.dart';
import 'package:zaki/Widgets/TextHeader.dart';
import 'package:zaki/Widgets/ZakiCircularButton.dart';
import 'package:zaki/Widgets/ZakiPrimaryButton.dart';
import '../Constants/AppConstants.dart';
import '../Constants/HelperFunctions.dart';
import '../Constants/Styles.dart';
import '../Widgets/AppBars/AppBar.dart';
import '../Widgets/CustomTextButon.dart';
import '../Widgets/CustomTextField.dart';
import 'GaolContributionScreen.dart';

class NewGoal extends StatefulWidget {
  const NewGoal({Key? key}) : super(key: key);

  @override
  _NewGoalState createState() => _NewGoalState();
}

class _NewGoalState extends State<NewGoal> {
  bool emojiShowing = false;
  final formGlobalKey = GlobalKey<FormState>();
  final goalAmountController = TextEditingController();
  final goalController = TextEditingController();
  late DateTime date;
  String goalError = '';

  // void _onEmojiSelected(Emoji emoji) {
  //   goalAmountController
  //     ..text += emoji.emoji
  //     ..selection = TextSelection.fromPosition(
  //         TextPosition(offset: goalAmountController.text.length));
  // }

  // void _onBackspacePressed() {
  //   goalAmountController
  //     ..text = goalAmountController.text.characters.skipLast(1).toString()
  //     ..selection = TextSelection.fromPosition(
  //         TextPosition(offset: goalAmountController.text.length));
  // }

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      var appConstants = Provider.of<AppConstants>(context, listen: false);
      if (appConstants.goal.userId != null) {
        goalController.text = appConstants.goal.goalName.toString();
        goalAmountController.text = appConstants.goal.goalPrice.toString();
        appConstants.updateDateOfBirth(
            '${appConstants.goal.goalDate!.day} / ${appConstants.goal.goalDate!.month} / ${appConstants.goal.goalDate!.year}');
        date = appConstants.goal.goalDate!;
        setState(() {});
      } else {
        DateTime today = DateTime.now();
        today = today.add(const Duration(days: 60));
        appConstants
            .updateDateOfBirth('${today.day} / ${today.month} / ${today.year}');
        setState(() {
          date = today;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    goalAmountController.dispose();
    goalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var appConstants = Provider.of<AppConstants>(context, listen: true);
    var internet = Provider.of<CheckInternet>(context, listen: true);
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    logMethod(
        title: 'Goal id inside main',
        message: 'Goall:: ${appConstants.goal.docId.toString()}');
    return Scaffold(
      body: SafeArea(
        child: Container(
          // color: white,
          child: Padding(
            padding: getCustomPadding(),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Form(
                key: formGlobalKey,
                autovalidateMode: AutovalidateMode.disabled,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    appBarHeader_005(
                        context: context,
                        appBarTitle: 'Goal',
                        backArrow: true,
                        height: height,
                        width: width,
                        leadingIcon: true),

                    // Row(
                    //   children: [
                    //     Expanded(
                    //       child: StreamBuilder(
                    //           stream: FirebaseFirestore.instance
                    //               .collection(AppConstants.USER)
                    //               .doc(appConstants.userRegisteredId)
                    //               .collection(AppConstants.USER_WALLETS)
                    //               .doc(AppConstants.Savings_Wallet)
                    //               .snapshots(),
                    //           builder: (context,
                    //               AsyncSnapshot<DocumentSnapshot> snapshot) {
                    //             if (!snapshot.hasData) {
                    //               return GoalsStatusButton(
                    //                 width: width,
                    //                 amount: 0.toString(),
                    //                 backGroundColor: 0,
                    //                 imageUrl: "saving.png",
                    //                 title: "Savings\nWallet",
                    //               );
                    //             }
                    //             return GoalsStatusButton(
                    //               width: width,
                    //               amount: snapshot
                    //                   .data![AppConstants.wallet_balance]
                    //                   .toString(),
                    //               backGroundColor: 0,
                    //               imageUrl: "saving.png",
                    //               title: (appConstants.nickNameModel
                    //                                               .NickN_SavingWallet !=
                    //                                           null &&
                    //                                       appConstants
                    //                                               .nickNameModel
                    //                                               .NickN_SavingWallet !=
                    //                                           "")
                    //                                   ? appConstants
                    //                                       .nickNameModel
                    //                                       .NickN_SavingWallet! +'\nWallet'
                    //                                   : 'Savings'.tr() +'\nWallet',
                    //               lockShow: (appConstants.personalizationSettingModel != null && appConstants.personalizationSettingModel!.kidPLockSavings == true)?true : false

                    //             );
                    //           }),
                    //     ),
                    //     SizedBox(
                    //       width: 10,
                    //     ),
                    //     Expanded(
                    //       child: StreamBuilder(
                    //           stream: FirebaseFirestore.instance
                    //               .collection(AppConstants.USER)
                    //               .doc(appConstants.userRegisteredId)
                    //               .collection(AppConstants.USER_WALLETS)
                    //               .doc(AppConstants.Donations_Wallet)
                    //               .snapshots(),
                    //           builder: (context,
                    //               AsyncSnapshot<DocumentSnapshot> snapshot) {
                    //             if (!snapshot.hasData) {
                    //               return GoalsStatusButton(
                    //                 width: width,
                    //                 amount: 0.toString(),
                    //                 backGroundColor: 0,
                    //                 imageUrl: "donation.png",
                    //                 title: "Savings\nWallet",
                    //               );
                    //             }
                    //             return GoalsStatusButton(
                    //               width: width,
                    //               amount: snapshot
                    //                   .data![AppConstants.wallet_balance]
                    //                   .toString(),
                    //               backGroundColor: 1,
                    //               imageUrl: "donation.png",
                    //               title: (appConstants.nickNameModel
                    //                                               .NickN_DonationWallet !=
                    //                                           null &&
                    //                                       appConstants
                    //                                               .nickNameModel
                    //                                               .NickN_DonationWallet !=
                    //                                           "")
                    //                                   ? appConstants
                    //                                       .nickNameModel
                    //                                       .NickN_DonationWallet! +'\nWallet'
                    //                                   : 'Charity'.tr()+"\nWallet",
                    //               lockShow: (appConstants.personalizationSettingModel != null && appConstants.personalizationSettingModel!.kidPLockDonate == true)?true : false
                    //             );
                    //           }),
                    //     ),
                    //   ],
                    // ),
                    // spacing_large,
                    TextHeader1(
                      title: 'What is your goal?',
                    ),
                    // spacing_small,
                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      textAlignVertical: TextAlignVertical.bottom,
                      textAlign: TextAlign.left,
                      validator: (String? name) {
                        if (name!.isEmpty) {
                          return 'Enter a Goal';
                        }
                        return null;
                      },
                      // style: TextStyle(color: primaryColor),
                      style: heading3TextStyle(width),
                      controller: goalController,
                      obscureText: false,
                      keyboardType: TextInputType.name,
                      maxLines: 1,
                      maxLength: 35,
                      decoration: InputDecoration(
                          counterText: '',
                          hintText: 'Enter a Goal',
                          hintStyle: heading3TextStyle(width),
                          contentPadding: EdgeInsets.all(8.0),
                          isDense: true
                          // labelText: 'My Name is',
                          // labelStyle: textStyleHeading2WithTheme(context,width*0.8, whiteColor: 2),
                          ),
                    ),
                    spacing_medium,
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 24,
                          width: 24,
                          child: Checkbox(
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              activeColor: grey.withValues(alpha:0.6),
                              // focusColor: lightGrey,
                              // fillColor: ,
                              // fillColor: ,
                              value: appConstants.registrationCheckBox,
                              onChanged: (value) {
                                appConstants.updateRegistrationCheckBox(value);
                              }),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: TextValue3(
                            title: 'Hide & Show others this text “Top Secret” ',
                          ),
                        )
                      ],
                    ),
                    spacing_large,
                    Text(
                      'Goal target amount:',
                      style: heading1TextStyle(context, width),
                    ),
                    CustomTextField(
                      amountController: goalAmountController,
                      amountLimit: 100000,
                      textFieldLimit: 6,
                      onChanged: (String value) {
                        if (double.parse(value) > 100000) {
                          setState(() {
                            goalError == 'error';
                          });
                          return;
                        }
                        setState(() {
                          goalError == '';
                        });
                      },
                      validator: (String? amount) {
                        if (amount!.isEmpty) {
                          return 'Please Enter Amount';
                        } else if (double.parse(amount) > 100000) {
                          return "Maximum ${getCurrencySymbol(context, appConstants: appConstants)}100000";
                        }
                        return null;
                      },
                    ),
                    // TextFormField(
                    //   autovalidateMode: AutovalidateMode.onUserInteraction,
                    //   textAlignVertical: TextAlignVertical.bottom,
                    //   textAlign: TextAlign.start,
                    //   validator: (String? name) {
                    //     // if(name!.isEmpty){
                    //     //   return 'Please Enter Goal';
                    //     // }
                    //     // else{
                    //       return null;
                    //     // }
                    //   },
                    //   // style: TextStyle(color: primaryColor),
                    //   style: heading2TextStyle(context, width),
                    //   controller: goalAmountController,
                    //   obscureText: false,
                    //   keyboardType: TextInputType.number,
                    //   maxLines: 1,
                    //   decoration: InputDecoration(
                    //     isDense: true,
                    //     prefixIcon: Padding(
                    //       padding: const EdgeInsets.only(top: 20, left: 20),
                    //       child: Text(
                    //         "${getCurrencySymbol(context, appConstants: appConstants )}",
                    //         style: heading2TextStyle(context, width),
                    //       ),
                    //     ),
                    //     // hintText: 'PKR',
                    //     // hintStyle: textStyleHeading2WithTheme(context, width * 0.8,
                    //     //     whiteColor: 2),
                    //     // labelText: 'My Name is',
                    //     // labelStyle: textStyleHeading2WithTheme(context,width*0.8, whiteColor: 2),
                    //   ),
                    // ),
                    spacing_large,
                    TextHeader1(
                      title: 'Goal due date?',
                    ),

                    spacing_small,
                    InkWell(
                      onTap: () async {
                        DateTime? dateTime = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2090),
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
                            initialEntryMode: DatePickerEntryMode.calendar);
                        // ignore: unnecessary_null_comparison
                        if (dateTime != null) {
                          print('Selected date is: ${dateTime.day}');
                          // 'dd / mm / yyyy'
                          appConstants.updateDateOfBirth(
                              '${dateTime.day} / ${dateTime.month} / ${dateTime.year}');
                          setState(() {
                            date = dateTime;
                          });
                        }
                      },
                      child: Row(
                        children: [
                          Text(
                            appConstants.dateOfBirth,
                            overflow: TextOverflow.clip,
                            style: heading3TextStyle(width),
                          ),
                          const Spacer(),
                          const Icon(Icons.calendar_today_rounded)
                        ],
                      ),
                    ),

                    spacing_small,
                    Divider(
                      color: black,
                      height: 0.3,
                    ),
                    if (appConstants.goal.userId != null)
                      Column(
                        children: [
                          spacing_large,
                          Row(
                            children: [
                              TextHeader1(
                                title: 'Goal raised amount:',
                              ),
                              SizedBox(
                                width: width * 0.05,
                              ),
                              Text(
                                '${getCurrencySymbol(context, appConstants: appConstants)} ${appConstants.goal.goalAmountCollected!.toInt().toString()}',
                                overflow: TextOverflow.clip,
                                style: heading3TextStyle(width, color: green),
                              ),
                              Spacer(),
                              IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                GaolContributter(
                                                  goalId:
                                                      appConstants.goal.docId,
                                                  goalTitle: appConstants
                                                      .goal.goalName,
                                                  amount: appConstants
                                                      .goal.goalAmountCollected!
                                                      .toInt()
                                                      .toString(),
                                                )));
                                  },
                                  icon: Icon(
                                    Icons.arrow_forward,
                                    color: grey,
                                  )),
                            ],
                          )
                        ],
                      ),
                    // InkWell(
                    //     onTap: () {
                    //       setState(() {
                    //         emojiShowing = !emojiShowing;
                    //       });
                    //     },
                    //     child: Padding(
                    //       padding: const EdgeInsets.all(4.0),
                    //       child: Icon(emojiShowing
                    //           ? Icons.emoji_emotions
                    //           : Icons.emoji_emotions_outlined),
                    //     )),

                    // //////////////Emojei Settings
                    // Offstage(
                    //   offstage: !emojiShowing,
                    //   child: SizedBox(
                    //     height: 250,
                    //     child: EmojiPicker(
                    //         onEmojiSelected: (Category category, Emoji emoji) {
                    //           _onEmojiSelected(emoji);
                    //         },
                    //         onBackspacePressed: _onBackspacePressed,
                    //         config: Config(
                    //             columns: 7,
                    //             // Issue: https://github.com/flutter/flutter/issues/28894
                    //             emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0),
                    //             verticalSpacing: 0,
                    //             horizontalSpacing: 0,
                    //             initCategory: Category.RECENT,
                    //             bgColor: const Color(0xFFF2F2F2),
                    //             indicatorColor: Colors.blue,
                    //             iconColor: Colors.grey,
                    //             iconColorSelected: Colors.blue,
                    //             progressIndicatorColor: Colors.blue,
                    //             backspaceColor: Colors.blue,
                    //             skinToneDialogBgColor: Colors.white,
                    //             skinToneIndicatorColor: Colors.grey,
                    //             enableSkinTones: true,
                    //             showRecentsTab: true,
                    //             recentsLimit: 28,
                    //             noRecentsText: 'No Recents',
                    //             noRecentsStyle: const TextStyle(
                    //                 fontSize: 20, color: Colors.black26),
                    //             tabIndicatorAnimDuration: kTabScrollDuration,
                    //             categoryIcons: const CategoryIcons(),
                    //             buttonMode: ButtonMode.MATERIAL)),
                    //   ),
                    // ),

                    // Text(
                    //   'Allocation',
                    //   style: textStyleHeading2WithTheme(context, width * 0.85,
                    //       whiteColor: 0),
                    // ),
                    spacing_large,
                    ZakiPrimaryButton(
                        title: 'Save',
                        width: width,
                        backGroundColor: blue,
                        onPressed: (internet.status ==
                                    AppConstants
                                        .INTERNET_STATUS_NOT_CONNECTED ||
                                goalError != '' ||
                                goalController.text.isEmpty ||
                                goalAmountController.text.isEmpty)
                            ? null
                            : () async {
                                ApiServices services = ApiServices();
                                if (appConstants.goal.userId != null) {
                                  await services.updateGoal(
                                    goalId: appConstants.goal.docId,
                                    amount: double.parse(
                                        goalAmountController.text.trim()),
                                    createdAt: date,
                                    goalName: goalController.text.trim(),
                                    status: appConstants.registrationCheckBox,
                                    userId: appConstants.userRegisteredId,
                                  );
                                  if (appConstants.goal.tokensList!.isNotEmpty)
                                    appConstants.goal.tokensList!
                                        .forEach((element) {
                                      services.sendNotification(
                                          token: element.toString(),
                                          title:
                                              NotificationText.GOAL_EDIT_TITLE,
                                          body: NotificationText
                                              .GOAL_EDIT_SUB_TITLE);
                                    });
                                  // await services.checkInviteForGoal(goalId: appConstants.goal.docId);
                                  Navigator.pop(context);
                                  return;
                                }
                                await services.addNewGoal(
                                    amount: double.parse(
                                        goalAmountController.text.trim()),
                                    createdAt: date,
                                    goalName: goalController.text.trim(),
                                    status: appConstants.registrationCheckBox,
                                    userId: appConstants.userRegisteredId,
                                    ammountCollected: 0);
                                if (appConstants.userModel.usaUserType ==
                                    AppConstants.USER_TYPE_KID)
                                  await services.getUserTokenAndSendNotification(
                                      userId:
                                          appConstants.userModel.userFamilyId,
                                      title:
                                          '${appConstants.userModel.usaUserName} ${NotificationText.REQUEST_NOTIFICATION_TITLE}',
                                      subTitle:
                                          '${NotificationText.REQUEST_NOTIFICATION_SUB_TITLE}');
                                Navigator.pop(context);
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) => const AllTransaction()));
                              }),
                    spacing_medium,
                    if (appConstants.goal.userId != null)
                      Row(
                        children: [
                          Expanded(
                              child: CustomTextButton(
                            width: width,
                            title: 'Delete',
                            onPressed: () async {
                              showDialog(
                                context: context,
                                builder: (BuildContext dialougeContext) =>
                                    AlertDialog(
                                        // title: TextHeader1(title: ''),
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(14.0))),
                                        content: TextValue2(
                                          title:
                                              'Are you sure you want to DELETE this Goal?',
                                        ),
                                        actions: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          ZakiCicularButton(
                                            title: '     Yes     ',
                                            width: width,
                                            textStyle: heading4TextSmall(width,
                                                color: green),
                                            onPressed: () async {
                                              ApiServices service =
                                                  ApiServices();
                                              await service.moveMoney(
                                                amount: appConstants
                                                    .goal.goalAmountCollected,
                                                fromWalletName: AppConstants
                                                    .All_Goals_Wallet,
                                                toWalletName:
                                                    AppConstants.Spend_Wallet,
                                                userId: appConstants
                                                    .userRegisteredId,
                                              );
                                              await service.deleteGoal(
                                                  documentId:
                                                      appConstants.goal.docId);
                                              Navigator.pop(dialougeContext);
                                              Navigator.pop(context);
                                              //  Navigator.pop(dialougeContext);
                                            },
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          ZakiCicularButton(
                                            title: '      No      ',
                                            width: width,
                                            selected: 4,
                                            backGroundColor: green,
                                            border: false,
                                            textStyle: heading4TextSmall(width,
                                                color: white),
                                            onPressed: () {
                                              Navigator.pop(dialougeContext);
                                            },
                                          ),
                                        ],
                                      ),
                                    ]
                                        // actions
                                        ),
                              );
                              return;
                            },
                          )),
                          SizedBox(width: 10),
                          Expanded(
                              child: CustomTextButton(
                            width: width,
                            title: 'Set to Complete',
                            onPressed: () async {
                              showDialog(
                                context: context,
                                builder: (BuildContext dialougeContext) =>
                                    AlertDialog(
                                        // title: TextHeader1(title: ''),
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(14.0))),
                                        content: TextValue2(
                                          title:
                                              'Are you sure this Goal is COMPLETE?',
                                        ),
                                        actions: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          ZakiCicularButton(
                                            title: '     Yes     ',
                                            width: width,
                                            textStyle: heading4TextSmall(width,
                                                color: green),
                                            onPressed: () async {
                                              ApiServices()
                                                  .getUserTokenAndSendNotification(
                                                      userId: appConstants
                                                          .userRegisteredId,
                                                      title:
                                                          '${NotificationText.GOAL_COMPLETED_NOTIFICATION_TITLE}',
                                                      subTitle:
                                                          '${appConstants.userModel.usaUserName} ${NotificationText.GOAL_COMPLETED_NOTIFICATION_SUB_TITLE}');
                                              await ApiServices()
                                                  .updateGoalStatus(
                                                      goalId: appConstants
                                                          .goal.docId,
                                                      status: "completed");
                                              Navigator.pop(dialougeContext);
                                              Navigator.pop(context);
                                            },
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          ZakiCicularButton(
                                            title: '      No      ',
                                            width: width,
                                            selected: 4,
                                            backGroundColor: green,
                                            border: false,
                                            textStyle: heading4TextSmall(width,
                                                color: white),
                                            onPressed: () {
                                              Navigator.pop(dialougeContext);
                                            },
                                          ),
                                        ],
                                      ),
                                    ]
                                        // actions
                                        ),
                              );
                            },
                          ))
                        ],
                      )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
