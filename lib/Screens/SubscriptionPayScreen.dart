import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ndialog/ndialog.dart';
import 'package:provider/provider.dart';
import 'package:zaki/Constants/AppConstants.dart';
import 'package:zaki/Constants/Whitelable.dart';
// import 'package:zaki/Constants/AuthMethods.dart';
import 'package:zaki/Constants/CheckInternetConnections.dart';
import 'package:zaki/Constants/HelperFunctions.dart';
import 'package:zaki/Constants/LocationGetting.dart';
// import 'package:zaki/Constants/NotificationTitle.dart';
import 'package:zaki/Constants/Spacing.dart';
import 'package:zaki/Constants/Styles.dart';
import 'package:zaki/Screens/AddMembersWorkFlow.dart';
import 'package:zaki/Screens/FundMyWallet.dart';
import 'package:zaki/Screens/HomeScreen.dart';
import 'package:zaki/Services/CreaditCardApis.dart';
import 'package:zaki/Services/api.dart';
import 'package:zaki/Widgets/AppBars/AppBar.dart';
import 'package:zaki/Widgets/CustomConfermationScreen.dart';
import 'package:zaki/Widgets/CustomLoadingScreen.dart';
import 'package:zaki/Widgets/SSLCustom.dart';
import 'package:zaki/Widgets/ZakiPrimaryButton.dart';

class SubscriptionPayScreen extends StatefulWidget {
  final String? subScriptionAmount;
  final String? packageName;
  final String? method;
  const SubscriptionPayScreen(
      {Key? key, this.subScriptionAmount, this.packageName, this.method})
      : super(key: key);

  @override
  State<SubscriptionPayScreen> createState() => _SubscriptionPayScreenState();
}

