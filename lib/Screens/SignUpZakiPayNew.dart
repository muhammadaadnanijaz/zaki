// import 'package:flutter/material.dart';
// import 'package:ndialog/ndialog.dart';
// import 'package:provider/provider.dart';
// import 'package:zaki/Constants/HelperFunctions.dart';
// import 'package:zaki/Constants/Styles.dart';
// import 'package:zaki/Screens/VerifyEmailAddress.dart';
// import 'package:zaki/Widgets/ZakiPrimaryButton.dart';

// import '../Constants/AppConstants.dart';
// import '../Services/api.dart';

// final formGlobalKey = GlobalKey<FormState>();

// class SignUpNew extends StatefulWidget {
//   const SignUpNew({Key? key}) : super(key: key);

//   @override
//   _SignUpNewState createState() => _SignUpNewState();
// }

// class _SignUpNewState extends State<SignUpNew> {
//   String emailError = '';

//   final emailCotroller = TextEditingController();
//   final passwordCotroller = TextEditingController();
//   final confirmPasswordCotroller = TextEditingController();

//   // @override
//   // void dispose() {
//   //   emailCotroller.dispose();
//   //   passwordCotroller.dispose();
//   //   confirmPasswordCotroller.dispose();
//   //   super.dispose();
//   // }

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
//       resizeToAvoidBottomInset: false,
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
//       body: Padding(
//         padding: EdgeInsets.all(width * 0.08),
//         child: Form(
//           key: formGlobalKey,
//           autovalidateMode: AutovalidateMode.disabled,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 'Let’s get you started',
//                 style: textStyleHeading1WithTheme(context, width * 0.9,
//                     whiteColor: 0),
//               ),
//               SizedBox(
//                 height: height * 0.02,
//               ),
//               Text(
//                 'Which Email Would you like to Sign Up With?',
//                 style: textStyleHeading2WithTheme(context, width * 0.7,
//                     whiteColor: 2),
//               ),
//               TextFormField(
//                 autovalidateMode: AutovalidateMode.onUserInteraction,
//                 validator: (String? email) {
//                   if (email!.isEmpty) {
//                     return 'Please Enter Email';
//                   } else if (!RegExp(
//                           r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
//                       .hasMatch(email)) {
//                     return 'Please enter a valid email address';
//                   } else {
//                     return null;
//                   }
//                 },
//                 // style: TextStyle(color: primaryColor),
//                 style: textStyleHeading2WithTheme(context, width * 0.8,
//                     whiteColor: 0),
//                 controller: emailCotroller,
//                 obscureText: false,
//                 keyboardType: TextInputType.emailAddress,
//                 maxLines: 1,
//                 onChanged: (String? value) {
//                   setState(() {
//                     emailError = '';
//                   });
//                   print('value is: $emailError');
//                 },
//                 decoration: InputDecoration(
//                   errorText: emailError == '' ? null : emailError,
//                   hintText: 'Enter Email',
//                   hintStyle: textStyleHeading2WithTheme(context, width * 0.8,
//                       whiteColor: 2),
//                   // labelText: 'Enter Email',
//                   // labelStyle: textStyleHeading2WithTheme(context,width*0.8, whiteColor: 0),
//                 ),
//               ),
//               TextFormField(
//                 autovalidateMode: AutovalidateMode.onUserInteraction,
//                 validator: (String? password) {
//                   if (password!.isEmpty) {
//                     return 'Please Enter Password';
//                   } else if (password.length < 6) {
//                     return 'Password is too short';
//                   } else {
//                     return null;
//                   }
//                 },
//                 style: textStyleHeading2WithTheme(context, width * 0.8,
//                     whiteColor: 0),
//                 controller: passwordCotroller,
//                 obscureText: appConstants.passwordVissibleRegistration,
//                 keyboardType: TextInputType.visiblePassword,
//                 decoration: InputDecoration(
//                     hintText: '********',
//                     hintStyle: textStyleHeading2WithTheme(context, width * 0.8,
//                         whiteColor: 0),
//                     labelText: 'Use a Unique Password',
//                     labelStyle: textStyleHeading2WithTheme(context, width * 0.8,
//                         whiteColor: 2),
//                     suffixIcon: IconButton(
//                         icon: Icon(
//                           Icons.visibility,
//                           color: grey,
//                         ),
//                         onPressed: () {
//                           appConstants.updatePasswordVisibilityRegistartion(
//                               appConstants.passwordVissibleRegistration);
//                         })),
//               ),
//               TextFormField(
//                 autovalidateMode: AutovalidateMode.onUserInteraction,
//                 validator: (String? password) {
//                   if (password!.isEmpty) {
//                     return 'Please Enter Password';
//                   } else if (password != passwordCotroller.text) {
//                     return 'Password doesn’t match :( Try again';
//                   } else {
//                     return null;
//                   }
//                 },
//                 style: textStyleHeading2WithTheme(context, width * 0.8,
//                     whiteColor: 0),
//                 controller: confirmPasswordCotroller,
//                 obscureText: appConstants.passwordVissibleRegistration,
//                 keyboardType: TextInputType.visiblePassword,
//                 decoration: InputDecoration(
//                     hintText: '********',
//                     hintStyle: textStyleHeading2WithTheme(context, width * 0.8,
//                         whiteColor: 0),
//                     labelText: 'Confirm your Password',
//                     labelStyle: textStyleHeading2WithTheme(context, width * 0.8,
//                         whiteColor: 2),
//                     suffixIcon: IconButton(
//                         icon: Icon(
//                           Icons.visibility,
//                           color: grey,
//                         ),
//                         onPressed: () {
//                           appConstants.updatePasswordVisibilityRegistartion(
//                               appConstants.passwordVissibleRegistration);
//                         })),
//               ),
//               Expanded(
//                   child: Column(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   Text(
//                     'By continuing, you agree to our User Agreement and',
//                     style: textStyleHeading2WithTheme(context, width * 0.7,
//                         whiteColor: 2),
//                   ),
//                   Text(
//                     'Privacy Policy',
//                     style: textStyleHeading2WithTheme(context, width * 0.7,
//                         whiteColor: 0),
//                   ),
//                   ZakiPrimaryButton(
//                       title: 'Next',
//                       width: width,
//                       onPressed: (emailCotroller.text == '' ||
//                               passwordCotroller.text == '' ||
//                               confirmPasswordCotroller.text == '')
//                           ? null
//                           : () async {
//                               if (formGlobalKey.currentState!.validate()) {
//                                 if (emailCotroller.text == '' ||
//                                     passwordCotroller.text == '' ||
//                                     confirmPasswordCotroller.text == '') {
//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                       const SnackBar(
//                                           content:
//                                               Text('Fill all the fields')));
//                                   return;
//                                 }
//                                 if (passwordCotroller.text !=
//                                     confirmPasswordCotroller.text) {
//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                       const SnackBar(
//                                           content: Text(
//                                               'Password did not matched')));
//                                   return;
//                                 }
//                                 appConstants.updateEmail(emailCotroller.text);
//                                 appConstants.updatePassword(encryptedValue(
//                                     value: passwordCotroller.text));
//                                 CustomProgressDialog progressDialog =
//                                     CustomProgressDialog(context, blur: 10);
//                                 progressDialog.setLoadingWidget(
//                                     CustomLoader(
//                                         valueColor:
//                                             AlwaysStoppedAnimation(black)));
//                                 progressDialog.show();

