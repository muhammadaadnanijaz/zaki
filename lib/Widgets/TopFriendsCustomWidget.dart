import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zaki/Constants/HelperFunctions.dart';
import 'package:zaki/Widgets/CustomLoader.dart';
import '../Constants/AppConstants.dart';
import '../Constants/Styles.dart';
import '../Models/UserModel.dart';
import '../Screens/PayOrRequestScreen.dart';
import '../Services/api.dart';
import 'TextHeader.dart';

class TopFriendsCustomWidget extends StatefulWidget {
  const TopFriendsCustomWidget(
      {Key? key,
      required this.selectedIndexTopFriends,
      required this.width,
      required this.index,
      required this.snapshot,
      this.enableOnTap})
      : super(key: key);

  final int selectedIndexTopFriends;
  final double width;
  final int index;
  final QueryDocumentSnapshot<Object?>? snapshot;
  final bool? enableOnTap;

  @override
  State<TopFriendsCustomWidget> createState() => _TopFriendsCustomWidgetState();
}

class _TopFriendsCustomWidgetState extends State<TopFriendsCustomWidget> {
  ApiServices services = ApiServices();
  String imageUrl = '';
  String firstNmae = '';
  String lastName = '';
  String? userName = '';
  String userId = '';
  int subscriptionValue = 0;
  

  @override
  void initState() {
    userData();
    super.initState();
  }

  userData() {
    Future.delayed(Duration.zero, () async {
      DocumentSnapshot<Map<String, dynamic>>? userData = await services
          .getUserDataFromId(id: widget.snapshot![AppConstants.USER_UserID]);
      if (userData != null) {
        imageUrl = userData.data()![AppConstants.USER_Logo];
        firstNmae = userData.data()![AppConstants.USER_first_name];
        lastName = userData.data()![AppConstants.USER_last_name];
        userName = userData.data()![AppConstants.USER_user_name];
        subscriptionValue =
            userData.data()![AppConstants.USER_SubscriptionValue];
        userId = userData.id;
        // (newSnapShot[AppConstants.USER_SubscriptionValue]<2 || newSnapShot[AppConstants.USER_SubscriptionValue]==null
        if (mounted) setState(() {});
      }
      // String number = '';
      // var appConstants = Provider.of<AppConstants>(context, listen: false);
    });
  }

  @override
  Widget build(BuildContext context) {
    var appConstants = Provider.of<AppConstants>(context, listen: true);
    return subscriptionValue < 2
        ? const SizedBox.shrink()
        : InkWell(
            onTap: widget.enableOnTap == null
                ? null
                : () async {
                    appConstants.updateCurrentUserIdForBottomSheet(userId);
                    bool screenNotOpen =
                        await checkUserSubscriptionValue(appConstants, context);
                    if (screenNotOpen == false) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PayOrRequestScreen(
                                    fromManageContactPhoneNumber: widget
                                            .snapshot![
                                        AppConstants.USER_contact_invitedphone],
                                    selectedUserModel: UserModel(
                                        usaLogo: imageUrl,
                                        usaFirstName: firstNmae,
                                        usaLastName: lastName,
                                        usaUserName: userName == ''
                                            ? firstNmae
                                            : '@ $userName',
                                        usaUserId: userId),
                                  )
                                  )
                                  );
                    }
                  },
            child: Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: Column(
                children: [
                  ClipOval(
                    child: Container(
                      height: 70,
                      width: 70,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          // color: grey,
                          border: Border.all(color: grey)),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: imageUrl == ''
                            ? SizedBox()
                            : imageUrl.contains('assets/images/')
                                ? CircleAvatar(
                                    backgroundColor: transparent,
                                    child: Image.asset(imageUrl))
                                : CircleAvatar(
                                    backgroundColor: transparent,
                                    child: CachedNetworkImage(
                                      imageUrl: imageUrl,
                                      placeholder: (context, url) =>
                                          CustomLoader(),
                                      errorWidget: (context, url, error) =>
                                          Icon(Icons.error),
                                    )),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  TextValue3(
                    title: (userName == null || userName == '')
                        ? firstNmae
                        : '@ $userName',
                  ),
                ],
              ),
            ),
          );
  }
}
