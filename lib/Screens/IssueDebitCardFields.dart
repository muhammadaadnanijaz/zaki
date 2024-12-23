import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ndialog/ndialog.dart';
import 'package:provider/provider.dart';
import 'package:zaki/Constants/NotificationTitle.dart';
import 'package:zaki/Constants/Spacing.dart';
// import 'package:zaki/Models/CardModel.dart';
import 'package:zaki/Services/api.dart';
import 'package:zaki/Widgets/TextHeader.dart';

import '../Constants/AppConstants.dart';
import '../Constants/HelperFunctions.dart';
import '../Constants/Styles.dart';
import '../Services/CreaditCardApis.dart';
import '../Widgets/AppBars/AppBar.dart';
import '../Widgets/CustomLoadingScreen.dart';
import '../Widgets/ZakiPrimaryButton.dart';

class IssueDebitCardFields extends StatefulWidget {
  final String? selectedUserId;
  final String? firstName;
  final String? lastName;
  final String? dateOfBirth;
  final String? phoneNumber;
  const IssueDebitCardFields(
      {Key? key,
      this.selectedUserId,
      this.firstName,
      this.lastName,
      this.dateOfBirth,
      this.phoneNumber})
      : super(key: key);

  @override
  State<IssueDebitCardFields> createState() => _IssueDebitCardFieldsState();
}

