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
// import 'package:zaki/Screens/ChatUi.dart';
// import 'package:zaki/Payment/AndroidIosPayment.dart';
import 'package:zaki/Screens/LoginWithPinCode.dart';
// import 'package:zaki/Screens/PinCodeSetUp.dart';
import 'package:zaki/Screens/SplashScreen.dart';
import 'package:zaki/Services/SqLiteHelper.dart';
import 'package:zaki/Services/iapService.dart';
// import 'package:zaki/Services/mode_badge.dart';
import 'package:zaki/Services/mode_services.dart';
import 'Constants/AppConstants.dart';
import 'Constants/CheckInternetConnections.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
// import 'Screens/CustomPermissions.dart';
// import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'Services/SharedPrefMnager.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

/// === ZP Full/Lite additions ===
/// 
/// ==============================

//firebase_crashlytics, firebase_analytics, in_app_purchase, firebase_messaging, easy_localization, overlay_support, provider, feedback, local_session_timeout, flutter_local_notifications, shared_preferences, path_provider, sqflite, flutter_inappwebview, flutter_background_service
 
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
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyAWtcufkuGbQl6N0lcVok0VKSF-FwRkbDg",
        authDomain: "zakipayapp.firebaseapp.com",
        projectId: "zakipayapp",
        storageBucket: "zakipayapp.appspot.com",
        messagingSenderId: "988544902171",
        appId: "1:988544902171:web:190d53e4a52faee2d2c4be",
        measurementId: "G-V4ZTXH2LE9",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

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
  };
  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  /// Update the iOS foreground notification presentation options to allow heads up notifications.
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  /// === ZP Full/Lite: create & load ModeService BEFORE runApp ===
  final modeService = ModeService();
  await modeService.loadMode(); // TODO: later load from Remote Config / Firestore
  /// ============================================================

  runApp(
    EasyLocalization(
      path: 'assets/languages',
      saveLocale: true,
      supportedLocales: const [Locale('en', 'EN'), Locale('ar', 'AR')],
      child: MultiProvider(
        providers: [
          /// moved providers here so they are available app-wide
          ChangeNotifierProvider.value(value: modeService), // NEW: ZP mode provider
          ChangeNotifierProvider(create: (_) => AppConstants()),
          ChangeNotifierProvider(create: (_) => CheckInternet()),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

// Future<void> initializeService() async { ... }  // (kept commented)

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  description: 'This channel is used for important notifications.', // description
  importance: Importance.max,
);
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

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
  static FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: analytics);

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
    checkStateForNotification();
    super.initState();
  }

  void notitficationPermission() async {
    // messaging.subscribeToTopic('${appName.replaceAll(' ', '')}_$GROUP_ID');
    await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: true,
      provisional: false,
      sound: true,
    );
    if (Platform.isIOS) {
      String? apnsToken = await messaging.getAPNSToken();
      if (apnsToken != null) {
        await messaging.subscribeToTopic(AppConstants.ZAKI_PAY_TOPIC);
      } else {
        await Future<void>.delayed(const Duration(seconds: 3));
        apnsToken = await messaging.getAPNSToken();
        if (apnsToken != null) {
          await messaging.subscribeToTopic(AppConstants.ZAKI_PAY_TOPIC);
        }
      }
    } else {
      messaging.subscribeToTopic(AppConstants.ZAKI_PAY_TOPIC);
    }
  }

  void checkStateForNotification() async {
    UserPreferences userPref = UserPreferences();
    String? currentUserId = await userPref.getCurrentUserId();
    logMethod(title: 'Inside Notification', message: 'Id of loged InUser: ${currentUserId}');
    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) async {
      if (message != null) {
        String? currentUserId = await userPref.getCurrentUserId();
        showNotification(error: 0, icon: Icons.notification_add, message: 'Message when app is runing');
        await insertNotificationInToDb(message, currentUserId.toString());
      }
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
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
          ),
        ),
        payload: jsonEncode(message.toMap()),
      );
      String? currentUserId = await userPref.getCurrentUserId();
      await insertNotificationInToDb(message, currentUserId.toString());
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      showNotification(error: 0, icon: Icons.notification_add, message: 'Message comes when app open from exit');
      String? currentUserId = await userPref.getCurrentUserId();
      await insertNotificationInToDb(message, currentUserId.toString());
    });
  }

  insertNotificationInToDb(RemoteMessage message, String userId) async {
    NotificationModel model = NotificationModel(
      notificationTitle: message.notification!.title,
      notificationDescription: message.notification!.body,
      notificationTime: message.sentTime.toString(),
      userId: userId,
    );
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
  }

  timeOut() async {
    var appConstants = Provider.of<AppConstants>(
      navigatorKey.currentState!.context,
      listen: false,
    );
    //This means user Already on Login With Code Screen
    if (appConstants.onPinCodeScreen == true) {
      return;
    }
    UserPreferences userPref = UserPreferences();
    String? currentUserId = await userPref.getCurrentUserId();
    if (currentUserId != null && appConstants.userModel.userFullyRegistered == true) {
      navigatorKey.currentState!.push(MaterialPageRoute(builder: (context) => LoginWithPinCode(timeOut: true)));
    } else {
      navigatorKey.currentState!.pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => SplashScreen()),
        (Route<dynamic> route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    getToken();
    final sessionConfig = SessionConfig(
      invalidateSessionForAppLostFocus: const Duration(seconds: 30),
      invalidateSessionForUserInactivity: const Duration(seconds: 120),
    );

    sessionConfig.stream.listen((SessionTimeoutState timeoutEvent) async {
      if (timeoutEvent == SessionTimeoutState.userInactivityTimeout) {
        if (kReleaseMode) timeOut();
      } else if (timeoutEvent == SessionTimeoutState.appFocusTimeout) {
        if (kReleaseMode) timeOut();
      }
    });

    /// NOTE:
    /// Providers (AppConstants, CheckInternet, ModeService) are now injected
    /// at the top-level in main() via MultiProvider, so we don't nest another
    /// MultiProvider here. Everything below remains as-is.
    return OverlaySupport.global(
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
              primarySwatch: Colors.blue,
              cardColor: Colors.white,
              cardTheme: const CardThemeData(color: Colors.white),
              useMaterial3: false,
            ),
            // Root screen + ZP QA overlay
            home: Stack(
              children: [
                SplashScreen(),
                // ModeBadge(), // shows active mode/flags in debug builds
              ],
            ),
            // home: Chatui(),
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
    );
  }
}

//////////////
// (rest of your commented debug scaffolding left unchanged)
