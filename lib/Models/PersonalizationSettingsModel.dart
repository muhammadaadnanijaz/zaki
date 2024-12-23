// To parse this JSON data, do
//
//     final personalizationSettingModel = personalizationSettingModelFromJson(jsonString);

import 'dart:convert';

PersonalizationSettingModel personalizationSettingModelFromJson( Map<dynamic, dynamic> str) => PersonalizationSettingModel.fromJson(str);

String personalizationSettingModelToJson(PersonalizationSettingModel data) => json.encode(data.toJson());

class PersonalizationSettingModel {
    PersonalizationSettingModel({
        this.kidPKids2Publish,
        this.kidPUseSlide2Pay,
        this.kidPSeePendApprovals,
        this.kidPLockSavings,
        this.kidPParentId,
        this.kidPKid2PayFriends,
        this.kidPCreatedAt,
        this.kidPUserId,
        this.kidPLockDonate,
    });

    bool? kidPKids2Publish;
    bool? kidPUseSlide2Pay;
    String? kidPSeePendApprovals;
    bool? kidPLockSavings;
    String? kidPParentId;
    bool? kidPKid2PayFriends;
    DateTime? kidPCreatedAt;
    String? kidPUserId;
    bool? kidPLockDonate;

    factory PersonalizationSettingModel.fromJson(Map<dynamic, dynamic> json) => PersonalizationSettingModel(
        kidPKids2Publish: json["KidP_Kids2Publish"],
        kidPUseSlide2Pay: json["KidP_UseSlide2Pay"],
        kidPSeePendApprovals: json["KidP_SeePendApprovals"],
        kidPLockSavings: json["KidP_lockSavings"],
        kidPParentId: json["KidP_Parent_id"],
        kidPKid2PayFriends: json["KidP_Kid2PayFriends"],
        kidPCreatedAt: json["KidP_created_at"].toDate(),
        kidPUserId: json["KidP_user_id"],
        kidPLockDonate: json["KidP_lockDonate"],
    );

    Map<String, dynamic> toJson() => {
        "KidP_Kids2Publish": kidPKids2Publish,
        "KidP_UseSlide2Pay": kidPUseSlide2Pay,
        "KidP_SeePendApprovals": kidPSeePendApprovals,
        "KidP_lockSavings": kidPLockSavings,
        "KidP_Parent_id": kidPParentId,
        "KidP_Kid2PayFriends": kidPKid2PayFriends,
        "KidP_created_at": kidPCreatedAt,
        "KidP_user_id": kidPUserId,
        "KidP_lockDonate": kidPLockDonate,
    };
}
