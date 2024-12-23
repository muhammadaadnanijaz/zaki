class NotificationModel {
  int? id;
  String? userId;
  String? notificationTitle;
  String? notificationDescription;
  String? notificationTime;

  NotificationModel(
      {this.id,
      this.notificationTitle,
      this.notificationDescription,
      this.notificationTime,
      this.userId});

  // Convert a Note object into a Map object
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    if (id != null) {
      map['id'] = id;
    }
    map['notificationTitle'] = notificationTitle;
    map['notificationDescription'] = notificationDescription;
    map['notificationTime'] = notificationTime;
    map['userId'] = userId;

    return map;
  }

  // Extract a Note object from a Map object
  NotificationModel.fromMapObject(Map<String, dynamic> map) {
    id = map['id'];
    notificationTitle = map['notificationTitle'];
    notificationDescription = map['notificationDescription'];
    notificationTime = map['notificationTime'];
    userId = map['userId'];
  }
}
