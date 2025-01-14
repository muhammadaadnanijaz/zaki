// import 'package:country_code_picker/country_code_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:provider/provider.dart';
// import 'package:zaki/Constants/HelperFunctions.dart';
// import 'package:zaki/Constants/Styles.dart';
// import 'package:zaki/Widgets/CustomSizedBox.dart';
// import 'package:zaki/Widgets/TextHeader.dart';

// import '../Constants/AppConstants.dart';
// import '../Services/api.dart';

// final formGlobalKeyasKidSignUp = GlobalKey<FormState>();

// class YouSelfInformation extends StatefulWidget {
//   const YouSelfInformation({Key? key}) : super(key: key);

//   @override
//   _YouSelfInformationState createState() => _YouSelfInformationState();
// }

// class _YouSelfInformationState extends State<YouSelfInformation> {
//   // List of items in our dropdown menu
//   var genderList = [
//     'Male',
//     'Female',
//   ];
//   var roleList = ['Dad', 'Mom', 'Single Male', 'Single Female', 'Kid'];
//   String userNameErrorMessage = '';

//   TextEditingController nameController = TextEditingController();
//   TextEditingController zipController = TextEditingController();
//   TextEditingController nickNameController = TextEditingController();
//   TextEditingController userNameController = TextEditingController();
//   TextEditingController emailAddressController = TextEditingController();
//   TextEditingController phoneNumberController = TextEditingController();
//   //   @override
//   // void dispose() {
//   //   nameController.dispose();
//   //   nickNameController.dispose();
//   //   userNameController.dispose();
//   //   emailAddressController.dispose();
//   //   phoneNumberController.dispose();
//   //   super.dispose();
//   // }

//   void clearFields() {
//     nameController.text = '';
//     nickNameController.text = '';
//     userNameController.text = '';
//     emailAddressController.text = '';
//     phoneNumberController.text = '';
//   }

//   @override
//   void initState() {
//     Future.delayed(const Duration(milliseconds: 200), () {
//       var appConstants = Provider.of<AppConstants>(context, listen: false);
//       phoneNumberController.text = appConstants.phoneNumber;
//       //  if (appConstants.userChildRegisteredId!='') {
//       userNameController.text =
//           appConstants.userModel.usaUserName ?? userNameController.text;
//       emailAddressController.text =
//           appConstants.userModel.usaEmail ?? emailAddressController.text;
//       phoneNumberController.text =
//           appConstants.userModel.usaPhoneNumber ?? emailAddressController.text;
//       nameController.text =
//           appConstants.userModel.usaFirstName ?? nameController.text;
//       nickNameController.text =
//           appConstants.userModel.usaLastName ?? nickNameController.text;
//       appConstants
//           .updateSignUpRole(appConstants.userModel.usaUserType.toString());

//       // }
//     });
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     var appConstants = Provider.of<AppConstants>(context, listen: true);

