import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zaki/Services/api.dart';
import '../Constants/AppConstants.dart';
import '../Constants/HelperFunctions.dart';
import '../Constants/Styles.dart';
import '../Models/PayRequestsModel.dart';
import '../Screens/PayReview.dart';

class PayHomeScreen extends StatefulWidget {
  const PayHomeScreen({
    Key? key,
    // required this.requestedMoney,
    required this.width,
    required this.height,
  }) : super(key: key);

  // final Stream<QuerySnapshot<Object?>>? requestedMoney;
  final double width;
  final double height;

  @override
  State<PayHomeScreen> createState() => _PayHomeScreenState();
}

class _PayHomeScreenState extends State<PayHomeScreen> {
   Stream<QuerySnapshot>? requestedMoney;

  @override
  void initState() {
    getMoney();
    super.initState();
  }

  getMoney() {
    Future.delayed(Duration.zero, () async {
      var appConstants = Provider.of<AppConstants>(context, listen: false);
      // userKids = ApiServices().fetchUserKids(appConstants.userRegisteredId, currentUserId: appConstants.userRegisteredId);

      // userKids1 = ApiServices().fetchUserKids1(appConstants.userRegisteredId, currentUserId: appConstants.userRegisteredId);
      requestedMoney = await ApiServices().getRequestedMoneyForCurrentUser(
          appConstants.userRegisteredId, context);
          setState(() {
            
          });
    });
  }