class _IssueDebitCardFieldsState extends State<IssueDebitCardFields> {
  final formGlobalKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailAddressController = TextEditingController();
  final ssnController = TextEditingController();
  final zipCodeController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final streetAddressController = TextEditingController();
  final appartOrSuitController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    setSelectedUserData(
      dateOfBirth: widget.dateOfBirth ?? '',
      firstName: widget.firstName ?? '',
      lastName: widget.lastName ?? '',
      // phoneNumber: widget.phoneNumber
    );
  }

  void setSelectedUserData(
      {String? firstName,
      String? lastName,
      String? dateOfBirth,
      String? gouvernmentId,
      String? phoneNumber}) {
    // var appConstants = Provider.of<AppConstants>(context, listen: false);
    // appConstants.updateDateOfBirth(dateOfBirth!);
    firstNameController.text = firstName!;
    lastNameController.text = lastName!;
    // phoneNumberController.text = phoneNumber!;
  }

  @override
  Widget build(BuildContext context) {
    var appConstants = Provider.of<AppConstants>(context, listen: true);
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: getCustomPadding(),
            child: Form(
              key: formGlobalKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  appBarHeader_005(
                      context: context,
                      appBarTitle: 'Issue a Debit Card',
                      backArrow: false,
                      height: height,
                      width: width,
                      leadingIcon: true),
                  spacing_large,
                  TextHeader1(title: 'Legal First Name'),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    // readOnly:   true: false,
                    enabled: true,
                    validator: (String? name) {
                      if (name!.isEmpty) {
                        return 'Enter a Name';
                      } else {
                        return null;
                      }
                    },
                    // style: TextStyle(color: primaryColor),
                    style: heading2TextStyle(context, width),
                    controller: firstNameController,
                    obscureText: false,
                    keyboardType: TextInputType.name,
                    maxLines: 1,
                    maxLength: 15,
                    decoration: InputDecoration(
                      hintText: 'Legal First Name',
                      counterText: '',
                      hintStyle: heading2TextStyle(context, width),
                    ),
                  ),
                  // CustomSizedBox(height: height),
                  spacing_large,
                  TextHeader1(title: 'Legal Last Name'),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    enabled: true,
                    validator: (String? name) {
                      if (name!.isEmpty) {
                        return 'Enter Last Name';
                      } else {
                        return null;
                      }
                    },
                    // style: TextStyle(color: primaryColor),
                    style: heading2TextStyle(context, width),
                    controller: lastNameController,
                    obscureText: false,
                    keyboardType: TextInputType.name,
                    maxLines: 1,
                    maxLength: 15,
                    decoration: InputDecoration(
                      hintText: 'Legal Last Name',
                      counterText: '',
                      hintStyle: heading2TextStyle(context, width),
                    ),
                  ),
                  spacing_large,

                  TextHeader1(title: 'Street Address'),
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
                    style: heading2TextStyle(context, width),
                    controller: streetAddressController,
                    obscureText: false,
                    keyboardType: TextInputType.streetAddress,
                    maxLines: 1,
                    maxLength: 40,
                    decoration: InputDecoration(
                      hintText: 'Street Address',
                      counterText: '',
                      hintStyle: heading2TextStyle(context, width),
                    ),
                  ),
                  spacing_large,
                  TextHeader1(title: 'Apartment or Suite (Optional)'),
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
                    style: heading2TextStyle(context, width),
                    controller: appartOrSuitController,
                    obscureText: false,
                    keyboardType: TextInputType.name,
                    maxLines: 1,
                    maxLength: 40,
                    decoration: InputDecoration(
                      hintText: 'Apartment or Suite (Optional)',
                      counterText: '',
                      hintStyle: heading2TextStyle(context, width),
                    ),
                  ),
                  spacing_large,
                  TextHeader1(title: 'City'),
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
                    style: heading2TextStyle(context, width),
                    controller: cityController,
                    obscureText: false,
                    keyboardType: TextInputType.name,
                    maxLines: 1,
                    maxLength: 30,
                    decoration: InputDecoration(
                      hintText: 'City',
                      counterText: '',
                      hintStyle: heading2TextStyle(context, width),
                    ),
                  ),
                  spacing_large,
                  TextHeader1(title: 'State'),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    // readOnly:   true: false,
                    enabled: true,
                    validator: (String? name) {
                      if (name!.isEmpty) {
                        return 'Enter a State';
                      } else {
                        return null;
                      }
                    },
                    // style: TextStyle(color: primaryColor),
                    style: heading2TextStyle(context, width),
                    controller: stateController,
                    obscureText: false,
                    keyboardType: TextInputType.name,
                    maxLines: 1,
                    maxLength: 5,
                    decoration: InputDecoration(
                      counterText: "",
                      hintText: 'State',
                      hintStyle: heading2TextStyle(context, width),
                    ),
                  ),
                  spacing_large,
                  TextHeader1(title: 'Zip Code'),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    // readOnly:   true: false,
                    enabled: true,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (String? name) {
                      if (name!.isEmpty) {
                        return 'Enter a Zip Code';
                      } else {
                        return null;
                      }
                    },
                    // style: TextStyle(color: primaryColor),
                    style: heading2TextStyle(context, width),
                    controller: zipCodeController,
                    obscureText: false,
                    keyboardType: TextInputType.number,
                    maxLines: 1,
                    maxLength: 5,
                    decoration: InputDecoration(
                      hintText: 'Enter a Zip Code',
                      counterText: "",
                      hintStyle: heading2TextStyle(context, width),
                    ),
                  ),

                  spacing_large,
                  TextHeader1(title: 'Date Of Birth'),
                  ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    visualDensity: VisualDensity(horizontal: 0, vertical: -3),
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
                          initialEntryMode: DatePickerEntryMode.calendar);
                      if (dateTime != null) {
                        print('Selected date is: ${dateTime.day}');
                        appConstants.updateDateOfBirth(
                            '${dateTime.day} / ${dateTime.month} / ${dateTime.year}');
                      }
                    },
                    title: Text(appConstants.dateOfBirth,
                        overflow: TextOverflow.clip,
                        style: heading2TextStyle(context, width)),
                    trailing: const Icon(
                      Icons.calendar_today_rounded,
                      size: 20,
                    ),
                  ),
                  Divider(
                    color: black,
                    height: 0.6,
                  ),
                  spacing_large,
                  TextHeader1(title: 'Last 4 Digits of SSN'),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.disabled,
                    // readOnly:   true: false,
                    enabled: true,
                    validator: (String? name) {
                      if (name!.isEmpty) {
                        return 'Enter SSN';
                      } else if (name.length < 4) {
                        return 'Enter Full SSN';
                      }
                      return null;
                    },
                    // style: TextStyle(color: primaryColor),
                    style: heading2TextStyle(context, width),
                    controller: ssnController,
                    obscureText: true,
                    keyboardType: TextInputType.number,
                    maxLength: 4,
                    maxLines: 1,
                    decoration: InputDecoration(
                      counterText: "",
                      hintText: 'Enter last four digits of SSN',
                      hintStyle: heading2TextStyle(context, width),
                    ),
                  ),

                  spacing_large,
                  TextHeader1(title: 'Email'),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    enabled: true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your email address';
                      } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                          .hasMatch(value)) {
                        return 'Please enter a valid email address';
                      } else {
                        String emailDomain = value.split('@')[1];
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
                          return 'Enter a valid email address';
                        }
                      }
                      return null;
                    },
                    // style: TextStyle(color: primaryColor),
                    style: heading2TextStyle(context, width),
                    controller: emailAddressController,
                    obscureText: false,
                    keyboardType: TextInputType.emailAddress,
                    maxLines: 1,
                    decoration: InputDecoration(
                      hintText: 'Enter Email',
                      hintStyle: heading2TextStyle(context, width),
                    ),
                  ),
                  spacing_large,
                  TextHeader1(title: 'Contact Phone Number'),

                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    enabled: true,
                    inputFormatters: [
                      // CardFormatter(sample: "XXX-XXX-XXX", separator: "-")
                      maskFormatter
                    ],
                    // validator: phoneNumberValidation,

                    // style: TextStyle(color: primaryColor),
                    style: heading2TextStyle(context, width),
                    controller: phoneNumberController,
                    obscureText: false,
                    keyboardType: TextInputType.number,
                    maxLines: 1,
                    enableIMEPersonalizedLearning: true,
                    enableInteractiveSelection: true,
                    decoration: InputDecoration(
                      hintText: 'xxx-xxx-xxxx',
                      contentPadding: const EdgeInsets.only(top: 18),
                      hintStyle: heading2TextStyle(context, width),
                      prefixIcon: CountryCodePicker(
                        onChanged: print,
                        enabled: false,
                        // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                        initialSelection: 'US',
                        // favorite: ['+39','FR'],
                        // optional. Shows only country name and flag
                        showCountryOnly: false,
                        countryFilter: const ['US'],
                        // countryFilter: const ['PK', 'SA', 'US', 'JO'],
                        // optional. Shows only country name and flag when popup is closed.
                        showOnlyCountryWhenClosed: false,
                        // optional. aligns the flag and the Text left
                        alignLeft: false,
                      ),
                    ),
                  ),
                  spacing_small,
                  Row(
                    children: [
                      Checkbox(
                          activeColor: green,
                          shape: const CircleBorder(),
                          value: appConstants.registrationCheckBox,
                          onChanged: (value) {
                            appConstants.updateRegistrationCheckBox(value);
                          }),
                      TextValue3(
                        title: 'I read and approve bla bla bla',
                      )
                    ],
                  ),
                  spacing_large,
                  ZakiPrimaryButton(
                    title: 'Request a Debit Card',
                    width: width,
                    onPressed: (appConstants.registrationCheckBox == false ||
                            phoneNumberController.text.length < 12 ||
                            firstNameController.text.isEmpty ||
                            lastNameController.text.isEmpty ||
                            cityController.text.isEmpty ||
                            stateController.text.length < 5 ||
                            ssnController.text.length < 4)
                        ? null
                        : () async {
                            if (!formGlobalKey.currentState!.validate()) {
                              return;
                            }
                            // CustomProgressDialog progressDialog =
                            //     CustomProgressDialog(context, blur: 6);
                            // progressDialog
                            //     .setLoadingWidget(CustomLoadingScreen());
                            // progressDialog.show();

                            // CreaditCardApi creaditCardApi = CreaditCardApi();

                            // String? userToken = await ApiServices()
                            //     .getAccountNumberFromId(
                            //         userId: widget.selectedUserId);

                            // logMethod(
                            //     title: 'User Bank Id: ',
                            //     message: userToken.toString());
                            // //  return;
                            // if (userToken == null) {
                            //   showNotification(
                            //       error: 1,
                            //       icon: Icons.credit_card_off_outlined,
                            //       message: NotificationText.CARD_ASSIGN_ERROR);
                            //   progressDialog.dismiss();
                            //   return;
                            // }
                            // String? cardProductToken =
                            //     await creaditCardApi.createCardProduct(
                            //         city: cityController.text.trim(),
                            //         country: 'US',
                            //         firstName: firstNameController.text,
                            //         lastName: lastNameController.text,
                            //         address1:
                            //             streetAddressController.text.trim(),
                            //         phoneNumber:
                            //             appConstants.userModel.usaPhoneNumber,
                            //         postalCode: appConstants.userModel.zipCode,
                            //         state: stateController.text,
                            //         userToken: userToken);
                            // if (cardProductToken != null) {
                            //   String? cardToken = await creaditCardApi.card(
                            //       userToken: userToken,
                            //       cardProductToken: cardProductToken);
                            //   ApiServices services = ApiServices();
                            //   // logMethod(title: 'Id is: ', message: selectedUserId);
                            //   await services.issueCard(
                            //       parentId: appConstants.userRegisteredId,
                            //       dateOfBirth: appConstants.dateOfBirth,
                            //       firstName: firstNameController.text,
                            //       lastName: lastNameController.text,
                            //       phoneNumber: getPhoneNumber(
                            //           number: phoneNumberController.text),
                            //       userId: widget.selectedUserId,
                            //       apartmentOrSuit:
                            //           appartOrSuitController.text.trim(),
                            //       city: cityController.text.trim(),
                            //       ssnNumber:
                            //           int.parse(ssnController.text.trim()),
                            //       state: stateController.text.trim(),
                            //       streetAddress:
                            //           streetAddressController.text.trim(),
                            //       zipCode:
                            //           int.parse(zipCodeController.text.trim()),
                            //       cardToken: cardToken,
                            //       userToken: userToken,
                            //       );
                            //   await services.addUserTokenBankApi(
                            //       widget.selectedUserId.toString(), userToken,
                            //       value: 2);
                            //   await services.getUserTokenAndSendNotification(
                            //       userId: widget.selectedUserId,
                            //       title:
                            //           '${appConstants.userModel.usaUserName} ${NotificationText.REQUEST_NOTIFICATION_TITLE}',
                            //       subTitle:
                            //           '${NotificationText.REQUEST_NOTIFICATION_SUB_TITLE}');
                            //   showNotification(
                            //       error: 0,
                            //       icon: Icons.check,
                            //       message: NotificationText.CARD_ASSIGN);
                            //   Future.delayed(Duration(seconds: 6), () {
                            //     showNotification(
                            //         error: 0,
                            //         icon: Icons.credit_card_outlined,
                            //         message: NotificationText.USER_TOKEN +
                            //             ' $userToken');

                            //     Navigator.pop(context, "success");
                            //     Navigator.pop(context, "success");
                            //   });
                            // }

                            // progressDialog.dismiss();
                            //   return;
                          },
                  ),
                  spacing_medium
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
