// ignore_for_file: unused_local_variable

import 'dart:convert';
import 'dart:isolate';

import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as authio;
import 'package:googleapis/servicecontrol/v1.dart' as servicecontrol;
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
// import 'package:geolocator/geolocator.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:local_auth/local_auth.dart';
import 'package:ndialog/ndialog.dart';
import 'package:provider/provider.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:zaki/Constants/AppConstants.dart';
import 'package:zaki/Constants/HelperFunctions.dart';
import 'package:zaki/Constants/NotificationTitle.dart';
import 'package:zaki/Constants/envUserConstants.dart';
import 'package:zaki/Models/Items.dart';
import 'package:zaki/Models/NickNameModel.dart';
import 'package:zaki/Models/TagItModel.dart';
import 'package:zaki/Models/ToDoModel.dart';
import 'package:zaki/Models/ZakiPayTagit.dart';
import 'package:zaki/Screens/AccountSetupAsaKid.dart';
import 'package:zaki/Screens/HomeScreen.dart';
import 'package:zaki/Screens/WhoLogin.dart';
import 'package:zaki/Screens/WhosSettingUp.dart';
import 'package:zaki/Services/SharedPrefMnager.dart';
import '../Constants/IntialSetup.dart';
import '../Models/FundMeWalletModel.dart';
import '../Models/GoalModel.dart';
import '../Models/PersonalizationSettingsModel.dart';
import '../Models/UserModel.dart';

class ApiServices {
  // ignore: unused_field
  AccessToken? _accessToken;
  // UserModel? currentUser;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  /////////User biomatric
  final auth = LocalAuthentication();

  Future<bool> userLoginBioMetric() async {
    bool canCheckBiometrics = await auth.canCheckBiometrics;
    if (!canCheckBiometrics) {
      return false;
    }

    try {
      return await auth.authenticate(
          localizedReason: 'Scan Fingureprint to authenticate',
          options: AuthenticationOptions(
            useErrorDialogs: true,
            stickyAuth: true,
            biometricOnly: false,
            sensitiveTransaction: true,
          ));
    } on PlatformException {
      return false;
    }
  }

  Future<String?> getDeviceId() async {
    String? identifier;
    try {
      final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

      if (Platform.isAndroid) {
        var build = await deviceInfoPlugin.androidInfo;
        identifier = build.id; //UUID for Android
        //print('Android identifier $identifier');
      } else if (Platform.isIOS) {
        var data = await deviceInfoPlugin.iosInfo;
        identifier = data.identifierForVendor!; //UUID for iOS

        //print('Ios identifier $identifier');
      }
      print('After Saving Token: $identifier');
    } catch (e) {
      //print("Exception: is : $e");
    }
    return identifier;
  }

  dynamic userLogin({String? email, String? password}) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: "$email", password: "$password");
      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'Error';
      } else if (e.code == 'wrong-password') {
        return 'Error';
      } else {
        return 'Error';
      }
    }
  }

  Future<void> signInFacebook() async {
    final LoginResult result = await FacebookAuth.i.login();

    if (result.status == LoginStatus.success) {
      _accessToken = result.accessToken;

      // final data =
      await FacebookAuth.i.getUserData();
      // UserModel model = UserModel.fromJson(data);
      // print('Usermodel :${model.name} and id is:${model.id} and access token is: ${_accessToken!.token}');

      // currentUser = model;
      // setState(() {

      // });
    }
  }

  Future<void> signOut() async {
    await FacebookAuth.i.logOut();
    // currentUser = null;
    _accessToken = null;
    // setState(() {

    // });
  }

  dynamic userRegistration({String? email, String? password}) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: "$email", password: "$password");
      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'weak-password';
      } else if (e.code == 'email-already-in-use') {
        return 'email-already-in-use';
      }
    } catch (e) {
      return 'Error';
    }
  }

  Future<UserCredential?> signInWithGoogle(
      [GoogleSignIn? _googleSignIn]) async {
    try {
      GoogleSignInAccount? googleUser;
      googleUser = await GoogleSignIn().signOut();
      googleUser = await GoogleSignIn(
        scopes: <String>[
          'email',
          'https://www.googleapis.com/auth/contacts.readonly',
        ],
      ).signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      UserCredential userCreds =
          await FirebaseAuth.instance.signInWithCredential(credential);
      print('sing in successfully: ${userCreds.additionalUserInfo} ');
      return userCreds;
    } catch (e) {
      print(e);
    }
    return null;
    // try {
    //   await _googleSignIn!.signOut();
    //   await _googleSignIn.signIn();
    //   print('After sign in: ${_googleSignIn.currentUser!.displayName}');
    //   return _googleSignIn.currentUser;
    //   } catch (error) {
    //   print(error);
    // }
    // Trigger the authentication flow
//   final GoogleSignInAccount googleUser = await GoogleSignIn();

//   // Obtain the auth details from the request
//   final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
// final GoogleAuthCredential credential = GoogleAuthProvider.credential(
//       accessToken: googleAuth.accessToken,
//       idToken: googleAuth.idToken,
//     );
//     UserCredential userCreds = await FirebaseAuth.instance.signInWithCredential(credential);
//     if (userCreds != null) {
//       print('sing in successfully: ${userCreds.additionalUserInfo} ');
//       return userCreds;
//     }
    // if (credential!=null) {
    //   return googleUser;
    // }
//  // Create a new credential
//   final credential = googleAuth.credential(
//     accessToken: googleAuth.accessToken,
//     idToken: googleAuth.idToken,
//   // );

//   // Once signed in, return the UserCredential
//   return googleUser;
  }

  ////Apple Sign In
    Future<UserCredential?> signInWithApple() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );

    print(credential);
    UserCredential userCreds =
      await FirebaseAuth.instance.signInWithCredential(credential as AuthCredential);
      print('sing in successfully: ${userCreds.additionalUserInfo} ');
    
      
      return userCreds;
    } catch (e) {
      print(e);
    }
    return null;
  }



Future<List<ImageModelTagIt>> fetchAllTags({AppConstants? appConstants }) async{
     List<ImageModelTagIt> list = [];
    QuerySnapshot<Map<String, dynamic>> value = await FirebaseFirestore.instance
        .collection(AppConstants.TagitCollection)
        .get();
    // logMethod(title: "Full list data", message: value.docs.toString());
    value.docs.forEach((element) {
      logMethod(title: "Icon", message: Icons.ac_unit_sharp.codePoint.toString());
      var data = element.data();
                final unicode = int.parse(data['icon']); // Convert stored Unicode to int

          // Dynamically create IconData
          final iconData = IconData(unicode, fontFamily: 'MaterialIcons');
      ImageModelTagIt tagitmodel = ImageModelTagIt(
        fullName: data['fullName'],
        icon: IconData(int.parse(data['icon']), fontFamily: 'MaterialIcons'),
        id: data['id'],
        isSelected: data['isSelected'],
        mccId: data['mccId'],
        publicTag_it: data['publicTag_it'],
        tagItId: data['tagItId'],
        title: data['title'],
        );
      
      list.add(tagitmodel);
      logMethod(title: "Full list", message: element.data().toString());
      // if (element.data()[AppConstants.USER_invited_signedup]) {
        // list.add(element.data()[AppConstants.USER_UserID]);
      // }
      // element.data()
    });
    // for (var element in list) {
    //   logMethod(title: "Full list after adding", message: element.fullName);

    // }
    // appConstants!.updateTagItList(list);
    return list;
  }
  // Fetch all data from the API
//   Future<List<ZakiPayTag>> fetchAllTags() async {
//     logMethod(title: "All Tag it method is being called", message: "true");

//     try {
//       final response = await http.get(Uri.parse(AppConstants.BASE_URL_OF_TAG_IT_GOOGLE_SHEET));

//       if (response.statusCode == 200) {
//         final List<dynamic> jsonData = json.decode(response.body);
//         logMethod(title: "All Tag it Fetch Result", message: response.body.toString());
//         // Parse the response to filter unique tags
//   List<TagItModel> filteredList = tagItParseResponse(response.body);

//   // Print the filtered list
//   for (var tag in filteredList) {
//     print(
//         'Bank Biz Code: ${tag.bankBizCode}, TagIt ID: ${tag.tagItId}, TagIt Name: ${tag.tagItName}');
//   }
//         return jsonData.map((json) => ZakiPayTag.fromJson(json)).toList();
//       } else {
//         throw Exception(
//             'Failed to load data: ${response.statusCode}, ${response.reasonPhrase}');
//       }
//     } catch (e) {
//       throw Exception('Error fetching data: $e');
//     }
//   }
//   List<TagItModel> tagItParseResponse(String response) {
//   try {
//     // Parse the JSON response
//     final List<dynamic> jsonResponse = json.decode(response);

//     // Convert JSON to a list of TagItModel
//     List<TagItModel> allTags = jsonResponse.map((json) {
//       return TagItModel.fromJson(json);
//     }).toList();

//     // Remove duplicates based on tagItId
//     List<TagItModel> filteredTags = allTags.toSet().toList();

//     return filteredTags;
//   } catch (e) {
//     throw Exception('Error parsing response: $e');
//   }
// }

  // Fetch filtered data by key and value
  Future<List<ZakiPayTag>> fetchFilteredTags(
      String filterKey, String filterValue) async {

    try {
      final url =
          '${AppConstants.BASE_URL_OF_TAG_IT_GOOGLE_SHEET}?filterKey=$filterKey&filterValue=${Uri.encodeComponent(filterValue)}';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        logMethod(title: "All Tag it Filter results", message: response.body.toString());

        return jsonData.map((json) => ZakiPayTag.fromJson(json)).toList();
      } else {
        throw Exception(
            'Failed to load data: ${response.statusCode}, ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error fetching filtered data: $e');
    }
  }


  //////////////////USER LOCATION
  // Future<Position> determinePosition() async {
  //   bool serviceEnabled;
  //   LocationPermission permission;

  //   // Test if location services are enabled.
  //   serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     // Location services are not enabled don't continue
  //     // accessing the position and request users of the
  //     // App to enable the location services.
  //     return Future.error('Location services are disabled.');
  //   }

  //   permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       // Permissions are denied, next time you could try
  //       // requesting permissions again (this is also where
  //       // Android's shouldShowRequestPermissionRationale
  //       // returned true. According to Android guidelines
  //       // your App should show an explanatory UI now.
  //       return Future.error('Location permissions are denied');
  //     }
  //   }

  //   if (permission == LocationPermission.deniedForever) {
  //     // Permissions are denied forever, handle appropriately.
  //     return Future.error(
  //         'Location permissions are permanently denied, we cannot request permissions.');
  //   }

  //   // When we reach here, permissions are granted and we can
  //   // continue accessing the position of the device.
  //   return await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high);
  // }

  Future<String?> newUserPhoneVerification({
    bool? isPinUser,
    List? deviceId,
    bool? isEnabled,
    bool? touchEnable,
    String? parentId,
    bool? locationStatus,
    bool? notificationStatus,
    bool? pinEnabled,
    String? userName,
    String? pinCode,
    int? pinLength,
    String? currency,
    String? method,
    String? country,
    String? city,
    String? latLng,
    String? gender,
    String? phoneNumber,
    bool? isEmailVerified,
    String? dob,
    String? firstName,
    String? lastName,
    String? email,
    String? password,
    String? status,
    bool? kidEnabled,
    bool? userStatus,
    String? userSignUpMemberType,
    bool? userFullyRegistred,
    required String? zipCode,
    bool? seeKids,
    String? firstLegalName,
    String? lastLegalName
  }) async {
    logMethod(title: 'Parent Id------->>>>>>>>>', message: '$parentId');
    // return '';

    // List mainWallet = [
    //   {
    //     AppConstants.main_account_nick_name: "main",
    //     AppConstants.updated_at: DateTime.now(),
    //     AppConstants.wallet_balance: "0"
    //   },
    //   // main_account_nick_name
    // ];
    // List charityWallet = [
    //   {
    //     AppConstants.Donate_account_nick_name: "charity",
    //     AppConstants.updated_at: DateTime.now(),
    //     AppConstants.wallet_balance: "0"
    //   },
    // ];
    // List savingsWallet = [
    //   {
    //     AppConstants.saving_account_nick_name: "saving",
    //     AppConstants.updated_at: DateTime.now(),
    //     AppConstants.wallet_balance: "0"
    //   },
    // ];
    // List invitedList = [
    //   {
    //     AppConstants.USER_invited_signedup: false,
    //     AppConstants.USER_contact_invitedphone: ''
    //   }
    // ];

    CollectionReference users = firestore.collection(AppConstants.USER);
    var response = await users.add({
      // AppConstants.USER_Main_Wallet: FieldValue.arrayUnion(mainWallet),
      // AppConstants.USER_Donate_wallet: FieldValue.arrayUnion(charityWallet),
      // AppConstants.USER_Savings_wallet: FieldValue.arrayUnion(savingsWallet),
      AppConstants.device_list: FieldValue.arrayUnion(deviceId!),
      // "USER_UserID":parentId!=null? users.doc().id : FirebaseAuth.instance.currentUser!.uid,
      AppConstants.USER_UserID: '',
      // AppConstants.USER_contacts: FieldValue.arrayUnion(invitedList),
      AppConstants.USER_Family_Id: parentId,
      AppConstants.USER_first_name: firstName,
      AppConstants.USER_last_name: lastName,
      AppConstants.USER_legalfirst_name: firstLegalName,
      AppConstants.USER_legallast_name: lastLegalName,
      AppConstants.USER_email: email,
      AppConstants.USER_dob: dob,
      AppConstants.USER_password: password,
      AppConstants.USER_UserType: status,
      AppConstants.USER_isEmailVerified: isEmailVerified,
      AppConstants.USER_phone_number: phoneNumber,
      AppConstants.USER_gender: gender,
      AppConstants.USER_lat_lng: latLng,
      AppConstants.USER_city: city,
      AppConstants.USER_country: country,
      AppConstants.USER_SignUp_Method: method,
      AppConstants.USER_currency: currency,
      AppConstants.USER_created_at: DateTime.now(),
      AppConstants.USER_pin_code_length: pinLength,
      AppConstants.USER_pin_code: pinCode,
      AppConstants.USER_user_name: userName,
      AppConstants.USER_pin_enable: pinEnabled,
      AppConstants.USER_TouchID_isEnabled: touchEnable,

      AppConstants.USER_Notification_isEnabled: notificationStatus,
      AppConstants.USER_IsUserPin: isPinUser,
      AppConstants.USER_Location_isEnabled: locationStatus,
      AppConstants.USER_Logo: getKidImage(
        gender: gender,
        imageUrl: '',
        userType: status,
      ),
      AppConstants.NewMember_kid_isEnabled:
          kidEnabled == null ? false : kidEnabled,
      AppConstants.USER_zip_code: zipCode,
      AppConstants.USER_Status: userStatus,
      AppConstants.USER_iNApp_NotifyToken: await getToken(),
      AppConstants.USER_background_image_url: '',
      AppConstants.USER_SignupMember_Type: userSignUpMemberType,
      AppConstants.USER_Fully_Registered: userFullyRegistred,
      AppConstants.NewMember_isEnabled: isEnabled,
      AppConstants.USER_See_Kids: seeKids,
      AppConstants.USER_email_verified_status: false,
      AppConstants.USER_State: '',
      AppConstants.SubscriptionExpired: false,
      AppConstants.USER_SubscriptionValue:0
    });

    firestore
        .collection(AppConstants.USER)
        .doc(response.id)
        .collection(AppConstants.USER_WALLETS)
        .doc(AppConstants.All_Goals_Wallet)
        .set({
      "all_goals_account_nick_name": "all_goals",
      AppConstants.updated_at: DateTime.now(),
      AppConstants.wallet_balance: 0
    });
    firestore
        .collection(AppConstants.USER)
        .doc(response.id)
        .collection(AppConstants.USER_WALLETS)
        .doc(AppConstants.Donations_Wallet)
        .set({
      AppConstants.Donate_account_nick_name: "charity",
      AppConstants.updated_at: DateTime.now(),
      AppConstants.wallet_balance: 0
    });
    firestore
        .collection(AppConstants.USER)
        .doc(response.id)
        .collection(AppConstants.USER_WALLETS)
        .doc(AppConstants.Savings_Wallet)
        .set({
      AppConstants.saving_account_nick_name: "saving",
      AppConstants.updated_at: DateTime.now(),
      AppConstants.wallet_balance: 0
    });
    firestore
        .collection(AppConstants.USER)
        .doc(response.id)
        .collection(AppConstants.USER_WALLETS)
        .doc(AppConstants.Spend_Wallet)
        .set({
      AppConstants.main_account_nick_name: "main",
      AppConstants.updated_at: DateTime.now(),
      AppConstants.wallet_balance: 0
    });
    print('Document Id is: ${response.id}');

    ///////////Update Current userid beacuse i want to see all kids and
    ///we are using current user id for that to create a check on it
    ///this is firebase id that is auto genrated so are assigning that id to that user
    firestore
        .collection(AppConstants.USER)
        .doc(response.id)
        .update({AppConstants.USER_UserID: response.id});
    // Parent
    // Kid
    // Single

    // Male
    // Female
    // Rather not specify

    return response.id;
    // await addSubcollection(userId: response.id, collectionName: AppConstants.USER_Main_Wallet, accountName: 'spending', amount: '1000');
    // await addSubcollection(userId: response.id, collectionName: 'USER_Savings_wallet', accountName: 'saving', amount: '1000');
    // await addSubcollection(userId: response.id, collectionName: 'USER_Donate_wallet', accountName: 'donation', amount: '1000');
  }

  Future<String?> updateUserAfterYourSelfInfo(
      {String? userId,
      String? userName,
      String? gender,
      String? phoneNumber,
      String? dob,
      String? firstName,
      String? lastName,
      String? email,
      String? userType,
      required String? zipCode,
      required String? userState}) async {
    // showNotification(
    //     error: 0, icon: Icons.check, message: 'Tell Us your self data save');
    logMethod(
        title: 'User Updated In Tell us about your self',
        message: 'TELL US ABOUT YOUR SELF');
    // return '';
    CollectionReference users = firestore.collection(AppConstants.USER);
    await users.doc(userId).update({
      AppConstants.USER_first_name: firstName,
      AppConstants.USER_last_name: lastName,
      AppConstants.USER_email: email,
      AppConstants.USER_dob: dob,
      AppConstants.USER_UserType: userType,
      AppConstants.USER_phone_number: phoneNumber,
      AppConstants.USER_gender: gender,
      AppConstants.USER_user_name: userName,
      AppConstants.USER_zip_code: zipCode,
      AppConstants.USER_State: userState
    });
    return 'Updated';
    // await addSubcollection(userId: response.id, collectionName: AppConstants.USER_Main_Wallet, accountName: 'spending', amount: '1000');
    // await addSubcollection(userId: response.id, collectionName: 'USER_Savings_wallet', accountName: 'saving', amount: '1000');
    // await addSubcollection(userId: response.id, collectionName: 'USER_Donate_wallet', accountName: 'donation', amount: '1000');
  }

  newUserCreateDbDefault(
      {String? userId,
      String? status,
      String? gender,
      String? parentId}) async {
    logMethod(title: 'User type gender and id', message: '$status and $gender and $userId');
    // return;
    await addIntialGoals(
        userId: userId,
        goalList: (status == 'Parent' && gender == 'Male')
            ? IntialSetup.dadDefaultGoals
            : (status == 'Parent' && gender == 'Female')
                ? IntialSetup.momDefaultGoals
                : (status == 'Kid' && gender == 'Male')
                    ? IntialSetup.kidsDefaultGoals
                    : (status == 'Kid' && gender == 'Female')
                        ? IntialSetup.kidsDefaultGoals
                        : (status == 'Single' && (gender == 'Rather not specify' || gender == 'Male'))
                            ? IntialSetup.singleDefaultGoals
                            : IntialSetup.defaultGoals);
    // return;                   
    await addIntialToDos(
        userId: userId,
        parentId: '',
        todoList: (status == 'Parent' && gender == 'Male')
            ? IntialSetup.dadDefaultTodos
            : (status == 'Parent' && gender == 'Female')
                ? IntialSetup.momDefaultTodos
                : (status == 'Kid' && gender == 'Male')
                    ? IntialSetup.kidsDefaultTodos
                    : (status == 'Kid' && gender == 'Female')
                        ? IntialSetup.kidsDefaultTodos
                        : (status == 'Single' && (gender == 'Rather not specify'|| gender == 'Male'))
                            ? IntialSetup.singleDefaultTodos
                            : IntialSetup.defaultTodos);
  }