  @override
  Widget build(BuildContext context) {
    var appConstants = Provider.of<AppConstants>(context, listen: true);
    return
    requestedMoney==null? SizedBox.shrink() : StreamBuilder(
      stream: requestedMoney,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const SizedBox();
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("");
        }

//snapshot.data!.docs[index] ['USA_first_name']
        if (snapshot.hasData && snapshot.data!.docs.isNotEmpty)
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int index) {
              // print(snapshot.data!.docs[index] ['USA_first_name']);
              return InkWell(
                onTap: snapshot.data!.docs[index]
                            [AppConstants.RQT_SenderUser_id] ==
                        snapshot.data!.docs[index]
                            [AppConstants.RQT_ReceiverUser_id]
                    ? null
                    : () async {
                        logMethod(
                            title: 'Sender and receiver id',
                            message:
                                'Sender: ${snapshot.data!.docs[index][AppConstants.RQT_SenderUser_id]} and ${snapshot.data!.docs[index][AppConstants.RQT_ReceiverUser_id]}');
                        // if(snapshot.data!.docs[index][AppConstants.RQT_ReceiverUser_id]==appConstants.userRegisteredId){
                        // return;
                        // }
                        // appConstants.updateCurrentUserIdForBottomSheet()
                        bool screenNotOpen = await checkUserSubscriptionValue(
                            appConstants, context);
                        if (screenNotOpen == false) {
                          String? bankTokenOfSelectedUser = await ApiServices()
                              .getAccountNumberFromId(
                                  userId: snapshot.data!.docs[index]
                                      [AppConstants.RQT_SenderUser_id]);
                          PayRequestModel model = PayRequestModel(
                              isFromReview: true,
                              id: snapshot.data!.docs[index].id,
                              receiverGender: snapshot.data!.docs[index]
                                  [AppConstants.RQT_Sender_UserName],
                              receiverUserType: snapshot.data!.docs[index]
                                  [AppConstants.RQT_Sender_UserName],
                              accountHolderName: snapshot.data!.docs[index]
                                  [AppConstants.RQT_Sender_UserName],
                              accountType: snapshot.data!.docs[index]
                                  [AppConstants.RQT_WalletName],
                              tagItId: snapshot.data!.docs[index]
                                  [AppConstants.RQT_TAGIT_id],
                              tagItName: snapshot.data!.docs[index]
                                  [AppConstants.RQT_TAGIT_name],
                              amount: snapshot.data!.docs[index]
                                  [AppConstants.RQT_amount],
                              createdAt: snapshot.data!.docs[index][AppConstants.created_at]
                                  .toDate(),
                              fromUserId: snapshot.data!.docs[index]
                                  [AppConstants.RQT_SenderUser_id],
                              imageUrl: snapshot.data!.docs[index]
                                  [AppConstants.RQT_image_url],
                              selectedKidName: snapshot.data!.docs[index]
                                  [AppConstants.RQT_Sender_UserName],
                              selectedKidImageUrl: snapshot.data!.docs[index][AppConstants.RQT_sender_image_url],
                              message: snapshot.data!.docs[index][AppConstants.RQT_Message_Text],
                              requestType: snapshot.data!.docs[index][AppConstants.RQT_transaction_type],
                              requestDoucumentId: snapshot.data!.docs[index][AppConstants.RQT_DocumentId],
                              toUserId: snapshot.data!.docs[index][AppConstants.RQT_SenderUser_id],
                              selectedKidBankToken: bankTokenOfSelectedUser
                              // selectedKidBankToken:
                              );
                          appConstants.updatePayRequestModel(model);

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const PayReview(
                                        userInvitedList: [],
                                      )));
                        }
                      },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6.0),
                  child: Column(
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Container(
                                height: 70,
                                width: 70,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: snapshot.data!.docs[index][
                                                  AppConstants
                                                      .RQT_SenderUser_id] ==
                                              snapshot.data!.docs[index][
                                                  AppConstants
                                                      .RQT_ReceiverUser_id]
                                          ? green
                                          : red,
                                    )),
                                child: snapshot.data!.docs[index][AppConstants.RQT_sender_image_url] ==
                                        ''
                                    ? SizedBox()
                                    : snapshot.data!.docs[index][AppConstants.RQT_sender_image_url]
                                            .contains('assets/images/')
                                        ? CircleAvatar(
                                            radius: widget.width * 0.09,
                                            backgroundColor: transparent,
                                            backgroundImage: AssetImage(
                                                snapshot.data!.docs[index][
                                                    AppConstants
                                                        .RQT_sender_image_url]))
                                        : CircleAvatar(
                                            // backgroundColor: grey,
                                            radius: widget.width * 0.09,
                                            backgroundColor: transparent,
                                            backgroundImage: NetworkImage(snapshot
                                                    .data!.docs[index]
                                                [AppConstants.RQT_sender_image_url])),
                              )),
                          Positioned(
                            top: 1,
                            right: -8,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: snapshot.data!.docs[index][
                                              AppConstants.RQT_SenderUser_id] ==
                                          snapshot.data!.docs[index]
                                              [AppConstants.RQT_ReceiverUser_id]
                                      ? green
                                      : red,
                                  borderRadius: BorderRadius.circular(
                                      widget.width * 0.06)),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Row(
                                  // crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    // Text(
                                    //   '${getCurrencySymbol(context, appConstants: appConstants )} ',
                                    //   style: textStyleHeading2WithTheme(
                                    //       context, width * 0.5,
                                    //       whiteColor: 1),
                                    // ),
                                    Text(
                                      snapshot.data!.docs[index][AppConstants
                                                  .RQT_SenderUser_id] ==
                                              snapshot.data!.docs[index][
                                                  AppConstants
                                                      .RQT_ReceiverUser_id]
                                          ? '+'
                                          : '-',
                                      style: textStyleHeading2WithTheme(
                                          context, widget.width * 0.8,
                                          whiteColor: 1),
                                    ),
                                    Text(
                                      snapshot.data!.docs[index]
                                          [AppConstants.RQT_amount],
                                      style: textStyleHeading2WithTheme(
                                          context, widget.width * 0.8,
                                          whiteColor: 1),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      // spacing_small,
                      SizedBox(
                        height: 2,
                      ),
                      SizedBox(
                        width: widget.height * 0.065,
                        child: Center(
                          child: Text(
                            "${snapshot.data!.docs[index][AppConstants.RQT_Sender_UserName]}",
                            overflow: TextOverflow.clip,
                            maxLines: 1,
                            style: heading4TextSmall(widget.width),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        // if (snapshot.data!.size == 0) {
        return SizedBox.shrink();
        // }
      },
    );
  }
}
