// import 'package:flutter/cupertino.dart';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:ndialog/ndialog.dart';
import 'package:provider/provider.dart';
// import 'package:zaki/Constants/AuthMethods.dart';
import 'package:zaki/Constants/CheckInternetConnections.dart';
import 'package:zaki/Constants/LocationGetting.dart';
import 'package:zaki/Constants/NotificationTitle.dart';
import 'package:zaki/Payment/AndroidIosPayment.dart';
import 'package:zaki/Payment/PayFortConstants.dart';
import 'package:zaki/Services/CreaditCardApis.dart';
import 'package:zaki/Widgets/AppBars/AppBar.dart';
import 'package:zaki/Widgets/CustomConfermationScreen.dart';
import 'package:zaki/Widgets/SSLCustom.dart';
import 'package:zaki/Widgets/TermsAndConditionsSmall.dart';

import '../Constants/AppConstants.dart';
import '../Constants/HelperFunctions.dart';
import '../Constants/Spacing.dart';
import '../Constants/Styles.dart';
import '../Services/api.dart';
// import '../Widgets/SSLCustomRow.dart';
import '../Widgets/CustomLoadingScreen.dart';
import '../Widgets/ZakiPrimaryButton.dart';
// import 'package:flutter_amazonpaymentservices/environment_type.dart';
// import 'package:flutter_amazonpaymentservices/flutter_amazonpaymentservices.dart';


class FundMyWallet extends StatefulWidget {
  FundMyWallet({Key? key}) : super(key: key);

  @override
  State<FundMyWallet> createState() => _FundMyWalletState();
}

class _FundMyWalletState extends State<FundMyWallet> {
  final formGlobalKey = GlobalKey<FormState>();
  final securityCodeController = TextEditingController();
  final zipCodeController = TextEditingController();
  final amountController = TextEditingController();
  final cardHolderNameController = TextEditingController();
  final cardNumberController = TextEditingController();
  final expireDateController = TextEditingController();
  double processingFee = 0.00;
  String expiredDate = '';
  bool isCardChecked = true;
  bool cardStatusDeclined = false;
  bool cardStatusOthers = false;
  bool _obscureText = true;

  @override
  void initState() {
    checkCardSave();
    super.initState();
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setScreenName(name: AppConstants.FUND_MY_WALLET_SCREEN);
  }

  checkCardSave() {
    // appConstants.fundMeWalletModel.FM_WALLET_cardHolderName!
    Future.delayed(
      Duration.zero,
      () async {
        logMethod(title: 'Fund My Wallet Screen', message: 'Called');
        var appConstants = Provider.of<AppConstants>(context, listen: false);
        bool screenNotOpen =
            await checkUserSubscriptionValue(appConstants, context);
        logMethod(title: 'Data from Pay+', message: screenNotOpen.toString());
        if (screenNotOpen == true) {
          Navigator.pop(context);
        } else {
          if (appConstants.fundMeWalletModel.FM_WALLET_cardHolderName != null) {
            cardHolderNameController.text =
                appConstants.fundMeWalletModel.FM_WALLET_cardHolderName!;
            cardNumberController.text =
                appConstants.fundMeWalletModel.FM_WALLET_card_number!;
            appConstants.updateDateOfBirth(
                '${appConstants.fundMeWalletModel.FM_WALLET_expiryDate}');
            logMethod(
                title: 'Save Card Expiry Date',
                message:
                    '${appConstants.fundMeWalletModel.FM_WALLET_expiryDate}');
            expireDateController.text =
                '${appConstants.fundMeWalletModel.FM_WALLET_expiryDate}';
          }
        }
      },
    );
  }
  Set<String> _kProductIds = <String>{'your_product_id_1', 'your_product_id_2'};
  
