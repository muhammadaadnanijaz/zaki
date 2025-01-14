// ignore_for_file: file_names
import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:country_code_picker/country_code_picker.dart';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zaki/Constants/LocationGetting.dart';
import 'package:zaki/Constants/Styles.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:zaki/Models/ExtractMemoModel.dart';
import 'package:zaki/Screens/AddMembersWorkFlow.dart';
import 'package:pointycastle/export.dart';
import 'package:zaki/Screens/MemberShipPlan.dart';
import 'package:zaki/Widgets/SecondaryUserScreen.dart';
import 'package:zaki/Widgets/TermsView.dart';

import '../Widgets/CustomLoadingScreen.dart';
import '../Widgets/TextHeader.dart';
import '../Widgets/ZakiCircularButton.dart';
import 'AppConstants.dart';

var maskFormatter = new MaskTextInputFormatter(
    mask: '###-###-####',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy);
// 12-345-6789
var saudiaMaskFormatter = new MaskTextInputFormatter(
    mask: '##-###-####',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy);
// 1234-1234
var qatarMaskFormatter = new MaskTextInputFormatter(
    mask: '#-###-####',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy);


var ssnMaskFormatter = new MaskTextInputFormatter(
    mask: '###-##-####',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy);

var cardNumberMaskFormatter = new MaskTextInputFormatter(
    mask: '####-####-####-####',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy);

var dateFormateMaskFormatter = new MaskTextInputFormatter(
    mask: '##/##',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy);

getPhoneNumber({String? number}) {
  return number!.replaceAll(RegExp(r'[^\w\s]+'), '').toString();
}
String checkSubscriptionValueText({int? subscriptionValue, bool? kidsEnabledStatus, bool? newMemberIsEnabled}) {
  return subscriptionValue==0? 'Setup Wallet': subscriptionValue==1? 'Setup Wallet':subscriptionValue==2? 'Issue Debit Card' : (kidsEnabledStatus==true &&newMemberIsEnabled==false)?'Complete Profile' : '';
}
OutlineInputBorder circularOutLineBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: BorderSide(
        color: grey.withValues(alpha:0.4),
      ));

String encryptPin(String pin) {
  // Padding the PIN to a fixed length for consistent encryption output
  String paddedPin = pin.padRight(16, '#'); // Pad the PIN to 16 characters

  // Example key and IV (use a secure way to generate and store these in a real app)
  final keyBytes = Uint8List.fromList(List.generate(16, (i) => i + 1));
  final ivBytes = Uint8List.fromList(List.generate(16, (i) => i));

  final key = KeyParameter(keyBytes);
  final iv = ParametersWithIV(key, ivBytes);

  final encrypter = StreamCipher('AES/CTR');
  encrypter.init(true, iv);

  final encryptedBytes = encrypter.process(Uint8List.fromList(paddedPin.codeUnits));
  return base64.encode(encryptedBytes);
}
DateTime addOneMonth(DateTime date) {
  int year = date.year;
  int month = date.month;
  int day = date.day;

  // Add one month
  month += 1;

  // Handle overflow to next year
  if (month > 12) {
    month = 1;
    year += 1;
  }

  // Handle day overflow in case of shorter months
  int daysInNewMonth = DateTime(year, month + 1, 0).day;
  if (day > daysInNewMonth) {
    day = daysInNewMonth;
  }

  return DateTime(year, month, day);
}

String decryptPin(String encryptedPinBase64) {
  // Decoding the base64 encoded encrypted PIN
  final encryptedBytes = base64.decode(encryptedPinBase64);

  // Same key and IV as used in encryption (use a secure way to generate and store these in a real app)
  final keyBytes = Uint8List.fromList(List.generate(16, (i) => i + 1));
  final ivBytes = Uint8List.fromList(List.generate(16, (i) => i));

  final key = KeyParameter(keyBytes);
  final iv = ParametersWithIV(key, ivBytes);

  final decrypter = StreamCipher('AES/CTR');
  decrypter.init(false, iv);

  // Decrypting and converting to String
  final decryptedBytes = decrypter.process(encryptedBytes);
  String decryptedPin = String.fromCharCodes(decryptedBytes);

  // Removing padding
  return decryptedPin.replaceAll('#', '');
}


String encryptedValue({String? value}) {
  // Padding the PIN to a fixed length for consistent encryption output
  String paddedPin = value!.padRight(16, '#'); // Pad the PIN to 16 characters

  // Example key and IV (use a secure way to generate and store these in a real app)
  final keyBytes = Uint8List.fromList(List.generate(16, (i) => i + 1));
  final ivBytes = Uint8List.fromList(List.generate(16, (i) => i));

  final key = KeyParameter(keyBytes);
  final iv = ParametersWithIV(key, ivBytes);

  final encrypter = StreamCipher('AES/CTR');
  encrypter.init(true, iv);

  final encryptedBytes = encrypter.process(Uint8List.fromList(paddedPin.codeUnits));
  return base64.encode(encryptedBytes);
}

String decryptedValue({String? value}) {
// Decoding the base64 encoded encrypted PIN
  final encryptedBytes = base64.decode(value!);

  // Same key and IV as used in encryption (use a secure way to generate and store these in a real app)
  final keyBytes = Uint8List.fromList(List.generate(16, (i) => i + 1));
  final ivBytes = Uint8List.fromList(List.generate(16, (i) => i));

  final key = KeyParameter(keyBytes);
  final iv = ParametersWithIV(key, ivBytes);

  final decrypter = StreamCipher('AES/CTR');
  decrypter.init(false, iv);

  // Decrypting and converting to String
  final decryptedBytes = decrypter.process(encryptedBytes);
  String decryptedPin = String.fromCharCodes(decryptedBytes);

  // Removing padding
  return decryptedPin.replaceAll('#', '');
}

