import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zaki/Constants/HelperFunctions.dart';
import 'package:zaki/Constants/IntialSetup.dart';
// import 'package:zaki/Constants/NotificationTitle.dart';
import 'package:zaki/Screens/PinCodeSetUp.dart';
import 'package:zaki/Services/api.dart';
import 'package:zaki/Widgets/TextHeader.dart';
import 'package:zaki/Widgets/ZakiPrimaryButton.dart';
import '../Constants/AppConstants.dart';
import '../Constants/Spacing.dart';
import '../Constants/Styles.dart';
import '../Widgets/AppBars/AppBar.dart';
import '../Widgets/CustomConfermationScreen.dart';
import 'package:zaki/Constants/Whitelable.dart';

enum SignUpVia { number, pinCode }

class ActivateFamilyMember extends StatefulWidget {
  final String? userId;
  final String? firstName;
  const ActivateFamilyMember({Key? key, this.firstName, this.userId})
      : super(key: key);

  @override
  State<ActivateFamilyMember> createState() => _ActivateFamilyMemberState();
}

class _ActivateFamilyMemberState extends State<ActivateFamilyMember> {
  late SignUpVia? signUpThrough = SignUpVia.number;
  final formGlobalKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneOrEmailNameController = TextEditingController();
  var roleList = [
    'Son',
    'Daughter',
    'A Kid',
  ];


  @override
  void initState() {
    super.initState();
    firstNameController.text = widget.firstName!;
    Future.delayed(const Duration(milliseconds: 200), () {
      var appConstants = Provider.of<AppConstants>(context, listen: false);
      lastNameController.text = appConstants.userModel.usaLastName!;
    });
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    phoneOrEmailNameController.dispose();
    super.dispose();
  }