  void _initializeProducts() async {
  final bool available = await InAppPurchase.instance.isAvailable();
  if (!available) {
    // Handle the store not available case
    return;
  }

  final ProductDetailsResponse response = await InAppPurchase.instance.queryProductDetails(_kProductIds);
  if (response.notFoundIDs.isNotEmpty) {
    // Handle the case when some products are not found
  }

  setState(() {
    // _products = response.productDetails;
  });
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
            key: formGlobalKey,
            child: Padding(
              padding: getCustomPadding(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  appBarHeader_005(
                      context: context,
                      appBarTitle: 'Fund my wallet',
                      height: height,
                      width: width,
                      tralingIconButton: SSLCustom()),
                      if(appConstants.allowApplePayAndGooglePay)
                      
                      // Platform.isIOS ? applePayButton : googlePayButton,
                      if(appConstants.payFortTestingModeForFundMyWallet)
                      Column(
                        children: [
                          Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0, vertical: 8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                          height: 25,
                                          width: 30,
                                          child: Checkbox(
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(4),
                                                side: BorderSide(color: green)),
                                            checkColor: white,
                                            activeColor:
                                                // isCardChecked ?
                                                // green
                                                // :
                                                grey,
                                            // fillColor: MaterialStateProperty.resolveWith(),
                                            value: cardStatusDeclined,
                                            onChanged:
                                                //  (cardNumberController
                                                //                 .text.length <
                                                //             19 ||
                                                //         amountController.text.isEmpty ||
                                                //         cardHolderNameController
                                                //             .text.isEmpty ||
                                                //         expireDateController.text.isEmpty ||
                                                //         zipCodeController.text.length < 5 ||
                                                //         securityCodeController.text.length <
                                                //             5)
                                                //     ? null
                                                //     :
                                                (bool? value) {
                                              setState(() {
                                                cardStatusDeclined = value!;
                                                // cardStatusOthers=!cardStatusDeclined;
                                              });
                                            },
                                          ),
                                        ),
                                        Text(
                                          'Declined',
                                          style: heading3TextStyle(width,
                                              color:
                                                  //  isCardChecked
                                                  //     ?
                                                  black
                                              // : grey.withValues(alpha:0.8)
                                              ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                          // spacing_medium,
                                            Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0, vertical: 8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                          height: 25,
                                          width: 30,
                                          child: Checkbox(
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(4),
                                                side: BorderSide(color: green)),
                                            checkColor: white,
                                            activeColor:
                                                // isCardChecked ?
                                                // green
                                                // :
                                                grey,
                                            // fillColor: MaterialStateProperty.resolveWith(),
                                            value: cardStatusOthers,
                                            onChanged:
                                                //  (cardNumberController
                                                //                 .text.length <
                                                //             19 ||
                                                //         amountController.text.isEmpty ||
                                                //         cardHolderNameController
                                                //             .text.isEmpty ||
                                                //         expireDateController.text.isEmpty ||
                                                //         zipCodeController.text.length < 5 ||
                                                //         securityCodeController.text.length <
                                                //             5)
                                                //     ? null
                                                //     :
                                                (bool? value) {
                                              setState(() {
                                                cardStatusOthers = value!;
                                                // cardStatusDeclined=!cardStatusOthers;
                                              });
                                            },
                                          ),
                                        ),
                                        Text(
                                          'Other status',
                                          style: heading3TextStyle(width,
                                              color:
                                                  //  isCardChecked
                                                  //     ?
                                                  black
                                              // : grey.withValues(alpha:0.8)
                                              ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                          spacing_medium,

                        ],
                      ),
                  
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        // color: white,
                        // elevation: 2,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: borderColor)
                        ), 
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Container(
                            // decoration: BoxDecoration(
                            //   borderRadius: BorderRadius.circular(14)
                            // ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'How Much?',
                                  style: heading1TextStyle(context, width,
                                      color: green),
                                ),
                                TextFormField(
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  validator: (String? amount) {
                                    if (amount!.isEmpty) {
                                      return 'Enter an Amount';
                                    } else if (double.parse(amount) > 1000) {
                                      return "Maximum ${getCurrencySymbol(context, appConstants: appConstants)}1000";
                                    } else {
                                      return null;
                                    }
                                  },
                                  // style: TextStyle(color: primaryColor),
                                  style: heading3TextStyle(width),
                                  controller: amountController,
                                  obscureText: false,
                                  keyboardType: TextInputType.number,
                                  maxLines: 1,
                                  maxLength: 4,
                                  // onFieldSubmitted: (String value) {
                                  //   processingFee = double.parse(value) * 0.01;
                                  // },
                                  onFieldSubmitted: (String value) {
                                    if (value.isNotEmpty) {
                                      setState(() {
                                        processingFee =
                                            double.parse(value) * 0.01;
                                      });
                                    }
                                  },
                                  decoration: InputDecoration(
                                    hintText: ' 0',
                                    counterText: '',
                                    isDense: true,
                                    // filled: true,
                                    // fillColor: white,
                                    border: circularOutLineBorder,
                                    enabledBorder: circularOutLineBorder,
                                    prefixIcon: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 6, bottom: 1, right: 4),
                                      child: Text(
                                        "${getCurrencySymbol(context, appConstants: appConstants)}",
                                        style: heading4TextSmall(width),
                                      ),
                                    ),
                                    prefixIconConstraints: const BoxConstraints(
                                        minWidth: 0, minHeight: 0),
                                    hintStyle: heading3TextStyle(width),
                                    // labelText: 'Enter Email',
                                    // labelStyle: textStyleHeading2WithTheme(context,width*0.8, whiteColor: 0),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Card Info',
                              style: heading1TextStyle(context, width,
                                  color: green),
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  height: 25,
                                  width: 30,
                                  child: Checkbox(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4),
                                        side: BorderSide(color: green)),
                                    checkColor: white,
                                    activeColor:
                                        // isCardChecked ?
                                        // green
                                        // :
                                        grey,
                                    // fillColor: MaterialStateProperty.resolveWith(),
                                    value: isCardChecked,
                                    onChanged:
                                        //  (cardNumberController
                                        //                 .text.length <
                                        //             19 ||
                                        //         amountController.text.isEmpty ||
                                        //         cardHolderNameController
                                        //             .text.isEmpty ||
                                        //         expireDateController.text.isEmpty ||
                                        //         zipCodeController.text.length < 5 ||
                                        //         securityCodeController.text.length <
                                        //             5)
                                        //     ? null
                                        //     :
                                        (bool? value) {
                                      setState(() {
                                        isCardChecked = value!;
                                      });
                                    },
                                  ),
                                ),
                                Text(
                                  'Save Card',
                                  style: heading3TextStyle(width,
                                      color:
                                          //  isCardChecked
                                          //     ?
                                          black
                                      // : grey.withValues(alpha:0.8)
                                      ),
                                ),
                                // Transform.scale(
                                //   scale: 0.6,
                                //   alignment: Alignment.centerRight,
                                //   child: CupertinoSwitch(
                                //     value: isCardChecked,
                                //     activeColor: isCardChecked ? green : grey,
                                //     trackColor: isCardChecked ? green : grey,
                                //     onChanged: (cardNumberController.text.length <
                                //                 19 ||
                                //             amountController.text.isEmpty ||
                                //             cardHolderNameController.text.isEmpty ||
                                //             expireDateController.text.isEmpty ||
                                //             zipCodeController.text.length < 5 ||
                                //             securityCodeController.text.length < 5)
                                //         ? null
                                //         : (value) async {
                                //             setState(() {
                                //               isCardChecked = value;
                                //             });
                                //             // if (isCardChecked) {
                                //             //   if(!formGlobalKey.currentState!.validate() ){
                                //             //     return;
                                //             //   }
                                //             //   else

                                //             // }
                                //           },
                                //   ),
                                // ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        // color: white,
                        // elevation: 2,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: borderColor)
                        ), 
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextFormField(
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                maxLength: 35,
                                validator: (String? name) {
                                  if (name!.isEmpty) {
                                    return 'Enter Name';
                                  } else {
                                    return null;
                                  }
                                },
                                style: heading3TextStyle(width),
                                controller: cardHolderNameController,
                                // obscureText: appConstants.passwordVissibleRegistration,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  isDense: true,
                                  counterText: '',
                                  border: circularOutLineBorder,
                                  enabledBorder: circularOutLineBorder,
                                  hintText: 'Card Holder name',
                                  hintStyle: heading3TextStyle(width),
                                ),
                              ),
                              spacing_medium,
                              TextFormField(
                                inputFormatters: [
                                  // CardFormatter(sample: "XXX-XXX-XXX", separator: "-")
                                  cardNumberMaskFormatter
                                ],
                                autovalidateMode: AutovalidateMode.disabled,
                                validator: (String? number) {
                                  if (number!.isEmpty) {
                                    return 'Enter Card Number';
                                  }
                                  if (number.toString().length < 17) {
                                    return 'Ooops, you seem to be missing some numbers!';
                                  } else {
                                    return null;
                                  }
                                },
                                style: heading3TextStyle(width),
                                controller: cardNumberController,
                                maxLength: 19,
                                // obscureText: appConstants.passwordVissibleRegistration,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                    isDense: true,
                                    counterText: '',
                                    hintText: 'Card Number',
                                    hintStyle: heading3TextStyle(width),
                                    border: circularOutLineBorder,
                                    enabledBorder: circularOutLineBorder,
                                    suffixIconColor: grey,
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 6),
                                    suffixIcon: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        CardTypeIcons(
                                          icon: FontAwesomeIcons.ccVisa,
                                        ),
                                        CardTypeIcons(
                                          icon: FontAwesomeIcons.ccMastercard,
                                        ),
                                        CardTypeIcons(
                                          icon: FontAwesomeIcons.ccAmex,
                                        ),
                                      ],
                                    )),
                              ),
                              spacing_medium,
                              Row(
                                children: [
                                  Expanded(
                                      child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 2.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        TextFormField(
                                          // enabled: false,
                                          // readOnly: true,
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          inputFormatters: [
                                            dateFormateMaskFormatter
                                          ],
                                          // obscureText: true,
                                          // obscuringCharacter: '*',
                                          onTap: () async {
                                            expiredDate =
                                                expireDateController.text;
                                            setState(() {});

                                            // DateTime toDay = DateTime.now();
                                            // DateTime? dateTime = await showDatePicker(
                                            //     context: context,
                                            //     initialDate: toDay,
                                            //     firstDate: toDay,
                                            //     lastDate: DateTime(toDay.year + 9,
                                            //         toDay.month + 7, toDay.day),
                                            //     initialEntryMode:
                                            //         DatePickerEntryMode.calendar);
                                            // // ignore: unnecessary_null_comparison
                                            // if (dateTime != null) {
                                            //   print(
                                            //       'Selected date is: ${dateTime.day}');
                                            //   appConstants.updateDateOfBirth(
                                            //       '${dateTime.month} / ${dateTime.year}');
                                            //   expireDateController.text =
                                            //       appConstants.dateOfBirth;
                                            //   setState(() {
                                            //     expiredDate = dateTime;
                                            //   });
                                            // }
                                          },
                                          validator: (String? date) {
                                            // return null;

                                            if (date!.isEmpty) {
                                              return 'Select a date';
                                            } else {
                                              String firstDate =
                                                  date.split('/')[0];
                                              if (int.parse(firstDate) > 12) {
                                                return 'Invalid Date';
                                              }
                                              String secondDate =
                                                  date.split('/').last;
                                              logMethod(
                                                  title:
                                                      'Second Date: ${DateTime.now().year.toString().substring(2, 4)} and next year${(DateTime.now().year + 7).toString().substring(2, 4)}',
                                                  message: secondDate);
                                              //Checking that user enter year == current year
                                              if (int.parse(secondDate) ==
                                                  int.parse(DateTime.now()
                                                      .year
                                                      .toString()
                                                      .substring(2, 4))) {
                                                //Now checking that its upto 3 months
                                                if (int.parse(firstDate) <=
                                                    int.parse(
                                                        (DateTime.now().month +
                                                                3)
                                                            .toString())) {
                                                  return 'Card almost expired';
                                                }
                                              }
                                              if (int.parse(secondDate) <
                                                      int.parse(DateTime.now()
                                                          .year
                                                          .toString()
                                                          .substring(2, 4)) ||
                                                  int.parse(secondDate) >=
                                                      int.parse(((DateTime.now()
                                                                  .year +
                                                              7)
                                                          .toString()
                                                          .substring(2, 4)))) {
                                                return 'Invalid Date';
                                              }
                                              logMethod(
                                                  title: 'Date',
                                                  message: firstDate);
                                              return null;
                                            }
                                          },
                                          maxLength: 8,
                                          decoration: InputDecoration(
                                            counterText: "",
                                            isDense: true,
                                            border: circularOutLineBorder,
                                            enabledBorder:
                                                circularOutLineBorder,
                                            hintText: 'MM/YY (exp)',
                                            hintStyle: heading3TextStyle(width),
                                          ),
                                          style: heading3TextStyle(width),
                                          controller: expireDateController,
                                          // obscureText: appConstants.passwordVissibleRegistration,
                                          keyboardType: TextInputType.datetime,
                                        ),
                                      ],
                                    ),
                                  )),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                      child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 2.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [],
                                        ),
                                        TextFormField(
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly
                                          ],
                                          maxLength: 5,
                                          validator: (String? code) {
                                            if (code!.isEmpty) {
                                              return 'Enter Security Code';
                                            } else if (code.length < 5) {
                                              return 'Enter Full Security Code';
                                            }
                                            // else {
                                            return null;
                                            // }
                                          },
                                          obscureText: _obscureText,
                                          decoration: InputDecoration(
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    horizontal: 12),
                                            suffixIcon: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      _obscureText =
                                                          !_obscureText;
                                                    });
                                                  },
                                                  child: Icon(_obscureText
                                                      ? Icons.visibility
                                                      : Icons.visibility_off)),
                                            ),
                                            counterText: '',
                                            isDense: true,
                                            border: circularOutLineBorder,
                                            enabledBorder:
                                                circularOutLineBorder,
                                            hintText: 'CVC / CVV',
                                            hintStyle: heading3TextStyle(width),
                                          ),
                                          style: heading3TextStyle(width),
                                          controller: securityCodeController,
                                          // obscureText: appConstants.passwordVissibleRegistration,
                                          keyboardType: TextInputType.number,
                                        ),
                                      ],
                                    ),
                                  ))
                                ],
                              ),
                              spacing_medium,
                              Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      maxLength: 5,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      validator: (String? zipCode) {
                                        // return null;

                                        if (zipCode!.isEmpty) {
                                          return 'Enter ZipCode';
                                        } else if (zipCode.length < 5) {
                                          return 'Enter Full Zip code';
                                        }
                                        // else {
                                        return null;
                                        // }
                                      },
                                      // obscureText: true,
                                      decoration: InputDecoration(
                                        counterText: '',
                                        isDense: true,
                                        border: circularOutLineBorder,
                                        enabledBorder: circularOutLineBorder,
                                        hintText: 'Zip Code',
                                        hintStyle: heading3TextStyle(width),
                                      ),
                                      style: heading3TextStyle(width),
                                      controller: zipCodeController,
                                      // obscureText: appConstants.passwordVissibleRegistration,
                                      keyboardType: TextInputType.number,
                                    ),
                                  ),
                                  Expanded(
                                      child: SizedBox(
                                    width: width * 0.1,
                                  ))
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      spacing_medium,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TermsAndConditionsSmallText(width: width),
                          Row(
                            children: [
                              Text(
                                'Processing Fee:  ',
                                style: heading4TextSmall(width),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 12.0),
                                child: Text(
                                  '${getCurrencySymbol(context, appConstants: appConstants)} ${processingFee.toStringAsFixed(2)}',
                                  style: heading3TextStyle(width, font: 12),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      // spacing_medium,
                      // SSLCustomRow(),
                      spacing_large,
                      ZakiPrimaryButton(
                          title: 'Fund Now',
                          width: width,
                          onPressed: (internet.status ==
                                      AppConstants
                                          .INTERNET_STATUS_NOT_CONNECTED ||
                                  cardNumberController.text.length < 19 ||
                                  amountController.text.isEmpty ||
                                  int.tryParse(amountController.text.trim())! >
                                      1000 ||
                                  cardHolderNameController.text.isEmpty ||
                                  expireDateController.text.isEmpty ||
                                  int.parse(expireDateController.text
                                          .split('/')[0]) >
                                      12 ||
                                  zipCodeController.text.length < 5 ||
                                  securityCodeController.text.length < 3)
                              // formGlobalKey.currentState?.validate() ?? true
                              ? null
                              : () async {
                                  if (!formGlobalKey.currentState!.validate()) {
                                    return;
                                  }
                                  if(appConstants.payFortTestingModeForFundMyWallet)
                                  if(cardStatusDeclined){
                                    CustomProgressDialog progressDialog =
                                      CustomProgressDialog(context, blur: 3);
                                  progressDialog
                                      .setLoadingWidget(CustomLoadingScreen());
                                  progressDialog.show();
                                    Future.delayed(Duration(seconds: 2), (){
                                      progressDialog.dismiss();
                                      showNotification(error: 1, icon: Icons.error_outline, message: "Credit card declined please try again with another part.");
                                    } );
                                    return;
                                    // cardStatusDeclined=!cardStatusOthers;
                                  }
                                  if(appConstants.payFortTestingModeForFundMyWallet)
                                  if(cardStatusOthers){
                                    CustomProgressDialog progressDialog =
                                      CustomProgressDialog(context, blur: 3);
                                  progressDialog
                                      .setLoadingWidget(CustomLoadingScreen());
                                  progressDialog.show();
                                    Future.delayed(Duration(seconds: 2), (){
                                      progressDialog.dismiss();
                                    showNotification(error: 1, icon: Icons.credit_card_outlined, message: "There is an error while processing your card. Please try again.");
                                    } );
                                    return;
                                  }
                                  Position userLocation =await UserLocation().determinePosition();
                                  // bool? checkAuth = await authenticateTransactionUsingBioOrPinCode(appConstants: appConstants, context: context);
                                  // if(checkAuth==false){
                                  //   return;
                                  // }
                                  CustomProgressDialog progressDialog =
                                      CustomProgressDialog(context, blur: 3);
                                  progressDialog
                                      .setLoadingWidget(CustomLoadingScreen());
                                  progressDialog.show();

                                  ApiServices service = ApiServices();
                                  service.addTransaction( 
                                      transactionMethod: AppConstants
                                          .Transaction_Method_Received,
                                      tagItName: AppConstants
                                          .TAG_IT_Transaction_TYPE_Fund_My_Wallet,
                                      tagItId: "15",
                                      selectedKidName:
                                          appConstants.userModel.usaUserName,
                                      accountHolderName:
                                          appConstants.userModel.usaUserName,
                                      amount: amountController.text.trim(),
                                      currentUserId:
                                          appConstants.userRegisteredId,
                                      receiverId: appConstants.userRegisteredId,
                                      requestType: AppConstants
                                          .TAG_IT_Transaction_TYPE_Fund_My_Wallet,
                                      senderId: appConstants.userRegisteredId,
                                      message: '',
                                      fromWallet: 'Card',
                                      toWallet: AppConstants.Spend_Wallet);
                                  //  service.addTransaction(
                                  //         transactionMethod: AppConstants.Transaction_Method_Payment,
                                  //         tagItId : AppConstants.GOAL,
                                  //         tagItId: "8",
                                  //         selectedKidName: appConstants.userModel.usaUserName,
                                  //         accountHolderName: appConstants.userModel.usaUserName,
                                  //         amount: amountController.text.trim(),
                                  //         currentUserId: appConstants.userRegisteredId,
                                  //         receiverId: appConstants.userRegisteredId,
                                  //         requestType: AppConstants.TAG_IT_Transaction_TYPE_Fund_My_Wallet,
                                  //         senderId: appConstants.userRegisteredId,
                                  //         message: '',
                                  //         fromWallet: 'Card',
                                  //         toWallet: AppConstants.Spend_Wallet
                                  //       );

                                  if (isCardChecked) {
                                    await service.saveCardInfoForFuture(
                                        amount: amountController.text.trim(),
                                        cardHolderName:
                                            cardHolderNameController.text,
                                        cardNumber: cardNumberController.text,
                                        cardStatus: true,
                                        expiryDate: expireDateController.text,
                                        id: appConstants.userRegisteredId);
                                    // service.getfun
                                  } else if (appConstants.fundMeWalletModel
                                              .FM_WALLET_cardHolderName !=
                                          null &&
                                      isCardChecked == false) {
                                    //Delete the card
                                    service.deleteCard(
                                        id: appConstants.userRegisteredId);
                                  }
                                  await service.addMoneyToMainWallet(
                                      amountSend: amountController.text.trim(),
                                      senderId: appConstants.userRegisteredId);
                                  await service.saveProcessingFee(
                                      feeAmount: processingFee,
                                      totalAmount: double.parse(
                                          amountController.text.trim()),
                                      id: appConstants.userRegisteredId);
                                  await service.getUserData(
                                      context: context,
                                      userId: appConstants.userRegisteredId);
                                  await CreaditCardApi().addAmountFromCardToBank(
                                      amount: amountController.text.trim(),
                                      name: appConstants.userModel.usaFirstName,
                                      userToken:
                                          appConstants.userModel.userTokenId,
                                      tags: createMemo(
                                          fromWallet: AppConstants.Spend_Wallet,
                                          toWallet: AppConstants.Spend_Wallet,
                                          transactionMethod: AppConstants
                                              .Transaction_Method_Received,
                                          tagItName: AppConstants.GOAL,
                                          tagItId: "15",
                                          goalId: '',
                                          transactionType: AppConstants
                                              .TAG_IT_Transaction_TYPE_Fund_My_Wallet,
                                          receiverId:
                                              appConstants.userRegisteredId,
                                          senderId:
                                              appConstants.userRegisteredId,
                                          transactionId: '',
                                          latLng: '${userLocation.latitude},${userLocation.longitude}'
                                          ));

                                  /// This is precessing fee That will be added to ZAKI PAY Account
                                  await CreaditCardApi().addAmountFromCardToBank(
                                      amount: processingFee.toString(),
                                      name: appConstants.userModel.usaFirstName,
                                      userToken:
                                          AppConstants.ZAKI_PAY_ACCOUNT_NUMBER,
                                      tags: createMemo(
                                          fromWallet: AppConstants.Spend_Wallet,
                                          toWallet: AppConstants.Spend_Wallet,
                                          transactionMethod: AppConstants
                                              .Transaction_Method_Received,
                                          tagItName: AppConstants.GOAL,
                                          tagItId: "15",
                                          goalId: '',
                                          transactionType: AppConstants
                                              .TAG_IT_Transaction_TYPE_Fund_My_Wallet,
                                          receiverId:
                                              appConstants.userRegisteredId,
                                          senderId:
                                              appConstants.userRegisteredId,
                                          transactionId: 'fee',
                                          latLng: '${userLocation.latitude},${userLocation.longitude}'
                                          ));

                                  // await CreaditCardApi().moveMoney(
                                  //   amount: processingFee.toString(),
                                  //   name: appConstants.userModel.usaFirstName,
                                  //   senderUserToken: appConstants.userModel.userTokenId,
                                  //   receiverUserToken:
                                  //   );

                                  progressDialog.dismiss();
                                  showNotification(
                                      error: 0,
                                      icon: Icons.check,
                                      message: NotificationText.WALLET_UPDATED);
                                  // Navigator.pop(context);

                                  // Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (context) => ConfirmedScreen(
                                  //               amount: amountController.text
                                  //                   .trim(),
                                  //               // name: appConstants.userModel.usaUserName,
                                  //               walletImageUrl:
                                  //                   imageBaseAddress +
                                  //                       'spending_act.png',
                                  //               fromCreaditCardScreen: true,
                                  //             )));
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute( 
                                          builder: (context) =>
                                              CustomConfermationScreen(
                                                subTitle:
                                                    "${getCurrencySymbol(context, appConstants: appConstants)} ${amountController.text} added to your \n${appConstants.nickNameModel.NickN_SpendWallet ?? 'Spend'} Wallet",
                                              )));
                                }),
                      spacing_medium
                    ],
                  ),
                  if(appConstants.payFortTestingModeForFundMyWallet)
                  ZakiPrimaryButton(
                    title: 'Checking Payfort testing',
                    width: width,
                    onPressed: () async{

                      var requestParam = {
                        "amount": 100,
                        "command": "AUTHORIZATION",
                        "currency": "USD",
                        "customer_email": "test@gmail.com",
                        "language": "en",
                        "merchant_reference": "${Payfortconstants.MERCHANT_TOKEN}",
                        "sdk_token": "Dwp78q3"
                      }; 

                      try {
                        var result = '';
                        // await FlutterAmazonpaymentservices.normalPay(requestParam, EnvironmentType.sandbox, isShowResponsePage: true);
                        logMethod(title: "Payment status", message: result.toString());
                      } on PlatformException catch (e) 
                      {
                        print("Error ${e.message} details:${e.details}"); return;
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CardTypeIcons extends StatelessWidget {
  const CardTypeIcons({Key? key, required this.icon}) : super(key: key);
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Icon(
        icon,
        size: 14,
      ),
    );
  }
}
