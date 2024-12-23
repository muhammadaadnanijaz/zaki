// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:ndialog/ndialog.dart';
// import 'package:provider/provider.dart';
// import 'package:zaki/Constants/AppConstants.dart';
// import 'package:zaki/Constants/Styles.dart';
// import 'package:zaki/Services/api.dart';
// import 'package:zaki/Widgets/LoginCircularButton.dart';
// import 'package:zaki/Widgets/ZakiPrimaryButton.dart';

// GoogleSignIn? _googleSignIn = GoogleSignIn(
//   // Optional clientId
//   // clientId: '479882132969-9i9aqik3jfjd7qhci1nqf0bm2g71rm1u.apps.googleusercontent.com',
//   scopes: <String>[
//     'email',
//     'https://www.googleapis.com/auth/contacts.readonly',
//   ],
// );

// class RegistrationScreen extends StatefulWidget {
//   const RegistrationScreen({Key? key}) : super(key: key);

//   @override
//   _RegistrationScreenState createState() => _RegistrationScreenState();
// }

// class _RegistrationScreenState extends State<RegistrationScreen> {
//   final emailCotroller = TextEditingController();
//   final passwordCotroller = TextEditingController();
//   final confirmPasswordCotroller = TextEditingController();

//   @override
//   void dispose() {
//     emailCotroller.dispose();
//     passwordCotroller.dispose();
//     confirmPasswordCotroller.dispose();
//     super.dispose();
//   }

//   void clearFields() {
//     emailCotroller.text = '';
//     passwordCotroller.text = '';
//     confirmPasswordCotroller.text = '';
//     setState(() {});
//   }

