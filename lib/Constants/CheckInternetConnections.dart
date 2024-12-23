
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zaki/Constants/AppConstants.dart';
import 'package:zaki/Constants/NotificationTitle.dart';
import 'package:zaki/Constants/Styles.dart';

import '../main.dart';
 
class CheckInternet extends ChangeNotifier {
  String status = 'waiting...';
  final Connectivity _connectivity = Connectivity();
  // ignore: unused_field
  late StreamSubscription _streamSubscription;
 
  // void checkConnectivity() async {
  // code
  //   var connectionResult = await _connectivity.checkConnectivity();
  //   if (connectionResult == ConnectivityResult.mobile) {
  //     status = "Connected to MobileData";
  //     notifyListeners();
  //   } else if (connectionResult == ConnectivityResult.wifi) {
  //     status = "Connected to Wifi";
  //     notifyListeners();
  //   } else {
  //     status = "Offline";
  //     notifyListeners();
  //   }
  // }

  void checkRealtimeConnection() {
  _streamSubscription = _connectivity.onConnectivityChanged.listen((event) {

    // if(event.name==ConnectivityResult.none){
    //   ScaffoldMessenger.of(navigatorKey.currentState!.context).showSnackBar(
    //         SnackBar(
    //           content: Text('Check Your internet connection'),
    //           duration: Duration(days: 3),
    //           ));
    //     return;
    // }
    // else{
    //    ScaffoldMessenger.of(navigatorKey.currentState!.context).showSnackBar(
    //         SnackBar(
    //           content: Text('Internet Has arrived'),
    //           // duration: Duration(),
    //           ));
    //    return;
    // }
    if(event.contains(ConnectivityResult.none)){
    // switch (event) {
    //   case ConnectivityResult.none:
    //     {
          status = AppConstants.INTERNET_STATUS_NOT_CONNECTED;
          // showNotification(
          //   error: 0, icon: Icons.e_mobiledata, 
          //   autoDismiss: true,
          //   message: "Connection Back Successfully");
          // navigatorKey!.currentState!.context.
      //     ScaffoldMessenger.of(navigatorKey.currentState!.context).showSnackBar(SnackBar(
      //   content: const Text('snack'),
      //   duration: const Duration(seconds: 1),
      //   action: SnackBarAction(
      //     label: 'ACTION',
      //     onPressed: () { },
      //   ),
      // ));
          ScaffoldMessenger.of(navigatorKey.currentState!.context).showMaterialBanner(
            MaterialBanner(
              backgroundColor: crimsonColor,
              // forceActionsBelow: true, 
              // t: Icon(Icons.signal_wifi_off, color: white),
              content: FittedBox(child: Text(NotificationText.NO_INTERNET_CONNECTION_MESSAGE, style: heading3TextStyle(400,color: white, font: 15, bold: true),maxLines: 1)),
              actions: [
                IconButton(
                  onPressed: null,
                  icon: Icon(FontAwesomeIcons.arrowsRotate, color: white), ),
                // TextButton(
                //   onPressed: null,
                //   child: Text(''),
                // ),
              ],
              
    //           behavior: SnackBarBehavior.floating,
    // shape: RoundedRectangleBorder(
    //   borderRadius: BorderRadius.circular(24),
    // ),
    // margin: EdgeInsets.only(
    //     // bottom: MediaQuery.of(navigatorKey.currentState!.context).size.height - 100,
    //     right: 20,
    //     left: 20),
    //           duration: Duration(days: 2),
              )
              );
          // OverlaySupportEntry.of(navigatorKey.currentState!.context)!.dismiss();
          // OverlaySupportEntry.empty();
          // OverlaySupportEntry.of(navigatorKey.currentState!.overlay!.context)!.dismiss(animate: true);
          
          notifyListeners();
        // }
        // break;
      // case ConnectivityResult.wifi:
      //   {
      //     ScaffoldMessenger.of(navigatorKey.currentState!.context).showSnackBar(
      //       SnackBar(
      //         content: Text('Internet Has arrived'),
      //         // duration: Duration(),
      //         ));
      //     // showNotification(
      //     //   error: 0, icon: Icons.wifi, 
      //     //   autoDismiss: true,
      //     //   message: "Connection Back Successfully");
      //     status = "Connected to Wifi";
      //     notifyListeners();
      //   }
      //   break;
      // default:
    }
    else
        {
          status = 'Online';
          ScaffoldMessenger.of(navigatorKey.currentState!.context).clearMaterialBanners();
          ScaffoldMessenger.of(navigatorKey.currentState!.context).hideCurrentMaterialBanner();
          ScaffoldMessenger.of(navigatorKey.currentState!.context).removeCurrentMaterialBanner();

          // showNotification(
          //   error: 1, icon: Icons.wifi_off, 
          //   autoDismiss: false,
          //   message: "Check Your internet connection");
      //       showSimpleNotification(Text('Check Your internet connection'),
      // leading: Icon(Icons.wifi_off), 
      // // autoDismiss: status=='Offline'? false: true,
      // slideDismissDirection: DismissDirection.horizontal,
      // background: red);
            // noInternetNotification();
          notifyListeners();
        }
        // break;
    // }
  });
}



}