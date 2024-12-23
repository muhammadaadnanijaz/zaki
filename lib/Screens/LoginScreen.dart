// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:ndialog/ndialog.dart';
// import 'package:provider/provider.dart';
// import 'package:zaki/Constants/AppConstants.dart';
// import 'package:zaki/Constants/Styles.dart';
// import 'package:zaki/Screens/ForgetScreen.dart';
// import 'package:zaki/Screens/WhatsAppLoginScreen.dart';
// import 'package:zaki/Services/api.dart';
// import 'package:zaki/Widgets/ZakiPrimaryButton.dart';

// import 'ChooseLoginType.dart';

// GoogleSignIn? _googleSignIn = GoogleSignIn(
//   // Optional clientId
//   // clientId: '479882132969-9i9aqik3jfjd7qhci1nqf0bm2g71rm1u.apps.googleusercontent.com',
//   scopes: <String>[
//     'email',
//     'https://www.googleapis.com/auth/contacts.readonly',
//   ],
// );

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({Key? key}) : super(key: key);

//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final formGlobalKey = GlobalKey<FormState>();
//   // GoogleSignInAccount? _currentUser;
//   final emailCotroller = TextEditingController();
//   final passwordCotroller = TextEditingController();
//   bool loggedIn = false;

//   // AccessToken? _accessToken;
//   UserModel? currentUser;

//   @override
//   void initState() {
//     super.initState();
//     // _googleSignIn!.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
//     //   setState(() {
//     //     _currentUser = account;
//     //   });
//     //   if (_currentUser != null) {
//     //     print('After sign in: $_currentUser');
//     //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Logged in username: ${_currentUser!.displayName}')));
//     //   }
//     // });
//     // _googleSignIn!.signInSilently();
//   }

//   @override
//   void dispose() {
//     emailCotroller.dispose();
//     passwordCotroller.dispose();
//     super.dispose();
//   }

//   void clearFields() {
//     emailCotroller.text = '';
//     passwordCotroller.text = '';
//     setState(() {});
//   }

//   ///////////////////////////////

//   // // Widget _buildWidget() {
//   // //   UserModel? user = currentUser;
//   // //   if (user != null) {
//   // //     return Padding(
//   // //       padding: const EdgeInsets.all(12.0),
//   // //       child: Column(
//   // //         children: [
//   // //           ListTile(
//   // //             leading: CircleAvatar(
//   // //               radius: user.pictureModel!.width! / 6,
//   // //               backgroundImage: NetworkImage(user.pictureModel!.url!),
//   // //             ),
//   // //             title: Text(user.name!),
//   // //             subtitle: Text(user.email!),
//   // //           ),
//   // //           const SizedBox(height: 20,),
//   // //           const Text(
//   // //             'Signed in successfully',
//   // //             style: TextStyle(fontSize: 20),
//   // //           ),
//   // //           const SizedBox(height: 10,),
//   // //           ElevatedButton(
//   // //               onPressed: signOut,
//   // //               child: const Text('Sign out')
//   // //           )
//   // //         ],
//   // //       ),
//   // //     );
//   // //   } else {
//   // //     return Padding(
//   // //       padding: const EdgeInsets.all(12.0),
//   // //       child: Column(
//   // //         children: [
//   // //           const SizedBox(height: 20,),
//   // //           const Text(
//   // //             'You are not signed in',
//   // //             style: TextStyle(fontSize: 20),
//   // //           ),
//   // //           const SizedBox(height: 10,),
//   // //           IconButton(onPressed: signIn, icon: const Icon(Icons.facebook)),
//   // //           // ElevatedButton(
//   // //           //     onPressed: signIn,
//   // //           //     child: const Text('Sign in')
//   // //           // ),
//   // //         ],
//   // //       ),
//   // //     );
//   // //   }
//   // // }

//   // Future<void> signIn() async {
//   //   final LoginResult result = await FacebookAuth.i.login();

//   //   if(result.status == LoginStatus.success){
//   //     _accessToken = result.accessToken;

