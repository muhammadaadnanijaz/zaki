// import 'package:country_code_picker/country_code_picker.dart';
// import 'package:country_picker/country_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:provider/provider.dart';
// import 'package:zaki/Constants/HelperFunctions.dart';
// import 'package:zaki/Constants/Styles.dart';
// import 'package:zaki/Widgets/CustomSizedBox.dart';
// import 'package:zaki/Widgets/TextHeader.dart';
// import 'package:zaki/Widgets/ZakiPrimaryButton.dart';

// import '../Constants/AppConstants.dart';
// import '../Services/api.dart';

// class YouSelfInformationAsKidSetupPin extends StatefulWidget {
//   const YouSelfInformationAsKidSetupPin({Key? key}) : super(key: key);

//   @override
//   _YouSelfInformationAsKidSetupPinState createState() =>
//       _YouSelfInformationAsKidSetupPinState();
// }

// class _YouSelfInformationAsKidSetupPinState
//     extends State<YouSelfInformationAsKidSetupPin> {
//   final _formGlobalKeyasKidSignUp = GlobalKey<FormState>();
//   // List of items in our dropdown menu
//   var genderList = [
//     'Male',
//     'Female',
//   ];
//   var roleList = [
//     'Dad',
//     'Mom',
//     'Single Male',
//     'Single Female',
//     'Son',
//     'Daughter'
//   ];
//   String userNameErrorMessage = '';

//   final nameController = TextEditingController();
//   final nickNameController = TextEditingController();
//   final userNameController = TextEditingController();
//   final emailAddressController = TextEditingController();
//   final phoneNumberController = TextEditingController();
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

//       if (appConstants.userModel.usaDob != '') {
//         appConstants.updateDateOfBirth(appConstants.userModel.usaDob!);
//         // return;
//       }

//       userNameController.text = appConstants.userModel.usaUserName!;
//       emailAddressController.text = appConstants.userModel.usaEmail!;
//       phoneNumberController.text = appConstants.userModel.usaPhoneNumber!;
//       nameController.text = appConstants.userModel.usaFirstName!;
//       nickNameController.text = appConstants.userModel.usaLastName!;
//       // if (appConstants.userModel.usaUserType!='Son' || appConstants.userModel.usaUserType!='Daughter') {

//       // }

