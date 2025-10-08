// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:zaki/Constants/AppConstants.dart';
import 'package:zaki/Constants/HelperFunctions.dart';
import 'package:zaki/Constants/Whitelable.dart';
import 'package:zaki/Screens/AddMembersWorkFlow.dart';
import 'package:zaki/Screens/FundMyWallet.dart';
import 'package:zaki/Screens/PayOrRequestScreen.dart';

import '../Constants/Spacing.dart';
import '../Constants/Styles.dart';
import '../Screens/Socialize.dart';
import '../Screens/HomeScreen.dart';
import 'AppBars/AppBar.dart';
import 'TextHeader.dart';
import 'ZakiPrimaryButton.dart';

// lottie, provider,

class CustomConfermationScreen extends StatefulWidget {
  final String? imageUrl;
  final String? title;
  final String? subTitle;
  final bool? fromCreateUser;
  final bool? fromSubscription;
  final bool? fromSubScriptionRenew;
  final Widget? subscriptionUI;
  CustomConfermationScreen(
      {Key? key,
      this.imageUrl,
      this.subTitle,
      this.title,
      this.fromCreateUser,
      this.fromSubscription,
      this.subscriptionUI,
      this.fromSubScriptionRenew
      })
      : super(key: key);

  @override
  State<CustomConfermationScreen> createState() =>
      _CustomConfermationScreenState();
}

class _CustomConfermationScreenState extends State<CustomConfermationScreen> {

@override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // add setCurrentScreeninstead of initState because might not always give you the
    // expected results because initState() is called before the widget
    // is fully initialized, so the screen might not be visible yet.
    setScreenName(name: AppConstants.MISSION_ACCOMPLISHED);
  }

  @override
  void initState() {
    super.initState();
    if (widget.fromCreateUser != null) {
      Future.delayed(Duration(seconds: 10), () {
        var appConstants = Provider.of<AppConstants>(context, listen: false);

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => widget.fromSubScriptionRenew == true?
                HomeScreen():
                 widget.fromSubscription == true
                    ? AddMemberWorkFlow()
                    : checkUserEqual(appConstants)
                        ? FundMyWallet()
                        : PayOrRequestScreen()));
      });
    }
    if (widget.fromSubscription == true) {
      Future.delayed(Duration(seconds: 5), () {
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => widget.fromSubScriptionRenew == true?
                HomeScreen() : AddMemberWorkFlow()));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var appConstants = Provider.of<AppConstants>(context, listen: true);
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: getCustomPadding(),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  appBarHeader_001(
                      context: context,
                      height: height,
                      width: width,
                      leadingIcon: false,
                      needSpaceUnderDivider: false
                      // needLogo: false
                      ),
                  spacing_medium,
                  // Container(
                  //   decoration: BoxDecoration(
                  //     image: DecorationImage(
                  //       fit: BoxFit.cover,
                  //       image: AssetImage(imageBaseAddress+ 'mission_accomplished_header.png')
                  //     )
                  //   ),
                  // child:
                  Center(
                    child: Text(
                      'Mission\nAccomplished',
                      style: appBarTextStyle(context, width),
                      textAlign: TextAlign.center,
                    ),
                    // ),
                  ),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      // Lottie.asset(
                      //   'assets/animations/success.json',
                      //   // height: 200,
                      //   width: width,
                      //   repeat: true,
                      //   // reverse: true,
                      //   fit: BoxFit.cover,

                      // ),
                      Lottie.asset('assets/animations/party.json',
                          height: 380,
                          width: width,
                          repeat: true,
                          animate: true,

                          // frameRate: FrameRate(2),
                          // addRepaintBoundary: false,
                          // options: LottieOptions(
                          //   enableMergePaths: true
                          // ),
                          // reverse: true,
                          fit: BoxFit.cover),
                      Image.asset(
                        APPLICATION_SUCCESS_MISSION_ACCOMPLISHED_IMAGE,
                          ),
                      CircleAvatar(
                        maxRadius: width * 0.22,
                        backgroundColor: transparent,
                        child: (widget.imageUrl == null ||
                                widget.imageUrl!.contains('assets/images/'))
                            ? ClipOval(
                                child: Image.asset(widget.imageUrl != null
                                    ? widget.imageUrl!
                                    : APPLICATION_SUCCESS_BOY_IMAGE))
                            : ClipOval(
                                child: Image.network(
                                widget.imageUrl.toString(),
                              )),
                      )
                      // Positioned()
                    ],
                  ),
                  // spacing_large,
                  if (widget.title != null)
                    TextHeader1(
                      title: widget.title != null
                          ? widget.title
                          : 'Allowance Updated',
                    ),
                  if (widget.subTitle != null) spacing_medium,
                  if (widget.subTitle != null)
                    Text(
                      widget.subTitle.toString(),
                      style: textStyleHeading2(context, width),
                      textAlign: TextAlign.center,
                    ),
                  spacing_medium,
                  widget.fromCreateUser != null
                      ? ZakiPrimaryButton(
                          title: 'Next',
                          width: width,
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        checkUserEqual(appConstants)
                                            ? FundMyWallet()
                                            : PayOrRequestScreen()));
                          },
                        )
                      : widget.subscriptionUI != null
                          ? widget.subscriptionUI!
                          : Column(
                              children: [
                                ZakiPrimaryButton(
                                  title: 'Friends Activities',
                                  width: width,
                                  onPressed: () {
                                    Navigator.pop(context);
                                    Future.delayed(Duration.zero, (){
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const AllActivities()),
                                                result: true
                                                );
                                    });
                                    
                                  },
                                ),
                                spacing_medium,
                                ZakiPrimaryButton(
                                  title: 'Home',
                                  width: width,
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                HomeScreen()));
                                  },
                                ),
                              ],
                            ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
