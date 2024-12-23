import 'package:cloud_firestore/cloud_firestore.dart';

class TodoModelWithQuery {
  final bool? doAllowanceLinked;
  final DateTime? doCreatedAt;
  final DateTime? doDueDate;
  final String? doDay;
  final String? doDeletedBy;
  final String? doEndRepeat;
  final String? doKidStatus;
  final String? doStatus;
  final String? doTitle;
  final String? doUserId;
  final DateTime? doNewCreatedAt;
  final String? doParentId;
  final String? todoRepeatSchedule;
  final int? todoRewardAmount;
  final String? todoRewardStatus;
  final bool? todoWithReward;

  TodoModelWithQuery({
    this.doAllowanceLinked,
    this.doCreatedAt,
    this.doDueDate,
    this.doDay,
    this.doDeletedBy,
    this.doEndRepeat,
    this.doKidStatus,
    this.doStatus,
    this.doTitle,
    this.doUserId,
    this.doNewCreatedAt,
    this.doParentId,
    this.todoRepeatSchedule,
    this.todoRewardAmount,
    this.todoRewardStatus,
    this.todoWithReward,
  });

  factory TodoModelWithQuery.fromFirestore(Map<String, dynamic> firestoreDoc) {
    return TodoModelWithQuery(
      doAllowanceLinked: firestoreDoc['DO_Allowance_Linked'] as bool?,
      doCreatedAt: (firestoreDoc['DO_CreatedAt'] as Timestamp?)?.toDate(),
      doDueDate: (firestoreDoc['DO_DUE_DATE'] as Timestamp?)?.toDate(),
      doDay: firestoreDoc['DO_Day'] as String?,
      doDeletedBy: firestoreDoc['DO_Deleted_By'] as String?,
      doEndRepeat: firestoreDoc['DO_End_Repeat'] as String?,
      doKidStatus: firestoreDoc['DO_Kid_Status'] as String?,
      doStatus: firestoreDoc['DO_Status'] as String?,
      doTitle: firestoreDoc['DO_Title'] as String?,
      doUserId: firestoreDoc['DO_UserId'] as String?,
      doNewCreatedAt: (firestoreDoc['DO_newCreatedAt'] as Timestamp?)?.toDate(),
      doParentId: firestoreDoc['DO_parentId'] as String?,
      todoRepeatSchedule: firestoreDoc['ToDo_Repeat_Schedule'] as String?,
      todoRewardAmount: firestoreDoc['ToDo_Reward_Amount'] as int?,
      todoRewardStatus: firestoreDoc['ToDo_Reward_Status'] as String?,
      todoWithReward: firestoreDoc['ToDo_WithReward'] as bool?,
    );
  }
}
