import 'dart:io';
import 'package:zaki/Constants/Whitelable.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:ndialog/ndialog.dart';
import 'package:provider/provider.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart';
import 'package:uuid/uuid.dart';
import 'package:zaki/Constants/AuthMethods.dart';
import 'package:zaki/Constants/CheckInternetConnections.dart';
import 'package:zaki/Constants/LocationGetting.dart';
// import 'package:zaki/Constants/NotificationTitle.dart';
import 'package:zaki/Constants/Spacing.dart';
import 'package:zaki/Models/BalanceModel.dart';
import 'package:zaki/Services/CreaditCardApis.dart';
import 'package:zaki/Services/api.dart';
import 'package:zaki/Widgets/AppBars/AppBar.dart';
import 'package:zaki/Widgets/TextHeader.dart';
import '../Constants/AppConstants.dart';
import '../Constants/HelperFunctions.dart';
import '../Constants/Styles.dart';
import '../Widgets/CustomConfermationScreen.dart';
import '../Widgets/CustomLoadingScreen.dart';
import '../Widgets/ZakiPrimaryButton.dart';

class PayReview extends StatefulWidget {
  final bool? fromPayReviewHome;
  final List? userInvitedList;
  const PayReview({Key? key, this.fromPayReviewHome, this.userInvitedList})
      : super(key: key);

  @override
  State<PayReview> createState() => _PayReviewState();
}

