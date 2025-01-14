import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ndialog/ndialog.dart';
import 'package:provider/provider.dart';
import 'package:zaki/Constants/Spacing.dart';
import 'package:zaki/Screens/FundMyWallet.dart';
import 'package:zaki/Services/api.dart';
import 'package:zaki/Widgets/CustomConfermationScreen.dart';
import 'package:zaki/Widgets/TextHeader.dart';

import '../Constants/AppConstants.dart';
import '../Constants/HelperFunctions.dart';
import '../Constants/Styles.dart';
import '../Services/CreaditCardApis.dart';
import '../Widgets/CustomLoadingScreen.dart';
import '../Widgets/ZakiPrimaryButton.dart';

class CreateUser extends StatefulWidget {
  final double? height;
  const CreateUser({Key? key, this.height}) : super(key: key);

  @override
  State<CreateUser> createState() => _IssueDebitCardFieldsState();
}

class _IssueDebitCardFieldsState extends State<CreateUser> {
  final formGlobalKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  // final emailAddressController = TextEditingController();
  final ssnController = TextEditingController();
  final zipCodeController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final streetAddressController = TextEditingController();
  final appartOrSuitController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final securityCodeController = TextEditingController();
  final amountController = TextEditingController();
  final cardHolderNameController = TextEditingController();
  final cardNumberController = TextEditingController();
  final expireDateController = TextEditingController();
  String expiredDate = '';
  bool isCardChecked = true;
  OutlineInputBorder circularOutLineBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: BorderSide(
        color: grey.withValues(alpha:0.4),
      ));

  @override
  void initState() {
    super.initState();
    setUpUser();
  }

  void setUpUser() {
    Future.delayed((Duration.zero), () {
      var appConstants = Provider.of<AppConstants>(context, listen: false);

      // firstNameController.text = appConstants.userModel.usaFirstName.toString();
      // lastNameController.text = appConstants.userModel.usaLastName.toString();
      // emailAddressController.text = appConstants.userModel.usaEmail.toString();
      zipCodeController.text = appConstants.userModel.zipCode.toString();

      // phoneNumberController.text = appConstants.userModel.usaPhoneNumber.toString();
    });
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
        child: SizedBox(
          height: widget.height != null ? height * 0.8 : height,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: getCustomPadding(),
              child: Form(
                key: formGlobalKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                        // color: white.withValues(alpha:0.1),
                        // elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                          // side: BorderSide(color: grey)
                          //set border radius more than 50% of height and width to make circle
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Container(
                            child: Text(
                              'Lock Icon here. You must configure your wallet with our FDIC ensured bank partner to unlock this feature and all other benefits of ZakiPay.  This will be a one time charge of ${getCurrencySymbol(context, appConstants: appConstants)}4.99',
                              style: heading4TextSmall(
                                width * 0.8,
                              ),
                            ),
                          ),
                        )),
                    // appBarHeader_005(
                    //     context: context,
                    //     appBarTitle: 'Setup Spend Wallet',
                    //     backArrow: false,
                    //     height: height,
                    //     width: width,
                    //     requiredHeader: false,
                    //     leadingIcon: true),
                    // TextHeader1(title: 'Step 1:'),
                    // spacing_large,
                    spacing_medium,
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

                    // spacing_large,
                    // TextHeader1(title: 'Email'),
                    // TextFormField(
                    //             autovalidateMode: AutovalidateMode.onUserInteraction,
                    //             enabled: true,
                    //             validator: (value) {
                    //                if (value!.isEmpty) {
                    //                 return 'Please enter your email address';
                    //                 }
                    //                else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                    //                 return 'Please enter a valid email address';
                    //                 }
                    //               else {
                    //               String emailDomain = value.split('@')[1]; String domainExtension = emailDomain.split('.').last; List<String> validExtensions = ['com', 'net', 'org', 'edu', 'gov'];
                    //               // add more extensions as needed
                    //               if (!validExtensions.contains(domainExtension)) {
                    //                 return 'Enter a valid email address';
                    //               }
                    //             }
                    //             return null;
                    //             },
                    //             // style: TextStyle(color: primaryColor),
                    //             style: heading2TextStyle(
                    //                   context, width),
                    //             controller: emailAddressController,
                    //             obscureText: false,
                    //             keyboardType: TextInputType.emailAddress,
                    //             maxLines: 1,
                    //             decoration: InputDecoration(
                    //               hintText: 'Enter Email',
                    //               hintStyle: heading2TextStyle(
                    //                   context, width),
                    //             ),
                    //           ),
                    spacing_large,
                    TextHeader1(title: 'Contact Phone Number'),

                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      enabled: true,
                      inputFormatters: [
                        // CardFormatter(sample: "XXX-XXX-XXX", separator: "-")
                        maskFormatter
                      ],
                      validator: phoneNumberValidation,

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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Card(
                          color: white,
                          // elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                            // side: BorderSide(color: grey)
                            //set border radius more than 50% of height and width to make circle
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextFormField(
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  maxLength: 35,
                                  validator: (String? name) {
                                    if (name!.isEmpty) {
                                      return 'Enter Name';
                                    } else {
                                      return null;
                                    }
                                  },
                                  style: heading3TextStyle(width),
                                  controller: cardHolderNameController,
                                  // obscureText: appConstants.passwordVissibleRegistration,
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    isDense: true,
                                    counterText: '',
                                    border: circularOutLineBorder,
                                    enabledBorder: circularOutLineBorder,
                                    hintText: 'Card Holder name',
                                    hintStyle: heading3TextStyle(width),
                                  ),
                                ),
                                spacing_medium,
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12.0, vertical: 8),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Card Info',
                                        style: heading1TextStyle(context, width,
                                            color: green),
                                      ),
                                      Row(
                                        children: [
                                          SizedBox(
                                            height: 25,
                                            width: 30,
                                            child: Checkbox(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                  side:
                                                      BorderSide(color: green)),
                                              checkColor: white,
                                              activeColor:
                                                  isCardChecked ? green : grey,
                                              // fillColor: MaterialStateProperty.resolveWith(),
                                              value: isCardChecked,
                                              onChanged: (cardNumberController
                                                              .text.length <
                                                          19 ||
                                                      cardHolderNameController
                                                          .text.isEmpty ||
                                                      expireDateController
                                                          .text.isEmpty ||
                                                      zipCodeController
                                                              .text.length <
                                                          5 ||
                                                      securityCodeController
                                                              .text.length <
                                                          5)
                                                  ? null
                                                  : (bool? value) {
                                                      setState(() {
                                                        isCardChecked = value!;
                                                      });
                                                    },
                                            ),
                                          ),
                                          Text(
                                            'Save Card',
                                            style: heading3TextStyle(width,
                                                color: isCardChecked
                                                    ? black
                                                    : grey.withValues(alpha:0.8)),
                                          ),
                                          // Transform.scale(
                                          //   scale: 0.6,
                                          //   alignment: Alignment.centerRight,
                                          //   child: CupertinoSwitch(
                                          //     value: isCardChecked,
                                          //     activeColor: isCardChecked ? green : grey,
                                          //     trackColor: isCardChecked ? green : grey,
                                          //     onChanged: (cardNumberController.text.length <
                                          //                 19 ||
                                          //             amountController.text.isEmpty ||
                                          //             cardHolderNameController.text.isEmpty ||
                                          //             expireDateController.text.isEmpty ||
                                          //             zipCodeController.text.length < 5 ||
                                          //             securityCodeController.text.length < 5)
                                          //         ? null
                                          //         : (value) async {
                                          //             setState(() {
                                          //               isCardChecked = value;
                                          //             });
                                          //             // if (isCardChecked) {
                                          //             //   if(!formGlobalKey.currentState!.validate() ){
                                          //             //     return;
                                          //             //   }
                                          //             //   else

                                          //             // }
                                          //           },
                                          //   ),
                                          // ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                spacing_medium,
                                TextFormField(
                                  inputFormatters: [
                                    // CardFormatter(sample: "XXX-XXX-XXX", separator: "-")
                                    cardNumberMaskFormatter
                                  ],
                                  autovalidateMode: AutovalidateMode.disabled,
                                  validator: (String? number) {
                                    if (number!.isEmpty) {
                                      return 'Enter Card Number';
                                    }
                                    if (number.toString().length < 17) {
                                      return 'Ooops, you seem to be missing some numbers!';
                                    } else {
                                      return null;
                                    }
                                  },
                                  style: heading3TextStyle(width),
                                  controller: cardNumberController,
                                  maxLength: 19,
                                  // obscureText: appConstants.passwordVissibleRegistration,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                      isDense: true,
                                      counterText: '',
                                      hintText: 'Card Number',
                                      hintStyle: heading3TextStyle(width),
                                      border: circularOutLineBorder,
                                      enabledBorder: circularOutLineBorder,
                                      suffixIconColor: grey,
                                      contentPadding:
                                          EdgeInsets.symmetric(horizontal: 6),
                                      suffixIcon: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          CardTypeIcons(
                                            icon: FontAwesomeIcons.ccVisa,
                                          ),
                                          CardTypeIcons(
                                            icon: FontAwesomeIcons.ccMastercard,
                                          ),
                                          CardTypeIcons(
                                            icon: FontAwesomeIcons.ccAmex,
                                          ),
                                        ],
                                      )),
                                ),
                                spacing_medium,
                                Row(
                                  children: [
                                    Expanded(
                                        child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 2.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          TextFormField(
                                            // enabled: false,
                                            // readOnly: true,
                                            autovalidateMode: AutovalidateMode
                                                .onUserInteraction,
                                            inputFormatters: [
                                              dateFormateMaskFormatter
                                            ],
                                            // obscureText: true,
                                            // obscuringCharacter: '*',
                                            onTap: () async {
                                              expiredDate =
                                                  expireDateController.text;
                                              setState(() {});

                                              // DateTime toDay = DateTime.now();
                                              // DateTime? dateTime = await showDatePicker(
                                              //     context: context,
                                              //     initialDate: toDay,
                                              //     firstDate: toDay,
                                              //     lastDate: DateTime(toDay.year + 9,
                                              //         toDay.month + 7, toDay.day),
                                              //     initialEntryMode:
                                              //         DatePickerEntryMode.calendar);
                                              // // ignore: unnecessary_null_comparison
                                              // if (dateTime != null) {
                                              //   print(
                                              //       'Selected date is: ${dateTime.day}');
                                              //   appConstants.updateDateOfBirth(
                                              //       '${dateTime.month} / ${dateTime.year}');
                                              //   expireDateController.text =
                                              //       appConstants.dateOfBirth;
                                              //   setState(() {
                                              //     expiredDate = dateTime;
                                              //   });
                                              // }
                                            },
                                            validator: (String? date) {
                                              // return null;

                                              if (date!.isEmpty) {
                                                return 'Select a date';
                                              } else {
                                                String firstDate =
                                                    date.split('/')[0];
                                                if (int.parse(firstDate) > 12) {
                                                  return 'Invalid Date';
                                                }
                                                String secondDate =
                                                    date.split('/').last;
                                                logMethod(
                                                    title:
                                                        'Second Date: ${DateTime.now().year.toString().substring(2, 4)} and next year${(DateTime.now().year + 7).toString().substring(2, 4)}',
                                                    message: secondDate);
                                                //Checking that user enter year == current year
                                                if (int.parse(secondDate) ==
                                                    int.parse(DateTime.now()
                                                        .year
                                                        .toString()
                                                        .substring(2, 4))) {
                                                  //Now checking that its upto 3 months
                                                  if (int.parse(firstDate) <=
                                                      int.parse((DateTime.now()
                                                                  .month +
                                                              3)
                                                          .toString())) {
                                                    return 'Card almost expired';
                                                  }
                                                }
                                                if (int.parse(secondDate) <
                                                        int.parse(DateTime.now()
                                                            .year
                                                            .toString()
                                                            .substring(2, 4)) ||
                                                    int.parse(secondDate) >=
                                                        int.parse(
                                                            ((DateTime.now()
                                                                        .year +
                                                                    7)
                                                                .toString()
                                                                .substring(
                                                                    2, 4)))) {
                                                  return 'Invalid Date';
                                                }
                                                logMethod(
                                                    title: 'Date',
                                                    message: firstDate);
                                                return null;
                                              }
                                            },
                                            maxLength: 8,
                                            decoration: InputDecoration(
                                              counterText: "",
                                              isDense: true,
                                              border: circularOutLineBorder,
                                              enabledBorder:
                                                  circularOutLineBorder,
                                              hintText: 'MM/YY',
                                              hintStyle:
                                                  heading3TextStyle(width),
                                            ),
                                            style: heading3TextStyle(width),
                                            controller: expireDateController,
                                            // obscureText: appConstants.passwordVissibleRegistration,
                                            keyboardType:
                                                TextInputType.datetime,
                                          ),
                                        ],
                                      ),
                                    )),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                        child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 2.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [],
                                          ),
                                          TextFormField(
                                            autovalidateMode: AutovalidateMode
                                                .onUserInteraction,
                                            maxLength: 5,
                                            validator: (String? code) {
                                              if (code!.isEmpty) {
                                                return 'Enter Security Code';
                                              } else if (code.length < 3) {
                                                return 'Enter Full Security Code';
                                              } else {
                                                return null;
                                              }
                                            },
                                            obscureText: true,
                                            decoration: InputDecoration(
                                              counterText: '',
                                              isDense: true,
                                              border: circularOutLineBorder,
                                              enabledBorder:
                                                  circularOutLineBorder,
                                              hintText: 'CVC / CVV',
                                              hintStyle:
                                                  heading3TextStyle(width),
                                            ),
                                            style: heading3TextStyle(width),
                                            controller: securityCodeController,
                                            // obscureText: appConstants.passwordVissibleRegistration,
                                            keyboardType: TextInputType.number,
                                          ),
                                        ],
                                      ),
                                    ))
                                  ],
                                ),
                                spacing_medium,
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        maxLength: 5,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly
                                        ],
                                        validator: (String? zipCode) {
                                          // return null;

                                          if (zipCode!.isEmpty) {
                                            return 'Enter ZipCode';
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
                                          hintStyle: heading3TextStyle(width),
                                        ),
                                        style: heading3TextStyle(width),
                                        controller: zipCodeController,
                                        // obscureText: appConstants.passwordVissibleRegistration,
                                        keyboardType: TextInputType.number,
                                      ),
                                    ),
                                    Expanded(
                                        child: SizedBox(
                                      width: width * 0.1,
                                    ))
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),

                        // spacing_medium,
                        // SSLCustomRow(),
                      ],
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
                      title: 'Send & Next Step',
                      width: width,
                      onPressed: (appConstants.registrationCheckBox == false ||
                                  phoneNumberController.text.length < 12 ||
                                  firstNameController.text.isEmpty ||
                                  lastNameController.text.isEmpty ||
                                  cityController.text.isEmpty ||
                                  stateController.text.length < 5 ||
                                  ssnController.text.length < 4) ||
                              (cardNumberController.text.length < 19 ||
                                  cardHolderNameController.text.isEmpty ||
                                  expireDateController.text.isEmpty ||
                                  int.parse(expireDateController.text
                                          .split('/')[0]) >
                                      12 ||
                                  zipCodeController.text.length < 5 ||
                                  securityCodeController.text.length < 3)
                          ? null
                          : () async {
                              if (!formGlobalKey.currentState!.validate()) {
                                return;
                              }
                              ApiServices services = ApiServices();
                              if (isCardChecked) {
                                await services.saveCardInfoForFuture(
                                    amount: amountController.text.trim(),
                                    cardHolderName:
                                        cardHolderNameController.text,
                                    cardNumber: cardNumberController.text,
                                    cardStatus: true,
                                    expiryDate: expireDateController.text,
                                    id: appConstants.userRegisteredId);
                                services.getCardInfoFromFundMyWallet(
                                    context: context,
                                    userId: appConstants.userRegisteredId);
                                // service.getfun
                              } else if (appConstants.fundMeWalletModel
                                          .FM_WALLET_cardHolderName !=
                                      null &&
                                  isCardChecked == false) {
                                //Delete the card
                                services.deleteCard(
                                    id: appConstants.userRegisteredId);
                              }

                              // ApiServices().addUserTokenBankApi(appConstants.userRegisteredId, '12312312');
                              // return;

                              CustomProgressDialog progressDialog =
                                  CustomProgressDialog(context, blur: 6);
                              progressDialog
                                  .setLoadingWidget(CustomLoadingScreen());
                              progressDialog.show();

                              CreaditCardApi creaditCardApi = CreaditCardApi();

                              //  else {

                              String? paid = await CreaditCardApi()
                                  .addAmountFromCardToBank(
                                      amount: '4',
                                      name: appConstants.userModel.usaFirstName,
                                      tags: "",
                                      userToken:
                                          AppConstants.ZAKI_PAY_ACCOUNT_NUMBER);
                              if (paid == null) {
                                showNotification(
                                    error: 1,
                                    icon: Icons.credit_card_off_outlined,
                                    message: 'Card Not Accepted');
                                progressDialog.dismiss();
                                return;
                              }
                              String? userToken =
                                  await creaditCardApi.createUserForCard(
                                      gender: 'M',
                                      city: cityController.text.trim(),
                                      country: 'US',
                                      // email: emailAddressController.text.trim(),
                                      firstName: firstNameController.text,
                                      lastName: lastNameController.text,
                                      password: 'hussam01@G',
                                      address1:
                                          streetAddressController.text.trim(),
                                      phoneNumber:
                                          appConstants.userModel.usaPhoneNumber,
                                      postalCode:
                                          appConstants.userModel.zipCode,
                                      state: 'STATE',
                                      useParentAccount: false
                                      // useParentAccount: widget.selectedUserId==appConstants.userRegisteredId?false:true
                                      );
                              if (userToken != null) {
                                await services.addUserTokenBankApi(
                                    checkUserEqual(appConstants)
                                        ? appConstants.userRegisteredId
                                        : appConstants
                                            .currentUserIdForBottomSheet,
                                    userToken,
                                    USER_Subscription_Method: ""
                                    );
                              }

                              Future.delayed(Duration(milliseconds: 200), () {
                                services.getUserData(
                                    context: context,
                                    userId: appConstants.userRegisteredId);
                              });
                              showNotification(
                                  error: 0,
                                  icon: Icons.credit_card_off_outlined,
                                  message: 'Account Created');
                              progressDialog.dismiss();
                              Navigator.pop(context);

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          CustomConfermationScreen(
                                            title: 'Great Job!',
                                            fromCreateUser: true,
                                            subTitle:
                                                "Account Created Successfully and fee deducted ${getCurrencySymbol(context, appConstants: appConstants)} 4.99",
                                          )));
                              // }

                              // progressDialog.dismiss();
                              //   return;
                            },
                    ),
                    spacing_medium,
                    Card(
                        // color: white.withValues(alpha:0.1),
                        // elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                          // side: BorderSide(color: grey)
                          //set border radius more than 50% of height and width to make circle
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Container(
                            child: Text(
                              'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do',
                              style: heading4TextSmall(
                                width * 0.8,
                              ),
                            ),
                          ),
                        )),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
