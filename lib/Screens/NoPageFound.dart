import 'package:flutter/material.dart';
import 'package:zaki/Screens/HomeScreen.dart';
import 'package:zaki/Widgets/TextHeader.dart';
import 'package:zaki/Widgets/ZakiPrimaryButton.dart';

import '../Constants/Styles.dart';
import '../Widgets/CustomSizedBox.dart';

class NoPageFound extends StatefulWidget {
  const NoPageFound({Key? key}) : super(key: key);

  @override
  State<NoPageFound> createState() => _NoPageFoundState();
}

class _NoPageFoundState extends State<NoPageFound> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(width: width),
            Image.asset(imageBaseAddress + 'issue_report_successfully.png'),
            CustomSizedBox(
              height: height,
            ),
            TextHeader1(
              title: 'Ouch---Dead End :(',
            ),
            CustomSizedBox(
              height: height,
            ),
            TextValue2(
              title: 'Sorry.... this page no longer exists.',
            ),
            CustomSizedBox(
              height: height,
            ),
            ZakiPrimaryButton(
              title: 'Home',
              width: width,
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomeScreen()));
              },
            ),
            CustomSizedBox(
              height: height,
            ),
            ZakiPrimaryButton(
              title: 'Friends',
              width: width,
              onPressed: () {},
            )
          ],
        ),
      ),
    );
  }
}
