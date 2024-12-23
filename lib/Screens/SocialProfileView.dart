import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zaki/Constants/Spacing.dart';
import 'package:zaki/Widgets/ZakiPrimaryButton.dart';
import '../Constants/AppConstants.dart';
import '../Constants/HelperFunctions.dart';
import '../Constants/Styles.dart';
import '../Models/UserModel.dart';
import '../Services/api.dart';
import '../Widgets/AppBars/AppBar.dart';
import 'Socialize.dart';
import 'MyPosts.dart';
import 'PayOrRequestScreen.dart';

class SocialProfileView extends StatefulWidget {
  final String? selectedUserImageUrl;
  final String? selectedUserId;
  final String? selectedUserName;
  const SocialProfileView(
      {Key? key,
      this.selectedUserId,
      this.selectedUserImageUrl,
      this.selectedUserName})
      : super(key: key);

  @override
  State<SocialProfileView> createState() => _SocialProfileViewState();
}

class _SocialProfileViewState extends State<SocialProfileView> {
  Stream<QuerySnapshot>? requestedMoneyActivities;
  Stream<QuerySnapshot>? payMoneyActivities;
  Stream<QuerySnapshot>? socialFeed;
  // final _controller = ItemScrollController();
  late PageController _pageController;
  int selectedIndex = 0;
  bool? alreadyFiernds = false;

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: selectedIndex);
    getUserKids();
  }

  getUserKids() {
    Future.delayed(const Duration(milliseconds: 200), () async {
      var appConstants = Provider.of<AppConstants>(context, listen: false);
      bool? friend = await ApiServices().checkFriends(
          id: appConstants.userRegisteredId,
          friendId: widget.selectedUserId.toString());
      setState(() {
        alreadyFiernds = friend;
        socialFeed =
            ApiServices().getSocialFeeds(userId: widget.selectedUserId);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var appConstants = Provider.of<AppConstants>(context, listen: true);
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
                padding: getCustomPadding(),
                child: Column(
                  children: [
                    appBarHeader_005(
                      context: context,
                      appBarTitle: '@${widget.selectedUserName} Profile',
                      backArrow: false,
                      height: height,
                      width: width,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  // color: green,
                                  shape: BoxShape.circle,
                                  // border: Border.all(color: grey)
                                ),
                                width: width * 0.25,
                                height: height * 0.13,
                                child: Center(
                                  child: userImage(
                                    imageUrl: widget.selectedUserImageUrl,
                                    width: width,
                                  ),
                                ),
                              ),
                              Text(
                                '@${widget.selectedUserName!}',
                                style: heading3TextStyle(width, color: black),
                              ),
                            ],
                          ),
                        ),
                        //  SizedBox(
                        //   width: 20,
                        //  ),

                        Expanded(
                          child: alreadyFiernds == false
                              ? SizedBox(
                                  height: 10,
                                  width: 10,
                                )
                              : Column(
                                  children: [
                                    ZakiPrimaryButton(
                                      width: width,
                                      borderColor: green,
                                      textColor: white,
                                      // backgroundTransparent: 1,
                                      title: 'Send',
                                      backGroundColor: green,
                                      onPressed: () {
                                        logMethod(
                                            title: 'Socialize Pay+ User',
                                            message: widget.selectedUserId);
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  PayOrRequestScreen(
                                                selectedUserModel: UserModel(
                                                  usaLogo: widget
                                                      .selectedUserImageUrl,
                                                  usaFirstName:
                                                      widget.selectedUserName,
                                                  usaUserName:
                                                      widget.selectedUserName,
                                                  usaUserId:
                                                      widget.selectedUserId,
                                                ),
                                              ),
                                            ));
                                      },
                                    ),
                                    spacing_small,
                                    ZakiPrimaryButton(
                                      backgroundTransparent: 1,
                                      width: width,
                                      borderColor: green,
                                      textColor: green,
                                      title: 'Request',
                                      backGroundColor: white,
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  PayOrRequestScreen(
                                                selectedUserModel: UserModel(
                                                  usaLogo: widget
                                                      .selectedUserImageUrl,
                                                  usaFirstName:
                                                      widget.selectedUserName,
                                                  usaUserName:
                                                      widget.selectedUserName,
                                                  usaUserId:
                                                      widget.selectedUserId,
                                                ),
                                              ),
                                            ));
                                      },
                                    ),
                                  ],
                                ),
                        ),
                      ],
                    ),
                    // spacing_medium,

                    spacing_large,
                    Container(
                      color: const Color(0XFFF9FFF9),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 0,
                          vertical: 0,
                        ),
                        child: Container(
                          height: height * 0.07,
                          decoration: BoxDecoration(
                              color: white,
                              border: Border.all(color: grey.withOpacity(0.4)),
                              borderRadius:
                                  BorderRadius.circular(width * 0.08)),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      selectedIndex = 0;
                                      setState(() {
                                        _pageController
                                            .jumpToPage(selectedIndex);
                                      });
                                    },
                                    child: AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 300),
                                      decoration: BoxDecoration(
                                          borderRadius: selectedIndex == 0
                                              ? BorderRadius.circular(
                                                  width * 0.08)
                                              : BorderRadius.circular(0),
                                          color: selectedIndex == 0
                                              ? green
                                              : transparent),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          AnimatedSwitcher(
                                            duration: const Duration(
                                                milliseconds: 400),
                                            transitionBuilder:
                                                (child, animation) {
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
                                                    'social_selected.png')
                                                : Image.asset(imageBaseAddress +
                                                    'social_un_selected.png'),
                                          ),
                                          const SizedBox(width: 5),
                                          Center(
                                              child: FittedBox(
                                                  child: Text(
                                            'Everyone',
                                            style: textStyleHeading2WithTheme(
                                                context, width * 0.75,
                                                whiteColor:
                                                    selectedIndex == 0 ? 1 : 5),
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
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    decoration: BoxDecoration(
                                        borderRadius: selectedIndex == 1
                                            ? BorderRadius.circular(
                                                width * 0.08)
                                            : BorderRadius.circular(0),
                                        color: selectedIndex == 1
                                            ? green
                                            : transparent),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        AnimatedSwitcher(
                                          duration:
                                              const Duration(milliseconds: 400),
                                          transitionBuilder:
                                              (child, animation) {
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
                                                  'justMe_selected.png')
                                              : Image.asset(imageBaseAddress +
                                                  'justMe_unselected.png'),
                                        ),
                                        const SizedBox(width: 5),
                                        Center(
                                            child: FittedBox(
                                                child: Text(
                                          'Just Us',
                                          style: textStyleHeading2WithTheme(
                                              context, width * 0.75,
                                              whiteColor:
                                                  selectedIndex == 1 ? 1 : 5),
                                        ))),
                                      ],
                                    ),
                                  ),
                                ))
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {},
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  EveryOneActivities(
                      socialFeed: socialFeed,
                      appConstants: appConstants,
                      selectedUserId: widget.selectedUserId),
                  MyPosts(
                      selectedUserId: widget.selectedUserId, fromProfile: true)
                  // ActivitiesWithVideos()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