class _SubscriptionPayScreenState extends State<SubscriptionPayScreen> {
  final formGlobalKey = GlobalKey<FormState>();
  final securityCodeController = TextEditingController();
  final zipCodeController = TextEditingController();
  final amountController = TextEditingController();
  final cardHolderNameController = TextEditingController();
  final cardNumberController = TextEditingController();
  final expireDateController = TextEditingController();
  // double processingFee = 0.00;
  String expiredDate = '';
  bool isCardChecked = true;
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    // setState(() {
    //    processingFee = double.parse(widget.subScriptionAmount.toString()) * 0.01;
    // });
  }

  @override
  Widget build(BuildContext context) {
    var appConstants = Provider.of<AppConstants>(context, listen: true);
    var internet = Provider.of<CheckInternet>(context, listen: true);
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: getCustomPadding(),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Form(
              key: formGlobalKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  appBarHeader_005(
                      context: context,
                      appBarTitle: 'Setup Wallet & Card',
                      backArrow: true,
                      requiredHeader: false,
                      height: height,
                      width: width,
                      leadingIcon: true,
                      tralingIconButton: SSLCustom()),
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
                                Text(
                                  'Selected Package',
                                  style: heading1TextStyle(context, width,
                                      color: green),
                                ),
                                spacing_medium,
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0, right: 12),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '${widget.packageName}',
                                          style: heading4TextSmall(width,
                                              color: grey),
                                        ),
                                        Text(
                                          '${getCurrencySymbol(context, appConstants: appConstants)} ${widget.subScriptionAmount} / Month',
                                          style: heading4TextSmall(width,
                                              color: grey),
                                        ),
                                      ]),
                                )
                              ]))),
                  spacing_large,
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Card Info',
                          style:
                              heading1TextStyle(context, width, color: green),
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
                                    //         widget.subScriptionAmount.toString().isEmpty ||
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
                              style: heading4TextSmall(width, color: grey),
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
                            //             widget.subScriptionAmount.toString().isEmpty ||
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
                  spacing_small,
                   Container(
                        // color: white,
                        // elevation: 2,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: borderColor)
                        ), 
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20.0, horizontal: 12),
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
                            style: heading4TextSmall(width, color: grey),
                            controller: cardHolderNameController,
                            // obscureText: appConstants.passwordVissibleRegistration,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              isDense: true,
                              counterText: '',
                              border: circularOutLineBorder,
                              enabledBorder: circularOutLineBorder,
                              hintText: 'Card Holder Name',
                              hintStyle: heading4TextSmall(width, color: grey),
                            ),
                          ),
                          spacing_medium,
                          TextFormField(
                            inputFormatters: [
                              // CardFormatter(sample: "XXX-XXX-XXX", separator: "-")
                              cardNumberMaskFormatter
                            ],
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (String? number) {
                              if (number!.isEmpty) {
                                return 'Enter Card Number';
                              }
                              if (number.toString().length < 19) {
                                return 'Ooops, you seem to be missing some numbers!';
                              } else {
                                return null;
                              }
                            },
                            style: heading4TextSmall(width, color: grey),
                            controller: cardNumberController,
                            maxLength: 19,
                            // obscureText: appConstants.passwordVissibleRegistration,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                isDense: true,
                                counterText: '',
                                hintText: 'Card Number',
                                hintStyle:
                                    heading4TextSmall(width, color: grey),
                                border: circularOutLineBorder,
                                enabledBorder: circularOutLineBorder,
                                suffixIconColor: grey,
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 12),
                                suffixIcon: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
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
                                  ),
                                )),
                          ),
                          spacing_medium,
                          Row(
                            children: [
                              Expanded(
                                  child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 2.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextFormField(
                                      // enabled: false,
                                      // readOnly: true,
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      inputFormatters: [
                                        dateFormateMaskFormatter
                                      ],
                                      // obscureText: true,
                                      // obscuringCharacter: '*',
                                      onTap: () async {
                                        expiredDate = expireDateController.text;
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
                                          String firstDate = date.split('/')[0];
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
                                                    (DateTime.now().month + 3)
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
                                                  int.parse(
                                                      ((DateTime.now().year + 7)
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
                                        enabledBorder: circularOutLineBorder,
                                        hintText: 'MM/YY (exp)',
                                        hintStyle: heading4TextSmall(width,
                                            color: grey),
                                      ),
                                      style:
                                          heading4TextSmall(width, color: grey),
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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 2.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [],
                                    ),
                                    TextFormField(
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      maxLength: 5,
                                      validator: (String? code) {
                                        if (code!.isEmpty) {
                                          return 'Enter Security Code';
                                        } else if (code.length < 3) {
                                          return 'Enter Full Security Code';
                                        } else {
                                          return null;
                                        }
                                      },
                                      obscureText: _obscureText,
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 12),
                                        suffixIcon: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: InkWell(
                                              onTap: () {
                                                setState(() {
                                                  _obscureText = !_obscureText;
                                                });
                                              },
                                              child: Icon(_obscureText
                                                  ? Icons.visibility
                                                  : Icons.visibility_off)),
                                        ),
                                        counterText: '',
                                        isDense: true,
                                        border: circularOutLineBorder,
                                        enabledBorder: circularOutLineBorder,
                                        hintText: 'CVC / CVV',
                                        hintStyle: heading4TextSmall(width,
                                            color: grey),
                                      ),
                                      style:
                                          heading4TextSmall(width, color: grey),
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
                                      return 'Enter Full  Zipcode';
                                    } else {
                                      return null;
                                    }
                                  },
                                  // obscureText: true,
                                  decoration: InputDecoration(
                                    counterText: '',
                                    isDense: true,
                                    border: circularOutLineBorder,
                                    enabledBorder: circularOutLineBorder,
                                    hintText: 'Zip Code',
                                    hintStyle:
                                        heading4TextSmall(width, color: grey),
                                  ),
                                  style: heading4TextSmall(width, color: grey),
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
                  spacing_large,
                  ZakiPrimaryButton(
                      title: 'Subscribe Now',
                      width: width,
                      onPressed: (cardNumberController.text.length < 19 ||
                              cardHolderNameController.text.isEmpty ||
                              expireDateController.text.isEmpty ||
                              int.parse(
                                      expireDateController.text.split('/')[0]) >
                                  12 ||
                              zipCodeController.text.length < 5 ||
                              securityCodeController.text.length < 3)
                          ? null
                          : internet.status ==
                                  AppConstants.INTERNET_STATUS_NOT_CONNECTED
                              ? null
                              : () async {
                                  if (!formGlobalKey.currentState!.validate()) {
                                    return;
                                  }
                                  // bool? checkAuth = await authenticateTransactionUsingBioOrPinCode(appConstants: appConstants, context: context);
                                  //                 if(checkAuth==false){
                                  //                   return;
                                  //                 }
                                  bool subscriptionExpireStatus = appConstants.userModel.subscriptionExpired==true? true:false;
                                  CustomProgressDialog progressDialog =
                                      CustomProgressDialog(context, blur: 3);
                                  progressDialog
                                      .setLoadingWidget(CustomLoadingScreen());
                                  progressDialog.show();

                                  ApiServices service = ApiServices();
                                  // service.addTransaction(
                                  //     transactionMethod: AppConstants
                                  //         .Transaction_Method_Received,
                                  //     tagItName: AppConstants.GOAL,
                                  //     tagItId: "8",
                                  //     selectedKidName:
                                  //         appConstants.userModel.usaUserName,
                                  //     accountHolderName:
                                  //         appConstants.userModel.usaUserName,
                                  //     amount: widget.subScriptionAmount.toString().trim(),
                                  //     currentUserId:
                                  //         appConstants.userRegisteredId,
                                  //     receiverId: appConstants.userRegisteredId,
                                  //     requestType: AppConstants
                                  //         .TAG_IT_Transaction_TYPE_Fund_My_Wallet,
                                  //     senderId: appConstants.userRegisteredId,
                                  //     message: '',
                                  //     fromWallet: 'Card',
                                  //     toWallet: AppConstants.Spend_Wallet);
                                  //  service.addTransaction(
                                  //         transactionMethod: AppConstants.Transaction_Method_Payment,
                                  //         tagItId : AppConstants.GOAL,
                                  //         tagItId: "8",
                                  //         selectedKidName: appConstants.userModel.usaUserName,
                                  //         accountHolderName: appConstants.userModel.usaUserName,
                                  //         amount: widget.subScriptionAmount.toString().trim(),
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
                                        amount: widget.subScriptionAmount
                                            .toString()
                                            .trim(),
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
                                  // await service.addMoneyToMainWallet(
                                  //     amountSend: widget.subScriptionAmount.toString().trim(),
                                  //     senderId: appConstants.userRegisteredId);
Position userLocation =await UserLocation().determinePosition();
                                  await CreaditCardApi().addAmountFromCardToBank(
                                      amount: widget.subScriptionAmount
                                          .toString()
                                          .trim(),
                                      name: appConstants.userModel.usaFirstName,
                                      userToken:
                                          AppConstants.ZAKI_PAY_ACCOUNT_NUMBER,
                                      tags: createMemo(
                                          fromWallet: AppConstants.Spend_Wallet,
                                          toWallet: AppConstants.Spend_Wallet,
                                          transactionMethod: AppConstants
                                              .Transaction_Method_Received,
                                          tagItName: AppConstants.GOAL,
                                          tagItId: "8",
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
                                  //Checking Subscription Status and Updating accordigly
                                  if(appConstants.userModel.subscriptionExpired==true){
                                    await service.userSubscriptionStatusRestored(
                                      userId: appConstants.userRegisteredId,
                                      subscriptionStauts: false,
                                      USER_Subscription_Method: widget.method?? AppConstants.USER_Subscription_Method_Card
                                      );
                                  } else
                                  await service.addUserTokenBankApi(
                                      appConstants.userRegisteredId,
                                      appConstants.userModel.userTokenId
                                          .toString(),
                                      value: 1,
                                      USER_Subscription_Method: widget.method?? AppConstants.USER_Subscription_Method_Card
                                      );
                                  Future.delayed(
                                      Duration(
                                        seconds: 1,
                                      ), () async {
                                    await service.getUserData(
                                        context: context,
                                        userId: appConstants.userRegisteredId);
                                  });
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
                                  //               amount: widget.subScriptionAmount.toString()
                                  //                   .trim(),
                                  //               // name: appConstants.userModel.usaUserName,
                                  //               walletImageUrl:
                                  //                   imageBaseAddress +
                                  //                       'spending_act.png',
                                  //               fromCreaditCardScreen: true,
                                  //             )));
                                  // Navigator.pop(context);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              CustomConfermationScreen(
                                                fromSubscription: true,
                                                fromSubScriptionRenew: subscriptionExpireStatus==true?true:null,
                                                title: 'Subscription Activated',
                                                subTitle:
                                                    'This page will redirect in 5 seconds',
                                                subscriptionUI:
                                                subscriptionExpireStatus==true?
                                                ZakiPrimaryButton(
                                                  title: 'Home',
                                                  width: width,
                                                  onPressed: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                HomeScreen()));
                                                  },
                                                ):
                                                    ZakiPrimaryButton(
                                                  title: 'Setup Your Wallet',
                                                  width: width,
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                    Navigator.pop(context);
                                                    Navigator.pop(context);
                                                    Navigator.pop(context);
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                AddMemberWorkFlow()));
                                                  },
                                                ),
                                              )));
                                }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