//                                 ApiServices service = ApiServices();

//                                 dynamic apiServices =
//                                     await service.userRegistration(
//                                         email: emailCotroller.text,
//                                         password: passwordCotroller.text);
//                                 print('Api Service: $apiServices');
//                                 // ignore: unrelated_type_equality_checks
//                                 if (apiServices == 'Error') {
//                                   progressDialog.dismiss();
//                                   showNotification(
//                                       message: 'Some thing went wrong',
//                                       error: 1,
//                                       icon: Icons.error_outline);
//                                   return;
//                                 } else if (apiServices ==
//                                     'email-already-in-use') {
//                                   setState(() {
//                                     emailError =
//                                         'Email already in use try different';
//                                   });
//                                   // emailCotroller
//                                   progressDialog.dismiss();
//                                   showNotification(
//                                       message: 'Already Registered',
//                                       error: 1,
//                                       icon: Icons.error_outline);
//                                   return;
//                                 } else {
//                                   progressDialog.dismiss();
//                                   showNotification(
//                                       message: 'Successfully Registered',
//                                       error: 0,
//                                       icon: Icons.check);

//                                   Future.delayed(const Duration(seconds: 2),
//                                       () {
//                                     Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                             builder: (context) =>
//                                                 const VerifyEmailAddress()));
//                                   });
//                                 }
//                                 ///////////For testing only

//                                 // CustomProgressDialog progressDialog = CustomProgressDialog(context,blur: 10);
//                                 //   progressDialog.setLoadingWidget(CustomLoader(valueColor: AlwaysStoppedAnimation(black)));
//                                 //   progressDialog.show();

//                                 // ApiServices service = ApiServices();

//                                 // dynamic apiServices = await service.userRegistration(email: emailCotroller.text, password: passwordCotroller.text);
//                                 // print('Api Service: $apiServices');
//                                 // // ignore: unrelated_type_equality_checks
//                                 // if (apiServices=='Error') {
//                                 //   progressDialog.dismiss();
//                                 //   // ignore: unrelated_type_equality_checks
//                                 //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(apiServices=='Error'?'Something Went Wrong':'Successfully Registred')));
//                                 //   return;
//                                 // }
//                                 // else{

//                                 //   progressDialog.dismiss();
//                                 //   // service.addUserToDatabase(
//                                 //   //     email: emailCotroller.text,
//                                 //   //     name: 'dani',
//                                 //   //     password: passwordCotroller.text,
//                                 //   //     status: 'Dad'
//                                 //   //   );
//                                 //     appConstants.updateRegistrationForm(emails: emailCotroller.text, passwords: passwordCotroller.text, isEmailVerfieds: false, isToucheds: false, firstNames: '', lastNames: '', pins: 0, userNames: '');
//                                 //   // clearFields();
//                                 //   Navigator.push(context, MaterialPageRoute(builder: (context)=>const VerifyEmailAddress()));
//                                 // // Navigator.push(context, MaterialPageRoute(builder: (context)=>const LoginPersonType()));
//                                 // }

//                               }
//                             })
//                 ],
//               ))
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