// void goToScreen({required BuildContext context, required Widget className, bool? requiredNavBar }){
//   PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
//                 context,
//                 settings: RouteSettings(),
//                 screen: className,
//                 withNavBar: requiredNavBar==null? false: requiredNavBar,
//                 pageTransitionAnimation: PageTransitionAnimation.cupertino,
//             );
// }
resetPreviousData(AppConstants appConstants) { 
  appConstants.updateIndex(0);
  appConstants.updateSignUpMethod('');
  appConstants.updateEmailUsed(false);
  appConstants.updateFirstName('');
  appConstants.updateLastName('');
  appConstants.updateZipCode('');
  appConstants.updateDateOfBirth('mm / dd / yyyy');
  appConstants.updateUserName('');
  appConstants.updateEmail('');
  appConstants.updatePin('');
  appConstants.updateExactPinCode('');
  appConstants.updateExactFullPinConfirm('');
  appConstants.updatePinLength(4);
  appConstants.updateZipCode('');
  appConstants.alreadyExistUserNameErrorMessageUpdate('');
  appConstants.alreadyExistEmailErrorMessageUpdate('');
  appConstants.updateRequestedMoneyLength(0);
  appConstants.updateTopFriendsListLength(0);
  appConstants.familyMemberLimitUpdate(false);
  appConstants.updateToucheds(false);
  appConstants.updateKidsLength(0);
}

bool checkPrimaryUserWithParent(AppConstants appConstants, String? userType){
  // logMethod(title: 'Parent Id', message: '${appConstants.userModel.userFamilyId.toString()} and User Id: ${appConstants.userModel.usaUserId} Primary User: ${(appConstants.userModel.userFamilyId==null || appConstants.userModel.userFamilyId == appConstants.userModel.usaUserId)?"PrimaryUser":"SecondryUser"}');
  // logMethod(title: 'Parent Id', message: '${appConstants.userModel.userFamilyId.toString()} and User Id: ${appConstants.userModel.usaUserId} Primary User: ${appConstants.userModel.isUserPinUser}');
  return 
  ((appConstants.userModel.userFamilyId==null || appConstants.userModel.userFamilyId == appConstants.userModel.usaUserId) && userType==AppConstants.USER_TYPE_PARENT)?
  // appConstants.userModel.userFamilyId != appConstants.userModel.usaUserId && (appConstants.userModel.userFamilyId!=''||appConstants.userModel.userFamilyId!=null)?
  true:
  false;
  
}
bool checkPrimaryUser(AppConstants appConstants){
  logMethod(title: 'Parent Id', message: '${appConstants.userModel.userFamilyId.toString()} and User Id: ${appConstants.userModel.usaUserId} Primary User: ${(appConstants.userModel.userFamilyId==null || appConstants.userModel.userFamilyId == appConstants.userModel.usaUserId)?"PrimaryUser":"SecondryUser"}');
  logMethod(title: 'Parent Id', message: '${appConstants.userModel.userFamilyId.toString()} and User Id: ${appConstants.userModel.usaUserId} Primary User: ${appConstants.userModel.isUserPinUser}');
  return 
  (appConstants.userModel.userFamilyId==null || appConstants.userModel.userFamilyId == appConstants.userModel.usaUserId)?
  // appConstants.userModel.userFamilyId != appConstants.userModel.usaUserId && (appConstants.userModel.userFamilyId!=''||appConstants.userModel.userFamilyId!=null)?
  true:
  false;
  
}

bool checkPrimaryUserForNotFullyRegistered(AppConstants appConstants){
  logMethod(title: 'Parent Id', message: '${appConstants.userModel.userFamilyId.toString()} and User Id: ${appConstants.userModel.usaUserId}');
  return 
  appConstants.userModel.userFamilyId==''||appConstants.userModel.userFamilyId==null?
  true:
  false;
  
}

String? phoneNumberValidation(String? number) {
  if (number!.isEmpty) {
    return 'Enter a Number';
  } else if (number.length < 12) {
    return 'Enter Full Mobile Number';
  }
  return null;
}

Future<void> openUrl({String? url}) async {
  if (!await launchUrl(
    Uri.parse(url!),
    mode: LaunchMode.externalApplication,
  )) {
    throw 'Could not launch $url';
  }
}

Future<bool?> openWhatapp(number) async {
  try {
    var whatsappAndroid = Uri.parse(
        "whatsapp://send?phone=$number&text=${AppConstants.ZAKI_PAY_PROMOTIONAL_TEXT}");
    if (await canLaunchUrl(whatsappAndroid)) {
      bool launch = await launchUrl(
        whatsappAndroid,
      );

      return launch;
    } else {
      logMethod(title: 'Error', message: 'Whatsapp Not Installed');
      return false;
    }
  } catch (e) {
    return false;
  }
}

Future showNotification(
    {String? message, int? error, IconData? icon, bool? autoDismiss}) async {
  showSimpleNotification(Text(message!),
      leading: icon != null ? Icon(icon) : null,
      autoDismiss: autoDismiss ?? true,
      slideDismissDirection: DismissDirection.horizontal,
      background: error == 1 ? red : lightGreen);
}

Future emptyFunction() async {}

int daysBetween({DateTime? from, DateTime? to}) {
  from = DateTime(from!.year, from.month, from.day);
  to = DateTime(to!.year, to.month, to.day);
  int days = (to.difference(from).inHours / 24).round();
  return days == 0 ? 1 : days;
}

Future<String?> getDeviceInfo() async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  if (Platform.isAndroid) {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    print('Running on ${androidInfo.model}'); // e.g. "Moto G (4)"
    return androidInfo.model;
  } else {
    IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    print('Running on ${iosInfo.utsname.machine}'); // e.g. "iPod7,1"
    return iosInfo.utsname.machine;
  }
}

