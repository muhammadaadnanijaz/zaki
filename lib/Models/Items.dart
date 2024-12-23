import 'package:cloud_firestore/cloud_firestore.dart';

class Item {
  final String? transactionFromWallet;
  final String? transactionMessageText;
  final String? transactionMethod;
  final String? transactionReceiverUserId;
  final String? transactionSenderUserId;
  final String? transactionSenderUserName;
  final String? transactionTagitCategory;
  final String? transactionTagitCode;
  final String? transactionToWallet;
  final String? transactionAmount;
  final String? transactionId;
  final String? transactionReceiverName;
  final String? transactionTransactionType;
  final String? latLang;
  final DateTime? createdAt;

  Item({
     this.transactionFromWallet,
     this.transactionMessageText,
     this.transactionMethod,
     this.transactionReceiverUserId,
     this.transactionSenderUserId,
     this.transactionSenderUserName,
     this.transactionTagitCategory,
     this.transactionTagitCode,
     this.transactionToWallet,
     this.transactionAmount,
     this.transactionId,
     this.transactionReceiverName,
     this.transactionTransactionType,
     this.latLang,
     this.createdAt,
  });

  factory Item.fromFirestore(Map<String, dynamic> firestoreDoc) {
    return Item(
      transactionFromWallet: firestoreDoc['Transaction_From_Wallet'] ,
      transactionMessageText: firestoreDoc['Transaction_Message_Text'] ,
      transactionMethod: firestoreDoc['Transaction_Method'] ,
      transactionReceiverUserId: firestoreDoc['Transaction_ReceiverUser_id'] ,
      transactionSenderUserId: firestoreDoc['Transaction_SenderUser_id'] ,
      transactionSenderUserName: firestoreDoc['Transaction_Sender_UserName'] ,
      transactionTagitCategory: firestoreDoc['Transaction_TAGIT_Category'] ,
      transactionTagitCode: firestoreDoc['Transaction_TAGIT_code'] ,
      transactionToWallet: firestoreDoc['Transaction_To_Wallet'] ,
      transactionAmount: firestoreDoc['Transaction_amount']  ,
      transactionId: firestoreDoc['Transaction_id'] ,
      transactionReceiverName: firestoreDoc['Transaction_receiver_name'] ,
      transactionTransactionType: firestoreDoc['Transaction_transaction_type'] ,
      createdAt: (firestoreDoc['created_at'] as Timestamp).toDate(),
    );
  }
}
