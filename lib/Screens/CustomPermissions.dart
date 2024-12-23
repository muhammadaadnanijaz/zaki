import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:zaki/Constants/HelperFunctions.dart';
import 'package:zaki/Constants/Spacing.dart';
import 'package:zaki/Services/CloudFunctions.dart';
import 'package:zaki/Widgets/ZakiPrimaryButton.dart';

class CustomPermissions extends StatefulWidget {
  const CustomPermissions({Key? key}) : super(key: key);

  @override
  State<CustomPermissions> createState() => _CustomPermissionsState();
}

class _CustomPermissionsState extends State<CustomPermissions> {
  @override
  Widget build(BuildContext context) { 
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ZakiPrimaryButton(
            title: 'Call Cloud Function',
            width: 200,
            onPressed: (){
              CloudFunctions().callFunction();
              //  CloudFunctions().helloFunction();
            },

          ),
          spacing_X_large,
          ZakiPrimaryButton(
            title: 'Grant Permissions',
            width: 200,
            onPressed: () async {
              // var status = 
              await Permission.contacts.request();
              var statuss = await Permission.contacts.status;
              logMethod(
                  title: 'Permission Contacts==>>>', message: statuss.name);
              if (statuss.name == 'denied') {
                logMethod(
                    title: 'Permission internal Contacts==>>>',
                    message: statuss.name);
                    openAppSettings();
                // We didn't ask for permission yet or the permission has been denied before but not permanently.
              }
            },
          ),
          spacing_medium,
          ZakiPrimaryButton(
            title: 'Remove Permissions',
            width: 200,
            onPressed: () async {
              await Permission.speech.request();
              if (await Permission.speech.isPermanentlyDenied) {
                // The user opted to never again see the permission request dialog for this
                // app. The only way to change the permission's status now is to let the
                // user manually enable it in the system settings.
                openAppSettings();
              }

              openAppSettings();
              var status = await Permission.contacts.isDenied;
              if (status) {
                // We didn't ask for permission yet or the permission has been denied before but not permanently.
                await Permission.contacts.request();
              }
              if (await Permission.contacts.isPermanentlyDenied) {
                // The user opted to never again see the permission request dialog for this
                // app. The only way to change the permission's status now is to let the
                // user manually enable it in the system settings.
                openAppSettings();
              }
            },
          ),
        ],
      ),
    );
  }
}
