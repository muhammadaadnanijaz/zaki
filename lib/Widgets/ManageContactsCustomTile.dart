import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zaki/Constants/HelperFunctions.dart';
import 'package:zaki/Models/UserModel.dart';
import 'package:zaki/Services/api.dart';
import 'package:zaki/Widgets/CustomLoader.dart';
import '../Constants/AppConstants.dart';
import '../Constants/Styles.dart';
import '../Screens/PayOrRequestScreen.dart';
import 'TextHeader.dart';

class ManageContactCustomTile extends StatefulWidget {
  const ManageContactCustomTile({
    Key? key,
    required this.selectedUserId,
    this.snapshot,
  }) : super(key: key);
  final String selectedUserId;
  final QueryDocumentSnapshot<Object?>? snapshot;

  @override
  State<ManageContactCustomTile> createState() =>
      _ManageContactCustomTileState();
}

class _ManageContactCustomTileState extends State<ManageContactCustomTile> {
  ApiServices services = ApiServices();
  String imageUrl = '';
  String firstNmae = '';
  String lastName = '';
  String userName = '';
  String userId = '';
  String parentId = '';
  int subscriptionValue = 0;
  String userType = '';

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
        userName = (userData.data()![AppConstants.USER_user_name] == '' ||
                userData.data()![AppConstants.USER_user_name] == null)
            ? userData.data()![AppConstants.USER_first_name]
            : userData.data()![AppConstants.USER_user_name];
        parentId = userData.data()![AppConstants.USER_Family_Id];
        userType = userData.data()![AppConstants.USER_UserType];
        subscriptionValue =
            userData.data()![AppConstants.USER_SubscriptionValue] ?? 0;
        // (snapshot.data!.docs[index][AppConstants.USER_Family_Id]!=appConstants.userModel.userFamilyId && (snapshot.data!.docs[index][AppConstants.USER_SubscriptionValue]==0 || snapshot.data!.docs[index][AppConstants.USER_SubscriptionValue]==null))?
        //                                               SizedBox.shrink():
        userId = userData.id;
        if (mounted) setState(() {});
      }
      // String number = '';
      // var appConstants = Provider.of<AppConstants>(context, listen: false);
    });
  }

  @override
  Widget build(BuildContext context) {
    var appConstants = Provider.of<AppConstants>(context, listen: true);
    // var height = MediaQuery.of(context).size.height;
    // var width = MediaQuery.of(context).size.width;
    return ListTile(
      // dense: true,
      contentPadding: EdgeInsets.zero,
      leading: ClipOval(
        child: Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(shape: BoxShape.circle, color: grey.withOpacity(0.2)),
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
                        placeholder: (context, url) => CustomLoader(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      )),
        ),
      ),
      title: TextValue2(
        title: (firstNmae == '' && lastName == '')
            ? '${widget.snapshot![AppConstants.USER_first_name]}'
            : '$firstNmae $lastName',
      ),
      subtitle: TextValue3(
        title: userName == ''
            ? '${widget.snapshot![AppConstants.USER_contact_invitedphone]}'
            : '@ $userName',
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          (checkUserValue(
                  appConstants: appConstants,
                  parentId: parentId,
                  subscriptionValue: subscriptionValue))
              ?
              // (parentId!=appConstants.userModel.userFamilyId && (subscriptionValue==0 || subscriptionValue==null))?
              SizedBox.shrink()
              : (parentId == appConstants.userModel.userFamilyId &&
                      subscriptionValue < 2)
                  ? SizedBox.shrink()
                  : InkWell(
                      onTap: () async {
                        if (subscriptionValue == 0) {
                          appConstants
                              .updateCurrentUserIdForBottomSheet(userId);
                          await checkUserSubscriptionValue(
                              appConstants, context,
                              subScriptionValue: subscriptionValue);
                          return;
                        }
                        appConstants.updateCurrentUserIdForBottomSheet(
                            appConstants.userRegisteredId);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PayOrRequestScreen(
                                      fromManageContactPhoneNumber:
                                          widget.snapshot![AppConstants
                                              .USER_contact_invitedphone],
                                      selectedUserModel: UserModel(
                                          usaLogo: imageUrl,
                                          usaFirstName: firstNmae,
                                          usaLastName: lastName,
                                          usaUserName: userName,
                                          usaUserId: userId),
                                    )));
                      },
                      child: Image.asset(
                        imageBaseAddress + 'money_send_contact.png',
                        // height: height * 0.02,
                      ),
                    ),
          InkWell(
            onTap: () async {
              services.updateFriendStatus(
                  friendDocId: widget.snapshot!.id,
                  status: widget.snapshot![AppConstants.USER_IsFavorite] == true
                      ? false
                      : true,
                  userId: widget.selectedUserId);
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Icon(
                widget.snapshot![AppConstants.USER_IsFavorite]
                    ? Icons.favorite
                    : Icons.favorite_border,
                color:
                    widget.snapshot![AppConstants.USER_IsFavorite] ? red : grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