//     var height = MediaQuery.of(context).size.height;
//     var width = MediaQuery.of(context).size.width;
//     return Scaffold(
//       body: Form(
//         key: formGlobalKeyasKidSignUp,
//         // autovalidateMode: AutovalidateMode.always,
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               CustomSizedBox(
//                 height: height,
//               ),
//               CustomSizedBox(
//                 height: height,
//               ),
//               TextHeader1(
//                 title: 
//                 'Tell Us About Yourself',
//               ),
//               CustomSizedBox(
//                 height: height,
//               ),
//               CustomSizedBox(
//                 height: height,
//               ),
//               Text(
//                 'My Name is',
//                 style: heading1TextStyle(context, width),
//               ),
//               Row(
//                 children: [
//                   Expanded(
//                     child: TextFormField(
//                       autovalidateMode: AutovalidateMode.onUserInteraction,
//                       validator: (String? name) {
//                         if (name!.isEmpty) {
//                           return 'Please Enter Name';
//                         } else {
//                           return null;
//                         }
//                       },
//                       // style: TextStyle(color: primaryColor),
//                       style: heading2TextStyle(context, width),
//                       controller: nameController,
//                       obscureText: false,
//                       keyboardType: TextInputType.name,
//                       maxLines: 1,
//                       maxLength: 8,
//                       onChanged: (String firstName) {
//                         appConstants.updateFirstName(firstName);
//                         appConstants.userModel.usaFirstName = firstName;
//                       },
//                       decoration: InputDecoration(
//                         counterText: "",
//                         hintText: 'First Name',
//                         hintStyle: heading2TextStyle(context, width),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(
//                     width: 5,
//                   ),
//                   Expanded(
//                     child: TextFormField(
//                       autovalidateMode: AutovalidateMode.onUserInteraction,
//                       validator: (String? name) {
//                         if (name!.isEmpty) {
//                           return 'Please Enter Last Name';
//                         } else {
//                           return null;
//                         }
//                       },
//                       // style: TextStyle(color: primaryColor),
//                       style: heading2TextStyle(context, width),
//                       controller: nickNameController,
//                       obscureText: false,
//                       keyboardType: TextInputType.name,
//                       maxLines: 1,
//                       maxLength: 8,
//                       onChanged: (String lastName) {
//                         appConstants.updateLastName(lastName);
//                         appConstants.userModel.usaLastName = lastName;
//                       },
//                       decoration: InputDecoration(
//                         counterText: "",
//                         hintText: 'Last Name',
//                         hintStyle: heading2TextStyle(context, width),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               // Padding(
//               //   padding: const EdgeInsets.only(top: 8.0),
//               //   child: Row(
//               //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               //     children: [
//               //       Expanded(
//               //         child: Column(
//               //           crossAxisAlignment: CrossAxisAlignment.start,
//               //           children: [
//               //             Text(
//               //               'I am a',
//               //               style: heading1TextStyle(context, width),
//               //             ),
//               //             DropdownButtonHideUnderline(
//               //       child: DropdownButton(
//               //         isExpanded: true,
//               //         // Initial Value
//               //         value: appConstants.signUpRole,
//               //         style: heading2TextStyle(context, width),
//               //         // Down Arrow Icon
//               //         icon: const Icon(Icons.keyboard_arrow_down),
//               //         // Array list of items
//               //         items: roleList.map((String items) {
//               //           return DropdownMenuItem(
//               //             value: items,
//               //             child: Text(items),
//               //           );
//               //         }).toList(),
//               //         // After selecting the desired option,it will
//               //         // change button value to selected value
//               //         onChanged: (String? value) {
//               //           appConstants.updateSignUpRole(value!);
//               //           if (value=='Dad' || value=='Single Male' ) {
//               //              appConstants.updateGenderType('Male');
//               //           }
//               //           else if (value=='Single Female' || value=='Mom') {
//               //             appConstants.updateGenderType('Female');
//               //           }
//               //           showNotification(error: 0, icon: FontAwesomeIcons.genderless, message: appConstants.genderType);
//               //         },
//               //       ),
//               //     ),
//               //     Divider(
//               //       color: black,
//               //       height: 0.8,
//               //     )
//               //           ],
//               //         ),
//               //       ),
//               //       const SizedBox(width: 8),
//               //       Expanded(
//               //         child: SizedBox(height: 0,)
//               //       ),
//               //     ],
//               //   ),
//               // ),
//               CustomSizedBox(
//                 height: height,
//               ),

//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'Living In:',
//                           style: heading1TextStyle(context, width),
//                         ),
//                         CustomSizedBox(
//                           height: height,
//                         ),
//                         Row(
//                           children: [
//                             Expanded(
//                               child: Padding(
//                                 padding: const EdgeInsets.only(bottom: 8.0),
//                                 child: InkWell(
//                                   onTap: () {
//                                     CountryCodePicker(
//                                       onChanged: (CountryCode code) {
//                                         logMethod(
//                                             title: "country",
//                                             message: code.name.toString());
//                                         appConstants.updateCountry(
//                                             code.name.toString());
//                                         appConstants.updateSelectedCounteryCode(
//                                             code.flagUri!
//                                                 .split('/')[1]
//                                                 .split('.')[0]
//                                                 .toUpperCase());
//                                       },
//                                       // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
//                                       initialSelection:
//                                           appConstants.selectedCountryCode,
//                                       // favorite: ['+39','FR'],
//                                       // optional. Shows only country name and flag
//                                       showCountryOnly: false,

//                                       countryFilter: const [
//                                         'PK',
//                                         'SA',
//                                         'US',
//                                         'JO'
//                                       ],
//                                       // optional. Shows only country name and flag when popup is closed.
//                                       showOnlyCountryWhenClosed: false,
//                                       textStyle:
//                                           heading2TextStyle(context, width),
//                                       // optional. aligns the flag and the Text left
//                                       alignLeft: false,
//                                     );
//                                   },
//                                   child: Text(
//                                     appConstants.selectedCountry,
//                                     overflow: TextOverflow.clip,
//                                     style: heading2TextStyle(context, width),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                         Divider(
//                           color: black,
//                           height: 0.32,
//                         )
//                       ],
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   Expanded(
//                     child: TextFormField(
//                       autovalidateMode: AutovalidateMode.onUserInteraction,
//                       validator: (String? name) {
//                         // if (name!.isEmpty) {
//                         //   return 'Please Enter Zip Code';
//                         // } else {
//                         //   return null;
//                         // }
//                       },
//                       // style: TextStyle(color: primaryColor),
//                       style: heading2TextStyle(context, width),
//                       controller: zipController,
//                       obscureText: false,
//                       keyboardType: TextInputType.number,
//                       maxLines: 1,
//                       maxLength: 5,
//                       onChanged: (String zipcode) {
//                         appConstants.userModel.zipCode = zipcode;
//                         ode(zipcode);
//                       },
//                       decoration: InputDecoration(
//                         counterText: "",
//                         hintText: 'Zip Code',
//                         hintStyle: heading2TextStyle(context, width),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   SizedBox(
//                     height: height * 0.01,
//                   ),
//                   Text(
//                     'I was born on',
//                     style: heading1TextStyle(context, width),
//                   ),
//                   ListTile(
//                     onTap: () async {
//                       DateTime? dateTime = await showDatePicker(
//                           context: context,
//                           initialDate: DateTime.now(),
//                           firstDate: DateTime(1950),
//                           lastDate: DateTime.now(),
//                           initialEntryMode: DatePickerEntryMode.calendar);
//                       print('selected date is: ${dateTime!.day}');
//                       // ignore: unnecessary_null_comparison
//                       if (dateTime != null) {
//                         showNotification(
//                             error: 0,
//                             icon: Icons.date_range,
//                             message: 'Age is: ' +
//                                 calculateAge(birthDate: dateTime).toString());

//                         appConstants.updateDateOfBirth(
//                             '${dateTime.month} / ${dateTime.day} /  ${dateTime.year}');
//                       }
//                     },
//                     title: Text(
//                       appConstants.dateOfBirth,
//                       overflow: TextOverflow.clip,
//                       style: heading2TextStyle(context, width),
//                     ),
//                     trailing: const Icon(Icons.calendar_today_rounded),
//                   ),
//                   Divider(
//                     color: black,
//                     height: 0.3,
//                   )
//                 ],
//               ),

//               CustomSizedBox(
//                 height: height,
//               ),
//               Text(
//                 'My Email Address Is:',
//                 style: heading1TextStyle(context, width),
//               ),
//               TextFormField(
//                 autovalidateMode: AutovalidateMode.disabled,
//                 validator: (String? email) {
//                   if (email!.isEmpty) {
//                     return 'Please Enter Email';
//                   } else if (!RegExp(
//                           r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
//                       .hasMatch(email)) {
//                     return 'Please enter a valid email address';
//                   } else {
//                     return null;
//                   }
//                 },
//                 onChanged: (String? email) {
//                   appConstants.updateEmail(email);
//                   appConstants.userModel.usaEmail = email;
//                 },
//                 // style: TextStyle(color: primaryColor),
//                 style: heading2TextStyle(context, width),
//                 controller: emailAddressController,
//                 obscureText: false,
//                 keyboardType: TextInputType.emailAddress,
//                 maxLines: 1,
//                 decoration: InputDecoration(
//                   hintText: 'name@website.com',
//                   hintStyle: heading2TextStyle(context, width),
//                 ),
//               ),
//               CustomSizedBox(
//                 height: height,
//               ),
//               Text(
//                 'My Phone Number Is:',
//                 style: heading1TextStyle(context, width),
//               ),
//               TextFormField(
//                 autovalidateMode: AutovalidateMode.onUserInteraction,
//                 validator: (String? email) {
//                   // if (email!.isEmpty) {
//                   //   return 'Please Enter Number';
//                   // } else {
//                   //   return null;
//                   // }
//                 },
//                 // style: TextStyle(color: primaryColor),
//                 style: heading2TextStyle(context, width),
//                 controller: phoneNumberController,
//                 obscureText: false,
//                 keyboardType: TextInputType.number,
//                 maxLines: 1,
//                 enabled: false,
//                 decoration: InputDecoration(
//                     hintText: '00-XXXX-XXXX-X',
//                     contentPadding: const EdgeInsets.only(top: 18),
//                     hintStyle: heading2TextStyle(context, width),
//                     prefixIcon: CountryCodePicker(
//                       onChanged: (CountryCode code) {
//                         logMethod(
//                             title: "countery", message: code.name.toString());
//                         appConstants.updateCountry(code.name.toString());
//                         appConstants.updateSelectedCounteryCode(code.flagUri!
//                             .split('/')[1]
//                             .split('.')[0]
//                             .toUpperCase());
//                       },
//                       // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
//                       initialSelection: appConstants.selectedCountryCode,
//                       // favorite: ['+39','FR'],
//                       // optional. Shows only country name and flag
//                       showCountryOnly: false,

//                       countryFilter: const ['PK', 'SA', 'US', 'JO'],
//                       // optional. Shows only country name and flag when popup is closed.
//                       showOnlyCountryWhenClosed: false,
//                       // optional. aligns the flag and the Text left
//                       alignLeft: false,
//                     )),
//               ),
//               CustomSizedBox(
//                 height: height,
//               ),
//               Text(
//                 'I would like my username to be:',
//                 style: heading1TextStyle(context, width),
//               ),
//               TextFormField(
//                 autovalidateMode: AutovalidateMode.onUserInteraction,
//                 validator: (String? name) {
//                   if (name!.isEmpty) {
//                     return 'Please Enter Username';
//                   } else {
//                     return null;
//                   }
//                 },
//                 // style: TextStyle(color: primaryColor),
//                 style: heading2TextStyle(context, width),
//                 controller: userNameController,
//                 obscureText: false,
//                 keyboardType: TextInputType.name,
//                 maxLines: 1,
//                 maxLength: 10,
//                 textAlign: TextAlign.start,
//                 textAlignVertical: TextAlignVertical.center,
//                 onChanged: (String username) async {
//                   appConstants.updateUserName(username);

//                   ApiServices services = ApiServices();
//                   bool? isUserNameExist = await services.checkUserNameExist(
//                       userName: userNameController.text);
//                   if (isUserNameExist!) {
//                     setState(() {
//                       userNameErrorMessage =
//                           'username already taken, search another username';
//                     });
//                   } else {
//                     setState(() {
//                       userNameErrorMessage = '';
//                     });
//                   }
//                 },
//                 decoration: InputDecoration(
//                     hintText: 'username',
//                     isDense: true,
//                     counterText: '',
//                     errorText: userNameErrorMessage == ''
//                         ? null
//                         : userNameErrorMessage,
//                     prefixIcon: Icon(
//                       FontAwesomeIcons.at,
//                       size: width * 0.04,
//                       color: black.withValues(alpha:0.2),
//                     ),
//                     contentPadding: EdgeInsets.all(12)),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
