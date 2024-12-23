// To parse this JSON data, do
//
//     final userModel = userModelFromMap(jsonString);

// ignore_for_file: file_names

import 'dart:convert';

import 'package:zaki/Constants/AppConstants.dart';
import 'package:zaki/Constants/envUserConstants.dart';

UserModel userModelFromMap(Map<dynamic, dynamic> str) => UserModel.fromMap(str);

String userModelToMap(UserModel data) => json.encode(data.toMap());

class UserModel {
  UserModel(
      {this.usaPassword,
      this.userFamilyId,
      this.usaUserType,
      this.usaSavingsWallet,
      this.usaMainWallet,
      this.usaCharityWallet,
      this.usaUserName,
      this.usaIsEmailVerified,
      this.usaFirstName,
      this.usaGender,
      this.usaMethod,
      this.usaLatLng,
      this.usaEmail,
      this.usaPinCode,
      this.usaTouchEnable,
      this.usaDob,
      this.usaNotificationStatus,
      this.usaLastName,
      this.usaCurrency,
      this.usaLocationStatus,
      this.usaPhoneNumber,
      this.usaPinCodeLength,
      this.usaPinEnable,
      this.usaCity,
      this.usaCreatedAt,
      this.usaCountry,
      this.usaUserId,
      this.deviceList,
      // this.invitedList,
      this.usaIsenable,
      this.usaBackgroundImageUrl,
      this.usaLogo,
      this.deviceToken,
      this.isUserPinUser,
      this.kidEnabled,
      this.zipCode,
      this.seeKids,
      this.userFullyRegistered,
      this.emailVerfied,
      this.userState,
      this.userTokenId,
      this.subScriptionValue,
      this.usaLegalFirstName,
      this.usaLegalLastName,
      this.anniverasryDate,
      this.subscriptionExpired,
      this.userBlockTime,
      this.pincodeSetupDateTime,
      this.userLastLoginDatetime
      });

  String? usaPassword;
  String? userFamilyId;
  String? usaUserType;
  List<UsaSavingsWallet>? usaSavingsWallet;
  List<UsaMainWallet>? usaMainWallet;
  List<UsaCharityWallet>? usaCharityWallet;
  String? usaUserName;
  bool? usaIsEmailVerified;
  String? usaFirstName;
  String? usaLegalFirstName;
  String? usaLegalLastName;
  String? usaGender;
  String? usaMethod;
  String? usaLatLng;
  String? usaEmail;
  String? usaPinCode;
  bool? usaTouchEnable;
  bool? usaIsenable;
  String? usaDob;
  String? anniverasryDate;
  bool? usaNotificationStatus;
  String? usaLastName;
  String? usaCurrency;
  bool? usaLocationStatus;
  String? usaPhoneNumber;
  int? usaPinCodeLength;
  bool? usaPinEnable;
  String? usaCity;
  DateTime? usaCreatedAt;
  String? usaCountry;
  String? usaUserId;
  String? usaLogo;
  String? usaBackgroundImageUrl;
  bool? isUserPinUser;
  String? deviceToken;
  String? userTokenId;
  String? zipCode;
  bool? kidEnabled;
  List<dynamic>? deviceList;
  // List<UserInvited>? invitedList;
  bool? seeKids;
  bool? userFullyRegistered;
  bool? emailVerfied;
  String? userState;
  int? subScriptionValue;
  bool? subscriptionExpired;
  DateTime? userBlockTime;
  DateTime? pincodeSetupDateTime;
  DateTime? userLastLoginDatetime;

