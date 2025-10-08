// ignore_for_file: deprecated_member_use

// import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:zaki/Constants/HelperFunctions.dart';
import 'package:zaki/Constants/Styles.dart';
import 'package:zaki/Screens/VerificationCodeWhatsapp.dart';
import 'package:zaki/Screens/WhatsAppLoginScreen.dart';
import 'package:zaki/Services/api.dart';
// import 'package:zaki/Widgets/TermsAndConditionsSmall.dart';
import 'package:zaki/Widgets/TextHeader.dart';
import 'package:zaki/Widgets/ZakiPrimaryButton.dart';

import '../Constants/AppConstants.dart';
import '../Constants/Spacing.dart';

// firebase_core, cloud_firestore, firebase_auth, google_sign_in, flutter_facebook_auth

class WhatsAppSignUpScreen extends StatefulWidget {
  const WhatsAppSignUpScreen({Key? key}) : super(key: key);

  @override
  _WhatsAppSignUpScreenState createState() => _WhatsAppSignUpScreenState();
}

class _WhatsAppSignUpScreenState extends State<WhatsAppSignUpScreen> {
  final signUpFormKey = GlobalKey<FormState>();
  DateTime? _lastQuitTime = DateTime.now();
  final nameController = TextEditingController();
  final numberController = TextEditingController();
  final passwordCotroller = TextEditingController();
  final confirmPasswordCotroller = TextEditingController();
  String alreadyExist = '';

   @override
  void dispose() {
    numberController.dispose();
    super.dispose();
  }

  void clearFields() {
    numberController.text = '';
    setState(() {});
  }

  @override
  void initState() {
    Future.delayed(Duration.zero, (){
      var appConstants = Provider.of<AppConstants>(context, listen: false);
      appConstants.updateCountry(AppConstants.COUNTRY_SAUDIA);
      appConstants.updateCurrency(AppConstants.COUNTRY_SAUDIA_CURRENCY);
      appConstants.updateSelectedCounteryDialCode('+966');
    });
    userPermissions();
    super.initState();
  }

  userPermissions() async {
    // You can request multiple permissions at once.
// Map<Permission, PermissionStatus> statuses = await [
//   Permission.location,
//   Permission.storage,
// ].request();
// print(statuses[Permission.location]);
    // // await Permission.contacts.request();
    // // await Permission.camera.request();
    // // await Permission.locationWhenInUse.request();
  }

