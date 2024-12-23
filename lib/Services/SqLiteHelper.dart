import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:zaki/Constants/AppConstants.dart';
import 'package:zaki/Constants/HelperFunctions.dart';
import 'package:zaki/Models/NotificationModel.dart';

class DatabaseHelper {
  String databaseName = 'localdatabase.db';

  //Notification Table
  String notificationTable = "notificationTable";
  String colNotificationId = 'id';
  String colNotificationUserId = 'userId';
  String colNotificationTitle = 'notificationTitle';
  String colNotificationDescription = 'notificationDescription';
  String colNotificationTime = 'notificationTime';
static final DatabaseHelper _db = new DatabaseHelper._internal();
  DatabaseHelper._internal();
  static DatabaseHelper get instance => _db;
  static Database? _database;

  Future<Database?> get database async {
    if(_database != null)
      return _database;
    _database = await openLocalDatabase();
    return _database;

  }

  Future<Database> openLocalDatabase() async {
    final database = openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      join(await getDatabasesPath(), databaseName),
      // When the database is first created, create a table to store dogs.
      onCreate: (db, version) {
        // Run the CREATE TABLE statement on the database.
        return db.execute(
          'CREATE TABLE $notificationTable($colNotificationId INTEGER PRIMARY KEY, $colNotificationTitle TEXT, $colNotificationDescription TEXT, $colNotificationTime TEXT, $colNotificationUserId TEXT)',
        );
      },
      version: 2,
    );
    logMethod(message: 'successfully craeted', title: 'Database opened');
    return database;
  }
  // Define a function that inserts dogs into the database
Future<void> insertNotification(NotificationModel notification) async {
  // Get a reference to the database.
  var db = await DatabaseHelper.instance.database;

  // Insert the Dog into the correct table. You might also specify the
  // `conflictAlgorithm` to use in case the same dog is inserted twice.
  // In this case, replace any previous data.
  await db!.insert(
    notificationTable,
    notification.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
  // logMethod(message: 'Notification Inserted Succesfully', title: 'Notification Table');
}
// A method that retrieves all the dogs from the dogs table.
Future<List<NotificationModel>> getAllNotifications({required AppConstants? appConstants}) async {
  // Get a reference to the database.
   var db = await DatabaseHelper.instance.database;

  // Query the table for all The Dogs.
  final List<Map<String, dynamic>> maps = await db!.query(notificationTable, where: '$colNotificationUserId = ?', whereArgs: [appConstants!.userRegisteredId]);

  // Convert the List<Map<String, dynamic> into a List<Dog>.
  return List.generate(maps.length, (i) {
    return NotificationModel(
      id: maps[i]['id'],
      notificationTitle: maps[i][colNotificationTitle],
      notificationDescription: maps[i][colNotificationDescription],
      notificationTime: maps[i][colNotificationTime],
      userId: maps[i][colNotificationUserId],
    );
  });
}
Future<int> getLengthOfNotificationForBatch({AppConstants? appConstants}) async {
  // Get a reference to the database.
   var db = await DatabaseHelper.instance.database;

  // Query the table for all The Dogs.
  var result = await db!.query(notificationTable, where: '$colNotificationUserId = ?', whereArgs: [appConstants!.userRegisteredId]);

  // Convert the List<Map<String, dynamic> into a List<Dog>.
  appConstants.updateBatchCounter(result.length.toString());
  return result.length;
}
 Future<int> deleteNotification({int? id}) async {
   var db = await DatabaseHelper.instance.database;
    return await db!.delete(notificationTable, where: '$colNotificationId = ?', whereArgs: [id]);
  }
}
