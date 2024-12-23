// ignore_for_file: file_names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
// import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:zaki/Constants/HelperFunctions.dart';
import 'package:zaki/Models/GoalModel.dart';
import 'package:zaki/Screens/CompletedGoals.dart';
import 'package:zaki/Screens/NewGoal.dart';
import 'package:zaki/Screens/OthersGoal.dart';
import 'package:zaki/Widgets/FloatingActionButton.dart';

import '../Constants/AppConstants.dart';
import '../Constants/Styles.dart';
import '../Widgets/AppBars/AppBar.dart';
import '../Widgets/CustomBottomNavigationBar.dart';
import 'UnCompletedGoals.dart';

class AllGoals extends StatefulWidget {
  const AllGoals({Key? key}) : super(key: key);

  @override
  _AllGoalsState createState() => _AllGoalsState();
}

class _AllGoalsState extends State<AllGoals> {
  // final bottomSheetController = PanelController();
  late PageController _pageController;
  int selectedIndex = 0;

  @override
  void initState() {
    _pageController = PageController(initialPage: selectedIndex);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var appConstants = Provider.of<AppConstants>(context, listen: true);
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      floatingActionButton: CustomFloadtingActionButton(),
      bottomNavigationBar: CustomBottomNavigationBar(),
      body: SafeArea(
        child: Container(
          color: white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 0),
                  child: appBarHeader_005(
                    context: context,
                    appBarTitle: 'Goals',
                    backArrow: false,
                    height: height,
                    width: width,
                    leadingIcon: true,
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
                              appConstants.updateGoalModel(GoalModel());
                              appConstants.updateDateOfBirth('dd / mm / yyyy');
                              Navigator.pop(context);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const NewGoal()));
                            },
                            leading: Icon(
                              FontAwesomeIcons.bullseye,
                              color: black,
                              size: width * 0.05,
                            ),
                            title: Text('New Goal'),
                          ),
                        ),
                        PopupMenuItem(
                          child: ListTile(
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const CompletedGoals()));
                            },
                            leading: Icon(
                              Icons.edit_calendar_rounded,
                              color: black,
                              size: width * 0.05,
                            ),
                            title: Text('Expired & Completed Goals'),
                          ),
                        ),
                      ],
                    ),
                  )),
              Container(
                color: blue.withOpacity(0.15),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: width * 0.075,
                    vertical: width * 0.035,
                  ),
                  child: Container(
                    height: height * 0.06,
                    decoration: BoxDecoration(
                        color: white,
                        border: Border.all(color: grey.withOpacity(0.4)),
                        borderRadius: BorderRadius.circular(width * 0.08)),
                    child: Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              selectedIndex = 0;
                              setState(() {
                                _pageController.jumpToPage(selectedIndex);
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              decoration: BoxDecoration(
                                  borderRadius: selectedIndex == 0
                                      ? BorderRadius.circular(width * 0.08)
                                      : BorderRadius.circular(0),
                                  color:
                                      selectedIndex == 0 ? blue : transparent),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
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
                                    child: selectedIndex == 0
                                        ? Image.asset(imageBaseAddress +
                                            'my_goal_selected.png')
                                        : Image.asset(imageBaseAddress +
                                            'my_goal_un_selected.png'),
                                  ),
                                  const SizedBox(width: 5),
                                  Center(
                                      child: FittedBox(
                                          child: Text(
                                    'My \nGoals',
                                    style: textStyleHeading2WithTheme(
                                        context, width * 0.65,
                                        whiteColor: selectedIndex == 0 ? 1 : 8),
                                    textAlign: TextAlign.center,
                                  ))),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                            child: InkWell(
                          onTap: () {
                            selectedIndex = 1;
                            setState(() {
                              _pageController.jumpToPage(selectedIndex);
                            });
                          },
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                decoration: BoxDecoration(
                                    borderRadius: selectedIndex == 1
                                        ? BorderRadius.circular(width * 0.08)
                                        : BorderRadius.circular(0),
                                    color: selectedIndex == 1
                                        ? blue
                                        : transparent),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    AnimatedSwitcher(
                                      duration:
                                          const Duration(milliseconds: 400),
                                      transitionBuilder: (child, animation) {
                                        return SlideTransition(
                                          position: animation.drive(Tween(
                                            begin: const Offset(1.0, 0.0),
                                            end: const Offset(0.0, 0.0),
                                          )),
                                          child: child,
                                        );
                                      },
                                      child: selectedIndex == 1
                                          ? Image.asset(imageBaseAddress +
                                              'others_goal_selected.png')
                                          : Image.asset(imageBaseAddress +
                                              'others_goal_un_selected.png'),
                                    ),
                                    const SizedBox(width: 5),
                                    Center(
                                        child: FittedBox(
                                            child: Text(
                                      'Friends & Family \nGoals',
                                      textAlign: TextAlign.center,
                                      style: textStyleHeading2WithTheme(
                                          context, width * 0.65,
                                          whiteColor:
                                              selectedIndex == 1 ? 1 : 8),
                                    ))),
                                  ],
                                ),
                              ),
                              StreamBuilder(
                                  stream: FirebaseFirestore.instance
                                      .collection(AppConstants.USER)
                                      .doc(appConstants.userRegisteredId)
                                      .collection(AppConstants
                                          .Goal_InviteReceivedFrom_UserID)
                                      .snapshots(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot snapshots) {
                                    var width =
                                        MediaQuery.of(context).size.width;
                                    if (snapshots.hasError) {
                                      return const Text(':(');
                                    }
                                    if (snapshots.connectionState ==
                                        ConnectionState.waiting) {
                                      return SizedBox.shrink();
                                    }
                                    if (snapshots.data!.docs.length == 0) {
                                      return SizedBox.shrink();
                                    }
                                    // var snapShot = snapshots.data!.data() as Map<String, dynamic>;
                                    return Positioned(
                                        top: -10,
                                        right: -15,
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: selectedIndex == 1
                                                  ? blue
                                                  : white,
                                              border: Border.all(
                                                  color: selectedIndex == 1
                                                      ? white
                                                      : blue,
                                                  width: 3),
                                              shape: BoxShape.circle),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 18, vertical: 0),
                                            child: Text(
                                              '${snapshots.data!.docs.length}',
                                              style: textStyleHeading2WithTheme(
                                                  context, width * 0.6,
                                                  whiteColor: selectedIndex == 1
                                                      ? 1
                                                      : 8),
                                            ),
                                          ),
                                        ));
                                  })
                            ],
                          ),
                        ))
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (index) {},
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    UnCompletedGoals(
                        // bottomSheetController: bottomSheetController
                        ),
                    const OthersGoal()
                  ],
                ),
              ),

              // Center(
              //   child: Text(
              //     'Ooops No Goals Setup Yet',
              //     style: textStyleHeading2WithTheme(context,width*0.75, whiteColor: 2),
              //     ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

