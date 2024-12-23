import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zaki/Constants/Spacing.dart';
import 'package:zaki/Constants/Styles.dart';
import 'package:zaki/Widgets/TextHeader.dart';

import '../Constants/AppConstants.dart';
import '../Widgets/AppBars/AppBar.dart';
import '../Widgets/SSLCustom.dart';
import 'AccountSetUpInformation.dart';

class WhosSettingsUp extends StatefulWidget {
  const WhosSettingsUp({Key? key}) : super(key: key);

  @override
  State<WhosSettingsUp> createState() => _WhosSettingsUpState();
}

class _WhosSettingsUpState extends State<WhosSettingsUp> {
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              appBarHeader_005(
                context: context,
                appBarTitle: '',
                height: height,
                width: width,
                leadingIcon: false,
                // tralingIconButton: 
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'I am a:',
                      style: appBarTextStyle(context, width),
                      ),
                      SSLCustom(),
                  ],
                ),
              ),
              // SizedBox(
              //   height: height * 0.0,
              // ),
              spacing_large,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SettingUpForWhoWidget(
                    imageUrl: 'my_family.png',
                    title: 'Dad or Mom',
                    onTap: () {
                      appConstants
                          .updateSignUpRole(AppConstants.USER_TYPE_PARENT);
                      appConstants.updateGenderType('Male');
                      appConstants.updateAccountSettingUpFor('Family');
                      appConstants.updateDateOfBirth('dd / mm / yyyy');
                      appConstants.updateHveKidsOrNot('No');
                      appConstants.updateDateOfBirthWithDate(null);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const AccountSetupInformation()));
                    },
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  SettingUpForWhoWidget(
                    imageUrl: 'for_me.png',
                    title: 'Single ',
                    subTitle: '(18+)',
                    onTap: () {
                      appConstants.updateAccountSettingUpFor('Me');
                      appConstants
                          .updateSignUpRole(AppConstants.USER_TYPE_SINGLE);
                      appConstants.updateGenderType('Male');
                      appConstants.updateDateOfBirth('dd / mm / yyyy');
                      appConstants.updateDateOfBirthWithDate(null);
                      appConstants.updateHveKidsOrNot('No');
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const AccountSetupInformation()));
                    },
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class SettingUpForWhoWidget extends StatelessWidget {
  const SettingUpForWhoWidget({Key? key, this.onTap, this.title, this.imageUrl, this.subTitle })
      : super(key: key);

  final String? title;
  final String? imageUrl;
  final String? subTitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: height * 0.25,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextValue2(
                      title: '$title',
                    ),
                    if(subTitle!=null)
                    Text(subTitle.toString(), style: heading4TextSmall(width, color: black),)
                  ],
                ),
              ),
            ],
          ),
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                    imageBaseAddress + "$imageUrl",
                  ),
                  fit: BoxFit.fill)),
        ),
      ),
    );
  }
}
