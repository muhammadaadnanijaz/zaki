import 'package:cloud_firestore/cloud_firestore.dart';

class GoalModelWithQuery {
  final DateTime? goalDueDate;
  final List<dynamic>? goalInvitedTokenList;
  final String? goalStatus;
  final double? goalAmountCollected;
  final DateTime? goalCreatedAt;
  final bool? goalIsPrivate;
  final String? goalName;
  final String? goalUserId;
  final double? goalTargetAmount;
  final int? fundGoalFrom;

  GoalModelWithQuery({
    this.goalDueDate,
    this.goalInvitedTokenList,
    this.goalStatus,
    this.goalAmountCollected,
    this.goalCreatedAt,
    this.goalIsPrivate,
    this.goalName,
    this.goalUserId,
    this.goalTargetAmount,
    this.fundGoalFrom,
  });

  factory GoalModelWithQuery.fromFirestore(Map<String, dynamic> firestoreDoc) {
    return GoalModelWithQuery(
      goalDueDate: (firestoreDoc['GOAL_Due_Date'] as Timestamp?)?.toDate(),
      goalInvitedTokenList: firestoreDoc['GOAL_Invited_Token_List'] as List<dynamic>?,
      goalStatus: firestoreDoc['GOAL_Status'] as String?,
      goalAmountCollected: firestoreDoc['GOAL_amount_collected'] as double?,
      goalCreatedAt: (firestoreDoc['GOAL_created_at'] as Timestamp?)?.toDate(),
      goalIsPrivate: firestoreDoc['GOAL_isPrivate'] as bool?,
      goalName: firestoreDoc['GOAL_name'] as String?,
      goalUserId: firestoreDoc['GOAL_user_id'] as String?,
      goalTargetAmount: firestoreDoc['Goal_Target_Amount'] as double?,
      fundGoalFrom: firestoreDoc['fund_goal_from'] as int?,
    );
  }
}
