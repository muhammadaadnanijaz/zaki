// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:zaki/Constants/Styles.dart';

// class MoveMoneyFrom extends StatefulWidget {
//   const MoveMoneyFrom({Key? key}) : super(key: key);

//   @override
//   _MoveMoneyFromState createState() => _MoveMoneyFromState();
// }

// class _MoveMoneyFromState extends State<MoveMoneyFrom> {
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
//           'Move Money From',
//           style:
//               textStyleHeading1WithTheme(context, width * 0.85, whiteColor: 0),
//         ),
//       ),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(
//             height: height * 0.01,
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   '[Kids Name] Account',
//                   style: textStyleHeading1WithTheme(context, width * 0.75,
//                       whiteColor: 0),
//                 ),
//                 ListTile(
//                   leading: CircleAvatar(
//                     backgroundColor: grey,
//                     radius: width * 0.07,
//                     child: Padding(
//                       padding: EdgeInsets.all(8.0),
//                       child: Icon(
//                         FontAwesomeIcons.piggyBank,
//                         color: white,
//                       ),
//                     ),
//                   ),
//                   title: Text(
//                     'Spend Anywhere',
//                     style: textStyleHeading1WithTheme(context, width * 0.75,
//                         whiteColor: 0),
//                   ),
//                   subtitle: Text(
//                     '${getCurrencySymbol(context, appConstants: appConstants)}1 Balance',
//                     style: textStyleHeading2WithTheme(context, width * 0.6,
//                         whiteColor: 2),
//                   ),
//                 )
//               ],
//             ),
//           ),
//           const Divider(),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   '[Parent’s Name} Account',
//                   style: textStyleHeading1WithTheme(context, width * 0.75,
//                       whiteColor: 0),
//                 ),
//                 ListTile(
//                   leading: CircleAvatar(
//                     backgroundColor: grey,
//                     radius: width * 0.07,
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 0),
//                       child: Icon(
//                         FontAwesomeIcons.piggyBank,
//                         color: white,
//                       ),
//                     ),
//                   ),
//                   title: Text(
//                     'Dad',
//                     style: textStyleHeading1WithTheme(context, width * 0.75,
//                         whiteColor: 0),
//                   ),
//                 ),
//                 ListTile(
//                   leading: CircleAvatar(
//                     backgroundColor: grey,
//                     radius: width * 0.07,
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 0),
//                       child: Icon(
//                         // ignore: deprecated_member_use
//                         FontAwesomeIcons.userFriends,
//                         color: white,
//                       ),
//                     ),
//                   ),
//                   title: Text(
//                     'Mom',
//                     style: textStyleHeading1WithTheme(context, width * 0.75,
//                         whiteColor: 0),
//                   ),
//                 )
//               ],
//             ),
//           ),
//           const Divider(),
//         ],
//       ),
//     );
//   }
// }
