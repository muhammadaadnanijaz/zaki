// // ignore_for_file: file_names

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:provider/provider.dart';
// import 'package:zaki/Constants/AppConstants.dart';
// import 'package:zaki/Constants/Styles.dart';
// import 'package:zaki/Screens/HomeScreen.dart';
// import 'package:zaki/Screens/LoginScreen.dart';
// import 'package:zaki/Screens/SignUpZakiPayNew.dart';
// import 'package:zaki/Screens/WhatsAppSignUpScreen.dart';
// import 'package:zaki/Screens/WhoLogin.dart';
// import 'package:zaki/Services/api.dart';

// GoogleSignIn? _googleSignIn = GoogleSignIn(
//   // Optional clientId
//   // clientId: '479882132969-9i9aqik3jfjd7qhci1nqf0bm2g71rm1u.apps.googleusercontent.com',
//   scopes: <String>[
//     'email',
//     'https://www.googleapis.com/auth/contacts.readonly',
//   ],
// );

// class ChooseLoginType extends StatefulWidget {
//   const ChooseLoginType({Key? key}) : super(key: key);

//   @override
//   _ChooseLoginTypeState createState() => _ChooseLoginTypeState();
// }

// class _ChooseLoginTypeState extends State<ChooseLoginType> {
//   final double tabBarHeight = 80;
//   double botomPosition = 100;
//   // final bottomSheetController = PanelController();

//   @override
//   void dispose() {
//     // bottomSheetController.close();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     var appConstants = Provider.of<AppConstants>(context, listen: true);
//     var height = MediaQuery.of(context).size.height;
//     var width = MediaQuery.of(context).size.width;
//     return Scaffold(
//       body: SafeArea(
//         child: Container(
//             // controller: bottomSheetController,
//             // maxHeight: height * 0.5,
//             // minHeight: height * 0.1,
//             // borderRadius: BorderRadius.only(
//             //     topLeft: Radius.circular(width * 0.09),
//             //     topRight: Radius.circular(width * 0.09)),
//             // panel: 
//             child:
//             Padding(
//               padding: EdgeInsets.only(bottom: height * 0.1),
//               child: SingleChildScrollView(
//                 child: Column(
//                   // mainAxisAlignment: MainAxisAlignment.end,
//                   // crossAxisAlignment: CrossAxisAlignment.end,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
//                       child: InkWell(
//                         onTap: () {
//                           // bottomSheetController.open();
//                         },
//                         child: Container(
//                           width: width * 0.2,
//                           height: 5,
//                           decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(width * 0.08),
//                               color: grey),
//                         ),
//                       ),
//                     ),
//                     // Center(
//                     //   child: TextButton(
//                     //     child: const Text('Settings'),
//                     //     onPressed: () {
//                     //       Navigator.push(
//                     //           context,
//                     //           MaterialPageRoute(
//                     //               builder: (context) =>
//                     //                   const SettingsMainScreen()));
//                     //     },
//                     //   ),
//                     // ),
//                     // Center(
//                     //   child: TextButton(
//                     //     child: Text(
//                     //       appConstants.userLat == 0.00
//                     //           ? 'Get User Location'
//                     //           : '${appConstants.userLat} & ${appConstants.userLng}',
//                     //       // textScaleFactor: width * 0.008,
//                     //     ),
//                     //     onPressed: () async {
//                     //       Position location =
//                     //           await ApiServices().determinePosition();
//                     //       appConstants.updateLatAndLng(
//                     //           location.latitude, location.longitude);
//                     //       print(
//                     //           'User latitude is: ${location.latitude} and longitude is: ${location.longitude}');
//                     //     },
//                     //   ),
//                     // ),

