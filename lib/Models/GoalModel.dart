class GoalModel {
  String? docId;
  String? userId;
  String? goalName;
  String? goalPrice;
  bool? topSecret;
  DateTime? goalDate;
  double? goalAmountCollected;
  List? tokensList;

  GoalModel(
      {this.docId,
      this.userId,
      this.goalName,
      this.goalPrice,
      this.topSecret,
      this.goalDate,
      this.goalAmountCollected,
      this.tokensList,
      });
}