  @override
  Widget build(BuildContext context) {
    var appConstants = Provider.of<AppConstants>(context, listen: true);
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        if (DateTime.now().difference(_lastQuitTime!).inSeconds > 1) {
          showSnackBarDialog(
              context: context, message: 'Press back button to exit');
          // Scaffold.of(context)
          //     .showSnackBar(SnackBar(content: Text('Press again Back Button exit')));
          _lastQuitTime = DateTime.now();
          return false;
        } else {
          SystemChannels.platform.invokeMethod('SystemNavigator.pop');
          return true;
        }
      },
      child: Scaffold(
        // resizeToAvoidBottomInset: false,

        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: getCustomPadding(),
              child: Form(
                key: signUpFormKey,
                autovalidateMode: AutovalidateMode.disabled,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    spacing_X_large,
                    Center(child: Image.asset(appLogosBaseAddress+'zakipay_logo_signUp.png')),
                    spacing_X_large,
                    Text('FREE Sign Up:', style: appBarTextStyle(context, width, color: green),),
                    // spacing_medium,
                    // TextHeader1(
                    //   title:
                    //   'Enter your Mobile Number',
                    // ),
                    
                    ////////////////////////////////
                    TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          inputFormatters: [
                            // CardFormatter(sample: "XXX-XXX-XXX", separator: "-")
                            // maskFormatter
                            appConstants.selectedCountry==AppConstants.COUNTRY_SAUDIA? saudiaMaskFormatter:qatarMaskFormatter
                          ],
                          validator: (number){
                            if (number!.isEmpty) {
                              return 'Enter a Number';
                            } else if ((number.length  < (appConstants.selectedCountry==AppConstants.COUNTRY_SAUDIA? 11 : 10))) {
                              return 'Enter Full Mobile Number';
                            }
                            return null;
                          },
                          // style: TextStyle(color: primaryColor),
                          style: heading3TextStyle(width, color: grey),
                          controller: numberController,
                          obscureText: false,
                          keyboardType: TextInputType.phone,
                          maxLines: 1,
                          onChanged: (String username) {
                            if(alreadyExist!='')
                            setState(() {
                              alreadyExist = '';
                            });
                          },
                          decoration: InputDecoration(
                            hintText: 'Enter Phone Number',
                            isDense: true,
                            errorText: alreadyExist == '' ? null : alreadyExist,
                            hintStyle: heading3TextStyle(width, color: grey),
                            contentPadding: const EdgeInsets.only(top: 18),
                            prefixIcon: customCountryPicker(appConstants, width),
                          ),
                        ),
                    ///////////////////////////////
                    //   TextFormField(
                    //     autovalidateMode: AutovalidateMode.onUserInteraction,
                    //     validator: (String? password) {
                    //         if(password!.isEmpty){
                    //           return 'Please Enter Password';
                    //         }
                    //         else{
                    //           return null;
                    //         }
                    //       },
                    //       style: textStyleHeading2WithTheme(context,width*0.8, whiteColor: 0),
                    //       controller: passwordCotroller,
                    //       obscureText: appConstants.passwordVissibleRegistration,
                    //        keyboardType: TextInputType.visiblePassword,
                    //       decoration: InputDecoration(
                    //         hintText: '********',
                    //         hintStyle: textStyleHeading2WithTheme(context,width*0.8, whiteColor: 2),
                    //         labelText: 'Enter Password',
                    //         labelStyle: textStyleHeading2WithTheme(context,width*0.8, whiteColor: 2),
                    //         suffixIcon: IconButton(
                    //           icon: Icon(
                    //             Icons.visibility,
                    //             color: grey,),
                    //           onPressed: (){
                    //             appConstants.updatePasswordVisibilityRegistartion(appConstants.passwordVissibleRegistration);
                    //           })
                    //       ),
                    //       ),
                    // TextFormField(
                    //   autovalidateMode: AutovalidateMode.onUserInteraction,
                    //       validator: (String? password) {
                    //         if(password!.isEmpty){
                    //           return 'Please Enter Password';
                    //         } else if (password!=passwordCotroller.text) {
                    //           return 'Password doesn’t match :( Try again';
                    //         }
                    //         else{
                    //           return null;
                    //         }
                    //       },
                    //       style: textStyleHeading2WithTheme(context,width*0.8, whiteColor: 0),
                    //       controller: confirmPasswordCotroller,
                    //       textAlignVertical: TextAlignVertical.bottom,
                    // textAlign: TextAlign.left,
                    //       obscureText: appConstants.passwordVissibleRegistration,
                    //        keyboardType: TextInputType.visiblePassword,
                    //       decoration: InputDecoration(
                    //         hintText: '********',
                    //         hintStyle: textStyleHeading2WithTheme(context,width*0.8, whiteColor: 2),
                    //         labelText: 'Confirm Password',
                    //         labelStyle: textStyleHeading2WithTheme(context,width*0.8, whiteColor: 2),
                    //         suffixIcon: IconButton(
                    //           icon: Icon(
                    //             Icons.visibility,
                    //             color: grey,),
                    //           onPressed: (){
                    //             appConstants.updatePasswordVisibilityRegistartion(appConstants.passwordVissibleRegistration);
                    //           })
                    //       ),
                    //       ),
                    spacing_small,
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            TextValue3(
                          title:  'Verification code will be sent to ',
                          ),
                            Icon(FontAwesomeIcons.whatsapp, color: green, size: width * 0.05,),
                            Text(' Whatsapp ', style: heading4TextSmall(width, color: green),),
                          ],
                        ),
                  
                        spacing_large,
                        ZakiPrimaryButton(
                            title: 'Sign Up',
                            width: width,
                            onPressed: numberController.text.length < (appConstants.selectedCountry==AppConstants.COUNTRY_SAUDIA? 11: 10)
                                ? null
                                : () async {
                                  resetPreviousData(appConstants);
                                    ApiServices services = ApiServices();
                                    if (signUpFormKey.currentState!
                                        .validate()) {
                                      // appConstants.updateSignUpMethod('WhatsApp');
                                      bool userExist = await services.isUserExist(number: '${appConstants.selectedCountryDialCode}${getPhoneNumber(number: numberController.text)}');
                                      if (userExist) {
                                        setState(() {
                                          alreadyExist =
                                              'Mobile Number already registered! Log In or Sign Up with another number';
                                        });
                                        return;
                                      }
                                      // return;
                                      appConstants.updatePhoneNumber(
                                          '${appConstants.selectedCountryDialCode}${getPhoneNumber(number: numberController.text)}');
                                      // appConstants 
                                      //     .updateFirstName(nameController.text);
                                      logMethod(title: 'Number', message: appConstants.phoneNumber );
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const VerficationCodeWhatsapp(),
                                        ),
                                      );
                                    }
                                  }),
                      ],
                    ),
                          spacing_medium,
                  Center(child: TextValue3(title: '--OR--',)),
                  spacing_medium,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Got an account? ',
                          style: heading3TextStyle(width),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const WhatsAppLoginScreen()));
                          },
                          child: Text(
                          'Log In',
                          style: heading3TextStyle(width,color: green, underLine: true),
                        ),
                        ),
                      ],
                    ),
                    spacing_X_large,
                    spacing_X_large,
                    spacing_large,
                    
                    TermsAndConditions(width: width, height: height),
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

class TermsAndConditions extends StatelessWidget {
  const TermsAndConditions({
    Key? key,
    required this.width,
    required this.height,
  }) : super(key: key);

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: '*By signing up, you are agreeing to ZakiPay’s ',
        style: heading4TextSmall(width),
        children: <TextSpan>[
          TextSpan(text: 'Terms & Conditions', style: heading4TextSmall(width, underline: true), 
          recognizer: TapGestureRecognizer()
            ..onTap = () async{
              await teamViewMethod(context: context , height: height,width: width, url: "https://zakipay.com/terms-conditions/");
            },
          ),
          TextSpan(text: ' & '),
          TextSpan(
            text: 'Privacy Policy.',
             style: heading4TextSmall(width, underline: true), 
            recognizer: TapGestureRecognizer()
            ..onTap = () async{
              await teamViewMethod(context: context , height: height,width: width, url: "https://zakipay.com/privacy-policy/");
            },
            )
        ],
      ),
    );
  }
}
