// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ndialog/ndialog.dart';
import 'package:provider/provider.dart';
import 'package:zaki/Constants/AuthMethods.dart';
import 'package:zaki/Constants/CheckInternetConnections.dart';
import 'package:zaki/Constants/NotificationTitle.dart';
import 'package:zaki/Constants/Spacing.dart';
import 'package:zaki/Screens/HomeScreen.dart';
import 'package:zaki/Services/CreaditCardApis.dart';
import 'package:zaki/Services/api.dart';
import 'package:zaki/Widgets/CustomLoadingScreen.dart';
import 'package:zaki/Widgets/TermsAndConditions.dart';
import 'package:zaki/Widgets/ZakiPrimaryButton.dart';
import '../Constants/AppConstants.dart';
import '../Constants/HelperFunctions.dart';
import '../Constants/IntialSetup.dart';
import '../Constants/Styles.dart';
import '../Services/SharedPrefMnager.dart';
import '../Widgets/AppBars/AppBar.dart';
import '../Widgets/TextHeader.dart';

enum SignUpVia { number, pinCode }

class AddFamilyMember extends StatefulWidget {
  const AddFamilyMember({Key? key}) : super(key: key);

  @override
  State<AddFamilyMember> createState() => _AddFamilyMemberState();
}

class _AddFamilyMemberState extends State<AddFamilyMember> {
  late SignUpVia? signUpThrough = SignUpVia.number;
  final formGlobalKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneOrEmailNameController = TextEditingController();
  final stateController = TextEditingController();
  final ssnController = TextEditingController();
  final zipCodeController = TextEditingController();
  final streetAddressController = TextEditingController();
  final appartOrSuitController = TextEditingController();
  final cityController = TextEditingController();
  bool underAgeLockedCardStatus = false;
  bool _obscureText = true;
  DateTime now = DateTime.now();
  late DateTime firstDate;
  late DateTime lastDate;

