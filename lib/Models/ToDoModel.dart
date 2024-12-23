class ToDoModel {
  DateTime? createdAt;
  String? doTitle;
  String? doType;
  String? doDay;
  String? doStatus;
  bool? linkedAllowance;
  ToDoModel(
      {this.createdAt,
      this.doDay,
      this.doStatus,
      this.doTitle,
      this.doType,
      this.linkedAllowance});
}