Future<void> sendCustomEmail({String? code, String? email}) async {
// String? mobileData = await getDeviceInfo();
// logMethod(title: 'Mobile Dta', message: mobileData.toString());
  // Get the temporary directory to save the image file
  // Directory tempDir = 
  await getTemporaryDirectory();

  // // Save the image as a file
  // File imageFile = await File('${tempDir.path}/image.jpg').writeAsBytes(imageData);
  // // Prepare the image attachment
  // var mime = lookupMimeType('image.jpg', headerBytes: imageData);
  // var base64Image = base64Encode(imageData);
  //   // Write image data to temporary file
  // await imageFile.writeAsBytes(imageData);

  // // Create a file attachment
  // final attachment = FileAttachment(imageFile);

  final username = 'hi@zakipay.com';
  final password = 'Xjehe8B#9BuuxAwV';
  final receiverEmail = 'muhammadadnanijaz01@gmail.com';
  final secondReceiverEmail = 'hi@zakipay.com';
  final smtpServer = SmtpServer(
    'mail.zakipay.com',
    port: 465,
    username: username,
    password: password,
    allowInsecure: true,
    ssl: true,
    ignoreBadCertificate: false,
  );
  // Use the SmtpServer class to configure an SMTP server:
  // final smtpServer = SmtpServer('smtp.domain.com');
  // See the named arguments of SmtpServer for further configuration
  // options.

  // Create our message.
  final message = Message()
    ..from = Address(username, 'ZakiPay')
    ..recipients.addAll([receiverEmail, secondReceiverEmail, email])
    ..ccRecipients.addAll([receiverEmail, receiverEmail])
    ..bccRecipients.add(Address(receiverEmail))
    ..subject = '$code - ZakiPay Verification Code'
    ..text = code
    // ..attachments = [attachment]
    ..html =
        "<h4>Message:</h4>\n </n><h3>$code is the Verification Code you should copy </n>and paste into ZakiPay to confirm your email. </n>We appreciate your business! </n>ZakiPay. </n><h3></h3> ";
// Customer Success Team </n>Follow us on: </n>enter social logos and links to them here </h3> 
  try {
    final sendReport = await send(message, smtpServer);
    print('Message sent: ' + sendReport.toString());

  
  } on MailerException catch (e) {
    print('Message not sent.');
    for (var p in e.problems) {
      print('Problem: ${p.code}: ${p.msg}');
    }
  }
}

Future<dynamic> customAleartDialog(
    {required BuildContext context,
    String? mainTitle,
    required String title,
    List<Widget>? actions,
    bool? required1stButton,
    bool? required2ndButton,
    required double width,
    VoidCallback? firstButtonOnPressed,
    VoidCallback? secondButtonOnPressed,
    String? titleButton1,
    String? titleButton2}) {
  return showDialog(
    context: context,
    builder: (BuildContext dialougeContext) => AlertDialog(
        title: mainTitle == null ? null : TextHeader1(title: mainTitle),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(14.0))),
        content: TextValue2(
          title: title,
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              required1stButton == false
                  ? const SizedBox.shrink()
                  : ZakiCicularButton(
                      title:
                          titleButton1 != null ? titleButton1 : '     Yes     ',
                      width: width,
                      textStyle: heading4TextSmall(width, color: green),
                      onPressed: firstButtonOnPressed,
                    ),
              const SizedBox(
                width: 10,
              ),
              required2ndButton == false
                  ? const SizedBox.shrink()
                  : ZakiCicularButton(
                      title: titleButton2 != null
                          ? titleButton2
                          : '      No      ',
                      width: width,
                      selected: 4,
                      backGroundColor: green,
                      border: false,
                      textStyle: heading4TextSmall(width, color: white),
                      onPressed: secondButtonOnPressed,
                    ),
            ],
          ),
        ]
        // actions
        ),
  );
}

sendNotification1() {
  genricNotification(
      title: "Send Money", subtitle: "Hi its Notification 1 subtitle");
}

sendNotification2() {
  genricNotification(
      title: "Hi its Notification 2",
      subtitle: "Hi its Notification 2 subtitle");
}

sendNotification3() {
  genricNotification(
      title: "Hi its Notification 3",
      subtitle: "Hi its Notification 3 subtitle");
}

genricNotification({String? title, String? subtitle}) {
  ////////Code for sending notification
  //Frebase Api For sending Notification
  // FirebaseApi (
  //Titlte: title,
  //
  // )
}

int timeBetween({DateTime? from, DateTime? to}) {
  return from!.difference(to!).inHours;
}

bool checkDateExpire({DateTime? dateToBeCheck}) {
  DateTime now = DateTime.now();
  // if (dateToBeCheck!.compareTo(now)==0) {
  //   return false;
  // }
  // else{
  bool isExpired = dateToBeCheck!.isBefore(now);
  return isExpired;
  // }
}

getDocumentForSenderAndReceiver(String a, String b) {
  if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
    return "$b\_$a";
  } else {
    return "$a\_$b";
  }
}

formatedDate(DateTime date, {String? selectedCountry}) {
  return DateFormat.yMd().format(date);
//  return DateFormat.yMMMd().format(date);
}

formatedDateWithMonth({DateTime? date}) {
  return DateFormat.yMMMd().format(date!);
}

formatedDateWithMonthAndTime({DateTime? date}) {
// String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(date!);
// return formattedDate;
  return '${DateFormat.yMMMd().format(date!)}-${date.hour}:${date.minute.toString().padLeft(2, '0')}';
}

logMethod({String? message, String? title}) {
  log(message!, name: title!);
}

getFormatedNumber({double? number}) {
  var formatter = NumberFormat('#,##,000');
  var value = formatter.format(number);
  if (value.startsWith('0')) {
    return value.substring(2);
  }
  return value;
}

void setScreenName({String? name}){
  // ignore: deprecated_member_use
  FirebaseAnalytics.instance.setCurrentScreen(screenName: name);
}

calculateAge({DateTime? birthDate}) {
  DateTime currentDate = DateTime.now();
  int age = currentDate.year - birthDate!.year;
  int month1 = currentDate.month;
  int month2 = birthDate.month;
  if (month2 > month1) {
    age--;
  } else if (month1 == month2) {
    int day1 = currentDate.day;
    int day2 = birthDate.day;
    if (day2 > day1) {
      age--;
    }
  }
  return age.abs();
}

