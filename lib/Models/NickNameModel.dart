// To parse this JSON data, do
//
//     final userModel = userModelFromMap(jsonString);

// ignore_for_file: file_names

import 'dart:convert';

import 'package:zaki/Constants/AppConstants.dart';

NickNameModel nickNameModelFromMap(Map<dynamic, dynamic> str) => NickNameModel.fromMap(str);

String nickNameModelToMap(NickNameModel data) => json.encode(data.toMap());

class NickNameModel {
    NickNameModel({
        this.NickN_TopFriends,
        this.NickN_SpendWallet,
        this.NickN_DonationWallet,
        this.NickN_SavingWallet,
        this.created_at
    });

    String? NickN_TopFriends;
    String? NickN_SpendWallet;
    String? NickN_DonationWallet;
    String? NickN_SavingWallet;
    DateTime? created_at;

    factory NickNameModel.fromMap(Map<dynamic, dynamic> json) => NickNameModel(
        NickN_TopFriends: json[AppConstants.TopFriends_Name ],
        NickN_SpendWallet: json[AppConstants.SpendWallet_Name],
        NickN_DonationWallet: json[AppConstants.DonationWallet_Name],
        NickN_SavingWallet: json[AppConstants.SavingWallet_Name],
        created_at: json[AppConstants.createdAt].toDate(),
    );

    Map<String, dynamic> toMap() => {
        AppConstants.TopFriends_Name: NickN_TopFriends,
        AppConstants.SpendWallet_Name: NickN_SpendWallet,
        AppConstants.DonationWallet_Name: NickN_DonationWallet,
        AppConstants.SavingWallet_Name: NickN_SavingWallet,
        AppConstants.createdAt: created_at,
    
    };
}
