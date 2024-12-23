import 'dart:async';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zaki/Constants/CheckInternetConnections.dart';
import 'package:zaki/Constants/HelperFunctions.dart';
import 'package:zaki/Constants/Styles.dart';
import 'package:zaki/Screens/LoginWithPinCode.dart';
import 'package:zaki/Screens/WhatsAppLoginScreen.dart';
import 'package:zaki/Screens/WhoLogin.dart';
import 'package:zaki/Services/api.dart';
import '../Constants/AppConstants.dart';
import '../Services/SharedPrefMnager.dart';
import 'WhatsAppSignUpScreen.dart';

// ignore: must_be_immutable
class SplashScreen extends StatefulWidget {
 GlobalKey<NavigatorState>? navigatorKey = GlobalKey<NavigatorState>();
  SplashScreen({Key? key, this.navigatorKey}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late VideoPlayerController _controller;
  DateTime? lastQuitTime = DateTime.now();
  bool isExpired = false;

  @override
  void initState() {
    loadUserVideo();
    getUserData();
    userCheckTimeOut();
//     Future.delayed(const Duration(seconds: 2),(){
//       Navigator.push(
//   context,
//   PageRouteBuilder(
//     transitionDuration: const Duration(seconds: 2),
//     pageBuilder: (_, __, ___) => const ChooseLoginType(),
//   ),
// );
//     });
    super.initState();
  }

  loadUserVideo() {
    _controller = VideoPlayerController.asset(
      imageBaseAddress + 'intro_video.mp4',
      // 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
      // videoPlayerOptions: VideoPlayerOptions(allowBackgroundPlayback: true)
    )..initialize().then((_) {
        _controller.play();
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
    _controller.setLooping(true);
    // _controller.addListener(() {
    // });
  }

  @override
  void dispose() {
    _controller.pause();
    _controller.dispose();
    super.dispose();
  }
  closeVideo(){
    _controller.pause();
    // _controller.dispose();
  }

  userCheckTimeOut() {
    Timer(Duration(seconds: 8), () {
      if (mounted)
        setState(() {
          isExpired = true;
        });
    });
  }

  void getUserData() async {
    var appConstants = Provider.of<AppConstants>(context, listen: false);
    UserPreferences userPref = UserPreferences();
    String? currentUserId = await userPref.getCurrentUserId();
    int? themeId = await userPref.getThemeData();
    if (themeId != null) {
      appConstants.updateTheme(themeId);
      showNotification(
          error: 0, icon: Icons.check, message: themeId.toString());
    }
    if (currentUserId != null) {
      ApiServices service = ApiServices();
      await service.storingFirebaseToken(id: currentUserId);
      appConstants.updateUserId(currentUserId);
      await service.getUserData(
          userId: await userPref.getCurrentUserId(), context: context);
      Future.delayed(const Duration(seconds: 2), () {
        logMethod(
            title: 'Username and isEnabed Status is',
            message:
                '${appConstants.userModel.usaFirstName} & ${appConstants.userModel.usaIsenable}');
        //  if (appConstants.userModel.usaIsenable!=null && appConstants.userModel.usaIsenable!) {
        if (appConstants.userModel.usaIsenable != null &&
            !appConstants.userModel.usaIsenable!) {
          if (appConstants.userModel.isUserPinUser != null &&
              appConstants.userModel.isUserPinUser!) {
            // closeVideo();
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const WhoIsLoginWithPin()));
            return;
          }
          logMethod(
              title: 'True condition Username and isEnabed Status is',
              message:
                  '${appConstants.userModel.usaFirstName} & ${appConstants.userModel.usaIsenable}');
          // appConstants.updateAccountSettingUpFor('Me');
          // Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //         builder: (context) => const AccountSetupAsAkid()));
           if (appConstants.userModel.usaPinCode == '') {
            appConstants.updateFirstName(appConstants.userModel.usaFirstName);
            appConstants.updateLastName(appConstants.userModel.usaLastName);
            appConstants.updateZipCode(appConstants.userModel.zipCode);
            appConstants.updateDateOfBirth(appConstants.userModel.usaDob!);
            appConstants
                .updatePhoneNumber(appConstants.userModel.usaPhoneNumber);
            appConstants.updateEmail(appConstants.userModel.usaEmail);
            appConstants.updateUserName(appConstants.userModel.usaUserName);
            appConstants.updatePin('');
            // appConstants.updateUserName('');
            // appConstants.updatePhoneNumber('');
            // appConstants.updateAccountSettingUpFor('Me');
            //////Commeted New after new Faluire process
            // Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //         builder: (context) => const WhosSettingsUp()));
            //////////////End commented new
            closeVideo();
            Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const WhatsAppLoginScreen()));
          } else{
            closeVideo();
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginWithPinCode(),
                ), 
                // (route) => false,
                );
          }
        } else {
          closeVideo();
          if(appConstants.userModel.userFullyRegistered==true){
            Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginWithPinCode(),
                    ), 
                    // (route) => false,
                    );
          } else{
            Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const WhatsAppLoginScreen()));
          }
        }
      });
    } else {
      Future.delayed(const Duration(seconds: 5), () {
        // Navigator.push(
        //   context,
        //   PageRouteBuilder(
        //     transitionDuration: const Duration(seconds: 2),
        //     pageBuilder: (_, __, ___) => const ChooseLoginType(),
        //   ),
        // );
        // appConstants.updateSignUpMethod('WhatsApp');
        closeVideo();
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const WhatsAppSignUpScreen()));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    var appConstants = Provider.of<CheckInternet>(context, listen: true);
    appConstants.checkRealtimeConnection();
    // Offline
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              height: height,
              width: width,
              // decoration: BoxDecoration(
              //     image: DecorationImage(
              //   image: AssetImage(
              //     imageBaseAddress + "Splash_gif.gif",
              //   ),
              //   // filterQuality: FilterQuality.high,
              //   fit: BoxFit.contain,
              // )
              // ),
              child: _controller.value.isInitialized
                  ? AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(
                        _controller,
                      ),
                    )
                  : Container(),

              // child: Image.asset(

              // ),
            ),
            // Align(
            //   alignment: Alignment.center,
            //   child: Center(
            //     child: Image.asset(imageBaseAddress + 'loading_logo.gif'),
            //   ),
            // )
            if (isExpired)
              Align(
                alignment: Alignment.bottomCenter,
                child: InkWell(
                  onTap: () {
                    UserPreferences userPref = UserPreferences();
                    userPref.clearLoggedInUser();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const WhatsAppSignUpScreen(),
                        ));
                  },
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                    child: Text(
                      'Skip Intro!',
                      style: heading1TextStyle(context, width * 0.7),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
