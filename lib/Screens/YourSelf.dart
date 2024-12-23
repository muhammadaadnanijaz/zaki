import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:zaki/Constants/HelperFunctions.dart';
import 'package:zaki/Constants/NotificationTitle.dart';
import 'package:zaki/Constants/Styles.dart';
import 'package:zaki/Widgets/TextHeader.dart';
import '../Constants/AppConstants.dart';
import '../Constants/Spacing.dart';
import '../Services/api.dart';
import '../Widgets/CustomHeaderTextField.dart';
// import '../Widgets/SelectCouneryState.dart';

final formGlobalKey = GlobalKey<FormState>();

class YouSelfInformation extends StatefulWidget {
  final bool? secondaryUser;
  const YouSelfInformation({Key? key, this.secondaryUser}) : super(key: key);

  @override
  _YouSelfInformationState createState() => _YouSelfInformationState();
}

class _YouSelfInformationState extends State<YouSelfInformation> {
  // List of items in our dropdown menu
  var genderList = ['Male', 'Female', 'Rather not specify'];
  var roleList = [
    'Dad',
    'Mom',
  ];
  ApiServices services = ApiServices();

  TextEditingController nameController = TextEditingController();
  // TextEditingController zipController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailAddressController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  //   @override
  // void dispose() {
  //   nameController.dispose();
  //   lastNameController.dispose();
  //   userNameController.dispose();
  //   emailAddressController.dispose();
  //   phoneNumberController.dispose();
  //   super.dispose();
  // }
  DateTime now = DateTime.now();
  late DateTime firstDate;
  late DateTime lastDate;