  factory UserModel.fromMap(Map<dynamic, dynamic> json) => UserModel(
        usaPassword: json[AppConstants.USER_password],
        isUserPinUser: json[AppConstants.USER_IsUserPin],
        userFamilyId: json[AppConstants.USER_Family_Id],
        usaUserType: json[AppConstants.USER_UserType],
        // usaSavingsWallet: List<UsaSavingsWallet>.from(
        //     json[AppConstants.USER_Savings_wallet]
        //         .map((x) => UsaSavingsWallet.fromMap(x))),
        // usaMainWallet: List<UsaMainWallet>.from(
        //     json[AppConstants.USER_Main_Wallet]
        //         .map((x) => UsaMainWallet.fromMap(x))),
        // usaCharityWallet: List<UsaCharityWallet>.from(
        //     json[AppConstants.USER_Donate_wallet]
        //         .map((x) => UsaCharityWallet.fromMap(x))),
        usaUserName: json[AppConstants.USER_user_name]  ?? EnvUserConstants.USER_user_name_Const,
        usaIsEmailVerified: json[AppConstants.USER_isEmailVerified] ?? 'Default gender',
        usaFirstName: json[AppConstants.USER_first_name] ?? 'Default gender',
        usaLegalFirstName: json[AppConstants.USER_legalfirst_name] ?? 'Default gender',
        usaLegalLastName: json[AppConstants.USER_legallast_name] ?? 'Default gender',
        usaIsenable: json[AppConstants.NewMember_isEnabled] ?? 'Default gender',
        usaGender: json[AppConstants.USER_gender] ?? 'Default gender',
        usaMethod: json[AppConstants.USER_SignUp_Method],
        usaLatLng: json[AppConstants.USER_lat_lng] ??'Default latlng',
        usaEmail: json[AppConstants.USER_email]??'Default email',
        usaPinCode: json[AppConstants.USER_pin_code]??'Default' ,
        usaTouchEnable: json[AppConstants.USER_TouchID_isEnabled],
        usaDob: json[AppConstants.USER_dob],
        anniverasryDate: json[AppConstants.USER_wedding_anniversary],
        usaNotificationStatus: json[AppConstants.USER_Notification_isEnabled],
        usaLastName: json[AppConstants.USER_last_name],
        usaCurrency: json[AppConstants.USER_currency],
        usaLocationStatus: json[AppConstants.USER_Location_isEnabled],
        usaPhoneNumber: json[AppConstants.USER_phone_number],
        usaPinCodeLength: json[AppConstants.USER_pin_code_length],
        usaPinEnable: json[AppConstants.USER_pin_enable],
        usaCity: json[AppConstants.USER_city],
        userTokenId: json[AppConstants.USER_BankAccountID],
        usaCreatedAt: json[AppConstants.USER_created_at].toDate(),
        usaCountry: json[AppConstants.USER_country],
        usaUserId: json[AppConstants.USER_UserID],
        usaLogo: json[AppConstants.USER_Logo],
        zipCode: json[AppConstants.USER_zip_code],
        deviceToken: json[AppConstants.USER_iNApp_NotifyToken],
        kidEnabled: json[AppConstants.NewMember_kid_isEnabled],
        seeKids: json[AppConstants.USER_See_Kids],
        userFullyRegistered: json[AppConstants.USER_Fully_Registered]??EnvUserConstants.USER_Fully_Registered_Const,
        emailVerfied: json[AppConstants.USER_email_verified_status],
        userState: json[AppConstants.USER_State],
        subScriptionValue: json[AppConstants.USER_SubscriptionValue],
        usaBackgroundImageUrl: json[AppConstants.USER_background_image_url],
        subscriptionExpired: json[AppConstants.SubscriptionExpired],
        userBlockTime: json.containsKey(AppConstants.USER_Block_Time)
          ? json[AppConstants.USER_Block_Time]==null?null:json[AppConstants.USER_Block_Time].toDate()
          : null, // Use null if the key doesn't exist,
        userLastLoginDatetime: json.containsKey(AppConstants.USER_LAST_LOGIN_DATE_TIME)
          ? json[AppConstants.USER_LAST_LOGIN_DATE_TIME]==null?null:json[AppConstants.USER_LAST_LOGIN_DATE_TIME].toDate()
          : null, // Use null if the key doesn't exist,
        pincodeSetupDateTime: json.containsKey(AppConstants.USER_PIN_CODE_SETUP_DATE_TIME)
          ? json[AppConstants.USER_PIN_CODE_SETUP_DATE_TIME]==null?null:json[AppConstants.USER_PIN_CODE_SETUP_DATE_TIME].toDate()
          : null, // Use null if the key doesn't exist,
        deviceList:
            List<dynamic>.from(json[AppConstants.device_list].map((x) => x)),
        // invitedList: List<UserInvited>.from(json[AppConstants.USER_contacts]
        //     .map((x) => UserInvited.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        AppConstants.USER_IsUserPin: isUserPinUser,
        AppConstants.USER_password: usaPassword,
        AppConstants.USER_Family_Id: userFamilyId,
        AppConstants.USER_UserType: usaUserType,
        // AppConstants.USER_Savings_wallet:
        //     List<dynamic>.from(usaSavingsWallet!.map((x) => x.toMap())),
        // AppConstants.USER_Main_Wallet:
        //     List<dynamic>.from(usaMainWallet!.map((x) => x.toMap())),
        // AppConstants.USER_Donate_wallet:
        //     List<dynamic>.from(usaCharityWallet!.map((x) => x.toMap())),
        AppConstants.USER_user_name: usaUserName,
        AppConstants.USER_isEmailVerified: usaIsEmailVerified,
        AppConstants.USER_first_name: usaFirstName,
        AppConstants.USER_legalfirst_name: usaLegalFirstName,
        AppConstants.USER_legallast_name: usaLegalLastName,
        AppConstants.USER_gender: usaGender,
        AppConstants.USER_SignUp_Method: usaMethod,
        AppConstants.USER_lat_lng: usaLatLng,
        AppConstants.USER_email: usaEmail,
        AppConstants.USER_pin_code: usaPinCode,
        AppConstants.USER_TouchID_isEnabled: usaTouchEnable,
        AppConstants.USER_dob: usaDob,
        AppConstants.USER_wedding_anniversary : anniverasryDate,
        AppConstants.NewMember_isEnabled: usaIsenable,
        AppConstants.USER_Notification_isEnabled: usaNotificationStatus,
        AppConstants.USER_last_name: usaLastName,
        AppConstants.USER_currency: usaCurrency,
        AppConstants.USER_Location_isEnabled: usaLocationStatus,
        AppConstants.USER_phone_number: usaPhoneNumber,
        AppConstants.USER_pin_code_length: usaPinCodeLength,
        AppConstants.USER_pin_enable: usaPinEnable,
        AppConstants.USER_city: usaCity,
        AppConstants.USER_created_at: usaCreatedAt,
        AppConstants.USER_country: usaCountry,
        AppConstants.USER_UserID: usaUserId,
        AppConstants.USER_background_image_url: usaBackgroundImageUrl,
        AppConstants.USER_Logo: usaLogo,
        AppConstants.USER_iNApp_NotifyToken: deviceToken,
        AppConstants.USER_zip_code: zipCode,
        AppConstants.NewMember_kid_isEnabled: kidEnabled,
        AppConstants.USER_See_Kids: seeKids,
        AppConstants.USER_Fully_Registered : userFullyRegistered,
        AppConstants.USER_email_verified_status: emailVerfied,
        AppConstants.USER_State: userState,
        AppConstants.USER_SubscriptionValue: subScriptionValue,
        AppConstants.USER_BankAccountID:userTokenId,
        AppConstants.SubscriptionExpired: subscriptionExpired,
        AppConstants.USER_Block_Time: userBlockTime,
        AppConstants.device_list: List<dynamic>.from(deviceList!.map((x) => x)),
        // AppConstants.USER_contacts:
        //     List<dynamic>.from(invitedList!.map((x) => x.toMap())),
      };
}

