// // ignore_for_file: file_names

// import 'package:flutter/material.dart';
// import 'package:zaki/Screens/UpdatePasswordScreen.dart';
// import 'package:zaki/Widgets/ZakiPrimaryButton.dart';
// import '../Constants/Styles.dart';

// class ForgetVerifyEmailCode extends StatefulWidget {
//   const ForgetVerifyEmailCode({Key? key}) : super(key: key);

//   @override
//   _ForgetVerifyEmailCodeState createState() => _ForgetVerifyEmailCodeState();
// }

// class _ForgetVerifyEmailCodeState extends State<ForgetVerifyEmailCode> {
//   final formGlobalKey = GlobalKey<FormState>();
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
//       ),
//       body: SizedBox(
//         height: height,
//         child: SingleChildScrollView(
//           child: Form(
//             key: formGlobalKey,
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   Center(
//                     child: Icon(
//                       Icons.email,
//                       color: grey,
//                       size: width * 0.35,
//                     ),
//                   ),
//                   Text(
//                     'Enter\nCode Sent to your email',
//                     style: textStyleHeading1WithTheme(context, width * 0.9,
//                         whiteColor: 0),
//                   ),
//                   SizedBox(
//                     height: height * 0.02,
//                   ),
//                   TextFormField(
//                     autovalidateMode: AutovalidateMode.onUserInteraction,
//                     validator: (String? email) {
//                       if (email!.isEmpty) {
//                         return 'Please Enter Email';
//                       } else {
//                         return null;
//                       }
//                     },
//                     // style: TextStyle(color: primaryColor),
//                     style: textStyleHeading2WithTheme(context, width * 0.8,
//                         whiteColor: 0),
//                     // controller: emailCotroller,
//                     obscureText: false,
//                     keyboardType: TextInputType.emailAddress,
//                     maxLines: 1,
//                     decoration: InputDecoration(
//                       hintText: 'Enter Verification Code',
//                       hintStyle: textStyleHeading2WithTheme(
//                           context, width * 0.8,
//                           whiteColor: 2),
//                       // labelText: 'Enter Email',
//                       // labelStyle: textStyleHeading2WithTheme(context,width*0.8, whiteColor: 0),
//                     ),
//                   ),
//                   Center(
//                     child: Padding(
//                       padding: EdgeInsets.symmetric(vertical: width * 0.1),
//                       child: Column(
//                         children: [
//                           Text(
//                             '00:30',
//                             style: textStyleHeading2WithTheme(
//                                 context, width * 0.8,
//                                 whiteColor: 2),
//                           ),
//                           Text(
//                             'Didn’t receive code?',
//                             style: textStyleHeading2WithTheme(
//                                 context, width * 0.8,
//                                 whiteColor: 2),
//                           ),
//                           TextButton(
//                             child: Text(
//                               'Resend Code',
//                               style: textStyleHeading2WithTheme(
//                                   context, width * 0.8,
//                                   whiteColor: 0),
//                             ),
//                             onPressed: () {},
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
//                   SizedBox(
//                     height: height * 0.01,
//                   ),
//                   Padding(
//                     padding: EdgeInsets.symmetric(horizontal: width * 0.08),
//                     child: Container(
//                       color: grey.withOpacity(0.2),
//                       width: width,
//                       child: Padding(
//                         padding: EdgeInsets.all(width * 0.04),
//                         child: Column(
//                           children: [
//                             Text(
//                               'Tip',
//                               style: textStyleHeading2WithTheme(context, width,
//                                   whiteColor: 2),
//                             ),
//                             SizedBox(
//                               height: height * 0.01,
//                             ),
//                             Text(
//                               '1. Wait a few Minutes for the email to arrive.',
//                               style: textStyleHeading2WithTheme(
//                                   context, width * 0.7,
//                                   whiteColor: 0),
//                             ),
//                             Text(
//                               '2. Remember to Check your Junk/Spam Folder.',
//                               style: textStyleHeading2WithTheme(
//                                   context, width * 0.7,
//                                   whiteColor: 0),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                   SizedBox(
//                     height: height * 0.04,
//                   ),
//                   Padding(
//                     padding: EdgeInsets.symmetric(horizontal: width * 0.08),
//                     child: ZakiPrimaryButton(
//                         title: 'Continue',
//                         width: width,
//                         onPressed: () {
//                           Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (context) =>
//                                       const UpdatePasswordScreen()));
//                         }),
//                   )
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
