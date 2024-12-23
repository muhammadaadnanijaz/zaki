// To parse this JSON data, do
//
//     final paymentAccessTokenModel = paymentAccessTokenModelFromJson(jsonString);

import 'dart:convert';

PaymentAccessTokenModel paymentAccessTokenModelFromJson(String str) => PaymentAccessTokenModel.fromJson(json.decode(str));

String paymentAccessTokenModelToJson(PaymentAccessTokenModel data) => json.encode(data.toJson());

class PaymentAccessTokenModel {
    String serviceCommand;
    String accessCode;
    String merchantIdentifier;
    String language;
    String deviceId;
    String signature;

    PaymentAccessTokenModel({
        required this.serviceCommand,
        required this.accessCode,
        required this.merchantIdentifier,
        required this.language,
        required this.deviceId,
        required this.signature,
    });

    factory PaymentAccessTokenModel.fromJson(Map<String, dynamic> json) => PaymentAccessTokenModel(
        serviceCommand: json["service_command"],
        accessCode: json["access_code"],
        merchantIdentifier: json["merchant_identifier"],
        language: json["language"],
        deviceId: json["device_id"],
        signature: json["signature"],
    );

    Map<String, dynamic> toJson() => {
        "service_command": serviceCommand,
        "access_code": accessCode,
        "merchant_identifier": merchantIdentifier,
        "language": language,
        "device_id": deviceId,
        "signature": signature,
    };
}
