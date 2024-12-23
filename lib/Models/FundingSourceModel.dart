// To parse this JSON data, do
//
//     final fundingSourceModel = fundingSourceModelFromMap(jsonString);

import 'dart:convert';

FundingSourceModel fundingSourceModelFromMap(String str) => FundingSourceModel.fromMap(json.decode(str));

String fundingSourceModelToMap(FundingSourceModel data) => json.encode(data.toMap());

class FundingSourceModel {
    String name;
    bool active;
    String token;
    DateTime createdTime;
    DateTime lastModifiedTime;
    String account;

    FundingSourceModel({
        required this.name,
        required this.active,
        required this.token,
        required this.createdTime,
        required this.lastModifiedTime,
        required this.account,
    });

    factory FundingSourceModel.fromMap(Map<String, dynamic> json) => FundingSourceModel(
        name: json["name"],
        active: json["active"],
        token: json["token"],
        createdTime: DateTime.parse(json["created_time"]),
        lastModifiedTime: DateTime.parse(json["last_modified_time"]),
        account: json["account"],
    );

    Map<String, dynamic> toMap() => {
        "name": name,
        "active": active,
        "token": token,
        "created_time": createdTime.toIso8601String(),
        "last_modified_time": lastModifiedTime.toIso8601String(),
        "account": account,
    };
}
