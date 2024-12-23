// To parse this JSON data, do
//
//     final userModel = userModelFromMap(jsonString);

// ignore_for_file: file_names

import 'dart:convert';

import 'package:zaki/Constants/AppConstants.dart';

FundMeWalletModel fundMeWalletModelFromMap(Map<dynamic, dynamic> str) => FundMeWalletModel.fromMap(str);

String fundMeWalletModelToMap(FundMeWalletModel data) => json.encode(data.toMap());

class FundMeWalletModel {
    FundMeWalletModel({
        this.FM_WALLET_userId,
        this.FM_WALLET_cardHolderName,
        this.FM_WALLET_cardStatus,
        this.FM_WALLET_card_number,
        this.FM_WALLET_expiryDate,
        this.FM_WALLET_createdAt
    });

    String? FM_WALLET_userId;
    String? FM_WALLET_cardHolderName;
    bool? FM_WALLET_cardStatus;
    String? FM_WALLET_card_number;
    DateTime? FM_WALLET_createdAt;
    String? FM_WALLET_expiryDate;

    factory FundMeWalletModel.fromMap(Map<dynamic, dynamic> json) => FundMeWalletModel(
        FM_WALLET_userId: json[AppConstants.FM_WALLET_userId ],
        FM_WALLET_cardHolderName: json[AppConstants.FM_WALLET_cardHolderName],
        FM_WALLET_cardStatus: json[AppConstants.FM_WALLET_cardStatus],
        FM_WALLET_card_number: json[AppConstants.FM_WALLET_card_number],
        FM_WALLET_createdAt: json[AppConstants.FM_WALLET_createdAt].toDate(),
        FM_WALLET_expiryDate: json[AppConstants.FM_WALLET_expiryDate],
    );

    Map<String, dynamic> toMap() => {
        AppConstants.FM_WALLET_userId: FM_WALLET_userId,
        AppConstants.FM_WALLET_cardHolderName: FM_WALLET_cardHolderName,
        AppConstants.FM_WALLET_cardStatus: FM_WALLET_cardStatus,
        AppConstants.FM_WALLET_card_number: FM_WALLET_card_number,
        AppConstants.FM_WALLET_createdAt: FM_WALLET_createdAt,
        AppConstants.FM_WALLET_expiryDate: FM_WALLET_expiryDate,
    
    };
}
