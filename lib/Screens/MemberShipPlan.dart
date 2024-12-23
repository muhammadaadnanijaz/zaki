// import 'dart:io';

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';
import 'package:zaki/Constants/AppConstants.dart';
import 'package:zaki/Constants/HelperFunctions.dart';
import 'package:zaki/Constants/Spacing.dart';
import 'package:zaki/Constants/Styles.dart';
import 'package:zaki/Screens/HomeScreen.dart';
import 'package:zaki/Screens/SubscriptionPayScreen.dart';
import 'package:zaki/Services/api.dart';
import 'package:zaki/Widgets/TermsAndConditionsSmall.dart';
import 'package:zaki/Widgets/TextHeader.dart';
import 'package:zaki/Widgets/ZakiPrimaryButton.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';

class MemberShipPlan extends StatefulWidget {
  const MemberShipPlan({Key? key}) : super(key: key);

  @override
  State<MemberShipPlan> createState() => _MemberShipPlanState();
}

class _MemberShipPlanState extends State<MemberShipPlan> {
  Set<String> _productIds = <String>{'subscription_01'};
  bool showFirstScreen = true;
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  List<ProductDetails> _products = [];
  @override
  void initState() {
    super.initState();
    initStateCheckInfo();
  }
  initStateCheckInfo() async{
    final bool available = await _inAppPurchase.isAvailable();
    if (available) {
      logMethod(title: "Connection to the store is available", message: available.toString());
      ProductDetailsResponse productDetailsResponse = await _inAppPurchase.queryProductDetails(_productIds);
      setState(() {
        _products = productDetailsResponse.productDetails;
        logMethod(title: "Subscriptions are", message: _products.first.price.toString());

      });
    }else {
      logMethod(title: "Connection to the store is available", message: available.toString());

    }
  }
  @override
  Widget build(BuildContext context) {
    var appConstants = Provider.of<AppConstants>(context, listen: true);
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: getCustomPadding(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // appBarHeader_005(
              //         context: context,
              //         appBarTitle: 'Premium Feature',
              //         backArrow: false,
              //         height: height,
              //         width: width,
              //         leadingIcon: true
              //         ),
              Center(
                child: Text(
                  appConstants.userModel.subscriptionExpired == true
                      ? 'Renew Subscription'
                      : 'Access Premium Features',
                  style: appBarTextStyle(context, width),
                ),
              ),
              appConstants.userModel.subscriptionExpired == true
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        spacing_medium,
                        Text(
                          'Your Subscription Expired, Renew Your Subscription by selecting a package',
                          style: heading4TextSmall(
                            width,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        spacing_medium
                      ],
                    )
                  : spacing_large,
              Text(
                'Benefits',
                style: heading1TextStyle(context, width, color: black),
              ),
              spacing_medium,
              Container(
                      // color: white,
                      // elevation: 2,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: borderColor)
                      ), 
                child: ListTile(
                  contentPadding: EdgeInsets.all(8),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BenifitCustomText(
                          text: 'Setup Family Members for FREE!'),
                      BenifitCustomText(
                          text:
                              'Send or Request Money from Friends & Family'),
                      BenifitCustomText(
                          text: 'Setup spend limits for your Family.'),
                      BenifitCustomText(
                          text:
                              'Setup automated allowance & so much more !!'),
                    ],
                  ),
                  // subtitle: Text(
                  //   '$subtitle',
                  //   style: heading4TextSmall(width, color: black),
                  //   ),
                ),
              ),
              showFirstScreen
                  ? 
                  Expanded(
                    child: ListView.builder(
                      itemCount: _products.length,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        // PurchaseParam purchaseParam = PurchaseParam(productDetails: _products[index]);
                        return Column(
                        children: [
                          SizedBox(
                            height: height * 0.4,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Only ',
                                style: heading3TextStyle(width),
                              ),
                              Text(
                                '${getCurrencySymbol(context, appConstants: appConstants)}  ',
                                style: heading3TextStyle(width),
                              ),
                              Text(
                                '${_products[index].rawPrice} / Month',
                                style: heading3TextStyle(width),
                              ),
                            ],
                          ),
                          spacing_small,
                          ZakiPrimaryButton(
                            title: 'Subscribe Now',
                            width: width,
                            onPressed: () async{
                              // late PurchaseParam purchaseParam;

                              // if (Platform.isAndroid) {
                              //   purchaseParam = await GooglePlayPurchaseParam(
                              //     productDetails: _products[index],
                              //     changeSubscriptionParam: null
                              //   );
                              // }
                              // final response = await InAppPurchase.instance.buyNonConsumable(purchaseParam: purchaseParam);
                              // logMethod(title: "Response after buying subscription", message: response.toString());
                              toUpMethodsBottomSheet(
                                  context: context,
                                  height: height,
                                  width: width,
                                  amount: '4.99',
                                  packageName: 'Standard');
                            },
                          ),
                        ],
                      );
                      },
                    ),
                  )
                  
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        spacing_medium,
                        TextHeader1(
                          title: 'Select a Package:',
                        ),
                        appConstants.userModel.usaUserType ==
                                AppConstants.USER_TYPE_PARENT
                            ? Column(
                                children: [
                                  spacing_medium,
                                  PackageCard(
                                    width: width,
                                    backGroundColor: green,
                                    title: 'Support our BETA*',
                                    amount:
                                        '14.99 ${getCurrencySymbol(context, appConstants: appConstants)} ',
                                    recommendedConatiner: Container(
                                      decoration: BoxDecoration(
                                          color: orange,
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(20),
                                              topRight: Radius.circular(8))),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12.0, vertical: 6),
                                        child: Text(
                                          'Recommended',
                                          style: heading4TextSmall(
                                              width * 0.85,
                                              color: white),
                                        ),
                                      ),
                                    ),
                                    onTap: () {
                                      toUpMethodsBottomSheet(
                                          context: context,
                                          height: height,
                                          width: width,
                                          amount: '14.99',
                                          packageName: 'Support our BETA*');
                                      // Navigator.push(context, MaterialPageRoute(builder: (context)=>SubscriptionPayScreen(subScriptionAmount: '14.99',)));
                                    },
                                  ),
                                ],
                              )
                            : SizedBox.shrink(),
                        spacing_medium,
                        PackageCard(
                          width: width,
                          backGroundColor: white,
                          title: 'Standard',
                          amount:
                              '4.99 ${getCurrencySymbol(context, appConstants: appConstants)} ',
                          onTap: () {
                            toUpMethodsBottomSheet(
                                context: context,
                                height: height,
                                width: width,
                                amount: '4.99',
                                packageName: 'Standard');
                            // Navigator.push(context, MaterialPageRoute(builder: (context)=>SubscriptionPayScreen(subScriptionAmount: '4.99',)));
                          },
                        ),
                        spacing_medium,
                        InkWell(
                          onTap: () {
                            toUpMethodsBottomSheet(
                                context: context,
                                height: height,
                                width: width,
                                amount: '1.99',
                                packageName: 'Discounted*');
                          },
                          child: Card(
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(width * 0.025),
                              // side: BorderSide(color: grey)
                              //set border radius more than 50% of height and width to make circle
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12.0, vertical: 12),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Discounted*',
                                    style: heading4TextSmall(width * 0.8),
                                  ),
                                  Text(
                                    '1.99 ${getCurrencySymbol(context, appConstants: appConstants)} / Month',
                                    style: heading4TextSmall(width * 0.8),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        spacing_medium,
                        Text(
                          '*First 3 months, after which standard package will apply. automated renewal, cancellation via website formLorem ipsum dolor sit amet consectetur. Egestas et magnis pretium quisque elit pellentesque. Nisl pretium etiam viverra in quis id lorem. Turpis volutpat id vestibulum a a est eget sit augue. Nulla cras mauris consectetur lorem massa massa. Diam ornare in mattis fringilla.',
                          style: heading5TextSmall(width, bold: false),
                          textAlign: TextAlign.justify,
                        ),
                        spacing_large,
                        Center(
                            child: TermsAndConditionsSmallText(width: width)),
                      ],
                    ),
              // Terms & Conditions Applied*
            ],
          ),
        ),
      ),
    );
  }
}

