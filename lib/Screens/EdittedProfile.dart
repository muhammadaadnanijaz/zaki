import 'dart:io';
import 'dart:math';
import 'package:zaki/Constants/CheckInternetConnections.dart';
import 'package:zaki/Screens/WhatsAppLoginScreen.dart';
import 'package:zaki/Widgets/CustomLoader.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
// import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:us_states/us_states.dart';
import 'package:zaki/Constants/HelperFunctions.dart';
import 'package:zaki/Constants/NotificationTitle.dart';
import 'package:zaki/Screens/EmailVerification.dart';
import 'package:zaki/Services/api.dart';
import 'package:zaki/Widgets/TextHeader.dart';
import 'package:zaki/Widgets/ZakiPrimaryButton.dart';

import '../Constants/AppConstants.dart';
import '../Constants/Spacing.dart';
import '../Constants/Styles.dart';
import '../Widgets/AppBars/AppBar.dart';
import '../Widgets/CustomHeaderTextField.dart';
// import '../Widgets/SelectCouneryState.dart';
import '../Widgets/ZakiCircularButton.dart';
import 'AccountSetUpInformation.dart';
import 'ChooseImageForUpload.dart';

class EdittedProfile extends StatefulWidget {
  const EdittedProfile({Key? key}) : super(key: key);

  @override
  _EdittedProfileState createState() => _EdittedProfileState();
}

class _EdittedProfileState extends State<EdittedProfile> {
  // List of items in our dropdown menu
  String userNameErrorMessage = '';
  bool emailAddressChanged = false;
  var genderList = ['Male', 'Female', 'Rather not specify'];
  var roleList = [
    'Husband',
    'Wife',
    'Son',
    'Daughter',
    'An Adult',
    'A Kid',
    'Dad',
    'Mom'
  ];
  final formGlobalKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final nickNameController = TextEditingController();
  final zipController = TextEditingController();
  final userNameController = TextEditingController();
  final emailController = TextEditingController();
  final emailVerifiedCode = TextEditingController();
  final phoneNumberController = TextEditingController();
  File? userLogo;
  File? headerImage;
  String emailErrorMessage = '';