//                     FittedBox(
//                       child: Text(
//                         'Sign Up with',
//                         style: textStyleHeading1WithTheme(context, width * 0.9,
//                             whiteColor: 0),
//                       ),
//                     ),
//                     SizedBox(
//                       height: height * 0.01,
//                     ),
//                     Text(
//                       ' By continuing, you agree to our\nUser Agreement and Privacy Policy',
//                       style: textStyleHeading2WithTheme(context, width * 0.7,
//                           whiteColor: 2),
//                     ),
//                     SizedBox(
//                       height: height * 0.01,
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         LoginCustomButton(
//                           width: width,
//                           icon: FontAwesomeIcons.googlePlusG,
//                           onTap: () async {
//                             UserCredential? info = await ApiServices()
//                                 .signInWithGoogle(_googleSignIn);
//                             if (info != null) {
//                               ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                                   content: Text(info
//                                           .additionalUserInfo!.isNewUser
//                                       ? 'New user Register successfully'
//                                       : 'Successfully Logged in email: ${info.user?.email}')));
//                               return;
//                             } else {
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                   const SnackBar(
//                                       content: Text('Logged in failed')));
//                               return;
//                             }
//                           },
//                         ),
//                         LoginCustomButton(
//                           width: width,
//                           icon: FontAwesomeIcons.apple,
//                           onTap: () {
//                             showDialog();
//                           },
//                         ),
//                         LoginCustomButton(
//                           width: width,
//                           icon: FontAwesomeIcons.facebookF,
//                           onTap: () async {
//                             await ApiServices().signInFacebook();
//                           },
//                         ),
//                         LoginCustomButton(
//                           width: width,
//                           icon: FontAwesomeIcons.whatsapp,
//                           onTap: () {
//                             appConstants.updateSignUpMethod('WhatsApp');
//                             Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                     builder: (context) =>
//                                         const WhatsAppSignUpScreen()));
//                           },
//                         ),
//                       ],
//                     ),
//                     SizedBox(
//                       height: height * 0.01,
//                     ),
//                     Text(
//                       'Or',
//                       style: textStyleHeading2WithTheme(context, width * 0.7,
//                           whiteColor: 2),
//                     ),
//                     SizedBox(
//                       height: height * 0.01,
//                     ),

//                     InkWell(
//                       onTap: () {
//                         // appConstants.updateSignUpMthod('Email');
//                         // Navigator.push(
//                         //     context,
//                         //     MaterialPageRoute(
//                         //         builder: (context) => const SignUpNew()));
//                       },
//                       child: Text(
//                         'Sign up with email',
//                         style: textStyleHeading2WithTheme(context, width * 0.9,
//                             whiteColor: 0),
//                       ),
//                     ),
//                     SizedBox(
//                       height: height * 0.01,
//                     ),
//                     ListTile(
//                       leading: Checkbox(
//                           activeColor: black,
//                           value: appConstants.registrationCheckBox,
//                           onChanged: (value) {
//                             appConstants.updateRegistrationCheckBox(value);
//                           }),
//                       title: InkWell(
//                         onTap: () {
//                           // Navigator.push(
//                           //     context,
//                           //     MaterialPageRoute(
//                           //         builder: (context) => const HomwScreen()));
//                         },
//                         child: Text(
//                           'Check box I agree to get educational emails from ZakiPay',
//                           style: textStyleHeading2WithTheme(
//                               context, width * 0.7,
//                               whiteColor: 0),
//                         ),
//                       ),
//                     ),
//                     SizedBox(
//                       height: height * 0.01,
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         InkWell(
//                           onTap: () {
//                             Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                     builder: (context) =>
//                                         const WhoIsLoginWithPin()));
//                           },
//                           child: Text(
//                             'Already have an account?',
//                             style: textStyleHeading2WithTheme(
//                                 context, width * 0.75,
//                                 whiteColor: 0),
//                           ),
//                         ),
//                         InkWell(
//                           onTap: () {
//                             // Navigator.push(
//                             //     context,
//                             //     MaterialPageRoute(
//                             //         builder: (context) => const LoginScreen()));
//                           },
//                           child: Text(
//                             'Log In',
//                             style: textStyleHeading1WithTheme(
//                                 context, width * 0.7,
//                                 whiteColor: 0),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             ////////////////////////
//             // body: Column(
//             //   children: [
//             //     Hero(
//             //       tag: 'splashAnimation',
//             //       child: FlutterLogo(
//             //         size: width * 0.2,
//             //       ),
//             //     ),
//             //   ],
//             // )
//             // Padding(
//             //   padding: EdgeInsets.only(bottom: height * 0.1),
//             //   child: Column(
//             //     mainAxisAlignment: MainAxisAlignment.end,
//             //     crossAxisAlignment: CrossAxisAlignment.end,
//             //     children: [
//             //       Center(
//             //         child: TextButton(
//             //           child: const Text('Settings'),
//             //           onPressed: () {
//             //             Navigator.push(
//             //                 context,
//             //                 MaterialPageRoute(
//             //                     builder: (context) => const SettingsMainScreen()));
//             //           },
//             //         ),
//             //       ),
//             //       Center(
//             //         child: TextButton(
//             //           child: Text(appConstants.userLat == 0.00
//             //               ? 'Get User Location'
//             //               : '${appConstants.userLat} & ${appConstants.userLng}'),
//             //           onPressed: () async {
//             //             Position location = await ApiServices().determinePosition();
//             //             appConstants.updateLatAndLng(
//             //                 location.latitude, location.longitude);
//             //             print(
//             //                 'User latitude is: ${location.latitude} and longitude is: ${location.longitude}');
//             //           },
//             //         ),
//             //       ),
//             //       Padding(
//             //         padding: EdgeInsets.symmetric(horizontal: width * 0.12),
//             //         child: LoginCircularButton(
//             //             width: width,
//             //             title: 'Continue With Facebook',
//             //             iconData: Icons.facebook,
//             //             onPressed: () async {
//             //               await ApiServices().signInFacebook();
//             //             }),
//             //       ),
//             //       Padding(
//             //         padding:
//             //             EdgeInsets.symmetric(horizontal: width * 0.12, vertical: 5),
//             //         child: LoginCircularButton(
//             //             width: width,
//             //             title: 'Continue With Google',
//             //             iconData: FontAwesomeIcons.google,
//             //             onPressed: () async {
//             //               UserCredential? info =
//             //                   await ApiServices().signInWithGoogle(_googleSignIn);
//             //               if (info != null) {
//             //                 ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//             //                     content: Text(info.additionalUserInfo!.isNewUser
//             //                         ? 'New user Register successfully'
//             //                         : 'Successfully Logged in email: ${info.user?.email}')));
//             //                 return;
//             //               } else {
//             //                 ScaffoldMessenger.of(context).showSnackBar(
//             //                     const SnackBar(content: Text('Logged in failed')));
//             //                 return;
//             //               }
//             //             }),
//             //       ),
//             //       Padding(
//             //         padding:
//             //             EdgeInsets.symmetric(horizontal: width * 0.12, vertical: 5),
//             //         child: LoginCircularButton(
//             //             width: width,
//             //             title: 'Continue With Apple',
//             //             iconData: FontAwesomeIcons.apple,
//             //             onPressed: () {
//             //               showDialog();
//             //             }),
//             //       ),
//             //       Padding(
//             //         padding:
//             //             EdgeInsets.symmetric(horizontal: width * 0.12, vertical: 5),
//             //         child: LoginCircularButton(
//             //             width: width,
//             //             title: 'Continue With Email',
//             //             iconData: Icons.email,
//             //             onPressed: () {
//             //               Navigator.push(
//             //                   context,
//             //                   MaterialPageRoute(
//             //                       builder: (context) => const LoginScreen()));
//             //             }),
//             //       ),
//             //     ],
//             //   ),
//             // ),
//             ),
//       ),
//     );
//   }

//   void showDialog() {
//     showCupertinoDialog(
//       context: context,
//       builder: (context) {
//         return CupertinoAlertDialog(
//           title: const Text("Please Turn on\n  Notifications"),
//           content: const Text(
//               "Get notified of the best content for you, as well as replies to your posts and comments"),
//           actions: [
//             CupertinoDialogAction(
//                 child: const Text("Not Now"),
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 }),
//             CupertinoDialogAction(
//               child: const Text("Ok"),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             )
//           ],
//         );
//       },
//     );
//   }
// }

// class LoginCustomButton extends StatelessWidget {
//   const LoginCustomButton(
//       {Key? key, required this.width, required this.onTap, required this.icon})
//       : super(key: key);

//   final double width;
//   final VoidCallback onTap;
//   final IconData icon;

//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       // color: transparent,
//       child: InkWell(
//         onTap: onTap,
//         splashColor: white,
//         child: Container(
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(width * 0.02),
//             color: grey,
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(10.0),
//             child: Icon(
//               icon,
//               size: width * 0.08,
//               color: white,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