  void clearFields() {
    firstNameController.text = '';
    lastNameController.text = '';
    phoneOrEmailNameController.text = '';
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                appBarHeader_005(
                  context: context, 
                  appBarTitle: 'Activate User', 
                  backArrow: false, 
                  height: height, 
                  width: width, 
                  leadingIcon: true),
                Text(
                  'Name',
                  style: heading1TextStyle(context, width),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
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
                        onChanged: (String username) {},
                        decoration: InputDecoration(
                          counterText: '',
                          hintText: 'First Name',
                          hintStyle: heading2TextStyle(context, width),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
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
                        onChanged: (String username) {},
                        decoration: InputDecoration(
                          hintText: 'Last Name',
                          counterText: '',
                          hintStyle: heading2TextStyle(
                              context, width),
                        ),
                      ),
                    ),
                  ],
                ),
                spacing_large,
                        TextHeader1(title: 'Relationship'),
                        DropdownButtonHideUnderline(
                          child: DropdownButton(
                            isExpanded: true,
                            // Initial Value
                            value: appConstants.kidSignUpRole,
                            style: heading2TextStyle(context, width),

                            // Down Arrow Icon
                            icon: const Icon(Icons.keyboard_arrow_down),

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
                              if (value == 'Dad' || value == 'Husband') {
                                appConstants.updateSignUpRole(AppConstants.USER_TYPE_PARENT);
                                appConstants.updateGenderType('Male');
                              } else if (value == 'Mom' || value == 'Wife') {
                                appConstants.updateSignUpRole(AppConstants.USER_TYPE_PARENT);
                                appConstants.updateGenderType('Female');
                              } else if (value == 'Son') {
                                appConstants.updateSignUpRole(AppConstants.USER_TYPE_KID);
                                appConstants.updateGenderType('Male');
                              } else if (value == 'Daughter') {
                                appConstants.updateSignUpRole(AppConstants.USER_TYPE_KID);
                                appConstants.updateGenderType('Female');
                              } else if (value == 'An Adult') {
                                appConstants.updateSignUpRole(AppConstants.USER_TYPE_SINGLE);
                                appConstants.updateGenderType('Rather not specify');
                              } else if (value == 'A Kid') {
                                appConstants.updateSignUpRole(AppConstants.USER_TYPE_KID);
                                appConstants.updateGenderType('Rather not specify');
                              }
                              
                              showNotification(
                                  error: 0,
                                  icon: Icons.check,
                                  message:
                                      'USERTYPE: ${appConstants.signUpRole} and GENDER: ${appConstants.genderType}');
                            },
                          ),
                        ),
                        Divider(
                          color: black,
                          height: 0.3,
                        ),
                spacing_large,
                Text(
                  'Date of Birth',
                  style: heading1TextStyle(context, width),
                ),
                ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  onTap: () async {
                    DateTime? dateTime = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(DateTime.now().year-21),
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
                          '${dateTime.month} / ${dateTime.day} / ${dateTime.year}');
                    }
                  },
                  title: Text(
                    appConstants.dateOfBirth,
                    overflow: TextOverflow.clip,
                    style: heading2TextStyle(context, width),
                  ),
                  trailing: const Icon(Icons.calendar_today_rounded),
                ),
                Divider(
                  color: black,
                  height: 0.3,
                ),
                spacing_large,
                Text(
                  'Signup ${widget.firstName} via:',
                  style: heading1TextStyle(context, width),
                ),
                Row(
                  children: [
                    Radio(
                        activeColor: black,
                        value: SignUpVia.number,
                        groupValue: signUpThrough,
                        onChanged: (SignUpVia? caha) {
                          setState(() {
                            signUpThrough = caha;
                          });
                        }),
                    Text(
                      'Phone Number',
                      style: heading2TextStyle(context, width),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Radio(
                        activeColor: black,
                        value: SignUpVia.pinCode,
                        groupValue: signUpThrough,
                        onChanged: (SignUpVia? caha) {
                          setState(() {
                            signUpThrough = caha;
                          });
                        }),
                    Text(
                      'PIN Code',
                      style: heading2TextStyle(context, width),
                    ),
                  ],
                ),
                
                if(signUpThrough!.index==0)
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  inputFormatters: [
                              // CardFormatter(sample: "XXX-XXX-XXX", separator: "-")
                              maskFormatter
                              ],
                  validator: signUpThrough!.index!=0?null: phoneNumberValidation,
                  // style: TextStyle(color: primaryColor),
                  style: heading2TextStyle(context, width),
                  controller: phoneOrEmailNameController,
                  obscureText: false,
                  keyboardType: TextInputType.phone,
                  maxLines: 1,
                  onChanged: (String username) {},
                  decoration: InputDecoration(
                    hintText: '000-000-0000',
                    hintStyle: heading2TextStyle(context, width),
                    contentPadding: const EdgeInsets.only(top: 18),
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
                spacing_large,
                ZakiPrimaryButton(
                    width: width,
                    title: 'Next',
                    onPressed: (firstNameController.text.isEmpty||lastNameController.text.isEmpty || ( phoneOrEmailNameController.text.length <12 && signUpThrough!.index==0))?null: () async {
                      ApiServices services = ApiServices();
                      if (signUpThrough!.index == 1) {
                        appConstants.updateFirstName(firstNameController.text);
                        appConstants.updateLastName(lastNameController.text);
                        // var respose = await 
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PinCodeSetUp(
                                      fromKidsSignUpPage: 0,
                                      fromActivate: true,
                                      userId: widget.userId,
                                    )));
                      //   if (respose=="Matched") {
                          
                      // Navigator.push(context, MaterialPageRoute(builder: (context)=> ConfirmedScreen(name: firstNameController.text.toString()),));
                      //   }
                        return;
                      }
                      
                      services.updateKidStatus(
                          dob: appConstants.dateOfBirth,
                          firstName: firstNameController.text,
                          lastName: lastNameController.text,
                          zipCode: appConstants.userModel.zipCode,
                          phoneNumber: getPhoneNumber(number: phoneOrEmailNameController.text),
                          pinEnabled: appConstants.pinEnable,
                          isEnabled: false,
                          kidEnabled: true,
                          pinUser: false,
                          userId: widget.userId,
                          gender: appConstants.genderType,
                          userType: appConstants.signUpRole
                          );
                      services.addFriendsAutumatically(signedUpStatus: false, isFavorite: true, requestReceiverrId: widget.userId, currentUserId: appConstants.userRegisteredId, number: getPhoneNumber(number:phoneOrEmailNameController.text), requestReceiverName: '${firstNameController.text.trim()} ${lastNameController.text.trim()}', requestSenderName: '${appConstants.userModel.usaFirstName} ${appConstants.userModel.usaLastName}', requestSenderPhoneNumber: appConstants.userModel.usaPhoneNumber);
                      if(appConstants.signUpRole==AppConstants.USER_TYPE_SINGLE  || appConstants.signUpRole == AppConstants.USER_TYPE_PARENT){

                      } else{
                      IntialSetup.addDefaultPersonalozationSettings(userId: widget.userId, parentId: appConstants.userRegisteredId);
                      }
                      showNotification(
                          error: 0,
                          icon: Icons.check,
                          message: NotificationText.USER_UPDATED);
                      Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                          builder: (context) => CustomConfermationScreen(
                                            // title: 'Allowance Updated',
                                            subTitle: "${firstNameController.text.trim()} is now part of your family!",
                                            )));
                    }
                  ),
                spacing_medium
              ],
            ),
          ),
        ),
      ),
    );
  }
}