  verfiyEmail({String? email, String? sendedCode}) {
    emailVerifiedCode.text = '';
    String error = '';
    bool? resendButtonEnabled = false;
    logMethod(title: 'Sended Code', message: sendedCode);
    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            var appConstants = Provider.of<AppConstants>(context, listen: true);
            var height = MediaQuery.of(context).size.height;
            var width = MediaQuery.of(context).size.width;
            return AlertDialog(
                title: Row(
                  children: [
                    InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(Icons.close)),
                    Expanded(
                      child: Text(
                        'Enter verification code sent to:\n$email',
                        style: heading4TextSmall(width, color: black),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                // icon: Icon(Icons.close),
                shape: shape(),
                contentPadding: EdgeInsets.zero,
                insetPadding: EdgeInsets.zero,
                content: Container(
                  height: height,
                  width: width,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Pinput(
                          length: 5,
                          autofocus: false,
                          obscuringCharacter: '*',
                          obscureText: true,
                          errorTextStyle: heading4TextSmall(width, color: red),
                          validator: (String? pin) {
                            if (pin!.isEmpty) {
                              return '';
                            } else if (pin != sendedCode) {
                              return 'Verification Failed';
                            }
                            // else {
                            return null;
                            // }
                          },
                          // onSubmit: (String pin) => _showSnackBar(pin, context),
                          // focusNode: _pinPutFocusNode,
                          controller: emailVerifiedCode,
                          errorText: error == '' ? null : error,
                          // forceErrorState: false,
                          onChanged: (String zipcode) {
                            setState(() {
                              error = '';
                            });
                          },
                        ),
                        spacing_medium,
                        CircularCountDownTimer(
                          duration: 60,
                          initialDuration: 0,
                          controller: _controller,
                          width: 60,
                          height: 60,
                          ringColor: resendButtonEnabled == true
                              ? crimsonColor
                              : Colors.green[300]!,
                          ringGradient: null,
                          fillColor: resendButtonEnabled == true
                              ? crimsonColor
                              : grey.withOpacity(0.5),
                          fillGradient: null,
                          backgroundColor: white,
                          backgroundGradient: null,
                          strokeWidth: 10.0,
                          strokeCap: StrokeCap.round,
                          textStyle:
                              heading1TextStyle(context, width, color: grey),
                          textFormat: CountdownTextFormat.MM_SS,
                          isReverse: true,
                          isReverseAnimation: false,
                          isTimerTextShown: true,
                          autoStart: true,
                          onStart: () {
                            setState(() {
                              resendButtonEnabled = false;
                            });
                            // _controller.start();
                            debugPrint('Countdown Started');
                          },
                          onComplete: () {
                            setState(() {
                              resendButtonEnabled = true;
                            });

                            debugPrint('Countdown Ended');
                          },
                          onChange: (String timeStamp) {
                            debugPrint('Countdown Changed $timeStamp');
                          },
                          timeFormatterFunction:
                              (defaultFormatterFunction, duration) {
                            if (duration.inSeconds == 0) {
                              return "00:00";
                            } else {
                              return Function.apply(
                                  defaultFormatterFunction, [duration]);
                            }
                          },
                        ),
                        spacing_medium,
                        Center(
                          child: Column(
                            children: [
                              TextValue3(
                                title: 'Didn’t get a verification code?',
                              ),
                              // spacing_small,
                              // SizedBox(
                              //   width: 2,
                              // ),
                              TextButton(
                                child: Text(
                                  'Resend Code',
                                  style: heading4TextSmall(width,
                                      color: resendButtonEnabled == false
                                          ? null
                                          : green),
                                ),
                                onPressed: resendButtonEnabled == false
                                    ? null
                                    : () async {
                                        logMethod(
                                            title: 'Time is',
                                            message: _controller
                                                .getTime()
                                                .toString());
                                        // if(_controller.getTime().toString()=='02:00'){

                                        var rng = new Random();
                                        var code = rng.nextInt(90000) + 10000;
                                        sendCustomEmail(
                                            code: code.toString(),
                                            email: emailController.text
                                                .trim()
                                                .toString());

                                        setState(() {
                                          _controller.reset();
                                          _controller.start();
                                          sendedCode = code.toString();
                                        });
                                      },
                              )
                            ],
                          ),
                        ),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   children: [
                        //     ZakiCicularButton(
                        //                         title: '   Resend   ',
                        //                         width: width,
                        //                         textStyle: heading4TextSmall(width, color: resendButtonEnabled == false? grey : green),
                        //                         selected: resendButtonEnabled == false? 1:null,
                        //                         onPressed: resendButtonEnabled == false? null: () async{
                        //                           logMethod(title: 'Time is', message: _controller.getTime().toString());
                        //                           // if(_controller.getTime().toString()=='02:00'){

                        //                           var rng = new Random();
                        //                           var code = rng.nextInt(90000) + 10000;
                        //                           sendCustomEmail(code: code.toString(), email: emailController.text.trim().toString());

                        //                           setState(() {
                        //                            _controller.reset();
                        //                            _controller.start();
                        //                            sendedCode = code.toString();
                        //                         });

                        //                         },
                        //                       ),
                        //   ],
                        // ),
                        // spacing_medium,
                        TextValue3(
                            title: 'Reminder: Check your Spam / Junk folder'),
                      ],
                    ),
                  ),
                ),
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ZakiCicularButton(
                        title: '   Confirm   ',
                        width: width,
                        selected: 4,
                        backGroundColor: green,
                        border: false,
                        textStyle: heading4TextSmall(width, color: white),
                        onPressed: () async {
                          if (_controller.getTime().toString() == '01:00') {
                            setState(() {
                              error = 'Code is expired';
                            });
                            return;
                          }
                          if (emailVerifiedCode.text.trim().toString() !=
                              sendedCode) {
                            setState(() {
                              error = 'Verification Failed';
                            });
                            return;
                          }
                          ApiServices services = ApiServices();
                          String? verfiyEmail =
                              await services.updateUserEmailStatus(
                                  emailStatus: true,
                                  userId: appConstants.userRegisteredId);
                          if (verfiyEmail != null) {
                            await services.getUserData(
                                userId: appConstants.userRegisteredId,
                                context: context);
                            showNotification(
                                error: 0,
                                icon: Icons.verified,
                                message: 'Email Verified');
                            Navigator.pop(context);
                          }
                        },
                      ),
                      //   const SizedBox(
                      //     width: 10,
                      //   ),

                      // ZakiCicularButton(
                      //   title:' Cancle ',
                      //   width: width,
                      //   selected: 4,
                      //   backGroundColor: green,
                      //   border: false,
                      //   textStyle: heading4TextSmall(width, color: white),
                      //   onPressed: (){
                      //     Navigator.pop(context);
                      //   },
                      // ),
                    ],
                  ),
                ]);
          },
        );
      },
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    nickNameController.dispose();
    userNameController.dispose();
    emailController.dispose();
    phoneNumberController.dispose();
    emailVerifiedCode.dispose();
    super.dispose();
  }

  // void clearFields() {
  //   nameController.text = '';
  //   nickNameController.text = '';
  //   userNameController.text = '';
  //   setState(() {
  //   });
  // }
  final CountDownController _controller = CountDownController();
  @override
  void initState() {
    // userNameController.text = '@jhons';
    // emailController.text = 'Johndoe@gmail.com';
    // phoneNumberController.text = '966 222 555 69';

    Future.delayed(const Duration(milliseconds: 100), () {
      var appConstants = Provider.of<AppConstants>(context, listen: false);
      USStates.getAllNames().forEach((element) {
        logMethod(title: 'Name', message: element);
      });
      logMethod(
          title: 'User email Status',
          message: appConstants.userModel.emailVerfied.toString());
      // verfiyEmail();
      // if (appConstants.userChildRegisteredId != '') {
      //   nameController.text = appConstants.firstName;
      //   nickNameController.text = appConstants.userModel.usaLastName!;
      // } else {

      if (appConstants.userModel.usaDob != '') {
        appConstants.updateDateOfBirth(appConstants.userModel.usaDob!);
        // return;
      }
      if (appConstants.userModel.anniverasryDate != '' &&
          appConstants.userModel.anniverasryDate != null) {
        appConstants
            .updateAnniversaryDate(appConstants.userModel.anniverasryDate!);
        // return;
      }
      userNameController.text = appConstants.userModel.usaUserName!;
      emailController.text = appConstants.userModel.usaEmail!;
      phoneNumberController.text =
          appConstants.userModel.usaPhoneNumber!.substring(4);
      nameController.text = appConstants.userModel.usaFirstName!;
      nickNameController.text = appConstants.userModel.usaLastName!;

      appConstants.updateSignUpRole(getRole(
          usertype: appConstants.userModel.usaUserType,
          gender: appConstants.userModel.usaGender));
      zipController.text = appConstants.userModel.zipCode ?? '';
      logMethod(
          title: 'State', message: appConstants.userModel.userState ?? '');
      appConstants.updateGenderType(appConstants.userModel.usaGender!);
      appConstants.updateSelectedCounteryState(
          appConstants.userModel.userState == null ||
                  (appConstants.userModel.userState == '')
              ? 'Select State'
              : appConstants.userModel.userState!);
      // }
    });
    super.initState();
  }

  String getRole({String? usertype, String? gender}) {
    String role = '';
    if (usertype == AppConstants.USER_TYPE_SINGLE) {
      role = 'An Adult';
    } else if (usertype == AppConstants.USER_TYPE_PARENT && gender == 'Male') {
      role = 'Dad';
    } else if (usertype == AppConstants.USER_TYPE_PARENT &&
        gender == 'Female') {
      role = 'Mom';
    } else if (usertype == AppConstants.USER_TYPE_KID && gender == 'Male') {
      role = 'Son';
    } else if (usertype == AppConstants.USER_TYPE_KID && gender == 'Female') {
      role = 'Daughter';
    } else if (usertype == AppConstants.USER_TYPE_KID) {
      role = 'A Kid';
    }
    return role;
  }

  @override
  Widget build(BuildContext context) {
    var appConstants = Provider.of<AppConstants>(context, listen: true);
    var internet = Provider.of<CheckInternet>(context, listen: true);
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
        body: SafeArea(
      child: Form(
        key: formGlobalKey,
        autovalidateMode: AutovalidateMode.disabled,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 0),
            child: Column(
              children: [
                appBarHeader_005(
                    context: context,
                    appBarTitle: 'Edit Profile',
                    backArrow: false,
                    height: height,
                    width: width,
                    leadingIcon: true),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        InkWell(
                            onTap: () async {},
                            child: appConstants
                                        .userModel.usaBackgroundImageUrl !=
                                    null
                                ? appConstants.userModel.usaBackgroundImageUrl!
                                        .contains('assets/images/')
                                    ? Image.asset(
                                        appConstants
                                            .userModel.usaBackgroundImageUrl
                                            .toString(),
                                        width: width,
                                        height: height * 0.18,
                                        fit: BoxFit.cover,
                                      )
                                    : appConstants.userModel
                                                .usaBackgroundImageUrl !=
                                            ''
                                        ? CachedNetworkImage(
                                            imageUrl: appConstants
                                                .userModel.usaBackgroundImageUrl
                                                .toString(),
                                            width: width,
                                            height: height * 0.18,
                                            fit: BoxFit.contain,
                                            placeholder: (context, url) =>
                                                Center(child: CustomLoader()),
                                            errorWidget:
                                                (context, url, error) =>
                                                    Icon(Icons.error),
                                          )
                                        : Image.asset(
                                            imageBaseAddress +
                                                '1_background.png',
                                            width: width,
                                            height: height * 0.18,
                                            fit: BoxFit.cover,
                                          )
                                : Image.asset(
                                    imageBaseAddress + 'header_background.png',
                                    width: width,
                                    height: height * 0.18,
                                    fit: BoxFit.cover,
                                  )),
                        Positioned(
                          top: 5,
                          right: 5,
                          child: Container(
                            decoration: BoxDecoration(
                                color: white, shape: BoxShape.circle),
                            child: InkWell(
                              onTap: () {
                                appConstants.updateComeFrom(from: false);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ChooseImageForUpload(
                                              imageUrl: appConstants.userModel
                                                  .usaBackgroundImageUrl,
                                            )));
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Icon(
                                  Icons.camera_alt,
                                  color: grey,
                                  size: width * 0.045,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                            bottom: -height * 0.065,
                            left: width * 0.03,
                            child: Row(
                              children: [
                                Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    InkWell(
                                      onTap: () async {
                                        appConstants.updateComeFrom(from: true);
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ChooseImageForUpload(
                                                        imageUrl: appConstants
                                                            .userModel.usaLogo,
                                                        userType: appConstants
                                                            .userModel
                                                            .usaUserType,
                                                        gender: appConstants
                                                            .userModel
                                                            .usaGender)));
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: white,
                                            shape: BoxShape.circle,
                                            border: Border.all(color: grey)),
                                        width: width * 0.24,
                                        height: height * 0.13,
                                        child: Center(
                                            child: userImage(
                                                imageUrl: appConstants
                                                    .userModel.usaLogo!,
                                                userType: appConstants
                                                    .userModel.usaUserType,
                                                width: width,
                                                gender: appConstants
                                                    .userModel.usaGender,
                                                appConstants: appConstants)),
                                      ),
                                    ),
                                    Positioned(
                                      top: height * 0.02,
                                      right: 10,
                                      child: InkWell(
                                        onTap: () {
                                          appConstants.updateComeFrom(
                                              from: true);
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ChooseImageForUpload(
                                                        imageUrl: appConstants
                                                            .userModel.usaLogo,
                                                      )));
                                        },
                                        child: Card(
                                          elevation: 10,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                          ),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: white,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        width * 0.18)),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(3.0),
                                              child: Icon(
                                                Icons.camera_alt,
                                                size: width * 0.026,
                                                color: grey,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            )),
                      ],
                    ),
                    spacing_large,
                    spacing_large,
                    Text(
                      'My name is:',
                      style: heading1TextStyle(context, width),
                    ),
                    Row(
                      children: [
                        // TextFormField(
                        //         autovalidateMode: AutovalidateMode.onUserInteraction,
                        //         validator: (String? name) {
                        //           if (name!.isEmpty) {
                        //             return 'Please Enter Name';
                        //           } else {
                        //             return null;
                        //           }
                        //         },
                        //         // style: TextStyle(color: primaryColor),
                        //         style: heading2TextStyle(context, width),
                        //         controller: nameController,
                        //         obscureText: false,
                        //         keyboardType: TextInputType.name,
                        //         maxLines: 1,
                        //         maxLength: 20,
                        //         onChanged: (String firstName) {
                        //           appConstants.updateFirstName(firstName);
                        //           appConstants.userModel.usaFirstName = firstName;
                        //         },
                        //         decoration: InputDecoration(
                        //           counterText: "",
                        //           isDense: true,
                        //           hintText: 'First Name',
                        //           hintStyle:
                        //               heading2TextStyle(context, width, color: black),
                        //         ),
                        //       ),
                        Expanded(
                          child: CustomHeaders(
                            hintText: 'First Name',
                            controller: nameController,
                            validator: (String? name) {
                              if (name!.isEmpty) {
                                return 'Enter Name';
                              } else {
                                return null;
                              }
                            },
                            onChange: (String firstName) {},
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: CustomHeaders(
                            hintText: 'Last Name',
                            controller: nickNameController,
                            validator: (String? name) {
                              if (name!.isEmpty) {
                                return 'Enter Last Name';
                              } else {
                                return null;
                              }
                            },
                            onChange: (String lastName) {},
                          ),
                        ),
                      ],
                    ),
                    spacing_large,
                    Padding(
                      padding: const EdgeInsets.only(top: 6.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'I am a',
                                  style: heading1TextStyle(context, width),
                                ),
                                appConstants.userModel.usaUserType !=
                                        AppConstants.USER_TYPE_PARENT
                                    ? DropdownButtonHideUnderline(
                                        child: DropdownButton(
                                            // isExpanded: true,
                                            // Initial Value
                                            value: appConstants.genderType,
                                            style: heading2TextStyle(
                                                context, width),

                                            // Down Arrow Icon
                                            icon: Icon(
                                                Icons.keyboard_arrow_down,
                                                color: black),

                                            // Array list of items
                                            items:
                                                genderList.map((String items) {
                                              return DropdownMenuItem(
                                                value: items,
                                                child: Text(
                                                  items,
                                                  style: heading2TextStyle(
                                                      context, width),
                                                ),
                                              );
                                            }).toList(),
                                            onChanged: null),
                                      )
                                    : DropdownButtonHideUnderline(
                                        child: DropdownButton(
                                            // isExpanded: true,
                                            // Initial Value

                                            value: appConstants.signUpRole,
                                            style: heading2TextStyle(
                                                context, width),

                                            // Down Arrow Icon
                                            icon: Icon(
                                                Icons.keyboard_arrow_down,
                                                color: black),

                                            // Array list of items
                                            items: roleList.map((String items) {
                                              return DropdownMenuItem(
                                                value: items,
                                                child: Text(
                                                  items,
                                                  style: heading2TextStyle(
                                                      context, width),
                                                ),
                                              );
                                            }).toList(),
                                            onChanged: null),
                                      ),
                                Divider(
                                  color: black,
                                  height: 0.3,
                                )
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                              child: SizedBox(
                            height: 0,
                          )),
                        ],
                      ),
                    ),
                    spacing_large,
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     Expanded(
                    //       flex: 6,
                    //       child: Column(
                    //         crossAxisAlignment: CrossAxisAlignment.start,
                    //         children: [
                    //           Text(
                    //             'Living in:',
                    //             style: heading1TextStyle(context, width),
                    //           ),
                    //           spacing_medium,
                    //           Row(
                    //             children: [
                    //               Expanded(
                    //                 child: Padding(
                    //                   padding:
                    //                       const EdgeInsets.only(bottom: 4.0),
                    //                   child: InkWell(
                    //                     onTap: () {
                    //                       showDialog(
                    //                         context: context,
                    //                         builder: (BuildContext context) {
                    //                           return SelectCounteryState(
                    //                             listItems:
                    //                                 USStates.getAllNames(),
                    //                           );
                    //                         },
                    //                       );
                    //                     },
                    //                     child: Text(
                    //                       appConstants.selectedCountrySate,
                    //                       overflow: TextOverflow.clip,
                    //                       style:
                    //                           heading2TextStyle(context, width),
                    //                     ),
                    //                   ),
                    //                 ),
                    //               ),
                    //               Padding(
                    //                 padding: const EdgeInsets.all(0.0),
                    //                 child: Icon(Icons.keyboard_arrow_down,
                    //                     color: black),
                    //               ),
                    //             ],
                    //           ),
                    //           Divider(
                    //             color: black,
                    //             height: 0.32,
                    //           )
                    //         ],
                    //       ),
                    //     ),
                    //     const SizedBox(width: 8),
                    //     Expanded(
                    //       flex: 5,
                    //       child: Column(
                    //         children: [
                    //           textValueHeaderbelow,
                    //           textValueHeaderbelow,
                    //           textValueHeaderbelow,
                    //           textValueHeaderbelow,
                    //           CustomHeaders(
                    //             hintText: 'Zip Code',
                    //             controller: zipController,
                    //             keyboardType: TextInputType.number,
                    //             maxLength: 5,
                    //             inputFormates: [
                    //               FilteringTextInputFormatter.digitsOnly
                    //             ],
                    //             validator: (String? zipcode) {
                    //               if (zipcode!.isEmpty) {
                    //                 return 'Please Enter Zip Code';
                    //               } else {
                    //                 return null;
                    //               }
                    //             },
                    //             onChange: (String zipcode) {
                    //               // appConstants.userModel.zipCode = zipcode;
                    //               // appConstants.updateZipCode(zipcode);
                    //             },
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    Text(
                          'Zip Code:',
                          style: heading1TextStyle(context, width),
                        ),
                    CustomHeaders(
                                hintText: 'Zip Code',
                                controller: zipController,
                                keyboardType: TextInputType.number,
                                maxLength: 5,
                                inputFormates: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                validator: (String? zipcode) {
                                  if (zipcode!.isEmpty) {
                                    return 'Please Enter Zip Code';
                                  } else {
                                    return null;
                                  }
                                },
                                onChange: (String zipcode) {
                                  // appConstants.userModel.zipCode = zipcode;
                                  // appConstants.updateZipCode(zipcode);
                                },
                              ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        spacing_large,
                        Text(
                          'I was born on:',
                          style: heading1TextStyle(context, width),
                        ),
                        spacing_small,
                        InkWell(
                          onTap: null,
                          //  () async {
                          //   DateTime? dateTime = await showDatePicker(
                          //       context: context,
                          //       initialDate: DateTime.now(),
                          //       firstDate: DateTime(1950),
                          //       lastDate: DateTime.now(),
                          //       builder: (context, child) {
                          //                     return Theme(
                          //                       data: Theme.of(context).copyWith(
                          //                         colorScheme: ColorScheme.light(
                          //                           primary: green,
                          //                         ),
                          //                       ),
                          //                       child: child!,
                          //                     );
                          //                   },
                          //       initialEntryMode:
                          //           DatePickerEntryMode.calendar);
                          //   // ignore: unnecessary_null_comparison
                          //   if (dateTime != null) {
                          //     print('selected date is: ${dateTime.day}');

                          //     showNotification(
                          //         error: 0,
                          //         icon: Icons.date_range,
                          //         message: 'Age is: ' +
                          //             calculateAge(birthDate: dateTime)
                          //                 .toString());

                          //     appConstants.updateDateOfBirth(
                          //         '${dateTime.month} / ${dateTime.day} /  ${dateTime.year}');
                          //     // if (calculateAge(birthDate: dateTime) < 18) {
                          //     //   Navigator.push(context,
                          //     //       MaterialPageRoute(builder: (context) {
                          //     //     return AskYourParent();
                          //     //   }));
                          //     // }
                          //   }
                          // },
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  appConstants.dateOfBirth,
                                  overflow: TextOverflow.clip,
                                  style: heading2TextStyle(context, width),
                                ),
                              ),
                              Icon(
                                Icons.calendar_today_rounded,
                                color: darkGrey,
                              ),
                            ],
                          ),
                        ),
                        spacing_small,
                        // ListTile(
                        //   onTap: ()
                        //   title:
                        //   trailing:
                        // ),
                        Divider(
                          color: black,
                          height: 0.3,
                        )
                      ],
                    ),
                    spacing_large,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'My email address is:',
                          style: heading1TextStyle(context, width),
                        ),
                        // VerifyOrNot(width),
                      ],
                    ),
                    appConstants.userModel.usaMethod!=AppConstants.LOGIN_TYPE_EMAIL?
                    Column(
                      children: [
                        spacing_medium,
                        LoginTypesButton(
                                      width: width,
                                      title: 'Connected with ${appConstants.userModel.usaMethod == AppConstants.LOGIN_TYPE_APPLE?'Apple': appConstants.userModel.usaMethod == AppConstants.LOGIN_TYPE_FACEBOOK?'Facebook': appConstants.userModel.usaMethod == AppConstants.LOGIN_TYPE_GOOGLE?'Google':'X'}',
                                      iconColor: appConstants.userModel.usaMethod == AppConstants.LOGIN_TYPE_APPLE? black: appConstants.userModel.usaMethod == AppConstants.LOGIN_TYPE_FACEBOOK? blue: appConstants.userModel.usaMethod == AppConstants.LOGIN_TYPE_GOOGLE? green: blue,
                                      icon: appConstants.userModel.usaMethod == AppConstants.LOGIN_TYPE_APPLE? FontAwesomeIcons.apple: appConstants.userModel.usaMethod == AppConstants.LOGIN_TYPE_FACEBOOK? FontAwesomeIcons.facebookF: appConstants.userModel.usaMethod == AppConstants.LOGIN_TYPE_GOOGLE? FontAwesomeIcons.google: FontAwesomeIcons.xTwitter,
                                      onPressed: null,
                                      ),
                      ],
                    ):
                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      maxLength: 40,
                      validator: appConstants.isUserPinUser != null
                          ? appConstants.isUserPinUser!
                              ? null
                              : null
                          : (String? name) {
                              if (name!.isEmpty) {
                                Future.delayed(Duration.zero, () {
                                  setState(() {
                                    emailErrorMessage =
                                        'Enter an email address';
                                  });
                                });
                                return 'Enter an email address';
                              } else if (!RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(name)) {
                                Future.delayed(Duration.zero, () {
                                  setState(() {
                                    emailErrorMessage =
                                        'Enter a valid email address';
                                  });
                                });
                                return 'Enter a valid email address';
                              } else {
                                Future.delayed(Duration.zero, () {
                                  setState(() {
                                    emailErrorMessage = '';
                                  });
                                });
                                return null;
                              }
                            },
                      // style: TextStyle(color: primaryColor),
                      style: heading2TextStyle(context, width),
                      controller: emailController,
                      obscureText: false,
                      keyboardType: TextInputType.emailAddress,
                      maxLines: 1,
                      onFieldSubmitted: (String email) {
                        if (email != appConstants.userModel.usaEmail &&
                            appConstants.userModel.emailVerfied != null &&
                            appConstants.userModel.emailVerfied == true) {
                          emailAddressChanged = true;
                        } else {
                          emailAddressChanged = false;
                        }
                        setState(() {});
                      },
                      onChanged: (String email) async {
                        if (email != appConstants.userModel.usaEmail) {
                          ApiServices services = ApiServices();
                          bool? isEmailExist =
                              await services.checkEmailExist(email: email);
                          if (isEmailExist!) {
                            setState(() {
                              emailErrorMessage =
                                  'This email is already taken, search for another one';
                            });
                          } else {
                            setState(() {
                              emailErrorMessage = '';
                            });
                          }
                        }
                      },
                      decoration: InputDecoration(
                        errorText:
                            emailErrorMessage == '' ? null : emailErrorMessage,
                        hintText: 'name@website.com',
                        counterText: '',
                        hintStyle: heading2TextStyle(context, width),
                        suffixIconConstraints: BoxConstraints.expand(
                            height: 50, width: width * 0.25),
                        suffixIcon: IconButton(
                            padding: EdgeInsets.zero,
                            onPressed: () {},
                            icon: ZakiCicularButton(
                              title: (appConstants.userModel.emailVerfied ==
                                          null ||
                                      appConstants.userModel.emailVerfied ==
                                          false ||
                                      emailAddressChanged == true)
                                  ? 'Verify Now'
                                  : 'Verified',
                              width: width,
                              icon: (appConstants.userModel.emailVerfied ==
                                          null ||
                                      appConstants.userModel.emailVerfied ==
                                          false ||
                                      emailAddressChanged == true)
                                  ? null
                                  : Icons.check,
                              iconColor: green,
                              // selected: 6,
                              border:
                                  (appConstants.userModel.emailVerfied ==
                                              null ||
                                          appConstants.userModel.emailVerfied ==
                                              false ||
                                          emailAddressChanged == true)
                                      ? true
                                      : false,
                              borderColor:
                                  (appConstants.userModel.emailVerfied ==
                                              null ||
                                          appConstants.userModel.emailVerfied ==
                                              false ||
                                          emailAddressChanged == true)
                                      ? crimsonColor
                                      : null,
                              // backGroundColor: crimsonColor,
                              textStyle: heading4TextSmall(width * 0.8,
                                  color: (appConstants.userModel.emailVerfied ==
                                              null ||
                                          appConstants.userModel.emailVerfied ==
                                              false ||
                                          emailAddressChanged == true)
                                      ? crimsonColor
                                      : green),
                              //   onPressed: () {
                              //   },
                              // ),
                              //  Icon(Icons.verified, color: (appConstants.userModel.emailVerfied==null ||  appConstants.userModel.emailVerfied==false || emailAddressChanged==true )?  red: green,),
                              onPressed: emailErrorMessage != ''
                                  ? null
                                  : internet.status ==
                                          AppConstants
                                              .INTERNET_STATUS_NOT_CONNECTED
                                      ? null
                                      : () async {
                                          if (appConstants.userModel.emailVerfied != null &&
                                              appConstants
                                                      .userModel.emailVerfied ==
                                                  true &&
                                              emailAddressChanged == false) {
                                            return;
                                          }
                                          if (appConstants
                                                      .userModel.emailVerfied ==
                                                  null ||
                                              appConstants
                                                      .userModel.emailVerfied ==
                                                  false ||
                                              emailController.text.isNotEmpty) {
                                            var rng = new Random();
                                            var code =
                                                rng.nextInt(90000) + 10000;
                                            sendCustomEmail(
                                                code: code.toString(),
                                                email: emailController.text
                                                    .trim()
                                                    .toString());
                                            // verfiyEmail(email: emailController.text, sendedCode: code.toString());
                                            String? emailStatus =
                                                await Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            EmailVerfication(
                                                                sendedCode: code
                                                                    .toString(),
                                                                emailForResend:
                                                                    emailController
                                                                        .text
                                                                        .trim())));
                                            if (emailStatus != null) {
                                              await ApiServices().getUserData(
                                                  userId: appConstants
                                                      .userRegisteredId,
                                                  context: context);

                                              emailAddressChanged = false;
                                              setState(() {});
                                            }
                                          }
                                        },
                            )),
                      ),
                    ),
                    spacing_large,
                    appConstants.isUserPinUser != null
                        ? appConstants.isUserPinUser!
                            ? const SizedBox()
                            : const SizedBox()
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'My Phone Number Is:',
                                style: heading1TextStyle(context, width),
                              ),
                              // VerifyOrNot(width),
                            ],
                          ),
                    appConstants.isUserPinUser != null
                        ? appConstants.isUserPinUser!
                            ? const SizedBox()
                            : const SizedBox()
                        : TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            inputFormatters: [
                              // CardFormatter(sample: "XXX-XXX-XXX", separator: "-")
                              // maskFormatter
                              appConstants.userModel.usaCountry ==
                                      AppConstants.COUNTRY_SAUDIA
                                  ? saudiaMaskFormatter
                                  : qatarMaskFormatter
                            ],
                            validator: (String? email) {
                              if (email!.isEmpty) {
                                return 'Please Enter Number';
                              } else {
                                return null;
                              }
                            },
                            // style: TextStyle(color: primaryColor),
                            style: heading2TextStyle(context, width),
                            controller: phoneNumberController,
                            obscureText: false,
                            keyboardType: TextInputType.number,
                            maxLines: 1,
                            enabled: false,
                            decoration: InputDecoration(
                              hintText: '000-000-0000',
                              hintStyle: heading2TextStyle(context, width),
                              // prefixIconConstraints:
                              //     const BoxConstraints(minWidth: 10, minHeight: 10, maxHeight: 40, maxWidth: 40),
                              contentPadding: const EdgeInsets.only(top: 18),
                              prefixIcon:
                                  customCountryPicker(appConstants, width, country: appConstants.userModel.usaCountry),
                              // prefixIcon: CountryCodePicker(
                              //   onChanged: print,
                              //   enabled: false,
                              //   textStyle:
                              //       heading3TextStyle(width, color: grey),
                              //   // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                              //   initialSelection: 'US',
                              //   // favorite: ['+39','FR'],
                              //   // optional. Shows only country name and flag
                              //   showCountryOnly: false,
                              //   showFlag: false,
                              //   countryFilter: const ['US'],
                              //   // optional. Shows only country name and flag when popup is closed.
                              //   showOnlyCountryWhenClosed: false,
                              //   // optional. aligns the flag and the Text left
                              //   alignLeft: false,
                              // )
                            ),
                          ),
                    appConstants.userModel.usaUserType !=
                            AppConstants.USER_TYPE_PARENT
                        ? const SizedBox()
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              spacing_large,
                              Text(
                                'My wedding anniversary is on:',
                                style: heading1TextStyle(context, width),
                              ),
                              ListTile(
                                dense: true,
                                contentPadding: EdgeInsets.zero,
                                onTap: () async {
                                  DateTime? dateTime = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(1950),
                                      lastDate: DateTime.now(),
                                      builder: (context, child) {
                                        return Theme(
                                          data: Theme.of(context).copyWith(
                                            colorScheme: ColorScheme.light(
                                              primary: green,
                                            ),
                                          ),
                                          child: child!,
                                        );
                                      },
                                      initialEntryMode:
                                          DatePickerEntryMode.calendar);
                                  if (dateTime != null) {
                                    appConstants.updateAnniversaryDate(
                                        '${dateTime.day} / ${dateTime.month} / ${dateTime.year}');
                                  }
                                },
                                title: Text(
                                  appConstants.anniversaryDate,
                                  overflow: TextOverflow.clip,
                                  style: heading2TextStyle(context, width),
                                ),
                                trailing:
                                    const Icon(Icons.calendar_today_rounded),
                              ),
                              Divider(
                                color: black,
                                height: 0.3,
                              )
                            ],
                          ),
                    spacing_large,
                    Text(
                      'I would like my username to be:',
                      style: heading1TextStyle(context, width),
                    ),
                    CustomHeaders(
                      hintText: 'Username',
                      controller: userNameController,
                      maxLength: 10,
                      validationMode: AutovalidateMode.disabled,
                      error: userNameErrorMessage,
                      leadingIcon: Icon(
                        FontAwesomeIcons.at,
                        size: width * 0.04,
                        color: grey,
                      ),
                      validator: (String? name) {
                        if (name!.isEmpty) {
                          return 'Enter a Username';
                        } else {
                          return null;
                        }
                      },
                      onChange: (String username) async {
                        appConstants.updateUserName(username);
                        // appConstants.userModel.usaUserName = username;
                        if (username == appConstants.userModel.usaUserName) {
                          return;
                        }
                        ApiServices services = ApiServices();
                        bool? isUserNameExist =
                            await services.checkUserNameExist(
                                userName: userNameController.text);
                        if (isUserNameExist!) {
                          setState(() {
                            userNameErrorMessage =
                                'Sorry, username taken, search for another one';
                          });
                        } else {
                          setState(() {
                            userNameErrorMessage = '';
                          });
                        }
                      },
                    ),
                    spacing_large,
                    ZakiPrimaryButton(
                        title: 'Update',
                        width: width,
                        onPressed: (emailErrorMessage != '' ||
                                userNameErrorMessage != '')
                            ? null
                            : internet.status ==
                                    AppConstants.INTERNET_STATUS_NOT_CONNECTED
                                ? null
                                : () async {
                                    if (!formGlobalKey.currentState!
                                        .validate()) {
                                      return;
                                    }
                                    // if(appConstants.userModel.usaUserName!= userNameController.text.trim()){
                                    // ApiServices services = ApiServices();
                                    // bool? isUserNameExist =
                                    //     await services.checkUserNameExist(
                                    //         userName: userNameController.text);
                                    // if (isUserNameExist!) {
                                    //   setState(() {
                                    //     userNameErrorMessage =
                                    //         'username already taken, search another username';
                                    //   });
                                    //   return;
                                    // }
                                    // }

                                    if (appConstants.userChildRegisteredId !=
                                        '') {
                                      ApiServices services = ApiServices();
                                      // String? response =
                                      await services.edittedProfile(
                                          dob: appConstants.dateOfBirth,
                                          email: emailController.text,
                                          firstName: nameController.text,
                                          lastName: nickNameController.text,
                                          isEnabled: true,
                                          phoneNumber: appConstants
                                              .userModel.usaPhoneNumber,
                                          userName: userNameController.text,
                                          zipCode: zipController.text,
                                          userId: appConstants
                                              .userChildRegisteredId,
                                          userState:
                                              appConstants.selectedCountrySate,
                                          anniversaryDate:
                                              appConstants.anniversaryDate);
                                      // if (response!=null) {
                                      List<dynamic> list = await services
                                          .getDevicesArray(appConstants
                                              .userChildRegisteredId);
                                      // showNotification(error: 0, icon: Icons.clean_hands, message: list.first);
                                      list.add(await services.getDeviceId());
                                      await services.updateDevicesArray(
                                          appConstants.userChildRegisteredId,
                                          list);

                                      await services.getUserData(
                                          context: context,
                                          userId: appConstants
                                              .userChildRegisteredId);
                                      // appConstants.updateFirstName(nameController.text);
                                      // appConstants.updateLastName(nickNameController.text);
                                      // appConstants
                                      //     .updatePhoneNumber(phoneNumberController.text);
                                      // appConstants.updateUserName(userNameController.text);
                                      Future.delayed(
                                          const Duration(milliseconds: 200),
                                          () {
                                        logMethod(
                                            title: 'PIN Code User value:',
                                            message: appConstants
                                                .userModel.isUserPinUser
                                                .toString());
                                        logMethod(
                                            title: 'User type value:',
                                            message: appConstants
                                                .userModel.usaUserType
                                                .toString());
                                        if (appConstants
                                            .userModel.isUserPinUser!) {
                                          // Navigator.push(
                                          //     context,
                                          //     MaterialPageRoute(
                                          //         builder: (context) =>
                                          //             const SyncContactsPermssion()));
                                        }
                                        // else if (appConstants.userModel.usaUserType! ==
                                        //         'Single Male' ||
                                        //     appConstants.userModel.usaUserType! ==
                                        //         'Single Female') {
                                        //   Navigator.push(
                                        //       context,
                                        //       MaterialPageRoute(
                                        //           builder: (context) =>
                                        //               const AccountSetupAsAkid()));
                                        // }
                                        else {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const AccountSetupInformation()));
                                        }
                                      });
                                      //

                                      // }
                                      // showNotification(
                                      //   error: 0,
                                      //   icon: Icons.clear,
                                      //   message: 'Successfully Updated'
                                      // );
                                    } else {
                                      ApiServices services = ApiServices();
                                      await services.edittedProfile(
                                          dob: appConstants.dateOfBirth,
                                          email: emailController.text,
                                          firstName: nameController.text,
                                          lastName: nickNameController.text,
                                          isEnabled: true,
                                          zipCode: zipController.text,
                                          phoneNumber: appConstants
                                              .userModel.usaPhoneNumber,
                                          userName: userNameController.text,
                                          userId: appConstants.userRegisteredId,
                                          userState:
                                              appConstants.selectedCountrySate,
                                          anniversaryDate:
                                              appConstants.anniversaryDate);

                                      await services.getUserData(
                                          context: context,
                                          userId:
                                              appConstants.userRegisteredId);
                                      showNotification(
                                          error: 0,
                                          icon: Icons.clear,
                                          message: NotificationText
                                              .ADDED_SUCCESSFULLY);
                                      Navigator.pop(context);
                                      // appConstants.updateFirstName(nameController.text);
                                      // appConstants.updateLastName(nickNameController.text);
                                      // appConstants
                                      //     .updatePhoneNumber(phoneNumberController.text);
                                      // appConstants.updateUserName(userNameController.text);
                                      // Future.delayed(const Duration(milliseconds: 200), () {
                                      //   if (appConstants.userModel.usaUserType!
                                      //           .toUpperCase() ==
                                      //       'Kid'.toUpperCase()) {
                                      //     Navigator.push(
                                      //         context,
                                      //         MaterialPageRoute(
                                      //             builder: (context) =>
                                      //                 const AccountSetupAsAkid()));
                                      //   } else {
                                      //     Navigator.push(
                                      //         context,
                                      //         MaterialPageRoute(
                                      //             builder: (context) =>
                                      //                 const AccountSetupInformation()));
                                      //   }
                                      // });
                                    }
                                  }),
                    spacing_medium
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }

  // Row VerifyOrNot(double width) {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.end,
  //     children: [
  //       Icon(
  //         Icons.error,
  //         color: yellow,
  //         size: width * 0.05,
  //       ),
  //       Padding(
  //         padding: const EdgeInsets.symmetric(horizontal: 4.0),
  //         child: Text(
  //           'Verify',
  //           style:
  //               textStyleHeading2WithTheme(context, width * 0.6, whiteColor: 4),
  //         ),
  //       )
  //     ],
  //   );
  // }
}