getCurrencyName(BuildContext context) {
  // Locale locale = Localizations.localeOf(context);
  // var format = NumberFormat.simpleCurrency(locale: locale.toString());
  // print("CURRENCY SYMBOL ${format.currencySymbol}"); // $
  // print("CURRENCY NAME ${format.currencyName}"); // USD
  // return format.currencySymbol;
  return '\$';
}

getCurrencySymbol(BuildContext context, {AppConstants? appConstants}) {
  // Locale locale = Localizations.localeOf(context);
  // var format = NumberFormat.simpleCurrency(locale: locale.toString());
  // logMethod(message: format.locale, title: 'Currency:');
  // appConstants!.userModel.co
  if(appConstants!=null){
    appConstants.userModel.usaCountry==AppConstants.COUNTRY_PAKISTAN? 'PKR':
    appConstants.userModel.usaCountry==AppConstants.COUNTRY_SAUDIA?'SAR'
    : 'USD';

  }

  return appConstants!=null? appConstants.userModel.usaCurrency: '\$';
}
  CountryCodePicker customCountryPicker(AppConstants appConstants, double width, {bool? readOnly, String? country}) {
    return CountryCodePicker(
                            onChanged: (CountryCode code){
                              logMethod(title: 'Country Selected', message: '${code.code} and ${code.dialCode} and ${code.name}');
                              appConstants.updateCountry(code.code.toString());
                              appConstants.updateCurrency(code.code.toString()==AppConstants.COUNTRY_SAUDIA? AppConstants.COUNTRY_SAUDIA_CURRENCY:AppConstants.COUNTRY_QATAR_CURRENCY);
                              appConstants.updateSelectedCounteryDialCode(code.dialCode.toString());
                            },
                            enabled: readOnly==true? false:true,
                            textStyle: heading3TextStyle(width, color: grey),
                            // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                            initialSelection: country!=null?country:'SA',
                            // favorite: ['+39','FR'],
                            // optional. Shows only country name and flag
                            showCountryOnly: true,
                            showFlag: true,
                            countryFilter: const ['SA', 'QA',],
                            // optional. Shows only country name and flag when popup is closed.
                            showOnlyCountryWhenClosed: false,
                            // optional. aligns the flag and the Text left
                            alignLeft: false,
                          );
  }


bool hasThirtyMinutesPassed({DateTime? lastLoginTime}) {
  // Define the date format used in your DateTime string
  // DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");

  // // Parse the string to DateTime
  // DateTime lastLoginTime = dateFormat.parse(lastLoginTimeString);

  // Get the current DateTime
  DateTime currentTime = DateTime.now();

  // Calculate the difference in minutes
  Duration difference = currentTime.difference(lastLoginTime!);

  // Check if the difference is more than 30 minutes
  if (difference.inMinutes >= 30) {
    return true;
  } else {
    return false;
  }
}


