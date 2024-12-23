// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:ndialog/ndialog.dart';
import 'package:provider/provider.dart';
import 'package:zaki/Constants/Spacing.dart';
import 'package:zaki/Models/UserModel.dart';
import 'package:zaki/Screens/AccountSetupAsaKid.dart';
import 'package:zaki/Screens/LoginWithPinCode.dart';
import 'package:zaki/Screens/RestPinCode.dart';
import 'package:zaki/Widgets/TextHeader.dart';
import '../Constants/AppConstants.dart';
import '../Constants/HelperFunctions.dart';
import '../Constants/Styles.dart';
import '../Services/api.dart';
import '../Widgets/AppBars/AppBar.dart';
import '../Widgets/CustomLoadingScreen.dart';

class WhoIsLoginWithPin extends StatefulWidget {
  final bool? fromRestPinCode;
  const WhoIsLoginWithPin({Key? key, this.fromRestPinCode}) : super(key: key);

  @override
  State<WhoIsLoginWithPin> createState() => _WhoIsLoginWithPinState();
}

class _WhoIsLoginWithPinState extends State<WhoIsLoginWithPin> {
  Future<List<UserModel>>? userKids;

  @override
  void initState() {
    getUserKids();
    super.initState();
  }

  getUserKids() {
    Future.delayed(Duration.zero, () {
      var appConstants = Provider.of<AppConstants>(context, listen: false);
      userKids = ApiServices().fetchUserPinCodeKids(appConstants.userModel.userFamilyId??appConstants.userModel.usaUserId.toString(), currentUserId: appConstants.userRegisteredId);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    var appConstants = Provider.of<AppConstants>(context, listen: true);
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: getCustomPadding(),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                appBarHeader_005(
                    width: width,
                    height: height,
                    context: context,
                    appBarTitle: widget.fromRestPinCode==true? 'Select User' : 'Who is signing in?',
                    backArrow: false,
                    leadingIcon: false
                    ),
                InkWell(
                  onTap: () async {
                    if (widget.fromRestPinCode==true) {
                      Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const RestPinCode()));
                    }else
                    // UserPreferences userPref = UserPreferences();
                    // await userPref
                    //     .saveCurrentUserId(appConstants.userRegisteredId);
                        Navigator.push(context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  LoginWithPinCode(
                                                    pinCode: appConstants.userModel.usaPinCode,
                                                    pinCodeLength: appConstants.userModel.usaPinCodeLength,
                                                    userId: appConstants.userRegisteredId,
                                                    firstName: appConstants.userModel.usaFirstName,
                                                    primaryUser: true,
                                                    )));
                    // await ApiServices().getUserData(context: context, userId: appConstants.userRegisteredId);
                    // Future.delayed(Duration(milliseconds: 500), (){
                    //   Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //           builder: (context) =>
                    //               const YouSelfInformationAsKidSetupPin()));

                    // });
                    // Navigator.push(context,
                    //     MaterialPageRoute(builder: (context) => HomeScreen()));
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: transparent,
                            // border: Border.all(color: grey)
                          ),
                          child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: userImage(
                                  imageUrl: appConstants.userModel.usaLogo!,
                                  userType: appConstants.userModel.usaUserType,
                                  width: width + width * 0.6,
                                  gender: appConstants.userModel.usaGender,
                                  appConstants: appConstants)),
                        ),
                        TextHeader1(
                          title:
                              '@ ${appConstants.userModel.usaUserName}',
                        )
                      ],
                    ),
                  ),
                ),
                spacing_large,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child:
                   Text(
                    'Children with a PIN Code:',
                    style: appBarTextStyle(context, width),
                    ),
                ),
                spacing_medium,
                userKids == null
                    ? const SizedBox.shrink()
                    : FutureBuilder<List<UserModel>>(
                        future: userKids,
                        builder: (BuildContext context, snapshot) {
                          if (snapshot.hasError) {
                            return const Text(
                                'Ooops...Something went wrong :(');
                          }

                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Text("");
                          }
                          if (snapshot.data!.length == 0) {
                            return const Center(child: Text(""));
                          }

                          return GridView(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 0,
                              mainAxisSpacing: 0,
                              // childAspectRatio: 2 / 1
                            ),
                            primary: false,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            children: List<Widget>.generate(
                                snapshot.data!.length, (index) {
                              return InkWell(
                                onTap: () async {
                                  if (widget.fromRestPinCode==true) {
                                      Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                               RestPinCode(userId: snapshot.data![index].usaUserId)));
                                      return;
                                    }
                                  CustomProgressDialog progressDialog =
                                      CustomProgressDialog(context, blur: 10);
                                  progressDialog
                                      .setLoadingWidget(CustomLoadingScreen());
                                  progressDialog.show();
                                  // ApiServices service = ApiServices();
                                  // appConstants.updateDateOfBirth(
                                  //     snapshot.data!.docs[index][AppConstants.USER_dob]);
                                  // appConstants.updateUserChildRegisteredId(
                                  //     snapshot.data![index].usaUserId.toString());
                                  // appConstants.updateUserId(
                                  //     snapshot.data![index].usaUserId.toString());
                                  // appConstants.updateFirstName(
                                  //     snapshot.data!.docs[index][AppConstants.USER_first_name]);
                                  // appConstants.updateIfUserIsPinUser(
                                  //     snapshot.data!.docs[index][AppConstants.USER_IsUserPin]);
                                  // appConstants.updateLastName(
                                  //     snapshot.data!.docs[index][AppConstants.USER_last_name]);
                                  // appConstants.updateGenderType(
                                  //     snapshot.data!.docs[index][AppConstants.USER_gender]);

                                  ///////////////////
                                  // UserPreferences userPref = UserPreferences();
                                  // await userPref.saveCurrentUserId(
                                  //     snapshot.data![index].usaUserId!);
                                  // await ApiServices().getUserData(
                                  //     context: context,
                                  //     userId: snapshot.data![index].usaUserId!);
                                  //////////
                                  appConstants.updateAccountSettingUpFor('Me');
                                  
                                    if (snapshot.data![index].userFullyRegistered==true) {
                                          progressDialog.dismiss();
                                          Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  LoginWithPinCode(
                                                    pinCode: snapshot.data![index].usaPinCode,
                                                    pinCodeLength: snapshot.data![index].usaPinCodeLength,
                                                    userId: snapshot.data![index].usaUserId,
                                                    firstName: snapshot.data![index].usaFirstName,
                                                    
                                                    )));
                                      
                                      // Navigator.push(
                                      //     context,
                                      //     MaterialPageRoute(
                                      //         builder: (context) =>
                                      //             HomeScreen()));
                                      return;
                                    }
                                    appConstants.updateFirstName(
                                        snapshot.data![index].usaFirstName);
                                    appConstants.updateLastName(
                                        snapshot.data![index].usaLastName);
                                    appConstants.updateZipCode(
                                        appConstants.userModel.zipCode);
                                    appConstants.updatePin('');
                                    appConstants.updateUserName('');
                                    appConstants.updatePhoneNumber('');
                                    appConstants.updateSignUpRole(
                                        AppConstants.USER_TYPE_KID);
                                    

                                    // UserModel? model = 
                                    await ApiServices().getUserData(userId: snapshot.data![index].usaUserId, context: context);
                                    // if(model!=null){
                                      appConstants.updateUserId(snapshot.data![index].usaUserId.toString());
                                      logMethod(title: 'Logged in user', message: '${appConstants.userRegisteredId}');
                                      Future.delayed(Duration(seconds: 2), () async{
                                        progressDialog.dismiss();
                                    
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const AccountSetupAsAkid(secondryPinCodeUser: true)));
                                      });
                                    // }
                                    // return;
                                    
                                    // Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //         builder: (context) =>
                                    //             const YouSelfInformationAsKidSetupPin()));
                                  // });
                                },
                                child: Column(
                                  children: [
                                    Stack(
                                      children: [
                                        Center(
                                          child: Container(
                                            // height: 100,
                                            // width: 100,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: transparent,
                                              // border: Border.all(color: grey)
                                            ),
                                            child: Padding(
                                                padding: const EdgeInsets.all(2.0),
                                                child: userImage(
                                                  imageUrl: snapshot.data![index].usaLogo,
                                                  userType: snapshot.data![index].usaUserType,
                                                  width: width + width * 0.6,
                                                  gender: snapshot.data![index].usaGender,
                                                )),
                                          ),
                                        ),
                                        if(snapshot.data![index].userFullyRegistered!=true)
                                      Align(
                                        alignment: Alignment.center,
                                        child: Image.asset(
                                          imageBaseAddress+'Logo_Activate.png',
                                          height: height*0.15,
                                          width: width + width * 0.6,
                                          ),
                                      )
                                      ],
                                    ),
                                    Text(
                                      snapshot.data![index].userFullyRegistered!=true?
                                      '${snapshot.data![index].usaFirstName}':
                                      '@ ${snapshot.data![index].usaUserName}',
                                      style: heading3TextStyle(width, font: 13),
                                      // overflow: TextOverflow.clip,
                                      // textScaleFactor: width*0.4,
                                    )
                                  ],
                                ),
                              );
                            }),
                          );

                          // Padding(
                          //   padding: const EdgeInsets.all(4.0),
                          //   child: GridView(
                          //     shrinkWrap: true,
                          //     physics: const NeverScrollableScrollPhysics(),
                          //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          //       crossAxisSpacing: 20,
                          //       mainAxisSpacing: 20,
                          //       childAspectRatio: 1.1,
                          //       crossAxisCount: 2),
                          //     children: snapshot.data!.docs.

                          //     map((DocumentSnapshot document){
                          //     Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                          //       return Text(data['USA_first_name']);
                          //     }).toList(),
                          //   ),
                          // );
                        },
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
