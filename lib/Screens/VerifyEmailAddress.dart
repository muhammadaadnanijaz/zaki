// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:zaki/Screens/WelcomeEmail.dart';
// import 'package:zaki/Widgets/ZakiPrimaryButton.dart';

// import '../Constants/AppConstants.dart';
// import '../Constants/Styles.dart';

// class VerifyEmailAddress extends StatefulWidget {
//   const VerifyEmailAddress({Key? key}) : super(key: key);

//   @override
//   _VerifyEmailAddressState createState() => _VerifyEmailAddressState();
// }

// class _VerifyEmailAddressState extends State<VerifyEmailAddress> {
//   @override
//   Widget build(BuildContext context) {
//     var appConstants = Provider.of<AppConstants>(context, listen: true);
//     var height = MediaQuery.of(context).size.height;
//     var width = MediaQuery.of(context).size.width;
//     return Scaffold(
//       appBar: AppBar(
//         actions: [
//           TextButton(
//             child: Text(
//               'Skip',
//               style: textStyleHeading2WithTheme(context, width * 0.7,
//                   whiteColor: 3),
//             ),
//             onPressed: () {},
//           )
//         ],
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
//       ),
//       body: SizedBox(
//         height: height,
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               Icon(
//                 Icons.email,
//                 color: grey,
//                 size: width * 0.35,
//               ),
//               Center(
//                 child: Column(
//                   children: [
//                     Text(
//                       'Verify your Email',
//                       style: textStyleHeading1WithTheme(context, width * 0.9,
//                           whiteColor: 0),
//                     ),
//                     Text(
//                       'confirmation code has been emailed.',
//                       style: textStyleHeading2WithTheme(context, width * 0.8,
//                           whiteColor: 0),
//                     )
//                   ],
//                 ),
//               ),
//               SizedBox(
//                 height: height * 0.02,
//               ),
//               Padding(
//                 padding: EdgeInsets.symmetric(horizontal: width * 0.08),
//                 child: TextFormField(
//                   validator: (String? email) {
//                     if (email!.isEmpty) {
//                       return 'Please Enter Email';
//                     } else {
//                       return null;
//                     }
//                   },
//                   // style: TextStyle(color: primaryColor),
//                   style: textStyleHeading2WithTheme(context, width * 0.8,
//                       whiteColor: 0),
//                   // controller: emailCotroller,
//                   obscureText: false,
//                   keyboardType: TextInputType.emailAddress,
//                   maxLines: 1,
//                   decoration: InputDecoration(
//                     hintText: 'Enter Verification Code',
//                     hintStyle: textStyleHeading2WithTheme(context, width * 0.8,
//                         whiteColor: 2),
//                     // labelText: 'Enter Email',
//                     // labelStyle: textStyleHeading2WithTheme(context,width*0.8, whiteColor: 0),
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: EdgeInsets.symmetric(vertical: width * 0.1),
//                 child: Column(
//                   children: [
//                     Text(
//                       '00:30',
//                       style: textStyleHeading2WithTheme(context, width * 0.8,
//                           whiteColor: 2),
//                     ),
//                     Text(
//                       'Didn’t receive code?',
//                       style: textStyleHeading2WithTheme(context, width * 0.8,
//                           whiteColor: 2),
//                     ),
//                     TextButton(
//                       child: Text(
//                         'Resend Code',
//                         style: textStyleHeading2WithTheme(context, width * 0.8,
//                             whiteColor: 0),
//                       ),
//                       onPressed: () {},
//                     )
//                   ],
//                 ),
//               ),
//               SizedBox(
//                 height: height * 0.02,
//               ),
//               Padding(
//                 padding: EdgeInsets.symmetric(horizontal: width * 0.08),
//                 child: Container(
//                   color: grey.withOpacity(0.2),
//                   width: width,
//                   child: Padding(
//                     padding: EdgeInsets.all(width * 0.04),
//                     child: Column(
//                       children: [
//                         Text(
//                           'Tip',
//                           style: textStyleHeading2WithTheme(context, width,
//                               whiteColor: 2),
//                         ),
//                         SizedBox(
//                           height: height * 0.01,
//                         ),
//                         Text(
//                           '1. Wait a few Minutes for the email to arrive.',
//                           style: textStyleHeading2WithTheme(
//                               context, width * 0.7,
//                               whiteColor: 0),
//                         ),
//                         Text(
//                           '2. Remember to Check your Junk/Spam Folder.',
//                           style: textStyleHeading2WithTheme(
//                               context, width * 0.7,
//                               whiteColor: 0),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 height: height * 0.1,
//               ),
//               Padding(
//                 padding: EdgeInsets.symmetric(horizontal: width * 0.08),
//                 child: ZakiPrimaryButton(
//                     title: 'Get Started',
//                     width: width,
//                     onPressed: () {
//                       appConstants.updateIsEmailVerfied(true);
//                       Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) => const WelcomeEmail()));
//                     }),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
