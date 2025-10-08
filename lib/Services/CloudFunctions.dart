import 'package:cloud_functions/cloud_functions.dart';
import 'package:zaki/Constants/HelperFunctions.dart';

// cloud_functions, firebase_core, firebase_auth, firebase_messaging, firebase_analytics, firebase_remote_config, firebase_performance, firebase_crashlytics, firebase_database, firebase_storage, firebase_firestore, firebase_auth

class CloudFunctions {
  Future<String?> callFunction({
  String? useReceiverId, 
  String? userToken, 
  String? notificationTitle, 
  String? notificationSubTitle, 
  String? expression,
  String? userSenderId,
  String? amount
}) async {
  final HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
    'updateCollectionAndNotifyUser',
  );

  logMethod(title: 'Function Called', message: '$useReceiverId, $userToken, $expression');

  try {
    final HttpsCallableResult result = await callable.call(
      <String, dynamic>{
        'dateTime': DateTime.now().toIso8601String(),
        'useReceiverId': useReceiverId ?? 'cOjCLkY2BntNgy1EAhwo',
        'userSenderId':userSenderId,
        'userToken': userToken,
        'amount': amount,
        'title': '$notificationTitle - Cloud Function',
        'body': '$notificationSubTitle - Cloud Function',
        'cronExpression': expression,
      },
    );
    print('Function called: ${result.data}');
    if (result.data['success'] == true) {
      print('Function called successfully: ${result.data['message']}');
      return null;
    } else {
      print('Function call failed: ${result.data['message']}');
      return null;
    }
  } catch (e) {
    print('Error calling function: $e');
    return null;
  }
  return null;
}

// createCronJob
  Future<String?> updateAlloanceForUser({
  String? useReceiverId, 
  String? userToken, 
  String? notificationTitle, 
  String? notificationSubTitle, 
  String? expression,
  String? userSenderId,
  String? amount
}) async {
  // Specify the region if your function is not in the default region
  final HttpsCallable createCronJob = FirebaseFunctions.instance.httpsCallable(
    'createCronJob',
  );

  logMethod(title: 'Function Called', message: '$useReceiverId, $userToken, $expression');

  try {
    final HttpsCallableResult result = await createCronJob.call(
      <String, dynamic>{
        'dateTime': DateTime.now().toIso8601String(),
        'useReceiverId': useReceiverId ?? 'cOjCLkY2BntNgy1EAhwo',
        'userSenderId':userSenderId,
        'userToken': userToken,
        'amount': amount,
        'title': '$notificationTitle - Cloud Function',
        'body': '$notificationSubTitle - Cloud Function',
        'cronExpression': expression,
      },
    );
    print('Function called: ${result.data}');
    if (result.data['success'] == true) {
      print('Function called successfully: ${result.data['message']}');
      return null;
    } else {
      print('Function call failed: ${result.data['message']}');
      return null;
    }
  } catch (e) {
    print('Error calling function: $e');
    return null;
  }
  return null;
}



  void addAllowanceToUser({String? userId, String? amount}) async {
    final HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
      'updateCollectionAndNotifyUser',
    );

    final HttpsCallableResult result = await callable.call(
      <String, dynamic>{
        'userId': userId,
        'amount': amount,
      },
    );

    if (result.data['success']) {
      print('Function called successfully');
    } else {
      print('Function call failed');
    }
  }
 Future<void> sendUserNotification({String? userToken, String? userCardToken, String? userId}) async {
      final HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('sendUserNotification');

    logMethod(title: 'User card items', message: 'User id: $userId, user card token: $userCardToken and user device token: $userToken');

    final HttpsCallableResult result = await callable.call(
      <String, dynamic>{
        'userId': userId,
        'userCardToken': "19db06d8-b53f-4d08-8528-b1bc54603639",
        'userToken': userToken
      },
    );

    if (result.data!=null && result.data['success']) {
      print('Function called successfully');
    } else {
      print('Function call failed');
    }
  }

 void sendNotification_({String? userToken, String? notificationTitle, String? notificationSubTitle, String? cownExpression}) async {
    final HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
      'scheduleNotification',
    );

    final HttpsCallableResult result = await callable.call(
      <String, dynamic>{
        'userToken': userToken,
        'title': '$notificationTitle - Cloud Function',
        'body': '$notificationSubTitle - Cloud Function',
        'cronExpression': cownExpression
      },
    );

    if (result.data!=null && result.data['success']) {
      print('Function called successfully');
    } else {
      print('Function call failed');
    }
  }
}
