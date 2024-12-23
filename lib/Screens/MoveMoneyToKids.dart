// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:zaki/Constants/Styles.dart';

// class MoveMoneyToKids extends StatefulWidget {
//   const MoveMoneyToKids({Key? key}) : super(key: key);

//   @override
//   _MoveMoneyToKidsState createState() => _MoveMoneyToKidsState();
// }

// class _MoveMoneyToKidsState extends State<MoveMoneyToKids> {
//   @override
//   Widget build(BuildContext context) {
//     // var appConstants = Provider.of<AppConstants>(context, listen: true);
//     var height = MediaQuery.of(context).size.height;
//     var width = MediaQuery.of(context).size.width;
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           icon: Icon(
//             Icons.clear,
//             color: black,
//           ),
//         ),
//         backgroundColor: transparent,
//         elevation: 0,
//         title: Text(
//           'Move Money To',
//           style:
//               textStyleHeading1WithTheme(context, width * 0.85, whiteColor: 0),
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             SizedBox(
//               height: height * 0.01,
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Accounts',
//                     style: textStyleHeading1WithTheme(context, width * 0.75,
//                         whiteColor: 0),
//                   ),
//                   ListView.separated(
//                     itemCount: 3,
//                     shrinkWrap: true,
//                     physics: const NeverScrollableScrollPhysics(),
//                     separatorBuilder: (BuildContext context, int index) {
//                       return const Divider();
//                     },
//                     itemBuilder: (BuildContext context, int index) {
//                       return ListTile(
//                         leading: CircleAvatar(
//                           backgroundColor: grey,
//                           radius: width * 0.07,
//                           child: Padding(
//                             padding: EdgeInsets.all(8.0),
//                             child: Icon(
//                               FontAwesomeIcons.piggyBank,
//                               color: white,
//                             ),
//                           ),
//                         ),
//                         title: Text(
//                           'Spend Anywhere',
//                           style: textStyleHeading1WithTheme(
//                               context, width * 0.75,
//                               whiteColor: 0),
//                         ),
//                         subtitle: Text(
//                           '${getCurrencySymbol(context, appConstants: appConstants)}1 Balance',
//                           style: textStyleHeading2WithTheme(
//                               context, width * 0.6,
//                               whiteColor: 2),
//                         ),
//                       );
//                     },
//                   ),
//                   Text(
//                     'Your Spend Controls',
//                     style: textStyleHeading1WithTheme(context, width * 0.75,
//                         whiteColor: 0),
//                   ),
//                   ListView.separated(
//                     itemCount: 3,
//                     shrinkWrap: true,
//                     physics: const NeverScrollableScrollPhysics(),
//                     separatorBuilder: (BuildContext context, int index) {
//                       return const Divider();
//                     },
//                     itemBuilder: (BuildContext context, int index) {
//                       return ListTile(
//                         leading: CircleAvatar(
//                           backgroundColor: grey,
//                           radius: width * 0.07,
//                           child: Padding(
//                             padding: EdgeInsets.all(8.0),
//                             child: Icon(
//                               FontAwesomeIcons.piggyBank,
//                               color: white,
//                             ),
//                           ),
//                         ),
//                         title: Text(
//                           'Spend Anywhere',
//                           style: textStyleHeading1WithTheme(
//                               context, width * 0.75,
//                               whiteColor: 0),
//                         ),
//                         subtitle: Text(
//                           '${getCurrencySymbol(context, appConstants: appConstants)}1 Balance',
//                           style: textStyleHeading2WithTheme(
//                               context, width * 0.6,
//                               whiteColor: 2),
//                         ),
//                       );
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