class GoalsStatusButton extends StatelessWidget {
  const GoalsStatusButton(
      {Key? key,
      required this.width,
      this.imageUrl,
      this.amount,
      this.title,
      this.backGroundColor,
      this.lockShow})
      : super(key: key);

  final double width;
  final String? imageUrl;
  final String? title;
  final String? amount;
  final int? backGroundColor;
  final bool? lockShow;

  @override
  Widget build(BuildContext context) {
    var appConstants = Provider.of<AppConstants>(context, listen: true);
    return Container(
      decoration: BoxDecoration(
          color: backGroundColor == 0 ? blue : transparent,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
              color: backGroundColor == 0 ? blue : grey.withOpacity(0.4),
              width: backGroundColor == 0 ? 1 : 2)),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$title',
                  style: textStyleHeading2WithTheme(context, width * 0.6,
                      whiteColor: backGroundColor == 0 ? 1 : 0),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Image.asset(imageBaseAddress + imageUrl!),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  appConstants.userModel.usaCountry == "Pakistan"
                      ? Row(
                          children: [
                            Text(
                              '$amount',
                              style: textStyleHeading1WithTheme(context, width,
                                  whiteColor: backGroundColor == 0 ? 1 : 0,
                                  bold: false),
                            ),
                            SizedBox(
                              width: width * 0.015,
                            ),
                            Text(
                              '${getCurrencySymbol(context, appConstants: appConstants)}',
                              style: textStyleHeading2WithTheme(
                                  context, width * 0.9,
                                  whiteColor: backGroundColor == 0 ? 1 : 0),
                            ),
                          ],
                        )
                      : Row(
                          children: [
                            Text(
                              '${getCurrencySymbol(context, appConstants: appConstants)} ${getAmountAsFormatedIntoLetter(amount: double.parse(amount.toString()))}',
                              style: textStyleHeading1WithTheme(context, width,
                                  whiteColor: backGroundColor == 0 ? 1 : 0,
                                  bold: false),
                            ),
                          ],
                        ),
                  lockShow == true
                      ? Icon(
                          Icons.lock,
                          color: backGroundColor == 0 ? white : blue,
                          size: width * 0.04,
                        )
                      : const SizedBox()
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}


///