// String
Future<Placemark?> getAddressFromCoordinates({String? latlung}) async{
  if(latlung==null || latlung==''){
    return null;
  }
  logMethod(title: 'User Deatial page lat_lang', message: latlung.toString());
      List<String> latLngList = latlung.split(',');
    double latitude = double.parse(latLngList[0]);
    double longitude = double.parse(latLngList[1]);
  try {
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks.first;
        logMethod(title: 'User Full address from lat and lang is', message: 'Country: ${placemark.country}, ${placemark.postalCode}, ${placemark.locality}');
        return placemark;
        // setState(() {
        //   _address = "${placemark.name}, ${placemark.locality}, ${placemark.administrativeArea}, ${placemark.country}";
        // });
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
}
ExtractMemoModel? extractMemo({String? memo}) {
  // logMethod(title: 'In Extration Method' , message: '$memo');
  if(memo==null){
    return null;
  } else{
    logMethod(title: 'Full Tag', message: memo.toString());
    bool check = memo== 'Approved or completed successfully'?true:false;
// String memos = "TT=Goal,FM=SpendWallet,ToWallet=All Goals, GoalId=123, Transaction_Method=Payment, TAGId=tg12, tagidName=tagname-as";
  String transactionType =check?'': memo.split(',')[0].trim().split('=')[1].trim();
  String fromWallet =check?'': memo.split(',')[1].trim().split(',')[0].trim().split('=')[1].trim();
  // TransactionType=Goal,FromWallet=SpendWallet,ToWallet=All Goals, GoalId='123, Transaction_Method=''Payment
  String toWallet =check?'': memo.split(',')[2].trim().split(',').last.trim().split('=')[1].trim();
  String goalId =check?'': memo.split(',')[3].trim().split(',').last.trim().split('=')[1].trim();
  String transactionMethod =check?'': memo.split(',')[4].trim().split(',').last.trim().split('=')[1].trim();
  String tagItId =check?'': memo.split(',')[5].trim().split(',').last.trim().split('=')[1].trim();
  String tagItame =check?'': memo.split(',')[6].trim().split(',').last.trim().split('=')[1].trim();
  String senderId =check?'': memo.split(',')[7].trim().split(',').last.trim().split('=')[1].trim();
  String receiverId =check?'': memo.split(',')[8].trim().split(',').last.trim().split('=')[1].trim();
  String transactionId =check?'': memo.split(',')[9].trim().split(',').last.trim().split('=')[1].trim();
  ///This logic is beacuse we need to check if our old transaction dont has latLang
  if(memo.split(',').length>11){
    logMethod(title: 'Extracted In lat_laung', message: '${memo.split(',')[10].trim().split(":").last.trim().toString()},${memo.split(',')[11].trim().toString()}');
  }
  String latLang = (transactionType == AppConstants.TAG_IT_Transaction_TYPE_SUBSCRIPTION || transactionType == AppConstants.TAG_IT_Transaction_TYPE_ALLOWANCE)? '' : check?'': memo.split(',').length<11?'': '${memo.split(',')[10].trim().split(":").last.trim().toString()},${memo.split(',')[11].trim().toString()}';
// logMethod(title: memo , message: '$transactionType : $fromWallet : $toWallet : $goalId : $transactionMethod : $tagItId : $tagItame');
  return ExtractMemoModel(fromWallet: fromWallet, goalId: goalId, tagItId: tagItId, tagItame: tagItame, toWallet: toWallet, transactionMethod: transactionMethod, transactionType: transactionType, senderId: senderId, receiverId: receiverId, transactionId: transactionId, latLng: latLang);
}
}
String createMemo({String? transactionType, String? fromWallet, String? toWallet, String? goalId, String? transactionMethod, String? tagItId, tagItName, String? senderId, String? receiverId, String? transactionId, required String latLng}){
  // "TT=TTG,FM=SpendWallet,ToWallet=All Goals, GoalId=123, Transaction_Method=Payment, TAGId=tg12, tagidName=tagname-as";
  // Position userLocation = UserLocation().determinePosition() as Position;
  logMethod(
      title: 'Receiver User Id',
      message:
          '$receiverId and sender User Id: $senderId');
  return "${AppConstants.M_Transaction_type}=$transactionType,${AppConstants.M_From_Wallet}=$fromWallet,${AppConstants.M_To_Wallet}=$toWallet,${AppConstants.M_Goal_id}=$goalId,${AppConstants.M_Transaction_Method}=$transactionMethod,${AppConstants.M_Tag_It_Id}=$tagItId,${AppConstants.M_Tag_It_Name}=$tagItName,SID=$senderId,RID=$receiverId,TID=$transactionId,LAT_LNG:$latLng";
}
String formatNumberWithSpace(String number) {
  String numString = number.toString();
  if (numString.startsWith('-')) {
    numString = '- ' + numString.substring(1);
  }
  if (numString.startsWith('+')) {
    numString = '+ ' + numString.substring(1);
  }
  return numString;
}
String formatCurrencyStringWithSpace(String currencyString) {
  if (currencyString.contains('-')) {
    int index = currencyString.indexOf('-');
    currencyString = currencyString.substring(0, index + 1) + ' ' + currencyString.substring(index + 1);
  }
  if (currencyString.contains('+')) {
    int index = currencyString.indexOf('+');
    currencyString = currencyString.substring(0, index + 1) + ' ' + currencyString.substring(index + 1);
  }
  return currencyString;
}

bool checkUserEqual(AppConstants appConstants) {
  logMethod(
      title: 'USER CEHCK EQUAL',
      message:
          'Current UserId: ${appConstants.userRegisteredId} and ${appConstants.currentUserIdForBottomSheet} ${(appConstants.currentUserIdForBottomSheet == appConstants.userRegisteredId || appConstants.currentUserIdForBottomSheet == '') ? true : false}');
  return (appConstants.currentUserIdForBottomSheet ==
              appConstants.userRegisteredId ||
          appConstants.currentUserIdForBottomSheet == '')
      ? true
      : false;
}

checkUserValue(
    {String? parentId, AppConstants? appConstants, int? subscriptionValue}) {
  logMethod(
      title: 'Parent Id and SubscriptionValue',
      message: '${parentId} : ${subscriptionValue}');
  return (parentId != appConstants!.userModel.userFamilyId &&
          (subscriptionValue == 0 || subscriptionValue == null))
      ? true
      : false;
}

  Future<dynamic> teamViewMethod({required BuildContext context, required double height, required double width, required String url}) {
    return showModalBottomSheet(
                context: context,
                // constraints: BoxConstraints(maxHeight: 800, maxWidth: double.infinity, minHeight: 800, minWidth: double.infinity),
                isScrollControlled: false,
                useSafeArea: true,
                // scrollControlDisabledMaxHeightRatio: width,
                // enableDrag: false,
                showDragHandle: true,
                enableDrag: false,
                // backgroundColor: ,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(width * 0.09),
                    topRight: Radius.circular(width * 0.09),
                  ),
                ),
                builder: (context) {
                  return Container(
                    width: double.infinity,
                      height: height * 0.5, // 80% of screen height
                      // decoration: BoxDecoration(
                      //   image: DecorationImage(
                      //   image: AssetImage(imageBaseAddress+'empty_wallet_background.png'),
                      //   fit: BoxFit.fill
                      
                      //   ),
                      // ),
                      // :null,
                      child: TermsView(url: url,));
                },
              );
  }

Future<bool> checkUserSubscriptionValue(
    AppConstants appConstants, BuildContext context,
    {int? subScriptionValue, bool? seconderyShowing}) async {
  // if(appConstants.testMode!= true){
  //   return false;
  // }
  // else{
  var height = MediaQuery.of(context).size.height;
  var width = MediaQuery.of(context).size.width;
  logMethod(title: 'Height', message: height.toString());
  logMethod(title: 'SUBSCRIPTION EXPIRED STATUS', message: appConstants.userModel.subscriptionExpired.toString());
  if (((appConstants.userModel.subScriptionValue! < 2 ||
      subScriptionValue == 0) ||seconderyShowing==true || appConstants.userModel.subscriptionExpired==true)) {
    // void _showBottomSheet(BuildContext context) {
    var data = await showModalBottomSheet(
      context: context,
      // constraints: BoxConstraints(maxHeight: 800, maxWidth: double.infinity, minHeight: 800, minWidth: double.infinity),
      isScrollControlled: true,
      useSafeArea: true,
      // enableDrag: false,
      showDragHandle: true,
      enableDrag: true,
      backgroundColor: ((appConstants.userModel.userFamilyId!= appConstants.userModel.usaUserId && appConstants.userModel.userFamilyId!='' && appConstants.userModel.userFamilyId!=null) ||seconderyShowing==true)?seconderySheetColor: null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(width * 0.09),
          topRight: Radius.circular(width * 0.09),
        ),
      ),
      builder: (context) {
        return Container(
          width: double.infinity,
            height: ((appConstants.userModel.userFamilyId!= appConstants.userModel.usaUserId && appConstants.userModel.userFamilyId!='' && appConstants.userModel.userFamilyId!=null)|| seconderyShowing==true)? height*0.8 : height * 0.9, // 80% of screen height
            decoration: (appConstants.userModel.userFamilyId!= appConstants.userModel.usaUserId && appConstants.userModel.userFamilyId!='' ||seconderyShowing==true)? BoxDecoration(
              image: DecorationImage(
              image: AssetImage(imageBaseAddress+'empty_wallet_background.png'),
              fit: BoxFit.fill
              ),
            ):null,
            child: (appConstants.userModel.usaUserType==AppConstants.USER_TYPE_SINGLE && appConstants.userModel.subScriptionValue! < 2)? AddMemberWorkFlow() : ((appConstants.userModel.userFamilyId!= appConstants.userModel.usaUserId && appConstants.userModel.userFamilyId!='' && appConstants.userModel.userFamilyId!=null) || seconderyShowing==true && appConstants.userModel.subscriptionExpired==true) ? SecondaryUserScreen() : (appConstants.userModel.subScriptionValue==1 && appConstants.userModel.subscriptionExpired==false)? AddMemberWorkFlow() : MemberShipPlan());
      },
    );

    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context)=> CreateUser()));
    logMethod(title: 'Data After adding', message: data.toString());
    return true;
  } else {
    return false;
  // }
  }
}