  String alreadyExist = '';
  var roleList = [
    'Husband',
    'Wife',
    'Son',
    'Daughter',
    'An Adult',
    'A Kid',
  ];
  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    phoneOrEmailNameController.dispose();
    zipCodeController.dispose();
    stateController.dispose();
    super.dispose();
  }

  void clearFields() {
    firstNameController.text = '';
    lastNameController.text = '';
    phoneOrEmailNameController.text = '';
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setScreenName(name: AppConstants.ADD_FAMILY_MEMBER);
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      var appConstants = Provider.of<AppConstants>(context, listen: false);
        
      appConstants.updateDateOfBirth('dd / mm / yyyy');
      bool screenNotOpen =
          await checkUserSubscriptionValue(appConstants, context);
      logMethod(title: 'Data from Pay+', message: screenNotOpen.toString());
      if (screenNotOpen == true) {
        Navigator.pop(context);
      } else {
        cityController.text = appConstants.userModel.usaCity ?? '';
        stateController.text = appConstants.userModel.userState ?? 'no state';
        // zipCodeController.text = appConstants.userModel.zipCode??'';
        appConstants.updateIssueDebitCardCheckBox(true);
        appConstants.updateRegistrationCheckBox(false);
        appConstants.updateSignUpRole(AppConstants.USER_TYPE_KID);
        appConstants.updateKidSignUpRole('Son');
        appConstants.updateGenderType('Male');
        firstDate = DateTime(now.year - 30, now.month, now.day);
        lastDate = DateTime(now.year - 8, now.month, now.day);
        setState(() {});
      }
    });
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
              padding: getCustomPadding(),
              child: Column(
                children: [
                  appBarHeader_005( 
                      context: context,
                      appBarTitle: 'Setup Wallet & Card',
                      backArrow: false,
                      height: height,
                      width: width,
                      leadingIcon: true),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      spacing_medium,
                      Text(
                        'Family Member Info:',
                        style: heading1TextStyle(context, width, color: green),
                      ),
                      spacing_medium,
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (String? name) {
                          if (name!.isEmpty) {
                            return 'Enter Name';
                          } else {
                            return null;
                          }
                        },
                        // style: TextStyle(color: primaryColor),
                        style: heading3TextStyle(width, color: grey),
                        controller: firstNameController,
                        obscureText: false,
                        keyboardType: TextInputType.name,
                        maxLines: 1,
                        maxLength: 15,
                        onChanged: (String username) {},
                        decoration: InputDecoration(
                          border: circularOutLineBorder,
                          enabledBorder: circularOutLineBorder,
                          counterText: "",
                          isDense: true,
                          hintText: 'Legal First Name',
                          hintStyle: heading3TextStyle(width, color: grey),
                        ),
                      ),
                      spacing_medium,
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (String? name) {
                          if (name!.isEmpty) {
                            return 'Enter Last Name';
                          } else {
                            return null;
                          }
                        },
                        // style: TextStyle(color: primaryColor),
                        style: heading3TextStyle(width, color: grey),
                        controller: lastNameController,
                        obscureText: false,
                        keyboardType: TextInputType.name,
                        maxLines: 1,
                        maxLength: 15,
                        onChanged: (String username) {},
                        decoration: InputDecoration(
                          border: circularOutLineBorder,
                          enabledBorder: circularOutLineBorder,
                          counterText: '',
                          hintText: 'Legal Last Name',
                          isDense: true,
                          hintStyle: heading3TextStyle(width, color: grey),
                        ),
                      ),
                      spacing_medium,
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: grey.withOpacity(0.4))),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                              // borderRadius: BorderRadius.circular(12),
                              isExpanded: true,
                              hint: Text('Relationship',
                                  style: heading3TextStyle(width, color: grey)),
                              // Initial Value
                              value: appConstants.kidSignUpRole,
                              style: heading3TextStyle(width, color: grey),
                              // underline: SizedBox(),
                              // Down Arrow Icon
                              icon: Icon(
                                Icons.keyboard_arrow_down,
                                color: grey,
                              ),

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
                                appConstants.updateKidSignUpRole(value!);
                                // 'Husband',
                                //   'Wife',
                                //   'Son',
                                //   'Daughter',
                                //   'An Adult',
                                //   'A Kid',
                                if (value == 'Dad' || value == 'Husband') {
                                  appConstants.updateSignUpRole(
                                      AppConstants.USER_TYPE_PARENT);
                                  appConstants.updateGenderType('Male');
                                } else if (value == 'Mom' || value == 'Wife') {
                                  appConstants.updateSignUpRole(
                                      AppConstants.USER_TYPE_PARENT);
                                  appConstants.updateGenderType('Female');
                                } else if (value == 'Son') {
                                  appConstants.updateSignUpRole(
                                      AppConstants.USER_TYPE_KID);
                                  appConstants.updateGenderType('Male');
                                } else if (value == 'Daughter') {
                                  appConstants.updateSignUpRole(
                                      AppConstants.USER_TYPE_KID);
                                  appConstants.updateGenderType('Female');
                                } else if (value == 'An Adult') {
                                  appConstants.updateSignUpRole(
                                      AppConstants.USER_TYPE_SINGLE);
                                  appConstants
                                      .updateGenderType('Rather not specify');
                                } else if (value == 'A Kid') {
                                  appConstants.updateSignUpRole(
                                      AppConstants.USER_TYPE_KID);
                                  appConstants
                                      .updateGenderType('Rather not specify');
                                }
                                // if(appConstants.signUpRole==AppConstants.USER_TYPE_PARENT){
                                appConstants.updateIssueDebitCardCheckBox(true);
                                appConstants
                                    .updateDateOfBirth('dd / mm / yyyy');
                                // }
                                if (appConstants.signUpRole ==
                                        AppConstants.USER_TYPE_PARENT ||
                                    appConstants.signUpRole ==
                                        AppConstants.USER_TYPE_SINGLE) {
                                  firstDate = DateTime(
                                      now.year - 80, now.month, now.day);
                                  lastDate = DateTime(
                                      now.year - 18, now.month, now.day);
                                } else if (appConstants.signUpRole ==
                                    AppConstants.USER_TYPE_KID) {
                                  firstDate = DateTime(
                                      now.year - 30, now.month, now.day);
                                  lastDate = DateTime(
                                      now.year - 8, now.month, now.day);
                                } else {
                                  // For 'single' or any other types, define your logic here
                                  firstDate = DateTime(
                                      now.year - 80, now.month, now.day);
                                  lastDate =
                                      DateTime.now(); // or any other end date
                                }
                                setState(() {});

                                showNotification(
                                    error: 0,
                                    icon: Icons.check,
                                    message:
                                        'USERTYPE: ${appConstants.signUpRole} and GENDER: ${appConstants.genderType} and image Url is:${getKidImage(gender: appConstants.genderType, imageUrl: '', userType: appConstants.signUpRole)}');
                              },
                            ),
                          ),
                        ),
                      ),
                      // Divider(
                      //   color: black,
                      //   height: 0.3,
                      // ),
                      spacing_medium,
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: grey.withOpacity(0.4))),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: ListTile(
                            dense: true,
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
                                  // initialDate: DateTime.now().subtract(Duration(
                                  //     days: (appConstants.signUpRole ==
                                  //                 AppConstants.USER_TYPE_KID
                                  //             ? 30
                                  //             : 80) *
                                  //         365)),
                                  // firstDate: DateTime.now().subtract(Duration(
                                  //     days: (appConstants.signUpRole ==
                                  //                 AppConstants.USER_TYPE_KID
                                  //             ? 30
                                  //             : 80) *
                                  //         365)),
                                  // lastDate:  DateTime.now().subtract(Duration(
                                  //     days: (appConstants.signUpRole ==
                                  //                 AppConstants.USER_TYPE_KID
                                  //             ? 30
                                  //             : 80) *
                                  //         365)),
                                  // selectableDayPredicate: (date) => date.isBefore(
                                  //     DateTime.now().subtract(
                                  //         Duration(days: (appConstants.signUpRole == AppConstants.USER_TYPE_KID ? 8 : 18) * 365)
                                  //         )
                                  // ),

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
                                ////1): Parent and single age shouldl nor be less than 16
                                if ((appConstants.signUpRole ==
                                            AppConstants.USER_TYPE_PARENT ||
                                        appConstants.signUpRole ==
                                            AppConstants.USER_TYPE_SINGLE) &&
                                    calculateAge(birthDate: dateTime) < 18) {
                                  showNotification(
                                      error: 1,
                                      icon: Icons.date_range,
                                      message:
                                          NotificationText.AGE_LESS_THAN_18);
                                  return;
                                }
                                ////3): Age should be between 13 to 30 for kids
                                if (appConstants.signUpRole ==
                                        AppConstants.USER_TYPE_KID &&
                                    (calculateAge(birthDate: dateTime) < 8 ||
                                        calculateAge(birthDate: dateTime) >
                                            30)) {
                                  showNotification(
                                      error: 1,
                                      icon: Icons.date_range,
                                      message: NotificationText.AGE_13_TO_30);
                                  return;
                                }
                                ////2): If age is less then 13 card will not be assigned
                                if (calculateAge(birthDate: dateTime) < 13) {
                                  showNotification(
                                      error: 1,
                                      icon: Icons.credit_card_off,
                                      message: NotificationText
                                          .UNDER_AGE_CARD_NOT_ASSIGNED);
                                  setState(() {
                                    appConstants
                                        .updateIssueDebitCardCheckBox(false);
                                    underAgeLockedCardStatus = true;
                                  });
                                  // return;
                                } else {
                                  setState(() {
                                    appConstants
                                        .updateIssueDebitCardCheckBox(true);
                                    underAgeLockedCardStatus = false;
                                  });
                                }
                                appConstants.updateDateOfBirth(
                                    '${dateTime.day} / ${dateTime.month} / ${dateTime.year}');
                              }
                            },
                            contentPadding: EdgeInsets.symmetric(horizontal: 3),
                            title: Text(
                              appConstants.dateOfBirth,
                              overflow: TextOverflow.clip,
                              style: heading3TextStyle(width, color: grey),
                            ),
                            trailing: Icon(
                              Icons.calendar_today_rounded,
                              color: grey,
                            ),
                          ),
                        ),
                      ),
                      // Divider(
                      //   color: black,
                      //   height: 0.3,
                      // ),
                      spacing_medium,
                      Text(
                        'Gouvernment ID:',
                        style: heading1TextStyle(context, width, color: green),
                      ),
                      spacing_medium,
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        maxLength: 15,
                        obscureText: _obscureText,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          ssnMaskFormatter
                        ],
                        validator: (String? state) {
                          // return null;
                          if (state!.isEmpty) {
                            return 'Enter Security Number';
                          } else if (state.length < 11) {
                            return 'Enter Full National ID / Iqama ID';
                          } else {
                            return null;
                          }
                        },
                        // obscureText: true,
                        decoration: InputDecoration(
                            counterText: '',
                            isDense: true,
                            border: circularOutLineBorder,
                            enabledBorder: circularOutLineBorder,
                            hintText: 'National ID / Iqama ID',
                            hintStyle: heading3TextStyle(width, color: grey),
                            suffixIconColor: grey,
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 12),
                            suffixIcon: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      _obscureText = !_obscureText;
                                    });
                                  },
                                  child: Icon(_obscureText
                                      ? Icons.visibility
                                      : Icons.visibility_off)),
                            )),
                        style: heading3TextStyle(width, color: grey),
                        controller: ssnController,
                        // obscureText: appConstants.passwordVissibleRegistration,
                        keyboardType: TextInputType.number,
                      ),
                      spacing_large,
                      Text(
                        'Home Address:',
                        style: heading1TextStyle(context, width, color: green),
                      ),
                      spacing_medium,
                      //  TextHeader1(title: 'Street Address'),
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        // readOnly:   true: false,
                        enabled: true,
                        validator: (String? name) {
                          if (name!.isEmpty) {
                            return 'Enter a Street Address';
                          } else {
                            return null;
                          }
                        },
                        // style: TextStyle(color: primaryColor),
                        style: heading3TextStyle(width, color: grey),
                        controller: streetAddressController,
                        obscureText: false,
                        keyboardType: TextInputType.streetAddress,
                        maxLines: 1,
                        maxLength: 40,
                        decoration: InputDecoration(
                          hintText: 'Street Address',
                          isDense: true,
                          border: circularOutLineBorder,
                          enabledBorder: circularOutLineBorder,
                          counterText: '',
                          hintStyle: heading3TextStyle(width, color: grey),
                        ),
                      ),
                      spacing_medium,
                      // TextHeader1(title: 'Apartment or Suite (Optional)'),
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        // readOnly:   true: false,
                        enabled: true,
                        // validator: (String? name) {
                        // if (name!.isEmpty) {
                        //   return 'Enter a Street Adress';
                        // } else {
                        // return null;
                        // }
                        // },
                        // style: TextStyle(color: primaryColor),
                        style: heading3TextStyle(width, color: grey),
                        controller: appartOrSuitController,
                        obscureText: false,
                        keyboardType: TextInputType.name,
                        maxLines: 1,
                        maxLength: 40,
                        decoration: InputDecoration(
                          hintText: 'Apartment or Suite (Optional)',
                          isDense: true,
                          counterText: '',
                          border: circularOutLineBorder,
                          enabledBorder: circularOutLineBorder,
                          hintStyle: heading3TextStyle(width, color: grey),
                        ),
                      ),
                      spacing_medium,

                      // TextHeader1(title: 'City'),
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        // readOnly:   true: false,
                        enabled: true,
                        validator: (String? name) {
                          if (name!.isEmpty) {
                            return 'Enter a City Name';
                          } else {
                            return null;
                          }
                        },
                        // style: TextStyle(color: primaryColor),
                        style: heading3TextStyle(width, color: grey),
                        controller: cityController,
                        obscureText: false,
                        keyboardType: TextInputType.name,
                        maxLines: 1,
                        maxLength: 30,
                        decoration: InputDecoration(
                          hintText: 'City',
                          isDense: true,
                          counterText: '',
                          border: circularOutLineBorder,
                          enabledBorder: circularOutLineBorder,
                          hintStyle: heading3TextStyle(width, color: grey),
                        ),
                      ),
                      spacing_medium,
                      // Row(
                      //   children: [
                      //     // Expanded(
                      //     //   child: TextFormField(
                      //     //     autovalidateMode:
                      //     //         AutovalidateMode.onUserInteraction,
                      //     //     maxLength: 5,
                      //     //     // inputFormatters: [
                      //     //     //   FilteringTextInputFormatter.digitsOnly
                      //     //     // ],
                      //     //     validator: (String? state) {
                      //     //       // return null;

                      //     //       if (state!.isEmpty) {
                      //     //         return 'Enter state';
                      //     //       } else {
                      //     //         return null;
                      //     //       } 
                      //     //     },
                      //     //     // obscureText: true,
                      //     //     onTap: () async {
                      //     //       // String data =
                      //     //       await showDialog(
                      //     //         context: context,
                      //     //         builder: (BuildContext context) {
                      //     //           return SelectCounteryState(
                      //     //             listItems: USStates.getAllNames(),
                      //     //           );
                      //     //         },
                      //     //       );
                      //     //       stateController.text =
                      //     //           appConstants.selectedCountrySate;
                      //     //     },
                      //     //     // enabled: false,
                      //     //     enableInteractiveSelection: false,
                      //     //     readOnly: true,
                      //     //     decoration: InputDecoration(
                      //     //         counterText: '',
                      //     //         isDense: true,
                      //     //         border: circularOutLineBorder,
                      //     //         enabledBorder: circularOutLineBorder,
                      //     //         hintText: 'State',
                      //     //         hintStyle:
                      //     //             heading3TextStyle(width, color: grey),
                      //     //         contentPadding:
                      //     //             EdgeInsets.symmetric(horizontal: 12),
                      //     //         suffixIcon: StateSuffixIcon()),
                      //     //     style: heading3TextStyle(width, color: grey),
                      //     //     controller: stateController,
                      //     //     // obscureText: appConstants.passwordVissibleRegistration,
                      //     //     keyboardType: TextInputType.name,
                      //     //   ),
                      //     // ),
                      //     // SizedBox(
                      //     //   width: 10,
                      //     // ),
                      //   ],
                      // ),
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        maxLength: 5,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        validator: (String? zipCode) {
                          // return null;

                          if (zipCode!.isEmpty) {
                            return 'Enter ZipCode';
                          } else if (zipCode.length < 5) {
                            return 'Enter Full ZipCode';
                          } else {
                            return null;
                          }
                        },
                        // obscureText: true,
                        decoration: InputDecoration(
                          counterText: '',
                          isDense: true,
                          border: circularOutLineBorder,
                          enabledBorder: circularOutLineBorder,
                          hintText: 'Zip Code',
                          hintStyle: heading3TextStyle(width, color: grey),
                        ),
                        style: heading3TextStyle(width, color: grey),
                        controller: zipCodeController,
                        // obscureText: appConstants.passwordVissibleRegistration,
                        keyboardType: TextInputType.number,
                      ),

                      spacing_medium,
                      Row(
                        children: [
                          Text(
                            'Setup access via: ',
                            style:
                                heading1TextStyle(context, width, color: green),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Icon(
                            Icons.info_outline,
                            color: grey,
                            size: width * 0.045,
                          )
                        ],
                      ),
                      spacing_small,
                      Row(
                        children: [
                          Radio(
                              activeColor: green,
                              value: SignUpVia.number,
                              visualDensity: VisualDensity.compact,
                              groupValue: signUpThrough,
                              onChanged: (SignUpVia? caha) {
                                setState(() {
                                  signUpThrough = caha;
                                });
                              }),
                          Text(
                            'Their Phone Number',
                            style: heading4TextSmall(width, color: grey),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Radio(
                              activeColor: green,
                              visualDensity: VisualDensity.compact,
                              value: SignUpVia.pinCode,
                              groupValue: signUpThrough,
                              onChanged: (SignUpVia? caha) {
                                setState(() {
                                  signUpThrough = caha;
                                });
                              }),
                          Text(
                            'My Account',
                            style: heading4TextSmall(width, color: grey),
                          ),
                        ],
                      ),
                      spacing_medium,
                      signUpThrough!.index == 0
                          ? TextFormField(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              inputFormatters: [
                                // CardFormatter(sample: "XXX-XXX-XXX", separator: "-")
                                // maskFormatter
                                appConstants.selectedCountry ==
                                        AppConstants.COUNTRY_SAUDIA
                                    ? saudiaMaskFormatter
                                    : qatarMaskFormatter
                              ],
                              validator: signUpThrough!.index == 0
                                  ? (number) {
                                      if (number!.isEmpty) {
                                        return 'Enter a Number';
                                      } else if ((number.length <
                                          (appConstants.selectedCountry ==
                                                  AppConstants.COUNTRY_SAUDIA
                                              ? 11
                                              : 10))) {
                                        return 'Enter Full Mobile Number';
                                      }
                                      return null;
                                    }
                                  : null,
                              // style: TextStyle(color: primaryColor),
                              style: heading3TextStyle(width, color: grey),
                              controller: phoneOrEmailNameController,
                              obscureText: false,
                              keyboardType: TextInputType.phone,
                              maxLines: 1,
                              onChanged: (String username) {
                                setState(() {
                                  alreadyExist = '';
                                });
                              },
                              decoration: InputDecoration(
                                hintText: 'Enter Phone Number',
                                isDense: true,
                                border: circularOutLineBorder,
                                enabledBorder: circularOutLineBorder,
                                errorText:
                                    alreadyExist == '' ? null : alreadyExist,
                                hintStyle:
                                    heading3TextStyle(width, color: grey),
                                contentPadding: const EdgeInsets.only(top: 18),
                                prefixIcon: customCountryPicker(
                                    appConstants, width,
                                    readOnly: true),
                              ),
                            )
                          : Text(
                              'They can assign their own PIN Code when they login.',
                              style: heading3TextStyle(width, color: grey),
                            ),
                      spacing_medium,
                      Row(
                        children: [
                          Checkbox(
                              visualDensity: VisualDensity.compact,
                              activeColor: green,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(3)),
                              value: appConstants.issueDebitCardCheckBox,
                              onChanged: appConstants.signUpRole !=
                                      AppConstants.USER_TYPE_PARENT
                                  ? null
                                  : (value) {
                                      appConstants
                                          .updateIssueDebitCardCheckBox(value);
                                    }),
                          TextValue3(
                            title: 'Issue a debit card',
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Checkbox(
                              visualDensity: VisualDensity.compact,
                              activeColor: grey,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(3)),
                              value: appConstants.registrationCheckBox,
                              onChanged: (value) {
                                appConstants.updateRegistrationCheckBox(value);
                              }),
                          // Expanded(
                          //   child: Text(
                          //     'I agree to ZakiPay’s Terms & Conditions, Cardholder Agreement & Privacy Policy.',
                          //     style: heading4TextSmall(width, underline: true),
                          //     textAlign: TextAlign.start,
                          //     maxLines: 2,
                          //   ),
                          // ),
                          TermsAndConditions(width: width)
                        ],
                        // Text(
                        //   'Terms & Conditions, ',
                        //   style: heading4TextSmall(width, underline: true),
                        // ),
                        // Text(
                        //   'Cardholder Agreement & Privacy Policy. ',
                        //   style: heading4TextSmall(width, underline: true),
                        // ),
                        // Text(
                        //   '& ',
                        //   style: heading4TextSmall(width),

                        // ),
                        // Text(
                        //   'Privacy Policy.',
                        //   style: heading4TextSmall(width, underline: true),
                        // ),
                      ),
                      spacing_medium,
                      ZakiPrimaryButton(
                          width: width,
                          title: 'Setup',
                          onPressed: (internet.status ==
                                      AppConstants
                                          .INTERNET_STATUS_NOT_CONNECTED ||
                                  (signUpThrough!.index == 0 &&
                                      phoneOrEmailNameController.text.length <
                                          (appConstants.selectedCountry ==
                                                  AppConstants.COUNTRY_SAUDIA
                                              ? 11
                                              : 10)) ||
                                  (appConstants.registrationCheckBox == false ||
                                      firstNameController.text.isEmpty ||
                                      lastNameController.text.isEmpty ||
                                      cityController.text.isEmpty ||
                                      stateController.text.length < 5 ||
                                      ssnController.text.length < 4) ||
                                  firstNameController.text.isEmpty ||
                                  lastNameController.text.isEmpty ||
                                  appConstants.dateOfBirth == 'dd / mm / yyyy')
                              ? null
                              : () async {
                                  bool? checkAuth =
                                      await authenticateTransactionUsingBioOrPinCode(
                                          appConstants: appConstants,
                                          context: context);
                                  if (checkAuth == false) {
                                    return;
                                  }
                                  ApiServices services = ApiServices();
                                  // if (signUpThrough!.index == 0) {
                                  if (!formGlobalKey.currentState!.validate()) {
                                    return;
                                  }
                                  if (signUpThrough!.index == 0) {
                                    bool userExist = await services.isUserExist(
                                        // context: context,
                                        number:
                                            '${appConstants.selectedCountryDialCode}${getPhoneNumber(number: phoneOrEmailNameController.text)}');
                                    if (userExist) {
                                      setState(() {
                                        alreadyExist =
                                            'Seems like this number is already registered, either Log In or try a different number.';
                                      });
                                      return;
                                    }
                                  }
                                  // else {
                                  List mobileDevices = [
                                    await services.getDeviceId()
                                  ];
                                  CustomProgressDialog progressDialog =
                                      CustomProgressDialog(context, blur: 6);
                                  progressDialog
                                      .setLoadingWidget(CustomLoadingScreen());
                                  progressDialog.show();

                                  CreaditCardApi creaditCardApi =
                                      CreaditCardApi();

                                  UserPreferences userPref = UserPreferences();
                                  String? newAddedUserId =
                                      await services.newUserPhoneVerification(
                                          seeKids: ((appConstants.signUpRole ==
                                                      'Parent') ||
                                                  (appConstants.signUpRole ==
                                                      'Single'))
                                              ? true
                                              : false,
                                          deviceId: mobileDevices,
                                          ///If already added parent id then show that otherwise add like this
                                          parentId: (appConstants.userModel.userFamilyId!=null && appConstants.userModel.userFamilyId!='')? appConstants.userModel.userFamilyId 
                                          // : (appConstants
                                          //             .userModel.usaUserType ==
                                          //         AppConstants.USER_TYPE_PARENT)
                                          //     ? 
                                          //     appConstants
                                          //         .userModel.userFamilyId
                                              : await userPref
                                                  .getCurrentUserId(),
                                          email: '',
                                          zipCode:
                                              appConstants.userModel.zipCode,
                                          firstName: firstNameController.text,
                                          lastName: lastNameController.text,
                                          firstLegalName:
                                              firstNameController.text,
                                          lastLegalName:
                                              lastNameController.text,
                                          password: '',
                                          status: appConstants.signUpRole,
                                          // status: (appConstants.signUpRole=="Son" || appConstants.signUpRole=="Daughter")? "Kid": appConstants.signUpRole,
                                          // gender: (appConstants.signUpRole == "Mom" || appConstants.signUpRole == "Single Female" || appConstants.signUpRole == "Daughter")
                                          //     ? "Female"
                                          //     : "Male",
                                          gender: appConstants.genderType,
                                          city: '',
                                          country: appConstants.selectedCountry,
                                          currency: appConstants
                                              .userModel.usaCurrency,
                                          dob: appConstants.dateOfBirth,
                                          isEmailVerified: false,
                                          latLng: '',
                                          locationStatus: true,
                                          method: appConstants.signUpMethod,
                                          notificationStatus: true,
                                          phoneNumber:
                                              '${appConstants.selectedCountryDialCode}${getPhoneNumber(number: phoneOrEmailNameController.text.trim())}',
                                          pinCode: "",
                                          pinEnabled: signUpThrough!.index == 0
                                              ? false
                                              : true,
                                          pinLength: appConstants.pinLength,
                                          userName: '',
                                          touchEnable:
                                              appConstants.isTouchEnable,
                                          isEnabled: false,
                                          kidEnabled: true,
                                          isPinUser:
                                              signUpThrough!.index == 0 ? false : true,
                                          userStatus: false,
                                          userFullyRegistred: false,);
                                  // newAddedUserId
                                  //A new User Added So Persolzation setting should be added
                                  //And user type Kid
                                  if (appConstants.signUpMethod ==
                                      AppConstants.USER_TYPE_KID) {
                                    await services.addUserPersonalization(
                                        userId: newAddedUserId,
                                        kidsToPayFriends: true,
                                        kidsToPublish: true,
                                        lockCharity: true,
                                        lockSaving: true,
                                        pendingApprovales:
                                            appConstants.pendingApprovales,
                                        slideToPay: true,
                                        parentId: appConstants.userRegisteredId,
                                        disableToDo: true);
                                  }
                                  await services.addFriendsAutumatically(
                                      signedUpStatus: false,
                                      isFavorite: true,
                                      requestReceiverrId: newAddedUserId,
                                      currentUserId:
                                          appConstants.userRegisteredId,
                                      number:
                                          '${appConstants.selectedCountryDialCode}${getPhoneNumber(number: phoneOrEmailNameController.text)}',
                                      requestReceiverName:
                                          '${firstNameController.text.trim()} ${lastNameController.text.trim()}',
                                      requestSenderName:
                                          '${appConstants.userModel.usaFirstName} ${appConstants.userModel.usaLastName}',
                                      requestSenderPhoneNumber: appConstants
                                          .userModel.usaPhoneNumber);
                                  /////////Add Friends Automatically for other family members
                                  await ApiServices().fetchUserKids1(
                                    appConstants.userModel.seeKids == true
                                        ? appConstants.userModel.userFamilyId!
                                        : appConstants.userRegisteredId,
                                    currentUserId:
                                        appConstants.userRegisteredId,
                                    newlyAddedUserId: newAddedUserId,
                                    newAddedUserFirstName:
                                        firstNameController.text.trim(),
                                    newAddedUserLasttName:
                                        lastNameController.text.trim(),
                                    newAddedUserPhoneNumber:
                                        phoneOrEmailNameController.text.trim(),
                                  );

                                  String? userToken =
                                      await creaditCardApi.createUserForCard(
                                          gender: 'M',
                                          city: cityController.text.trim(),
                                          country: 'US',
                                          // email: emailAddressController.text.trim(),
                                          firstName: firstNameController.text,
                                          lastName: lastNameController.text,
                                          password: '',
                                          address1: streetAddressController.text
                                              .trim(),
                                          phoneNumber: appConstants
                                              .userModel.usaPhoneNumber,
                                          postalCode:
                                              zipCodeController.text.trim(),
                                          state: stateController.text,
                                          useParentAccount: false
                                          // useParentAccount: widget.selectedUserId==appConstants.userRegisteredId?false:true
                                          );
                                  if (userToken != null) {
                                    await services.addUserTokenBankApi(
                                        newAddedUserId.toString(), userToken,
                                        value: 2);
                                    // checkUserEqual(appConstants) ? appConstants.userRegisteredId : appConstants.currentUserIdForBottomSheet, userToken);
                                    if (appConstants.issueDebitCardCheckBox ==
                                        true) {
                                      String? cardProductToken =
                                          await creaditCardApi
                                              .createCardProduct(
                                                  city: cityController.text
                                                      .trim(),
                                                  country: 'US',
                                                  firstName:
                                                      firstNameController.text,
                                                  lastName:
                                                      lastNameController.text,
                                                  address1:
                                                      streetAddressController
                                                          .text
                                                          .trim(),
                                                  phoneNumber: appConstants
                                                      .userModel.usaPhoneNumber,
                                                  postalCode: zipCodeController
                                                      .text
                                                      .trim(),
                                                  state: stateController.text,
                                                  userToken: userToken);
                                      if (cardProductToken != null) {
                                        String? cardToken =
                                            await creaditCardApi.card(
                                                userToken: userToken,
                                                cardProductToken:
                                                    cardProductToken);
                                        ApiServices services = ApiServices();
                                        // logMethod(title: 'Id is: ', message: selectedUserId);
                                        await services.issueCard(
                                            parentId:
                                                appConstants.userRegisteredId,
                                            dateOfBirth:
                                                appConstants.dateOfBirth,
                                            firstName: firstNameController.text,
                                            lastName: lastNameController.text,
                                            phoneNumber: '',
                                            userId: newAddedUserId,
                                            apartmentOrSuit:
                                                appartOrSuitController.text
                                                    .trim(),
                                            city: cityController.text.trim(),
                                            ssnNumber: int.parse(getPhoneNumber(
                                                number:
                                                    ssnController.text.trim())),
                                            state: stateController.text.trim(),
                                            streetAddress:
                                                streetAddressController.text
                                                    .trim(),
                                            zipCode: int.parse(
                                                zipCodeController.text.trim()),
                                            cardToken: cardToken,
                                            userToken: userToken);
                                        await services.addUserTokenBankApi(
                                            newAddedUserId.toString(),
                                            userToken,
                                            value: 3);
                                      }
                                    }
                                  }

                                  //This
                                  if (appConstants.signUpRole ==
                                          AppConstants.USER_TYPE_SINGLE ||
                                      appConstants.signUpRole ==
                                          AppConstants.USER_TYPE_PARENT) {
                                  } else
                                    IntialSetup
                                        .addDefaultPersonalozationSettings(
                                            userId: newAddedUserId,
                                            parentId:
                                                appConstants.userRegisteredId);
                                  ///////////////Now we need to add Assign user a card if
                                  ///issue debit card is checked
                                  // services.newUserCreateDbDefault(gender: appConstants.genderType, parentId: appConstants.userRegisteredId, status: appConstants.signUpRole, userId: await userPref.getCurrentUserId());
                                  showNotification(
                                      error: 0,
                                      icon: Icons.check,
                                      message: NotificationText.USER_ADDED);
                                  await ApiServices().kidsLength(
                                      appConstants.userRegisteredId.toString(),
                                      context: context);
                                  // Navigator.pop(context, 'added');

                                  progressDialog.dismiss();
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => HomeScreen()));
                                  return;
                                  // }
                                  // } else {
                                  // if (!formGlobalKey.currentState!
                                  //     .validate()) {
                                  //   return;
                                  // }
                                  // appConstants.updateFirstName(
                                  //     firstNameController.text);
                                  // appConstants.updateLastName(
                                  //     lastNameController.text);
                                  // // var respose = await
                                  // Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (context) =>
                                  //             const PinCodeSetUp(
                                  //               fromKidsSignUpPage: 0,
                                  //             )));
                                  // if (respose == "Matched") {
                                  //   ApiServices service = ApiServices();
                                  //   List mobileDevices = [await service.getDeviceId()];
                                  //   UserPreferences userPref = UserPreferences();
                                  //   await service.addUserToDatabase(
                                  //       isPinUser: true,
                                  //       zipCode: '',
                                  //       deviceId: mobileDevices,
                                  //       parentId: await userPref.getCurrentUserId(),
                                  //       email: '',
                                  //       firstName: firstNameController.text,
                                  //       lastName: lastNameController.text,
                                  //       password: '',
                                  //       status: appConstants.signUpRole,
                                  //       city: '',
                                  //       country: appConstants.selectedCountry,
                                  //       currency: 'US',
                                  //       dob: appConstants.dateOfBirth,
                                  //       gender: appConstants.genderType,
                                  //       isEmailVerified: false,
                                  //       latLng: '',
                                  //       locationStatus: true,
                                  //       method: appConstants.signUpMethod,
                                  //       notificationStatus: true,
                                  //       phoneNumber: '',
                                  //       pinCode: appConstants.pin.toString(),
                                  //       pinEnabled: true,
                                  //       pinLength: appConstants.pinLength,
                                  //       userName: '',
                                  //       touchEnable: appConstants.isTouchEnable,
                                  //       isEnabled: false);
                                  //   showNotification(
                                  //       error: 0,
                                  //       icon: Icons.check,
                                  //       message: 'Kid Added Successfully');
                                  //   Navigator.push(
                                  //       context,
                                  //       MaterialPageRoute(
                                  //         builder: (context) => ConfirmedScreen(
                                  //             name: firstNameController.text.toString()),
                                  //       ));
                                  // }
                                  // }
                                }),
                      spacing_medium
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
