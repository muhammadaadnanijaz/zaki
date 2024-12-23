import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../Constants/HelperFunctions.dart';
import '../Constants/Styles.dart';
import '../Screens/Socialize.dart';
import '../Screens/HomeScreen.dart';
import '../Screens/PayOrRequestScreen.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int? index;
  const CustomBottomNavigationBar({Key? key, this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      backgroundColor: transparent,
      color: green,
      index: index ?? 0,
      // animationDuration: Duration(milliseconds: 200),
      items: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.home,
              size: 30,
              color: white,
            ),
            // Text(
            //   'Home',
            //   style: heading3TextStyle(width, color: white),
            // )
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              FontAwesomeIcons.arrowRightArrowLeft,
              size: 25,
              color: white,
            ),
            // Text(
            //   'Send or Request',
            //   style: heading3TextStyle(width, color: white),
            // )
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.people_sharp,
              size: 30,
              color: white,
            ),
            // Text(
            //   'Friends',
            //   style: heading3TextStyle(width, color: white),
            // )
          ],
        ),
      ],
      onTap: (index) {
        logMethod(title: 'Index', message: index.toString());
        if (index == 0) {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const HomeScreen()));
        } else if (index == 1) {
          Future.delayed(
              Duration(
                milliseconds: 500,
              ), () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const PayOrRequestScreen(
                          leadingIconRequired: false,
                        )));
          });
        } else if (index == 2) {
          Future.delayed(
              Duration(
                milliseconds: 500,
              ), () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AllActivities(
                          leadingIconRequired: false,
                        )));
          });
        }
        //Handle button tap
      },
    );
  }
}