//       appConstants.updateSignUpRole(appConstants.userModel.usaUserType!);
//       appConstants.updateFirstName(appConstants.userModel.usaFirstName!);
//       appConstants.updateLastName(appConstants.userModel.usaLastName!);
//       appConstants.updateUserName(appConstants.userModel.usaUserName!);
//       appConstants.updatePhoneNumber(appConstants.userModel.usaPhoneNumber!);
//       appConstants.updateEmail(appConstants.userModel.usaEmail!);

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
//         key: _formGlobalKeyasKidSignUp,
//         // autovalidateMode: AutovalidateMode.always,
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: EdgeInsets.symmetric(horizontal: width * 0.05),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 SizedBox(
//                   height: height * 0.1,
//                 ),
//                 TextHeader1(
//                   title: 'Tell Us About Yourself',
//                 ),
//                 CustomSizedBox(
//                   height: height,
//                 ),
//                 TextHeader1(
//                   title: 
//                   'My Name is',
//                 ),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: TextFormField(
//                         autovalidateMode: AutovalidateMode.onUserInteraction,
//                         validator: (String? name) {
//                           if (name!.isEmpty) {
//                             return 'Please Enter Name';
//                           } else {
//                             return null;
//                           }
//                         },
//                         // style: TextStyle(color: primaryColor),
//                         style: heading2TextStyle(context, width),
//                         controller: nameController,
//                         obscureText: false,
//                         keyboardType: TextInputType.name,
//                         maxLines: 1,
//                         maxLength: 15,
//                         onChanged: (String firstName) {
//                           appConstants.updateFirstName(firstName);
//                         },
//                         decoration: InputDecoration(
//                           hintText: 'First Name',
//                           hintStyle: heading2TextStyle(context, width),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(
//                       width: 5,
//                     ),
//                     Expanded(
//                       child: TextFormField(
//                         autovalidateMode: AutovalidateMode.onUserInteraction,
//                         validator: (String? name) {
//                           if (name!.isEmpty) {
//                             return 'Please Enter Last Name';
//                           } else {
//                             return null;
//                           }
//                         },
//                         // style: TextStyle(color: primaryColor),
//                         style: heading2TextStyle(context, width),
//                         controller: nickNameController,
//                         obscureText: false,
//                         keyboardType: TextInputType.name,
//                         maxLines: 1,
//                         maxLength: 15,
//                         onChanged: (String lastName) {
//                           appConstants.updateLastName(lastName);
//                         },
//                         decoration: InputDecoration(
//                           hintText: 'Last Name',
//                           hintStyle: heading2TextStyle(context, width),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(top: 8.0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             TextHeader1(
//                   title: 
//                               'I am a',
//                             ),
//                             DropdownButtonHideUnderline(
//                               child: DropdownButton(
//                                   isExpanded: true,
//                                   // Initial Value
//                                   value: appConstants.signUpRole,
//                                   style: heading2TextStyle(context, width),

//                                   // Down Arrow Icon
//                                   // icon: const Icon(Icons.keyboard_arrow_down),

//                                   // Array list of items
//                                   items: roleList.map((String items) {
//                                     return DropdownMenuItem(
//                                       value: items,
//                                       child: Text(items),
//                                     );
//                                   }).toList(),
//                                   // After selecting the desired option,it will
//                                   // change button value to selected value
//                                   onChanged: null

//                                   //  (String? value) {
//                                   //   appConstants.updateSignUpRole(value!);
//                                   //   if (value=='Dad' || value=='Single Male' ) {
//                                   //      appConstants.updateGenderType('Male');

//                                   //   }
//                                   //   else if (value=='Single Female' || value=='Mom') {
//                                   //     appConstants.updateGenderType('Female');

//                                   //   }

//                                   //   showNotification(error: 0, icon: FontAwesomeIcons.genderless, message: appConstants.genderType);

//                                   // },
//                                   ),
//                             ),
//                             Divider(
//                               color: black,
//                               height: 0.8,
//                             )
//                           ],
//                         ),
//                       ),
//                       const SizedBox(width: 8),
//                       Expanded(
//                         child: Column(
//                           children: [
//                             SizedBox(
//                               height: height * 0.025,
//                             ),
//                             Row(
//                               children: [
//                                 Expanded(
//                                   child: InkWell(
//                                     onTap: () {
//                                       showCountryPicker(
//                                         context: context,
//                                         showWorldWide: false,
//                                         showPhoneCode:
//                                             false, // optional. Shows phone code before the country name.
//                                         countryFilter: const [
//                                           'PK',
//                                           'SA',
//                                           'US',
//                                           'JO'
//                                         ],
//                                         onSelect: (Country country) {
//                                           appConstants
//                                               .updateCountry(country.name);
//                                         },
//                                       );
//                                     },
//                                     child: Text(
//                                       appConstants.selectedCountry,
//                                       overflow: TextOverflow.clip,
//                                       style: heading2TextStyle(context, width),
//                                     ),
//                                   ),
//                                 ),
//                                 IconButton(
//                                   onPressed: () {},
//                                   icon: const Icon(Icons.keyboard_arrow_down),
//                                 )
//                               ],
//                             ),
//                             Divider(
//                               color: black,
//                               height: 0.3,
//                             )
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     SizedBox(
//                       height: height * 0.01,
//                     ),
//                     TextHeader1(
//                   title: 
//                       'I was born on',
//                     ),
//                     ListTile(
//                       onTap: () async {
//                         DateTime? dateTime = await showDatePicker(
//                             context: context,
//                             initialDate: DateTime.now(),
//                             firstDate: DateTime(1950),
//                             lastDate: DateTime.now(),
//                             initialEntryMode: DatePickerEntryMode.calendar);
//                         print('selected date is: ${dateTime!.day}');
//                         // ignore: unnecessary_null_comparison
//                         if (dateTime != null) {
//                           showNotification(
//                               error: 0,
//                               icon: Icons.date_range,
//                               message: 'Age is: ' +
//                                   calculateAge(birthDate: dateTime).toString());

//                           appConstants.updateDateOfBirth(
//                               '${dateTime.day} / ${dateTime.month} / ${dateTime.year}');
//                         }
//                       },
//                       title: TextValue1(
//                   title: 
//                         appConstants.dateOfBirth,
//                       ),
//                       trailing: const Icon(Icons.calendar_today_rounded),
//                     ),
//                     Divider(
//                       color: black,
//                       height: 0.3,
//                     )
//                   ],
//                 ),
//                 CustomSizedBox(
//                   height: height,
//                 ),
//                 TextHeader1(
//                   title: 
//                   'My Email Address Is:',
//                 ),
//                 TextFormField(
//                   autovalidateMode: AutovalidateMode.disabled,
//                   validator: (String? email) {
//                     if (email!.isEmpty) {
//                       return 'Please Enter Email';
//                     } else if (!RegExp(
//                             r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
//                         .hasMatch(email)) {
//                       return 'Please enter a valid email address';
//                     } else {
//                       return null;
//                     }
//                   },
//                   onChanged: (String? email) {
//                     appConstants.updateEmail(email);
//                   },
//                   // style: TextStyle(color: primaryColor),
//                   style: heading2TextStyle(context, width),
//                   controller: emailAddressController,
//                   obscureText: false,
//                   keyboardType: TextInputType.emailAddress,
//                   maxLines: 1,
//                 ),
//                 appConstants.userChildRegisteredId != ''
//                     ? const SizedBox()
//                     : Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           CustomSizedBox(
//                             height: height,
//                           ),
//                           TextHeader1(
//                             title: 
//                             'My Phone Number Is:',
//                           ),
//                           TextFormField(
//                             autovalidateMode:
//                                 AutovalidateMode.onUserInteraction,
//                             // validator: (String? email) {
//                             //   if (email!.isEmpty) {
//                             //     return 'Please Enter Number';
//                             //   } else {
//                             //     return null;
//                             //   }
//                             // },
//                             onChanged: (String? number) {
//                               appConstants.updatePhoneNumber(number);
//                             },
//                             // style: TextStyle(color: primaryColor),
//                             style: heading2TextStyle(context, width),
//                             controller: phoneNumberController,
//                             obscureText: false,
//                             keyboardType: TextInputType.number,
//                             maxLines: 1,
//                             enabled: false,
//                             decoration: InputDecoration(
//                               hintText: '00-XXXX-XXXX-X',
//                               contentPadding: const EdgeInsets.only(top: 18),
//                               hintStyle: heading2TextStyle(context, width),
//                               prefixIcon: CountryCodePicker(
//                                 onChanged: (CountryCode? code) {},
//                                 // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
//                                 initialSelection: 'PK',
//                                 // favorite: ['+39','FR'],
//                                 // optional. Shows only country name and flag
//                                 showCountryOnly: false,

//                                 countryFilter: const ['PK', 'SA', 'US', 'JO'],
//                                 // optional. Shows only country name and flag when popup is closed.
//                                 showOnlyCountryWhenClosed: false,
//                                 // optional. aligns the flag and the Text left
//                                 alignLeft: false,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                 CustomSizedBox(
//                   height: height,
//                 ),
//                 TextHeader1(
//                   title: 
//                   'I would like my username to be:',
//                 ),
//                 TextFormField(
//                   autovalidateMode: AutovalidateMode.onUserInteraction,
//                   validator: (String? name) {
//                     if (name!.isEmpty) {
//                       return 'Please Enter Username';
//                     } else {
//                       return null;
//                     }
//                   },
//                   // style: TextStyle(color: primaryColor),
//                   style: heading2TextStyle(context, width),
//                   controller: userNameController,
//                   obscureText: false,
//                   keyboardType: TextInputType.name,
//                   maxLines: 1,
//                   maxLength: 24,

//                   onChanged: (String username) async {
//                     appConstants.updateUserName(username);

//                     ApiServices services = ApiServices();
//                     bool? isUserNameExist = await services.checkUserNameExist(
//                         userName: userNameController.text);
//                     if (isUserNameExist!) {
//                       setState(() {
//                         userNameErrorMessage =
//                             'username already taken, search another username';
//                       });
//                     } else {
//                       setState(() {
//                         userNameErrorMessage = '';
//                       });
//                     }
//                   },
//                   decoration: InputDecoration(
//                     hintText: 'jhons',
//                     errorText: userNameErrorMessage == ''
//                         ? null
//                         : userNameErrorMessage,
//                     prefixIcon: Icon(
//                       FontAwesomeIcons.at,
//                       size: width * 0.04,
//                       color: black.withValues(alpha:0.2),
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                   height: height * 0.05,
//                 ),
//                 ZakiPrimaryButton(
//                   title: 'Update',
//                   width: width,
//                   onPressed: () async {
//                     ApiServices services = ApiServices();
//                     await services.edittedProfile(
//                         dob: appConstants.dateOfBirth,
//                         email: emailAddressController.text,
//                         firstName: nameController.text,
//                         lastName: nickNameController.text,
//                         isEnabled: true,
//                         phoneNumber: '',
//                         userName: userNameController.text,
//                         userId: appConstants.userChildRegisteredId);
//                     appConstants
//                         .updateUserId(appConstants.userChildRegisteredId);
//                     await services.getUserData(
//                         context: context,
//                         userId: appConstants.userChildRegisteredId);
//                     showNotification(
//                         error: 0,
//                         icon: Icons.clear,
//                         message: 'Successfully Updated');
//                     // Navigator.push(context, MaterialPageRoute(builder: (context)=>SycnContactsPermssion()));
//                   },
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
