import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
// import 'package:twitter_login/twitter_login.dart';
import 'package:zaki/Constants/AppConstants.dart';
import 'package:zaki/Constants/HelperFunctions.dart';
import 'package:zaki/Services/api.dart';

//googleapis, google_sign_in, googleapis_auth, google_sign_in_web, googleapis_auth_web, googleapis_auth_nodejs, googleapis_auth_io, googleapis_auth_flutter
GoogleSignIn? googleSignIns = GoogleSignIn(
  // Optional clientId
  // clientId: '479882132969-9i9aqik3jfjd7qhci1nqf0bm2g71rm1u.apps.googleusercontent.com',
  scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);

Future<UserCredential> signInWithFacebook() async {
  // Trigger the sign-in flow
  final LoginResult loginResult = await FacebookAuth.instance.login();

  // Create a credential from the access token
  final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(loginResult.accessToken!.tokenString);

  // Once signed in, return the UserCredential
  return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
}
 
  // sign in with twitter method
  Future<UserCredential?> signInWithTwitter() async {
  // Create a TwitterLogin instances
  // final twitterLogin = new TwitterLogin(
  //     apiKey: AppConstants.TWITTER_API_KEY,
  //     apiSecretKey: AppConstants.TWITTER_SECRET_API_KEY,
  //     redirectURI: "twittersdk://"
  // );

  // Trigger the sign-in flow
  // final authResult = await twitterLogin.login();

  // Create a credential from the access token
  // final twitterAuthCredential = TwitterAuthProvider.credential(
  //   accessToken: authResult.authToken!,
  //   secret: authResult.authTokenSecret!,
  // );

  // Once signed in, return the UserCredential
  // return await FirebaseAuth.instance.signInWithCredential(twitterAuthCredential);
}
  // Future signInWithTwitters() async {
  //   final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  // final twitterLogin = TwitterLogin(
  //     apiKey: AppConstants.TWITTER_API_KEY,
  //     apiSecretKey: AppConstants.TWITTER_SECRET_API_KEY,
  //     redirectURI: "twittersdk://"
  //     );
  //   final authResult = await twitterLogin.loginV2();
  //   logMethod(title: 'Auth Result', message:'${authResult.errorMessage}');
  //   if (authResult.status == TwitterLoginStatus.loggedIn) {
  //     try {
  //       logMethod(title: 'Access Token and secret', message:'${authResult.authToken} and ${authResult.authTokenSecret}');
  //       final credential = TwitterAuthProvider.credential(
  //           accessToken: authResult.authToken!,
  //           secret: authResult.authTokenSecret!);
  //       await firebaseAuth.signInWithCredential(credential);

  //       final userDetails = authResult.user;
  //       logMethod(title: 'User Detail of Twitter', message: userDetails.toString());
  //       // save all the data
  //       // _name = userDetails!.name;
  //       // _email = firebaseAuth.currentUser!.email;
  //       // _imageUrl = userDetails.thumbnailImage;
  //       // _uid = userDetails.id.toString();
  //       // _provider = "TWITTER";
  //       // _hasError = false;
  //       // notifyListeners();
  //     } on FirebaseAuthException catch (e) {
  //       logMethod(title: 'User Detail of Twitter exception', message: e.code.toString());

  //       switch (e.code) {
  //         case "account-exists-with-different-credential":
  //           // _errorCode =
  //           //     "You already have an account with us. Use correct provider";
  //           // _hasError = true;
  //           // notifyListeners();
  //           break;

  //         case "null":
  //           // _errorCode = "Some unexpected error while trying to sign in";
  //           // _hasError = true;
  //           // notifyListeners();
  //           break;
  //         default:
  //           // _errorCode = e.toString();
  //           // _hasError = true;
  //           // notifyListeners();
  //       }
  //     }
  //   } else {
  //     // _hasError = true;
  //     // notifyListeners();
  //   }
  // }


Future<bool?> authenticateTransactionUsingBioOrPinCode({required BuildContext context, required AppConstants appConstants}) async{
  if (appConstants.userModel.usaTouchEnable != null &&
                                    appConstants.userModel.usaTouchEnable==true) {
                                  bool isAuth =
                                      await ApiServices().userLoginBioMetric();
                                  if (isAuth) {
                                    logMethod(title: 'AUTH->>>', message: 'Auth Successfully');
                                    return true;
                                    // CustomProgressDialog progressDialog =
                                    // CustomProgressDialog(context, blur: 10);
                                    //   progressDialog
                                    //       .setLoadingWidget(CustomLoadingScreen());
                                    //   progressDialog.show();
                                      
                                    // await ApiServices().getNickNames(
                                    //     context: context,
                                    //     userId: appConstants.userRegisteredId);
                                    // // showSnackBarDialog(
                                    // //     context: context,
                                    // //     message: 'Authenticated successfully');
                                    // Future.delayed(const Duration(seconds: 1), () {
                                    //   progressDialog.dismiss();
                                    //   FocusManager.instance.primaryFocus?.unfocus();
                                    //   Navigator.push(
                                    //       context,
                                    //       MaterialPageRoute(
                                    //           builder: (context) => HomeScreen()));
                                    // });
                                  } else {
                                    // showSnackBarDialog(
                                    //     context: context,
                                    //     message: 'Ooops...Something went wrong');
                                    return false;
                                  }
                                } else {
                                  return null;
                                  // showSnackBarDialog(
                                  //     context: context,
                                  //     message: "You haven't enabled Biometric");
                                }
}