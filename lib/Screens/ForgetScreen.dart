// // ignore_for_file: file_names

// import 'package:flutter/material.dart';
// import 'package:zaki/Screens/ForgetVerifyEmailCode.dart';
// import 'package:zaki/Widgets/ZakiPrimaryButton.dart';

// import '../Constants/Styles.dart';

// class ForgetScreen extends StatefulWidget {
//   const ForgetScreen({Key? key}) : super(key: key);

//   @override
//   _ForgetScreenState createState() => _ForgetScreenState();
// }

// class _ForgetScreenState extends State<ForgetScreen> {
//   final emailCotroller = TextEditingController();
//   final formGlobalKey = GlobalKey<FormState>();

//   @override
//   void dispose() {
//     emailCotroller.dispose();
//     super.dispose();
//   }

//   void clearFields() {
//     emailCotroller.text = '';
//   }

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
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//           child: Form(
//             key: formGlobalKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 SizedBox(
//                   height: height * 0.02,
//                 ),
//                 Text(
//                   'Forgot\nPassword',
//                   style:
//                       textStyleHeading1WithTheme(context, width, whiteColor: 0),
//                 ),
//                 SizedBox(
//                   height: height * 0.02,
//                 ),
//                 Text(
//                   'Use email you Signed Up with:',
//                   style: textStyleHeading2WithTheme(context, width * 0.8,
//                       whiteColor: 2),
//                 ),
//                 TextFormField(
//                   autovalidateMode: AutovalidateMode.onUserInteraction,
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
//                   controller: emailCotroller,
//                   obscureText: false,
//                   keyboardType: TextInputType.emailAddress,
//                   maxLines: 1,
//                   decoration: InputDecoration(
//                     hintText: 'Enter Email',
//                     hintStyle: textStyleHeading2WithTheme(context, width * 0.8,
//                         whiteColor: 2),
//                     // labelText: 'Enter Email',
//                     // labelStyle: textStyleHeading2WithTheme(context,width*0.8, whiteColor: 0),
//                   ),
//                 ),
//                 SizedBox(
//                   height: height * 0.4,
//                 ),
//                 ZakiPrimaryButton(
//                     title: 'Reset Password',
//                     width: width,
//                     onPressed: () {
//                       Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) =>
//                                   const ForgetVerifyEmailCode()));
//                     }),
//                 TextButton(
//                   child: Center(
//                       child: Text(
//                     'Cancel',
//                     style: textStyleHeading2WithTheme(context, width,
//                         whiteColor: 0),
//                   )),
//                   onPressed: () {},
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
