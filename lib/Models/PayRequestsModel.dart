class PayRequestModel {
  String? id;
  String? toUserId;
  String? amount;
  String? fromUserId;
  String? imageUrl;
  String? message;
  String? tagItId;
  String? tagItName;
  String? accountType;
  String? requestType;
  String? accountHolderName;
  DateTime? createdAt;
  bool? isFromReview;
  String? senderImageUrl;
  String? selectedKidName;
  String? selectedKidImageUrl;
  String? receiverGender;
  String? receiverUserType;
  List? likesList;
  String? requestDoucumentId;
  String? selectedKidBankToken;

  PayRequestModel(
      {this.receiverUserType,
      this.receiverGender,
      this.likesList,
      this.senderImageUrl,
      this.selectedKidName,
      this.selectedKidImageUrl,
      this.isFromReview,
      this.id,
      this.toUserId,
      this.amount,
      this.fromUserId,
      this.imageUrl,
      this.message,
      this.tagItId,
      this.tagItName,
      this.accountHolderName,
      this.accountType,
      this.requestType,
      this.requestDoucumentId,
      this.selectedKidBankToken,
      this.createdAt});
}