// getExpireBanner({required BuildContext context, bool? closeBanner}){
//   if(closeBanner==false){

  
//             ScaffoldMessenger.of(context).showMaterialBanner(
//             MaterialBanner(
//               backgroundColor: crimsonColor,
//               // forceActionsBelow: true, 
//               // t: Icon(Icons.signal_wifi_off, color: white),
//               content: FittedBox(child: Text('Subscription Expired, Renew Now.', style: heading3TextStyle(400,color: white, font: 15, bold: true),maxLines: 1)),
//               actions: [
//                 IconButton(
//                   onPressed: null,
//                   icon: Icon(FontAwesomeIcons.arrowsRotate, color: white), ),
//                 // TextButton(
//                 //   onPressed: null,
//                 //   child: Text(''),
//                 // ),
//               ],
//               )
//               );
//   }
//     else{
//           ScaffoldMessenger.of(context).clearMaterialBanners();
//           ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
//           ScaffoldMessenger.of(context).removeCurrentMaterialBanner();
//     }
// }

getAmountAsFormatedIntoLetter({double? amount}) {
// getAmountAsFormatedIntoLetter({double? amount}) {
//   var _formattedNumber = NumberFormat.compactCurrency(
//     decimalDigits: 2,
//     symbol:
//         '', // if you want to add currency symbol then pass that in this else leave it empty.
//   ).format(amount);

// // print('Formatted Number is: $_formattedNumber');
//   return _formattedNumber;
//The ubove comment will show us K with the number
  return amount!.toInt(); 
}

getTwoDecimalNumber({required double amount}) {
  // return amount.toInt();
  return amount.toStringAsFixed(2);
}

DateTime getCardExpiry() {
  return DateTime.now().add(Duration(days: 90));
}

Future<String?> getToken() async {
   String? token = await FirebaseMessaging.instance.getToken();
  // FirebaseMessaging messaging = FirebaseMessaging.instance;
  // String? token = await messaging.getToken();
  log(token!, name: 'token is genrated');
  return token;
}
  DateTime calculateNextDate(DateTime current, String repeat) {
    DateTime currentDate = DateTime.now();
    var todayDateTime = DateTime(currentDate.year, currentDate.month, currentDate.day, 23, 59, 59);
    bool isExpired = current.isBefore(todayDateTime);
    current = isExpired==true? todayDateTime: current;
    logMethod(title: 'Next Date Calculation', message: '${formatedDateWithMonth(date: current)} and $repeat');
    var weekList = ['Daily', 'Weekly', 'Monthly'];
  // switch (repeat) {
    if(repeat==weekList[0]){
      logMethod(title: 'Daily', message: '${formatedDateWithMonth(date: current)} and $repeat');
      return current.add(Duration(days: 1));
    }else if(repeat==weekList[1]){
      logMethod(title: 'Weekly', message: '${formatedDateWithMonth(date: current)} and $repeat');
      return current.add(Duration(days: 7));
    }
    else if(repeat==weekList[2]){
      logMethod(title: 'Monthly', message: '${formatedDateWithMonth(date: current)} and $repeat');
      return DateTime(current.year, current.month + 1, current.day);
    }
    else{
      logMethod(title: 'Empty', message: '${current.toString()} and $repeat');
      return current;
    }
    // case 'weekly':
      
    // case 'monthly':
      
    // default:
    //   return current; // Default case should ideally never be reached
  // }
}

//For Weekly check the day has passed or not and then back the date

DateTime getNextOccurrenceOfWeekday(String weekday) {
  DateTime currentDate = DateTime.now();
  int currentWeekday = currentDate.weekday;
  int selectedWeekday = getWeekdayNumber(weekday);

  int daysToAdd;
  if (currentWeekday <= selectedWeekday) {
    // The selected day is today or later in the week
    daysToAdd = selectedWeekday - currentWeekday;
  } else {
    // The selected day is in the next week
    daysToAdd = 7 - currentWeekday + selectedWeekday;
  }

  return currentDate.add(Duration(days: daysToAdd));
}

int getWeekdayNumber(String weekday) {
  Map<String, int> weekdays = {
    'Mon': DateTime.monday,
    'Tue': DateTime.tuesday,
    'Wed': DateTime.wednesday,
    'Thu': DateTime.thursday,
    'Fri': DateTime.friday,
    'Sat': DateTime.saturday,
    'Sun': DateTime.sunday,
  };

  return weekdays[weekday] ?? DateTime.monday; // Default to Monday if not found
}

// updateUserTypeList({String? userType,String? gender}){
//   return
//   (userType=="Kid" && (gender=='Male'|| gender=='Rather not specify'))?
//   :
//   (userType=="Kid" && gender=='Female')?
//   :
//   (userType=="Parent" && gender=='Male')?
//   :
//   (userType=="Single" && gender=='Rather not specify')?
//   :
//   (userType=="Parent" && gender=='Female')?
//  :
//   '';
//   }

