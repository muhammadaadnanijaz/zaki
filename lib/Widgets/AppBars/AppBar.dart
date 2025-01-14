
import 'package:flutter/material.dart';
import 'package:zaki/Constants/AppConstants.dart';
import 'package:zaki/Screens/HomeScreen.dart';
import 'package:zaki/Screens/SecretDebitCard.dart';
import '../../Constants/HelperFunctions.dart';
import '../../Constants/Spacing.dart';
import '../../Constants/Styles.dart';
import '../../Screens/EdittedProfile.dart';
import '../../Screens/GetStartedScreen.dart';
import '../../Screens/NotificationScreen.dart';
import '../../Screens/Settings.dart';
import 'package:badges/badges.dart' as badges;
import '../TextHeader.dart';

appBarHeader_001(
    {bool? needSpaceUnderDivider,
    bool? needLogo,
    double? width,
    double? height,
    required BuildContext context,
    bool? leadingIcon,
    VoidCallback? onTap,
    }) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      spacing_medium,
      needLogo == false ? spacing_medium : AppBarImageHeader(),
      spacing_medium,
      appBarDivider(),
      needSpaceUnderDivider == false ? const SizedBox.shrink() : spacing_medium,
      leadingIcon == false
          ? const SizedBox.shrink()
          : InkWell(
              onTap: onTap!=null?onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.clear,
                color: grey,
              ),
            ),
    ],
  );
}

appBarHeader_002(
    {double? width,
    double? height,
    BuildContext? context,
    AppConstants? appConstants,
    String? batch
    }) {
      // var appConstantss = Provider.of<AppConstants>(context!, listen: true);
  return Row(
    children: [
      Column(
        children: [
          spacing_medium,
        AppBarImageHeader(),
        spacing_medium,
        appBarDivider(),
        ],
      ),
      
      InkWell(
        onTap: (){
          logMethod(title: "Check Primary User", message: checkPrimaryUser(appConstants!).toString());
          Navigator.push(
                context!,
                MaterialPageRoute(
                    builder: (context) => const SecretDebitCard()
                    )
                    );
        },
        child: Text('        ')),
      const Spacer(),
      InkWell(
        onTap: (){
          Navigator.push(
                context!,
                MaterialPageRoute(
                    builder: (context) => const NotificationScreen()
                    )
                    );
            
        },
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: badges.Badge(
              badgeStyle: badges.BadgeStyle(
          badgeColor: green,
              ),
              showBadge: (batch=="0" || batch==null)?false:true,
              position: badges.BadgePosition.topStart(),
              badgeContent: Text('$batch', style: heading4TextSmall(250,color: white),),
              child: Icon(
                Icons.notifications_none,
                color: grey,
                // size: width!*0.08,
                // size: 25,
              ),
            ),
        ),
      ),
      // IconButton(
      //     icon: Icon(
      //       Icons.notifications_none,
      //       color: grey,
      //       size: 20,
      //     ),
      //     onPressed: () {
      //       Navigator.push(
      //           context!,
      //           MaterialPageRoute(
      //               builder: (context) => const NotificationScreen()));
      //     }),
      PopupMenuButton(
        shape: shape(),
        child: Center(
          child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Icon(
                Icons.menu,
                color: grey,
                // size: width*0.08,
                // size: 24,
              )),
        ),
        elevation: 20,
        enableFeedback: true,
        enabled: true,
        itemBuilder: (_) => <PopupMenuEntry>[
          PopupMenuItem(
              height: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                      onTap: () {
                        Navigator.pop(context!);
                      },
                      child: Icon(
                        Icons.clear,
                        color: black,
                        // size: 24,
                        // size: width! * 0.045,
                      )),
                ],
              )),
          PopupMenuItem(
            child: ListTile(
              onTap: () {
                Navigator.pop(context!);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const EdittedProfile()));
              },
              leading: Icon(
                Icons.person,
                color: black,
              ),
              title: Text('Profile'),
            ),
          ),
          PopupMenuItem(
            child: ListTile(
              onTap: () {
                Navigator.pop(context!);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SettingsMainScreen()));
              },
              leading: Icon(
                Icons.settings,
                color: black,
              ),
              title: Text('Settings'),
            ),
          ),
          PopupMenuItem(
            child: ListTile(
              onTap: () async {
                // bool screenNotOpen = await checkUserSubscriptionValue(appConstants!, context!);
                //                 if(screenNotOpen==false){
                logMethod(title: 'User Card Token', message: '${appConstants!.userModel.userTokenId}');
                // return;
                // bool? isExist =
               toUpMethodsBottomSheet(
                                                context: context!,
                                                height: height,
                                                width: width);
              
              
                // if (isExist!) {
                //   Navigator.push(
                //       context!,
                //       MaterialPageRoute(
                //           builder: (context) => const ManageLinkedCards()));
                //   return;
                // }
                // Navigator.push(
                //     context!,
                //     MaterialPageRoute(
                //         builder: (context) => FundMyWallet()));
                // cardBottomSheet(
                //     context: context, height: height, width: width);
                                // }
              },
              leading: Icon(
                Icons.account_balance_wallet,
                color: black,
              ),
              title: Text('Fund My Wallet'),
            ),
          ),
          
          // PopupMenuItem(
          //   child: StatefulBuilder(
          //               builder: (context, setState) {
          //    return 
          //             }
          //   ),
          // ),
        ],
      ),
    ],
  );
}

appBarHeader_005(
    {double? width,
    double? height,
    required BuildContext context,
    required String appBarTitle,
    bool? backArrow,
    bool? ownBackArrowTakeHomeScreen,
    IconData? rightSideAppbarIcon,
    bool? leadingIcon,
    bool? requiredHeader,
    bool? fromInviteScreen,
    PopupMenuButton? menuButton,
    Widget? tralingIconButton}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      requiredHeader==false? SizedBox():
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          spacing_medium,
          AppBarImageHeader(),
          spacing_medium,
          appBarDivider(),
        ],
      ),
      if (fromInviteScreen != true) spacing_medium,
      Row(
        children: [
          
          leadingIcon == false
              ? const SizedBox.shrink()
              : InkWell(
                  onTap: () {
                    if(ownBackArrowTakeHomeScreen==true){
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomeScreen()));
                      return;
                    }
                    Navigator.pop(context);
                  },
                  child: Icon(
                    backArrow == true ? Icons.arrow_back : Icons.clear,
                    color: darkGrey,
                  ),
                ),
          Expanded(
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if(rightSideAppbarIcon!=null)
                  Padding(
                    padding: const EdgeInsets.only(right: 6.0),
                    child: Icon(rightSideAppbarIcon, size: 20,),
                  ),
                  Text(
                    appBarTitle,
                    style: appBarTextStyle(context, width!),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          fromInviteScreen == true
              ? TextButton(
                  child: TextValue3(
                    title: 'Next',
                    // style: heading2TextStyle(context, width),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const GetStarted()));
                  },
                )
              : menuButton != null
                  ? menuButton
                  : tralingIconButton != null
                      ? tralingIconButton
                      : SizedBox(
                          width: 20,
                        )
        ],
      ),
      spacing_medium,
      spacing_small,
    ],
  );
}

Container appBarDivider() {
  return Container(
    height: 0.8,
    color: grey,
  );
}

class AppBarImageHeader extends StatelessWidget {
  const AppBarImageHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Image.asset(
      imageBaseAddress + "header_zakipay.png",
      height: height * 0.027,
    );
  }
}