class _PayReviewState extends State<PayReview> {
  final amountController = TextEditingController();
  String message = '';
  String name = '';
  bool loading = false;

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 200), () {
      var appConstants = Provider.of<AppConstants>(context, listen: false);
      amountController.text = appConstants.payRequestModel.amount.toString();
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    amountController.dispose();
    // passwordCotroller.dispose();
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
        child: Padding(
          padding: getCustomPadding(),
          child: SingleChildScrollView(
            child: Column(
              children: [
                appBarHeader_005(
                    context: context,
                    appBarTitle: 'Send or Request',
                    height: height,
                    width: width,
                    backArrow: true),
                loading
                    ? Center(
                        child: LoadingBouncingGrid.circle(
                          size: width * 0.2,
                          backgroundColor: green,
                        ),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'How Much?',
                            style: heading1TextStyle(context, width),
                          ),
                          TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (String? email) {
                              if (email!.isEmpty) {
                                return 'Enter an Amount';
                              } else {
                                return null;
                              }
                            },
                            // style: TextStyle(color: primaryColor),
                            style: heading2TextStyle(context, width),
                            controller: amountController,
                            obscureText: false,
                            enabled: false,
                            keyboardType: TextInputType.number,
                            maxLines: 1,
                            decoration: InputDecoration(
                              hintText: '150.00',
                              prefixIcon: Padding(
                                padding: const EdgeInsets.all(8),
                                child: TextValue1(
                                  title:
                                      "${getCurrencySymbol(context, appConstants: appConstants)}",
                                ),
                              ),
                              prefixIconConstraints: const BoxConstraints(
                                  minWidth: 0, minHeight: 0),
                              hintStyle: heading2TextStyle(context, width),
                              // labelText: 'Enter Email',
                              // labelStyle: textStyleHeading2WithTheme(context,width*0.8, whiteColor: 0),
                            ),
                          ),
                          spacing_large,
                          Text(
                            'To',
                            style: heading1TextStyle(context, width),
                          ),
                          spacing_medium,
                          InkWell(
                            child: Column(
                              children: [
                                Container(
                                  height: height * 0.08,
                                  width: height * 0.08,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: transparent,
                                      border:
                                          Border.all(width: 2, color: green)),
                                  child: Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: CircleAvatar(
                                        backgroundColor: grey,
                                        radius: width * 0.09,
                                        child: appConstants.payRequestModel
                                                .selectedKidImageUrl!
                                                .contains('assets/images/')
                                            ? ClipOval(
                                                child: Image.asset(appConstants
                                                    .payRequestModel
                                                    .selectedKidImageUrl!),
                                              )
                                            : ClipOval(
                                                child: Image.network(
                                                    appConstants.payRequestModel
                                                        .selectedKidImageUrl!),
                                              ),
                                      )),
                                ),
                                spacing_small,
                                SizedBox(
                                  width: height * 0.065,
                                  child: Center(
                                    child: Text(
                                      appConstants
                                          .payRequestModel.selectedKidName
                                          .toString(),
                                      overflow: TextOverflow.clip,
                                      maxLines: 1,
                                      style: heading4TextSmall(width),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          spacing_large,
                          Text(
                            'Make it Fun',
                            style: heading1TextStyle(context, width),
                          ),
                          spacing_medium,
                          Container(
                            width: double.infinity,
                            height: height * 0.24,
                            decoration: BoxDecoration(
                              // shape: BoxShape.circle,
                              border: Border.all(color: grey.withValues(alpha:0.5)),
                              borderRadius: BorderRadius.circular(width * 0.03),
                            ),
                            child: appConstants.payRequestModel.imageUrl
                                    .toString()
                                    .contains('assets/images/')
                                ? Image.asset(
                                    appConstants.payRequestModel.imageUrl
                                        .toString(),
                                    // height: height*0.2,
                                    // width: width,
                                    fit: BoxFit.contain,
                                  )
                                : appConstants.payRequestModel.imageUrl
                                        .toString()
                                        .contains('com.zakipay.teencard')
                                    ? Image.file(
                                        File(appConstants
                                            .payRequestModel.imageUrl
                                            .toString()),
                                        fit: BoxFit.contain,
                                        // height: 150,
                                        // width: double.infinity,
                                        // fit: BoxFit.fill,
                                      )
                                    : Image.network(
                                        appConstants.payRequestModel.imageUrl
                                            .toString(),
                                        // height: height*0.2,
                                        // width: width,
                                        fit: BoxFit.contain,
                                      ),
                          ),
                          spacing_large,
                          Text(
                            'Message',
                            style: heading1TextStyle(context, width),
                          ),
                          spacing_medium,
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              appConstants.payRequestModel.message!,
                              style: heading2TextStyle(context, width),
                            ),
                          ),
                          spacing_large,
                          Text(
                            'Tag-it',
                            style: heading1TextStyle(context, width),
                          ),
                          spacing_medium,
                          Container(
                            height: height * 0.08,
                            width: height * 0.08,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: transparent,
                                border: Border.all(width: 2, color: green)),
                            child: Icon(AppConstants
                                .tagItList[int.parse(
                                    appConstants.payRequestModel.tagItId!)]
                                .icon),
                          ),
                          spacing_large,
                          appConstants.payRequestModel.isFromReview == true
                              ? Row(
                                  children: [
                                    Expanded(
                                      child: ZakiPrimaryButton(
                                        onPressed: internet.status ==
                                                AppConstants
                                                    .INTERNET_STATUS_NOT_CONNECTED
                                            ? null
                                            : () async {
                                                ApiServices services =
                                                    ApiServices();
                                                await services.deleteRequest(
                                                    documentId: appConstants
                                                        .payRequestModel.id,
                                                    userId: appConstants
                                                        .userRegisteredId,
                                                    status: 'Cancel');
                                                // Sender User Side request delete
                                                await services.deleteRequest(
                                                    documentId: appConstants
                                                        .payRequestModel
                                                        .requestDoucumentId,
                                                    userId: appConstants
                                                        .payRequestModel
                                                        .toUserId,
                                                    status: 'Cancel');

                                                showNotification(
                                                    error: 1,
                                                    icon: Icons.delete_forever,
                                                    message: NotificationText
                                                        .DELETED);

                                                await sendUserNotification(
                                                    receiverId: appConstants
                                                        .payRequestModel
                                                        .fromUserId,
                                                    titleNotification:
                                                        NotificationText
                                                            .PAY_REQUEST_CANCEL_NOTIFICATION_TITLE,
                                                    bodyNotification:
                                                        NotificationText
                                                            .PAY_REQUEST_CANCEL_NOTIFICATION_SUB_TITLE);
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            CustomConfermationScreen(
                                                              // title: 'Mission Accomplished!',
                                                              subTitle:
                                                                  "You declined a Payment Request from ${appConstants.payRequestModel.selectedKidName} for ${getCurrencySymbol(context, appConstants: appConstants)} ${amountController.text}",
                                                              imageUrl: appConstants
                                                                  .payRequestModel
                                                                  .selectedKidImageUrl,
                                                            )));
                                              },
                                        title: 'Decline',
                                        backgroundTransparent: 1,
                                        selected: 0,
                                        width: width,
                                        borderColor: green,
                                        textColor: green,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    ///////////////////
                                    Expanded(
                                      child: ZakiPrimaryButton(
                                        onPressed: internet.status ==
                                                AppConstants
                                                    .INTERNET_STATUS_NOT_CONNECTED
                                            ? null
                                            : () async {
                                              bool? checkAuth = await authenticateTransactionUsingBioOrPinCode(appConstants: appConstants, context: context);
                                                  if(checkAuth==false){
                                                    return;
                                                  }
                                                var uuid = Uuid();
                                                String transactionId =
                                                    uuid.v1();

                                                ApiServices services =
                                                    ApiServices();
                                                logMethod(
                                                    title:
                                                        'Sender User and receiver userId',
                                                    message:
                                                        "Receiver User id: ${appConstants.payRequestModel.toUserId} and sender user id ${appConstants.userRegisteredId}");
                                                // return ;
                                                // setState(() {
                                                //   loading = true;
                                                // });

                                                CustomProgressDialog
                                                    progressDialog =
                                                    CustomProgressDialog(
                                                        context,
                                                        blur: 3);
                                                progressDialog.setLoadingWidget(
                                                    CustomLoadingScreen());
                                                progressDialog.show();

                                                CreaditCardApi creaditCardApi =
                                                    CreaditCardApi();
                                                // if(appConstants.appMode!= false){
                                                BalanceModel? balanceModel =
                                                    await creaditCardApi
                                                        .checkBalance(
                                                            userToken:
                                                                appConstants
                                                                    .userModel
                                                                    .userTokenId);
                                                if (balanceModel!
                                                        .gpa.availableBalance <
                                                    int.parse(amountController
                                                        .text
                                                        .toString())) {
                                                  // setState(() {
                                                  //     error =
                                                  //         'Not enough money :(  add funds to your wallet first';
                                                  //   });
                                                  progressDialog.dismiss();
                                                  showNotification(
                                                      error: 1,
                                                      icon: Icons.error,
                                                      message: NotificationText
                                                          .NOT_ENOUGH_BALANCE);
                                                  return;
                                                } else {
                                                  Map<String, dynamic>? data =
                                                      await ApiServices()
                                                          .getKidSpendingLimit(
                                                              appConstants
                                                                  .userModel
                                                                  .userFamilyId
                                                                  .toString(),
                                                              appConstants
                                                                  .userRegisteredId);
                                                  // if () {
                                                  //   return;
                                                  // }
                                                  if (data != null &&
                                                      int.parse(amountController
                                                              .text
                                                              .trim()) >
                                                          data[AppConstants
                                                              .SpendL_Transaction_Amount_Max]) {
                                                    showNotification(
                                                        error: 1,
                                                        icon: Icons.error,
                                                        message:
                                                            NotificationText
                                                                .LIMIT_REACHED);

                                                    // setState(() {
                                                    //   error =
                                                    //       'Not enough Lmit';
                                                    // });
                                                    progressDialog.dismiss();
                                                    return;
                                                  }
                                                  Position userLocation =await UserLocation().determinePosition();
                                                  await creaditCardApi
                                                      .moveMoney(
                                                          amount: amountController
                                                              .text
                                                              .trim(),
                                                          name: appConstants
                                                              .userModel
                                                              .usaFirstName,
                                                          senderUserToken:
                                                              appConstants
                                                                  .userModel
                                                                  .userTokenId,
                                                          //This is not assigned
                                                          receiverUserToken: appConstants
                                                              .payRequestModel
                                                              .selectedKidBankToken,
                                                          tags: createMemo(
                                                              fromWallet: appConstants
                                                                  .selectFromWalletRealName,
                                                              toWallet: AppConstants
                                                                  .All_Goals_Wallet,
                                                              transactionMethod:
                                                                  AppConstants
                                                                      .Transaction_Method_Received,
                                                              tagItId: appConstants
                                                                  .payRequestModel
                                                                  .tagItId,
                                                              tagItName: appConstants
                                                                  .payRequestModel
                                                                  .tagItName,
                                                              goalId: '',
                                                              transactionType:
                                                                  AppConstants
                                                                      .TAG_IT_Transaction_TYPE_SEND_OR_REQUEST,
                                                              transactionId:
                                                                  transactionId,
                                                              latLng: '${userLocation.latitude},${userLocation.longitude}'
                                                                  ));
                                                  showNotification(
                                                      error: 0,
                                                      icon: Icons.balance,
                                                      message: NotificationText
                                                          .NOT_ENOUGH_BALANCE);
                                                }
                                                ///////Checkbalance first in to Spend Wallet
                                                bool? hasBalance = await services
                                                    .checkWalletHasAmount(
                                                        amount: double.parse(
                                                            amountController
                                                                .text
                                                                .trim()),
                                                        userId: appConstants
                                                            .userRegisteredId,
                                                        fromWalletName:
                                                            AppConstants
                                                                .Spend_Wallet);
                                                if (hasBalance == true) {
                                                  progressDialog.dismiss();
                                                  // setState(() {
                                                  // error =
                                                  //     'Not enough money :(  add funds to your wallet first';
                                                  // });
                                                  setState(() {
                                                    loading = false;
                                                  });
                                                  showNotification(
                                                      error: 1,
                                                      icon: Icons.error,
                                                      message: NotificationText
                                                          .NOT_ENOUGH_BALANCE);
                                                  return;
                                                }

                                                List<dynamic> likes = [];

                                                if (appConstants
                                                    .payRequestModel.imageUrl!
                                                    .contains(
                                                        'com.zakipay.teencard')) {
                                                  // ZakiPay/Country code-bank code/sendreceive/User id/images/
                                                              String fullPath = '${appConstants.userModel.usaCountry}/sendreceive/${appConstants.userRegisteredId}/images';
                                                  String? pathImage =
                                                      await services.uploadImage(
                                                        fullPath: fullPath,
                                                          path: appConstants
                                                              .payRequestModel
                                                              .imageUrl, userId: appConstants.userRegisteredId);
                                                  showNotification(
                                                      error: 0,
                                                      icon: Icons.check,
                                                      message: pathImage);

                                                  // String? transactionId =
                                                  await services.payPlusMoney(
                                                      likesList: likes,
                                                      selectedKidImageUrl:
                                                          appConstants
                                                              .payRequestModel
                                                              .selectedKidImageUrl,
                                                      selectedKidName: appConstants
                                                          .payRequestModel
                                                          .selectedKidName,
                                                      senderImageUrl: appConstants
                                                          .payRequestModel
                                                          .senderImageUrl,
                                                      requestType: 'Send',
                                                      privacy: appConstants
                                                          .selectedPrivacyType,
                                                      accountHolderName:
                                                          '${appConstants.userModel.usaFirstName} ${appConstants.userModel.usaLastName}',
                                                      message: appConstants
                                                          .payRequestModel
                                                          .message,
                                                      accountType: 'main',
                                                      tagItId: appConstants
                                                          .payRequestModel
                                                          .tagItId,
                                                      tagItName: appConstants
                                                          .payRequestModel
                                                          .tagItName,
                                                      amount:
                                                          amountController.text,
                                                      imageUrl: pathImage,
                                                      toUserId: appConstants
                                                          .payRequestModel
                                                          .toUserId,
                                                      currentUserId: appConstants
                                                          .userRegisteredId,
                                                      transactionId: transactionId);
                                                  await services.addSocialFeed(
                                                      likesList: likes,
                                                      usersList: widget
                                                          .userInvitedList!,
                                                      selectedKidImageUrl: appConstants
                                                          .payRequestModel
                                                          .selectedKidImageUrl,
                                                      selectedKidName: appConstants
                                                          .payRequestModel
                                                          .selectedKidName,
                                                      senderImageUrl: appConstants
                                                          .payRequestModel
                                                          .senderImageUrl,
                                                      requestType: AppConstants
                                                          .TAG_IT_Transaction_TYPE_SEND_OR_REQUEST,
                                                      privacy: appConstants
                                                          .selectedPrivacyType,
                                                      accountHolderName:
                                                          '${appConstants.userModel.usaFirstName} ${appConstants.userModel.usaLastName}',
                                                      message: appConstants
                                                          .payRequestModel
                                                          .message,
                                                      accountType: '',
                                                      tagItId: appConstants
                                                          .payRequestModel
                                                          .tagItId,
                                                      tagItName: appConstants
                                                          .payRequestModel
                                                          .tagItName,
                                                      amount:
                                                          amountController.text,
                                                      imageUrl: appConstants
                                                          .payRequestModel
                                                          .imageUrl,
                                                      receiverId: appConstants.payRequestModel.toUserId,
                                                      senderId: appConstants.userRegisteredId,
                                                      transactionId: transactionId);
                                                } else {
                                                  // String? transactionId =
                                                  await services.payPlusMoney(
                                                      likesList: likes,
                                                      selectedKidImageUrl:
                                                          appConstants
                                                              .payRequestModel
                                                              .selectedKidImageUrl,
                                                      selectedKidName: appConstants
                                                          .payRequestModel
                                                          .selectedKidName,
                                                      senderImageUrl: appConstants
                                                          .payRequestModel
                                                          .senderImageUrl,
                                                      requestType: 'Send',
                                                      privacy: appConstants
                                                          .selectedPrivacyType,
                                                      accountHolderName:
                                                          '${appConstants.userModel.usaFirstName} ${appConstants.userModel.usaLastName}',
                                                      message: appConstants
                                                          .payRequestModel
                                                          .message,
                                                      accountType: 'main',
                                                      tagItId: appConstants
                                                          .payRequestModel
                                                          .tagItId,
                                                      tagItName: appConstants
                                                          .payRequestModel
                                                          .tagItName,
                                                      amount:
                                                          amountController.text,
                                                      imageUrl: appConstants
                                                          .payRequestModel
                                                          .imageUrl,
                                                      toUserId: appConstants
                                                          .payRequestModel
                                                          .toUserId,
                                                      currentUserId: appConstants.userRegisteredId,
                                                      transactionId: transactionId);
                                                  await services.addSocialFeed(
                                                      likesList: likes,
                                                      usersList: widget
                                                          .userInvitedList!,
                                                      selectedKidImageUrl: appConstants
                                                          .payRequestModel
                                                          .selectedKidImageUrl,
                                                      selectedKidName: appConstants
                                                          .payRequestModel
                                                          .selectedKidName,
                                                      senderImageUrl: appConstants
                                                          .payRequestModel
                                                          .senderImageUrl,
                                                      requestType: AppConstants
                                                          .TAG_IT_Transaction_TYPE_SEND_OR_REQUEST,
                                                      privacy: appConstants
                                                          .selectedPrivacyType,
                                                      accountHolderName:
                                                          '${appConstants.userModel.usaFirstName} ${appConstants.userModel.usaLastName}',
                                                      message: appConstants
                                                          .payRequestModel
                                                          .message,
                                                      accountType: '',
                                                      tagItId: appConstants
                                                          .payRequestModel
                                                          .tagItId,
                                                      tagItName: appConstants
                                                          .payRequestModel
                                                          .tagItName,
                                                      amount:
                                                          amountController.text,
                                                      imageUrl: appConstants
                                                          .payRequestModel
                                                          .imageUrl,
                                                      receiverId: appConstants.payRequestModel.toUserId,
                                                      senderId: appConstants.userRegisteredId,
                                                      transactionId: transactionId);
                                                }
                                                //Current User Side request Deleted

                                                await services.deleteRequest(
                                                    documentId: appConstants
                                                        .payRequestModel.id,
                                                    userId: appConstants
                                                        .userRegisteredId,
                                                    status: 'Paid');
                                                // Sender User Side request delete
                                                await services.deleteRequest(
                                                    documentId: appConstants
                                                        .payRequestModel
                                                        .requestDoucumentId,
                                                    userId: appConstants
                                                        .payRequestModel
                                                        .toUserId,
                                                    status: 'Paid');
                                                // requestDoucumentId
                                                setState(() {
                                                  loading = false;
                                                });
                                                await services
                                                    .getUserTokenAndSendNotification(
                                                        userId: appConstants
                                                            .payRequestModel
                                                            .toUserId,
                                                        title:
                                                            '${appConstants.userModel.usaUserName} ${NotificationText.REQUEST_NOTIFICATION_TITLE}',
                                                        subTitle:
                                                            '${NotificationText.REQUEST_NOTIFICATION_SUB_TITLE} ${getCurrencySymbol(context, appConstants: appConstants)} ${amountController.text}',
                                                        checkParent: true,
                                                        parentTitle: '${appConstants.userModel.usaUserName} sent ${getCurrencySymbol(context, appConstants: appConstants)} ${amountController.text}',
                                            parentSubtitle: 'See Details in ZakiPay'
                                                            );
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            CustomConfermationScreen(
                                                              title:
                                                                  'Mission Accomplished!',
                                                              subTitle:
                                                                  "${appConstants.payRequestModel.selectedKidName} received ${getCurrencySymbol(context, appConstants: appConstants)} ${amountController.text}",
                                                              imageUrl: appConstants
                                                                  .payRequestModel
                                                                  .selectedKidImageUrl,
                                                            )));
                                              },
                                        title: 'Send',
                                        width: width,
                                      ),
                                    ),
                                  ],
                                )
                              : Center(
                                  child: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: internet.status ==
                                                    AppConstants
                                                        .INTERNET_STATUS_NOT_CONNECTED
                                                ? grey
                                                : green),
                                        borderRadius:
                                            BorderRadius.circular(25)),
                                    child: ConfirmationSlider(
                                      height: height * 0.065,
                                      foregroundColor: green,
                                      shadow: BoxShadow(color: black),
                                      onConfirmation: () async {
                                        if (internet.status ==
                                            AppConstants
                                                .INTERNET_STATUS_NOT_CONNECTED) {
                                          showNotification(
                                              error: 1,
                                              icon: Icons.wifi_off_rounded,
                                              message: NotificationText
                                                  .NO_INTERNET_CONNECTION_MESSAGE);
                                          return;
                                        }
                                        bool? checkAuth = await authenticateTransactionUsingBioOrPinCode(appConstants: appConstants, context: context);
                                                  if(checkAuth==false){
                                                    return;
                                                  }
                                                  
                                        var uuid = Uuid();
                                        String transactionId = uuid.v1();
                                        CustomProgressDialog progressDialog =
                                            CustomProgressDialog(context,
                                                blur: 6);
                                        progressDialog.setLoadingWidget(
                                            CustomLoadingScreen());
                                        progressDialog.show();

                                        ApiServices services = ApiServices();
                                        List<dynamic> likes = [];

                                        if (appConstants
                                            .payRequestModel.imageUrl!
                                            .contains('com.zakipay.teencard')) {
                                              // ZakiPay/Country code-bank code/sendreceive/User id/images/
                                                              String fullPath = '${appConstants.userModel.usaCountry}/sendreceive/${appConstants.userRegisteredId}/images';
                                          String? pathImage =
                                              await services.uploadImage(
                                                fullPath: fullPath,
                                                  path: appConstants
                                                      .payRequestModel
                                                      .imageUrl, userId: appConstants.userRegisteredId);
                                          showNotification(
                                              error: 0,
                                              icon: Icons.check,
                                              message: pathImage);

                                          // String? transactionId =
                                          await services.payPlusMoney(
                                              likesList: likes,
                                              selectedKidImageUrl: appConstants
                                                  .payRequestModel
                                                  .selectedKidImageUrl,
                                              selectedKidName: appConstants
                                                  .payRequestModel
                                                  .selectedKidName,
                                              senderImageUrl: appConstants
                                                  .payRequestModel
                                                  .senderImageUrl,
                                              requestType: AppConstants
                                                  .TAG_IT_Transaction_TYPE_SEND_OR_REQUEST,
                                              privacy: appConstants
                                                  .selectedPrivacyType,
                                              accountHolderName:
                                                  '${appConstants.userModel.usaFirstName} ${appConstants.userModel.usaLastName}',
                                              message: appConstants
                                                  .payRequestModel.message,
                                              accountType: 'main',
                                              tagItId: appConstants
                                                  .payRequestModel.tagItId,
                                              tagItName: appConstants
                                                  .payRequestModel.tagItName,
                                              amount: amountController.text,
                                              imageUrl: pathImage,
                                              toUserId: appConstants
                                                  .payRequestModel.toUserId,
                                              currentUserId:
                                                  appConstants.userRegisteredId,
                                              transactionId: transactionId);
                                          await services.addSocialFeed(
                                              likesList: likes,
                                              usersList:
                                                  widget.userInvitedList!,
                                              selectedKidImageUrl: appConstants
                                                  .payRequestModel
                                                  .selectedKidImageUrl,
                                              selectedKidName: appConstants
                                                  .payRequestModel
                                                  .selectedKidName,
                                              senderImageUrl: appConstants
                                                  .payRequestModel
                                                  .senderImageUrl,
                                              requestType: AppConstants
                                                  .TAG_IT_Transaction_TYPE_SEND_OR_REQUEST,
                                              privacy: appConstants
                                                  .selectedPrivacyType,
                                              accountHolderName:
                                                  '${appConstants.userModel.usaFirstName} ${appConstants.userModel.usaLastName}',
                                              message: appConstants
                                                  .payRequestModel.message,
                                              accountType: '',
                                              tagItId: appConstants
                                                  .payRequestModel.tagItId,
                                              tagItName: appConstants
                                                  .payRequestModel.tagItName,
                                              amount: amountController.text,
                                              imageUrl: appConstants
                                                  .payRequestModel.imageUrl,
                                              receiverId: appConstants
                                                  .payRequestModel.toUserId,
                                              senderId:
                                                  appConstants.userRegisteredId,
                                              transactionId: transactionId);
                                        } else {
                                          // String? transactionId =
                                          await services.payPlusMoney(
                                              likesList: likes,
                                              selectedKidImageUrl: appConstants
                                                  .payRequestModel
                                                  .selectedKidImageUrl,
                                              selectedKidName: appConstants
                                                  .payRequestModel
                                                  .selectedKidName,
                                              senderImageUrl: appConstants
                                                  .payRequestModel
                                                  .senderImageUrl,
                                              requestType: AppConstants
                                                  .TAG_IT_Transaction_TYPE_SEND_OR_REQUEST,
                                              privacy: appConstants
                                                  .selectedPrivacyType,
                                              accountHolderName:
                                                  '${appConstants.userModel.usaFirstName} ${appConstants.userModel.usaLastName}',
                                              message: appConstants
                                                  .payRequestModel.message,
                                              accountType: 'main',
                                              tagItId: appConstants
                                                  .payRequestModel.tagItId,
                                              tagItName: appConstants
                                                  .payRequestModel.tagItName,
                                              amount: amountController.text,
                                              imageUrl: appConstants
                                                  .payRequestModel.imageUrl,
                                              toUserId: appConstants
                                                  .payRequestModel.toUserId,
                                              currentUserId:
                                                  appConstants.userRegisteredId,
                                              transactionId: transactionId);
                                          await services.addSocialFeed(
                                              likesList: likes,
                                              usersList:
                                                  widget.userInvitedList!,
                                              selectedKidImageUrl: appConstants
                                                  .payRequestModel
                                                  .selectedKidImageUrl,
                                              selectedKidName: appConstants
                                                  .payRequestModel
                                                  .selectedKidName,
                                              senderImageUrl: appConstants
                                                  .payRequestModel
                                                  .senderImageUrl,
                                              requestType: AppConstants
                                                  .TAG_IT_Transaction_TYPE_SEND_OR_REQUEST,
                                              privacy: appConstants
                                                  .selectedPrivacyType,
                                              accountHolderName:
                                                  '${appConstants.userModel.usaFirstName} ${appConstants.userModel.usaLastName}',
                                              message: appConstants
                                                  .payRequestModel.message,
                                              accountType: '',
                                              tagItId: appConstants
                                                  .payRequestModel.tagItId,
                                              tagItName: appConstants
                                                  .payRequestModel.tagItName,
                                              amount: amountController.text,
                                              imageUrl: appConstants
                                                  .payRequestModel.imageUrl,
                                              receiverId: appConstants
                                                  .payRequestModel.toUserId,
                                              senderId:
                                                  appConstants.userRegisteredId,
                                              transactionId: transactionId);
                                        }

                                        progressDialog.dismiss();
                                        await services.getUserTokenAndSendNotification(
                                            userId: appConstants
                                                .payRequestModel.toUserId,
                                            title:
                                                '${appConstants.userModel.usaUserName} ${NotificationText.REQUEST_NOTIFICATION_TITLE}',
                                            subTitle:
                                                '${NotificationText.REQUEST_NOTIFICATION_SUB_TITLE} ${getCurrencySymbol(context, appConstants: appConstants)} ${amountController.text}',
                                            checkParent: true,
                                            parentTitle: '${appConstants.userModel.usaUserName} sent ${getCurrencySymbol(context, appConstants: appConstants)} ${amountController.text}',
                                            parentSubtitle: 'See Details in ZakiPay'
                                                );

                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    CustomConfermationScreen(
                                                      // title: 'Mission Accomplished!',
                                                      subTitle:
                                                          "${appConstants.payRequestModel.selectedKidName} received ${getCurrencySymbol(context, appConstants: appConstants)} ${appConstants.payRequestModel.amount}",
                                                      // imageUrl: selectedKidImageUrl,
                                                    )));
                                      },
                                    ),
                                  ),
                                ),
                          spacing_medium
                        ],
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  sendUserNotification(
      {String? receiverId,
      String? titleNotification,
      String? bodyNotification}) async {
    ApiServices service = ApiServices();
    //////Getting User Token and then send Notification to Particular User
    Map<dynamic, dynamic>? userData =
        await service.getFirebaseTokenAndNumber(id: receiverId);
    logMethod(
        title: 'After Fetching Token from firebase',
        message: userData![AppConstants.USER_iNApp_NotifyToken]);

    if (userData[AppConstants.USER_iNApp_NotifyToken] != null)
      await service.sendNotification(
          title: titleNotification,
          body: bodyNotification,
          token: userData[AppConstants.USER_iNApp_NotifyToken]);
  }
}
