// import 'dart:developer';
// import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:feedback/feedback.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter_beep/flutter_beep.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:local_session_timeout/local_session_timeout.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:zaki/Constants/HelperFunctions.dart';
import 'package:zaki/Models/NotificationModel.dart';
// import 'package:zaki/Payment/AndroidIosPayment.dart';
import 'package:zaki/Screens/LoginWithPinCode.dart';
// import 'package:zaki/Screens/PinCodeSetUp.dart';
import 'package:zaki/Screens/SplashScreen.dart';
import 'package:zaki/Services/SqLiteHelper.dart';
import 'package:zaki/Services/iapService.dart';
import 'Constants/AppConstants.dart';
import 'Constants/CheckInternetConnections.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
// import 'Screens/CustomPermissions.dart';
// import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'Services/SharedPrefMnager.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
// import 'package:flutter/foundation.dart';

// void callbackDispatcher() {
//   Workmanager().executeTask((taskName, inputData) {
//
//     if (taskName=='MoveyMoney') {
//       logMethod(title: 'Background Service start with second task', message: taskName);
//
//     }
//     else{
//     logMethod(title: 'Background Service start with First Taskname:', message: taskName);

//     }
//     return Future.value(true);
//   });
// }

// class FirstScreen extends StatefulWidget {
//   const FirstScreen({ Key? key }) : super(key: key);

//   @override
//   State<FirstScreen> createState() => _FirstScreenState();
// }

// class _FirstScreenState extends State<FirstScreen> {

//   @override
//   void initState() {
//     // addPreodicTask();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           SizedBox(
//             width: double.infinity,
//           ),
//           TextButton(onPressed: (){
//           }, child: Text('Start Background Task')),
//           TextButton(onPressed: (){
//             // Workmanager().registerPeriodicTask('taskTwo', 'MoveyMoney', frequency: Duration(minutes: 16, ), );

//           }, child: Text('Start Background Task preodic'))
//         ],
//       ),
//     );
//   }
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  InAppPurchase.instance.restorePurchases();
  // await initializeService();
  await Firebase.initializeApp(
      // options: DefaultFirebaseOptions.currentPlatform,
      // options: const FirebaseOptions(
      //     apiKey: "AIzaSyCzOY0MFjdXH4GysIpFWx0EqQcWKpS5-xE",
      //   authDomain: "zakipayapp.firebaseapp.com",
      //   projectId: "zakipayapp",
      //   storageBucket: "zakipayapp.appspot.com",
      //   messagingSenderId: "988544902171",
      //   appId: "1:988544902171:web:305e5992f0b00fb0d2c4be",
      //   measurementId: "G-N2NSZ40K28",
      // )
      );
