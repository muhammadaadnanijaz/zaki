// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:zaki/Screens/PasswordUpdatedSuccessScreen.dart';
// import 'package:zaki/Widgets/ZakiPrimaryButton.dart';

// import '../Constants/AppConstants.dart';
// import '../Constants/Styles.dart';

// class UpdatePasswordScreen extends StatefulWidget {
//   const UpdatePasswordScreen({Key? key}) : super(key: key);

//   @override
//   _UpdatePasswordScreenState createState() => _UpdatePasswordScreenState();
// }

// class _UpdatePasswordScreenState extends State<UpdatePasswordScreen> {
//   final formGlobalKey = GlobalKey<FormState>();
//   final passwordCotroller = TextEditingController();
//   final confirmPasswordCotroller = TextEditingController();

//   @override
//   void dispose() {
//     passwordCotroller.dispose();
//     confirmPasswordCotroller.dispose();
//     super.dispose();
//   }

//   void clearFields() {
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
//                   'Update your\nPassword',
//                   style:
//                       textStyleHeading1WithTheme(context, width, whiteColor: 0),
//                 ),
//                 SizedBox(
//                   height: height * 0.05,
//                 ),
//                 TextFormField(
//                   autovalidateMode: AutovalidateMode.onUserInteraction,
//                   validator: (String? password) {
//                     if (password!.isEmpty) {
//                       return 'Please Enter Password';
//                     } else {
//                       return null;
//                     }
//                   },
//                   style: textStyleHeading2WithTheme(context, width * 0.8,
//                       whiteColor: 0),
//                   controller: passwordCotroller,
//                   obscureText: appConstants.passwordVissibleRegistration,
//                   keyboardType: TextInputType.visiblePassword,
//                   decoration: InputDecoration(
//                       hintText: 'New Password',
//                       hintStyle: textStyleHeading2WithTheme(
//                           context, width * 0.8, whiteColor: 0),
//                       labelText: 'New Password',
//                       labelStyle: textStyleHeading2WithTheme(
//                           context, width * 0.8,
//                           whiteColor: 2),
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
//                   autovalidateMode: AutovalidateMode.onUserInteraction,
//                   validator: (String? password) {
//                     if (password!.isEmpty) {
//                       return 'Please Enter Password';
//                     } else if (password != passwordCotroller.text) {
//                       return 'Password doesn’t match :( Try again';
//                     } else {
//                       return null;
//                     }
//                   },
//                   style: textStyleHeading2WithTheme(context, width * 0.8,
//                       whiteColor: 0),
//                   controller: confirmPasswordCotroller,
//                   obscureText: appConstants.passwordVissibleRegistration,
//                   keyboardType: TextInputType.visiblePassword,
//                   decoration: InputDecoration(
//                       hintText: 'Confirm New Password',
//                       hintStyle: textStyleHeading2WithTheme(
//                           context, width * 0.8, whiteColor: 0),
//                       labelText: 'Confirm New Password',
//                       labelStyle: textStyleHeading2WithTheme(
//                           context, width * 0.8,
//                           whiteColor: 2),
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
//                                   const PasswordUpdatedSuccessScreen()));
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