//   //     final data = await FacebookAuth.i.getUserData();
//   //     UserModel model = UserModel.fromJson(data);

//   //     currentUser = model;
//   //     setState(() {

//   //     });
//   //   }
//   // }

//   // Future<void> signOut() async {
//   //   await FacebookAuth.i.logOut();
//   //   currentUser = null;
//   //   _accessToken = null;
//   //   setState(() {

//   //   });
//   // }

//   //////////////////
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
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//           child: SingleChildScrollView(
//             child: Form(
//               key: formGlobalKey,
//               // autovalidateMode: AutovalidateMode.always,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   SizedBox(
//                     height: height * 0.02,
//                   ),
//                   Center(
//                       child: Text(
//                     'Log in',
//                     style: textStyleHeading1WithTheme(context, width,
//                         whiteColor: 0),
//                   )),
//                   SizedBox(
//                     height: height * 0.02,
//                   ),
//                   Text(
//                     'With:',
//                     style: textStyleHeading1WithTheme(context, width,
//                         whiteColor: 0),
//                   ),
//                   SizedBox(
//                     height: height * 0.02,
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       LoginCustomButton(
//                         width: width,
//                         icon: FontAwesomeIcons.googlePlusG,
//                         onTap: () async {
//                           UserCredential? info = await ApiServices()
//                               .signInWithGoogle(_googleSignIn);
//                           if (info != null) {
//                             ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                                 content: Text(info.additionalUserInfo!.isNewUser
//                                     ? 'New user Register successfully'
//                                     : 'Successfully Logged in email: ${info.user?.email}')));
//                             return;
//                           } else {
//                             ScaffoldMessenger.of(context).showSnackBar(
//                                 const SnackBar(
//                                     content: Text('Logged in failed')));
//                             return;
//                           }
//                         },
//                       ),
//                       LoginCustomButton(
//                         width: width,
//                         icon: FontAwesomeIcons.apple,
//                         onTap: () {
//                           // showDialog();
//                         },
//                       ),
//                       LoginCustomButton(
//                         width: width,
//                         icon: FontAwesomeIcons.facebookF,
//                         onTap: () async {
//                           await ApiServices().signInFacebook();
//                         },
//                       ),
//                       LoginCustomButton(
//                         width: width,
//                         icon: FontAwesomeIcons.whatsapp,
//                         onTap: () {
//                           Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (context) =>
//                                       const WhatsAppLoginScreen()));
//                         },
//                       ),
//                     ],
//                   ),
//                   SizedBox(
//                     height: height * 0.03,
//                   ),
//                   Center(
//                       child: Text(
//                     'OR',
//                     style: textStyleHeading2WithTheme(context, width * 0.8,
//                         whiteColor: 2),
//                   )),
//                   SizedBox(
//                     height: height * 0.03,
//                   ),
//                   Text(
//                     'With:',
//                     style: textStyleHeading1WithTheme(context, width,
//                         whiteColor: 0),
//                   ),
//                   SizedBox(
//                     height: height * 0.01,
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
//                     controller: emailCotroller,
//                     obscureText: false,
//                     keyboardType: TextInputType.emailAddress,
//                     maxLines: 1,
//                     decoration: InputDecoration(
//                       hintText: 'Enter Email',
//                       hintStyle: textStyleHeading2WithTheme(
//                           context, width * 0.8,
//                           whiteColor: 2),
//                       // labelText: 'Enter Email',
//                       // labelStyle: textStyleHeading2WithTheme(context,width*0.8, whiteColor: 0),
//                     ),
//                   ),
//                   TextFormField(
//                     autovalidateMode: AutovalidateMode.onUserInteraction,
//                     validator: (String? password) {
//                       if (password!.isEmpty) {
//                         return 'Please Enter Password';
//                       } else {
//                         return null;
//                       }
//                     },
//                     style: textStyleHeading2WithTheme(context, width * 0.8,
//                         whiteColor: 0),
//                     controller: passwordCotroller,
//                     obscureText: appConstants.passwordVissibleRegistration,
//                     keyboardType: TextInputType.visiblePassword,
//                     decoration: InputDecoration(
//                         hintText: '********',
//                         hintStyle: textStyleHeading2WithTheme(
//                             context, width * 0.8, whiteColor: 0),
//                         labelText: 'Password',
//                         labelStyle: textStyleHeading2WithTheme(
//                             context, width * 0.8,
//                             whiteColor: 2),
//                         suffixIcon: IconButton(
//                             icon: Icon(
//                               Icons.visibility,
//                               color: grey,
//                             ),
//                             onPressed: () {
//                               appConstants.updatePasswordVisibilityRegistartion(
//                                   appConstants.passwordVissibleRegistration);
//                             })),
//                   ),
//                   SizedBox(
//                     height: height * 0.01,
//                   ),
//                   InkWell(
//                       onTap: () {
//                         Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => const ForgetScreen()));
//                       },
//                       child: Text(
//                         'Forget your password?',
//                         style: textStyleHeading2WithTheme(context, width * 0.8,
//                             whiteColor: 2),
//                       )),

//                   // Row(
//                   //   crossAxisAlignment: CrossAxisAlignment.end,
//                   //   children: [
//                   //     Text('New to Zaki?', style: textStyleHeading2WithTheme(context,width*0.8, whiteColor: 2),),
//                   //     const SizedBox(width: 5,),
//                   //     InkWell(
//                   //       onTap: (){
//                   //     Navigator.push(context, MaterialPageRoute(builder: (context)=>const RegistrationScreen()));
//                   //       },
//                   //       child: Text('Sign Up', style: textStyleHeading1WithTheme(context,width*0.8, context, whiteColor: 0),)),
//                   //   ],
//                   // ),

//                   SizedBox(
//                     height: height * 0.12,
//                   ),
//                   ZakiPrimaryButton(
//                     title: 'Login',
//                     width: width,
//                     onPressed: () async {
//                       if (emailCotroller.text == '' ||
//                           passwordCotroller.text == '') {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(content: Text('Fill all the fields')));
//                         return;
//                       }
//                       CustomProgressDialog progressDialog =
//                           CustomProgressDialog(context, blur: 10);
//                       progressDialog.setLoadingWidget(CustomLoader(
//                           valueColor: AlwaysStoppedAnimation(black)));
//                       progressDialog.show();

//                       var apiServices = await ApiServices().userLogin(
//                           email: emailCotroller.text,
//                           password: passwordCotroller.text);
//                       if (apiServices == 'Error') {
//                         progressDialog.dismiss();
//                         ScaffoldMessenger.of(context).showSnackBar(
//                             const SnackBar(
//                                 content: Text('Something Went Wrong')));
//                       } else {
//                         progressDialog.dismiss();
//                         ScaffoldMessenger.of(context).showSnackBar(
//                             const SnackBar(
//                                 content: Text('Successfully Login')));
//                       }
//                       print('Api Service: $apiServices');
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class UserModel {
//   final String? email;
//   final String? id;
//   final String? name;
//   final PictureModel? pictureModel;

//   const UserModel({this.name, this.pictureModel, this.email, this.id});

//   factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
//       email: json['email'],
//       id: json['id'] as String?,
//       name: json['name'],
//       pictureModel: PictureModel.fromJson(json['picture']['data']));

//   /*
//   Sample result of get user data method
//   {
//     "email" = "dsmr.apps@gmail.com",
//     "id" = 3003332493073668,
//     "name" = "Darwin Morocho",
//     "picture" = {
//         "data" = {
//             "height" = 50,
//             "is_silhouette" = 0,
//             "url" = "https://platform-lookaside.fbsbx.com/platform/profilepic/?asid=3003332493073668",
//             "width" = 50,
//         },
//     }
// }
//    */
// }

// class PictureModel {
//   final String? url;
//   final int? width;
//   final int? height;

//   const PictureModel({this.width, this.height, this.url});

//   factory PictureModel.fromJson(Map<String, dynamic> json) => PictureModel(
//       url: json['url'], width: json['width'], height: json['height']);
// }
