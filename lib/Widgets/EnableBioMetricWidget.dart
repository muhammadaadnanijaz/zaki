import 'package:flutter/material.dart';
import 'package:zaki/Constants/AppConstants.dart';
import 'package:zaki/Constants/HelperFunctions.dart';
import 'package:zaki/Constants/Styles.dart';
import 'package:zaki/Services/api.dart';

class EnableBioMetricWidget extends StatelessWidget {
  const EnableBioMetricWidget({
    Key? key,
    required this.appConstants,
    required this.width,
  }) : super(key: key);

  final AppConstants appConstants;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
        onTap: appConstants.isTouchEnable? null: () async {
                  bool isAuth = await ApiServices().userLoginBioMetric();
                  logMethod(title: 'Enabled task', message: isAuth.toString());
                  if (isAuth) {
                    appConstants.updateToucheds(isAuth);
                    ApiServices services = ApiServices();
                    await services.updateUserTouchStatus(appConstants.userRegisteredId, isAuth);
                    // setState(() {
                    //   appConstants.isTouchEnable = true;
                    // });
                    // showSnackBarDialog(
                    //     context: context, message: 'Biomettric enabled');
                  } else {
                    // appConstants.isTouchEnable = false;
                    // appConstants.updateToucheds(isAuth);
                    // showSnackBarDialog(
                    //     context: context,
                    //     message: 'Ooops...Something went wrong :(');
                  }
                },
        child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              border: appConstants.isTouchEnable? null: Border.all(color: green)
            ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                padding: EdgeInsets.zero,
                icon: Icon(
                  Icons.fingerprint,
                  color: 
                  appConstants.isTouchEnable ? grey : 
                  green,
                  size: width *  0.1,
                ),
                onPressed: appConstants.isTouchEnable? null: () async {
                  bool isAuth = await ApiServices().userLoginBioMetric();
                  logMethod(title: 'Enabled task', message: isAuth.toString());
                  if (isAuth) {
                    appConstants.updateToucheds(isAuth);
                    ApiServices services = ApiServices();
                    await services.updateUserTouchStatus(appConstants.userRegisteredId, isAuth);
                    // setState(() {
                    //   appConstants.isTouchEnable = true;
                    // });
                    // showSnackBarDialog(
                    //     context: context, message: 'Biomettric enabled');
                  } else {
                    // appConstants.isTouchEnable = false;
                    // appConstants.updateToucheds(isAuth);
                    // showSnackBarDialog(
                    //     context: context,
                    //     message: 'Ooops...Something went wrong :(');
                  }
                },
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Text(
                  appConstants.isTouchEnable? 'Enabled':'Enable',
                  style: heading3TextStyle(width, color: appConstants.isTouchEnable?null:green),
                ),
              ),
              if(appConstants.isTouchEnable)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Icon(Icons.check, color: grey, size: width* 0.06,),
              )
            ],
          ),
        ),
      ),
    );
  }
}
