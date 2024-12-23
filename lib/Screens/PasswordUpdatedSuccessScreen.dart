// import 'package:flutter/material.dart';
// import 'package:zaki/Constants/Styles.dart';
// import 'package:zaki/Screens/LoginScreen.dart';
// import 'package:zaki/Widgets/ZakiPrimaryButton.dart';

// class PasswordUpdatedSuccessScreen extends StatefulWidget {
//   const PasswordUpdatedSuccessScreen({Key? key}) : super(key: key);

//   @override
//   _PasswordUpdatedSuccessScreenState createState() =>
//       _PasswordUpdatedSuccessScreenState();
// }

// class _PasswordUpdatedSuccessScreenState
//     extends State<PasswordUpdatedSuccessScreen> {
//   @override
//   Widget build(BuildContext context) {
//     // var height = MediaQuery.of(context).size.height;
//     var width = MediaQuery.of(context).size.width;
//     return Scaffold(
//       body: Column(
//         children: [
//           Expanded(
//               child: Center(
//                   child: Text(
//             'Password Updated!',
//             style: textStyleHeading1WithTheme(context, width, whiteColor: 0),
//           ))),
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: width * 0.1, vertical: 5),
//             child: ZakiPrimaryButton(
//                 title: 'Login',
//                 width: width,
//                 onPressed: () {
//                   Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => const LoginScreen()));
//                 }),
//           )
//         ],
//       ),
//     );
//   }
// }
