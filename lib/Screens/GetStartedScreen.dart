// ignore_for_file: file_names, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
// import 'package:zaki/Constants/AppConstants.dart';
import 'package:zaki/Constants/Spacing.dart';
import 'package:zaki/Constants/Styles.dart';
import 'package:zaki/Screens/HomeScreen.dart';
import 'package:zaki/Widgets/AppBars/AppBar.dart';
import 'package:zaki/Widgets/TextHeader.dart';
import 'package:zaki/Widgets/ZakiPrimaryButton.dart';

import '../Constants/AppConstants.dart';
import '../Services/api.dart';

class GetStarted extends StatefulWidget {
  const GetStarted({Key? key}) : super(key: key);

  @override
  _GetStartedState createState() => _GetStartedState();
}

class _GetStartedState extends State<GetStarted> {
  late PageController controller;
  int slideIndex = 0;
// AppConstants.TEMP_CODE;
  List<Map<String, String>> splashData = [
    {
      // "heading": "Issue a Debit Card",
      "heading": "Virtual Money",
      "text":
          "Personalize your kids Spend Limits and \nthen Monitor their spending. \nYour Family -  Your Rules",
      "image": imageBaseAddress + "RegistrationStartImage1.png"
    },
    {
      "heading": "Send or Request Money",
      "text":
          "Send/Request Money From/To Family and \nFriends...it’s Quick & Secure!",
      "image": imageBaseAddress + "RegistrationStartImage2.png"
    },
    {
      "heading": "Let’s Understand Finance!",
      "text":
          "It’s not Rocket Science! Give them a jump Start\non Financial Education in a fun experience, All \nwithin ZakiPay’s tools.",
      "image": imageBaseAddress + "RegistrationStartImage3.png"
    },
  ];
  @override
  void initState() {
    controller = PageController(initialPage: slideIndex);
    userFirstTimeLogin();
    super.initState();
  }

  userFirstTimeLogin() {
    Future.delayed(Duration.zero, () {
      var appConstants = Provider.of<AppConstants>(context, listen: false);
      ApiServices()
          .getUserData(context: context, userId: appConstants.userRegisteredId);
      appConstants.updateIsLoginFirstTime(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    // var appConstants = Provider.of<AppConstants>(context, listen: true);
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: white,
        body: SafeArea(
          child: Padding(
            padding: getCustomPadding(),
            child: Column(
              children: [
                appBarHeader_005(
                  context: context,
                  appBarTitle: 'Cool ZakiPay Features',
                  height: height,
                  leadingIcon: false,
                  width: width,
                  tralingIconButton: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomeScreen()));
                    },
                    child: TextValue3(
                      title: 'Skip',
                    ),
                  ),
                ),
                // spacing_large,

                Expanded(
                  child: Stack(
                    children: [
                      PageView.builder(
                        controller: controller,
                        onPageChanged: (value) {
                          setState(() {
                            slideIndex = value;
                          });
                          controller.jumpToPage(slideIndex);
                        },
                        itemCount: splashData.length,
                        itemBuilder: (context, index) => Column(
                          //  splashData[index]["image"],
                          //  splashData[index]['text'],
                          children: [
                            Image.asset(
                              splashData[index]["image"].toString(),
                              fit: BoxFit.contain,
                              height: height * 0.4,
                              width: width,
                              // color: green,
                            ),
                            Container(
                              width: width,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  spacing_large,
                                  Text(splashData[index]["heading"].toString(),
                                      textAlign: TextAlign.center,
                                      style: appBarTextStyle(
                                        context,
                                        width,
                                      )),
                                  spacing_medium,
                                  Text(splashData[index]["text"].toString(),
                                      textAlign: TextAlign.justify,
                                      style: heading3TextStyle(width)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          SizedBox(
                            height: height * 0.4,
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SmoothPageIndicator(
                                  controller: controller,
                                  count: 3,
                                
                                  effect: SlideEffect(
                                      spacing: 8.0,
                                      radius: 10.0,
                                      dotWidth: 60.0,
                                      dotHeight: 7.0,
                                      paintStyle: PaintingStyle.fill,
                                      strokeWidth: 3,
                                      dotColor: grey,
                                      activeDotColor: primaryButtonColor),
                                ),
                              ]),
                        ],
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                        flex: 4,
                        child: SizedBox(
                          width: 2,
                        )),
                    Expanded(
                      flex: 6,
                      child: slideIndex == 2
                          ? ZakiPrimaryButton(
                              title: 'Let’s Start',
                              width: width,
                              onPressed: () {
                                // if (appConstants.isUserPinUser != null &&
                                //     appConstants.isUserPinUser!) {
                                //   // Navigator.push(
                                //   //     context,
                                //   //     MaterialPageRoute(
                                //   //         builder: (context) =>
                                //   //             const KidsHomeScreen()));
                                // } else if (appConstants.kidsSignUpFirstTime) {
                                //   // Navigator.push(
                                //   //     context,
                                //   //     MaterialPageRoute(
                                //   //         builder: (context) =>
                                //   //             const KidsHomeScreen()));
                                // } else {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomeScreen()));
                                // }
                              })
                          : ZakiPrimaryButton(
                              title: 'Next',
                              width: width,
                              // backGroundColor: white,
                              backgroundTransparent: 1,
                              textColor: green,
                              borderColor: green,
                              onPressed: () {
                                if (slideIndex < 2) {
                                  setState(() {
                                    slideIndex = slideIndex + 1;
                                    controller.jumpToPage(slideIndex);
                                  });
                                }
                              }),
                    ),
                  ],
                ),
                spacing_medium
              ],
            ),
          ),
        ),
      ),
    );
  }
}