class BenifitCustomText extends StatelessWidget {
  const BenifitCustomText({Key? key, this.text}) : super(key: key);

  final String? text;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        spacing_small,
        Text(
          '•  $text',
          style: heading4TextSmall(
            width,
          ),
        ),
        spacing_small
      ],
    );
  }
}

class PackageCard extends StatelessWidget {
  const PackageCard(
      {Key? key,
      required this.width,
      this.backGroundColor,
      this.amount,
      this.title,
      this.onTap,
      this.recommendedConatiner})
      : super(key: key);

  final double width;
  final Color? backGroundColor;
  final String? title;
  final String? amount;
  final Widget? recommendedConatiner;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(width * 0.025),
          // side: BorderSide(color: grey)
          //set border radius more than 50% of height and width to make circle
        ),
        child: Container(
          decoration: BoxDecoration(
              color: backGroundColor,
              borderRadius: BorderRadius.circular(width * 0.025),
              border: Border.all(color: grey)),
          child: Column(
            children: [
              if (recommendedConatiner != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [recommendedConatiner!],
                ),
              if (recommendedConatiner == null) spacing_medium,
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '$title',
                      style: heading1TextStyle(context, width,
                          color: backGroundColor != green ? grey : white),
                    ),
                    if (recommendedConatiner == null)
                      SizedBox(
                        width: width * 0.25,
                      ),
                    // Text(
                    //   '$amount',
                    //   style: appBarTextStyle(context, width*0.85, color: backGroundColor!=green? grey : white),
                    // ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      '$amount / Monthly',
                      style: heading4TextSmall(width,
                          color: backGroundColor != green ? grey : white),
                    ),
                  ],
                ),
              ),
              spacing_medium,
            ],
          ),
        ),
      ),
    );
  }
}