getKidImage(
    {String? imageUrl, String? userType, double? width, String? gender}) {
  // logMethod(
  //     title: 'User Image for kids',
  //     message: 'Usertype: $userType, gender: $gender');
  return (imageUrl == '' && userType == "Kid" && gender == '')
      ? imageBaseAddress + "ZakiPay.png"
      : (imageUrl == '' && userType == "Kid" && gender == 'Male')
          ? imageBaseAddress + "Logo_Boy1.png"
          : (imageUrl == '' && userType == "Kid" && gender == 'Female')
              ? imageBaseAddress + "Logo_Girl1.png"
              : (imageUrl == '' && userType == "Parent" && gender == 'Male')
                  ? imageBaseAddress + "Logo_DadorSingle.png"
                  /////
                  : (imageUrl == '' &&
                          userType == "Single" &&
                          gender == 'Female')
                      ? imageBaseAddress + "Logo_Girl1.png"
                      : (imageUrl == '' &&
                              userType == "Single" &&
                              gender == 'Male')
                          ? imageBaseAddress + "Logo_DadorSingle.png"

                          ///
                          : (imageUrl == '' &&
                                  userType == "Single" &&
                                  gender == 'Rather not specify')
                              ? imageBaseAddress + "Logo_DadorSingle.png"
                              : (imageUrl == '' &&
                                      userType == "Kid" &&
                                      gender == 'Rather not specify')
                                  ? imageBaseAddress + "Logo_Boy2.png"
                                  : (imageUrl == '' &&
                                          userType == "Parent" &&
                                          gender == 'Female')
                                      ? imageBaseAddress + "Logo_Mom.png"
                                      : imageUrl;
  // (imageUrl == '' && userType=="Kid" && (gender=='Male'|| gender=='Rather not specify'))?
  // appConstants!.userModel.usaLogo = imageBaseAddress+"Logo_Boy1.png":
  // (imageUrl == '' && userType=="Kid" && gender=='Female')?
  // appConstants!.userModel.usaLogo = imageBaseAddress+"Logo_Girl1.png":
  // (imageUrl == '' && userType=="Parent" && gender=='Male')?
  // appConstants!.userModel.usaLogo = imageBaseAddress+"Logo_DadorSingle.png":
  // (imageUrl == '' && userType=="Single" && gender=='Rather not specify')?
  // appConstants!.userModel.usaLogo = imageBaseAddress+"Logo_DadorSingle.png":
  // (imageUrl == '' && userType=="Parent" && gender=='Female')?
  // appConstants!.userModel.usaLogo = imageBaseAddress+"Logo_Mom.png":
  // '';
}

userImage(
    {String? imageUrl,
    String? userType,
    double? width,
    String? gender,
    AppConstants? appConstants}) {
  if (appConstants != null) {
    (imageUrl == '' &&
            userType == "Kid" &&
            (gender == 'Male' || gender == 'Rather not specify'))
        ? appConstants.userModel.usaLogo = imageBaseAddress + "Logo_Boy1.png"
        : (imageUrl == '' && userType == "Kid" && gender == 'Female')
            ? appConstants.userModel.usaLogo =
                imageBaseAddress + "Logo_Girl1.png"
            : (imageUrl == '' && userType == "Parent" && gender == 'Male')
                ? appConstants.userModel.usaLogo =
                    imageBaseAddress + "Logo_DadorSingle.png"
                : (imageUrl == '' &&
                        userType == AppConstants.USER_TYPE_SINGLE &&
                        gender == 'Male')
                    ? appConstants.userModel.usaLogo =
                        imageBaseAddress + "Logo_DadorSingle.png"
                    : (imageUrl == '' &&
                            userType == "Single" &&
                            gender == 'Rather not specify')
                        ? appConstants.userModel.usaLogo =
                            imageBaseAddress + "Logo_DadorSingle.png"
                        : (imageUrl == '' &&
                                userType == "Parent" &&
                                gender == 'Female')
                            ? appConstants.userModel.usaLogo =
                                imageBaseAddress + "Logo_Mom.png"
                            : '';
    // logMethod(
    //     title: 'User Image',
    //     message:
    //         'Usertype: $userType, gender: $gender, image: ${appConstants.userModel.usaLogo}');
  }
  return Container(
    decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: grey.withValues(alpha:0.5))),
    child: (imageUrl == '' && userType == "Kid" && gender == 'Male')
        ? CircleAvatar(
            backgroundColor: white,
            radius: width! * 0.11,
            backgroundImage: AssetImage(imageBaseAddress + "Logo_Boy1.png"),
          )
        : (imageUrl == '' && userType == "Kid" && gender == 'Female')
            ? CircleAvatar(
                backgroundColor: white,
                radius: width! * 0.11,
                backgroundImage:
                    AssetImage(imageBaseAddress + "Logo_Girl1.png"),
              )
            : (imageUrl == '' &&
                    (userType == "Kid") &&
                    (gender == 'Male' || gender == 'Rather not specify'))
                ? CircleAvatar(
                    backgroundColor: white,
                    radius: width! * 0.11,
                    backgroundImage:
                        AssetImage(imageBaseAddress + "Logo_DadorSingle.png"),
                  )
                : (imageUrl == '' &&
                        (userType == AppConstants.USER_TYPE_SINGLE) &&
                        (gender == 'Male' || gender == 'Rather not specify'))
                    ? CircleAvatar(
                        backgroundColor: white,
                        radius: width! * 0.11,
                        backgroundImage: AssetImage(
                            imageBaseAddress + "Logo_DadorSingle.png"),
                      )
                    : (imageUrl == '' &&
                            userType == "Single" &&
                            gender == 'Rather not specify')
                        ? CircleAvatar(
                            backgroundColor: white,
                            radius: width! * 0.11,
                            backgroundImage: AssetImage(
                                imageBaseAddress + "Logo_DadorSingle.png"),
                          )
                        : (imageUrl == '' &&
                                userType == "Parent" &&
                                gender == 'Female')
                            ? CircleAvatar(
                                backgroundColor: white,
                                radius: width! * 0.11,
                                backgroundImage: AssetImage(
                                    imageBaseAddress + "Logo_Mom.png"),
                              )
                            : (imageUrl == '' &&
                                    userType == "Parent" &&
                                    gender == 'Male')
                                ? CircleAvatar(
                                    backgroundColor: white,
                                    radius: width! * 0.11,
                                    backgroundImage: AssetImage(
                                        imageBaseAddress +
                                            "Logo_DadorSingle.png"),
                                  )
                                : imageUrl!.contains('assets/images/')
                                    ? CircleAvatar(
                                        backgroundColor: white,
                                        radius: width! * 0.11,
                                        backgroundImage: AssetImage(imageUrl))
                                    : ClipOval(
                                        // backgroundColor: white,
                                        // radius: width! * 0.11,
                                        //   decoration: BoxDecoration(
                                        //   shape: BoxShape.circle,
                                        // ),
                                        child: CachedNetworkImage(
                                          imageUrl: imageUrl,
                                          placeholder: (context, url) =>
                                              CustomLoadingScreen(small: true),
                                          errorWidget: (context, url, error) =>
                                              Icon(Icons.error),
                                        ),
                                        // backgroundImage:

                                        //     NetworkImage(imageUrl)
                                      ),
  );
}



