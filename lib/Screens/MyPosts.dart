import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zaki/Constants/HelperFunctions.dart';
import 'package:zaki/Widgets/CustomLoader.dart';
import '../Constants/AppConstants.dart';
import '../Constants/Styles.dart';
import '../Services/api.dart';
import '../Widgets/CustomFeedCard.dart';
import '../Widgets/ZakiCircularButton.dart';
import 'InviteMainScreen.dart';

class MyPosts extends StatefulWidget {
  final String? selectedUserId;
  final String? postId;
  final bool? clickEnabled;
  final bool? fromProfile;

  const MyPosts(
      {Key? key,
      this.selectedUserId,
      this.postId,
      this.clickEnabled,
      this.fromProfile})
      : super(key: key);

  @override
  State<MyPosts> createState() => _MyPostsState();
}

class _MyPostsState extends State<MyPosts> {
  //  Stream<QuerySnapshot>? requestedMoneyActivities;
  // Stream<QuerySnapshot>? payMoneyActivities;
  Stream<QuerySnapshot>? socialFeed;
  Future<QuerySnapshot>? socialFeedFuture;
  // if( element[AppConstants.Social_Sender_user_id]==userId  ||  element[AppConstants.Social_receiver_user_id]==userId)
  // Stream<QuerySnapshot>? specficSocialFeed;
  // final _controller=ItemScrollController();

  @override
  void initState() {
    super.initState();
    getUserKids();
  }

  getUserKids() {
    Future.delayed(Duration.zero, () {
      var appConstants = Provider.of<AppConstants>(context, listen: false);
      // socialFeedFuture = ApiServices().getMySocialFeedFuture(userId: widget.selectedUserId!=null ? widget.selectedUserId: appConstants.userRegisteredId);
      socialFeed = ApiServices().getMySocialFeeds(
          userId: widget.selectedUserId != null
              ? widget.selectedUserId
              : appConstants.userRegisteredId);
      // if(widget.postId!=null)

      setState(() {});
      logMethod(title: 'POST ID', message: widget.postId ?? '');
      // if(widget.postId!=null){
      //   customFeedDialouge(socialFeed: specficSocialFeed);
      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    // sdjasdsa
    var appConstants = Provider.of<AppConstants>(context, listen: true);
    // var height = MediaQuery.of(context).size.height;
    // var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.95),
      body: Column(
        children: [
          // Expanded(
          //   child: FutureBuilder(
          //     future: socialFeedFuture,
          //      builder: (BuildContext context,
          //             AsyncSnapshot<QuerySnapshot> snapshot) {
          //               snapshot.data.docs
          //             })),
          Expanded(
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
                      if (snapshot.data!.size == 0) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: ZakiCicularButton(
                                title: 'Sync Contacts',
                                width: 50,
                                backGroundColor: white,
                                icon: Icons.sync_outlined,
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const InviteMainScreen(
                                          fromHomeScreen: true,
                                        ),
                                      ));
                                },
                              ),
                            ),
                          ],
                        );
                      }
                      return ListView.builder(
                        itemCount: snapshot.data!.size,
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        // separatorBuilder: (context, index) => (snapshot.data!.docs[index][AppConstants.Social_Sharedwith_Users_List].length!=0 && !snapshot.data!.docs[index][AppConstants.Social_Sharedwith_Users_List].contains(appConstants.userRegisteredId))?
                        //   SizedBox.shrink(): Divider(color: black),
                        itemBuilder: (BuildContext context, int index) {
                          return (snapshot.data!.docs[index][AppConstants.Social_Sharedwith_Users_List].length != 0 &&
                                  !snapshot.data!.docs[index][AppConstants.Social_Sharedwith_Users_List]
                                      .contains(widget.selectedUserId != null
                                          ? widget.selectedUserId
                                          : appConstants.userRegisteredId))
                              ? SizedBox.shrink()
                              : (snapshot.data!.docs[index][AppConstants.Social_Sender_user_id] == (widget.selectedUserId != null ? widget.selectedUserId : appConstants.userRegisteredId) ||
                                          snapshot.data!.docs[index][AppConstants.Social_receiver_user_id] ==
                                              (widget.selectedUserId != null
                                                  ? widget.selectedUserId
                                                  : appConstants
                                                      .userRegisteredId)) ||
                                      (widget.selectedUserId != null &&
                                          (snapshot.data!.docs[index][AppConstants.Social_Sender_user_id] == widget.selectedUserId ||
                                              snapshot.data!.docs[index][AppConstants.Social_receiver_user_id] ==
                                                  widget.selectedUserId))
                                  ? CustomFeedCard(
                                      snapshot: snapshot.data!.docs[index],
                                      clickEnabled: widget.clickEnabled,
                                      selectedUserId: widget.selectedUserId)
                                  : SizedBox.shrink();
                          // Text(snapshot.data!.docs[index][AppConstants.Social_amount].toString());
                        },
                      );
                    }),
          ),
        ],
      ),
    );
  }
}