//   @override
//   Widget build(BuildContext context) {
//     var appConstants = Provider.of<AppConstants>(context, listen: true);
//     var height = MediaQuery.of(context).size.height;
//     var width = MediaQuery.of(context).size.width;
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Registartion',
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
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//           child: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 SizedBox(
//                   height: height * 0.02,
//                 ),
//                 Text(
//                   'Log in to Zaki',
//                   style:
//                       textStyleHeading1WithTheme(context, width, whiteColor: 0),
//                 ),
//                 SizedBox(
//                   height: height * 0.02,
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 4.0),
//                   child: LoginCircularButton(
//                       width: width,
//                       title: 'Continue With Google',
//                       iconData: FontAwesomeIcons.google,
//                       border: 1,
//                       onPressed: () async {
//                         UserCredential? info =
//                             await ApiServices().signInWithGoogle(_googleSignIn);
//                         if (info != null) {
//                           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                               content: Text(info.additionalUserInfo!.isNewUser
//                                   ? 'New user Register successfully'
//                                   : 'Successfully Logged in email: ${info.user?.email}')));
//                           return;
//                         } else {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                               const SnackBar(
//                                   content: Text('Logged in failed')));
//                           return;
//                         }
//                       }),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(bottom: 4.0),
//                   child: LoginCircularButton(
//                       width: width,
//                       border: 1,
//                       title: 'Continue With Facebook',
//                       iconData: Icons.facebook,
//                       onPressed: () async {
//                         await ApiServices().signInFacebook();
//                       }),
//                 ),
//                 LoginCircularButton(
//                     width: width,
//                     title: 'Continue With Apple',
//                     border: 1,
//                     iconData: FontAwesomeIcons.apple,
//                     onPressed: () {}),
//                 SizedBox(
//                   height: height * 0.03,
//                 ),
//                 Row(
//                   children: [
//                     Expanded(
//                         child: Divider(
//                       color: grey,
//                       thickness: 0.5,
//                     )),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                       child: Text(
//                         'OR',
//                         style: textStyleHeading2WithTheme(context, width * 0.8,
//                             whiteColor: 2),
//                       ),
//                     ),
//                     Expanded(
//                         child: Divider(
//                       color: grey,
//                       thickness: 0.5,
//                     ))
//                   ],
//                 ),
//                 SizedBox(
//                   height: height * 0.03,
//                 ),
//                 TextFormField(
//                   validator: (String? value) {
//                     return null;
//                   },
//                   // style: TextStyle(color: primaryColor),
//                   style: textStyleHeading1WithTheme(context, width * 0.8,
//                       whiteColor: 0),
//                   controller: emailCotroller,
//                   obscureText: false,
//                   keyboardType: TextInputType.emailAddress,
//                   maxLines: 1,
//                   decoration: InputDecoration(
//                     labelText: 'Username',
//                     labelStyle: textStyleHeading1WithTheme(context, width * 0.8,
//                         whiteColor: 0),
//                   ),
//                 ),
//                 TextFormField(
//                   validator: (String? value) {
//                     return null;
//                   },
//                   // style: TextStyle(color: primaryColor),
//                   controller: passwordCotroller,
//                   obscureText: appConstants.passwordVissibleRegistration,
//                   keyboardType: TextInputType.visiblePassword,
//                   decoration: InputDecoration(
//                       labelText: 'Password',
//                       labelStyle: textStyleHeading1WithTheme(
//                           context, width * 0.8,
//                           whiteColor: 0),
//                       suffixIcon: IconButton(
//                           icon: Icon(
//                             Icons.visibility,
//                             color: grey,
//                           ),
//                           onPressed: () {
//                             appConstants.updatePasswordVisibilityRegistartion(
//                                 appConstants.passwordVissibleRegistration);
//                           })),
//                 ),
//                 TextFormField(
//                   validator: (String? value) {
//                     return null;
//                   },
//                   // style: TextStyle(color: primaryColor),
//                   controller: confirmPasswordCotroller,
//                   obscureText: appConstants.passwordVissibleRegistration,
//                   keyboardType: TextInputType.visiblePassword,
//                   decoration: InputDecoration(
//                       labelText: 'Re Enter Password',
//                       labelStyle: textStyleHeading1WithTheme(
//                           context, width * 0.8,
//                           whiteColor: 0),
//                       suffixIcon: IconButton(
//                           icon: Icon(
//                             Icons.visibility,
//                             color: grey,
//                           ),
//                           onPressed: () {
//                             appConstants.updatePasswordVisibilityRegistartion(
//                                 appConstants.passwordVissibleRegistration);
//                           })),
//                 ),
//                 SizedBox(
//                   height: height * 0.12,
//                 ),
//                 ZakiPrimaryButton(
//                   title: 'Continue',
//                   width: width,
//                   onPressed: () async {
//                     if (emailCotroller.text == '' ||
//                         passwordCotroller.text == '' ||
//                         confirmPasswordCotroller.text == '') {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                           const SnackBar(content: Text('Fill all the fields')));
//                       return;
//                     }
//                     if (passwordCotroller.text !=
//                         confirmPasswordCotroller.text) {
//                       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//                           content: Text('Password did not matched')));
//                       return;
//                     }
//                     CustomProgressDialog progressDialog =
//                         CustomProgressDialog(context, blur: 10);
//                     progressDialog.setLoadingWidget(CustomLoader(
//                         valueColor: AlwaysStoppedAnimation(black)));
//                     progressDialog.show();

//                     var apiServices = await ApiServices().userRegistration(
//                         email: emailCotroller.text,
//                         password: passwordCotroller.text);
//                     print('Api Service: $apiServices');
//                     if (apiServices == 'Error') {
//                       progressDialog.dismiss();
//                       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                           content: Text(apiServices == 'Error'
//                               ? 'Something Went Wrong'
//                               : 'Successfully Registred')));
//                       return;
//                     } else {
//                       clearFields();
//                       progressDialog.dismiss();
//                       // Navigator.push(context, MaterialPageRoute(builder: (context)=>const LoginPersonType()));
//                     }
//                   },
//                 )

//                 //////////
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