class UsaCharityWallet {
  UsaCharityWallet({
    this.updatedAt,
    this.walletBalance,
    this.charityAccountNickName,
  });

  DateTime? updatedAt;
  String? walletBalance;
  String? charityAccountNickName;

  factory UsaCharityWallet.fromMap(Map<String, dynamic> json) =>
      UsaCharityWallet(
        updatedAt: json[AppConstants.updated_at].toDate(),
        walletBalance: json[AppConstants.wallet_balance],
        charityAccountNickName: json[AppConstants.Donate_account_nick_name],
      );

  Map<String, dynamic> toMap() => {
        AppConstants.USER_created_at: updatedAt,
        AppConstants.wallet_balance: walletBalance,
        AppConstants.Donate_account_nick_name: charityAccountNickName,
      };
}

class UsaMainWallet {
  UsaMainWallet({
    this.updatedAt,
    this.walletBalance,
    this.mainAccountNickName,
  });

  DateTime? updatedAt;
  String? walletBalance;
  String? mainAccountNickName;

  factory UsaMainWallet.fromMap(Map<String, dynamic> json) => UsaMainWallet(
        updatedAt: json[AppConstants.updated_at].toDate(),
        walletBalance: json[AppConstants.wallet_balance],
        mainAccountNickName: json[AppConstants.main_account_nick_name],
      );

  Map<String, dynamic> toMap() => {
        AppConstants.updated_at: updatedAt,
        AppConstants.wallet_balance: walletBalance,
        AppConstants.main_account_nick_name: mainAccountNickName,
      };
}

class UsaSavingsWallet {
  UsaSavingsWallet({
    this.updatedAt,
    this.walletBalance,
    this.savingAccountNickName,
  });

  DateTime? updatedAt;
  String? walletBalance;
  String? savingAccountNickName;

  factory UsaSavingsWallet.fromMap(Map<String, dynamic> json) =>
      UsaSavingsWallet(
        updatedAt: json[AppConstants.updated_at].toDate(),
        walletBalance: json[AppConstants.wallet_balance],
        savingAccountNickName: json[AppConstants.saving_account_nick_name],
      );

  Map<String, dynamic> toMap() => {
        AppConstants.updated_at: updatedAt,
        AppConstants.wallet_balance: walletBalance,
        AppConstants.saving_account_nick_name: savingAccountNickName,
      };
}

// class UserInvited {
//   UserInvited({this.number, this.status, this.isFavorite});

//   String? number;
//   bool? status;
//   bool? isFavorite;

//   factory UserInvited.fromMap(Map<String, dynamic> json) => UserInvited(
//       number: json[AppConstants.USER_contact_invitedphone],
//       status: json[AppConstants.USER_invited_signedup],
//       isFavorite: json[AppConstants.USER_IsFavorite]);

//   Map<String, dynamic> toMap() => {
//         AppConstants.USER_contact_invitedphone: number,
//         AppConstants.USER_invited_signedup: status,
//         AppConstants.USER_IsFavorite: isFavorite
//       };

//   contains(String number) {}
// }
