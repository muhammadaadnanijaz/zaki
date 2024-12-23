// To parse this JSON data, do
//
//     final paymentModel = paymentModelFromMap(jsonString);

import 'dart:convert';

PaymentModel paymentModelFromMap(String str) => PaymentModel.fromMap(json.decode(str));

String paymentModelToMap(PaymentModel data) => json.encode(data.toMap());

class PaymentModel {
    String token;
    double amount;
    String tags;
    DateTime? createdTime;
    DateTime? lastModifiedTime;
    String? transactionToken;
    String? state;
    String? fundingSourceToken;
    String? userToken;
    String? currencyCode;

    PaymentModel({
        required this.token,
        required this.amount,
        required this.tags,
        required this.createdTime,
        required this.lastModifiedTime,
        required this.transactionToken,
        required this.state,
        required this.fundingSourceToken,
        required this.userToken,
        required this.currencyCode,
    });

    factory PaymentModel.fromMap(Map<String, dynamic> json) => PaymentModel(
        token: json["token"],
        amount: json["amount"],
        tags: json["tags"],
        createdTime: DateTime.parse(json["created_time"]),
        lastModifiedTime: DateTime.now(),
        transactionToken: json["transaction_token"],
        state: json["state"],
        fundingSourceToken: json["funding_source_token"],
        userToken: json["user_token"],
        currencyCode: json["currency_code"],
    );

    Map<String, dynamic> toMap() => {
        "token": token,
        "amount": amount,
        "tags": tags,
        "created_time": createdTime!.toIso8601String(),
        "last_modified_time": lastModifiedTime!.toIso8601String(),
        "transaction_token": transactionToken,
        "state": state,
        "funding_source_token": fundingSourceToken,
        "user_token": userToken,
        "currency_code": currencyCode,
    };
}