  void clearFields() {
    nameController.text = '';
    lastNameController.text = '';
    userNameController.text = '';
    emailAddressController.text = '';
    phoneNumberController.text = '';
  }

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 200), () {
      var appConstants = Provider.of<AppConstants>(context, listen: false);
      try {
        
      
      phoneNumberController.text = appConstants.phoneNumber;
      //  if (appConstants.userChildRegisteredId!='') {
      // userNameController.text = appConstants.userModel.usaUserName?? userNameController.text;
      emailAddressController.text =
          appConstants.userModel.usaEmail ?? emailAddressController.text;
      phoneNumberController.text =
          appConstants.userModel.usaPhoneNumber ?? emailAddressController.text;
      nameController.text =
          appConstants.userModel.usaFirstName ?? nameController.text;
      lastNameController.text =
          appConstants.userModel.usaLastName ?? lastNameController.text;
      // zipController.text = appConstants.userModel.zipCode ?? zipController.text;
      logMethod(
          title: 'Zip Code',
          message: 'Zip Code: ${appConstants.userModel.zipCode}');
      userNameController.text =
          appConstants.userModel.usaUserName ?? userNameController.text;
      appConstants.updateSelectedCounteryState(
          appConstants.userModel.userState == null ||
                  (appConstants.userModel.userState == '')
              ? 'Select State'
              : appConstants.userModel.userState!);
      // appConstants.updateGenderType(appConstants.userModel.usaGender.toString());
      if (appConstants.signUpRole == AppConstants.USER_TYPE_PARENT ||
          appConstants.signUpRole == AppConstants.USER_TYPE_SINGLE) {
        firstDate = DateTime(now.year - 80, now.month, now.day);
        lastDate = DateTime(now.year - 18, now.month, now.day);
      } else if (appConstants.signUpRole == AppConstants.USER_TYPE_KID) {
        firstDate = DateTime(now.year - 30, now.month, now.day);
        lastDate = DateTime(now.year - 8, now.month, now.day);
      } else {
        // For 'single' or any other types, define your logic here
        firstDate = DateTime(now.year - 80, now.month, now.day);
        lastDate = DateTime.now(); // or any other end date
      }
      if (widget.secondaryUser == true) {
        appConstants.updateDateOfBirth(
            '${appConstants.userModel.usaDob!.split('/')[1].trim()} / ${appConstants.userModel.usaDob!.split('/')[0].trim()} /  ${appConstants.userModel.usaDob!.split('/').last.trim()}');
        logMethod(
            title: 'Age is:',
            message:
                '${appConstants.dateOfBirth.toString()} and ${appConstants.userModel.usaDob!.split('/').last.trim()} and age is: ${DateTime.now().year - (int.parse(appConstants.userModel.usaDob!.split('/').last.trim().toString()))} and user type: ${appConstants.userModel.usaUserType}');
      }
      setState(() {});
      } catch (e) {
        
      }
      // }
    });
    super.initState();
  }

  String? firstNameVlidator(String? name) {
    if (name!.isEmpty) {
      return 'Enter Name';
    }
    // else if(name.length<15) {
    //   return 'Enter Full Name';
    // }
    return null;
  }
  // String?

  @override
  Widget build(BuildContext context) {
    var appConstants = Provider.of<AppConstants>(context, listen: true);
    // var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Form(
        key: formGlobalKey,
        autovalidateMode: AutovalidateMode.disabled,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              spacing_medium,
              if (widget.secondaryUser == null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextHeader1(
                      title: 'My name is:',
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
                            validator: firstNameVlidator,
                            onChange: (String firstName) {
                              appConstants.updateFirstName(firstName);
                              appConstants.userModel.usaFirstName = firstName;
                            },
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: CustomHeaders(
                            hintText: 'Last Name',
                            controller: lastNameController,
                            validator: firstNameVlidator,
                            onChange: (String lastName) {
                              appConstants.updateLastName(lastName);
                              appConstants.userModel.usaLastName = lastName;
                            },
                          ),
                        ),
                      ],
                    ),
                    spacing_large,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'I am a:',
                                style: heading1TextStyle(context, width),
                              ),
                              spacing_medium,
                              appConstants.accountSettingUpFor != 'Family'
                                  ? DropdownButtonHideUnderline(
                                      child: DropdownButton(
                                        isExpanded: true,
                                        isDense: true,
                                        // Initial Value
                                        value: appConstants.genderType,
                                        style:
                                            heading2TextStyle(context, width),

                                        // Down Arrow Icon
                                        icon: const Icon(
                                            Icons.keyboard_arrow_down),

                                        // Array list of items
                                        items: genderList.map((String items) {
                                          return DropdownMenuItem(
                                            value: items,
                                            child: Text(items),
                                          );
                                        }).toList(),
                                        // After selecting the desired option,it will
                                        // change button value to selected value
                                        onChanged: (String? value) {
                                          if (value.toString() == 'Male') {
                                            appConstants.updateSignUpRole(
                                                AppConstants.USER_TYPE_SINGLE);
                                            appConstants
                                                .updateGenderType('Male');
                                          } else if (value.toString() ==
                                              'Female') {
                                            appConstants.updateSignUpRole(
                                                AppConstants.USER_TYPE_SINGLE);
                                            appConstants
                                                .updateGenderType('Female');
                                          } else {
                                            appConstants.updateSignUpRole(
                                                AppConstants.USER_TYPE_SINGLE);
                                            appConstants.updateGenderType(
                                                'Rather not specify');
                                          }
                                          appConstants.updateDateOfBirth(
                                              'dd / mm / yyyy');
                                          // }
                                          if (appConstants.signUpRole ==
                                                  AppConstants
                                                      .USER_TYPE_PARENT ||
                                              appConstants.signUpRole ==
                                                  AppConstants
                                                      .USER_TYPE_SINGLE) {
                                            firstDate = DateTime(now.year - 80,
                                                now.month, now.day);
                                            lastDate = DateTime(now.year - 18,
                                                now.month, now.day);
                                          } else if (appConstants.signUpRole ==
                                              AppConstants.USER_TYPE_KID) {
                                            firstDate = DateTime(now.year - 30,
                                                now.month, now.day);
                                            lastDate = DateTime(now.year - 8,
                                                now.month, now.day);
                                          } else {
                                            // For 'single' or any other types, define your logic here
                                            firstDate = DateTime(now.year - 80,
                                                now.month, now.day);
                                            lastDate = DateTime
                                                .now(); // or any other end date
                                          }
                                          setState(() {});

                                          showNotification(
                                              error: 0,
                                              icon: FontAwesomeIcons.genderless,
                                              message:
                                                  '${appConstants.genderType} and ${appConstants.signUpRole}');
                                        },
                                      ),
                                    )
                                  : DropdownButtonHideUnderline(
                                      child: DropdownButton(
                                        isExpanded: true,
                                        isDense: true,
                                        // Initial Value
                                        value: appConstants.userType,
                                        style:
                                            heading2TextStyle(context, width),

                                        // Down Arrow Icon
                                        icon: const Icon(
                                            Icons.keyboard_arrow_down),

                                        // Array list of items
                                        items: roleList.map((String items) {
                                          return DropdownMenuItem(
                                            value: items,
                                            child: Text(items),
                                          );
                                        }).toList(),
                                        // After selecting the desired option,it will
                                        // change button value to selected value
                                        onChanged: (String? value) {
                                          appConstants.updateUserType(value!);
                                          if (value == 'Dad' ||
                                              value == 'Husband') {
                                            appConstants.updateSignUpRole(
                                                AppConstants.USER_TYPE_PARENT);
                                            appConstants
                                                .updateGenderType('Male');
                                          } else if (value == 'Mom' ||
                                              value == 'Wife') {
                                            appConstants.updateSignUpRole(
                                                AppConstants.USER_TYPE_PARENT);
                                            appConstants
                                                .updateGenderType('Female');
                                          } else if (value == 'Son') {
                                            appConstants.updateSignUpRole(
                                                AppConstants.USER_TYPE_KID);
                                            appConstants
                                                .updateGenderType('Male');
                                          } else if (value == 'Daughter') {
                                            appConstants.updateSignUpRole(
                                                AppConstants.USER_TYPE_KID);
                                            appConstants
                                                .updateGenderType('Female');
                                          } else if (value == 'An Adult') {
                                            appConstants.updateSignUpRole(
                                                AppConstants.USER_TYPE_SINGLE);
                                            appConstants.updateGenderType(
                                                'Rather not specify');
                                          } else if (value ==
                                              AppConstants.USER_TYPE_KID) {
                                            appConstants.updateSignUpRole(
                                                AppConstants.USER_TYPE_KID);
                                            appConstants.updateGenderType(
                                                'Rather not specify');
                                          }
                                          appConstants.updateDateOfBirth(
                                              'dd / mm / yyyy');
                                          // }
                                          if (appConstants.signUpRole ==
                                                  AppConstants
                                                      .USER_TYPE_PARENT ||
                                              appConstants.signUpRole ==
                                                  AppConstants
                                                      .USER_TYPE_SINGLE) {
                                            firstDate = DateTime(now.year - 80,
                                                now.month, now.day);
                                            lastDate = DateTime(now.year - 18,
                                                now.month, now.day);
                                          } else if (appConstants.signUpRole ==
                                              AppConstants.USER_TYPE_KID) {
                                            firstDate = DateTime(now.year - 30,
                                                now.month, now.day);
                                            lastDate = DateTime(now.year - 8,
                                                now.month, now.day);
                                          } else {
                                            // For 'single' or any other types, define your logic here
                                            firstDate = DateTime(now.year - 80,
                                                now.month, now.day);
                                            lastDate = DateTime
                                                .now(); // or any other end date
                                          }
                                          setState(() {});

                                          showNotification(
                                              error: 0,
                                              icon: FontAwesomeIcons.genderless,
                                              message:
                                                  '${appConstants.genderType} and ${appConstants.signUpRole}');
                                        },
                                      ),
                                    ),
                              Divider(
                                color: black,
                                height: 0.8,
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
                    // spacing_large,

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
                    //                   children: [
                    //                     Expanded(

                    //                       child: Padding(
                    //                         padding:
                    //                             const EdgeInsets.only(bottom: 4.0),
                    //                         child: InkWell(
                    //                           onTap: (){

                    //                             showDialog(
                    //                               context: context,
                    //                               useRootNavigator: true,
                    //                               builder: (BuildContext context) {
                    //                                 return SelectCounteryState(listItems: USStates.getAllNames(),);
                    //                               },
                    //                             );
                    //                           },
                    //                           child: Text(
                    //                             appConstants.selectedCountrySate,
                    //                             overflow: TextOverflow.clip,
                    //                             style: heading2TextStyle(
                    //                                 context, width),
                    //                           ),
                    //                         ),
                    //                       ),
                    //                     ),
                    //                     Icon(
                    //                         Icons.keyboard_arrow_down,
                    //                         color: black),
                    //                   ],
                    //                 ),
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
                    //             inputFormates: [
                    //               FilteringTextInputFormatter.digitsOnly
                    //               ],
                    //             keyboardType: TextInputType.number,
                    //             maxLength: 5,
                    //             validator: (String? zipcode) {
                    //               if (zipcode!.isEmpty) {
                    //                 return 'Enter a Zip Code';
                    //               } else if(zipcode.length<5) {
                    //                     return 'Enter a Zip Code';
                    //                   }
                    //                 return null;

                    //             },
                    //             onChange: (String zipcode) {
                    //               appConstants.userModel.zipCode = zipcode;
                    //               appConstants.updateZipCode(zipcode);
                    //             },
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //   ],
                    // ),
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
                          onTap: () async {
                            DateTime? dateTime = await showDatePicker(
                                context: context,
                                initialDate:
                                    lastDate, // or any initial date within the range
                                firstDate: firstDate,
                                lastDate: lastDate,
                                selectableDayPredicate: (DateTime val) {
                                  if ((val.isAfter(firstDate) ||
                                          val.isAtSameMomentAs(firstDate)) &&
                                      (val.isBefore(lastDate) ||
                                          val.isAtSameMomentAs(lastDate))) {
                                    return true;
                                  }
                                  return false;
                                },
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
                                initialEntryMode: DatePickerEntryMode.calendar);
                            // ignore: unnecessary_null_comparison
                            if (dateTime != null) {
                              print('Selected date is: ${dateTime.day}');
                              if (calculateAge(birthDate: dateTime) < 6) {
                                showNotification(
                                    error: 1,
                                    icon: Icons.date_range,
                                    message: NotificationText.AGE_UNDER_6);
                                return;
                              }
                              showNotification(
                                  error: 0,
                                  icon: Icons.date_range,
                                  message: 'Age is: ' +
                                      calculateAge(birthDate: dateTime)
                                          .toString());
                              appConstants.updateDateOfBirth(
                                  '${dateTime.day} / ${dateTime.month} / ${dateTime.year}');
                              appConstants.updateDateOfBirthWithDate(dateTime);
                            }
                          },
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
                                size: 18,
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
                  ],
                ),

              ///For secondary User
              if (widget.secondaryUser == true)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    spacing_large,
                    Text(
                      'Welcome, ${appConstants.userModel.usaFirstName}',
                      style: heading1TextStyle(context, width),
                    ),
                  ],
                ),
              spacing_large,
              //  if((DateTime.now().year - (int.parse(appConstants.userModel.usaDob!.split('/').last.trim().toString())) < 13 && appConstants.userModel.usaUserType==AppConstants.USER_TYPE_KID ))
              if(appConstants.myEmailUsedStatus==true)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'My email address is:',
                    style: heading1TextStyle(context, width),
                  ),
                  CustomHeaders(
                    hintText: 'name@website.com',
                    controller: emailAddressController,
                    maxLength: 40,
                    validationMode: AutovalidateMode.onUserInteraction,
                    validator:
                        // (DateTime.now().year - (int.parse(appConstants.userModel.usaDob!.split('/').last.trim().toString())) < 13 && appConstants.userModel.usaUserType==AppConstants.USER_TYPE_KID) ? null:
                        (String? email) {
                      // calculateAge()
                      if (appConstants.userModel.usaUserType ==
                              AppConstants.USER_TYPE_KID &&
                          !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(email!)) {
                        return 'Enter a valid email address';
                      }
                      if (email!.isEmpty &&
                          appConstants.userModel.usaUserType !=
                              AppConstants.USER_TYPE_KID) {
                        return 'Enter an email';
                      } else if (!RegExp(
                              r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
                          .hasMatch(email)) {
                        return 'Enter a valid email address';
                      } else {
                        String emailDomain = email.split('@')[1];
                        String domainExtension = emailDomain.split('.').last;
                        List<String> validExtensions = [
                          'com',
                          'net',
                          'org',
                          'edu',
                          'gov'
                        ];
                        // add more extensions as needed
                        if (!validExtensions.contains(domainExtension)) {
                          // if(mounted)
                          // appConstants.alreadyExistEmailErrorMessageUpdate('Enter a valid email address');
                          return 'Enter a valid email address';
                        }
                      }
                      return null;
                    },
                    error: appConstants.alreadyExistEmailErrorMessage,
                    onChange: (String email) async {
                      appConstants.updateEmail(email);

                      if (email.isEmpty) {
                        appConstants.alreadyExistEmailErrorMessageUpdate('');
                      }
                      if (email.isNotEmpty
                          // && email != appConstants.userModel.usaEmail
                          ) {
                        bool? isEmailExist =
                            await services.checkEmailExist(email: email);
                        if (isEmailExist! &&
                            email != appConstants.userModel.usaEmail) {
                          appConstants.alreadyExistEmailErrorMessageUpdate(
                              'This email is already taken, search for another one');
                        } else {
                          appConstants.userModel.usaEmail = email;
                          String emailDomain = email.split('@').last;
                          String domainExtension = emailDomain.split('.').last;
                          List<String> validExtensions = [
                            'com',
                            'net',
                            'org',
                            'edu',
                            'gov'
                          ];
                          // add more extensions as needed
                          if (!validExtensions.contains(domainExtension)) {
                            // if(mounted)
                            // appConstants.alreadyExistEmailErrorMessageUpdate('Enter a valid email address');
                            appConstants.alreadyExistEmailErrorMessageUpdate(
                                'Enter Valid Domain');
                            return 'Enter a valid email address';
                          }

                          appConstants.alreadyExistEmailErrorMessageUpdate('');
                        }
                      }
                      // else{
                      //   appConstants.alreadyExistEmailErrorMessageUpdate('');
                      // }
                    },
                  ),
                  spacing_large,
                ],
              ),
              // Text(
              //   'My phone number is:',
              //   style: heading1TextStyle(context, width),
              // ),
              // TextFormField(
              //             autovalidateMode: AutovalidateMode.onUserInteraction,
              //             inputFormatters: [
              //               // CardFormatter(sample: "XXX-XXX-XXX", separator: "-")
              //               maskFormatter
              //             ],
              //             // validator: phoneNumberValidation,
              //             readOnly: true,
              //             // style: TextStyle(color: primaryColor),
              //             style: heading3TextStyle(width, color: grey),
              //             controller: phoneNumberController,
              //             obscureText: false,
              //             keyboardType: TextInputType.phone,
              //             maxLines: 1,
              //             decoration: InputDecoration(
              //               hintText: 'Enter Phone Number',
              //               isDense: true,
              //               hintStyle: heading3TextStyle(width, color: grey),
              //               contentPadding: const EdgeInsets.only(top: 18),
              //               prefixIcon: CountryCodePicker(
              //                 onChanged: print,
              //                 enabled: false,
              //                 textStyle: heading3TextStyle(width, color: grey),
              //                 // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
              //                 initialSelection: 'US',
              //                 // favorite: ['+39','FR'],
              //                 // optional. Shows only country name and flag
              //                 showCountryOnly: false,
              //                 showFlag: false,
              //                 countryFilter: const ['US'],
              //                 // optional. Shows only country name and flag when popup is closed.
              //                 showOnlyCountryWhenClosed: false,
              //                 // optional. aligns the flag and the Text left
              //                 alignLeft: false,
              //               ),
              //             ),
              //           ),
              // spacing_large,
              Text(
                'I would like my username to be:',
                style: heading1TextStyle(context, width),
              ),
              CustomHeaders(
                hintText: 'username',
                controller: userNameController,
                maxLength: 10,
                validationMode: AutovalidateMode.disabled,
                error: appConstants.alreadyExistUserNameErrorMessage,
                leadingIcon: Icon(
                  FontAwesomeIcons.at,
                  size: width * 0.04,
                  color: grey,
                ),
                validator: (String? name) {
                  if (name!.isEmpty) {
                    return 'Enter a username';
                  } else {
                    return null;
                  }
                },
                onChange: (String username) async {
                  appConstants.updateUserName(username);
                  appConstants.userModel.usaUserName = username;
                  if (username.isNotEmpty) {
                    bool? isUserNameExist = await services.checkUserNameExist(
                        userName: userNameController.text);
                    if (isUserNameExist!) {
                      appConstants.alreadyExistUserNameErrorMessageUpdate(
                          'This username is already taken, search for another one');
                    } else {
                      appConstants.alreadyExistUserNameErrorMessageUpdate('');
                    }
                  }
                },
              ),
              spacing_medium
            ],
          ),
        ),
      ),
    );
  }
}
