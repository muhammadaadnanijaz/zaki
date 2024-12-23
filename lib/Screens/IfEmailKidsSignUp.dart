// // ignore_for_file: file_names

// import 'package:flutter/material.dart';

// import '../Constants/Styles.dart';

// class IfEmailKidsSignUp extends StatefulWidget {
//   const IfEmailKidsSignUp({Key? key}) : super(key: key);

//   @override
//   State<IfEmailKidsSignUp> createState() => _IfEmailKidsSignUpState();
// }

// class _IfEmailKidsSignUpState extends State<IfEmailKidsSignUp> {
//   @override
//   Widget build(BuildContext context) {
//     // var appConstants = Provider.of<AppConstants>(context, listen: true);
//     var height = MediaQuery.of(context).size.height;
//     var width = MediaQuery.of(context).size.width;
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'if email',
//           style:
//               textStyleHeading1WithTheme(context, width * 0.8, whiteColor: 0),
//         ),
//         centerTitle: true,
//         backgroundColor: transparent,
//         elevation: 0,
//         leading: IconButton(
//           icon: (Icon(
//             Icons.clear,
//             color: black,
//           )),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Fawzi will receive an invite  to complete sign up process\nAsk them to check Junk/Spam mail \nAsk them to customize the app by adding Goals, updating their profile, add fun images and logos',
//               style: textStyleHeading2WithTheme(context, width * 0.7,
//                   whiteColor: 2),
//             ),
//             SizedBox(
//               height: height * 0.1,
//             ),
//             Text(
//               'Send an email with a TEMP Password \n\nwhen logging in we will prompt to update password',
//               style: textStyleHeading1WithTheme(context, width * 0.7,
//                   whiteColor: 0),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
