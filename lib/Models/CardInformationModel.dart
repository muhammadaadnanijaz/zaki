// To parse this JSON data, do
//
//     final cardInformationModel = cardInformationModelFromMap(jsonString);

import 'dart:convert';

CardInformationModel cardInformationModelFromMap(String str) => CardInformationModel.fromMap(json.decode(str));

String cardInformationModelToMap(CardInformationModel data) => json.encode(data.toMap());

class CardInformationModel {
    DateTime createdTime;
    DateTime lastModifiedTime;
    String token;
    String userToken;
    String cardProductToken;
    String lastFour;
    String pan;
    String expiration;
    DateTime expirationTime;
    String barcode;
    bool pinIsSet;
    String state;
    String stateReason;
    String fulfillmentStatus;
    String instrumentType;
    bool expedite;
    Metadata metadata;

    CardInformationModel({
        required this.createdTime,
        required this.lastModifiedTime,
        required this.token,
        required this.userToken,
        required this.cardProductToken,
        required this.lastFour,
        required this.pan,
        required this.expiration,
        required this.expirationTime,
        required this.barcode,
        required this.pinIsSet,
        required this.state,
        required this.stateReason,
        required this.fulfillmentStatus,
        required this.instrumentType,
        required this.expedite,
        required this.metadata,
    });

    factory CardInformationModel.fromMap(Map<String, dynamic> json) => CardInformationModel(
        createdTime: DateTime.parse(json["created_time"]),
        lastModifiedTime: DateTime.parse(json["last_modified_time"]),
        token: json["token"],
        userToken: json["user_token"],
        cardProductToken: json["card_product_token"],
        lastFour: json["last_four"],
        pan: json["pan"],
        expiration: json["expiration"],
        expirationTime: DateTime.parse(json["expiration_time"]),
        barcode: json["barcode"],
        pinIsSet: json["pin_is_set"],
        state: json["state"],
        stateReason: json["state_reason"],
        fulfillmentStatus: json["fulfillment_status"],
        instrumentType: json["instrument_type"],
        expedite: json["expedite"],
        metadata: Metadata.fromMap(json["metadata"]),
    );

    Map<String, dynamic> toMap() => {
        "created_time": createdTime.toIso8601String(),
        "last_modified_time": lastModifiedTime.toIso8601String(),
        "token": token,
        "user_token": userToken,
        "card_product_token": cardProductToken,
        "last_four": lastFour,
        "pan": pan,
        "expiration": expiration,
        "expiration_time": expirationTime.toIso8601String(),
        "barcode": barcode,
        "pin_is_set": pinIsSet,
        "state": state,
        "state_reason": stateReason,
        "fulfillment_status": fulfillmentStatus,
        "instrument_type": instrumentType,
        "expedite": expedite,
        "metadata": metadata.toMap(),
    };
}

class Metadata {
    Metadata();

    factory Metadata.fromMap(Map<String, dynamic> json) => Metadata(
    );

    Map<String, dynamic> toMap() => {
    };
}
