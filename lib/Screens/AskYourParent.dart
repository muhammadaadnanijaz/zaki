import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zaki/Constants/Spacing.dart';
import 'package:zaki/Screens/ConfirmationMessage.dart';
import 'package:zaki/Services/api.dart';
import 'package:zaki/Widgets/TextHeader.dart';
import '../Constants/AppConstants.dart';
import '../Constants/HelperFunctions.dart';
import '../Constants/Styles.dart';
import '../Services/SharedPrefMnager.dart';
import '../Widgets/AppBars/AppBar.dart';
import '../Widgets/ZakiPrimaryButton.dart';

class AskYourParent extends StatefulWidget {
  const AskYourParent({Key? key}) : super(key: key);

  @override
  State<AskYourParent> createState() => _AskYourParentState();
}

class _AskYourParentState extends State<AskYourParent> {
  TextEditingController phoneNumberController = TextEditingController();
  final askYourParentformGlobalKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var appConstants = Provider.of<AppConstants>(context, listen: true);
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Form(
            key: askYourParentformGlobalKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: width * 0.05, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  appBarHeader_005(
                  context: context, 
                  appBarTitle: 'Under Age?', 
                  backArrow: true, 
                  height: height, 
                  width: width, 
                  leadingIcon: true),
                  // Text('Hi, seems like you are underage!\n\nGood News! YOU can still Join ZakiPay!\n\nSimply ask your Parents to join ZakiPay, and create an account.',
                  //   style: heading3TextStyle(width),
                  //   textAlign: TextAlign.center,
                  // ),
                  // spacing_large,
                  Image.asset(imageBaseAddress+'under_age.png'),
                  spacing_X_large,
                  spacing_X_large,
                  spacing_X_large,
                  spacing_X_large,

                  Container(
                    decoration: BoxDecoration(
                      color: Colors.blueAccent.withValues(alpha:0.1),
                      borderRadius: BorderRadius.circular(14)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextHeader1(
                            title: 
                            'Ask your parents to Sign Up for Free! ',
                          ),
                          spacing_small,
                         TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          inputFormatters: [
                            // CardFormatter(sample: "XXX-XXX-XXX", separator: "-")
                            maskFormatter
                          ],
                          validator: phoneNumberValidation,
                          // style: TextStyle(color: primaryColor),
                          style: heading3TextStyle(width, color: grey),
                          controller: phoneNumberController,
                          obscureText: false,
                          keyboardType: TextInputType.phone,
                          maxLines: 1,
                          decoration: InputDecoration(
                            hintText: 'Enter Phone Number',
                            isDense: true,
                            border: circularOutLineBorder,
                              enabledBorder: circularOutLineBorder,
                            hintStyle: heading3TextStyle(width, color: grey),
                            contentPadding: const EdgeInsets.only(top: 18),
                            prefixIcon: CountryCodePicker(
                              onChanged: print,
                              enabled: false,
                              textStyle: heading3TextStyle(width, color: grey),
                              // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                              initialSelection: 'US',
                              // favorite: ['+39','FR'],
                              // optional. Shows only country name and flag
                              showCountryOnly: false,
                              showFlag: false,
                              countryFilter: const ['US'],
                              // optional. Shows only country name and flag when popup is closed.
                              showOnlyCountryWhenClosed: false,
                              // optional. aligns the flag and the Text left
                              alignLeft: false,
                            ),
                          ),
                        )
                        ],
                      ),
                    ),
                  ),
                  
                  textValueBelow,
                  ZakiPrimaryButton(
                    title: 'Send Now!',
                    width: width,
                    onPressed:phoneNumberController.text.length <12
                                ? null
                        : () async{
                            if (!askYourParentformGlobalKey.currentState!
                                .validate()) {
                              return;
                            } else {
                              ApiServices().addParentPhoneNumber(
                                  id: appConstants.userRegisteredId,
                                  phoneNumber: getPhoneNumber(
                                      number: phoneNumberController.text.trim()));
                                showNotification(error: 0, icon: Icons.check, message: 'Under age user data added');

                                ////// Delete User Data that is saved
                                UserPreferences userPref = UserPreferences();
                                  await userPref.clearLoggedInUser();
                                  userPref.clearCurrentUserIdForLoginTouch();
                                  // if(appConstants.userModel.usaTouchEnable!=null && appConstants.userModel.usaTouchEnable==true){
                                  //   await userPref.saveCurrentUserIdForLoginTouch(appConstants.userRegisteredId);
                                  //   String? userId = await userPref.getCurrentUserIdForLoginTouch();
                                  //   logMethod(title: 'LogOut User id:', message: userId.toString());
                                  // } else{
                                  //   userPref.clearCurrentUserIdForLoginTouch();
                                  // }

                                  ////////Delete User Data
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return ConfirmationMessage();
                              }));
                              // getPhoneNumber(number: numberController.text)

                            }
                          },
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
