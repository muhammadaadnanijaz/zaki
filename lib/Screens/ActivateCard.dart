import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:zaki/Constants/CheckInternetConnections.dart';
// import 'package:zaki/Constants/NotificationTitle.dart';
import 'package:zaki/Constants/Spacing.dart';
import 'package:zaki/Services/CreaditCardApis.dart';
import 'package:zaki/Widgets/CustomConfermationScreen.dart';
// import 'package:zaki/Widgets/CustomSizedBox.dart';
import 'package:zaki/Widgets/ZakiPrimaryButton.dart';
import 'package:zaki/Constants/Whitelable.dart';

import '../Constants/AppConstants.dart';
import '../Constants/HelperFunctions.dart';
import '../Constants/Styles.dart';
import '../Services/api.dart';
import '../Widgets/AppBars/AppBar.dart';
import '../Widgets/BackgroundConatiner.dart';

// ignore: must_be_immutable
class ActivateCard extends StatefulWidget {
  var snapShot;
  String? selectedUserId;
  ActivateCard({Key? key, this.snapShot, this.selectedUserId})
      : super(key: key);

  @override
  State<ActivateCard> createState() => _ActivateCardState();
}

class _ActivateCardState extends State<ActivateCard> {
  final pinCodeController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    pinCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var appConstants = Provider.of<AppConstants>(context, listen: true);
    var internet = Provider.of<CheckInternet>(context, listen: true);

    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView( 
          child: Form(
            key: formKey,
            autovalidateMode: AutovalidateMode.disabled,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  appBarHeader_005(
                      context: context,
                      appBarTitle: (appConstants.forCardLockStatus == true &&
                              widget.snapShot![
                                      AppConstants.ICard_lockedStatus] ==
                                  true)
                          ? 'Lock Card'
                          : (appConstants.forCardLockStatus == true &&
                                  widget.snapShot![
                                          AppConstants.ICard_lockedStatus] ==
                                      false)
                              ? 'Unlock Card'
                              : widget.snapShot![AppConstants.ICard_cardStatus] == false
                                  ? 'Deactivate Card'.tr()
                                  : 'Activate Card'.tr(),
                      backArrow: true,
                      height: height,
                      width: width,
                      leadingIcon: true),
                  Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: CreaditCard(width, appConstants, height,
                            snapshot: widget.snapShot),
                      ),
                      if (widget.snapShot![AppConstants.ICard_cardStatus] ==
                          false)
                        Center(
                          child: InActivteCard(),
                        )
                      // if (appConstants.forCardLockStatus == true)
                      // Positioned(
                      //   top: height * 0.05,
                      //   left: width * 0.4,
                      //   child: Icon(

                      //         ? Icons.lock_clock
                      //         : Icons.lock_open,
                      //     color: white,
                      //     size: height * 0.08,
                      //   ),
                      // )
                    ],
                  ),
                  spacing_medium,
                  Container(
                    color: transparent,
                    // margin: const EdgeInsets.all(20.0),
                    padding: const EdgeInsets.symmetric(horizontal: 2.0),
                    child: Pinput(
                      length: appConstants.userModel.usaPinCodeLength as int,
                      // onSubmit: (String pin) => _showSnackBar(pin, context),
                      // focusNode: _pinPutFocusNode,
                      controller: pinCodeController,
                      obscuringCharacter: '*',
                      errorTextStyle: heading4TextSmall(width, color: red),
                      obscureText: true,
                      onChanged: (String pin) {},
                      validator: (String? pin) {
                        if (pin!.isEmpty) {
                          return 'Please Enter pin';
                        } else if (pin.length <
                            appConstants.userModel.usaPinCodeLength!) {
                          return 'Please Enter full pin';
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                  spacing_medium,
                  TextButton(
                    child: Text(
                      "Forgot your Pin Code?".tr(),
                      style: heading4TextSmall(width),
                    ),
                    onPressed: () {},
                  ),
                  spacing_large,
                  InkWell(
                    onTap: internet.status ==
                            AppConstants.INTERNET_STATUS_NOT_CONNECTED
                        ? null
                        : () async {
                            if (appConstants.userModel.usaTouchEnable != null &&
                                appConstants.userModel.usaTouchEnable!) {
                              bool isAuth =
                                  await ApiServices().userLoginBioMetric();
                              if (isAuth) {
                                showSnackBarDialog(
                                    context: context, message: 'Done!');
                                Future.delayed(const Duration(seconds: 1), () {
                                  // Navigator.pop(context, "Successfully");
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              CustomConfermationScreen(
                                                subTitle:
                                                    "Your card has been ${widget.snapShot![AppConstants.ICard_cardStatus] == true?'deactivated':'activated'}",
                                              )));
                                });
                              } else {
                                showSnackBarDialog(
                                    context: context,
                                    message: 'Ooops, something went wrong :( ');
                              }
                            } else {
                              showSnackBarDialog(
                                  context: context,
                                  message: 'You cant Use Touch ID');
                            }
                          },
                    child: Icon(
                      Platform.isAndroid ? Icons.fingerprint : Icons.camera_alt,
                      size: width * 0.2,
                      color: green,
                    ),
                  ),
                  // CustomSizedBox(
                  //   height: height,
                  // ),
                  // Text(
                  //   'Use Biometic ID to \nactivate card'.tr(),
                  //   style: heading4TextSmall(width),
                  // ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: width * 0.06, vertical: width * 0.03),
                    child: ZakiPrimaryButton(
                        title:
                            widget.snapShot![AppConstants.ICard_cardStatus] ==
                                    true
                                ? 'Deactivate'.tr()
                                : 'Activate'.tr(),
                        width: width,
                        onPressed: (pinCodeController.text.isEmpty ||
                                (appConstants.pinLength == 4 &&
                                    pinCodeController.text.length < 4) ||
                                (appConstants.pinLength == 6 &&
                                    pinCodeController.text.length < 6))
                            ? null
                            : internet.status ==
                                    AppConstants.INTERNET_STATUS_NOT_CONNECTED
                                ? null
                                : () {
                                  AppConstants.TEMP_CODE;
                                  
                                    if (!formKey.currentState!.validate()) {
                                      return;
                                    } else {
                                      if (encryptedValue(
                                              value: pinCodeController.text) ==
                                          appConstants.userModel.usaPinCode) {
                                        CreaditCardApi creaditCardApi =
                                            CreaditCardApi();
                                        ApiServices().updateCardStatus(
                                            id: widget.selectedUserId,
                                            parentId:
                                                appConstants.userRegisteredId,
                                            status: widget.snapShot[AppConstants
                                                        .ICard_cardStatus] ==
                                                    true
                                                ? false
                                                : true);
                                        creaditCardApi.updateCardStatus(
                                          cardToken: widget.snapShot![
                                              AppConstants.ICard_Token],
                                          status: widget.snapShot![AppConstants
                                                      .ICard_cardStatus] ==
                                                  true
                                              ? 'ACTIVE'
                                              : 'SUSPENDED',
                                        );
                                        ApiServices().getUserTokenAndSendNotification(
                                            userId: widget.selectedUserId,
                                            title: widget.snapShot![AppConstants
                                                        .ICard_cardStatus] ==
                                                    true
                                                ? '${appConstants.userModel.usaUserName} ${NotificationText.DE_ACTIVATE_CRAD_TITLE}'
                                                : NotificationText
                                                        .ACTIVATE_CRAD_TITLE +
                                                    '${appConstants.userModel.usaUserName}',
                                            subTitle: widget.snapShot![
                                                        AppConstants
                                                            .ICard_cardStatus] ==
                                                    true
                                                ? NotificationText
                                                    .DE_ACTIVATE_CARD_SUBTITLE
                                                : NotificationText
                                                    .ACTIVATE_CARD_SUBTITLE);
                                        // Navigator.pop(context, "Successfuly");
                                        Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              CustomConfermationScreen(
                                                subTitle:
                                                    "Your card has been ${widget.snapShot![AppConstants.ICard_cardStatus] == true?'deactivated':'activated'}",
                                              )));
                                      } else {
                                        showNotification(
                                            error: 1,
                                            icon: Icons.error,
                                            message: NotificationText
                                                .PIN_CODE_NOT_MATCHED);
                                      }
                                    }
                                  }),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container CreaditCard(double width, AppConstants appConstants, double height,
      {var snapshot}) {
    return Container(
      // Color(0XFF9831F5)
      height: height * 0.28,
      width: width,
      decoration: cardBackgroundConatiner(width, black, backgroundImageUrl: ''),
      child: Padding(
        padding: const EdgeInsets.only(left: 22.0, bottom: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              '${snapshot[AppConstants.ICard_firstName]} ${snapshot[AppConstants.ICard_lastName]}',
              style: heading2TextStyle(context, width, color: white),
            )
            // Column(
            //   crossAxisAlignment: CrossAxisAlignment.end,
            //   children: [
            //     Row(
            //       mainAxisAlignment: MainAxisAlignment.start,
            //       children: [

            //         // Transform.scale(
            //         //   scale: 0.7,
            //         //   child: CupertinoSwitch(
            //         //     value: snapshot[AppConstants.ICard_cardStatus],
            //         //     activeColor: white,
            //         //     thumbColor:
            //         //         snapshot[AppConstants.ICard_cardStatus] == false
            //         //             ? red
            //         //             : green,
            //         //     trackColor: white,
            //         //     onChanged: (value) async {
            //         //       appConstants.updateForCardLockStatus(from: false);
            //         //       var response = await Navigator.push(
            //         //           context,
            //         //           MaterialPageRoute(
            //         //               builder: (context) => ActivateCard(
            //         //                     snapShot: snapshot,
            //         //                   )));
            //         //       logMethod(
            //         //           title: 'PIN Code match status:',
            //         //           message: response ?? 'Not');
            //         //       if (response != null) {
            //         //         ApiServices apiServices = ApiServices();
            //         //         await apiServices.updateCardStatus(
            //         //             id: cardAlreadyExist.id,
            //         //             parentId: appConstants.userRegisteredId,
            //         //             status: value);
            //         //       }
            //         //     },
            //         //   ),
            //         // ),
            //       ],
            //     ),
            //     // TextValue2(
            //     //   title: 'Balance: \n50.00 ${getCurrencySymbol(context, appConstants: appConstants )}',
            //     // ),
            //   ],
            // ),
            // spacing_medium,
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     TextValue2(
            //       title: '**** 1289',
            //     ),
            //     TextHeader1(
            //       title: '09/25',
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}

class InActivteCard extends StatelessWidget {
  const InActivteCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: double.infinity,
      // color: grey,
      child: Image.asset(
        imageBaseAddress + "inactive_card.png",
      ),
    );
  }
}