// Future<String?> addSubcollection({String? userId, String? collectionName, String? accountName, String? amount})async{
//     CollectionReference users = firestore.collection(AppConstants.USER);
//     await users.doc(userId).collection(collectionName!).add({
//       'spending_account_nick_name':accountName,
//       'updated_at': DateTime.now(),
//       AppConstants.wallet_balance: amount
//     });
//     return 'Added Successfully';
//   }

  Future<String?> newUserUpdatedAfterConfirmPin(
      {List? deviceId,
      bool? isPinUser,
      bool? isEnabled,
      String? currentUserid,
      bool? touchEnable,
      String? parentId,
      bool? locationStatus,
      bool? notificationStatus,
      bool? pinEnabled,
      String? userName,
      String? pinCode,
      int? pinLength,
      String? currency,
      String? method,
      String? country,
      String? city,
      String? latLng,
      String? gender,
      String? phoneNumber,
      bool? isEmailVerified,
      String? dob,
      String? firstName,
      String? lastName,
      String? email,
      String? password,
      String? status,
      bool? userStatus,
      String? userSignUpMemberType,
      bool? userFullyRegistred,
      bool? seeKids,
      String? firstLegalName,
    String? lastLegalName,
      required String? zipCode,
      required DateTime? pincodeSetupDateTime,
      required int subscriptionValue
      }) async {
    // List mainWallet = [
    //   {
    //     AppConstants.main_account_nick_name: "main",
    //     AppConstants.updated_at: DateTime.now(),
    //     AppConstants.wallet_balance: "1000"
    //   },
    // ];
    // List charityWallet = [
    //   {
    //     AppConstants.Donate_account_nick_name: "charity",
    //     AppConstants.updated_at: DateTime.now(),
    //     AppConstants.wallet_balance: "1000"
    //   },
    // ];
    // List savingsWallet = [
    //   {
    //     AppConstants.saving_account_nick_name: "saving",
    //     AppConstants.updated_at: DateTime.now(),
    //     AppConstants.wallet_balance: "1000"
    //   },
    // ];

    // List invitedList = [
    //   {
    //     AppConstants.USER_invited_signedup: false,
    //     AppConstants.USER_contact_invitedphone: ''
    //   }
    // ];

    CollectionReference users = firestore.collection(AppConstants.USER);
    await users
        // .collection('users')
        // .doc(parentId!=null? users.doc().id : FirebaseAuth.instance.currentUser!.uid).set({
        .doc(currentUserid)
        .set({
      // AppConstants.USER_Main_Wallet: FieldValue.arrayUnion(mainWallet),
      // AppConstants.USER_Donate_wallet: FieldValue.arrayUnion(charityWallet),
      // AppConstants.USER_Savings_wallet: FieldValue.arrayUnion(savingsWallet),
      AppConstants.device_list: FieldValue.arrayUnion(deviceId!),
      // AppConstants.USER_contacts: FieldValue.arrayUnion(invitedList),
      // "USER_UserID":parentId!=null? users.doc().id : FirebaseAuth.instance.currentUser!.uid,
      AppConstants.USER_UserID: currentUserid,
      AppConstants.USER_first_name: firstName,
      AppConstants.USER_last_name: lastName,
      AppConstants.USER_legalfirst_name: firstLegalName,
      AppConstants.USER_legallast_name: lastLegalName,
      AppConstants.USER_email: email,
      AppConstants.USER_dob: dob,
      AppConstants.USER_password: password,
      AppConstants.USER_UserType: status,
      AppConstants.USER_isEmailVerified: isEmailVerified,
      AppConstants.USER_phone_number: phoneNumber,
      AppConstants.USER_gender: gender,
      AppConstants.USER_lat_lng: latLng,
      AppConstants.USER_city: city,
      AppConstants.USER_country: country,
      AppConstants.USER_SignUp_Method: method,
      AppConstants.USER_currency: currency,
      AppConstants.USER_created_at: DateTime.now(),
      AppConstants.USER_pin_code_length: pinLength,
      AppConstants.USER_pin_code: pinCode,
      AppConstants.USER_user_name: userName,
      AppConstants.USER_pin_enable: pinEnabled,
      AppConstants.USER_TouchID_isEnabled: touchEnable,
      AppConstants.NewMember_isEnabled: isEnabled,
      AppConstants.USER_Notification_isEnabled: notificationStatus,
      AppConstants.USER_IsUserPin: isPinUser,
      AppConstants.USER_Location_isEnabled: locationStatus,
      AppConstants.USER_Logo: getKidImage(
        gender: gender,
        imageUrl: '',
        userType: status,
      ),
      AppConstants.NewMember_kid_isEnabled: false,
      AppConstants.USER_iNApp_NotifyToken: await getToken(),
      AppConstants.USER_Status: userStatus,
      AppConstants.USER_background_image_url: '',
      AppConstants.USER_Family_Id: parentId,
      AppConstants.USER_SignupMember_Type: userSignUpMemberType,
      AppConstants.USER_Fully_Registered: userFullyRegistred,
      AppConstants.USER_See_Kids: seeKids,
      AppConstants.USER_zip_code: zipCode,
      AppConstants.USER_email_verified_status: false,
      AppConstants.USER_SubscriptionValue:subscriptionValue,
      AppConstants.SubscriptionExpired: false,
      AppConstants.USER_PIN_CODE_SETUP_DATE_TIME: pincodeSetupDateTime
    }).then((value) => {
              firestore
                  .collection(AppConstants.USER)
                  .doc(currentUserid)
                  .collection(AppConstants.USER_WALLETS)
                  .doc(AppConstants.All_Goals_Wallet)
                  .set({
                "all_goals_account_nick_name": "all_goals",
                AppConstants.updated_at: DateTime.now(),
                AppConstants.wallet_balance: 0
              }),
              firestore
                  .collection(AppConstants.USER)
                  .doc(currentUserid)
                  .collection(AppConstants.USER_WALLETS)
                  .doc(AppConstants.Donations_Wallet)
                  .set({
                AppConstants.Donate_account_nick_name: "charity",
                AppConstants.updated_at: DateTime.now(),
                AppConstants.wallet_balance: 0
              }),
              firestore
                  .collection(AppConstants.USER)
                  .doc(currentUserid)
                  .collection(AppConstants.USER_WALLETS)
                  .doc(AppConstants.Savings_Wallet)
                  .set({
                AppConstants.saving_account_nick_name: "saving",
                AppConstants.updated_at: DateTime.now(),
                AppConstants.wallet_balance: 0
              }),
              firestore
                  .collection(AppConstants.USER)
                  .doc(currentUserid)
                  .collection(AppConstants.USER_WALLETS)
                  .doc(AppConstants.Spend_Wallet)
                  .set({
                AppConstants.main_account_nick_name: "main",
                AppConstants.updated_at: DateTime.now(),
                AppConstants.wallet_balance: 0
              }),
            });

    // await addSubcollection(userId: currentUserid, collectionName: AppConstants.USER_Main_Wallet, accountName: 'spending', amount: '1000');
    // await addSubcollection(userId: currentUserid, collectionName: 'USER_Savings_wallet', accountName: 'saving', amount: '1000');
    // await addSubcollection(userId: currentUserid, collectionName: 'USER_Donate_wallet', accountName: 'donation', amount: '1000');

    return 'updated';
  }

  Future<String?> updateUserType({String? id}) async {
    CollectionReference users = firestore.collection(AppConstants.USER);
    users.doc(id).update({
      AppConstants.USER_UserType: 'Under 18',
    });
    return 'User Type Change';
  }

  Future<String?> addParentPhoneNumber(
      {String? id, String? phoneNumber}) async {
    CollectionReference users = firestore.collection(AppConstants.USER);
    users.doc(id).update({
      AppConstants.USER_phone_number_parent: phoneNumber,
    });
    return 'Parent Phone Number Added';
  }

  Future<String?> updateUserParentId({String? id, String? parentId}) async {
    logMethod(title: "Parent Id:", message: parentId);
    CollectionReference users = firestore.collection(AppConstants.USER);
    users.doc(id).update({
      AppConstants.USER_parent_id: parentId,
    });
    return 'User Type Change';
  }

  Future<String?> addAllowance(
      {DateTime? createdAt,
      String? parentId,
      String? kidId,
      String? amount,
      String? allowanceSchedule,
      String? spendAnyWhereAmount,
      String? spendAnyWhereAmountPercent,
      String? savingAmount,
      String? savingAmountPercent,
      String? donationsAmount,
      String? donationsAmountPercent,
      String? deliveryOn,
      bool? status,
      required bool linkedWith,
      required String parentBankAccountToken,
      required String kidBankAccountToken
      }) async {
    CollectionReference users = firestore.collection(AppConstants.ALLOW);
    
    await users.doc(kidId).set({
      AppConstants.USER_parent_id: parentId,
      AppConstants.USER_kid_id: kidId,
      AppConstants.USER_Allow1_amount: amount,
      AppConstants.USER_allowance_schedule: allowanceSchedule,
      AppConstants.USER_Main_amount: spendAnyWhereAmount,
      AppConstants.USER_saving_amount: savingAmount,
      AppConstants.USER_donate_amount: donationsAmount,
      AppConstants.USER_donate_amount_percent: donationsAmountPercent,
      AppConstants.USER_Main_amount_percent: spendAnyWhereAmountPercent,
      AppConstants.USER_saving_amount_percent: savingAmountPercent,
      AppConstants.USER_delivery_on: deliveryOn,
      AppConstants.USER_allowance_status: status,
      AppConstants.USER_allowance_linked_ToDo: linkedWith,
      AppConstants.USER_allowance_Parent_BankAccount_Id: parentBankAccountToken,
      AppConstants.USER_allowance_Kid_BankAccount_Id: kidBankAccountToken,
      AppConstants.created_at: createdAt
      // "created_at":DateTime.now().add(const Duration(days: 1))
    });
    //  addTransaction(selectedKidName: selectedKidName, selectedKidImageUrl: selectedKidImageUrl, senderImageUrl: senderImageUrl, accountHolderName: accountHolderName, amount: amount, currentUserId: currentUserId, imageUrl: imageUrl, message: message, receiverId: toUserId, requestType: AppConstants.Transaction_REQUEST_TYPE_PAY, senderId: currentUserId);
    return 'updated';
  }

  Future<String?> addIntialGoals(
      {String? userId, List<GoalModel>? goalList}) async {
        // goalList!.forEach((element) {
        //   logMethod(title: 'Name of goal',message: element.goalName);
        // });
    // return '';
    // Get a new write batch
    final batch = firestore.batch();
    goalList!.forEach((element) {
      final shardRef = firestore.collection(AppConstants.GOAL).doc();
      batch.set(shardRef, {
        AppConstants.GOAL_user_id: userId,
        AppConstants.GOAL_name: element.goalName,
        AppConstants.Goal_Target_Amount:
            double.parse(element.goalPrice.toString()),
        AppConstants.GOAL_isPrivate: element.topSecret,
        AppConstants.GOAL_Expired_Date: element.goalDate,
        AppConstants.GOAL_created_at: DateTime.now(),
        AppConstants.GOAL_Status: AppConstants.GOAL_Status_Active,
        AppConstants.GOAL_amount_collected:
            double.parse(element.goalAmountCollected.toString()),
        AppConstants.GOAL_selected_index: -1,
        AppConstants.GOAL_Invited_Token_List: []
        // AppConstants.GOAL_Expired_Status:false
        // "created_at":DateTime.now().add(const Duration(days: 1))
      });
    });
// batch.set(nycRef, {"name": "New York City"});
    await batch.commit();

    // CollectionReference users = firestore.collection(AppConstants.GOAL);
    // await users.add().then((value) {
    //   firestore.collection(AppConstants.GOAL).doc(value.id)
    //   .collection(AppConstants.GOAL_Invited_List).doc().collection(AppConstants.GOAL_Invited_List).add({
    //     "invited_by_id":"",
    //     "invited_to_image_url":"",
    //     "invited_to_username":""
    //   });
    // });
    return 'All Goals Added';
  }

  Future<String?> addIntialToDos(
      {String? userId, List<ToDoModel>? todoList, String? parentId}) async {
    DateTime createdAt = DateTime.now();
    var toDayToDoDate =
        DateTime(createdAt.year, createdAt.month, createdAt.day, 23, 59, 59);
//  CollectionReference users = firestore.collection(AppConstants.TO_DO);
//     await users.doc(userId).collection(AppConstants.TO_DO).add();
 todoList!.forEach((element) {
          logMethod(title: 'Name of todo',message: element.doTitle);
        });
    final batch = firestore.batch();
    todoList.forEach((element) {
      final shardRef = firestore
          .collection(AppConstants.TO_DO)
          .doc(userId)
          .collection(AppConstants.TO_DO)
          .doc();
      batch.set(shardRef, {
        AppConstants.DO_parentId: parentId,
        AppConstants.DO_UserId: userId,
        AppConstants.DO_Title: element.doTitle,
        AppConstants.ToDo_Repeat_Schedule: element.doType,
        AppConstants.DO_Day: '',
        AppConstants.DO_Status: element.doStatus,
        AppConstants.DO_DUE_DATE: toDayToDoDate,
        AppConstants.DO_CreatedAt: element.createdAt,
        AppConstants.DO_newCreatedAt: element.createdAt,
        AppConstants.DO_Allowance_Linked: false,
        AppConstants.DO_Deleted_By: "",
        AppConstants.DO_Kid_Status: "",
        AppConstants.ToDo_WithReward: false,
        AppConstants.ToDo_Reward_Amount: 0,
        AppConstants.ToDo_Reward_Status: '',
        AppConstants.DO_End_Repeat: null,
        // "created_at":DateTime.now().add(const Duration(days: 1))
      });
    });
// batch.set(nycRef, {"name": "New York City"});
    await batch.commit();

    // CollectionReference users = firestore.collection(AppConstants.GOAL);
    // await users.add().then((value) {
    //   firestore.collection(AppConstants.GOAL).doc(value.id)
    //   .collection(AppConstants.GOAL_Invited_List).doc().collection(AppConstants.GOAL_Invited_List).add({
    //     "invited_by_id":"",
    //     "invited_to_image_url":"",
    //     "invited_to_username":""
    //   });
    // });
    return 'All Goals Added';
  }

  Future<String?> addNewGoal(
      {DateTime? createdAt,
      String? userId,
      String? goalName,
      double? amount,
      double? ammountCollected,
      bool? status}) async {
    var result = DateTime.now();
    var goalLastDate =
        DateTime(createdAt!.year, createdAt.month, createdAt.day, 23, 59, 59);
    CollectionReference users = firestore.collection(AppConstants.GOAL);
    await users.add({
      AppConstants.GOAL_user_id: userId,
      AppConstants.GOAL_name: goalName,
      AppConstants.Goal_Target_Amount: amount,
      AppConstants.GOAL_isPrivate: status,
      AppConstants.GOAL_created_at: result,
      AppConstants.GOAL_Expired_Date: goalLastDate,
      AppConstants.GOAL_Status: AppConstants.GOAL_Status_Active,
      AppConstants.GOAL_amount_collected: ammountCollected,
      AppConstants.GOAL_selected_index: -1,
      AppConstants.GOAL_Invited_Token_List: []
      // AppConstants.GOAL_Expired_Status:false
      // "created_at":DateTime.now().add(const Duration(days: 1))
    })
        // .then((value) {
        //   firestore
        //       .collection(AppConstants.GOAL)
        //       .doc(value.id)
        //       .collection(AppConstants.GOAL_Invited_List)
        //       .doc()
        //       .collection(AppConstants.GOAL_Invited_List)
        //       .add({
        //     "invited_by_id": "",
        //     "invited_to_image_url": "",
        //     "invited_to_username": ""
        //   });
        // })
        ;
    return 'updated';
  }

  Future<String>? addTokenToGoal(
      {String? token, String? goalId, List? tokenList}) async {
    if (tokenList!.contains(token)) {
      return 'Already Added';
    } else {
      // else we need to add uid to the likes array
      FirebaseFirestore.instance
          .collection(AppConstants.GOAL)
          .doc(goalId)
          .update({
        AppConstants.GOAL_Invited_Token_List: FieldValue.arrayUnion([token])
      });

      return 'Token Added';
    }
  }
  Query getUncompletedGoalsWithQuery(String userId,
      {bool? fromHomeScreen}) {
    if (fromHomeScreen == true) {
      return FirebaseFirestore.instance
          .collection(AppConstants.GOAL)
          .where(AppConstants.GOAL_user_id, isEqualTo: userId)
          .where(AppConstants.GOAL_Status,
              isEqualTo: AppConstants.GOAL_Status_Active)
          .orderBy(AppConstants.GOAL_created_at, descending: true)
          .limit(3);
    }
    return FirebaseFirestore.instance
        .collection(AppConstants.GOAL)
        .where(AppConstants.GOAL_user_id, isEqualTo: userId)
        .where(AppConstants.GOAL_Status,
            isEqualTo: AppConstants.GOAL_Status_Active)
        .orderBy(AppConstants.GOAL_created_at, descending: true);
  }

  Stream<QuerySnapshot> getUncompletedGoals(String userId,
      {bool? fromHomeScreen}) {
    if (fromHomeScreen == true) {
      return FirebaseFirestore.instance
          .collection(AppConstants.GOAL)
          .where(AppConstants.GOAL_user_id, isEqualTo: userId)
          .where(AppConstants.GOAL_Status,
              isEqualTo: AppConstants.GOAL_Status_Active)
          .orderBy(AppConstants.GOAL_created_at, descending: true)
          .limit(3)
          .snapshots();
    }
    return FirebaseFirestore.instance
        .collection(AppConstants.GOAL)
        .where(AppConstants.GOAL_user_id, isEqualTo: userId)
        .where(AppConstants.GOAL_Status,
            isEqualTo: AppConstants.GOAL_Status_Active)
        .orderBy(AppConstants.GOAL_created_at, descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> getCompletedOrExpiredGoals(String userId) {
    return FirebaseFirestore.instance
        .collection(AppConstants.GOAL)
        .where(AppConstants.GOAL_Status,
            isNotEqualTo: AppConstants.GOAL_Status_Active)
        .where(AppConstants.GOAL_user_id, isEqualTo: userId)
        .snapshots();
    // .snapshots();
  }
 Query getCompletedOrExpiredGoalsWithQuery(String userId) {
    return FirebaseFirestore.instance
        .collection(AppConstants.GOAL)
        .where(AppConstants.GOAL_Status,
            isNotEqualTo: AppConstants.GOAL_Status_Active)
        .where(AppConstants.GOAL_user_id, isEqualTo: userId);
    // .snapshots();
  }

  Future updateGoalShareIndex({String? documentId, int? selectedIndex}) {
    return FirebaseFirestore.instance
        .collection(AppConstants.GOAL)
        .doc(documentId)
        .update({AppConstants.GOAL_selected_index: selectedIndex});
    // .snapshots();
  }

  Future addContribution({
    String? goalId,
    String? contributor_user_Id,
    String? countributed_amount,
    String? contribution_amount_currency,
    String? contributor_wallet_name,
  }) {
    return FirebaseFirestore.instance
        .collection(AppConstants.GOAL)
        .doc(goalId)
        .collection(AppConstants.Contribution)
        .add({
      AppConstants.contributor_user_Id: contributor_user_Id,
      AppConstants.countributed_amount: countributed_amount,
      AppConstants.contribution_amount_currency: contribution_amount_currency,
      AppConstants.contributor_wallet_name: contributor_wallet_name,
      AppConstants.contribution_date: DateTime.now()
    });
    // .snapshots();
  }

  Stream<QuerySnapshot> getUserFriendsAndFamilyForGoals(String userId) {
    final Stream<QuerySnapshot> _categoriesStream = FirebaseFirestore.instance
        .collection(AppConstants.USER)
        .doc(userId)
        .collection(AppConstants.USER_contacts)
        // .orderBy(AppConstants.updated_at, descending: true)
        .snapshots();
    return _categoriesStream;
  }

  Future<String?> updateGoalinviteStatus(
      {String? userId, String? invitedId, bool? status}) async {
    CollectionReference users = firestore.collection(AppConstants.USER);
    await users
        .doc(userId)
        .collection(AppConstants.USER_contacts)
        .doc(invitedId)
        .update({
      AppConstants.USER_invited_signedup: status,
      AppConstants.updated_at: DateTime.now()
      // "created_at":DateTime.now().add(const Duration(days: 1))
    });
    return 'Updated';
  }

  Stream<QuerySnapshot> getFriendsAndFamilyGoals(String userId) {
    return FirebaseFirestore.instance
        .collection(AppConstants.USER)
        .doc(userId)
        .collection(AppConstants.Goal_InviteReceivedFrom_UserID)
        // .where(AppConstants.GOAL_user_id, isEqualTo: userId)
        // .where(AppConstants.GOAL_Status, isEqualTo: AppConstants.GOAL_Status_Active)
        .snapshots();
    // .firestore.collection("GOAL_Invited_List")
    // .doc("userid").collection("GOAL_Invited_List").snapshots();
    // .orderBy(AppConstants.GOAL_created_at, descending: false).snapshots();
  }

  Future removeFriendAndFamilyGoal(
      {String? goalId, String? userId, String? goalSenderId}) async {
    // logMethod(message: 'Doc and user id', title: '$goalId and $userId');
    FirebaseFirestore.instance
        .collection(AppConstants.USER)
        .doc(userId)
        .collection(AppConstants.Goal_InviteReceivedFrom_UserID)
        .doc(goalId)
        .delete();

    //////Deleting From Sender Side
    FirebaseFirestore.instance
        .collection(AppConstants.USER)
        .doc(goalSenderId)
        .collection(AppConstants.Goal_InviteSentTo_UserID)
        .where(AppConstants.Goal_InviteSent_User_ReceiverId, isEqualTo: userId)
        .get()
        .then((value) {
      value.docs.first.reference.delete();
    });
    // .doc(goalId)
    // .delete();
    // .where(AppConstants.GOAL_user_id, isEqualTo: userId)
    // .where(AppConstants.GOAL_Status, isEqualTo: AppConstants.GOAL_Status_Active)
    // .firestore.collection("GOAL_Invited_List")
    // .doc("userid").collection("GOAL_Invited_List").snapshots();
    // .orderBy(AppConstants.GOAL_created_at, descending: false).snapshots();
  }
  //  getFriendsAndFamilyGoalsWithInvitedUser(String userId) async{
  //        final data = await FirebaseFirestore.instance.collection(AppConstants.GOAL)
  //             // .where(AppConstants.GOAL_user_id, isEqualTo: userId)
  //             .where(AppConstants.GOAL_Status, isEqualTo: AppConstants.GOAL_Status_Active)
  //             .get().then((value) {
  //               value.docs.forEach((element) {

  //               });
  //             } );

  //             logMethod(title: "Data for goal invited", message: data.docs.first.data().toString());
  //             // .firestore.collection("GOAL_Invited_List")
  //             // .doc("userid").collection("GOAL_Invited_List").snapshots();
  //             // .orderBy(AppConstants.GOAL_created_at, descending: false).snapshots();
  // }
  // Future<String?> addMoveMoney(
  //     {String? userId,
  //     String? parentId,
  //     String? amount,
  //     String? senderId,
  //     String? imageUrl,
  //     String? message,
  //     String? tagItId ,
  //     String? tagItName,
  //     String? accountType,
  //     String? accountHolderName,
  //     String? senderUserId}) async {
  //   CollectionReference users = firestore.collection(AppConstants.At);
  //   await users.add({
  //     AppConstants.At_user_id: userId,
  //     AppConstants.At_parent_id: parentId,
  //     AppConstants.At_amount: amount,
  //     AppConstants.At_sender_id: senderId,
  //     AppConstants.At_image_url: imageUrl,
  //     AppConstants.At_message: message,
  //     AppConstants.At_allocation_id: tagItId ,
  //     AppConstants.At_allocation_name: tagItName,
  //     AppConstants.At_acount_type: accountType,
  //     AppConstants.At_acount_holder_name: accountHolderName,
  //     AppConstants.created_at: DateTime.now()
  //   });
  //   // await addAllowanceFromFunds(kidId: userId, amount: amount);
  //   await addMoneyToSelectedMainWallet(
  //       receivedUserId: userId, amountSend: amount, senderId: senderUserId);
  //   return 'updated';
  // }
  Future<String>? addMoneyToAnyWallet(
      {String? receivedUserId, String? senderId, String? amountSend}) async {
    FirebaseFirestore.instance
        .collection(AppConstants.USER)
        .doc(senderId)
        .collection(AppConstants.USER_WALLETS)
        .doc(AppConstants.Spend_Wallet)
        .update({
      AppConstants.wallet_balance:
          FieldValue.increment(-double.parse(amountSend!))
    });
    FirebaseFirestore.instance
        .collection(AppConstants.USER)
        .doc(receivedUserId)
        .collection(AppConstants.USER_WALLETS)
        .doc(AppConstants.Spend_Wallet)
        .update({
      AppConstants.wallet_balance:
          FieldValue.increment(double.parse(amountSend))
    });
    return '';
  }

  // ignore: body_might_complete_normally_nullable
  Future<List<dynamic>?> addMoneyToSelectedMainWallet(
      {String? receivedUserId, String? senderId, String? amountSend}) async {
    FirebaseFirestore.instance
        .collection(AppConstants.USER)
        .doc(senderId)
        .collection(AppConstants.USER_WALLETS)
        .doc(AppConstants.Spend_Wallet)
        .update({
      AppConstants.wallet_balance:
          FieldValue.increment(-double.parse(amountSend!))
    });
    FirebaseFirestore.instance
        .collection(AppConstants.USER)
        .doc(receivedUserId)
        .collection(AppConstants.USER_WALLETS)
        .doc(AppConstants.Spend_Wallet)
        .update({
      AppConstants.wallet_balance:
          FieldValue.increment(double.parse(amountSend))
    });
    ////////////Receiver Money Getting From Server

//     List<dynamic> selectedUserWallet = [];
//     final value = await FirebaseFirestore.instance
//         .collection(AppConstants.USER)
//         .doc(receivedUserId)
//         .get();
//     selectedUserWallet = value.data()![AppConstants.USER_Main_Wallet];
// ////////////Sender Money Getting From Server
//     List<dynamic> senderUserWallet = [];
//     final senderValue = await FirebaseFirestore.instance
//         .collection(AppConstants.USER)
//         .doc(senderId)
//         .get();

//     senderUserWallet = senderValue.data()![AppConstants.USER_Main_Wallet];

//     double senderMoney =
//         double.parse(senderUserWallet[0][AppConstants.wallet_balance]);
//     ////////////Sender Money Getting From Server End
//     ///
//     ///
//     ///Now sender Money minus from sended money
//     double senderTotalMoney = senderMoney - double.parse(amountSend!);

//     List mainWallet = [
//       {
//         AppConstants.main_account_nick_name: "main",
//         AppConstants.updated_at: DateTime.now(),
//         AppConstants.wallet_balance: senderTotalMoney.toString()
//       },
//     ];
//     await FirebaseFirestore.instance
//         .collection(AppConstants.USER)
//         .doc(senderId)
//         .update({
//       AppConstants.USER_Main_Wallet: FieldValue.delete(),
//     });
//     await FirebaseFirestore.instance
//         .collection(AppConstants.USER)
//         .doc(senderId)
//         .update({
//       AppConstants.USER_Main_Wallet: FieldValue.arrayUnion(mainWallet),
//     });
//     ///////////////////Removed From sender account End

//     /// Add Amount into receiver account

//     double receiverBalance =
//         double.parse(selectedUserWallet[0][AppConstants.wallet_balance]) +
//             double.parse(amountSend);

//     List mainWalletReceiver = [
//       {
//         AppConstants.main_account_nick_name: "main",
//         AppConstants.updated_at: DateTime.now(),
//         AppConstants.wallet_balance: receiverBalance.toString()
//       },
//     ];
//     await FirebaseFirestore.instance
//         .collection(AppConstants.USER)
//         .doc(receivedUserId)
//         .update({
//       AppConstants.USER_Main_Wallet: FieldValue.delete(),
//     });
//     await FirebaseFirestore.instance
//         .collection(AppConstants.USER)
//         .doc(receivedUserId)
//         .update({
//       AppConstants.USER_Main_Wallet: FieldValue.arrayUnion(mainWalletReceiver),
//     });
//     return selectedUserWallet;
  }

/////////Savig wallet
//   Future<List<dynamic>> addMoneyToSelectedSavingWallet(
//       {String? receivedUserId, String? senderId, String? amountSend}) async {
//     ////////////Receiver Money Getting From Server
//     List<dynamic> selectedUserWallet = [];
//     final value = await FirebaseFirestore.instance
//         .collection(AppConstants.USER)
//         .doc(receivedUserId)
//         .get();
//     selectedUserWallet = value.data()![AppConstants.USER_Savings_wallet];
// ////////////Sender Money Getting From Server
//     List<dynamic> senderUserWallet = [];
//     final senderValue = await FirebaseFirestore.instance
//         .collection(AppConstants.USER)
//         .doc(senderId)
//         .get();

//     senderUserWallet = senderValue.data()![AppConstants.USER_Savings_wallet];

//     double senderMoney =
//         double.parse(senderUserWallet[0][AppConstants.wallet_balance]);
//     ////////////Sender Money Getting From Server End
//     ///
//     ///
//     ///Now sender Money minus from sended money
//     double senderTotalMoney = senderMoney - double.parse(amountSend!);

//     List mainWallet = [
//       {
//         AppConstants.main_account_nick_name: "main",
//         AppConstants.updated_at: DateTime.now(),
//         AppConstants.wallet_balance: senderTotalMoney.toString()
//       },
//     ];
//     await FirebaseFirestore.instance
//         .collection(AppConstants.USER)
//         .doc(senderId)
//         .update({
//       AppConstants.USER_Savings_wallet: FieldValue.delete(),
//     });
//     await FirebaseFirestore.instance
//         .collection(AppConstants.USER)
//         .doc(senderId)
//         .update({
//       AppConstants.USER_Savings_wallet: FieldValue.arrayUnion(mainWallet),
//     });
//     ///////////////////Removed From sender account End

//     /// Add Amount into receiver account

//     double receiverBalance =
//         double.parse(selectedUserWallet[0][AppConstants.wallet_balance]) +
//             double.parse(amountSend);

//     List mainWalletReceiver = [
//       {
//         AppConstants.main_account_nick_name: "main",
//         AppConstants.updated_at: DateTime.now(),
//         AppConstants.wallet_balance: receiverBalance.toString()
//       },
//     ];
//     await FirebaseFirestore.instance
//         .collection(AppConstants.USER)
//         .doc(receivedUserId)
//         .update({
//       AppConstants.USER_Savings_wallet: FieldValue.delete(),
//     });
//     await FirebaseFirestore.instance
//         .collection(AppConstants.USER)
//         .doc(receivedUserId)
//         .update({
//       AppConstants.USER_Savings_wallet:
//           FieldValue.arrayUnion(mainWalletReceiver),
//     });
//     return selectedUserWallet;
  // }

  /////////Charity wallet
//   Future<List<dynamic>> addMoneyToSelectedCharityWallet(
//       {String? receivedUserId, String? senderId, String? amountSend}) async {
//     ////////////Receiver Money Getting From Server
//     List<dynamic> selectedUserWallet = [];
//     final value = await FirebaseFirestore.instance
//         .collection(AppConstants.USER)
//         .doc(receivedUserId)
//         .get();
//     selectedUserWallet = value.data()![AppConstants.USER_Donate_wallet];
// ////////////Sender Money Getting From Server
//     List<dynamic> senderUserWallet = [];
//     final senderValue = await FirebaseFirestore.instance
//         .collection(AppConstants.USER)
//         .doc(senderId)
//         .get();

//     senderUserWallet = senderValue.data()![AppConstants.USER_Donate_wallet];

//     double senderMoney =
//         double.parse(senderUserWallet[0][AppConstants.wallet_balance]);
//     ////////////Sender Money Getting From Server End
//     ///
//     ///
//     ///Now sender Money minus from sended money
//     double senderTotalMoney = senderMoney - double.parse(amountSend!);

//     List mainWallet = [
//       {
//         AppConstants.main_account_nick_name: "main",
//         AppConstants.updated_at: DateTime.now(),
//         AppConstants.wallet_balance: senderTotalMoney.toString()
//       },
//     ];
//     await FirebaseFirestore.instance
//         .collection(AppConstants.USER)
//         .doc(senderId)
//         .update({
//       AppConstants.USER_Donate_wallet: FieldValue.delete(),
//     });
//     await FirebaseFirestore.instance
//         .collection(AppConstants.USER)
//         .doc(senderId)
//         .update({
//       AppConstants.USER_Donate_wallet: FieldValue.arrayUnion(mainWallet),
//     });
//     ///////////////////Removed From sender account End

//     /// Add Amount into receiver account

//     double receiverBalance =
//         double.parse(selectedUserWallet[0][AppConstants.wallet_balance]) +
//             double.parse(amountSend);

//     List mainWalletReceiver = [
//       {
//         AppConstants.main_account_nick_name: "main",
//         AppConstants.updated_at: DateTime.now(),
//         AppConstants.wallet_balance: receiverBalance.toString()
//       },
//     ];
//     await FirebaseFirestore.instance
//         .collection(AppConstants.USER)
//         .doc(receivedUserId)
//         .update({
//       AppConstants.USER_Donate_wallet: FieldValue.delete(),
//     });
//     await FirebaseFirestore.instance
//         .collection(AppConstants.USER)
//         .doc(receivedUserId)
//         .update({
//       AppConstants.USER_Donate_wallet:
//           FieldValue.arrayUnion(mainWalletReceiver),
//     });
//     return selectedUserWallet;
//   }

  Future<bool?> checkWalletHasAmount(
      {String? fromWalletName,
      String? userId,
      double? amount,
      bool? requiredOnlyBalance}) async {
    DocumentSnapshot<Map<String, dynamic>> walletBalance =
        await FirebaseFirestore.instance
            .collection(AppConstants.USER)
            .doc(userId)
            .collection(AppConstants.USER_WALLETS)
            .doc(fromWalletName)
            .get();
    // logMethod(
    //     title: "Amount from slected Wallet",
    //     message: walletBalance.data()![AppConstants.wallet_balance].toString());

    if (requiredOnlyBalance == true) {
      if (walletBalance.data()![AppConstants.wallet_balance] > 0) {
        return false;
      } else {
        return true;
      }
    }
    if (amount! > walletBalance.data()![AppConstants.wallet_balance]) {
      logMethod(
          title: "Amount and wallet amount",
          message: "$amount and ${walletBalance.data()!['wallet_balance']}");
      return true;
    } else {
      return false;
    }
  }

  Future<bool?> checkBalance(
      {String? userId, String? selectedWalletName, double? amount}) async {
    DocumentSnapshot<Map<String, dynamic>> walletBalance =
        await FirebaseFirestore.instance
            .collection(AppConstants.USER)
            .doc(userId)
            .collection(AppConstants.USER_WALLETS)
            .doc(selectedWalletName)
            .get();

    // logMethod(
    //     title: "Amount from slected Wallet",
    //     message: walletBalance.data()!['wallet_balance'].toString());
    if (amount! > walletBalance.data()!['wallet_balance']) {
      logMethod(
          title: "Amount and wallet amount",
          message: "$amount and ${walletBalance.data()!['wallet_balance']}");
      return false;
    } else {
      return true;
    }
  }

  Future<bool?> moveMoney({
    String? userId,
    String? fromWalletName,
    String? toWalletName,
    double? amount,
  }) async {
    bool? hasBalance = await checkBalance(
        amount: amount, selectedWalletName: fromWalletName, userId: userId);
    if (hasBalance == false) {
      // logMethod(
      //     title: "Amount and wallet amount",
      //     message: "$amount and ${walletBalance.data()!['wallet_balance']}");
      return false;
    } else {
      FirebaseFirestore.instance
          .collection(AppConstants.USER)
          .doc(userId)
          .collection(AppConstants.USER_WALLETS)
          .doc(fromWalletName)
          .update(
              {AppConstants.wallet_balance: FieldValue.increment(-amount!)});
      FirebaseFirestore.instance
          .collection(AppConstants.USER)
          .doc(userId)
          .collection(AppConstants.USER_WALLETS)
          .doc(toWalletName)
          .update({AppConstants.wallet_balance: FieldValue.increment(amount)});
      return true;
    }
  }

  Future<List<dynamic>> moveMoneyBetweenWallet(
      {String? receivedUserId,
      String? senderId,
      String? amountSend,
      required String walletName,
      required String walletNameFrom}) async {
    ////////////Receiver Money Getting From Server
    List<dynamic> selectedUserWallet = [];
    final value = await FirebaseFirestore.instance
        .collection(AppConstants.USER)
        .doc(receivedUserId)
        .get();
    selectedUserWallet = value.data()![walletName];
    //  showNotification(error: 0, icon: Icons.check, message: (double.parse(selectedUserWallet[0][AppConstants.wallet_balance])+ double.parse(amountSend!)).toString());

    List mainWallet = [
      {
        AppConstants.main_account_nick_name: "main",
        AppConstants.updated_at: DateTime.now(),
        AppConstants.wallet_balance:
            (double.parse(selectedUserWallet[0][AppConstants.wallet_balance]) +
                    double.parse(amountSend!))
                .toString()
      },
    ];
    await FirebaseFirestore.instance
        .collection(AppConstants.USER)
        .doc(senderId)
        .update({
      walletName: FieldValue.delete(),
    });
    await FirebaseFirestore.instance
        .collection(AppConstants.USER)
        .doc(senderId)
        .update({
      walletName: FieldValue.arrayUnion(mainWallet),
    });

    /////////////Now do subtract money from particular account
    ///
    if (walletName != walletNameFrom) {
      List<dynamic> senderWallet = [];
      senderWallet = value.data()![walletNameFrom];

      List mainWalletsender = [
        {
          AppConstants.main_account_nick_name: "main",
          AppConstants.updated_at: DateTime.now(),
          AppConstants.wallet_balance:
              (double.parse(senderWallet[0][AppConstants.wallet_balance]) -
                      double.parse(amountSend))
                  .toString()
        },
      ];
      await FirebaseFirestore.instance
          .collection(AppConstants.USER)
          .doc(senderId)
          .update({
        walletNameFrom: FieldValue.delete(),
      });
      await FirebaseFirestore.instance
          .collection(AppConstants.USER)
          .doc(senderId)
          .update({
        walletNameFrom: FieldValue.arrayUnion(mainWalletsender),
      });
    }

    return selectedUserWallet;
  }

  Future<String?> requestMoney(
      {String? requestType,
      String? accountHolderName,
      String? toUserId,
      String? amount,
      String? imageUrl,
      String? message,
      String? tagItId,
      String? tagItName,
      int? privacy,
      String? accountType,
      String? currentUserId,
      String? requestDocumentId,
      required String? selectedKidName,
      required String? selectedKidImageUrl,
      required String? senderImageUrl}) async {
        
    CollectionReference users = firestore
        .collection(AppConstants.USER)
        .doc(toUserId)
        .collection(AppConstants.Requested);
    DocumentReference<Object?> id = await users.add({
      AppConstants.RQT_ReceiverUser_id: toUserId,
      AppConstants.RQT_SocialPrivacy_Code: privacy,
      AppConstants.RQT_receiver_name: selectedKidName,
      AppConstants.RQT_sender_image_url: senderImageUrl,
      AppConstants.RQT_receiver_image_url: selectedKidImageUrl,
      AppConstants.RQT_amount: amount,
      AppConstants.RQT_SenderUser_id: currentUserId,
      AppConstants.RQT_image_url: imageUrl,
      AppConstants.RQT_Message_Text: message,
      AppConstants.RQT_TAGIT_id: tagItId,
      AppConstants.RQT_TAGIT_name: tagItName,
      AppConstants.RQT_WalletName: accountType,
      AppConstants.RQT_transaction_type: requestType,
      AppConstants.RQT_Sender_UserName: accountHolderName,
      AppConstants.RQT_DocumentId:requestDocumentId,
      AppConstants.created_at: DateTime.now()
    });
    
    // await addAllowanceFromFunds(kidId: userId, amount: amount);
    // await addMoneyToSelectedMainWallet(receivedUserId: userId, amountSend: amount, senderId: senderUserId);
    return id.id;
  }

  Future<String> addTransaction({
    String? requestType,
    String? accountHolderName,
    String? receiverId,
    String? senderId,
    String? amount,
    String? currentUserId,
    String? tagItId,
    String? tagItName,
    required String? selectedKidName,
    required String? transactionMethod,
    String? message,
    String? fromWallet,
    String? toWallet,
    String? transactionId,
  }) async {
  
  String commonId = ([senderId, receiverId]..sort()).join("_");
    logMethod( title: 'Common Id is:', message: commonId);
    // return "";
    CollectionReference transaction = firestore
        // .collection(AppConstants.USER)
        // .doc(currentUserId)
        .collection(AppConstants.Transaction);
    DocumentReference<Object?> trans = await transaction.add({
      AppConstants.Transaction_ReceiverUser_id: receiverId,
      AppConstants.Transaction_receiver_name: selectedKidName,
      AppConstants.Transaction_amount: double.parse(amount!).toStringAsFixed(2),
      AppConstants.Transaction_SenderUser_id: currentUserId,
      AppConstants.Transaction_transaction_type: requestType,
      AppConstants.Transaction_Sender_UserName: accountHolderName,
      AppConstants.Transaction_TAGIT_code: tagItId,
      AppConstants.Transaction_TAGIT_Category: tagItName,
      AppConstants.Transaction_Method: transactionMethod,
      AppConstants.Transaction_Message_Text: message,
      AppConstants.Transaction_To_Wallet: toWallet,
      AppConstants.Transaction_From_Wallet: fromWallet,
      AppConstants.Transaction_id: transactionId,
      AppConstants.created_at: DateTime.now(),
      AppConstants.Transaction_Common_id: commonId
    });
    // await addAllowanceFromFunds(kidId: userId, amount: amount);
    // await addMoneyToSelectedMainWallet(
    //     receivedUserId: toUserId, amountSend: amount, senderId: currentUserId);
    return '${trans.id}';
  }

  Future<String?> updateTransactionTagIt({
    String? transactionId,
    //   String? requestType,
    // String? receiverId,
    // String? senderId,
    // String? amount,
    String? selectedUserId,
    String? tagItId,
    String? tagItName,
  }) async {
    // logMethod( title: 'Sender Image Url:', message: senderImageUrl);
    CollectionReference transaction = firestore
        .collection(AppConstants.USER)
        .doc(selectedUserId)
        .collection(AppConstants.Transaction);
    await transaction.doc(transactionId).update({
      AppConstants.Transaction_TAGIT_code: tagItId,
      // AppConstants.Transaction_TAGIT_Category: tagItName,
      AppConstants.created_at: DateTime.now()
    });
    // await addAllowanceFromFunds(kidId: userId, amount: amount);
    // await addMoneyToSelectedMainWallet(
    //     receivedUserId: toUserId, amountSend: amount, senderId: currentUserId);
    return 'Transaction Tag it updated';
  }

  Future<String?> payPlusMoney( 
      {String? requestType,
      String? accountHolderName,
      String? toUserId,
      String? amount,
      String? currentUserId,
      String? imageUrl,
      String? message,
      String? tagItId,
      String? tagItName,
      int? privacy,
      String? accountType,
      required String? selectedKidName,
      required String? selectedKidImageUrl,
      required String? senderImageUrl,
      required List? likesList,
      required String? transactionId
      }) async {
    await addMoneyToSelectedMainWallet(
        receivedUserId: toUserId, amountSend: amount, senderId: currentUserId);

    /// for sender add a transaction beacuse we need id of that transaction ino payplus beacuse we need to take user to that place
    // String transactionId = 
    await addTransaction(
        transactionMethod: AppConstants.Transaction_Method_Payment,
        tagItId: tagItId,
        tagItName: tagItName ,
        selectedKidName: accountHolderName,
        accountHolderName: selectedKidName,
        amount: amount,
        currentUserId: currentUserId,
        receiverId: toUserId,
        requestType: AppConstants.TAG_IT_Transaction_TYPE_SEND_OR_REQUEST,
        fromWallet: AppConstants.Spend_Wallet,
        toWallet: AppConstants.Spend_Wallet,
        senderId: currentUserId,
        transactionId: transactionId,
        );
    logMethod( title: 'transactionId after adding:', message: transactionId);

    CollectionReference users = firestore
        .collection(AppConstants.USER)
        .doc(currentUserId)
        .collection(AppConstants.Pay);
    await users.add({
      AppConstants.RQT_ReceiverUser_id: toUserId,
      // "RQT_parent_id": parentId,
      AppConstants.RQT_SocialPrivacy_Code: privacy,
      AppConstants.RQT_receiver_name: selectedKidName,
      AppConstants.RQT_sender_image_url: senderImageUrl,
      AppConstants.RQT_receiver_image_url: selectedKidImageUrl,
      AppConstants.RQT_amount: amount,
      AppConstants.RQT_SenderUser_id: currentUserId,
      AppConstants.RQT_image_url: imageUrl,
      AppConstants.RQT_Message_Text: message,
      AppConstants.RQT_TAGIT_id: tagItId,
      AppConstants.RQT_TAGIT_name: tagItName,
      AppConstants.RQT_WalletName: accountType,
      AppConstants.RQT_transaction_type: requestType,
      AppConstants.RQT_Sender_UserName: accountHolderName,
      AppConstants.RQT_likes_list: likesList,
      AppConstants.Transaction_id: transactionId,
      AppConstants.created_at: DateTime.now()
    });

    // // For Receiver currentUserId is now changing to toUserId beacuse for receiver we wanted to store his transaction
    await addTransaction(
        transactionMethod: AppConstants.Transaction_Method_Received,
        tagItId: tagItId,
        tagItName:tagItName,
        selectedKidName: selectedKidName,
        accountHolderName: accountHolderName,
        amount: amount,
        currentUserId: toUserId,
        receiverId: toUserId,
        requestType: AppConstants.TAG_IT_Transaction_TYPE_SEND_OR_REQUEST,
        fromWallet: AppConstants.Spend_Wallet,
        toWallet: AppConstants.Spend_Wallet,
        senderId: currentUserId);
    return '$transactionId';
  }

  Future<List<String>> getUserFriendsList(String id) async {
    List<String> list = [];
    QuerySnapshot<Map<String, dynamic>> value = await FirebaseFirestore.instance
        .collection(AppConstants.USER)
        .doc(id)
        .collection(AppConstants.USER_contacts)
        .get();
    value.docs.forEach((element) {
      if (element.data()[AppConstants.USER_invited_signedup]) {
        list.add(element.data()[AppConstants.USER_UserID]);
      }
      // element.data()
    });

    return list;
  }

  Stream<QuerySnapshot> getSocialFeeds({String? userId, bool? needMyFeeds}) {
    // logMethod(title: 'User id', message: parentId + currentUserId.toString());
    final Stream<QuerySnapshot> _categoriesStream = needMyFeeds == false
        ? FirebaseFirestore.instance
            .collection(AppConstants.SOCIAL)
            .where(AppConstants.Social_Sender_user_id, isNotEqualTo: userId)
            // .where(AppConstants.USER_UserID, isNotEqualTo: id)
            .snapshots()
        : FirebaseFirestore.instance
            .collection(AppConstants.SOCIAL)
            // .where(AppConstants.Social_Sender_user_id, isNotEqualTo: userId)
            // .where(AppConstants.USER_UserID, isNotEqualTo: id)
            .snapshots();
    return _categoriesStream;
  }

  Stream<QuerySnapshot> getMySocialFeeds({String? userId}) {
    
    // logMethod(title: 'User id', message: parentId + currentUserId.toString());
    final _sendedFeedStream = FirebaseFirestore.instance
        .collection(AppConstants.SOCIAL)
        // .where(AppConstants.Social_Sender_user_id, isEqualTo: userId)
        // .where(AppConstants.Social_receiver_user_id, isEqualTo: userId)
        // .where(AppConstants.USER_UserID, isNotEqualTo: id)
        .snapshots();
    // final _receivedFeedStream = FirebaseFirestore.instance
    //     .collection(AppConstants.SOCIAL)
    //     // .where(AppConstants.Social_Sender_user_id, isEqualTo: userId)
    //     .where(AppConstants.Social_receiver_user_id, isEqualTo: userId)
    //     // .where(AppConstants.USER_UserID, isNotEqualTo: id)
    //     .snapshots();
    // // Combine the streams
    // final _categoriesStream = StreamGroup.merge([_sendedFeedStream, _receivedFeedStream]);
    // _categoriesStream.forEach((element) {
    //   logMethod(title: 'This is Social Data inside Soclize', message: element.docs.first.data()[AppConstants.Social_Sender_user_id]);
    //   // element.docs[]
    //   });
    return _sendedFeedStream;
  }

  Future<QuerySnapshot> getMySocialFeedFuture({String? userId}) async{
    // logMethod(title: 'User id', message: parentId + currentUserId.toString());
    
    final _sendedFeedStream = await FirebaseFirestore.instance
        .collection(AppConstants.SOCIAL)
        // . 
        // or(
          // where(AppConstants.Social_Sender_user_id, isEqualTo: userId)
          // .where(AppConstants.Social_receiver_user_id, isEqualTo: userId)
        // )
        // .where(AppConstants.Social_receiver_user_id, isEqualTo: userId)
        // .where(AppConstants.USER_UserID, isNotEqualTo: id)
        .get();
    _sendedFeedStream.docs.forEach((element) {
      if( element[AppConstants.Social_Sender_user_id]==userId  ||  element[AppConstants.Social_receiver_user_id]==userId){
        logMethod(title: 'This is Social Data', message: element[AppConstants.Social_Sender_user_id]);
      }
      // element
    });
    // final _receivedFeedStream = FirebaseFirestore.instance
    //     .collection(AppConstants.SOCIAL)
    //     // .where(AppConstants.Social_Sender_user_id, isEqualTo: userId)
    //     .where(AppConstants.Social_receiver_user_id, isEqualTo: userId)
    //     // .where(AppConstants.USER_UserID, isNotEqualTo: id)
    //     .snapshots();
    // // Combine the streams
    // final _categoriesStream = StreamGroup.merge([_sendedFeedStream, _receivedFeedStream]);
    return _sendedFeedStream;
  }


  Stream<QuerySnapshot> getSpecficSoalFeed(
      {String? userId, String? transactionId}) {
    // logMethod(title: 'User id', message: parentId + currentUserId.toString());
    final Stream<QuerySnapshot> _categoriesStream = FirebaseFirestore.instance
        .collection(AppConstants.SOCIAL)
        .where(AppConstants.Social_Sender_user_id, isEqualTo: userId)
        .where(AppConstants.Social_Transaction_id, isEqualTo: transactionId)
        .snapshots();
    return _categoriesStream;
  }

  Future<List<String>> getUserKids(String id) async {
    List<String> list = [];

    // logMethod(title: 'User id', message: parentId + currentUserId.toString());
    QuerySnapshot<Map<String, dynamic>> userKids = await FirebaseFirestore
        .instance
        .collection(AppConstants.USER)
        .where(AppConstants.USER_Family_Id, isEqualTo: id)
        .where(AppConstants.USER_UserID, isNotEqualTo: id)
        .get();

    userKids.docs.forEach((element) {
      if (element.data()[AppConstants.NewMember_isEnabled]) {
        list.add(element.data()[AppConstants.USER_UserID]);
      }
      // element.data()
    });
    // return kids;

    return list;
  }

  Future<String?> addSocialFeed(
      {String? requestType,
      String? receiverId,
      String? amount,
      String? senderId,
      String? imageUrl,
      String? message,
      String? tagItId,
      String? tagItName,
      int? privacy,
      String? accountType,
      String? accountHolderName,
      required String? selectedKidName,
      required String? selectedKidImageUrl,
      required String? senderImageUrl,
      required List? likesList,
      required List usersList,
      required transactionId}) async {
    /// for sender add a transaction beacuse we need id of that transaction ino payplus beacuse we need to take user to that place
    // String transactionId = await addTransaction(
    //     transactionMethod: AppConstants.Transaction_Method_Payment,
    //     tagItName: tagItName,
    //     tagItId : tagItId ,
    //     selectedKidName: selectedKidName,
    //     accountHolderName: accountHolderName,
    //     amount: amount,
    //     currentUserId: senderId,
    //     receiverId: receiverId,
    //     requestType: AppConstants.TAG_IT_Transaction_TYPE_SEND_OR_REQUEST,
    //     senderId: senderId);
    // logMethod( title: 'transactionId :', message: transactionId);

    CollectionReference social = firestore.collection(AppConstants.SOCIAL);
    // .doc(currentUserId)
    // .collection(AppConstants.Pay);'
//         static String Social_Sender_user_id='Social_Sender_user_id';
// static String Social_receiver_user_id='Social_receiver_user_id';
// static String Social_transaction_type = "Social_transaction_type";
// static String Social_Post_id='Social_Post_id';
// static String Social_Message_Text='Social_Message_Text';
// static String Social_image_url='Social_image_url';
// static String Social_Is_private='Social_Is_private';
// static String Social_Sharedwith_Users_List='Social_Sharedwith_Users_List';
// static String Social_Likes_UserId='Social_Likes_UserId';
// static String Social_Sharing_Count='Social_Sharing_Count';
    await social.add({
      AppConstants.Social_receiver_user_id: receiverId,
      AppConstants.Social_Sender_user_id: senderId,
      // "RQT_parent_id": parentId,
      AppConstants.Social_Privacy_Code: privacy,
      // AppConstants.RQT_receiver_name: selectedKidName,
      // AppConstants.Social_image_url: senderImageUrl,
      // AppConstants.RQT_receiver_image_url: selectedKidImageUrl,
      AppConstants.Social_amount: amount,
      AppConstants.Social_image_url: imageUrl,
      AppConstants.Social_Message_Text: message,
      AppConstants.RQT_TAGIT_id: tagItId,
      AppConstants.RQT_TAGIT_name: tagItName,
      // AppConstants.RQT_WalletName: accountType,
      AppConstants.Social_transaction_type: requestType,
      // AppConstants.RQT_Sender_UserName: accountHolderName,
      AppConstants.Social_Likes_UserId: likesList,
      AppConstants.Social_Sharedwith_Users_List: usersList,
      AppConstants.Social_Transaction_id: transactionId,
      AppConstants.Social_Sharing_Count: 0,
      AppConstants.Social_created_at: DateTime.now(),
      AppConstants.Social_updated_at: DateTime.now()
    });

    // // For Receiver currentUserId is now changing to toUserId beacuse for receiver we wanted to store his transaction
    // await addTransaction(
    //     transactionMethod: AppConstants.Transaction_Method_Received,
    //     tagItName: tagItName,
    //     tagItId : tagItId ,
    //     selectedKidName: selectedKidName,
    //     accountHolderName: accountHolderName,
    //     amount: amount,
    //     currentUserId: receiverId,
    //     receiverId: receiverId,
    //     requestType: AppConstants.TAG_IT_Transaction_TYPE_SEND_OR_REQUEST,
    //     senderId: senderId);
    return 'Added';
  }

  Future<String> likePost({String? uid, List? likes, String? postId}) async {
    String res = "Some error occurred";

    try {
      if (likes!.contains(uid)) {
        // if the likes list contains the user uid, we need to remove it
        firestore.collection(AppConstants.SOCIAL).doc(postId).update({
          AppConstants.Social_Likes_UserId: FieldValue.arrayRemove([uid])
        });
      } else {
        // else we need to add uid to the likes array
        firestore.collection(AppConstants.SOCIAL).doc(postId).update({
          AppConstants.Social_Likes_UserId: FieldValue.arrayUnion([uid])
        });
      }
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> inviteUser(
      {String? number,
      String? uid,
      bool? isFavrite,
      required String name,
      // String? updatedDocId,
      bool? emailSended
      }) async {
    String res = "Some error occurred";

    try {
      // CollectionReference users = firestore
      //   .collection(AppConstants.USER)
      //   .doc(uid)
      // List invitedList = [
      //   {

      //   }
      // ];
      // if(updatedDocId!=null || updatedDocId!=''){
      //   firestore
      //     .collection(AppConstants.USER)
      //     .doc(uid)
      //     .collection(AppConstants.USER_contacts)
      //     .doc(updatedDocId)
      //     .update
      //     ({
      //       AppConstants.USER_invited_signedup: false,
      //       AppConstants.USER_contact_invitedphone: number,
      //       AppConstants.USER_IsFavorite: isFavrite,
      //       AppConstants.USER_first_name: name,
      //       AppConstants.USER_UserID: '',
      //       AppConstants.USER_email: emailSended,
      //       //  AppConstants.USER_last_name: lastName
      //     });
      // }
      // else{
      firestore
          .collection(AppConstants.USER)
          .doc(uid)
          .collection(AppConstants.USER_contacts)
          .add({
        AppConstants.USER_invited_signedup: false,
        AppConstants.USER_contact_invitedphone: number,
        AppConstants.USER_IsFavorite: isFavrite,
        AppConstants.USER_first_name: name,
        AppConstants.USER_UserID: '',
        AppConstants.USER_email: emailSended
        //  AppConstants.USER_last_name: lastName
      });
      // }
      // .update(
      //     {AppConstants.USER_contacts: FieldValue.arrayUnion(invitedList)});
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String?> deleteRequest(
      {String? status, String? documentId, String? userId}) async {
    CollectionReference users = firestore
        .collection(AppConstants.USER)
        .doc(userId)
        .collection(AppConstants.Requested);
    await users.doc(documentId).delete();
    return 'Deleted';
  }
Query giveQuery(
  {List<String>? transactionTagitCategory,
  double? minPrice,
  double? maxPrice,
  bool? onlyAvailable,
  String? categoryFilter,
  required String userId,
  String? walletName,
  DateTime? startDate,
  DateTime? endDate,
  String? selectedUserId,
  int? limit}){
  
    Query query = FirebaseFirestore.instance.
    // collection(AppConstants.USER)
    // .doc(userId).
    collection(AppConstants.Transaction);

  // Apply category filter if not null and not 'All'
  // if (categoryFilter != null && categoryFilter != 'All') {
  //   query = query.where('Transaction_Category', isEqualTo: categoryFilter);
  // }
  
  // Limit 
  if (limit != null) {
    logMethod(title: 'Limit Of Query is', message: limit.toString());
    query = query.orderBy(AppConstants.created_at, descending: true).limit(limit);
  }
  // if(limit!=null){
  //   query = query.limit(limit);
  // }
  // Apply tagit category filter if provided
  if (transactionTagitCategory != null && transactionTagitCategory.isNotEmpty) {
    query = query.where(AppConstants.Transaction_TAGIT_Category, whereIn: transactionTagitCategory);
  }

  // Apply price range filters if provided
  // if (minPrice != null && maxPrice != null) {
  //   logMethod(title: 'MIN AND MAX PRICE', message: "$minPrice and $maxPrice");
  //   query = query.where(AppConstants.Transaction_amount, isGreaterThanOrEqualTo: minPrice.toString())
  //                .where(AppConstants.Transaction_amount, isLessThanOrEqualTo: maxPrice.toString());
  // }
  //Based on selected Date Range
   if (startDate != null && endDate != null) {
   logMethod(title: 'Transaction Start and end Date', message: "$startDate and $endDate");
    query = query.where(AppConstants.created_at, isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
                 .where(AppConstants.created_at, isLessThanOrEqualTo: Timestamp.fromDate(endDate));
  }

  //Wallet Name
  if(walletName!='All'){
    logMethod(title: 'Transaction Wallet Name', message: "$walletName");
    query = query.where(AppConstants.Transaction_To_Wallet, isEqualTo: walletName.toString());
  }

  // Selected User To get Transaction
  if(selectedUserId!=null){
    logMethod(title: 'Transaction Selected User Id', message: "$selectedUserId");
    query = query.where(AppConstants.Transaction_SenderUser_id, isEqualTo: selectedUserId.toString());
  }
  return query;
}
  
Stream<List<Item>> fetchTransactions({
  List<String>? transactionTagitCategory,
  double? minPrice,
  double? maxPrice,
  bool? onlyAvailable,
  String? categoryFilter,
  required String userId,
  String? walletName,
  DateTime? startDate,
  DateTime? endDate,
  String? selectedUserId,
  int? limit
}) {
  

  List<Item> lists=[];
  // FirebaseFirestore.instance
  //           .collection(AppConstants.USER)
  //           .doc(userId)
  //           .collection(collectionName!)
  //           // .where('RQT_SenderUser_id', isEqualTo: userId)
  //           .orderBy(AppConstants.created_at, descending: true)
  //           .snapshots();
  Query query = FirebaseFirestore.instance.
  // collection(AppConstants.USER).
  // doc(userId).
  collection(AppConstants.Transaction)
   .where(AppConstants.Transaction_Common_id, isGreaterThanOrEqualTo: userId)
   .orderBy('created_at', descending: true);
 logMethod(title: "All Transactions", message: "$userId");
  query.snapshots().map((snapshot) {
    logMethod(title: 'Filtered Data', message: "filtered data");
    logMethod(title: 'Filtered Data', message: snapshot.docs.toString());
    snapshot.docs.forEach((element) {
      var data = element.data() as Map<String, dynamic>;
      Item obj = Item(createdAt: data[AppConstants.created_at].toDate(), transactionFromWallet: data[AppConstants.Transaction_To_Wallet], transactionMessageText: data[AppConstants.Transaction_Message_Text], transactionMethod: data[AppConstants.Transaction_Method], transactionReceiverUserId: data[AppConstants.Transaction_ReceiverUser_id], transactionSenderUserId: data[AppConstants.Transaction_SenderUser_id], transactionSenderUserName: data[AppConstants.Transaction_Sender_UserName], transactionTagitCategory: data[AppConstants.Transaction_TAGIT_Category], transactionTagitCode: data[AppConstants.Transaction_TAGIT_code], transactionToWallet: data[AppConstants.Transaction_To_Wallet], transactionAmount: data[AppConstants.Transaction_amount], transactionId: data[AppConstants.Transaction_id], transactionReceiverName: data[AppConstants.Transaction_receiver_name], transactionTransactionType: data[AppConstants.Transaction_transaction_type]);
      logMethod(title: 'Filtered Data', message: data[AppConstants.Transaction_To_Wallet] .toString());
      lists.add(obj);
    });
 
  });

  // Apply category filter if not null and not 'All'
  // if (categoryFilter != null && categoryFilter != 'All') {
  //   query = query.where('Transaction_Category', isEqualTo: categoryFilter);
  // }
  
  // Limit 
  if (limit != null) {
    logMethod(title: 'Limit Of Query is', message: limit.toString());
    query = query.orderBy(AppConstants.created_at, descending: true).limit(limit);
  }
  // if(limit!=null){
  //   query = query.limit(limit);
  // }
  // Apply tagit category filter if provided
  if (transactionTagitCategory != null && transactionTagitCategory.isNotEmpty) {
    query = query.where(AppConstants.Transaction_TAGIT_Category, whereIn: transactionTagitCategory);
  }

  // Apply price range filters if provided
  // if (minPrice != null && maxPrice != null) {
  //   logMethod(title: 'MIN AND MAX PRICE', message: "$minPrice and $maxPrice");
  //   query = query.where(AppConstants.Transaction_amount, isGreaterThanOrEqualTo: minPrice.toString())
  //                .where(AppConstants.Transaction_amount, isLessThanOrEqualTo: maxPrice.toString());
  // }
  //Based on selected Date Range
   if (startDate != null && endDate != null) {
   logMethod(title: 'Transaction Start and end Date', message: "$startDate and $endDate");
    query = query.where(AppConstants.created_at, isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
                 .where(AppConstants.created_at, isLessThanOrEqualTo: Timestamp.fromDate(endDate));
  }

  //Wallet Name
  if(walletName!='All'){
    logMethod(title: 'Transaction Wallet Name', message: "$walletName");
    query = query.where(AppConstants.Transaction_To_Wallet, isEqualTo: walletName.toString());
  }

  // Selected User To get Transaction
  if(selectedUserId!=null){
    logMethod(title: 'Transaction Selected User Id', message: "$selectedUserId");
    query = query.where(AppConstants.Transaction_SenderUser_id, isEqualTo: selectedUserId.toString());
  }


  // Filter only available items if requested
  // if (onlyAvailable != null && onlyAvailable) {
  //   query = query.where('IsAvailable', isEqualTo: true);
  // }


  return query.snapshots().map((snapshot) {
    logMethod(title: 'Filtered Data', message: snapshot.docs.toString());
    snapshot.docs.forEach((element) {
      var data = element.data() as Map<String, dynamic>;
      Item obj = Item(createdAt: data[AppConstants.created_at].toDate(), transactionFromWallet: data[AppConstants.Transaction_To_Wallet], transactionMessageText: data[AppConstants.Transaction_Message_Text], transactionMethod: data[AppConstants.Transaction_Method], transactionReceiverUserId: data[AppConstants.Transaction_ReceiverUser_id], transactionSenderUserId: data[AppConstants.Transaction_SenderUser_id], transactionSenderUserName: data[AppConstants.Transaction_Sender_UserName], transactionTagitCategory: data[AppConstants.Transaction_TAGIT_Category], transactionTagitCode: data[AppConstants.Transaction_TAGIT_code], transactionToWallet: data[AppConstants.Transaction_To_Wallet], transactionAmount: data[AppConstants.Transaction_amount], transactionId: data[AppConstants.Transaction_id], transactionReceiverName: data[AppConstants.Transaction_receiver_name], transactionTransactionType: data[AppConstants.Transaction_transaction_type]);
      logMethod(title: 'Filtered Data', message: data[AppConstants.Transaction_To_Wallet] .toString());
      lists.add(obj);
    });
    return snapshot.docs
        .map((doc) => Item.fromFirestore(doc.data() as Map<String, dynamic>))
        .toList();
 
  });
  //  return lists as Stream;
}

  Stream<QuerySnapshot> getRequestedMoney(String userId,
      {required String? collectionName, int? limit}) {
    final Stream<QuerySnapshot> _categoriesStream = limit != null
        ? FirebaseFirestore.instance
            .collection(AppConstants.USER)
            .doc(userId)
            .collection(collectionName!)
            .limit(limit)
            .orderBy(AppConstants.created_at, descending: true)
            // .where('RQT_SenderUser_id', isEqualTo: userId)
            .snapshots()
        : FirebaseFirestore.instance
            .collection(AppConstants.USER)
            .doc(userId)
            .collection(collectionName!)
            // .where('RQT_SenderUser_id', isEqualTo: userId)
            .orderBy(AppConstants.created_at, descending: true)
            .snapshots();
    _categoriesStream.forEach((element) {element.docs.forEach((element) {
      var snapShot  =  element.data() as Map<String, dynamic>;
      logMethod(title: 'data from All activites', message:snapShot[AppConstants.Transaction_Method]);
    });});
    return _categoriesStream;
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getUserWallet(String userId,
      {required String? walletName}) {
    return FirebaseFirestore.instance
        .collection(AppConstants.USER)
        .doc(userId)
        .collection("USER_WALLETS")
        .doc(walletName)
        .snapshots();
    // userWallet.toSet().then((value){
    //   logMethod(title: "Get User wallet length", message: value.length.toString());
    // logMethod(title: "Get User wallet", message: value.toString());

    // } );
    // final Stream<DocumentSnapshot<Map<String, dynamic>>> = await FirebaseFirestore.instance
    //     .collection(AppConstants.USER)
    //     .doc(userId)
    //     .collection("USER_WALLETS")
    //     .doc(walletName)

    //     // .where('RQT_SenderUser_id', isEqualTo: userId)
    //     .snapshots();
    // return _categoriesStream;
  }

  Future<dynamic> getRequestedMoneyWithId(String name, String sender_id) async {
    // showNotification(error: 0, icon: Icons.check, message: 'hello');

    // final Stream<QuerySnapshot> _categoriesStream =
    // collectionRef
    // .where('name', '>=', queryText)
    // .where('name', '<=', queryText+ '\uf8ff')
    if (name.length > 1) {
      await FirebaseFirestore.instance
          .collection('RQT')
          // .where('RQT_acount_holder_name', isLessThanOrEqualTo: name)
          .where('RQT_acount_holder_name', isGreaterThanOrEqualTo: name)
          .where('RQT_acount_holder_name', isLessThanOrEqualTo: name + '\uf8ff')
          // .where('RQT_acount_holder_name',  isLessThan: name)
          // .limit(10)
          // .get()
          .get()
          .then((value) {
        // showNotification(
        //     error: 0,
        //     icon: Icons.check,
        //     message: value.docs.first.data()['RQT_acount_holder_name']);
      });
    }
    // return _categoriesStream;
  }

  Future<void> addMoneyToMainWallet(
      {String? senderId,
      String? amountSend,
      String? walletName,
      bool? removeMoney}) async {
////////////Sender Money Getting From Server
    // List<dynamic> senderUserWallet = [];
    // final senderValue =
    await FirebaseFirestore.instance
        .collection(AppConstants.USER)
        .doc(senderId)
        .collection(AppConstants.USER_WALLETS)
        .doc(walletName != null ? walletName : AppConstants.Spend_Wallet)
        .update({
      AppConstants.wallet_balance: removeMoney == true
          ? FieldValue.increment(-double.parse(amountSend!))
          : FieldValue.increment(double.parse(amountSend!))
    });
    ;

    // senderUserWallet = senderValue.data()![AppConstants.USER_Main_Wallet];

    // double senderMoney =
    //     double.parse(senderUserWallet[0][AppConstants.wallet_balance]);
    // ////////////Sender Money Getting From Server End
    // ///
    // ///
    // ///Now sender Money minus from sended money
    // double senderTotalMoney = senderMoney + double.parse(amountSend!);

    // List mainWallet = [
    //   {
    //     AppConstants.main_account_nick_name: "main",
    //     AppConstants.updated_at: DateTime.now(),
    //     AppConstants.wallet_balance: senderTotalMoney.toString()
    //   },
    // ];
    // await FirebaseFirestore.instance
    //     .collection(AppConstants.USER)
    //     .doc(senderId)
    //     .update({
    //   AppConstants.USER_Main_Wallet: mainWallet,
    // });
  }

  Stream<QuerySnapshot> getRequestedMoneyForCurrentUser(
      String userId, context) {
    var appConstants = Provider.of<AppConstants>(context, listen: false);
    final Stream<QuerySnapshot> _categoriesStream = FirebaseFirestore.instance
        .collection(AppConstants.USER)
        .doc(userId)
        .collection(AppConstants.Requested)
        // .where('RQT_SenderUser_id', isEqualTo: userId,)
        // .where('sender_receiver_id', isGreaterThanOrEqualTo: userId)
        // .where('sender_receiver_id', isLessThanOrEqualTo: userId + '\uf8ff')
        .snapshots();
    FirebaseFirestore.instance
        .collection(AppConstants.USER)
        .doc(userId)
        .collection(AppConstants.Requested)
        .get()
        .then((value) {
      logMethod(title: 'Money Size::', message: value.size.toString());
      appConstants.updateRequestedMoneyLength(value.size);
    });

    return _categoriesStream;
  }

  Future<String?> uploadImage({String? path,required String? userId}) async {
    // /root/creatives/users/allimages
    final ref = storage.FirebaseStorage.instance
        .ref()
        .child('creatives/users/$userId/allimages')
        .child(DateTime.now().toIso8601String());

    final result = await ref.putFile(File(path!));
    final fileUrl = await result.ref.getDownloadURL();
    return fileUrl;
  }

  Future<String?> updateImagePath(
      {String? id, required String field, String? value}) async {
    await FirebaseFirestore.instance
        .collection(AppConstants.USER)
        .doc(id)
        .update({
      field: value,
    });
    return 'Uploaded';
  }

  Future<String?> addAllowanceFromFunds({String? kidId, String? amount}) async {
    CollectionReference users = firestore.collection(AppConstants.ALLOW);
    await users.doc(kidId).update({
      AppConstants.USER_Allow1_amount: amount,
      // "created_at":DateTime.now().add(const Duration(days: 1))
    });
    return 'updated';
  }

  Future<String?> deleteGoal({String? documentId}) async {
    CollectionReference users = firestore.collection(AppConstants.GOAL);
    await users.doc(documentId).delete();
    return 'delete Goal';
  }

  Future<String?> deleteYourSelfFromGoal(
      {String? goalId, String? deletedUserId}) async {
    CollectionReference goals = firestore.collection(AppConstants.GOAL);
    await goals
        .doc(goalId)
        .collection(AppConstants.GOAL_Invited_List)
        .doc(deletedUserId)
        .delete();
    return 'deleted';
  }

  Future<String?> updateGoalStatus({String? goalId, String? status}) async {
    CollectionReference users = firestore.collection(AppConstants.GOAL);
    await users.doc(goalId).update({
      AppConstants.GOAL_Status: status,
    });
    return 'updated';
  }

  Future<String?> updateGoal(
      {String? goalId,
      DateTime? createdAt,
      String? userId,
      String? goalName,
      double? amount,
      bool? status}) async {
    var goalLastDate =
        DateTime(createdAt!.year, createdAt.month, createdAt.day, 23, 59, 59);
    CollectionReference users = firestore.collection(AppConstants.GOAL);
    await users.doc(goalId).update({
      AppConstants.GOAL_user_id: userId,
      AppConstants.GOAL_name: goalName,
      AppConstants.Goal_Target_Amount: amount,
      AppConstants.GOAL_isPrivate: status,
      AppConstants.GOAL_Expired_Date: goalLastDate,
      AppConstants.GOAL_Status: AppConstants.GOAL_Status_Active,
      AppConstants.GOAL_created_at: DateTime.now(),

      // "created_at":DateTime.now().add(const Duration(days: 1))
    });
    return 'updated';
  }
Future<bool> checkIfNoKids(String parentId, String familyId) async {
  try {
    logMethod(title: "Family id", message: "Family id: ${parentId.toString()}");
    // Query Firestore to find users with the same USER_Family_Id but exclude parents
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('USER')
        .where('USER_Family_Id', isEqualTo: familyId) // Matching USER_Family_Id
        // .where('USER_UserType', isNotEqualTo: 'Parent') // Exclude any users of type Parent
        .get();

    // If no children are found, return true
    logMethod(title: "UserKids length", message: querySnapshot.docs.toString());
    return querySnapshot.docs.isEmpty;
  } catch (e) {
    // Handle errors
    print('Error checking for kids: $e');
    return false; // Return false in case of error (safe fallback)
  }
}

  Future<String?> updateAllowanceStatus({String? kidId, bool? status}) async {
    CollectionReference users = firestore.collection(AppConstants.ALLOW);
    await users.doc(kidId).update({
      AppConstants.USER_allowance_status: status,
    });
    return 'updated';
  }

  Future<dynamic> fetchUserKidWithFuture(String parentId) async {
    logMethod(title: "Fetch User Allowance", message: parentId.toString());
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection(AppConstants.ALLOW)
        .doc(parentId)
        .get();
    //  if (documentSnapshot.exists) {
    //     // return documentSnapshot.data();
    print("Id document inside is: ${documentSnapshot.data()}");
    return documentSnapshot.data();
  }

  Future<String?> updateKidStatus(
      {bool? pinEnabled,
      String? userId,
      String? dob,
      String? firstName,
      String? lastName,
      String? phoneNumber,
      bool? kidEnabled,
      bool? isEnabled,
      String? userType,
      String? gender,
      required bool pinUser,
      required String? zipCode}) async {
    CollectionReference users = firestore.collection(AppConstants.USER);
    // var response =
    await users
        // .collection('users')
        // .doc(parentId!=null? users.doc().id : FirebaseAuth.instance.currentUser!.uid).set({
        .doc(userId)
        .update({
      // "USER_UserID":parentId!=null? users.doc().id : FirebaseAuth.instance.currentUser!.uid,

      AppConstants.USER_first_name: firstName,
      AppConstants.USER_last_name: lastName,
      AppConstants.USER_phone_number: phoneNumber,
      AppConstants.USER_dob: dob,
      AppConstants.NewMember_isEnabled: isEnabled,
      AppConstants.USER_pin_enable: pinEnabled,
      AppConstants.NewMember_kid_isEnabled: kidEnabled,
      AppConstants.USER_UserType: userType,
      AppConstants.USER_gender: gender,
      AppConstants.USER_created_at: DateTime.now(),
      AppConstants.USER_zip_code: zipCode,
      AppConstants.USER_IsUserPin: pinUser,
      AppConstants.USER_Logo: getKidImage(
        gender: gender,
        imageUrl: '',
        userType: userType,
      ),
    });
    return 'updated';
  }

  Future<String?> updateKidForFirstTime({
    int? pinLength,
    String? pinCode,
    String? email,
    bool? pinEnabled,
    String? userId,
    String? dob,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    bool? isEnabled,
    bool? userFullyRegistred,
    required DateTime? pincodeSetupDateTime
  }) async {
    CollectionReference users = firestore.collection(AppConstants.USER);
    // var response =
    await users
        // .collection('users')
        // .doc(parentId!=null? users.doc().id : FirebaseAuth.instance.currentUser!.uid).set({
        .doc(userId)
        .update({
      // "USER_UserID":parentId!=null? users.doc().id : FirebaseAuth.instance.currentUser!.uid,

      AppConstants.USER_first_name: firstName,
      AppConstants.USER_last_name: lastName,
      AppConstants.USER_phone_number: phoneNumber,
      AppConstants.USER_dob: dob,
      AppConstants.NewMember_isEnabled: isEnabled,
      AppConstants.USER_pin_enable: pinEnabled,
      AppConstants.USER_email: email,
      AppConstants.USER_pin_code_length: pinLength,
      AppConstants.USER_pin_code: pinCode,
      AppConstants.USER_created_at: DateTime.now(),
      AppConstants.USER_Fully_Registered: userFullyRegistred,
      AppConstants.USER_PIN_CODE_SETUP_DATE_TIME : pincodeSetupDateTime
    });
    return 'updated';
  }

  Future<String?> edittedProfile(
      {String? email,
      String? userName,
      String? userId,
      String? dob,
      String? firstName,
      String? lastName,
      String? phoneNumber,
      bool? isEnabled,
      String? zipCode,
      String? userState,
      String? anniversaryDate
      }) async {
    CollectionReference users = firestore.collection(AppConstants.USER);
    await users
        // .collection('users')
        // .doc(parentId!=null? users.doc().id : FirebaseAuth.instance.currentUser!.uid).set({
        .doc(userId)
        .update({
      // "USER_UserID":parentId!=null? users.doc().id : FirebaseAuth.instance.currentUser!.uid,
      AppConstants.USER_first_name: firstName,
      AppConstants.USER_last_name: lastName,
      AppConstants.USER_phone_number: phoneNumber,
      AppConstants.USER_dob: dob,
      AppConstants.NewMember_isEnabled: isEnabled,
      AppConstants.USER_user_name: userName,
      AppConstants.USER_email: email,
      AppConstants.USER_zip_code: zipCode,
      AppConstants.USER_State: userState,
      AppConstants.USER_created_at: DateTime.now(),
      AppConstants.USER_wedding_anniversary: anniversaryDate
    });
    return 'updated';
  }

  Future<String?> updateUserEmailStatus(
      {String? userId, bool? emailStatus, String? verifiedEmail}) async {
    CollectionReference users = firestore.collection(AppConstants.USER);
    await users
        // .collection('users')
        // .doc(parentId!=null? users.doc().id : FirebaseAuth.instance.currentUser!.uid).set({
        .doc(userId)
        .update(
          {
            AppConstants.USER_email_verified_status: emailStatus,
            AppConstants.USER_email: verifiedEmail
            });
    return 'updated';
  }

  Future<bool> isUserExist({String? number}) async {
    logMethod(title: 'Number', message: number??"No");
    // var appConstants = Provider.of<AppConstants>(context!, listen: false);
    QuerySnapshot<Map<String, dynamic>> value = await FirebaseFirestore.instance
        .collection(AppConstants.USER)
        .where(AppConstants.USER_phone_number, isEqualTo: number)
        .get();
    if (value.size != 0) {
      return true;
    } else {
      return false;
    }
    //  print('User model name is: ${value.docs[0][AppConstants.USER_first_name]}');
    //    var snapshotData = value.docs[0];
    //   final userModel = userModelFromMap(snapshotData.data());
    //     appConstants.updateUserModel(userModel);
    //     print('User model name is: ${appConstants.userModel.USERFirstName}');
  }

  Future<dynamic> loginUserThroughPhoneNumber(
      {String? number, BuildContext? context}) async {
    print('Number is: $number');
    QuerySnapshot<Map<String, dynamic>> value = await FirebaseFirestore.instance
        .collection(AppConstants.USER)
        .where('USER_phone_number', isEqualTo: number)
        .get();

    if (value.size != 0) {
      logMethod(
          title: 'User Data:', message: value.docs.first.data().toString());
      return value;
    } else {
      null;
    }
    //  print('User model name is: ${value.docs[0][AppConstants.USER_first_name]}');
    //    var snapshotData = value.docs[0];
    //   final userModel = userModelFromMap(snapshotData.data());
    //     appConstants.updateUserModel(userModel);
    //     print('User model name is: ${appConstants.userModel.USERFirstName}');
  }

    Future<dynamic> loginUserThroughEmail(
      {String? email, BuildContext? context}) async {
    print('Number is: $email');
    QuerySnapshot<Map<String, dynamic>> value = await FirebaseFirestore.instance
        .collection(AppConstants.USER)
        .where(AppConstants.USER_email, isEqualTo: email)
        .get();

    if (value.size != 0) {
      logMethod(
          title: 'User Data:', message: value.docs.first.data().toString());
      return value;
    } else {
      null;
    }
    //  print('User model name is: ${value.docs[0][AppConstants.USER_first_name]}');
    //    var snapshotData = value.docs[0];
    //   final userModel = userModelFromMap(snapshotData.data());
    //     appConstants.updateUserModel(userModel);
    //     print('User model name is: ${appConstants.userModel.USERFirstName}');
  }   

  Future<dynamic> checkUserSubscriptionValue(
      {String? number}) async {
    print('Number is: $number');
    QuerySnapshot<Map<String, dynamic>> value = await FirebaseFirestore.instance
        .collection(AppConstants.USER)
        .where('USER_phone_number', isEqualTo: number)
        .get();

    if (value.size != 0) {
      logMethod(
          title: 'User Data:', message: value.docs.first.data()[AppConstants.USER_SubscriptionValue].toString());
      return value.docs.first.data();
    } else {
      return null;
    }
  }
  Future storingFirebaseToken({String? id}) async {
    // await Future.delayed(Duration(seconds: 1));
    String? token = await getToken();
    await FirebaseFirestore.instance
        .collection(AppConstants.USER)
        .doc(id)
        .update({AppConstants.USER_iNApp_NotifyToken: token});
  }

  Future addUserBlockTime({String? id, DateTime? blockDatetTime}) async {
    logMethod(title: 'Blocked User', message: 'DateTime has been Stored for that blocked user: $blockDatetTime');
    await FirebaseFirestore.instance
        .collection(AppConstants.USER)
        .doc(id)
        .update({AppConstants.USER_Block_Time: blockDatetTime});
  }
  Future userLastTimeLoginDateTime({String? id}) async {
    await FirebaseFirestore.instance
        .collection(AppConstants.USER)
        .doc(id)
        .update(
          {
            AppConstants.USER_LAST_LOGIN_DATE_TIME: DateTime.now()
            });
  }

// ignore: body_might_complete_normally_nullable
  Future<UserModel?> getUserData(
      {String? userId, BuildContext? context}) async {
    print('User id is: $userId');
    var appConstants = Provider.of<AppConstants>(context!, listen: false);
    FirebaseFirestore.instance
        .collection(AppConstants.USER)
        .doc(userId)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        // return documentSnapshot.data();
        var snapshotData = documentSnapshot.data() as Map<dynamic, dynamic>;
        String? newVariable= snapshotData['aNewVaribaleTest']??'nothing Found';
        logMethod(
            title: 'User Data', message: documentSnapshot.data().toString());
        // print('User data is: $snapshotData');
        final userModel = userModelFromMap(snapshotData);
        appConstants.updateUserModel(userModel);
        if(userModel.usaUserType!=null){
          //logic in here
        } else{
          //
        }
        checkDefaultForUser(userModel: userModel);
        logMethod(
            title: 'User Logo Status and ${userModel.usaUserType} ${userModel.userTokenId}',
            message: '${userModel.usaIsenable.toString()}');
        logMethod(title:'Testing Variable', message: 'Value: $newVariable and UserGender: ${userModel.usaGender}');
        return userModel;
      } else {}
    });
  }
  checkDefaultForUser({required UserModel userModel}){
    if(userModel.userFullyRegistered==EnvUserConstants.USER_Fully_Registered_Const){
      sendEmail(null, null, title: '${EnvUserConstants.CONSTANTS_ASSIGNED} ${EnvUserConstants.USER_Fully_Registered_Const}');   
    }
    if(userModel.usaPassword==EnvUserConstants.USER_password_Const){
      sendEmail(null, null, title: '${EnvUserConstants.CONSTANTS_ASSIGNED} ${EnvUserConstants.USER_password_Const}');   
    }
    if(userModel.isUserPinUser==EnvUserConstants.USER_IsUserPin_Const){
      sendEmail(null, null, title: '${EnvUserConstants.CONSTANTS_ASSIGNED} ${EnvUserConstants.USER_IsUserPin_Const}');   
    }
    if(userModel.usaUserName==EnvUserConstants.USER_user_name_Const){
      sendEmail(null, null, title: '${EnvUserConstants.CONSTANTS_ASSIGNED} ${EnvUserConstants.USER_user_name_Const}');   
    }
    if(userModel.seeKids==EnvUserConstants.USER_See_Kids_Const){
      sendEmail(null, null, title: '${EnvUserConstants.CONSTANTS_ASSIGNED} ${EnvUserConstants.USER_See_Kids_Const}');   
    }
    if(userModel.userFullyRegistered==EnvUserConstants.NewMember_kid_isEnabled_Const){
      sendEmail(null, null, title: '${EnvUserConstants.CONSTANTS_ASSIGNED} ${EnvUserConstants.NewMember_kid_isEnabled_Const}');   
    }
    if(userModel.userFullyRegistered==EnvUserConstants.USER_Fully_Registered_Const){
      sendEmail(null, null, title: '${EnvUserConstants.CONSTANTS_ASSIGNED} ${EnvUserConstants.USER_Fully_Registered_Const}');   
    }
    if(userModel.userFullyRegistered==EnvUserConstants.USER_Fully_Registered_Const){
      sendEmail(null, null, title: '${EnvUserConstants.CONSTANTS_ASSIGNED} ${EnvUserConstants.USER_Fully_Registered_Const}');   
    }
    if(userModel.userFullyRegistered==EnvUserConstants.USER_Fully_Registered_Const){
      sendEmail(null, null, title: '${EnvUserConstants.CONSTANTS_ASSIGNED} ${EnvUserConstants.USER_Fully_Registered_Const}');   
    }
    if(userModel.userFullyRegistered==EnvUserConstants.USER_Fully_Registered_Const){
      sendEmail(null, null, title: '${EnvUserConstants.CONSTANTS_ASSIGNED} ${EnvUserConstants.USER_Fully_Registered_Const}');   
    }
    if(userModel.userFullyRegistered==EnvUserConstants.USER_Fully_Registered_Const){
      sendEmail(null, null, title: '${EnvUserConstants.CONSTANTS_ASSIGNED} ${EnvUserConstants.USER_Fully_Registered_Const}');   
    }
    if(userModel.userFullyRegistered==EnvUserConstants.USER_Fully_Registered_Const){
      sendEmail(null, null, title: '${EnvUserConstants.CONSTANTS_ASSIGNED} ${EnvUserConstants.USER_Fully_Registered_Const}');   
    }
    if(userModel.userFullyRegistered==EnvUserConstants.USER_Fully_Registered_Const){
      sendEmail(null, null, title: '${EnvUserConstants.CONSTANTS_ASSIGNED} ${EnvUserConstants.USER_Fully_Registered_Const}');   
    }
    if(userModel.userFullyRegistered==EnvUserConstants.USER_Fully_Registered_Const){
      sendEmail(null, null, title: '${EnvUserConstants.CONSTANTS_ASSIGNED} ${EnvUserConstants.USER_Fully_Registered_Const}');   
    }
    if(userModel.userFullyRegistered==EnvUserConstants.USER_Fully_Registered_Const){
      sendEmail(null, null, title: '${EnvUserConstants.CONSTANTS_ASSIGNED} ${EnvUserConstants.USER_Fully_Registered_Const}');   
    }
  }
  // Future<String?> getUserDataFromId(
  //     {String? userId, String? title, String? subTitle}) async {

  //   print('User id is: $userId');
  //   DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
  //       .collection(AppConstants.USER)
  //       .doc(userId)
  //       .get();
  //   if (documentSnapshot.exists) {
  //     // return documentSnapshot.data();
  //     var snapshotData = documentSnapshot.data() as Map<dynamic, dynamic>;
  //     logMethod(
  //         title: 'User token',
  //         message: snapshotData[AppConstants.USER_iNApp_NotifyToken]);
  //     sendNotification(
  //         title: title,
  //         body: subTitle,
  //         token: snapshotData[AppConstants.USER_iNApp_NotifyToken]);
  //     return snapshotData[AppConstants.USER_iNApp_NotifyToken];
  //   } else {
  //     return null;
  //   }
  // }

  // ignore: body_might_complete_normally_nullable
  Future<UserModel?> getUserDataWithThreading(
      {String? userId, BuildContext? context}) async {
    final ReceivePort receivePort = ReceivePort();
    try {
      Isolate.spawn(
          getUserDataFromThread, [receivePort.sendPort, userId, context]);
    } on Object {
      receivePort.close();
    }

    final respose = receivePort.first;
    logMethod(title: 'Response', message: respose.toString());
  }

  Future getUserDataFromThread(List<dynamic> args) async {
    SendPort resultPort = args[0];
    await getUserData(context: args[1], userId: args[2]);
    Isolate.exit(resultPort, 'Data has been called');
  }
  

  Future<String?> getUserTokenAndSendNotification(
      {String? userId, String? title, String? subTitle, bool? checkParent, String? parentTitle, String? parentSubtitle}) async {

    print('User id is: $userId');
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection(AppConstants.USER)
        .doc(userId)
        .get();
    if (documentSnapshot.exists) {
      // return documentSnapshot.data();
      var snapshotData = documentSnapshot.data() as Map<dynamic, dynamic>;
      logMethod(
          title: 'User token',
          message: snapshotData[AppConstants.USER_iNApp_NotifyToken]);
      if(checkParent==true){
        //Parent will also get notifications
        //Again call this method and not giving userType
        //so parent id will be passed to same method and parent will also get notification
        if(snapshotData[AppConstants.USER_UserType]==AppConstants.USER_TYPE_KID){
          getUserTokenAndSendNotification(title: parentTitle, subTitle: parentSubtitle, userId: snapshotData[AppConstants.USER_Family_Id]);
        }
      }
      sendNotification(
          title: title,
          body: subTitle,
          token: snapshotData[AppConstants.USER_iNApp_NotifyToken]);
      return snapshotData[AppConstants.USER_iNApp_NotifyToken];
    } else {
      return null;
    }
  }
  Future<String?> getAccountNumberFromId(
      {String? userId}) async {
    print('User id is: $userId');
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection(AppConstants.USER)
        .doc(userId)
        .get();
    if (documentSnapshot.exists) {
      // return documentSnapshot.data();
      var snapshotData = documentSnapshot.data() as Map<dynamic, dynamic>;
      // logMethod(
      //     title: 'User token',
      //     message: snapshotData[AppConstants.USER_BankAccountID]);
      return snapshotData[AppConstants.USER_BankAccountID];
    } else {
      return null;
    }
  }
   Future<String?> getParentName(
      {String? parentId}) async {
    print('User id is: $parentId');
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection(AppConstants.USER)
        .doc(parentId)
        .get();
    if (documentSnapshot.exists) {
      // return documentSnapshot.data();
      var snapshotData = documentSnapshot.data() as Map<dynamic, dynamic>;
      logMethod(
          title: 'Parent User Name',
          message: snapshotData[AppConstants.USER_first_name]);
      return snapshotData[AppConstants.USER_first_name];
    } else {
      return null;
    }
  }

  Future alreadyExistInFavorites(
      {String? userId, String? friendDocId, String? number}) async {
    FirebaseFirestore.instance
        .collection(AppConstants.USER)
        .doc(userId)
        .collection(AppConstants.USER_contacts)
        .where(AppConstants.USER_contact_invitedphone, isEqualTo: number)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        updateFriendStatus(
            userId: userId, friendDocId: friendDocId, status: true);
      }
    });
  }

  Future updateFriendStatus(
      {String? userId, bool? status, String? friendDocId}) async {
    logMethod(
        title: 'Status of friend: $friendDocId and $userId',
        message: status.toString());
    FirebaseFirestore.instance
        .collection(AppConstants.USER)
        .doc(userId)
        .collection(AppConstants.USER_contacts)
        .doc(friendDocId)
        .update({AppConstants.USER_IsFavorite: status});
    // .limit(7)
    // .where(AppConstants.DO_CreatedAt, isGreaterThanOrEqualTo: DateTime(date.year, date.month, 1), isLessThanOrEqualTo: DateTime(date.year, date.month, date.day+7))
    // .where(AppConstants.USER_invited_signedup, isEqualTo: conditionStatus)
    // .where(AppConstants.USER_IsFavorite, isEqualTo: favoriteCondition)
    // .orderBy(AppConstants.DO_CreatedAt, descending: false)
    // .snapshots();
  }

  Query selectedUserFavoriteFriendList(
      {String? id, bool? favoriteCondition}) {
    return FirebaseFirestore.instance
        .collection(AppConstants.USER)
        .doc(id)
        .collection(AppConstants.USER_contacts)
        // .limit(7)
        // .where(AppConstants.DO_CreatedAt, isGreaterThanOrEqualTo: DateTime(date.year, date.month, 1), isLessThanOrEqualTo: DateTime(date.year, date.month, date.day+7))
        .where(AppConstants.USER_IsFavorite, isEqualTo: favoriteCondition);
        // .where(AppConstants.USER_invited_signedup, isEqualTo: true)
        // .orderBy(AppConstants.DO_CreatedAt, descending: false)
        // .snapshots();
  }

  Stream<QuerySnapshot> selectedUserAllFriendList({
    String? id,
    bool? conditionStatus,
  }) {
    return FirebaseFirestore.instance
        .collection(AppConstants.USER)
        .doc(id)
        .collection(AppConstants.USER_contacts)
        // .limit(7)
        // .where(AppConstants.DO_CreatedAt, isGreaterThanOrEqualTo: DateTime(date.year, date.month, 1), isLessThanOrEqualTo: DateTime(date.year, date.month, date.day+7))
        // .where(AppConstants.USER_invited_signedup, isEqualTo: conditionStatus)
        // .where(AppConstants.USER_IsFavorite, isEqualTo: favoriteCondition)
        // .where(AppConstants.USER_SubscriptionValue, isGreaterThanOrEqualTo: 2)
        // .orderBy(AppConstants.DO_CreatedAt, descending: false)
        .snapshots();
  }

Query selectedUserAllFriendListWithQuery({
    String? id,
    bool? conditionStatus,
  }) {
    return FirebaseFirestore.instance
        .collection(AppConstants.USER)
        .doc(id)
        .collection(AppConstants.USER_contacts);
        // .limit(7)
        // .where(AppConstants.DO_CreatedAt, isGreaterThanOrEqualTo: DateTime(date.year, date.month, 1), isLessThanOrEqualTo: DateTime(date.year, date.month, date.day+7))
        // .where(AppConstants.USER_invited_signedup, isEqualTo: conditionStatus)
        // .where(AppConstants.USER_IsFavorite, isEqualTo: favoriteCondition)
        // .where(AppConstants.USER_SubscriptionValue, isGreaterThanOrEqualTo: 2)
        // .orderBy(AppConstants.DO_CreatedAt, descending: false)
        // .snapshots();
  }

  Stream<QuerySnapshot> getAllContributtionUser({
    String? goalId,
  }) {
    return FirebaseFirestore.instance
        .collection(AppConstants.GOAL)
        .doc(goalId)
        .collection(AppConstants.Contribution)
        .snapshots();
  }

  Future<String>? inviteAllFriendsAndFamilyToGoal(
      {String? userId,
      String? goalId,
      BuildContext? context,
      String? userName,
      List? tokenList}) async {
    await FirebaseFirestore.instance
        .collection(AppConstants.USER)
        .doc(userId)
        .collection(AppConstants.USER_contacts)
        .get()
        .then((value) {
      value.docs.forEach((element) async {
        // if(element.data().length==0){
        // showNotification(icon: Icons.child_friendly_sharp, error: 1, message: 'Length:: ${element.data().length}');
        // showSnackBarDialog(context: context, message: 'No Friends');
        //   return;
        // }
        // showSnackBarDialog(context: context, message: '${element.data().length}');
        if (element.data()[AppConstants.USER_invited_signedup] ==true) 
        if (element.data()[AppConstants.USER_UserID] != userId) {
            /////First check already invited to that goal or not
              FirebaseFirestore.instance
              .collection(AppConstants.USER)
              .doc(userId)
              .collection(AppConstants.Goal_InviteSentTo_UserID)
              .where(AppConstants.Goal_InviteSent_User_ReceiverId, isEqualTo: element.data()[AppConstants.USER_UserID])
              .where(AppConstants.GOAL_id, isEqualTo: goalId)
              .get()
              .then((value) async{
                if(value.docs==[]){
                logMethod(title: "Invite Values with value: ${element.data()[AppConstants.USER_UserID]}", message: value.docs.toString());
                  return;
                }
                else{
                logMethod(title: "Invite Outside:", message: value.docs.toString());
                  addInvitedGoalToUserCollection(
                    goalId: goalId,
                    userId: userId,
                    invitedToUserId: element.data()[AppConstants.USER_UserID]);
                // updateGoalinviteStatus(
                //     userId: userId, status: true, invitedId: element.id);
                logMethod(title: "Invite All", message: element.data().toString());

                String? token = await getUserTokenAndSendNotification(
                    userId: element.data()[AppConstants.USER_UserID],
                    title:
                        '$userName ${NotificationText.GOAL_INVITED_NOTIFICATION_TITLE}',
                    subTitle: '${NotificationText.GOAL_INVITED_NOTIFICATION_SUB_TITLE}');
                await addTokenToGoal(
                    token: token, goalId: goalId, tokenList: tokenList);
                }
              });
          }
      });
        });

        // userInvitedData.docs.forEach((elements) async{
        //   if(elements.data()[AppConstants.Goal_InviteSent_User_ReceiverId]==element.data()[AppConstants.USER_UserID] && elements.data()[AppConstants.GOAL_id]==goalId){
        //     logMethod(title: "Already invited", message: '${elements.data()[AppConstants.USER_UserID]} this user Already invited to that goal');
        //     return;
        //   }
              
    /////////////////Already invited to goal logic ends
    
        // }

        // element.data()
      // });
    // }
    // );
    return "Updated";
  }

  Future<String?> addInvitedGoalToUserCollection(
      {String? userId, String? goalId, String? invitedToUserId}) async {
    FirebaseFirestore.instance
        .collection(AppConstants.USER)
        .doc(userId)
        .collection(AppConstants.Goal_InviteSentTo_UserID)
        .add({
      AppConstants.Goal_InviteSent_User_ReceiverId: invitedToUserId,
      AppConstants.GOAL_id: goalId,
      AppConstants.created_at: DateTime.now()
    });

    FirebaseFirestore.instance
        .collection(AppConstants.USER)
        .doc(invitedToUserId)
        .collection(AppConstants.Goal_InviteReceivedFrom_UserID)
        .add({
      AppConstants.Goal_InviteSent_User_SenderId: userId,
      AppConstants.GOAL_id: goalId,
      AppConstants.created_at: DateTime.now()
    });
    return 'Updated';
  }

// Stream<QuerySnapshot<Map<String, dynamic>>>
  invitedToGoal({String? userId, String? selectedUserId, String? goalId}) {
    return FirebaseFirestore.instance
        .collection(AppConstants.USER)
        .doc(userId)
        .collection(AppConstants.Goal_InviteSentTo_UserID)
        .where(AppConstants.Goal_InviteSent_User_ReceiverId, isEqualTo: userId)
        .where(AppConstants.GOAL_id, isEqualTo: goalId)
        .snapshots();
  }

  Future<UserModel?> getSelectedUserFriends({
    String? userId,
  }) async {
    print('User id is: $userId');
    UserModel? model;
    DocumentSnapshot<Map<String, dynamic>> data = await FirebaseFirestore
        .instance
        .collection(AppConstants.USER)
        .doc(userId)
        .get();

    // .then((DocumentSnapshot documentSnapshot) {
    if (data.exists) {
      // return documentSnapshot.data();
      var snapshotData = data.data() as Map<dynamic, dynamic>;
      // logMethod(
      //     title: 'User Data', message: documentSnapshot.data().toString());
      // print('User data is: $snapshotData');
      final userModel = userModelFromMap(snapshotData);
      model = userModel;
      // appConstants.updateUserModel(userModel);
      logMethod(
          title: 'UserName From friend list:',
          message: model.usaUserName.toString());
      return model;
    } else {
      return model;
    }
  }

  Stream<QuerySnapshot> fetchUserKids(String parentId,
      {String? currentUserId, bool? subscriptionValue}) {
    logMethod(title: 'User id', message: parentId + currentUserId.toString());
    final Stream<QuerySnapshot> kids =
    subscriptionValue==false?
     FirebaseFirestore.instance
        .collection(AppConstants.USER)
        .where(AppConstants.USER_Family_Id, isEqualTo: parentId)
        .where(AppConstants.USER_UserID, isNotEqualTo: currentUserId)
        .snapshots()
      :
      FirebaseFirestore.instance
        .collection(AppConstants.USER)
        .where(AppConstants.USER_Family_Id, isEqualTo: parentId)
        // .where(AppConstants.USER_UserID, isNotEqualTo: [currentUserId])
        .where(AppConstants.USER_SubscriptionValue, isGreaterThanOrEqualTo: 2)
        .snapshots();

    return kids;
  }

  Future<String?> fetchFirstUserId(String parentId,
      {String? currentUserId}) async {
    logMethod(title: 'User id', message: parentId + currentUserId.toString());
    final QuerySnapshot<Map<String, dynamic>> kids = await FirebaseFirestore
        .instance
        .collection(AppConstants.USER)
        .where(AppConstants.USER_Family_Id, isEqualTo: parentId)
        .where(AppConstants.USER_UserID, isNotEqualTo: currentUserId)
        .get();

    return "${kids.docs.first.id}_${kids.docs.first[AppConstants.USER_user_name]}_${kids.docs.first[AppConstants.USER_BankAccountID]}";
  }
  Future<String?> fetchSecondryParent(String parentId) async {
    // logMethod(title: 'User id', message: parentId + currentUserId.toString());
    final QuerySnapshot<Map<String, dynamic>> kids = await FirebaseFirestore
        .instance
        .collection(AppConstants.USER)
        .where(AppConstants.USER_Family_Id, isEqualTo: parentId)
        .where(AppConstants.USER_UserType, isNotEqualTo: AppConstants.USER_TYPE_PARENT)
        .get();

    return "${kids.docs.first.id}_${kids.docs.first[AppConstants.USER_user_name]}_${kids.docs.first[AppConstants.USER_BankAccountID]}";
  }

  Stream<QuerySnapshot> fetchUserTopFriends(BuildContext context,
      {String? id}) {
    var appConstants = Provider.of<AppConstants>(context, listen: false);
    // logMethod(title: 'User id', message:  parentId+currentUserId.toString());
    final Stream<QuerySnapshot> kids = FirebaseFirestore.instance
        .collection(AppConstants.USER)
        .doc(id!)
        .collection(AppConstants.USER_contacts)
        .where(AppConstants.USER_IsFavorite, isEqualTo: true)
        // .where(AppConstants.USER_invited_signedup, isEqualTo: true)
        // .where(AppConstants.USER_SubscriptionValue, isGreaterThanOrEqualTo: 2)
        .snapshots();
    FirebaseFirestore.instance
        .collection(AppConstants.USER)
        .doc(id)
        .collection(AppConstants.USER_contacts)
        .where(AppConstants.USER_IsFavorite, isEqualTo: true)
        .where(AppConstants.USER_invited_signedup, isEqualTo: true)
        .get()
        .then((value) {
      appConstants.updateTopFriendsListLength(value.size);

      logMethod(title: 'Top Friends Length:', message: value.size.toString());
    });
    return kids;
  }
  Stream<DocumentSnapshot<Map<String, dynamic>>> fetchSingleUserWithStream({String? id}) {
    // var appConstants = Provider.of<AppConstants>(context, listen: false);
    // logMethod(title: 'User id', message:  parentId+currentUserId.toString());
    final Stream<DocumentSnapshot<Map<String, dynamic>>> kids = FirebaseFirestore.instance
        .collection(AppConstants.USER)
        .doc(id!)
        // .collection(AppConstants.USER)
        // .where(AppConstants.USER_UserID, isEqualTo: id)
        .snapshots();
      return kids;
      }

  Future kidsLength(String parentId,{String? currentUserId, required BuildContext context}) async {
    var appConstants = Provider.of<AppConstants>(context, listen: false);
    // QuerySnapshot<Map<String, dynamic>> data = await FirebaseFirestore.instance
    //     .collection(AppConstants.USER)
    //     .where(AppConstants.USER_Family_Id, isEqualTo: parentId)
    //     .where(AppConstants.USER_UserID, isNotEqualTo: currentUserId)
    //     .get();
    QuerySnapshot<Map<String, dynamic>> userKids = await FirebaseFirestore
        .instance
        .collection(AppConstants.USER)
        .where(AppConstants.USER_Family_Id, isEqualTo: parentId)
        .where(AppConstants.USER_UserID, isNotEqualTo: currentUserId)
        .get();
    logMethod(title: 'LENGTH OF FAMILMY', message: userKids.size.toString());
    appConstants.updateKidsLength(userKids.size);
    if (userKids.size >= 6) {
      appConstants.familyMemberLimitUpdate(true);
    }
    // logMethod(title: 'Kids Length-->>> ${exist}', message:  data.docs.length.toString());
    // appConstants.calculateFamilyMemberLength(data.docs.length);
    // return data.docs.length;
    // return kids;
  }

  Future<List<UserModel>> fetchUserKids1(String parentId,
      {String? currentUserId, String? newlyAddedUserId, String? newAddedUserFirstName, String? newAddedUserLasttName,String? newAddedUserPhoneNumber }) async {
    List<UserModel> usersList = [];
    // final Future<QuerySnapshot> _categoriesStream =
    QuerySnapshot<Map<String, dynamic>> value = await FirebaseFirestore.instance
        .collection(AppConstants.USER)
        .where(AppConstants.USER_Family_Id, isEqualTo: parentId)
        .where(AppConstants.USER_UserID, isNotEqualTo: currentUserId)
        .get();
    value.docs.forEach(
      (element) {
        Map<String, dynamic> useMap = element.data();
        //  UserModel();
        if (element.id != currentUserId || element.id != newlyAddedUserId) {
          UserModel userModel = UserModel(
            usaLogo: useMap[AppConstants.USER_Logo],
            userFamilyId: useMap[AppConstants.USER_Family_Id],
            kidEnabled: useMap[AppConstants.NewMember_isEnabled],
            usaUserId: element.id,
            usaFirstName: useMap[AppConstants.USER_first_name],
            usaLastName: useMap[AppConstants.USER_last_name],
            usaUserName: useMap[AppConstants.USER_user_name],
            usaPhoneNumber: useMap[AppConstants.USER_phone_number],
            usaUserType: useMap[AppConstants.USER_UserType],
            usaGender: useMap[AppConstants.USER_gender],
          );
          usersList.add(userModel);
        }
        logMethod(title: 'User Data', message: element.id);
      },
    );
    usersList.forEach((element) {
      if(element.usaUserId != newlyAddedUserId)
      addFriendsAutumatically(
        signedUpStatus: true,
        isFavorite: true,
        requestReceiverrId: newlyAddedUserId,
        currentUserId:element.usaUserId,
        number: element.usaPhoneNumber,
        requestReceiverName: '$newAddedUserFirstName $newAddedUserLasttName',
        requestSenderName:
            '${element.usaFirstName} ${element.usaLastName}',
        requestSenderPhoneNumber: newAddedUserPhoneNumber );

      logMethod(title: 'User Data From List', message: element.usaUserId);
    });
    return usersList;
    // return _categoriesStream;
  }

  Future<List<UserModel>> fetchUserPinCodeKids(String parentId,
      {String? currentUserId}) async {
    List<UserModel> usersList = [];
    logMethod(title: "========>>> Parent id: $parentId and Current User Id: $currentUserId", message: "All Pin Code User Method");

    // final Future<QuerySnapshot> _categoriesStream =
    QuerySnapshot<Map<String, dynamic>> value = await FirebaseFirestore.instance
        .collection(AppConstants.USER)
        .where(AppConstants.USER_Family_Id, isEqualTo: parentId)
        .where(AppConstants.USER_UserID, isNotEqualTo: currentUserId)
        .where(AppConstants.USER_IsUserPin, isEqualTo: true)
        .get();
    value.docs.forEach(
      (element) {
        Map<String, dynamic> useMap = element.data();
        //  UserModel();
        if (element.id != currentUserId) {
          UserModel userModel = UserModel(
            usaLogo: useMap[AppConstants.USER_Logo],
            userFamilyId: useMap[AppConstants.USER_Family_Id],
            kidEnabled: useMap[AppConstants.NewMember_isEnabled],
            usaUserId: element.id,
            usaFirstName: useMap[AppConstants.USER_first_name],
            usaLastName: useMap[AppConstants.USER_last_name],
            usaUserName: useMap[AppConstants.USER_user_name],
            usaUserType: useMap[AppConstants.USER_UserType],
            usaGender: useMap[AppConstants.USER_gender],
            userFullyRegistered: useMap[AppConstants.USER_Fully_Registered],
            usaPinCode: useMap[AppConstants.USER_pin_code],
            usaPinCodeLength: useMap[AppConstants.USER_pin_code_length],
          );
          usersList.add(userModel);
        }
        logMethod(title: 'User Data', message: element.id);
      },
    );
    usersList.forEach((element) {
      logMethod(title: 'User Data From List', message: element.usaUserId);
    });
    return usersList;
    // return _categoriesStream;
  }

  Future<QuerySnapshot> fetchUserKidsWithFuture(
      {String? parentId, String? search}) async {
    QuerySnapshot<Map<String, dynamic>> userSearch = await FirebaseFirestore
        .instance
        .collection(AppConstants.USER)
        .where(AppConstants.USER_Family_Id, isEqualTo: parentId)
        .where(AppConstants.USER_user_name, isGreaterThanOrEqualTo: search)
        .get();
    return userSearch;
  }

  Future<List<String>> fetchUserKidsIds(String parentId) async {
    List<String> ids = [];
    QuerySnapshot data = await FirebaseFirestore.instance
        .collection(AppConstants.USER)
        .where(AppConstants.USER_Family_Id, isEqualTo: parentId)
        .get();
    for (var item in data.docs) {
      ids.add(item.id);
    }

    return ids;
  }

  // Future<List<AppProfile>> fetchUserKidsWithSearch(String parentId) async {
  //   List<AppProfile> list = [];
  //   var data = FirebaseFirestore.instance
  //       .collection(AppConstants.USER)
  //       .where(AppConstants.USER_Family_Id, isEqualTo: parentId)
  //       .get();
  //   data.then((value) {
  //     print('Values are :${value.docs.first.data()}');
  //     for (var item in value.docs) {
  //       AppProfile object = AppProfile(
  //           item.data()[AppConstants.USER_user_name],
  //           item.data()[AppConstants.USER_first_name],
  //           item.data()[AppConstants.USER_last_name]);
  //       list.add(object);
  //     }
  //     return list;
  //   });
  //   return list;
  // }

  Future<String?> addUserPersonalization(
      {String? userId,
      String? parentId,
      String? pendingApprovales,
      bool? kidsToPayFriends,
      bool? kidsToPublish,
      bool? slideToPay,
      bool? lockSaving,
      bool? lockCharity,
      required bool? disableToDo}) async {
    CollectionReference users =
        firestore.collection(AppConstants.KidPersonalization);
    await users.doc(userId).set({
      AppConstants.KidP_user_id: userId,
      AppConstants.KidP_Parent_id: parentId,
      // AppConstants.KidP_SeePendApprovals: pendingApprovales,
      AppConstants.KidP_Kid2PayFriends: kidsToPayFriends,
      AppConstants.KidP_Kids2Publish: kidsToPublish,
      AppConstants.KidP_UseSlide2Pay: slideToPay,
      AppConstants.KidP_lockSavings: lockSaving,
      AppConstants.KidP_lockDonate: lockCharity,
      AppConstants.KidP_disableTo_Do: disableToDo,
      AppConstants.KidP_created_at: DateTime.now()
    });
    return 'Added';
  }

  Future<Map<String, dynamic>?> getKidsPersonalizeExperience(String id) async {
    // List<String> ids = [];
    QuerySnapshot<Map<String, dynamic>> data = await FirebaseFirestore.instance
        .collection(AppConstants.KidPersonalization)
        .where(AppConstants.KidP_user_id, isEqualTo: id)
        .get();
    if (data.docs.length != 0) {
      return data.docs.first.data();
    } else {
      return null;
    }
  }

  getUserPersonalizationSettings(AppConstants appConstants) async {
    Map<String, dynamic>? kidData = await ApiServices()
        .getKidsPersonalizeExperience(appConstants.userRegisteredId);
    if (kidData != null) {
      final personalizationSettingModel =
          personalizationSettingModelFromJson(kidData);
      appConstants
          .updatePersonalizationSettingModel(personalizationSettingModel);
      logMethod(
          title: 'User Personalization Settings created at and personalization :',
          message: '${appConstants.personalizationSettingModel!.kidPCreatedAt.toString()} and ${appConstants.personalizationSettingModel!.kidPKids2Publish}');
    } else {
      appConstants.updatePersonalizationSettingModel(null);
      logMethod(
          title: 'No User Personalization Settings found',
          message: 'Personalization Settings not found ');
    }
  }

  Future<Map<String, dynamic>?> getKidSpendingLimit(
      String parentId, String id) async {
    DocumentSnapshot<Map<String, dynamic>> data = await FirebaseFirestore
        .instance
        .collection(AppConstants.SpendLimits)
        // .doc(parentId)
        // .collection(AppConstants.SpendLimits)
        .doc(id)
        .get();
    // .where(AppConstants.KidP_user_id, isEqualTo: id).get();

    if (data.data() != null) {
      var snapShot = data.data() as Map<String, dynamic>;
      //  logMethod(
      //         title: "exist", message: '${snapShot}');
      return snapShot;
    } else {
      return null;
    }
  }

  Future<String?> updateSpendingRemain(
      {String? parentId, String? id, String? fieldName, int? amount}) async {
    FirebaseFirestore.instance
        .collection(AppConstants.SpendLimits)
        .doc(parentId)
        .collection(AppConstants.SpendLimits)
        .doc(id)
        .update({
      fieldName!: FieldValue.increment(-amount!),
      AppConstants.SpendL_Transaction_Amount_Remain:
          FieldValue.increment(-amount)
    });
    return "Updated";
  }

  Future<String?> issueCard(
      {String? parentId,
      required String? userId,
      String? firstName,
      String? lastName,
      String? dateOfBirth,
      String? gouvernmentId,
      String? phoneNumber,
      String? streetAddress,
      String? apartmentOrSuit,
      String? city,
      String? state,
      int? zipCode,
      int? ssnNumber,
      String? cardToken,
      String? userToken}) async {
    CollectionReference users =
        firestore.collection(AppConstants.ICard_Collection);
    await users
        .doc(parentId)
        .collection(AppConstants.ICard_Collection)
        .doc(userId)
        .set({
      AppConstants.ICard_user_id: userId,
      AppConstants.ICard_firstName: firstName,
      AppConstants.ICard_lastName: lastName,
      AppConstants.ICard_USER_DOB: dateOfBirth,
      // AppConstants.ICard_GovID: gouvernmentId,
      AppConstants.ICard_PhoneNum: phoneNumber,
      AppConstants.ICard_cardStatus: true,
      AppConstants.ICard_streetAddress: streetAddress,
      AppConstants.ICard_apartmentOrSuit: apartmentOrSuit,
      AppConstants.ICard_city: city,
      AppConstants.ICard_state: state,
      AppConstants.ICard_zipCode: zipCode,
      // AppConstants.ICard_ssnNumber: ssnNumber,
      // AppConstants.ICard_backGroundImage: '',
      AppConstants.ICard_physical_card: false,
      AppConstants.ICard_lockedStatus: false,
      AppConstants.ICard_Expired_Date: getCardExpiry(),
      AppConstants.ICard_Token: cardToken,
      AppConstants.ICard_User_Token: userToken,
      AppConstants.ICard_created_at: DateTime.now(),
    });
    return 'Issued';
  }

  Future<dynamic> checkCardExist({String? parentId, String? id}) async {
    logMethod(title: 'Parent id and User Id', message: "${parentId??'No id'} and $id");
    try {
      var doc = await FirebaseFirestore.instance
          .collection(AppConstants.ICard_Collection)
          .doc(parentId==""?id:parentId)
          .collection(AppConstants.ICard_Collection)
          .doc(id)
          .get();
        
      if (doc.exists) {
          // logMethod(
          //     title: "exist", message: '${doc.data()!['ICard_lastName']}');
          return doc;
        } else {
          // logMethod(title: "exist", message: '${doc.exists}');
          return false;
        }
      // return doc;
    } catch (e) {
      throw false;
    }
  }

  Future<String?> updateCardBakgroundImagePath(
      {String? cardId, required String parentId, String? imageUrl}) async {
    try {
      FirebaseFirestore.instance
          .collection(AppConstants.ICard_Collection)
          .doc(parentId)
          .collection(AppConstants.ICard_Collection)
          .doc(cardId)
          .update({AppConstants.ICard_backGroundImage: imageUrl});
    } catch (e) {
      throw e;
    }
    return 'Uploaded';
  }

  Future<String?> userInvited({String? userId, String? phoneNumber}) async {
    CollectionReference users = firestore.collection(AppConstants.USER_Invites);
    await users.doc().set({
      AppConstants.USER_contact_invitedphone: phoneNumber,
      AppConstants.USER_Invited_By_Id: userId,
      AppConstants.createdAt: DateTime.now()
    });
    return 'Success';
  }

  Future<QueryDocumentSnapshot<Map<String, dynamic>>?>
      checkUserExistInInvitedTable(
          {String? number, BuildContext? context}) async {
    // print('Number is: $number');
    // var appConstants = Provider.of<AppConstants>(context!, listen: false);
    QuerySnapshot<Map<String, dynamic>> value = await FirebaseFirestore.instance
        .collection(AppConstants.USER_Invites)
        .where(AppConstants.USER_contact_invitedphone, isEqualTo: number)
        .get();
    if (value.size != 0) {
      return value.docs[0];
      //
    } else {
      null;
    }
    return null;
    //  print('User model name is: ${value.docs[0][AppConstants.USER_first_name]}');
    //    var snapshotData = value.docs[0];
    //   final userModel = userModelFromMap(snapshotData.data());
    //     appConstants.updateUserModel(userModel);
    //     print('User model name is: ${appConstants.userModel.USERFirstName}');
  }
// await firestore.collection("courses").where("tags", arrayContainsAny: tagKeys)

////////////////
  Future<dynamic>? addFriendsAutumatically(
      {bool? isFavorite,
      String? requestReceiverrId,
      String? number,
      String? currentUserId,
      String? requestSenderPhoneNumber,
      String? requestSenderName,
      String? requestReceiverName,
      bool? signedUpStatus}) async {
//////////Added inside friendList of receiver
    FirebaseFirestore.instance
        .collection(AppConstants.USER)
        .doc(currentUserId)

        ///Invited By Id
        .collection(AppConstants.USER_contacts)
        .add({
      AppConstants.USER_first_name: requestReceiverName,
      AppConstants.USER_contact_invitedphone: number,
      AppConstants.USER_invited_signedup: signedUpStatus ?? true,
      AppConstants.USER_IsFavorite: isFavorite ?? false,
      AppConstants.USER_UserID: requestReceiverrId
    });
////////// Added inside friendList of current User
    FirebaseFirestore.instance
        .collection(AppConstants.USER)
        .doc(requestReceiverrId)

        ///Invited By Id
        .collection(AppConstants.USER_contacts)
        .add({
      AppConstants.USER_first_name: requestSenderName,
      AppConstants.USER_contact_invitedphone: requestSenderPhoneNumber,
      AppConstants.USER_invited_signedup: true,
      AppConstants.USER_IsFavorite: isFavorite ?? false,
      AppConstants.USER_UserID: currentUserId
    });
    return 'Friends Added';
  }

  Future<dynamic>? kidAddedIntoFriendListUpdatedStatus(
      {String? requestSenderId, String? currentUserId}) async {
    FirebaseFirestore.instance
        .collection(AppConstants.USER)
        .doc(requestSenderId)
        .collection(AppConstants.USER_contacts)
        .where(AppConstants.USER_UserID, isEqualTo: currentUserId)
        .get()
        .then((value) {
      // var snapShot = value.data() as Map<String, dynamic>;
      if (value.docs.isNotEmpty) {
        ///////This is for Invited User InvitedList updated to show friends
        logMethod(title: 'User Invited index', message: value.docs.first.id);
        FirebaseFirestore.instance
            .collection(AppConstants.USER)
            .doc(requestSenderId)

            ///Invited By Id
            .collection(AppConstants.USER_contacts)
            .doc(value.docs.first.id)
            .update({
          AppConstants.USER_invited_signedup: true,
          // AppConstants.USER_IsFavorite: false,
          // AppConstants.USER_UserID: currentUserId
        });
      }
    });
// 
    FirebaseFirestore.instance
        .collection(AppConstants.USER)
        .doc(currentUserId)
        .collection(AppConstants.USER_contacts)
        .where(AppConstants.USER_UserID, isEqualTo: requestSenderId)
        .get()
        .then((value) {
      // var snapShot = value.data() as Map<String, dynamic>;
      if (value.docs.isNotEmpty) {
        ///////This is for Invited User InvitedList updated to show friends
        logMethod(title: 'User Invited index', message: value.docs.first.id);
        FirebaseFirestore.instance
            .collection(AppConstants.USER)
            .doc(currentUserId)

            ///Invited By Id
            .collection(AppConstants.USER_contacts)
            .doc(value.docs.first.id)
            .update({
          AppConstants.USER_invited_signedup: true,
          // AppConstants.USER_IsFavorite: false,
          // AppConstants.USER_UserID: currentUserId
        });
      }
    });

    return 'Friends Added';
  }

///////////////
  Future<dynamic>? updateFromUserInvitedListStatus(
      String requestSenderId, String number, String idToBeDelete,
      {String? currentUserId,
      String? requestSenderPhoneNumber,
      String? requestSenderName}) async {
    FirebaseFirestore.instance
        .collection(AppConstants.USER)
        .doc(requestSenderId)
        .collection(AppConstants.USER_contacts)
        .where(AppConstants.USER_contact_invitedphone, isEqualTo: number)
        .get()
        .then((value) {
      // var snapShot = value.data() as Map<String, dynamic>;
      if (value.docs.isNotEmpty) {
        ///////This is for Invited User InvitedList updated to show friends
        logMethod(title: 'User Invited index', message: value.docs.first.id);
        FirebaseFirestore.instance
            .collection(AppConstants.USER)
            .doc(requestSenderId)

            ///Invited By Id
            .collection(AppConstants.USER_contacts)
            .doc(value.docs.first.id)
            .update({
          AppConstants.USER_invited_signedup: true,
          AppConstants.USER_IsFavorite: false,
          AppConstants.USER_UserID: currentUserId
        });

        // Now we are adding this friend To new added user so they can show them self inside firned list
        FirebaseFirestore.instance
            .collection(AppConstants.USER)
            .doc(currentUserId)

            ///Invited By Id
            .collection(AppConstants.USER_contacts)
            .doc()
            // .add(data)
            // .doc(value.docs.first.id)
            .set({
          AppConstants.USER_first_name: requestSenderName,
          AppConstants.USER_contact_invitedphone: requestSenderPhoneNumber,
          AppConstants.USER_invited_signedup: true,
          AppConstants.USER_IsFavorite: false,
          AppConstants.USER_UserID: requestSenderId
        });

        //////

        ////After adding into freind list now we are deleting user from table Invite
        if (idToBeDelete != '')
          FirebaseFirestore.instance
              .collection(AppConstants.USER_Invites)
              .doc(idToBeDelete)
              .delete()
              .then((value) {
            logMethod(title: 'Deleteed id', message: idToBeDelete);
          });
      }
    });

    ////////For Current User InvitedList Updated and that user is now friend of current User as well

    FirebaseFirestore.instance
        .collection(AppConstants.USER)
        .doc(currentUserId)
        .collection(AppConstants.USER_contacts)
        // .where(AppConstants.USER_contact_invitedphone, isEqualTo: number)
        .get()
        .then((value) {
      // var snapShot = value.data() as Map<String, dynamic>;
      if (value.docs.isNotEmpty) {
        ///////This is for Invited User InvitedList updated to show friends
        logMethod(title: 'User Invited index', message: value.docs.first.id);
        FirebaseFirestore.instance
            .collection(AppConstants.USER)
            .doc(currentUserId)
            .collection(AppConstants.USER_contacts)
            .doc(value.docs.first.id)
            .set({
          AppConstants.USER_invited_signedup: true,
          AppConstants.USER_IsFavorite: false
        });
      }
    });
    return 'Friends Added';

    // DocumentSnapshot<Map<String, dynamic>> data = await FirebaseFirestore
    //     .instance
    //     .collection(AppConstants.USER)
    //     .doc(id)
    //     .get();
    // // .where(AppConstants.KidP_user_id, isEqualTo: id).get();

    // if (data.data() != null) {
    //   var snapShot = data.data() as Map<String, dynamic>;

    //   logMethod(
    //       title: 'User Invited List',
    //       message: snapShot['USER_contacts'].toString());
    //   List userInvited = snapShot['USER_contacts'];
    //   // List updatedUserInviteList = [];
    //   int indexs = -1;
    //   for (var index = 0; index < userInvited.length; index++) {
    //     if (userInvited[index][AppConstants.USER_contact_invitedphone] == number) {
    //       userInvited[index] = {
    //         AppConstants.USER_contact_invitedphone: number,
    //         AppConstants.USER_invited_signedup: true,
    //         AppConstants.USER_IsFavorite: false
    //       };
    //       indexs = index;
    //       // List updateList =
    //       // [{
    //       //   AppConstants.USER_contact_invitedphone:number,
    //       //   AppConstants.USER_invited_signedup: true
    //       // }];
    //       // updatedUserInviteList.addAll(updateList);
    //       logMethod(
    //           title: 'Number found at index = $indexs',
    //           message: userInvited[index].toString());
    //       // break;
    //     }
    //   }
    //   if (indexs != -1) {
    //     // userInvited.forEach((element) {
    //     //   logMethod(title: 'Inside array', message: '${element['USER_contact_invitedphone']} and status ${element['USER_invited_signedup']}');
    //     // },);
    //     FirebaseFirestore.instance
    //         .collection(AppConstants.USER)
    //         .doc(id)
    //         .update({AppConstants.USER_contacts: userInvited});
    //     ////Delete User from Invite
    //     await FirebaseFirestore.instance
    //         .collection(AppConstants.USER_Invites)
    //         .doc(idToBeDelete)
    //         .delete()
    //         .then((value) {
    //       logMethod(title: 'Deleteed id', message: idToBeDelete);
    //     });
    //     //                 .then((value) {
    //     //   logMethod(title: 'Updating', message: 'Update Successfull');
    //     //  });
    //     //   .update({
    //     //   AppConstants.USER_contacts[indexs]:FieldValue.arrayUnion([
    //     // {
    //     //   AppConstants.USER_contact_invitedphone: number,
    //     //   AppConstants.USER_invited_signedup: true,
    //     // }
    //     //               ])
    //     //               }).then((value) {
    //     //   logMethod(title: 'Updating', message: 'Update Successfull');
    //     //  });
    //   }
    //   return snapShot;
    // } else {
    //   return null;
    // }
  }

  Future<bool>? checkAlreadyFriend({required String id, required String number}) async {
    QuerySnapshot<Map<String, dynamic>> value = await FirebaseFirestore.instance
        .collection(AppConstants.USER)
        .doc(id)
        .collection(AppConstants.USER_contacts)
        .where(AppConstants.USER_contact_invitedphone, isEqualTo: number)
        .get();

    if (value.docs.isNotEmpty) {
      //  emailAndNumber
      return true;
      //  EmailAndNumber(id: value.docs.first.id, emailExist: value.docs.first[AppConstants.USER_email]);
    } else {
      return false;
    }
  }

  Future<bool>? checkFriends({required String id, required String friendId}) async {
    QuerySnapshot<Map<String, dynamic>> value = await FirebaseFirestore.instance
        .collection(AppConstants.USER)
        .doc(id)
        .collection(AppConstants.USER_contacts)
        .where(AppConstants.USER_UserID, isEqualTo: friendId)
        .get();

    if (value.docs.isNotEmpty) {
      //  emailAndNumber
      return true;
      //  EmailAndNumber(id: value.docs.first.id, emailExist: value.docs.first[AppConstants.USER_email]);
    } else {
      return false;
    }
  }

  Future<dynamic>? updateFriendListStatus(
      {String? id, String? number, bool? status}) async {
    DocumentSnapshot<Map<String, dynamic>> data = await FirebaseFirestore
        .instance
        .collection(AppConstants.USER)
        .doc(id)
        .get();
    // .where(AppConstants.KidP_user_id, isEqualTo: id).get();

    if (data.data() != null) {
      var snapShot = data.data() as Map<String, dynamic>;
      List userInvited = snapShot['USER_contacts'];
      // userInvited.forEach((element) {
      //   logMethod(title: 'Number', message: element['USER_contact_invitedphone'].toString());
      // });
      int indexs = -1;
      for (var index = 0; index < userInvited.length; index++) {
        if (userInvited[index][AppConstants.USER_contact_invitedphone] ==
            number) {
          userInvited[index] = {
            AppConstants.USER_contact_invitedphone: number,
            AppConstants.USER_invited_signedup: userInvited[index]
                [AppConstants.USER_invited_signedup],
            AppConstants.USER_IsFavorite: status
          };
          indexs = index;
          // List updateList =
          // [{
          //   AppConstants.USER_contact_invitedphone:number,
          //   AppConstants.USER_invited_signedup: true
          // }];
          // updatedUserInviteList.addAll(updateList);
          logMethod(
              title: 'Number found at index = $indexs',
              message: userInvited[index].toString());
          // break;
        }
      }

      if (indexs != -1) {
        userInvited.forEach(
          (element) {
            logMethod(
                title: 'Inside array',
                message:
                    '${element['USER_contact_invitedphone']} and status ${element[AppConstants.USER_IsFavorite]}');
          },
        );
        FirebaseFirestore.instance
            .collection(AppConstants.USER)
            .doc(id)
            .update({AppConstants.USER_contacts: userInvited});
      }
    }
  }

  Future<void> updateCardStatus(
      {String? parentId, String? id, bool? status}) async {
    try {
      FirebaseFirestore.instance
          .collection(AppConstants.ICard_Collection)
          .doc(parentId)
          .collection(AppConstants.ICard_Collection)
          .doc(id)
          .update({AppConstants.ICard_cardStatus: status});
    } catch (e) {
      throw e;
    }
  }

  Future<void> updateCardLockedStatus(
      {String? parentId, String? id, bool? status}) async {
    try {
      FirebaseFirestore.instance
          .collection(AppConstants.ICard_Collection)
          .doc(parentId)
          .collection(AppConstants.ICard_Collection)
          .doc(id)
          .update({AppConstants.ICard_lockedStatus: status});
    } catch (e) {
      throw e;
    }
  }

  Future<void> updateCardPhysicalStatus(
      {String? parentId, String? id, bool? status}) async {
    try {
      FirebaseFirestore.instance
          .collection(AppConstants.ICard_Collection)
          .doc(parentId)
          .collection(AppConstants.ICard_Collection)
          .doc(id)
          .update({AppConstants.ICard_physical_card: status});
    } catch (e) {
      throw e;
    }
  }

  Stream<QuerySnapshot> fetchUserKidsCards({String? parentId}) {
    final Stream<QuerySnapshot> _categoriesStream = FirebaseFirestore.instance
        .collection(AppConstants.ICard_Collection)
        .doc(parentId)
        .collection(AppConstants.ICard_Collection)
        .snapshots();
    return _categoriesStream;
  }

  Future<String?> addCardSpendingLimits(
      {String? userId,
      String? parentId,
      String? totalAmount,
      String? tAGID0001Amount,
      String? tAGID0003Amount,
      String? tAGID0002Amount,
      String? tAGID0004Amount,
      String? tAGID0005Amount,
      String? tAGID0006Amount,
      String? tAGID0007Amount,
      String? tAGID0008Amount,
      String? tAGID0009Amount,
      String? tAGID0010Amount,
      String? tAGID0011Amount,
      String? tAGID0012Amount,
       String? tokenOfMaxSpendControll,
      String? dailyAmount
      }) async {
      logMethod(title: "Parent Id and Kid Id", message: "$parentId and $userId");
    CollectionReference users = firestore.collection(AppConstants.SpendLimits);
    await 
    users
        // .doc(parentId)
        // .collection(AppConstants.SpendLimits)
        .doc(userId)
        .set({
      AppConstants.SpendL_user_id: userId,
      AppConstants.SpendL_parent_id: parentId,
      AppConstants.SpendL_Transaction_Amount_Max: int.parse(totalAmount!),
      AppConstants.SpendL_Transaction_Amount_Remain: int.parse(totalAmount),
      AppConstants.SpendL_TAGID0001_Max: int.parse(tAGID0001Amount!),
      AppConstants.SpendL_TAGID0001_Remain: int.parse(tAGID0001Amount),
      AppConstants.SpendL_TAGID0001_mcc_id: AppConstants.tagItList[1].mccId,
      AppConstants.SpendL_TAGID0003_Max: int.parse(tAGID0003Amount!),
      AppConstants.SpendL_TAGID0003_Remain: int.parse(tAGID0003Amount),
      AppConstants.SpendL_TAGID0003_mcc_id: AppConstants.tagItList[2].mccId,
      AppConstants.SpendL_TAGID0002_Max: int.parse(tAGID0002Amount!),
      AppConstants.SpendL_TAGID0002_Remain: int.parse(tAGID0002Amount),
      AppConstants.SpendL_TAGID0002_mcc_id: AppConstants.tagItList[1].mccId,
      // AppConstants.SpendL_TAGID0004_Max: int.parse(tAGID0004Amount!),
      // AppConstants.SpendL_TAGID0004_Remain: int.parse(tAGID0004Amount),
      // AppConstants.SpendL_TAGID0004_mcc_id: AppConstants.tagItList[3].mccId,
      AppConstants.SpendL_TAGID0005_Max: int.parse(tAGID0005Amount!),
      AppConstants.SpendL_TAGID0005_Remain: int.parse(tAGID0005Amount),
      AppConstants.SpendL_TAGID0005_mcc_id: AppConstants.tagItList[4].mccId,
      AppConstants.SpendL_TAGID0006_Max: int.parse(tAGID0006Amount!),
      AppConstants.SpendL_TAGID0006_Remain: int.parse(tAGID0006Amount),
      AppConstants.SpendL_TAGID0006_mcc_id: AppConstants.tagItList[5].mccId,
      AppConstants.SpendL_TAGID0007_Max: int.parse(tAGID0007Amount!),
      AppConstants.SpendL_TAGID0007_Remain: int.parse(tAGID0007Amount),
      AppConstants.SpendL_TAGID0007_mcc_id: AppConstants.tagItList[6].mccId,
      AppConstants.SpendL_TAGID0008_Max: int.parse(tAGID0008Amount!),
      AppConstants.SpendL_TAGID0008_Remain: int.parse(tAGID0008Amount),
      AppConstants.SpendL_TAGID0008_mcc_id: AppConstants.tagItList[7].mccId,
      AppConstants.SpendL_TAGID0009_Max: int.parse(tAGID0009Amount!),
      AppConstants.SpendL_TAGID0009_Remain: int.parse(tAGID0009Amount),
      AppConstants.SpendL_TAGID0009_mcc_id: AppConstants.tagItList[8].mccId,
      AppConstants.SpendL_TAGID0010_Max: int.parse(tAGID0010Amount!),
      AppConstants.SpendL_TAGID0010_Remain: int.parse(tAGID0010Amount),
      AppConstants.SpendL_TAGID0010_mcc_id: AppConstants.tagItList[9].mccId,
      AppConstants.SpendL_TAGID0011_Max: int.parse(tAGID0011Amount!),
      AppConstants.SpendL_TAGID0011_Remain: int.parse(tAGID0011Amount),
      AppConstants.SpendL_TAGID0011_mcc_id: AppConstants.tagItList[10].mccId,
//
      AppConstants.SpendL_daily_Amount_Max: int.parse(dailyAmount!),
      AppConstants.SpendL_daily_Amount_Remain: int.parse(dailyAmount),
      AppConstants.SpendL_TAGID0022_mcc_id: AppConstants.tagItList[10].mccId,
      // dailyAmountController
      // AppConstants.SpendL_TAGID0012_Max: int.parse(tAGID0012Amount!),
      // AppConstants.SpendL_TAGID0012_Remain: int.parse(tAGID0012Amount),
      // AppConstants.SpendL_TAGID0012_mcc_id: AppConstants.tagItList[11].mccId,
      // AppConstants.SpendL_TokenOfMaxSpendControllPerTran : tokenOfMaxSpendControll,
      AppConstants.SpendL_CreatedAt: DateTime.now()
    });
    return 'updated';
  }

// static String  = 'Nick_Name';
  // static String  = 'SpendWallet_Name';
  // static String  = 'SavingWallet_Name';
  // static String  = 'DonationWallet_Name';
  // static String  = 'TopFriends_Name';
  // static String  = 'created_At';
  Future<String?> setNickNames(
      {DateTime? createdAt,
      String? kidId,
      String? SpendWallet_Name,
      String? SavingWallet_Name,
      String? DonationWallet_Name,
      String? TopFriends_Name}) async {
    CollectionReference users = firestore.collection(AppConstants.Nick_Name);
    await users.doc(kidId).set({
      AppConstants.Nick_Name_User_Id: kidId,
      AppConstants.SpendWallet_Name: SpendWallet_Name,
      AppConstants.SavingWallet_Name: SavingWallet_Name,
      AppConstants.DonationWallet_Name: DonationWallet_Name,
      AppConstants.TopFriends_Name: TopFriends_Name,
      AppConstants.created_at: createdAt
      // "created_at":DateTime.now().add(const Duration(days: 1))
    });
    return 'Added';
  }

  Future<NickNameModel?> getNickNames(
      {String? userId, BuildContext? context}) async {
    var appConstants = Provider.of<AppConstants>(context!, listen: false);
    DocumentSnapshot snapShot = await FirebaseFirestore.instance
        .collection(AppConstants.Nick_Name)
        .doc(userId)
        .get();

    if (snapShot.exists) {
      // return documentSnapshot.data();
      var snapshotData = snapShot.data() as Map<dynamic, dynamic>;
      logMethod(title: 'Nick Name Data', message: snapshotData.toString());
      // print('User data is: $snapshotData');
      final nickNameModel = nickNameModelFromMap(snapshotData);
      appConstants.updateNickNameModel(nickNameModel);
      logMethod(
          title: 'Wallet Nick name',
          message: 'nickName: ${appConstants.nickNameModel.NickN_SpendWallet}');
      return nickNameModel;
    } else {
      logMethod(title: 'Nick Name Data', message: 'No NickName Found');
      return appConstants.updateNickNameModel(NickNameModel());
    }
    // return null;
  }

  Future<NickNameModel?> getNickNameOfFavorit(
      {String? userId, BuildContext? context}) async {
    // var appConstants = Provider.of<AppConstants>(context!, listen: false);
    DocumentSnapshot snapShot = await FirebaseFirestore.instance
        .collection(AppConstants.Nick_Name)
        .doc(userId)
        .get();

    if (snapShot.exists) {
      // return documentSnapshot.data();
      var snapshotData = snapShot.data() as Map<dynamic, dynamic>;
      logMethod(title: 'Nick Name Data', message: snapshotData.toString());
      // print('User data is: $snapshotData');
      final nickNameModel = nickNameModelFromMap(snapshotData);
      // appConstants.updateNickNameModel(nickNameModel);
      return nickNameModel;
    } else {
      return null;
    }
    // return null;
  }

  Future<String?> saveCardInfoForFuture(
      {String? id,
      String? amount,
      String? cardNumber,
      String? cardHolderName,
      String? expiryDate,
      bool? cardStatus}) async {
    CollectionReference users = firestore.collection(AppConstants.FM_WALLET);
    await users.doc(id).set({
      AppConstants.FM_WALLET_userId: id,
      AppConstants.FM_WALLET_amount: amount,
      AppConstants.FM_WALLET_card_number: cardNumber,
      AppConstants.FM_WALLET_cardHolderName: cardHolderName,
      AppConstants.FM_WALLET_expiryDate: expiryDate,
      AppConstants.FM_WALLET_createdAt: DateTime.now(),
      AppConstants.FM_WALLET_cardStatus: cardStatus,
    });
    return 'Success';
  }

  Future<String?> updateCardInfo(
      {String? id,
      String? cardNumber,
      String? cardHolderName,
      DateTime? expiryDate}) async {
    CollectionReference users = firestore.collection(AppConstants.FM_WALLET);
    await users.doc(id).update({
      AppConstants.FM_WALLET_card_number: cardNumber,
      AppConstants.FM_WALLET_cardHolderName: cardHolderName,
      AppConstants.FM_WALLET_expiryDate: expiryDate,
    });
    return 'Updated';
  }

  Future<String?> deleteCard({String? id}) async {
    CollectionReference users = firestore.collection(AppConstants.FM_WALLET);
    await users.doc(id).delete();
    return 'delete';
  }

  Future<String?> saveProcessingFee({
    String? id,
    double? totalAmount,
    double? feeAmount,
  }) async {
    CollectionReference fee = firestore.collection(AppConstants.P_FEE);
    await fee.add({
      AppConstants.P_FEE_TOTAL_AMOUNT: totalAmount,
      AppConstants.P_FEE_AMOUNT: feeAmount,
      AppConstants.P_FEE_USER_ID: id,
      AppConstants.createdAt: DateTime.now()
    });
    return 'delete';
  }

  static String P_FEE = 'PROCESSING_FEE';
  static String P_FEE_USER_ID = 'P_FEE_USER_ID';
  static String P_FEE_TOTAL_AMOUNT = 'P_FEE_TOTAL_AMOUNT';
  static String P_FEE_AMOUNT = 'P_FEE_AMOUNT';

  Future<bool?> getCardInfoFromFundMyWallet(
      {String? userId, BuildContext? context}) async {
    var appConstants = Provider.of<AppConstants>(context!, listen: false);
    DocumentSnapshot snapShot = await FirebaseFirestore.instance
        .collection(AppConstants.FM_WALLET)
        .doc(userId)
        .get();
logMethod(title: "User id", message: userId.toString());
    if (snapShot.exists) {
      // // return documentSnapshot.data();
      var snapshotData = snapShot.data() as Map<dynamic, dynamic>;
      // // print('User data is: $snapshotData');
      final fundMeWalletModel = fundMeWalletModelFromMap(snapshotData);
      appConstants.updateFundMeWalletModel(fundMeWalletModel);
      return true;
    } else {
      appConstants.updateFundMeWalletModel(FundMeWalletModel());
      return false;
    }
    // return null;
  }

  Future<bool?> checkUserNameExist({String? userName}) async {
    logMethod(title: 'Username:', message: userName);
    // QuerySnapshot<Map<String, dynamic>> value
    QuerySnapshot<Map<String, dynamic>> value = await FirebaseFirestore.instance
        .collection(AppConstants.USER)
        .where(AppConstants.USER_user_name, isEqualTo: userName)
        .get();
    //  QuerySnapshot data =await FirebaseFirestore.instance
    //   .collection(AppConstants.KidPersonalization)
    //   .where(AppConstants.KidP_user_id, isEqualTo: id).get();
    //   var snapShot = data.docs.first.data() as Map<String, dynamic>;

    if (value.size != 0) {
      return true;
    } else {
      return false;
    }
    // return null;
  }

  Future<bool?> checkEmailExist({String? email}) async {
    // logMethod(title: 'Username:', message: email);
    // QuerySnapshot<Map<String, dynamic>> value
    QuerySnapshot<Map<String, dynamic>> value = await FirebaseFirestore.instance
        .collection(AppConstants.USER)
        .where(AppConstants.USER_email, isEqualTo: email)
        .get();
    //  QuerySnapshot data =await FirebaseFirestore.instance
    //   .collection(AppConstants.KidPersonalization)
    //   .where(AppConstants.KidP_user_id, isEqualTo: id).get();
    //   var snapShot = data.docs.first.data() as Map<String, dynamic>;

    // logMethod(
    //     title: 'Username value after hittig api is:',
    //     message: value.docs.toString());
    if (value.size != 0) {
      return true;
    } else {
      return false;
    }
    // return null;
  }

  Future<List<dynamic>> getDevicesArray(String id) async {
    List<dynamic> devicesList = [];
    final value = await FirebaseFirestore.instance
        .collection(AppConstants.USER)
        .doc(id)
        .get();

    devicesList = value.data()![AppConstants.device_list];
    return devicesList;
  }

  Future<String> updateDevicesArray(
    String id,
    List? deviceId,
  ) async {
    firestore.collection(AppConstants.USER).doc(id).update({
      AppConstants.device_list: FieldValue.arrayUnion(deviceId!),
    });
    return 'Successfull';
  }

  Future<String> updateUserTouchStatus(String id, bool value) async {
    firestore.collection(AppConstants.USER).doc(id).update({
      AppConstants.USER_TouchID_isEnabled: value,
    });
    return 'Successfull';
  }
  Future<String> addUserTokenBankApi(String userId, String userToken, {int? value, String? USER_Subscription_Method}) async {
    logMethod(title: 'User id and userToken', message: "$userId and $userToken");
    if(USER_Subscription_Method!=null){
      firestore.collection(AppConstants.USER).doc(userId).update({
      AppConstants.USER_BankAccountID: userToken,
      AppConstants.USER_SubscriptionValue: value==null? 1 : value,
      AppConstants.USER_Subscription_Method: USER_Subscription_Method,
      AppConstants.DateOfSubscription: DateTime.now(),
      AppConstants.DateOfExpirationSubscription: addOneMonth(DateTime.now())
    });
    }
    else{
    firestore.collection(AppConstants.USER).doc(userId).update({
      AppConstants.USER_BankAccountID: userToken,
      AppConstants.USER_SubscriptionValue: value==null? 1 : value,
    });
    }
    return 'Token Added';
  }

  Future<String> userSubscriptionStatusRestored({required String userId, required bool subscriptionStauts, required String USER_Subscription_Method,}) async {
    logMethod(title: 'User id and Subscription Status', message: "$userId and $subscriptionStauts");
    firestore.collection(AppConstants.USER).doc(userId).update({
      AppConstants.SubscriptionExpired: subscriptionStauts,
      AppConstants.DateOfSubscription: DateTime.now(),
      AppConstants.USER_Subscription_Method: USER_Subscription_Method,
      AppConstants.DateOfExpirationSubscription: addOneMonth(DateTime.now())
    });
    return 'Token Added';
  }

  Future<String> updateUserPinCode(
      String id, String value, int pinLength,DateTime pinCodeChangeDateTime) async {
    firestore.collection(AppConstants.USER).doc(id).update({
      AppConstants.USER_pin_code: encryptedValue(value: value),
      AppConstants.USER_pin_code_length: pinLength,
      AppConstants.USER_PIN_CODE_SETUP_DATE_TIME: pinCodeChangeDateTime
    });
    return 'Successfull';
  }

  ////////////Getting Token Of paticular user token
  Future<Map<dynamic, dynamic>?> getFirebaseTokenAndNumber({String? id}) async {
    // print('Number is: $number');
    // var appConstants = Provider.of<AppConstants>(context!, listen: false);
    DocumentSnapshot? snapshot = await FirebaseFirestore.instance
        .collection(AppConstants.USER)
        .doc(id)
        .get();
    if (snapshot.exists) {
      var snapshotData = snapshot.data() as Map<dynamic, dynamic>;
      // logMethod(title: 'After Fetching Token from firebase inside', message: snapshotData[AppConstants.USER_iNApp_NotifyToken]);

      return snapshotData;
      //
    } else {
      null;
    }
    return null;
    //  print('User model name is: ${value.docs[0][AppConstants.USER_first_name]}');
    //    var snapshotData = value.docs[0];
    //   final userModel = userModelFromMap(snapshotData.data());
    //     appConstants.updateUserModel(userModel);
    //     print('User model name is: ${appConstants.userModel.USERFirstName}');
  }

  ////////////Getting userId From number
  // ignore: body_might_complete_normally_nullable
  Future<String?> getUserIdFromPhoneNumber({String? number}) async {
    // print('Number is: $number');
    // var appConstants = Provider.of<AppConstants>(context!, listen: false);
    QuerySnapshot<Map<String, dynamic>> value = await FirebaseFirestore.instance
        .collection(AppConstants.USER)
        .where(AppConstants.USER_phone_number, isEqualTo: number)
        .get();
    //  var username = value.docs.first[AppConstants.USER_user_name];
    //  var firstName = value.docs.first[AppConstants.USER_first_name];
    //  var lastName = value.docs.first[AppConstants.USER_last_name];
    //  var logo = value.docs.first[AppConstants.USER_Logo];
    //  var id = value.docs.first.id;

    if (value.size != 0) {
      // print('Id is: ${value.docs.first.id}');
      return value.docs.first.id;
    } else {
      null;
    }
    //  print('User model name is: ${value.docs[0][AppConstants.USER_first_name]}');
    //    var snapshotData = value.docs[0];
    //   final userModel = userModelFromMap(snapshotData.data());
    //     appConstants.updateUserModel(userModel);
    //     print('User model name is: ${appConstants.userModel.USERFirstName}');
  }

  Future<QueryDocumentSnapshot<Map<String, dynamic>>?>
      getUserDataFromPhoneNumber({String? id}) async {
    // print('Number is: $number');
    // var appConstants = Provider.of<AppConstants>(context!, listen: false);
    QuerySnapshot<Map<String, dynamic>> value = await FirebaseFirestore.instance
        .collection(AppConstants.USER)
        .where(AppConstants.USER_UserID, isEqualTo: id)
        .get();
    //  var username = value.docs.first[AppConstants.USER_user_name];
    //  var firstName = value.docs.first[AppConstants.USER_first_name];
    //  var lastName = value.docs.first[AppConstants.USER_last_name];
    //  var logo = value.docs.first[AppConstants.USER_Logo];
    //  var id = value.docs.first.id;

    if (value.size != 0) {
      // print('Id is: ${value.docs.first.id}');
      return value.docs.first;
    } else {
      return null;
    }
    //  print('User model name is: ${value.docs[0][AppConstants.USER_first_name]}');
    //    var snapshotData = value.docs[0];
    //   final userModel = userModelFromMap(snapshotData.data());
    //     appConstants.updateUserModel(userModel);
    //     print('User model name is: ${appConstants.userModel.USERFirstName}');
  }

  // ignore: body_might_complete_normally_nullable
  Future<DocumentSnapshot<Map<String, dynamic>>?> getUserDataFromId(
      {String? id}) async {
    // print('Number is: $number');
    // var appConstants = Provider.of<AppConstants>(context!, listen: false);
    DocumentSnapshot<Map<String, dynamic>> value =
        await FirebaseFirestore.instance
            .collection(AppConstants.USER)
            // .where(AppConstants.USER_phone_number, isEqualTo: number)
            .doc(id)
            .get();
    //  var username = value.docs.first[AppConstants.USER_user_name];
    //  var firstName = value.docs.first[AppConstants.USER_first_name];
    //  var lastName = value.docs.first[AppConstants.USER_last_name];
    //  var logo = value.docs.first[AppConstants.USER_Logo];
    //  var id = value.docs.first.id;
    if (value.exists) {
      // print('Id is: ${value.docs.first.id}');
      return value;
    } else {
      null;
    }
    //  print('User model name is: ${value.docs[0][AppConstants.USER_first_name]}');
    //    var snapshotData = value.docs[0];
    //   final userModel = userModelFromMap(snapshotData.data());
    //     appConstants.updateUserModel(userModel);
    //     print('User model name is: ${appConstants.userModel.USERFirstName}');
  }

/////////////////To do List
  Future<String?> addToDo(
      {DateTime? createdAt,
      String? parentId,
      String? userId,
      String? doTitle,
      String? doType,
      String? doDay,
      String? doStatus,
      bool? linkedAllowance,
      DateTime? newCreatedAt
      }) async {
    // var todayTodo = DateTime.now();
    var toDayToDoDate =
        DateTime(createdAt!.year, createdAt.month, createdAt.day, 23, 59, 59);
    CollectionReference users = firestore.collection(AppConstants.TO_DO);
    await users.doc(userId).collection(AppConstants.TO_DO).add({
      AppConstants.DO_parentId: parentId,
      AppConstants.DO_UserId: userId,
      AppConstants.DO_Title: doTitle,
      AppConstants.ToDo_Repeat_Schedule: doType,
      AppConstants.DO_Day: doDay,
      AppConstants.DO_Status: doStatus,
      AppConstants.DO_DUE_DATE: toDayToDoDate,
      AppConstants.DO_CreatedAt: createdAt,
      AppConstants.DO_Allowance_Linked: linkedAllowance,
      AppConstants.DO_Deleted_By: "",
      AppConstants.DO_Kid_Status: "",
      AppConstants.ToDo_WithReward: false,
      AppConstants.ToDo_Reward_Amount: 0,
      AppConstants.ToDo_Reward_Status: '',
      AppConstants.DO_End_Repeat: null,
      AppConstants.DO_newCreatedAt: newCreatedAt,

      // "created_at":DateTime.now().add(const Duration(days: 1))
    });
    return 'Added';
  }

  /////////////////To do List
  Future<String?> pendingParentApproavlAdding(
      {
        // DateTime? createdAt,
        String? currentUserId,
        String? receiverId,
        String? toDoId,
      }) async {
    CollectionReference toDos = firestore.collection(AppConstants.To_Do_Pending_Approval);
    await toDos.add({
      AppConstants.TO_DO_Id: toDoId,
      AppConstants.DO_UserId: currentUserId,
      AppConstants.DO_Receiver_Id: receiverId,
      AppConstants.DO_CreatedAt: DateTime.now(),

      // "created_at":DateTime.now().add(const Duration(days: 1))
    });
    return 'Added';
  }

  Future<String?> deletePendingParentApproavlAdding(
      {
        String? toDoId,
      }) async {
    CollectionReference toDos = firestore.collection(AppConstants.To_Do_Pending_Approval);
    // await 
    await toDos.where(AppConstants.TO_DO_Id, isEqualTo: toDoId)
    .get()
    .then((value) {
      if(value.docs.first.exists)
      toDos.doc(value.docs.first.id.toString()).delete();
    })
    ;
    return 'Deleted';
  }

  Future<String?> updateToDoWeek(
      {String? userId, String? todoId, String? doType, DateTime? date}) async {
    CollectionReference users = firestore.collection(AppConstants.TO_DO);
    if (date != null) {
      await users
          .doc(userId)
          .collection(AppConstants.TO_DO)
          .doc(todoId)
          .update({
        AppConstants.ToDo_Repeat_Schedule: doType,
        AppConstants.DO_DUE_DATE: date,
        // "created_at":DateTime.now().add(const Duration(days: 1))
      });
    } else {
      await users
          .doc(userId)
          .collection(AppConstants.TO_DO)
          .doc(todoId)
          .update({
        AppConstants.ToDo_Repeat_Schedule: doType,
        // "created_at":DateTime.now().add(const Duration(days: 1))
      });
    }
    return 'Updated';
  }

  Future<String?> updateToDoDay({
    String? userId,
    String? todoId,
    String? doDay,
  }) async {
    CollectionReference users = firestore.collection(AppConstants.TO_DO);
    await users.doc(userId).collection(AppConstants.TO_DO).doc(todoId).update({
      AppConstants.DO_Day: doDay!,
      // "created_at":DateTime.now().add(const Duration(days: 1))
    });
    return 'Updated';
  }

  Future<String?> updateToDoStatus(
      {String? userId, String? todoId, String? toDoStatus, required DateTime? nextSechduleDateTime}) async {
        var toDayToDoDate =
        DateTime(nextSechduleDateTime!.year, nextSechduleDateTime.month, nextSechduleDateTime.day, 23, 59, 59);
    CollectionReference users = firestore.collection(AppConstants.TO_DO);
    await users.doc(userId).collection(AppConstants.TO_DO).doc(todoId).update({
      AppConstants.DO_Status: toDoStatus,
      AppConstants.DO_CreatedAt: nextSechduleDateTime,
      AppConstants.DO_DUE_DATE: toDayToDoDate
      // "created_at":DateTime.now().add(const Duration(days: 1))
    });
    if(toDoStatus=='Completed'){
      // This will call when user marked ay task as complted 
      // toDoCompltedTask(userId: userId, dueDate: toDayToDoDate, toDoStatus: 'Completed', todoId: todoId);
    }
    return 'Updated';
  }

  Future<String?> toDoCompltedTask(
      {String? userId, String? todoId, String? toDoStatus, required DateTime? dueDate}) async {
    CollectionReference toDo = firestore.collection(AppConstants.TO_DO);
    await toDo.doc(userId).collection(AppConstants.TO_DO_Completed).add({
      AppConstants.DO_Status: toDoStatus,
      AppConstants.TO_DO_Id: todoId,
      AppConstants.To_DO_Completed_At: DateTime.now(),
      AppConstants.DO_DUE_DATE: dueDate
      // "created_at":DateTime.now().add(const Duration(days: 1))
    });
    return 'Updated';
  }

  Future<String?> updateKidToDoStatus(
      {String? userId, String? todoId, String? toDoKidStatus, required String toDoWithReward}) async {
    CollectionReference users = firestore.collection(AppConstants.TO_DO);
    await users.doc(userId).collection(AppConstants.TO_DO).doc(todoId).update({
      AppConstants.DO_Kid_Status: toDoKidStatus,
      AppConstants.ToDo_Reward_Status: toDoWithReward,
      // "created_at":DateTime.now().add(const Duration(days: 1))
    });
    return 'Updated';
  }

  Future<String?> updateToDoLinkAllowance(
      {String? userId, String? todoId, bool? allowanceLinked}) async {
    CollectionReference users = firestore.collection(AppConstants.TO_DO);
    await users.doc(userId).collection(AppConstants.TO_DO).doc(todoId).update({
      AppConstants.DO_Allowance_Linked: allowanceLinked,
      // "created_at":DateTime.now().add(const Duration(days: 1))
    });
    return 'Updated';
  }

  Future<String?> updateToDoTitle({
    String? userId,
    String? todoId,
    String? title,
  }) async {
    CollectionReference users = firestore.collection(AppConstants.TO_DO);
    await users.doc(userId).collection(AppConstants.TO_DO).doc(todoId).update({
      AppConstants.DO_Title: title,
      AppConstants.DO_CreatedAt: DateTime.now()
      // "created_at":DateTime.now().add(const Duration(days: 1))
    });
    return 'Updated';
  }

  Future<String?> updateToDoDateAfterSwipe({
    String? userId,
    String? todoId,
    DateTime? updatedDate,
  }) async {
    CollectionReference users = firestore.collection(AppConstants.TO_DO);
    await users.doc(userId).collection(AppConstants.TO_DO).doc(todoId).update({
      AppConstants.DO_newCreatedAt: updatedDate,
      // "created_at":DateTime.now().add(const Duration(days: 1))
    });
    return 'Updated';
  }

  Future<String?> updateRepeatTime({
    String? userId,
    String? todoId,
    DateTime? repeatDateTime,
  }) async {
    CollectionReference users = firestore.collection(AppConstants.TO_DO);
    await users.doc(userId).collection(AppConstants.TO_DO).doc(todoId).update({
      AppConstants.DO_End_Repeat: repeatDateTime!,
      // "created_at":DateTime.now().add(const Duration(days: 1))
    });
    return 'Updated';
  }

  Future<String?> updateToDo({
    String? userId,
    String? todoId,
    DateTime? dueDate,
    bool? toDoWithReward,
    int? toDoRewardAmount,
    String? toDoRewardStatus,
    String? doType,
    String? doDay,
    required String? doKidStatus,
    required String? doStatus
  }) async {
    var toDayToDoDate =
        DateTime(dueDate!.year, dueDate.month, dueDate.day, 23, 59, 59);
    CollectionReference users = firestore.collection(AppConstants.TO_DO);
    await users.doc(userId).collection(AppConstants.TO_DO).doc(todoId).update({
      AppConstants.ToDo_WithReward: toDoWithReward,
      AppConstants.ToDo_Reward_Amount: toDoRewardAmount,
      AppConstants.ToDo_Reward_Status: toDoRewardStatus,
      AppConstants.DO_DUE_DATE: toDayToDoDate,
      AppConstants.ToDo_Repeat_Schedule: doType,
      AppConstants.DO_Day: doDay!,
      AppConstants.DO_Kid_Status: doKidStatus,
      AppConstants.DO_Status: doStatus
      // AppConstants.DO_CreatedAt: DateTime.now()
      // "created_at":DateTime.now().add(const Duration(days: 1))
    });
    return 'Updated';
  }

  void moveyMoneyForGoals(
      {String? documentId,
      double? amount,
      String? selectedWalletName,
      String? receiverId}) {
    ////////////Added into All Goals wallet
    FirebaseFirestore.instance
        .collection(AppConstants.USER)
        .doc(receiverId != null ? receiverId : documentId)
        .collection(AppConstants.USER_WALLETS)
        .doc(AppConstants.All_Goals_Wallet)
        .update({AppConstants.wallet_balance: FieldValue.increment(amount!)});
    //////////Subtract ammount from selected wallet
    FirebaseFirestore.instance
        .collection(AppConstants.USER)
        .doc(documentId)
        .collection(AppConstants.USER_WALLETS)
        .doc(selectedWalletName)
        .update({AppConstants.wallet_balance: FieldValue.increment(-amount)});
  }

  Future<String?> checkGoalAmount({String? documentId, double? amount}) async {
    FirebaseFirestore.instance
        .collection(AppConstants.GOAL)
        .doc(documentId)
        .update({
      AppConstants.GOAL_amount_collected: FieldValue.increment(amount!)
    });

    return 'Amount';
    // .snapshots();
  }

  Future moveMoneyToSelectedGoal({
    String? documentId,
    double? amount,
  }) async {
    FirebaseFirestore.instance
        .collection(AppConstants.GOAL)
        .doc(documentId)
        .update({
      AppConstants.GOAL_amount_collected: FieldValue.increment(amount!)
    });
    DocumentSnapshot<Map<String, dynamic>> data = await FirebaseFirestore
        .instance
        .collection(AppConstants.GOAL)
        .doc(documentId)
        .get();

    logMethod(
        title:
            'Goal amount: ${data.data()![AppConstants.GOAL_amount_collected]} and targetAmount',
        message: data.data()![AppConstants.Goal_Target_Amount].toString());
    if (data.data()![AppConstants.GOAL_amount_collected] >=
        data.data()![AppConstants.Goal_Target_Amount]) {
      updateGoalStatus(
          goalId: documentId, status: AppConstants.GOAL_Status_completed);
    }
    //
    // .snapshots();
  }

  Future<bool>? checkToDoTitleAlreadyExist({
    String? userId,
    String? todoId,
    String? title,
  }) async {
    QuerySnapshot<Map<String, dynamic>> value = await FirebaseFirestore.instance
        .collection(AppConstants.TO_DO)
        .doc(userId)
        .collection(AppConstants.TO_DO)
        .where(AppConstants.DO_Title, isEqualTo: title)
        .get();

    if (value.docs.length > 1) {
      return true;
      //
    } else {
      return false;
    }
  }

  Future<String?> updateDeletedByStatus(
      {String? userId, String? todoId, String? deletedBy}) async {
    CollectionReference users = firestore.collection(AppConstants.TO_DO);
    await users.doc(userId).collection(AppConstants.TO_DO).doc(todoId).update({
      AppConstants.DO_Deleted_By: deletedBy,
      // "created_at":DateTime.now().add(const Duration(days: 1))
    });
    return 'Updated';
  }

  Future<void> deleteToDo({String? userId, String? todoId}) async {
    CollectionReference users = firestore.collection(AppConstants.TO_DO);
    await users.doc(userId).collection(AppConstants.TO_DO).doc(todoId).delete();
  }

  Query getToDosQuery(
  {String? id, String? condition, int? limit, DateTime? selectedDateTime}) {
    var date = DateTime.now();
    Query? query;
    if (limit == 1) {
      query= FirebaseFirestore.instance
          .collection(AppConstants.TO_DO)
          .doc(id)
          .collection(AppConstants.TO_DO)
          .orderBy(AppConstants.DO_newCreatedAt, descending: true);
    }
    return query!;
}

  Stream<QuerySnapshot> getToDos(
      {String? id, String? condition, int? limit, DateTime? selectedDateTime}) {
    var date = DateTime.now();
    if (limit == 1) {
      return FirebaseFirestore.instance
          .collection(AppConstants.TO_DO)
          .doc(id)
          .collection(AppConstants.TO_DO)
          // .limit(7)
          // .where(AppConstants.DO_CreatedAt, isGreaterThanOrEqualTo: DateTime(date.year, date.month, 1), isLessThanOrEqualTo: DateTime(date.year, date.month, date.day+7))
          // .where(AppConstants.DO_Status, isEqualTo: condition)
          // .where(AppConstants.DO_CreatedAt, isLessThanOrEqualTo: date)
          .orderBy(AppConstants.DO_newCreatedAt, descending: true)
          .snapshots();
    }
    // For Home Screen Only 3
    if (limit == 3) {
      return FirebaseFirestore.instance
          .collection(AppConstants.TO_DO)
          .doc(id)
          .collection(AppConstants.TO_DO)
          .limit(3)
          // .where(AppConstants.DO_CreatedAt, isGreaterThanOrEqualTo: DateTime(date.year, date.month, 1), isLessThanOrEqualTo: DateTime(date.year, date.month, date.day+7))
          // .where(AppConstants.DO_Status, isEqualTo: condition)
          // .where(AppConstants.DO_CreatedAt, isLessThanOrEqualTo: date)
          .orderBy(AppConstants.DO_newCreatedAt, descending: true)
          .snapshots();
    }
    ///////////This is for Upcommings weeks
    if (selectedDateTime != null) {
      return FirebaseFirestore.instance
          .collection(AppConstants.TO_DO)
          .doc(id)
          .collection(AppConstants.TO_DO)
          // .limit(7)
          .where(AppConstants.DO_DUE_DATE,
              isGreaterThan: DateTime(date.year, date.month, date.day + 7))
          .where(AppConstants.DO_Status, isEqualTo: condition)
          .orderBy(AppConstants.DO_DUE_DATE, descending: false)
          .snapshots();
    }
    final Stream<QuerySnapshot> _categoriesStream = FirebaseFirestore.instance
        .collection(AppConstants.TO_DO)
        .doc(id)
        .collection(AppConstants.TO_DO)
        // .limit(7)
        .where(AppConstants.DO_DUE_DATE,
            isGreaterThanOrEqualTo: DateTime(date.year, date.month, 1),
            isLessThanOrEqualTo: DateTime(date.year, date.month, date.day + 7))
        .where(AppConstants.DO_Status, isEqualTo: condition)
        .orderBy(AppConstants.DO_DUE_DATE, descending: false)
        .snapshots();
    return _categoriesStream;
  }

    Stream<QuerySnapshot> getCompltedToDos(
      {String? id}) {
    // var date = DateTime.now();
    // if (limit == 1) {
      return FirebaseFirestore.instance
          .collection(AppConstants.TO_DO)
          .doc(id)
          .collection(AppConstants.TO_DO_Completed)
          // .limit(7)
          // .where(AppConstants.DO_CreatedAt, isGreaterThanOrEqualTo: DateTime(date.year, date.month, 1), isLessThanOrEqualTo: DateTime(date.year, date.month, date.day+7))
          // .where(AppConstants.DO_Status, isEqualTo: condition)
          // .where(AppConstants.DO_CreatedAt, isLessThanOrEqualTo: date)
          // .orderBy(AppConstants.DO_CreatedAt, descending: false)
          .snapshots();
    // }
  }

    Future<String> deletedTodoFromComplted({String? todoId, String? selectedUserId, }) async{
         FirebaseFirestore.instance
          .collection(AppConstants.TO_DO)
          .doc(selectedUserId)
          .collection(AppConstants.TO_DO_Completed)
          .doc(todoId)
          .delete();
    // }
    return 'Deleted';
  }

  ///////UserLoginWorkFlow
 void userLoginWorkFlow({required dynamic user, required AppConstants appConstants, bool? touchEnabled, required BuildContext context, required CustomProgressDialog progressDialog}) async{
  var snapshotData = user.docs[0];
  ApiServices().addUserBlockTime(id: snapshotData.id, blockDatetTime: null);
  ApiServices().userLastTimeLoginDateTime(id: snapshotData.id);

                            await storingFirebaseToken(
                                id: snapshotData.id);
                            final userModel =
                                userModelFromMap(snapshotData.data());
                            
                            appConstants.updateUserId(snapshotData.id);
                            UserPreferences userPref = UserPreferences();
                            await userPref.saveCurrentUserId(snapshotData.id);
                            /////////This is used For Touch id enabled from sign in screen
                            if(touchEnabled==true){
                              // if(appConstants.userModel.usaTouchEnable!=null && appConstants.userModel.usaTouchEnable==true){
                                await userPref.saveCurrentUserIdForLoginTouch(appConstants.userRegisteredId);
                                String? userId = await userPref.getCurrentUserIdForLoginTouch();
                                logMethod(title: 'LogOut User id:', message: userId.toString());
                                await ApiServices().updateUserTouchStatus(
                                          appConstants.userRegisteredId, true);
                                await ApiServices().getUserData(
                                  userId: appConstants.userRegisteredId,
                                  context: context);
                                
                              // } 
                              // else{
                              //   userPref.clearCurrentUserIdForLoginTouch();
                              // }
                            }
                            appConstants.updateUserModel(userModel);
                            progressDialog.dismiss();
                            Future.delayed(const Duration(milliseconds: 500),
                                () async {
                            
                              appConstants.updateSignUpRole(appConstants
                                  .userModel.usaUserType
                                  .toString());
                              // appConstants.updateSignUpRole(appConstants.userModel.usaUserType!);
                              // print('value is:::: ${appConstants.userModel.deviceList!.first}');
                              appConstants.updateGenderType(
                                  appConstants.userModel.usaGender!);
                              if (appConstants.userModel.userFullyRegistered != true && appConstants.userModel.usaUserId != null) {
                                    appConstants.updateFirstName(appConstants.userModel.usaFirstName);
                                    appConstants.updateLastName(appConstants.userModel.usaLastName);
                                    appConstants.updateZipCode(appConstants.userModel.zipCode);
                                    appConstants.updateDateOfBirth(appConstants.userModel.usaDob!);
                                    appConstants
                                        .updatePhoneNumber(appConstants.userModel.usaPhoneNumber);
                                    appConstants.updateEmail(appConstants.userModel.usaEmail);
                                    appConstants.updateUserName(appConstants.userModel.usaUserName);
                                    appConstants.updatePin('');
                                    // appConstants.updateUserName('');
                                    // appConstants.updatePhoneNumber('');
                                    // appConstants.updateAccountSettingUpFor('Me');
                                    //////Commeted New after new Faluire process
                                    ///
                                    ///We need to check that if you are secondary user where should it task you
                                    ///towards AccoundsetupforKid screen
                                    logMethod(title: 'UserType=====>>>>>', message: 'Type::   ${appConstants.userModel.usaUserType}');
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => 
                                            
                                            appConstants.userModel.usaUserType==AppConstants.USER_TYPE_PARENT? WhosSettingsUp() : checkPrimaryUserForNotFullyRegistered(appConstants) ? const WhosSettingsUp() : const AccountSetupAsAkid()  ));

                                            // appConstants.userModel.usaUserType==AppConstants.USER_TYPE_PARENT? WhosSettingsUp() : checkPrimaryUser(appConstants) ? const AccountSetupAsAkid() : const WhosSettingsUp() ));
                                    return;
                                    //////////////End commented new
                                  }
                              // if (appConstants.signUpRole == "Mom") {
                              //   Navigator.push(
                              //       context,
                              //       MaterialPageRoute(
                              //           builder: (context) =>
                              //               const AccountSetupInformation()));
                              // } else
                              //true ==false
                              if (appConstants.userModel.usaIsenable != null &&
                                  !appConstants.userModel.usaIsenable!) {
                                if (appConstants.userModel.isUserPinUser !=
                                        null &&
                                    appConstants.userModel.isUserPinUser!) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const WhoIsLoginWithPin()));
                                  return;
                                }
                                

                                logMethod(
                                    title:
                                        'True condition Username and isEnabed Status is',
                                    message:
                                        '${appConstants.userModel.usaFirstName} & ${appConstants.userModel.usaIsenable}');
                                appConstants.updateAccountSettingUpFor('Me');
                                appConstants.updateFirstName(
                                    appConstants.userModel.usaFirstName);
                                appConstants.updateLastName(
                                    appConstants.userModel.usaLastName);
                                appConstants.updateDateOfBirth(
                                    appConstants.userModel.usaDob.toString());

                                appConstants.updateZipCode(
                                    userModel.zipCode.toString());
                                // logMethod(title: 'Zip Code', message: 'Zip Code: ${userModel.zipCode}');

                                appConstants.updateEmail(
                                    appConstants.userModel.usaEmail ?? '');

                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const AccountSetupAsAkid()));
                              }
                              //  else if (!appConstants.userModel.deviceList!
                              //     .contains(await service.getDeviceId())) {
                              //   appConstants.updateDifferentDeviceStatus(true);
                              //   Navigator.push(
                              //       context,
                              //       MaterialPageRoute(
                              //           builder: (context) =>
                              //               const WhoIsLoginWithPin()));
                              // } 
                              else {
                                if(appConstants.userModel.usaUserType==AppConstants.USER_TYPE_PARENT && appConstants.userModel.userFullyRegistered==true){
                                logMethod(title: "USER MODEL======>>>>>> Family id:${appConstants.userModel.userFamilyId} User Fully Registered:${appConstants.userModel.userFullyRegistered}, User id: ${appConstants.userModel.usaUserId}, gender: ${appConstants.userModel.usaGender} and ${appConstants.userModel.usaIsenable}, Pin User: ${appConstants.userModel.isUserPinUser}", message: userModel.toString());

                                List<UserModel> pinCodeKidsList = await fetchUserPinCodeKids(appConstants.userModel.userFamilyId??appConstants.userRegisteredId, currentUserId: appConstants.userRegisteredId);
                                logMethod(title: 'User Data Length:', message: pinCodeKidsList.length.toString());
                                if(pinCodeKidsList.length==0){
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const HomeScreen()));
                                    return;
                                }
                                Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const WhoIsLoginWithPin()));
                                  return;
                              }
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomeScreen()));
                              }
                            });
 }


  //////////////////Sending notification

  Future <String> getAccessToken() async{
    final serviceAccountJson ={
          "type": "service_account",
          "project_id": "zakipayapp",
          "private_key_id": "a4e18c78104488a474e8541f1173bd48cfadbff1",
          "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQCvtozJ6xEfLxcQ\noxIsy8VIqmtUFR/5/tBqA3lrYsrcKgDK0KHfXSIlRfUo7JW5IGyabfjmomCy5y0k\n4c5RXMYnjuEublKqAvJLeP28Ty1Jxyfxpq3rwZpmjrCn/oY5AD1NHGeqtgEjVuPg\nMxZmQPdB5iFv0kxemC21xmGY5iV6ESJy3oLajokzIMZLHMFgYVk0vKsWlBH2OfQ2\nsPoa5cO2DAe4MWhIkImzk7hJorQ2DtuG+dBK7hBQDbBgIGAy8jZpdSge9WpqVwFj\nQaHg9o9DLgrPdQKLQYTtLc/I8Rm3eRn1BNkiBBFBye79CnMCszgESt4gu8ILJ0Ig\n87rXBlm7AgMBAAECggEAAsRVIzjYZC1Rp6lpt9rdmG9WkVRj1IP2tDSpzM8Zcq4W\npRrz8Zh92Sho2+Qd13RzQVtJ+BfGfgq140bLAOz9EdJmKV0DYDn7psSY+kYk6GyC\nbIO7aWL7E3Jbxcl0Q6GFVZmE6GNFUVEk9XrYd3O+cQM2s5QUL8klrx8YmlfFb06f\nCzTafwWakhBOxUxTb9h+NbVZrjWR+ri+xJdYCoqeEw1zT2Zh8MB/1IJFopYBvdcZ\nLyTTkO57oMDBOd42/JG6QHt7pdkTF0k3NZ1mnNA1q8x+/DuM6qlwb/kgsIlnQLP1\n1cB8M8lEXwLS/6dQ9rPbwWO5hct6+YKMU5vMlJ4WAQKBgQDtn/dOATpAK3p3XzRl\nGmoJ+AqItF4HHIQ8FGX9mg/lWP9CXVViqRuHld4EW/4Hyr9krojfm4QYEF96VJid\nrKtizoRnFBibYLCJwbWRx+kIOdzVY20x+VuF3UEwcRhRsCQxltzg2mOVSvW3eW0U\ndReVF6OVzZVkOLct2YHKxb0O4QKBgQC9TPmjBPaechkzu4L4A4C43I6QoeadoXfU\nk+Cor83HIKP/r8XcKcQ+ZKFTd6eRqpsd+qvNhTsx/RreE5tkkAWhcdPyUx4Qb8aX\nrE96th7Fi8GiY3apUs1p3+h9MZ9If5bCPNYe6P+zdglMups7UtyD2uwEeZlGwTEc\nrJ+IxTbIGwKBgQC3bgqbnnr22hk5WLa7bP56H40SJhmHZ830CtMIRwsKQf8Zna6x\n8FSd/2RY/SJFpY7FC64A3q3DXbA2YGNHI+lQ5pZyc6LjHmpojK26kRUkEnaUCqJa\nN2EdHsSZvlPFizEFTq3GrQ6+ShUPwp4fcpv3rT3L/9zYdqeAryxv+OCOQQKBgGhY\nbt6iVMLgB+5RNQ869xBvWxJ0e+d14tTFsrepOJfD8UJ2hG0ohKkT1S1qLm8ICLsM\nuvjtsMSMTOwPCL/093WXhgn0MQVEZ8ahT6pHi0y/DbxScU1CfEIZD1E7Mh7HXbWx\nzSF6s8Abl2K5Feoscaso2KJa2Nd8lHLG4KWGd/zzAoGBAOMC0iEbPtKE31Fijigx\nLkY204T8nwGj8wtavpar+TI3h6nqj4+D9CltKqO5nUN2Elc5iEGvgxyyuZyJb0DP\n2aazPUrTKVqajy7vVtD8fQoa5D0lTWdUcpkaRghdaEHdmFJ82A3gqO11rp3MhJDb\n+h1stnYR4W8X4XiPten9XHig\n-----END PRIVATE KEY-----\n",
          "client_email": "zakipay-adnan@zakipayapp.iam.gserviceaccount.com",
          "client_id": "110576912513824709621",
          "auth_uri": "https://accounts.google.com/o/oauth2/auth",
          "token_uri": "https://oauth2.googleapis.com/token",
          "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
          "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/zakipay-adnan%40zakipayapp.iam.gserviceaccount.com",
          "universe_domain": "googleapis.com"
        };
    List<String> scopes=[
      "https://www.googleapis.com/auth/firebase.messaging"
    ];

    http.Client client = await authio.clientViaServiceAccount(
      authio.ServiceAccountCredentials.fromJson(serviceAccountJson),
      scopes,
    );

    // get the access token
    authio.AccessCredentials credentials = await authio.obtainAccessCredentialsViaServiceAccount(
      authio.ServiceAccountCredentials.fromJson(serviceAccountJson),
      scopes,
      client
    );

client.close();

return credentials.accessToken.data;

  }

  Future sendNotification({
    String? token,
    String? title,
    String? body,
    // String? userId
  }) async {
    String authToken = await getAccessToken();
    // logMethod(title: 'Selected user', message: 'Userid: $token');

    // if(token==null){
    //   token = await getUserToken(userId: userId);
    // }
    // logMethod(title: 'Selected User Token', message: 'Userid: ${await token}');

    // return;
    await http.post(Uri.parse('https://fcm.googleapis.com/v1/projects/zakipayapp/messages:send'),
            headers: <String, String>{
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $authToken'
            },
            body: jsonEncode(
                 {
                  "message": {
                    "token":"$token",
                    "notification": {
                      "title": "$title",
                      "body": "$body"
                    },
                    "android": {
                      "notification": {
                        "sound": "default",
                        "channel_id": "high_importance_channel"
                      }
                    },
                    "apns": {
                      "payload": {
                        "aps": {
                          "badge": 1,
                          "sound": "default"
                        }
                      }
                    }
                  }
                } 
            ))
        .whenComplete(() {
//      print('sendOrderCollected(): message sent');
      // ignore: body_might_complete_normally_catch_error
    }).catchError((e) {
      print('sendOrderCollected() error: $e');
    });
  }
}
