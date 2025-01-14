import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esys_flutter_share_plus/esys_flutter_share_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:zaki/Constants/Spacing.dart';
import 'package:zaki/Screens/SocialProfileView.dart';

import '../Constants/AppConstants.dart';
import '../Constants/HelperFunctions.dart';
import '../Constants/Styles.dart';
import '../Services/api.dart';
import 'CustomLoadingScreen.dart';
import 'LikeAnimation.dart';
import 'TextHeader.dart';


class CustomFeedCard extends StatefulWidget {
  final QueryDocumentSnapshot? snapshot;
  final bool? needPadding;
  final bool? clickEnabled;
  final String? selectedUserId;
  CustomFeedCard({Key? key, required this.snapshot, this.needPadding, this.clickEnabled, this.selectedUserId}) : super(key: key);

  @override
  State<CustomFeedCard> createState() => _CustomFeedCardState();
}

class _CustomFeedCardState extends State<CustomFeedCard> {
  bool isLikeAnimating = false;
  @override
  Widget build(BuildContext context) {
    var appConstants = Provider.of<AppConstants>(context, listen: true);
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return 
    
    Padding(
      padding: EdgeInsets.only(bottom: widget.needPadding==false?5: 25.0),
      child: Card(
        color: white,
         shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(14),
        //set border radius more than 50% of height and width to make circle
  ),
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 7.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2),
                child: Row(
                  children: [
                    UserSection(
                      userId: widget.snapshot![AppConstants.Social_Sender_user_id],
                      clickEnabled: widget.clickEnabled
                      ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Text(
                        widget.snapshot![AppConstants.Social_transaction_type] ==
                                AppConstants.TAG_IT_Transaction_TYPE_SEND_OR_REQUEST
                            ? 'Paid'
                            : 'Request',
                        style: heading4TextSmall(width),
                      ),
                    ),
                    ///////////////////////////Right Side
                    UserSection(
                      userId: widget.snapshot![AppConstants.Social_receiver_user_id],
                      clickEnabled: widget.clickEnabled
                      ),
                  ],
                ),
              ),
              spacing_medium,
              spacing_small,
              GestureDetector(
                onDoubleTap: () async {
                  ApiServices services = ApiServices();
                  await services.likePost(
                      likes: widget.snapshot![AppConstants.Social_Likes_UserId],
                      uid: appConstants.userRegisteredId,
                      postId: widget.snapshot!.id);
                  setState(() {
                    isLikeAnimating = true;
                  });
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      height: height * 0.24,
                      width: width,
                      decoration: BoxDecoration(
                                // shape: BoxShape.circle,
                                // border: Border.all(color: grey.withValues(alpha:0.5)),
                                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(width * 0.03), bottomRight: Radius.circular(width * 0.03)),
                              ),
                      // color: green,
                      child: widget.snapshot![AppConstants.Social_image_url]
                              .contains('assets/images/')
                          ? Image.asset(
                            widget.snapshot![AppConstants.Social_image_url],
                            fit: BoxFit.fill,
                            // width: width,
                            )
                          : 
                          CachedNetworkImage(
                                          imageUrl: widget.snapshot![AppConstants.Social_image_url],
                                          fit: BoxFit.contain,
                                          placeholder: (context, url) => Center(
                                              child: CustomLoadingScreen(small: true,)),
                                          errorWidget: (context, url, error) =>
                                              Icon(Icons.error),
                                        )
                    ),
                    AnimatedOpacity(
                      duration: const Duration(milliseconds: 200),
                      opacity: isLikeAnimating ? 1 : 0,
                      child: LikeAnimation(
                        isAnimating: isLikeAnimating,
                        child: Icon(
                          Icons.favorite,
                          color: green,
                          size: 100,
                        ),
                        duration: const Duration(
                          milliseconds: 400,
                        ),
                        onEnd: () {
                          setState(() {
                            isLikeAnimating = false;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              if(widget.snapshot![AppConstants.Social_Message_Text].toString().trim().length!=0)
              Column(
                children: [
                  spacing_small,
                  spacing_small,
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
                    child: Text(
                      widget.snapshot![AppConstants.Social_Message_Text],
                      style: heading3TextStyle(width, font: 12),
                      )
                    
                  ),
                  
                ],
              ),
              spacing_medium,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                child: Row(
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // InkWell(
                    //   child: CustomIcon(
                    //   width: width,
                    //   icon: Icons.whatsapp,
                    //   ),
                    // ),
                    // CustomIcon(
                    //   width: width,
                    //   icon: Icons.facebook_outlined,
                    //   ),
                    InkWell(
                      onTap: () async {
                        // showNotification(error: 0, icon: Icons.image, message: widget.snapshot![AppConstants.Social_image_url]);
                        try {
                          if (widget.snapshot![AppConstants.Social_image_url]
                              .contains('assets/images/')) {
                            final ByteData bytes = await rootBundle
                                .load(widget.snapshot![AppConstants.Social_image_url]);
                            await Share.file('Share My Image', 'image.png',
                                bytes.buffer.asUint8List(), 'image/png',
                                text:
                                    '${appConstants.userModel.usaFirstName} ${AppConstants.ZAKI_PAY_SOCILIZE_SHARE_FIRST_TEXT} \n${AppConstants.ZAKI_PAY_SOCILIZE_SHARE_LAST_TEXT}\n ${AppConstants.ZAKI_PAY_APP_LINK}');
                          } else {
                            var request = await HttpClient().getUrl(Uri.parse(
                                widget.snapshot![AppConstants.Social_image_url]));
                            var response = await request.close();
                            Uint8List bytes =
                                await consolidateHttpClientResponseBytes(response);
                            await Share.file(
                                'Share My Image', 'amlog.jpg', bytes, 'image/jpg',
                                text:
                                    '${AppConstants.ZAKI_PAY_SHARED_TEXT} ${widget.snapshot![AppConstants.Social_Message_Text]} \n ${AppConstants.ZAKI_PAY_SHARED_LINK}');
                          }
                        } catch (e) {
                          logMethod(title: 'Exception is:', message: e.toString());
                        }
                        // Share.share(widget.snapshot![AppConstants.Social_image_url], subject: 'Download ZakiPay and Raise Smart Kids', );
                      },
                      child: CustomIcon(
                        width: width,
                        icon: Icons.share,
                        ),
                    ),
                    InkWell(
                      onTap: () async {
                        ApiServices services = ApiServices();
                        await services.likePost(
                            likes: widget.snapshot![AppConstants.Social_Likes_UserId],
                            uid: appConstants.userRegisteredId,
                            postId: widget.snapshot!.id);
                      },
                      child: LikeAnimation(
                        isAnimating: widget.snapshot![AppConstants.Social_Likes_UserId]
                            .contains(appConstants.userRegisteredId),
                        smallLike: true,
                        child: widget.snapshot![AppConstants.Social_Likes_UserId]
                                .contains(appConstants.userRegisteredId)
                            ? CustomIcon(
                      width: width,
                      icon: Icons.favorite,
                      color: green,
                      )
                            : CustomIcon(
                      width: width,
                      icon: Icons.favorite_border,
                      ),
                      ),
                      //   widget.snapshot![AppConstants.Social_Likes_UserId].contains(appConstants.userRegisteredId)?
                      //   Icon(
                      //     Icons.favorite,
                      //     size: width * 0.05,
                      //     color: green,
                      //   ) :
                      //   Icon(
                      //     Icons.favorite_border,
                      //     size: width * 0.05,
                      //     color: green,
                      //   )
                      //   ,
                      // ),
                    ),
                    TextValue3(
                      title:
                          '${widget.snapshot![AppConstants.Social_Likes_UserId].length}',
                    ),
                    const Spacer(),
                    if(appConstants.userRegisteredId == widget.snapshot![AppConstants.Social_Sender_user_id])
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Image.asset(
                            widget.snapshot![AppConstants.Social_Privacy_Code] == 1 ? imageBaseAddress + 'public.png'
                            : widget.snapshot![AppConstants.Social_Privacy_Code] == 2 ? imageBaseAddress + 'friends.png'
                            : widget.snapshot![AppConstants.Social_Privacy_Code] == 3 ? imageBaseAddress +'family.png'
                            : widget.snapshot![AppConstants.Social_Privacy_Code] ==4 ? imageBaseAddress + 'you_me.png'
                             : imageBaseAddress + 'you_me.png',
                            height: 23,
                            width: 18,
                          ),
                        ),
                    Text(
                      widget.snapshot![AppConstants.Social_Privacy_Code] == 1 ? 'Public'
                      : widget.snapshot![AppConstants.Social_Privacy_Code] == 2? 'Friends'
                      : widget.snapshot![AppConstants.Social_Privacy_Code] ==3? 'Family'
                      : 'You & Me',
                     style: heading3TextStyle(width, font: 12),
                    ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CustomIcon extends StatelessWidget {
  const CustomIcon({
    Key? key,
    required this.width,
    required this.icon,
    this.color
  }) : super(key: key);

  final double width;
  final IconData icon;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Icon(
        icon,
        size: width * 0.055,
        color: color!=null?color: grey,
      ),
    );
  }
}

class UserSection extends StatelessWidget {
  const UserSection({Key? key, required this.userId, this.clickEnabled, this.onlyName}) : super(key: key);
  final String? userId;
  final bool? clickEnabled;
  final bool? onlyName;
  

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var appConstants = Provider.of<AppConstants>(context, listen: true);
    // var height = MediaQuery.of(context).size.height;
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection(AppConstants.USER).doc(userId).snapshots(),
      // initialData: initialData,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if(!snapshot.hasData){
          return SizedBox.shrink();
        }
        return
        onlyName==true?
              Text(snapshot.data[AppConstants.USER_user_name]==''? snapshot.data[AppConstants.USER_first_name] :'@ ${snapshot.data[AppConstants.USER_user_name]}',
                      style: heading3TextStyle(width * 0.9),
                      overflow: TextOverflow.ellipsis,
                    ):
         InkWell(
          onTap: (userId==appConstants.userRegisteredId 
          || clickEnabled!=true
          )?null: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>SocialProfileView(selectedUserId: userId,selectedUserImageUrl: snapshot.data[AppConstants.USER_Logo],selectedUserName: snapshot.data[AppConstants.USER_user_name],)));
          },
          child: Column(
            children: [
              
              Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: ClipOval(
                        child: Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: grey.withValues(alpha:0.5)),
                              // borderRadius: BorderRadius.circular(width * 0.03),
                            ),
                          child: CircleAvatar(
                            radius: width * 0.08,
                            backgroundColor: grey,
                            child: snapshot.data[AppConstants.USER_Logo]
                                    .contains('assets/images/')
                                ?  Image.asset(snapshot.data[AppConstants.USER_Logo])
                                : CachedNetworkImage(
                                            imageUrl: snapshot.data[AppConstants.USER_Logo],
                                            fit: BoxFit.cover,
                                            height: 65,
                                            width: 65,
                                            placeholder: (context, url) => Center(
                                                child: CustomLoadingScreen(small: true,)),
                                            errorWidget: (context, url, error) =>
                                                Icon(Icons.error),
                                          )
                          ),
                        ),
                      )
              ),
              // SizedBox(height: height*0.005,),
              Text(snapshot.data[AppConstants.USER_user_name]==''? snapshot.data[AppConstants.USER_first_name] :'@ ${snapshot.data[AppConstants.USER_user_name]}',
                      style: heading4TextSmall(width),
                      overflow: TextOverflow.ellipsis,
                    ),
            ],
          ),
        );
      },
    );
  }
}
