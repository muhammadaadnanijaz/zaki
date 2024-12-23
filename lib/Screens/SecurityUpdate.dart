// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import '../Constants/AppConstants.dart';
// import '../Constants/Styles.dart';

// class SecurityUpdate extends StatefulWidget {
//   const SecurityUpdate({Key? key}) : super(key: key);

//   @override
//   _SecurityUpdateState createState() => _SecurityUpdateState();
// }

// class _SecurityUpdateState extends State<SecurityUpdate> {
//   @override
//   Widget build(BuildContext context) {
//     var appConstants = Provider.of<AppConstants>(context, listen: true);
//     var height = MediaQuery.of(context).size.height;
//     var width = MediaQuery.of(context).size.width;
//     return Scaffold(
//       appBar: AppBar(
//         title: InkWell(
//             onTap: () {
//               // Navigator.push(context, MaterialPageRoute(builder: (context)=>GetContacts()));
//             },
//             child: Text(
//               'Security',
//               style: textStyleHeading1WithTheme(context, width * 0.8,
//                   whiteColor: 0),
//             )),
//         centerTitle: true,
//         backgroundColor: transparent,
//         elevation: 0,
//         leading: IconButton(
//           icon: (Icon(
//             Icons.arrow_back,
//             color: black,
//           )),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               SizedBox(
//                 height: height * 0.02,
//               ),
//               ListTile(
//                 title: Text(
//                   'Face ID',
//                   style: textStyleHeading1WithTheme(context, width * 0.8,
//                       whiteColor: 0),
//                 ),
//                 subtitle: Text(
//                   'Enable Face ID for Faster Login.',
//                   style: textStyleHeading2WithTheme(context, width * 0.7,
//                       whiteColor: 0),
//                 ),
//                 trailing: CupertinoSwitch(
//                   value: appConstants.notificationAllow,
//                   activeColor: black,
//                   trackColor: primaryButtonColor,
//                   onChanged: (value) {
//                     appConstants.updateNotificationAllow(value);
//                   },
//                 ),
//               ),
//               const Divider(),
//               ListTile(
//                 title: Text(
//                   'User your PIN',
//                   style: textStyleHeading1WithTheme(context, width * 0.8,
//                       whiteColor: 0),
//                 ),
//                 subtitle: Text(
//                   'Next time, log in faster using your PIN',
//                   style: textStyleHeading2WithTheme(context, width * 0.7,
//                       whiteColor: 0),
//                 ),
//                 trailing: CupertinoSwitch(
//                   value: appConstants.notificationAllow,
//                   activeColor: black,
//                   trackColor: primaryButtonColor,
//                   onChanged: (value) {
//                     appConstants.updateNotificationAllow(value);
//                   },
//                 ),
//               ),
//               const Divider(),
//               ListTile(
//                   title: Text(
//                     'Change your PIN',
//                     style: textStyleHeading1WithTheme(context, width * 0.8,
//                         whiteColor: 0),
//                   ),
//                   subtitle: Text(
//                     'Reset your login PIN code',
//                     style: textStyleHeading2WithTheme(context, width * 0.7,
//                         whiteColor: 0),
//                   ),
//                   trailing: Icon(
//                     Icons.arrow_forward_ios,
//                     size: width * 0.05,
//                   )),
//               const Divider(),
//               ListTile(
//                 title: Text(
//                   'Extend your login session',
//                   style: textStyleHeading1WithTheme(context, width * 0.8,
//                       whiteColor: 0),
//                 ),
//                 subtitle: Text(
//                   'Your account is eligible for longer logged - in session for activies you do often.',
//                   style: textStyleHeading2WithTheme(context, width * 0.7,
//                       whiteColor: 0),
//                 ),
//                 trailing: CupertinoSwitch(
//                   value: appConstants.notificationAllow,
//                   activeColor: black,
//                   trackColor: primaryButtonColor,
//                   onChanged: (value) {
//                     appConstants.updateNotificationAllow(value);
//                   },
//                 ),
//               ),
//               const Divider()
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