// await Workmanager().initialize(
//     callbackDispatcher, // The top level function, aka callbackDispatcher
//     isInDebugMode: true // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
//   );

  // await AndroidAlarmManager.initialize();

  await EasyLocalization.ensureInitialized();
  FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
  // FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  ///
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
    if (!kDebugMode) {
      
    
    final String errorMessage = details.toString();
    logMethod(title: 'Crash analytics message', message: errorMessage.toString());
    sendEmail(null, null, exceptionTitle: errorMessage);
    }
    // sendEmailReport(errorMessage); // Sending email with Flutter error details
  };
  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
    PlatformDispatcher.instance.onError = (error, stack) {
      
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
    
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  runApp(
    EasyLocalization(
        path: 'assets/languages',
        saveLocale: true,
        supportedLocales: const [Locale('en', 'EN'), Locale('ar', 'AR')],
        child: const MyApp()),
  );
}
// Future<void> initializeService() async {
//   final service = FlutterBackgroundService();
//   await service.configure(
//     androidConfiguration: AndroidConfiguration(
//       // this will executed when app is in foreground or background in separated isolate
//       onStart: onStart,
//       // auto start service
//       autoStart: true,
//       isForegroundMode: true,
//     ),
//     iosConfiguration: IosConfiguration(
//       // auto start service
//       autoStart: true,
//       // this will executed when app is in foreground in separated isolate
//       onForeground: onStart,
//       // you have to enable background fetch capability on xcode project
//       onBackground: onIosBackground,
//     ),
//   );
// }
// // to ensure this executed
// // run app from xcode, then from xcode menu, select Simulate Background Fetch
// void onIosBackground() {
//   WidgetsFlutterBinding.ensureInitialized();
//   print('FLUTTER BACKGROUND FETCH');
// }
// void onStart() {
//   WidgetsFlutterBinding.ensureInitialized();
//   if (Platform.isIOS) FlutterBackgroundServiceIOS.registerWith();
//   if (Platform.isAndroid) FlutterBackgroundServiceAndroid.registerWith();
//   final service = FlutterBackgroundService();
//   service.onDataReceived.listen((event) {
//     if (event!["action"] == "setAsForeground") {
//       service.setAsForegroundService();
//       return;
//     }
//     if (event["action"] == "setAsBackground") {
//       service.setAsBackgroundService();
//     }
//     if (event["action"] == "stopService") {
//       service.stopService();
//     }
//   });
//   // bring to foreground
//   service.setAsForegroundService();
//   Timer.periodic(const Duration(seconds: 1), (timer) async {
//     if (!(await service.isRunning())) timer.cancel();
//     service.setNotificationInfo(
//       title: "My App Service",
//       content: "Updated at ${DateTime.now()}",
//     );
//     // test using external plugin
//     final deviceInfo = DeviceInfoPlugin();
//     String? device;
//     if (Platform.isAndroid) {
//       final androidInfo = await deviceInfo.androidInfo;
//       device = androidInfo.model;
//     }
//     if (Platform.isIOS) {
//       final iosInfo = await deviceInfo.iosInfo;
//       device = iosInfo.model;
//     }
//     // await FirebaseFirestore.instance.collection('USA').add({
//     //   'Datetime':DateTime.now()
//     // });
//     // FlutterBackgroundService().sendData(
//     //   {
//     //     'Add_data':FirebaseFirestore.instance.collection('USA').add({
//     //   'Datetime':DateTime.now()
//     // })
//     //   }
//     // );
//     service.sendData(
//       {
//         "current_date": DateTime.now().toIso8601String(),
//         "device": device,
//       },
//     );
//   });
// }

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  description:
      'This channel is used for important notifications.', // description
  importance: Importance.max,
);
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Started successfully');
  await Firebase.initializeApp();

  print("Handling a background message: ${message.notification!.body}");
}

