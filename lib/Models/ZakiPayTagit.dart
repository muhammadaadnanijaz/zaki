class ZakiPayTag {
  final String bankBizCode;
  final String zakiPayTagId;
  final String zakiPayTagName;

  ZakiPayTag({
    required this.bankBizCode,
    required this.zakiPayTagId,
    required this.zakiPayTagName,
  });

  // Factory constructor to create an object from JSON
  factory ZakiPayTag.fromJson(Map<String, dynamic> json) {
    return ZakiPayTag(
      bankBizCode: json['Bank_BizCode'].toString(),
      zakiPayTagId: json['ZakiPay_tag_id'].toString(),
      zakiPayTagName: json['ZakiPay_tag_Name'],
    );
  }
}