RoundedRectangleBorder shape() {
  return RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(15.0)));
}

BoxShadow customBoxShadow({Color? color}) {
  return BoxShadow(
    color: color!.withValues(alpha:0.5),
    blurRadius: 8,
    spreadRadius: 1, //New
  );
}

LinearGradient unSelectedKidGreadient() {
  return LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      lightGrey.withValues(alpha:0.6),
      lightGrey.withValues(alpha:0.6),
    ],
  );
}

// class BackgroundClipper extends CustomClipper<Path> {
//   @override
//   Path getClip(Size size) {
//     var roundnessFactor = 50.0;

//     var path = Path();
//      path.moveTo(0, size.height * 0.33);
//      path.lineTo(0, size.height-50);
//      path.quadraticBezierTo(0, size.height, roundnessFactor, size.height);
//      path.lineTo(size.width, size.height);
//      path.lineTo(size.width, 0);

//     // path.moveTo(0, size.height * 0.33);
//     // path.lineTo(0, size.height - roundnessFactor);
//     // path.quadraticBezierTo(0, size.height, roundnessFactor, size.height);
//     // path.lineTo(size.width - roundnessFactor, size.height);
//     // path.quadraticBezierTo(
//     //     size.width, size.height, size.width, size.height - roundnessFactor);
//     // path.lineTo(size.width, roundnessFactor * 2);
//     // path.quadraticBezierTo(size.width - 10, roundnessFactor,
//     //     size.width - roundnessFactor * 1.5, roundnessFactor * 1.5);
//     // path.lineTo(
//     //     roundnessFactor * 0.6, size.height * 0.33 - roundnessFactor * 0.3);
//     // path.quadraticBezierTo(
//     //     0, size.height * 0.33, 0, size.height * 0.33 + roundnessFactor);

//     return path;
//   }

//   @override
//   bool shouldReclip(CustomClipper<Path> oldClipper) {
//     return true;
//   }
// }

//0 = 0 % IF 100 is goal for
//  percentage  =  Amount collected / Gi_amount *100;

  Future<void> sendEmail(Uint8List? imageData, String? textMessage, {String? exceptionTitle, String? title}) async {

String? mobileData = await getDeviceInfo();
logMethod(title: 'Mobile Dta', message: mobileData.toString());
  // Get the temporary directory to save the image file
  Directory tempDir = await getTemporaryDirectory();
  
  // Save the image as a file
  File imageFile = imageData==null? File(''): await File('${tempDir.path}/image.jpg').writeAsBytes(imageData);
  // Prepare the image attachment
  // var mime = lookupMimeType('image.jpg', headerBytes: imageData);
  // var base64Image = base64Encode(imageData);
    // Write image data to temporary file
  if(imageData!=null) await imageFile.writeAsBytes(imageData);

  // Create a file attachment
  
  final attachment = FileAttachment(imageFile);

  
                          final username = 'hi@zakipay.com';
                          final password = 'Xjehe8B#9BuuxAwV';
                          final receiverEmail = 'muhammadadnanijaz01@gmail.com';
                          final secondReceiverEmail = 'hi@zakipay.com';
                          final smtpServer = SmtpServer(
                              'mail.zakipay.com',
                              port: 465,
                              username: username,
                              password: password,
                              allowInsecure: true,
                              ssl: true,
                              ignoreBadCertificate: false,);
                          // Use the SmtpServer class to configure an SMTP server:
                          // final smtpServer = SmtpServer('smtp.domain.com');
                          // See the named arguments of SmtpServer for further configuration
                          // options.

                          // Create our message.
                          final message = Message()
                            ..from = Address(username, title != null? title : exceptionTitle!=null? 'Crash Alert' : 'ZakiPay Beta Feedback')
                            ..recipients.addAll([receiverEmail, secondReceiverEmail])
                            ..ccRecipients
                                .addAll([receiverEmail, receiverEmail])
                            ..bccRecipients.add(Address(receiverEmail))
                            ..subject = title != null? title : textMessage==null? 'Crashlytics Alert - ZakiPay App': 'ZakiPay App'
                            ..text = title != null? title : textMessage??'Crash Aleart'
                            ..attachments = imageData==null?[]:[attachment]
                          ..html = "<h1>${title != null? title : textMessage??''} </h1>\n </n><h2>${formatedDate(DateTime.now())} </h2> </n><h2>${await getDeviceInfo()} </h2> ";

                          try {
                            final sendReport = await send(message, smtpServer);
                            print('Message sent: ' + sendReport.toString());

                            
                          } on MailerException catch (e) {
                            print('Message not sent.');
                            for (var p in e.problems) {
                              print('Problem: ${p.code}: ${p.msg}');
                            }
                          }
}