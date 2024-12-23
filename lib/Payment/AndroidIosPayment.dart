import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pay/pay.dart';
import 'package:zaki/Payment/Payment.dart';
String os = Platform.operatingSystem;

  var applePayButton = ApplePayButton(
    paymentConfiguration: PaymentConfiguration.fromJsonString(defaultApplePay),
    paymentItems: const [
      PaymentItem(
        label: 'Item A',
        amount: '0.01',
        status: PaymentItemStatus.final_price,
      ),
      PaymentItem(
        label: 'Item B',
        amount: '0.01',
        status: PaymentItemStatus.final_price,
      ),
      PaymentItem(
        label: 'Total',
        amount: '0.02',
        status: PaymentItemStatus.final_price,
      )
    ],
    style: ApplePayButtonStyle.black,
    width: double.infinity,
    height: 50,
    type: ApplePayButtonType.buy,
    margin: const EdgeInsets.only(top: 15.0),
    onPaymentResult: (result) => debugPrint('Payment Result $result'),
    loadingIndicator: const Center(
      child: CircularProgressIndicator(),
    ),
  );

  var googlePayButton = GooglePayButton(
    paymentConfiguration: PaymentConfiguration.fromJsonString(defaultGooglePay),
    paymentItems: const [
      PaymentItem(
        label: 'Total',
        amount: '5000',
        status: PaymentItemStatus.final_price,
      )
    ],
    type: GooglePayButtonType.pay,
    margin: const EdgeInsets.only(top: 2.0),
    cornerRadius: 4,
    width: 800,
    theme: GooglePayButtonTheme.light,
    onPaymentResult: (result) {
      if(result!=null){
        // Take towards Success Screen
      }else{
        // Show Error
      }
    },
    loadingIndicator: const Center(
      child: CircularProgressIndicator(),
    ),
  );

class AndroidIosPayment extends StatefulWidget {
  const AndroidIosPayment(
      {Key? key,}): super(key: key);

  @override
  State<AndroidIosPayment> createState() => _AndroidIosPaymentState();
}

class _AndroidIosPaymentState extends State<AndroidIosPayment> {
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Center(child: Platform.isIOS ? applePayButton : googlePayButton),
      ),
    );
  }
}