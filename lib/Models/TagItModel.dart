import 'package:flutter/cupertino.dart';

class ImageModelTagIt {
  int? id;
  String? tagItId;
  IconData? icon;
  String? title;
  bool? isSelected;
  String? mccId;
  bool? publicTag_it;
  String? fullName;
  ImageModelTagIt({this.fullName, this.tagItId, this.id,this.icon, this.title, this.isSelected, this.mccId, this.publicTag_it});
}

class TagItModel {
  final int bankBizCode;
  final int tagItId;
  final String tagItName;

  TagItModel({
    required this.bankBizCode,
    required this.tagItId,
    required this.tagItName,
  });

  // Factory constructor to create an object from JSON
  factory TagItModel.fromJson(Map<String, dynamic> json) {
    return TagItModel(
      bankBizCode: json['Bank_BizCode'],
      tagItId: json['ZakiPay_tag_id'],
      tagItName: json['ZakiPay_tag_Name'],
    );
  }

  // Override equality and hashCode to compare objects based on tagItId
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TagItModel &&
          runtimeType == other.runtimeType &&
          tagItId == other.tagItId;

  @override
  int get hashCode => tagItId.hashCode;
}

