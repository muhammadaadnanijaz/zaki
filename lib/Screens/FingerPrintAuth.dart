// // ignore_for_file: file_names

// import 'package:flutter/material.dart';
// import 'package:zaki/Constants/Styles.dart';
// import 'package:zaki/Widgets/ZakiPrimaryButton.dart';

// class FingerPrintAuth extends StatefulWidget {
//   const FingerPrintAuth({Key? key}) : super(key: key);

//   @override
//   _FingerPrintAuthState createState() => _FingerPrintAuthState();
// }

// class _FingerPrintAuthState extends State<FingerPrintAuth> {
//   @override
//   Widget build(BuildContext context) {
//     // var appConstants = Provider.of<AppConstants>(context, listen: true);
//     var height = MediaQuery.of(context).size.height;
//     var width = MediaQuery.of(context).size.width;
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Biometric',
//           style: textStyleHeading1WithTheme(context, width, whiteColor: 0),
//         ),
//         backgroundColor: white,
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
//       body: SafeArea(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Center(
//               child: Icon(
//                 Icons.fingerprint,
//                 size: height * 0.15,
//               ),
//             ),
//             SizedBox(
//               height: height * 0.05,
//             ),
//             Text(
//               'Enable Biometric',
//               style: textStyleHeading1WithTheme(context, width, whiteColor: 0),
//             ),
//             Text(
//               '(Face ID / Fingerprint)',
//               style: textStyleHeading1WithTheme(context, width, whiteColor: 0),
//             ),
//             SizedBox(
//               height: height * 0.03,
//             ),
//             Text(
//               'Set Biometric for Easier future login',
//               style: textStyleHeading2WithTheme(context, width, whiteColor: 0),
//             ),
//             SizedBox(
//               height: height * 0.03,
//             ),
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: width * 0.1),
//               child: ZakiPrimaryButton(
//                   title: 'Enable', width: width, onPressed: () async {}),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
