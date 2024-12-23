import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:zaki/Constants/HelperFunctions.dart';
import 'package:zaki/Constants/Spacing.dart';
import 'package:zaki/Constants/Styles.dart';
import 'package:zaki/Screens/MyPosts.dart';
import 'package:zaki/Widgets/FloatingActionButton.dart';
import '../Constants/AppConstants.dart';
import '../Services/api.dart';
import '../Widgets/AppBars/AppBar.dart';
import '../Widgets/CustomBottomNavigationBar.dart';
import '../Widgets/CustomFeedCard.dart';
import '../Widgets/ZakiCircularButton.dart';
import 'package:zaki/Widgets/CustomLoader.dart';
import 'InviteMainScreen.dart';

class AllActivities extends StatefulWidget {
  final String? id;
  final bool? leadingIconRequired;  
  final bool? needBottomNavbar;
  const AllActivities(
      {Key? key, this.id, this.leadingIconRequired, this.needBottomNavbar})
      : super(key: key);

  @override
  _AllActivitiesState createState() => _AllActivitiesState();
}

class _AllActivitiesState extends State<AllActivities> {
  // Stream<QuerySnapshot>? requestedMoneyActivities;
  // Stream<QuerySnapshot>? payMoneyActivities;
  Stream<QuerySnapshot>? socialFeed;
  // final _controller = ItemScrollController();
  late PageController _pageController;
  int selectedIndex = 0;

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  void initState() {
    super.initState();
    setPageController();

    getUserKids();
  }
  

  void setPageController() {
    selectedIndex = widget.id != null ? 1 : 0;
    setState(() {});
    _pageController = PageController(initialPage: selectedIndex);
  }

  getUserKids() {
    Future.delayed(const Duration(milliseconds: 200), () {
      var appConstants = Provider.of<AppConstants>(context, listen: false);
      setState(() {
        socialFeed = ApiServices().getSocialFeeds(
            userId: appConstants.userRegisteredId, needMyFeeds: false);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var appConstants = Provider.of<AppConstants>(context, listen: true);
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.95),
      floatingActionButton: CustomFloadtingActionButton(),
      bottomNavigationBar: widget.needBottomNavbar == false
          ? null
          : CustomBottomNavigationBar(index: 2),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: getCustomPadding(),
              child: appBarHeader_005(
                context: context,
                appBarTitle: 'Socialize',
                backArrow: true,
                height: height,
                width: width,
                rightSideAppbarIcon: FontAwesomeIcons.userGroup,
                leadingIcon: widget.leadingIconRequired == false ? false : true,
                // leadingIcon: widget.leadingIconRequired ==false?false: true,
                // menuButton: PopupMenuButton(
                //   shape: shape(),
                //   child: Padding(
                //     padding: const EdgeInsets.only(right: 8.0),
                //     child: Icon(
                //       Icons.more_horiz,
                //       color: blue,
                //     ),
                //   ),
                //   elevation: 20,
                //   enableFeedback: true,
                //   enabled: true,
                //   itemBuilder: (_) => <PopupMenuEntry>[
                //     PopupMenuItem(
                //       child: ListTile(
                //         onTap: () {
                //           Navigator.pop(context);
                //           Navigator.push(
                //               context,
                //               MaterialPageRoute(
                //                   builder: (context) => const MyPosts()));
                //         },
                //         leading: Icon(
                //           Icons.post_add,
                //           color: black,
                //           size: width * 0.05,
                //         ),
                //         title: Text('My Posts'),
                //       ),
                //     ),
                //   ],
                // ),
              ),
            ),
            Padding(
              padding: getCustomPadding(),
              child: Container(
                color: const Color(0XFFF9FFF9),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 0,
                    vertical: width * 0.045,
                  ),
                  child: Container(
                    height: height * 0.07,
                    decoration: BoxDecoration(
                        color: white,
                        border: Border.all(color: grey.withOpacity(0.4)),
                        borderRadius: BorderRadius.circular(width * 0.08)),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
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
                                    color: selectedIndex == 0
                                        ? green
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
                                      ? BorderRadius.circular(width * 0.08)
                                      : BorderRadius.circular(0),
                                  color:
                                      selectedIndex == 1 ? green : transparent),
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
                                    'Just Me',
                                    style: textStyleHeading2WithTheme(
                                        context, width * 0.75,
                                        whiteColor: selectedIndex == 1 ? 1 : 5),
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
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {},
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  EveryOneActivities(
                    socialFeed: socialFeed,
                    appConstants: appConstants,
                    clickEnabled: true,
                  ),
                  MyPosts(
                    postId: widget.id,
                    clickEnabled: true,
                  )
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

class EveryOneActivities extends StatelessWidget {
  const EveryOneActivities(
      {Key? key,
      required this.socialFeed,
      required this.appConstants,
      this.selectedUserId,
      this.clickEnabled})
      : super(key: key);

  final Stream<QuerySnapshot<Object?>>? socialFeed;
  final AppConstants appConstants;
  final bool? clickEnabled;
  final String? selectedUserId;

  @override
  Widget build(BuildContext context) {
    logMethod(title: 'Slected UserID', message: selectedUserId.toString());
    return socialFeed == null
        ? const SizedBox()
        : StreamBuilder<QuerySnapshot>(
            stream: socialFeed,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return const SizedBox();
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CustomLoader());
              }
              if (snapshot.data!.size == 0) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: ZakiCicularButton(
                        title: 'Sync Contacts',
                        width: 50,
                        backGroundColor: white,
                        icon: Icons.sync_outlined,
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const InviteMainScreen(
                                  fromHomeScreen: true,
                                ),
                              ));
                        },
                      ),
                    ),
                  ],
                );
              }
              return ListView.builder(
                itemCount: snapshot.data!.size,
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                // separatorBuilder: (context, index) => (snapshot.data!.docs[index][AppConstants.Social_Sharedwith_Users_List].length!=0 && !snapshot.data!.docs[index][AppConstants.Social_Sharedwith_Users_List].contains(appConstants.userRegisteredId))?
                //   SizedBox.shrink(): Divider(color: black),
                itemBuilder: (BuildContext context, int index) {
                  return (snapshot.data!.docs[index][AppConstants.Social_Sharedwith_Users_List]
                                      .length !=0 &&
                              !snapshot.data!.docs[index][AppConstants.Social_Sharedwith_Users_List]
                                  .contains(appConstants.userRegisteredId))
                          ? SizedBox.shrink()
                          : (selectedUserId == null)
                              ?
                              //  ((selectedUserId!=null) && snapshot.data!.docs[index][AppConstants.Social_Sender_user_id]==selectedUserId || snapshot.data!.docs[index][AppConstants.Social_receiver_user_id]==selectedUserId)?
                              CustomFeedCard(
                                  snapshot: snapshot.data!.docs[index],
                                  clickEnabled: clickEnabled,
                                )
                              : snapshot.data!.docs[index][AppConstants
                                              .Social_Sender_user_id] ==
                                          selectedUserId ||
                                      snapshot.data!.docs[index][AppConstants
                                              .Social_receiver_user_id] ==
                                          selectedUserId
                                  ? CustomFeedCard(
                                      snapshot: snapshot.data!.docs[index],
                                      clickEnabled: clickEnabled,
                                    )
                                  : SizedBox.shrink()
                      // :SizedBox.shrink()
                      ;

                  // Text(snapshot.data!.docs[index][AppConstants.Social_amount].toString());
                },
              );
            });
  }
}
