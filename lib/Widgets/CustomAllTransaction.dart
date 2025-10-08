import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:zaki/Constants/Spacing.dart';
import 'package:zaki/Models/Items.dart';
import 'package:zaki/Models/TransactionDetailModel.dart';
import 'package:zaki/Screens/TransactionDetailPage.dart';
import 'package:zaki/Widgets/ZakiCircularButton.dart';

import '../Constants/AppConstants.dart';
import '../Constants/HelperFunctions.dart';
import '../Constants/Styles.dart';
import '../Screens/Socialize.dart';
import '../Services/api.dart';
import 'CustomFeedCard.dart';
import 'package:zaki/Widgets/CustomLoader.dart';

// import 'ZakiPrimaryButton.dart';
// import '../Screens/AllActivities.dart';

class AllActivitiesCustomTile extends StatefulWidget {
  AllActivitiesCustomTile({required this.data, this.onTap, this.fromBankApi, this.selectedUserId});
  final Item data;
  final VoidCallback? onTap;
  final bool? fromBankApi;
  final String? selectedUserId;

  @override
  State<AllActivitiesCustomTile> createState() =>
      _AllActivitiesCustomTileState();
}

class _AllActivitiesCustomTileState extends State<AllActivitiesCustomTile> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      // var appConstants = Provider.of<AppConstants>(context, listen: false);
      logMethod(
          title: 'Method',
          message:widget.data.transactionMethod.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    var appConstants = Provider.of<AppConstants>(context, listen: true);
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    // logMethod(
    //     title:
    //         'Selected Wallet name: ${widget.data.transactionToWallet}',
    //     message: appConstants.selectedWallatFilter);
    return widget.data.transactionToWallet ==
            appConstants.selectedWallatFilter
        ? const Text('No data')
        : ListTile(
            // onTap: widget.onTap,
            onTap: () { 
              appConstants.updateDetailTransactionModel(
                TransactionDetailModel(
                  userId: widget.data.transactionReceiverUserId,
                  tagItIcon: (widget.data.transactionTransactionType==
                          AppConstants.TAG_IT_Transaction_TYPE_INTERNAL_TRANSFER)
                      ? Icons.money
                      : widget.data.transactionTransactionType ==
                              AppConstants.TAG_IT_Transaction_TYPE_TODO_REWARD
                          ? FontAwesomeIcons.moneyBillTransfer
                          : widget.data.transactionTagitCode==
                                  null
                              ? Icons.star_half
                              : AppConstants
                                  .tagItList[int.parse(widget.data.transactionTagitCode.toString())]
                                  .icon,
                  walletName: walletNickName(
                      walletName: (widget.data.transactionTransactionType ==
                                  AppConstants.TAG_IT_Transaction_TYPE_ALLOWANCE &&
                              (widget.data.transactionMethod ==
                                  AppConstants.Transaction_Method_Payment))
                          ? widget.data.transactionFromWallet
                          : ((widget.data.transactionTransactionType ==
                                      AppConstants.TAG_IT_Transaction_TYPE_GOALS) &&
                                  (widget.data.transactionMethod ==
                                      AppConstants.Transaction_Method_Payment))
                              ? widget
                                  .data.transactionFromWallet
                              : widget.data.transactionToWallet,
                      appConstants: appConstants),
                  amount: 
                  // (
                    // (widget.fromBankApi==true && widget.data.transactionAmount!.contains('-')) ? '-': (widget.fromBankApi==true && !widget.data.transactionAmount!.contains('-')) ? '+': (widget.data.transactionMethod == AppConstants.Transaction_Method_Payment) ? '-' : '+') +
                      '${getCurrencySymbol(context, appConstants: appConstants)}' + ' ' 
                      '${(widget.data.transactionAmount!.contains('-') ? double.parse(widget.data.transactionAmount!).toStringAsFixed(2): 
                      widget.data.transactionSenderUserId ==
                                (widget.selectedUserId?? appConstants.userRegisteredId)? "-"+double.parse(widget.data.transactionAmount!).toStringAsFixed(2):
                      "+"+double.parse(widget.data.transactionAmount!).toStringAsFixed(2))}',
                  transactionType: widget.data.transactionTransactionType,
                  name: widget.data.transactionSenderUserName,
                  transactionDate: formatedDateWithMonthAndTime(date: widget.data.createdAt),
                  fullDate: widget.data.createdAt,
                  transactionMessage: widget.data.transactionMessageText,
                  transactionId: widget.data.transactionId,
                  ///data.id  is o;d implementation
                  transactionMethod: widget.data.transactionMethod,
                  tagItName: widget.data.transactionTagitCategory,
                  transactionLatLang:widget.data.latLang
                  ));
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => TransactionDetail()));
            },
            dense: true, 
            contentPadding: EdgeInsets.symmetric(horizontal: 12),
            visualDensity: VisualDensity.compact,
            leading: Container(
              height: height * 0.06,
              width: height * 0.06,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: white,
                  border: Border.all(color: orange)),
              child: Icon(
                (widget.data.transactionTransactionType ==
                        AppConstants.TAG_IT_Transaction_TYPE_INTERNAL_TRANSFER)
                    ? FontAwesomeIcons.moneyBillTransfer
                    : (widget.data.transactionTransactionType ==
                            AppConstants.TAG_IT_Transaction_TYPE_Fund_My_Wallet)
                        ? FontAwesomeIcons.creditCard
                        : widget.data.transactionTransactionType ==
                                AppConstants.TAG_IT_Transaction_TYPE_TODO_REWARD
                            ? FontAwesomeIcons.trophy
                            : widget.data.transactionTagitCode ==
                                    null
                                ? Icons.star_half
                                : AppConstants
                                    .tagItList[int.parse(widget.data.transactionTagitCode.toString())]
                                    .icon,
                color: orange,
              ),
              // child: Image.asset(AppConstants.tagItList[snapshot.data!.docs[index][int.parse(AppConstants.Transaction_TAGIT_code)]].icon.toString() ),
            ),
            
            title:
                //  Heading1Field(title: snapshot.data!.docs[index]
                //       .transactionSenderUserName),
                Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        widget.data.transactionTransactionType== AppConstants.TAG_IT_Transaction_TYPE_SUBSCRIPTION?
                        'Zakipay Subscription Renewal':
                        (widget.data.transactionTransactionType ==
                                AppConstants.TAG_IT_Transaction_TYPE_DEBIT_CARD_P)
                            ? '[Store Name]'
                            : widget.data.transactionTransactionType ==
                                    AppConstants.TAG_IT_Transaction_TYPE_DEBIT_CARD_V
                                ? 'Refund'
                                : (widget.data.transactionTransactionType  ==
                                            AppConstants
                                                .TAG_IT_Transaction_TYPE_INTERNAL_TRANSFER ||
                                        widget.data.transactionTransactionType  ==
                                            AppConstants.TAG_IT_Transaction_TYPE_GOALS ||
                                        widget.data.transactionTransactionType  ==
                                            AppConstants
                                                .TAG_IT_Transaction_TYPE_Fund_My_Wallet)
                                    ? '${getTransactionName(appConstants: appConstants)}'
                                    : '${getTransactionName(appConstants: appConstants)} ${checkTransactionType(userId: widget.selectedUserId?? appConstants.userRegisteredId)} ${senderCurrentUser(userId: appConstants.userRegisteredId) ? widget.data.transactionReceiverName : widget.data.transactionSenderUserName}',
                        overflow: TextOverflow.clip,
                        maxLines: 2,
                        style: heading3TextStyle(width * 0.9),
                      ),
                      // Text('Name')
                      if(widget.data.transactionTransactionType == AppConstants.TAG_IT_Transaction_TYPE_SEND_OR_REQUEST || widget.data.transactionTransactionType == AppConstants.TAG_IT_Transaction_TYPE_ALLOWANCE || widget.data.transactionTransactionType == AppConstants.TAG_IT_Transaction_TYPE_TODO_REWARD)
                      UserSection(
                      userId: widget.data.transactionSenderUserId==appConstants.userRegisteredId? widget.data.transactionReceiverUserId : widget.data.transactionSenderUserId,
                      // widget.data.transactionTransactionType == AppConstants.TAG_IT_Transaction_TYPE_ALLOWANCE? widget.data.transactionReceiverUserId : widget.data.transactionSenderUserId,
                      onlyName: true, 
                      clickEnabled: false,
                      ),
                    ],
                  ),
                ),
                
              ],
            ),
            subtitle: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // if(widget.data.transactionTransactionType == AppConstants.TAG_IT_Transaction_TYPE_INTERNAL_TRANSFER)
                    Text(
                      '{${walletNickName(walletName: (widget.data.transactionTransactionType == AppConstants.TAG_IT_Transaction_TYPE_ALLOWANCE && (widget.data.transactionMethod == AppConstants.Transaction_Method_Payment)) ? widget.data.transactionFromWallet : ((widget.data.transactionTransactionType == AppConstants.TAG_IT_Transaction_TYPE_GOALS) && (widget.data.transactionMethod == AppConstants.Transaction_Method_Payment)) ? widget.data.transactionFromWallet : widget.data.transactionToWallet, appConstants: appConstants)}} - ',
                      overflow: TextOverflow.clip,
                      maxLines: 1,
                      style: heading4TextSmall(width),
                    ),

                    Text(
                      formatedDateWithMonth(
                          date: widget.data.createdAt),
                      overflow: TextOverflow.clip,
                      maxLines: 1,
                      style: heading4TextSmall(width),
                    ),

                    // Text(
                    //   " - ${data.transactionMethod}" ,
                    //   overflow: TextOverflow.clip,
                    //   maxLines: 1,
                    //   style: heading4TextSmall(width),
                    // ),
                    //
                  ],
                ),
                if ((widget.data.transactionTransactionType ==
                    AppConstants.TAG_IT_Transaction_TYPE_INTERNAL_TRANSFER))
                  Text(
                    widget.data.transactionMessageText.toString(),
                    style: heading4TextSmall(width * 0.85),
                  )
              ],
            ),
            trailing: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${getCurrencySymbol(context, appConstants: appConstants)}',
                  style: heading4TextSmall(width, color: grey.withValues(alpha:0.8)),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Text(
                    //   (widget.data.transactionMethod ==
                    //           AppConstants.Transaction_Method_Payment)
                    //       ? '-'
                    //       : '+'
                    //   // (widget.data.transactionMethod==AppConstants.Transaction_Method_Received)? '+':
                    //   ,
                    //   overflow: TextOverflow.clip,
                    //   maxLines: 1,
                    //   style: heading3TextStyle(width,
                    //       color:
                    //           (widget.data.transactionMethod ==
                    //                   AppConstants.Transaction_Method_Received)
                    //               ? green
                    //               : black),
                    // ),
                    Text(
                      '${widget.selectedUserId!=null? widget.data.transactionSenderUserId ==
                                (widget.selectedUserId)? '-': '+':''}${formatNumberWithSpace(double.parse(widget.data.transactionAmount!).toStringAsFixed(2))}',
                      // '${getCurrencySymbol(context, appConstants: appConstants )} ${getTwoDecimalNumber(amount: double.parse(widget.data[AppConstants.Transaction_amount]))}',
                      overflow: TextOverflow.clip,
                      maxLines: 1,
                      style: heading3TextStyle(width,
                          color:
                          (widget.fromBankApi==true && widget.data.transactionAmount!.contains('-'))? black:
                          (widget.fromBankApi==true && !widget.data.transactionAmount!.contains('-'))? green:
                          // (widget.data.transactionMethod == AppConstants.Transaction_Method_Received)
                          widget.data.transactionSenderUserId !=
                                (widget.selectedUserId)
                                  ? green
                                  : black),
                    ),
                    widget.data.transactionTransactionType ==
                            AppConstants.TAG_IT_Transaction_TYPE_SEND_OR_REQUEST
                        ? 
                        
                        widget.data.transactionSenderUserId ==
                                (widget.selectedUserId?? appConstants.userRegisteredId)
                            ? InkWell(
                                onTap: () {
                                  logMethod(
                                      title: 'Socialize id: ${widget.data.transactionId}',
                                      message: widget.data.transactionId.toString());
                                  Stream<QuerySnapshot>? specficSocialFeed =
                                      ApiServices().getSpecficSoalFeed(
                                          userId: appConstants.userRegisteredId,
                                          transactionId: widget.data.transactionId);
                                  customFeedDialouge(
                                      context: context,
                                      socialFeed: specficSocialFeed);
                                  // Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (context) =>
                                  //             AllActivities(id: data.id)));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 4.0),
                                  child: Icon(
                                    Icons.arrow_forward,
                                    size: width * 0.05,
                                    color: grey,
                                  ),
                                ),
                              )
                            : const SizedBox.shrink()
                        : const SizedBox.shrink(),
                  ],
                ),
              ],
            ),
          );
  }

  Future<dynamic> customFeedDialouge(
      {Stream<QuerySnapshot<Object?>>? socialFeed, BuildContext? context}) {
    return showDialog(
      useSafeArea: true,
      context: context!,
      builder: (_) => Dialog.fullscreen(
        // contentPadding: EdgeInsets.zero,

        // // title: mainTitle==null?null : TextHeader1(
        // //   title: mainTitle
        // //   ),
        // shape: RoundedRectangleBorder(
        //     borderRadius: BorderRadius.all(Radius.circular(14.0))),
        child: socialFeed == null
            ? const SizedBox()
            : StreamBuilder<QuerySnapshot>(
                stream: socialFeed,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  // if (highlight) {

                  // }
                  if (snapshot.hasError) {
                    return const SizedBox();
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CustomLoader());
                  }
                  return ListView.builder(
                    itemCount: snapshot.data!.size,
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    // separatorBuilder: (context, index) => (snapshot.data!.docs[index][AppConstants.Social_Sharedwith_Users_List].length!=0 && !snapshot.data!.docs[index][AppConstants.Social_Sharedwith_Users_List].contains(appConstants.userRegisteredId))?
                    //   SizedBox.shrink(): Divider(color: black),
                    itemBuilder: (BuildContext context, int index) {
                      return
                          // snapshot.data!.docs[index].id!=widget.postId? const SizedBox.shrink():
                          Column(
                        children: [
                          spacing_medium,
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: Icon(Icons.close))
                            ],
                          ),
                          spacing_large,
                          CustomFeedCard(
                            needPadding: false,
                            snapshot: snapshot.data!.docs[index],
                          ),
                          spacing_small,
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 40.0),
                            child: ZakiCicularButton(
                              title: 'See Friends Activities',
                              width: 200,
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AllActivities()));
                              },
                            ),
                          ),
                          spacing_medium
                          // ZakiPrimaryButton(
                          //   title: 'See Friends Activities',
                          //   width: 200,
                          //   onPressed: (){
                          //     Navigator.push(context, MaterialPageRoute(builder: (context)=>AllActivities()));
                          //   },
                          // )
                        ],
                      );
                      // Text(snapshot.data!.docs[index][AppConstants.Social_amount].toString());
                    },
                  );
                }),
        // actions
      ),
    );
  }

  getSendOrReceiveText({String? userId}) {
     if(widget.fromBankApi==true && widget.data.transactionAmount!.contains('-')) {
      //It means transafer method ==Payment
      return 'sent';
    } 
    if(widget.fromBankApi==true && !widget.data.transactionAmount!.contains('-')) {
      //It means transafer method ==Payment
      return 'received';
    } 
    // if(widget.data.transactionMethod == AppConstants.Transaction_Method_Payment )
    if(widget.data.transactionReceiverUserId != userId)
    
    return 'sent'; 
    else
     return 'received';

  }

  getTransactionName({AppConstants? appConstants}) {
    if (
        // data.transactionTransactionType == AppConstants.TAG_IT_Transaction_TYPE_SEND_OR_REQUEST &&
        widget.data.transactionTransactionType ==
            AppConstants.TAG_IT_Transaction_TYPE_SEND_OR_REQUEST) {
      return 'Money ${getSendOrReceiveText(userId: widget.selectedUserId)}';
    } else if (widget.data.transactionTransactionType ==
        AppConstants.TAG_IT_Transaction_TYPE_ALLOWANCE) {
      return '${AppConstants.TAG_IT_Transaction_TYPE_ALLOWANCE} ${(widget.fromBankApi==true && widget.data.transactionAmount!.contains('-')) ? 'sent' : (widget.fromBankApi==true && !widget.data.transactionAmount!.contains('-')) ? '':widget.data.transactionMethod == AppConstants.Transaction_Method_Payment ? 'sent' : ''}';
    } else if (widget.data.transactionTransactionType ==
        AppConstants.TAG_IT_Transaction_TYPE_TODO_REWARD) {
      return 'Reward ${(widget.fromBankApi==true && widget.data.transactionAmount!.contains('-')) ? 'Sent': (widget.fromBankApi==true && !widget.data.transactionAmount!.contains('-')) ? 'received':   widget.data.transactionMethod == AppConstants.Transaction_Method_Payment ? 'sent' : 'received'}';
    } else if (widget.data.transactionTransactionType ==
        AppConstants.TAG_IT_Transaction_TYPE_INTERNAL_TRANSFER) {
      return '${(widget.data.transactionMethod == AppConstants.Transaction_Method_Payment) ? 'Money moved to ${walletNickName(walletName: widget.data.transactionFromWallet, appConstants: appConstants)}' : 'Money moved from ${walletNickName(walletName: widget.data.transactionFromWallet, appConstants: appConstants)}'}';
    } else if (widget.data.transactionTransactionType ==
        AppConstants.TAG_IT_Transaction_TYPE_GOALS) {
      return 'Goals Funding ${(widget.fromBankApi==true) ? widget.data.transactionAmount!.contains('-')? ' - Sent':  (widget.data.transactionMethod == AppConstants.Transaction_Method_Payment) ?  ' - Sent' : ' From ${widget.data.transactionSenderUserName}':'From '}';
      // return 'Goals Contribution ${(widget.data.transactionMethod==AppConstants.Transaction_Method_Payment) ? ' to ${widget.data[AppConstants.Transaction_receiver_name]}' : ' from ${widget.data.transactionSenderUserName}}'}';
    } else if (widget.data.transactionTransactionType ==
        AppConstants.TAG_IT_Transaction_TYPE_Fund_My_Wallet) {
      return 'Deposit';
      // return 'Money deposited to ${walletNickName(walletName: widget.data[AppConstants.Transaction_To_Wallet], appConstants: appConstants)} Wallet';
    }
  }

  String walletNickName({String? walletName, AppConstants? appConstants}) {
    // var appConstants = Provider.of<AppConstants>(context, listen: true);

    return (walletName == AppConstants.Spend_Wallet ||
            walletName == 'Spend Anywhere')
        ? (appConstants!.nickNameModel.NickN_SpendWallet != null &&
                appConstants.nickNameModel.NickN_SpendWallet != ""
            ? appConstants.nickNameModel.NickN_SpendWallet!
            : 'Spend')
        : (walletName == AppConstants.Savings_Wallet || walletName == 'Savings')
            ? (appConstants!.nickNameModel.NickN_SavingWallet != null &&
                    appConstants.nickNameModel.NickN_SavingWallet != ""
                ? appConstants.nickNameModel.NickN_SavingWallet!
                : 'Savings')
            : (walletName == AppConstants.Donations_Wallet ||
                    walletName == 'Charity')
                ? (appConstants!.nickNameModel.NickN_DonationWallet != null &&
                        appConstants.nickNameModel.NickN_DonationWallet != ""
                    ? appConstants.nickNameModel.NickN_DonationWallet!
                    : 'Charity')
                : walletName == AppConstants.All_Goals_Wallet
                    ? 'All Goals'
                    : '';
  }

  checkTransactionType({required String userId}) {

    if(widget.fromBankApi==true && widget.data.transactionAmount!.contains('-')) {
      //It means transafer method ==Payment
      return 'to';
    } 
    if(widget.fromBankApi==true && !widget.data.transactionAmount!.contains('-')) {
      //It means transafer method ==Payment
      return 'from';
    } 
    logMethod(title: "Sender and receiver", message: 'Sender: ${widget.data.transactionSenderUserId} and Receiver: ${widget.data.transactionReceiverUserId} and current user id: $userId');
    if (
      // widget.data.transactionMethod ==
      //   AppConstants.Transaction_Method_Payment)

        widget.data.transactionReceiverUserId != userId)
    {
      return 'to';
    } else {
      return 'from';
    }
  }

  senderCurrentUser({required String userId}) {
    if (
        // data.transactionTransactionType == AppConstants.TAG_IT_Transaction_TYPE_SEND_OR_REQUEST &&
        widget.data.transactionSenderUserId != userId &&
            (widget.data.transactionTransactionType ==
                AppConstants.TAG_IT_Transaction_TYPE_INTERNAL_TRANSFER)) {
      return true;
    } else {
      return false;
    }
  }
}