void toUpMethodsBottomSheet(
    {required BuildContext context,
    double? width,
    double? height,
    String? amount,
    required String packageName}) {
  // bool isCardChecked = false;
  showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(width! * 0.09),
          topRight: Radius.circular(width * 0.09),
        ),
      ),
      builder: (BuildContext bc) {
        var appConstants = Provider.of<AppConstants>(bc, listen: false);
        return StatefulBuilder(
          builder: (BuildContext context, setState) => Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  spacing_medium,
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0, bottom: 12.0),
                    child: InkWell(
                      onTap: () {},
                      child: Container(
                        width: width * 0.2,
                        height: 5,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(width * 0.08),
                            color: grey),
                      ),
                    ),
                  ),
                  spacing_medium,
                  Center(
                    child: Text(
                      'Select Payment Method:',
                      style: heading1TextStyle(context, width),
                    ),
                  ),
                  spacing_medium,
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: width * 0.08,
                      vertical: width * 0.01,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if(Platform.isIOS)
                        Column(
                          children: [
                            TopUpMethodTile(
                                onTap: () async{
                                  await ApiServices().getCardInfoFromFundMyWallet(
                                  userId: appConstants.userRegisteredId,
                                  context: context);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          SubscriptionPayScreen(
                                            packageName: packageName,
                                            subScriptionAmount: '$amount',
                                            method: AppConstants.USER_Subscription_Method_Apple,
                                          )));
                                },
                                icon: FontAwesomeIcons.ccApplePay,
                                width: width,
                                title: 'Apple Send'),
                            spacing_medium,
                          ],
                        ),
                        // if(Platform.isAndroid)
                        Column(
                          children: [
                            TopUpMethodTile(
                                onTap: () async{
                                  await ApiServices().getCardInfoFromFundMyWallet(
                                  userId: appConstants.userRegisteredId,
                                  context: context);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          SubscriptionPayScreen(
                                            packageName: packageName,
                                            subScriptionAmount: '$amount',
                                            method: AppConstants.USER_Subscription_Method_Google,
                                          )));
                                },
                                width: width,
                                icon: FontAwesomeIcons.googlePay,
                                title: 'Google Send'
                              ),
                            spacing_medium,
                          ],
                        ),
                        // TopUpMethodTile(
                        //     onTap: () {},
                        //     width: width,
                        //     icon: FontAwesomeIcons.paypal,
                        //     title: 'PayPal (Coming soon)'),
                        // spacing_medium,
                        TopUpMethodTile(
                            onTap: () async {
                              appConstants.updateCurrentUserIdForBottomSheet(
                                  appConstants.userRegisteredId);
// bool screenNotOpen = await checkUserSubscriptionValue(appConstants, context);
//                                   if(screenNotOpen==false){
                              // bool? isExist =
                              await ApiServices().getCardInfoFromFundMyWallet(
                                  userId: appConstants.userRegisteredId,
                                  context: context);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          SubscriptionPayScreen(
                                            packageName: packageName,
                                            subScriptionAmount: '$amount',
                                            method: AppConstants.USER_Subscription_Method_Card,
                                          )));
                              //   Navigator.push(
                              // context,
                              // MaterialPageRoute(builder: (context)=> FundMyWallet()));

                              // if (isExist!) {
                              //   Navigator.push(
                              //       context,
                              //       MaterialPageRoute(
                              //           builder: (context) =>
                              //               const ManageLinkedCards()));
                              //   return;
                              // }
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) => FundMyWallet()));
                              // }
                            },
                            width: width,
                            icon: FontAwesomeIcons.creditCard,
                            title: 'Debit/Credit Card'),
                        spacing_medium,
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      });
}
