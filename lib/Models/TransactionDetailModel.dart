
import 'package:flutter/material.dart';

class TransactionDetailModel {
  String? transactionId, name, amount, transactionType, transactionDate, transactionMessage, walletName, userId, transactionMethod, tagItName, transactionLatLang;
  IconData? tagItIcon;
  DateTime? fullDate;
  TransactionDetailModel({this.fullDate, this.transactionId, this.tagItIcon ,this.walletName, this.amount, this.name, this.transactionDate, this.transactionMessage, this.transactionType, this.userId, this.transactionMethod, this.tagItName, this.transactionLatLang});
}