final navigatorKey = GlobalKey<NavigatorState>();
// FirebaseAnalytics analytics = FirebaseAnalytics.instance;
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late StreamSubscription<List<PurchaseDetails>> _iapSubscription;
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  @override
  void initState() {
        final Stream purchaseUpdated = InAppPurchase.instance.purchaseStream;

    _iapSubscription = purchaseUpdated.listen((purchaseDetailsList) {
      print("Purchase stream started");
      IAPService().listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      _iapSubscription.cancel();
    }, onError: (error) {
      _iapSubscription.cancel();
    }) as StreamSubscription<List<PurchaseDetails>>;
    // messaging.subscribeToTopic('Pakistan');
    notitficationPermission();
    // Future.delayed(Duration.zero, (){
    //   var appConstants = Provider.of<AppConstants>(context, listen: false);
    checkStateForNotification();

    // });
    // checkUserStatus();
    super.initState();
  }

  void notitficationPermission() async {
    // messaging.subscribeToTopic('${appName.replaceAll(' ', '')}_$GROUP_ID');
    // NotificationSettings settings =
    await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: true,
        provisional: false,
        sound: true);
    if (Platform.isIOS) {
    String? apnsToken = await messaging.getAPNSToken();
    if (apnsToken != null) {
      await messaging.subscribeToTopic(AppConstants.ZAKI_PAY_TOPIC);
    } else {
      await Future<void>.delayed(
        const Duration(
          seconds: 3,
        ), 
      );
      apnsToken = await messaging.getAPNSToken();
      if (apnsToken != null) {
        await messaging.subscribeToTopic(AppConstants.ZAKI_PAY_TOPIC);
      }
    }
  } else {
    // await _firebaseMessaging.subscribeToTopic(personID);
    messaging.subscribeToTopic(AppConstants.ZAKI_PAY_TOPIC);
  }
    
  }

  void checkStateForNotification() async {
    // _databaseHelper.initializeDatabase();
    UserPreferences userPref = UserPreferences();
    String? currentUserId = await userPref.getCurrentUserId();
    logMethod(
        title: 'Inside Notification',
        message: 'Id of loged InUser: ${currentUserId}');
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) async {
      // bool support = await FlutterAppBadger.isAppBadgeSupported();
      // if (support) {
      //   logMethod(title: 'Supported', message: 'Batches supports');
      // } else {
      //   logMethod(title: 'Supported', message: 'Not supports');
      // }
      if (message != null) {
        String? currentUserId = await userPref.getCurrentUserId();
        // FlutterAppBadger.updateBadgeCount(1);
        showNotification(
            error: 0,
            icon: Icons.notification_add,
            message: 'Message when app is runing');
        await insertNotificationInToDb(message, currentUserId.toString());
      }
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      // showNotification(
      //     error: 0,
      //     icon: Icons.notification_add,
      //     message: '${message.notification!.title}');

      flutterLocalNotificationsPlugin.show(
          message.hashCode,
          message.notification!.title,
          message.notification!.body,
          NotificationDetails(
              android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            icon: '@drawable/ic_launcher',
            playSound: true,
          )),
          payload: jsonEncode(message.toMap()));
      // FlutterAppBadger.updateBadgeCount(1);
      // FlutterBeep.playSysSound(41);
      String? currentUserId = await userPref.getCurrentUserId();
      await insertNotificationInToDb(message, currentUserId.toString());
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      showNotification(
          error: 0,
          icon: Icons.notification_add,
          message: 'Message comes when app open from exit');
      String? currentUserId = await userPref.getCurrentUserId();
      await insertNotificationInToDb(message, currentUserId.toString());
    });
  }

  insertNotificationInToDb(RemoteMessage message, String userId) async {
    NotificationModel model = NotificationModel(
        notificationTitle: message.notification!.title,
        notificationDescription: message.notification!.body,
        notificationTime: message.sentTime.toString(),
        userId: userId);
    DatabaseHelper helper = DatabaseHelper.instance;
    await helper.insertNotification(model);
  }

  void getToken() async {
    try {
      String? token = await messaging.getToken();
    logMethod(title: 'Token====>>>>>>', message: token);
    } catch (e) {
      logMethod(title: 'Error', message: e.toString()); 
    }
    // log(token!, name: 'token is genrated');
  }

  timeOut() async {
    var appConstants = Provider.of<AppConstants>(
        navigatorKey.currentState!.context,
        listen: false);
         //This means user Already on Login With Code Screen
    if(appConstants.onPinCodeScreen==true){
      return;
    }
    UserPreferences userPref = UserPreferences();
    String? currentUserId = await userPref.getCurrentUserId();
    if (currentUserId != null &&
        appConstants.userModel.userFullyRegistered == true) {
      // handle user  app lost focus timeout
      navigatorKey.currentState!.push(
          MaterialPageRoute(builder: (context) => LoginWithPinCode(timeOut:true)));
      // navigatorKey.currentState!.pushAndRemoveUntil(
      //     MaterialPageRoute(builder: (context) => LoginWithPinCode()),
      //     (Route<dynamic> route) => false);
    } else {
      navigatorKey.currentState!.pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => SplashScreen()),
          (Route<dynamic> route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    getToken();
    final sessionConfig = SessionConfig(
        invalidateSessionForAppLostFocus: const Duration(seconds: 30),
        invalidateSessionForUserInactivity: const Duration(seconds: 120));

    sessionConfig.stream.listen((SessionTimeoutState timeoutEvent) async {
      if (timeoutEvent == SessionTimeoutState.userInactivityTimeout) {
        // handle user  inactive timeout
        // Navigator.of(context).pushNamed("/auth");
        // timeOut();
        if (kReleaseMode)
        timeOut();
      } else if (timeoutEvent == SessionTimeoutState.appFocusTimeout) {
        if (kReleaseMode)
        timeOut();
      }
    }); 

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppConstants()),
        ChangeNotifierProvider(create: (_) => CheckInternet()),
      ],
      child: OverlaySupport.global(
        child: BetterFeedback(
          child: SessionTimeoutManager(
            sessionConfig: sessionConfig,
            child: MaterialApp(
              title: 'Teen Debit Card',
              navigatorKey: navigatorKey,
              debugShowCheckedModeBanner: false,
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: context.locale,
              navigatorObservers: <NavigatorObserver>[observer],
              theme: ThemeData(
                  // This is the theme of your application.
                  //
                  // Try running your application with "flutter run". You'll see the
                  // application has a blue toolbar. Then, without quitting the app, try
                  // changing the primarySwatch below to Colors.green and then invoke
                  // "hot reload" (press "r" in the console where you ran "flutter run",
                  // or simply save your changes to "hot reload" in a Flutter IDE).
                  // Notice that the counter didn't reset back to zero; the application
                  // is not restarted.
                  primarySwatch: Colors.blue,
                  cardColor: Colors.white,
                  cardTheme: CardTheme(
                    color: Colors.white,
                  ),
                  useMaterial3: false),
              // home: const GetContacts(),
              // home: const PinCodeSetUp(),
              home: SplashScreen(navigatorKey: navigatorKey),
              // home: AndroidIosPayment()
              // home: const FingerPrintAuth(),
              // home: const ChooseLoginType(),
              // home: const AccountSetupInformation(),
              // home:const AskYourParent()
              // home: const GetStarted(),
              // home:  CustomPermissions(),
              // home: const SettingsMainScreen(),
            ),
          ),
        ),
      ),
    );
  }
}

