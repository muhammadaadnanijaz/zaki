import 'package:flutter/material.dart';
import 'package:zaki/Constants/Styles.dart';
import 'package:zaki/Widgets/TextHeader.dart';

Future<dynamic> confirmPinDialoge(
    BuildContext context, int pinLength, _pinPutDecoration) {
  return showGeneralDialog(
      barrierLabel: "Barrier",
      barrierDismissible: false,
      transitionDuration: Duration(milliseconds: 300),
      context: context,
      pageBuilder: (BuildContext context, __, ___) {
        // var width = MediaQuery.of(context).size.width;
        return StatefulBuilder(
            builder: (BuildContext context,
                    void Function(void Function()) setState) =>
                AlertDialog(
                    backgroundColor: white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0))),
                    elevation: 20,
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextHeader1(
                          title: 
                          'Confirm Pin',
                        ),
                        IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              Icons.clear,
                              color: black,
                            ))
                      ],
                    ),
                    content: SingleChildScrollView(
                      child: Column(
                        children: [
                          // Container(
                          //     color: transparent,
                          //     // margin: const EdgeInsets.all(20.0),
                          //     padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          //     child: Pinput(
                          //       fieldsCount: pinLength,
                          //       // obscureText: appConstants.obSecurePin?null:'*',
                          //       // onSubmit: (String pin) => _showSnackBar(pin, context),
                          //       // focusNode: _pinPutFocusNode,
                          //       controller: pinCodeController,
                          //       submittedFieldDecoration: _pinPutDecoration,
                          //       selectedFieldDecoration: _pinPutDecoration,
                          //       followingFieldDecoration: _pinPutDecoration
                          //     ),
                          //   ),
                          //   const SizedBox(height: 10,),
                          //   ZakiPrimaryButton(
                          //     title: 'Confirm',
                          //     width: width,
                          //     onPressed: (){
                          //       Navigator.pop(context, pinCodeController.text);
                          //     })
                        ],
                      ),
                    )));
      });
}
