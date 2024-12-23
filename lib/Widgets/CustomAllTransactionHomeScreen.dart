import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:zaki/Constants/Spacing.dart';
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

class AllActivitiesCustomTileHomeScreen extends StatefulWidget {
  AllActivitiesCustomTileHomeScreen({required this.data, this.onTap});
  final QueryDocumentSnapshot data;
  final VoidCallback? onTap;

  @override
  State<AllActivitiesCustomTileHomeScreen> createState() =>
      _AllActivitiesCustomTileState();
}

class _AllActivitiesCustomTileState extends State<AllActivitiesCustomTileHomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      // var appConstants = Provider.of<AppConstants>(context, listen: false);
      // logMethod(
      //     title: 'Nick name: In IniT sate and value of tagit',
      //     message:
      //         'nickName: ${appConstants.nickNameModel.NickN_SpendWallet} ${widget.data[AppConstants.Transaction_TAGIT_code]}');
    });
  }

  @override
  Widget build(BuildContext context) {
    var appConstants = Provider.of<AppConstants>(context, listen: true);
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    // logMethod(
    //     title:
    //         'Selected Wallet name: ${widget.data[AppConstants.Transaction_To_Wallet]}',
    //     message: appConstants.selectedWallatFilter);
    return widget.data[AppConstants.Transaction_To_Wallet] ==
            appConstants.selectedWallatFilter
        ? const Text('No data')
        : ListTile(
            // onTap: widget.onTap,
            onTap: () {
              appConstants.updateDetailTransactionModel(TransactionDetailModel(
                  userId: widget.data[AppConstants.Transaction_ReceiverUser_id],
                  tagItIcon: (widget.data[AppConstants.Transaction_transaction_type] ==
                          AppConstants.TAG_IT_Transaction_TYPE_INTERNAL_TRANSFER)
                      ? Icons.money
                      : widget.data[AppConstants.Transaction_transaction_type] ==
                              AppConstants.TAG_IT_Transaction_TYPE_TODO_REWARD
                          ? FontAwesomeIcons.moneyBillTransfer
                          : widget.data[AppConstants.Transaction_TAGIT_code] ==
                                  null
                              ? Icons.star_half
                              : AppConstants
                                  .tagItList[int.parse(widget.data[
                                      AppConstants.Transaction_TAGIT_code])]
                                  .icon,
                  walletName: walletNickName(
                      walletName: (widget.data[AppConstants.Transaction_transaction_type] ==
                                  AppConstants.TAG_IT_Transaction_TYPE_ALLOWANCE &&
                              (widget.data[AppConstants.Transaction_Method] ==
                                  AppConstants.Transaction_Method_Payment))
                          ? widget.data[AppConstants.Transaction_From_Wallet]
                          : ((widget.data[AppConstants.Transaction_transaction_type] ==
                                      AppConstants.TAG_IT_Transaction_TYPE_GOALS) &&
                                  (widget.data[AppConstants.Transaction_Method] ==
                                      AppConstants.Transaction_Method_Payment))
                              ? widget
                                  .data[AppConstants.Transaction_From_Wallet]
                              : widget.data[AppConstants.Transaction_To_Wallet],
                      appConstants: appConstants),
                  amount: ((widget.data[AppConstants.Transaction_Method] == AppConstants.Transaction_Method_Payment) ? '-' : '+') +
                      '${getCurrencySymbol(context, appConstants: appConstants)}' +
                      '${widget.data[AppConstants.Transaction_amount]}',
                  transactionType: widget.data[AppConstants.Transaction_transaction_type],
                  name: widget.data[AppConstants.Transaction_Sender_UserName],
                  transactionDate: formatedDateWithMonthAndTime(date: widget.data[AppConstants.created_at].toDate()),
                  transactionMessage: widget.data[AppConstants.Transaction_Message_Text],
                  transactionId: widget.data.id,
                  transactionMethod: widget.data[AppConstants.Transaction_Method],
                  tagItName: widget.data[AppConstants.Transaction_TAGIT_Category],
                  fullDate: widget.data[AppConstants.created_at].toDate(),
                  // transactionLatLang:widget.data.latLang
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
                (widget.data[AppConstants.Transaction_transaction_type] ==
                        AppConstants.TAG_IT_Transaction_TYPE_INTERNAL_TRANSFER)
                    ? FontAwesomeIcons.moneyBillTransfer
                    : (widget.data[AppConstants.Transaction_transaction_type] ==
                            AppConstants.TAG_IT_Transaction_TYPE_Fund_My_Wallet)
                        ? FontAwesomeIcons.creditCard
                        : widget.data[AppConstants
                                    .Transaction_transaction_type] ==
                                AppConstants.TAG_IT_Transaction_TYPE_TODO_REWARD
                            ? FontAwesomeIcons.trophy
                            : widget.data[
                                        AppConstants.Transaction_TAGIT_code] ==
                                    null
                                ? Icons.star_half
                                : AppConstants
                                    .tagItList[int.parse(widget.data[
                                        AppConstants.Transaction_TAGIT_code])]
                                    .icon,
                color: orange,
              ),
              // child: Image.asset(AppConstants.tagItList[snapshot.data!.docs[index][int.parse(AppConstants.Transaction_TAGIT_code)]].icon.toString() ),
            ),
            title:
                //  Heading1Field(title: snapshot.data!.docs[index]
                //       [AppConstants.Transaction_Sender_UserName]),
                Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Text(
                    (widget.data[AppConstants.Transaction_transaction_type] ==
                            AppConstants.TAG_IT_Transaction_TYPE_DEBIT_CARD_P)
                        ? '[Store Name]'
                        : widget.data[AppConstants
                                    .Transaction_transaction_type] ==
                                AppConstants.TAG_IT_Transaction_TYPE_DEBIT_CARD_V
                            ? 'Refund'
                            : (widget.data[AppConstants
                                            .Transaction_transaction_type] ==
                                        AppConstants
                                            .TAG_IT_Transaction_TYPE_INTERNAL_TRANSFER ||
                                    widget.data[AppConstants
                                            .Transaction_transaction_type] ==
                                        AppConstants.TAG_IT_Transaction_TYPE_GOALS ||
                                    widget.data[AppConstants
                                            .Transaction_transaction_type] ==
                                        AppConstants
                                            .TAG_IT_Transaction_TYPE_Fund_My_Wallet)
                                ? '${getTransactionName(appConstants: appConstants)}'
                                : '${getTransactionName(appConstants: appConstants)} ${checkTransactionType(userId: appConstants.userRegisteredId)} ${senderCurrentUser(userId: appConstants.userRegisteredId) ? widget.data[AppConstants.Transaction_receiver_name] : widget.data[AppConstants.Transaction_Sender_UserName]}',
                    overflow: TextOverflow.clip,
                    maxLines: 2,
                    style: heading3TextStyle(width * 0.9),
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
                    // if(widget.data[AppConstants.Transaction_transaction_type] == AppConstants.TAG_IT_Transaction_TYPE_INTERNAL_TRANSFER)
                    Text(
                      '{${walletNickName(walletName: (widget.data[AppConstants.Transaction_transaction_type] == AppConstants.TAG_IT_Transaction_TYPE_ALLOWANCE && (widget.data[AppConstants.Transaction_Method] == AppConstants.Transaction_Method_Payment)) ? widget.data[AppConstants.Transaction_From_Wallet] : ((widget.data[AppConstants.Transaction_transaction_type] == AppConstants.TAG_IT_Transaction_TYPE_GOALS) && (widget.data[AppConstants.Transaction_Method] == AppConstants.Transaction_Method_Payment)) ? widget.data[AppConstants.Transaction_From_Wallet] : widget.data[AppConstants.Transaction_To_Wallet], appConstants: appConstants)}} - ',
                      overflow: TextOverflow.clip,
                      maxLines: 1,
                      style: heading4TextSmall(width),
                    ),

                    Text(
                      formatedDateWithMonth(
                          date: widget.data[AppConstants.created_at].toDate()),
                      overflow: TextOverflow.clip,
                      maxLines: 1,
                      style: heading4TextSmall(width),
                    ),

                    // Text(
                    //   " - ${data[AppConstants.Transaction_Method]}" ,
                    //   overflow: TextOverflow.clip,
                    //   maxLines: 1,
                    //   style: heading4TextSmall(width),
                    // ),
                    //
                  ],
                ),
                if ((widget.data[AppConstants.Transaction_transaction_type] ==
                    AppConstants.TAG_IT_Transaction_TYPE_INTERNAL_TRANSFER))
                  Text(
                    widget.data[AppConstants.Transaction_Message_Text],
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
                  style: heading4TextSmall(width, color: grey.withOpacity(0.8)),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      (widget.data[AppConstants.Transaction_Method] ==
                              AppConstants.Transaction_Method_Payment)
                          ? '-'
                          : '+'
                      // (widget.data[AppConstants.Transaction_Method]==AppConstants.Transaction_Method_Received)? '+':
                      ,
                      overflow: TextOverflow.clip,
                      maxLines: 1,
                      style: heading3TextStyle(width,
                          color:
                              (widget.data[AppConstants.Transaction_Method] ==
                                      AppConstants.Transaction_Method_Received)
                                  ? green
                                  : black),
                    ),
                    Text(
                      '${widget.data[AppConstants.Transaction_amount]}',
                      // '${getCurrencySymbol(context, appConstants: appConstants )} ${getTwoDecimalNumber(amount: double.parse(widget.data[AppConstants.Transaction_amount]))}',
                      overflow: TextOverflow.clip,
                      maxLines: 1,
                      style: heading3TextStyle(width,
                          color:
                              (widget.data[AppConstants.Transaction_Method] ==
                                      AppConstants.Transaction_Method_Received)
                                  ? green
                                  : black),
                    ),
                    widget.data[AppConstants.Transaction_transaction_type] ==
                            AppConstants.TAG_IT_Transaction_TYPE_SEND_OR_REQUEST
                        ? widget.data[AppConstants.Transaction_SenderUser_id] ==
                                appConstants.userRegisteredId
                            ? InkWell(
                                onTap: () {
                                  logMethod(
                                      title: 'Socialize id: ${widget.data.id}',
                                      message: widget.data.id.toString());
                                  Stream<QuerySnapshot>? specficSocialFeed =
                                      ApiServices().getSpecficSoalFeed(
                                          userId: appConstants.userRegisteredId,
                                          transactionId: widget.data[
                                              AppConstants.Transaction_id]);
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
      builder: (_) => AlertDialog(
        contentPadding: EdgeInsets.zero,

        // title: mainTitle==null?null : TextHeader1(
        //   title: mainTitle
        //   ),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(14.0))),
        content: socialFeed == null
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

  getTransactionName({AppConstants? appConstants}) {
    if (
        // data[AppConstants.Transaction_transaction_type] == AppConstants.TAG_IT_Transaction_TYPE_SEND_OR_REQUEST &&
        widget.data[AppConstants.Transaction_transaction_type] ==
            AppConstants.TAG_IT_Transaction_TYPE_SEND_OR_REQUEST) {
      return 'Money ${widget.data[AppConstants.Transaction_Method] == AppConstants.Transaction_Method_Payment ? 'sent' : 'received'}';
    } else if (widget.data[AppConstants.Transaction_transaction_type] ==
        AppConstants.TAG_IT_Transaction_TYPE_ALLOWANCE) {
      return '${AppConstants.TAG_IT_Transaction_TYPE_ALLOWANCE} ${widget.data[AppConstants.Transaction_Method] == AppConstants.Transaction_Method_Payment ? 'sent' : ''}';
    } else if (widget.data[AppConstants.Transaction_transaction_type] ==
        AppConstants.TAG_IT_Transaction_TYPE_TODO_REWARD) {
      return 'Reward ${widget.data[AppConstants.Transaction_Method] == AppConstants.Transaction_Method_Payment ? 'sent' : 'received'}';
    } else if (widget.data[AppConstants.Transaction_transaction_type] ==
        AppConstants.TAG_IT_Transaction_TYPE_INTERNAL_TRANSFER) {
      return '${(widget.data[AppConstants.Transaction_Method] == AppConstants.Transaction_Method_Payment) ? 'Money moved to ${walletNickName(walletName: widget.data[AppConstants.Transaction_From_Wallet], appConstants: appConstants)}' : 'Money moved from ${walletNickName(walletName: widget.data[AppConstants.Transaction_From_Wallet], appConstants: appConstants)}'}';
    } else if (widget.data[AppConstants.Transaction_transaction_type] ==
        AppConstants.TAG_IT_Transaction_TYPE_GOALS) {
      return 'Goals Funding ${(widget.data[AppConstants.Transaction_Method] == AppConstants.Transaction_Method_Payment) ? ' - Sent' : ' From ${widget.data[AppConstants.Transaction_Sender_UserName]}'}';
      // return 'Goals Contribution ${(widget.data[AppConstants.Transaction_Method]==AppConstants.Transaction_Method_Payment) ? ' to ${widget.data[AppConstants.Transaction_receiver_name]}' : ' from ${widget.data[AppConstants.Transaction_Sender_UserName]}}'}';
    } else if (widget.data[AppConstants.Transaction_transaction_type] ==
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
    if (widget.data[AppConstants.Transaction_Method] ==
        AppConstants.Transaction_Method_Payment)

    //     widget.data[AppConstants.Transaction_SenderUser_id] == userId)
    {
      return 'to';
    } else {
      return 'from';
    }
  }

  senderCurrentUser({required String userId}) {
    if (
        // data[AppConstants.Transaction_transaction_type] == AppConstants.TAG_IT_Transaction_TYPE_SEND_OR_REQUEST &&
        widget.data[AppConstants.Transaction_SenderUser_id] != userId &&
            (widget.data[AppConstants.Transaction_transaction_type] ==
                AppConstants.TAG_IT_Transaction_TYPE_INTERNAL_TRANSFER)) {
      return true;
    } else {
      return false;
    }
  }
}