//////////////
// class YesState extends StatefulWidget {
//   const YesState({Key? key}) : super(key: key);
//   @override
//   _YesStateState createState() => _YesStateState();
// }
// class _YesStateState extends State<YesState> {
//   String text = "Stop Service";
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('Service App'),
//         ),
//         body: Column(
//           children: [
//             StreamBuilder<Map<String, dynamic>?>(
//               stream: FlutterBackgroundService().on(''),
//               builder: (context, snapshot) {
//                 if (!snapshot.hasData) {
//                   return const Center(
//                     child: CustomLoader(),
//                   );
//                 }
//                 final data = snapshot.data!;
//                 String? device = data["device"];
//                 DateTime? date = DateTime.tryParse(data["current_date"]);
//                 return Column(
//                   children: [
//                     Text(device ?? 'Unknown'),
//                     Text(date.toString()),
//                   ],
//                 );
//               },
//             ),
//             ElevatedButton(
//               child: const Text("Foreground Mode"),
//               onPressed: () {
//                 FlutterBackgroundService()
//                     .sendData({"action": "setAsForeground"});
//               },
//             ),
//             ElevatedButton(
//               child: const Text("Background Mode"),
//               onPressed: () {
//                 FlutterBackgroundService()
//                     .sendData({"action": "setAsBackground"});
//               },
//             ),
//             ElevatedButton(
//               child: Text(text),
//               onPressed: () async {
//                 final service = FlutterBackgroundService();
//                 var isRunning = await service.isRunning();
//                 if (isRunning) {
//                   service.sendData(
//                     {"action": "stopService"},
//                   );
//                 } else {
//                   service.startService();
//                 }
//                 if (!isRunning) {
//                   text = 'Stop Service';
//                 } else {
//                   text = 'Start Service';
//                 }
//                 setState(() {});
//               },
//             ),
//           ],
//         ),
//         floatingActionButton: FloatingActionButton(
//           onPressed: () {
//             FlutterBackgroundService().sendData({
//               "hello": "world",
//             });
//           },
//           child: const Icon(Icons.play_arrow),
//         ),
//       ),
//     );
//   }
// }
// class AddCollection extends StatefulWidget {
//   const AddCollection({Key? key}) : super(key: key);
//   @override
//   State<AddCollection> createState() => _AddCollectionState();
// }
// class _AddCollectionState extends State<AddCollection> {
//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }
