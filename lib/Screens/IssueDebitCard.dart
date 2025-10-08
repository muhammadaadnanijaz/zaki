import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zaki/Constants/CheckInternetConnections.dart';
import 'package:zaki/Constants/HelperFunctions.dart';
import 'package:zaki/Constants/Spacing.dart';
import 'package:zaki/Models/CardInformationModel.dart';
import 'package:zaki/Screens/AddMembersWorkFlow.dart';
import 'package:zaki/Screens/IssueAndManageCards.dart';
import 'package:zaki/Services/CreaditCardApis.dart';
// import 'package:zaki/Screens/IssueDebitCardFields.dart';
// import 'package:zaki/Screens/SecretDebitCard.dart';
// import 'package:zaki/Screens/RequestDebitCard.dart';
import 'package:zaki/Widgets/CustomLoader.dart';
import 'package:zaki/Screens/SpendingLimit.dart';
import 'package:zaki/Widgets/FloatingActionButton.dart';
import 'package:zaki/Widgets/TextHeader.dart';
import 'package:zaki/Widgets/ZakiPrimaryButton.dart';
// import 'package:zaki/Widgets/CustomLoader.dart';
import '../Constants/AppConstants.dart';
import '../Constants/Styles.dart';
import '../Models/CardBackgroundImage.dart';
import '../Services/api.dart';
import '../Widgets/AppBars/AppBar.dart';
import '../Widgets/CustomConfermationScreen.dart';
import '../Widgets/CustomSizedBox.dart';
import '../Widgets/UnSelectedKidsWidget.dart';
import 'ActivateCard.dart';

class IssueDebitCard extends StatefulWidget {
  const IssueDebitCard({Key? key}) : super(key: key);

  @override
  _IssueDebitCardState createState() => _IssueDebitCardState();
}

class _IssueDebitCardState extends State<IssueDebitCard> {
  Stream<QuerySnapshot>? requestedMoneyActivities;
  Stream<QuerySnapshot>? userKids;
  int selectedIndex = -1;
  dynamic cardAlreadyExist = false;
  bool loading = true;
  bool cardActive = true;
  String selectedUserId = '';
  String selectedUserType = '';
  final formGlobalKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final ssnController = TextEditingController();
  final zipCodeController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final streetAddressController = TextEditingController();
  final appartOrSuitController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      var appConstants = Provider.of<AppConstants>(context, listen: false);

      bool screenNotOpen =
          await checkUserSubscriptionValue(appConstants, context);
      logMethod(title: 'Data from', message: screenNotOpen.toString());
      if (screenNotOpen == true) {
        Navigator.pop(context);
      } else {
        getUserKids(appConstants);
      }
    });
    super.initState();
  }

  getUserKids(AppConstants appConstants) async {
    // Future.delayed(const Duration(milliseconds: 200), () {
    // var appConstants = Provider.of<AppConstants>(context, listen: false);
    // requestedMoneyActivities = ApiServices().getRequestedMoney(
    //     appConstants.userRegisteredId,
    //     collectionName: 'Requested');
    userKids = ApiServices().fetchUserKids(
        appConstants.userModel.seeKids == true
            ? appConstants.userModel.userFamilyId??""
            : appConstants.userRegisteredId,
        currentUserId: appConstants.userRegisteredId);
    appConstants.updateDateOfBirth('dd / mm / yyyy');
    selectedUserId = appConstants.userRegisteredId;
    await userCardInfo(
        appConstants.userRegisteredId, appConstants.userModel.userFamilyId??"");
    loading = false;
    selectedUserType = appConstants.userModel.usaUserType.toString();
    setState(() {});
    // });
  }

  userCardInfo(String seletedUser, String parentId) async {
    ApiServices apiServices = ApiServices();
    dynamic cardExist =
        await apiServices.checkCardExist(parentId: parentId, id: seletedUser);
    if(cardExist!=false){
      cardActive = cardExist.data()[AppConstants.ICard_cardStatus];
    }
    setState(() {
      cardAlreadyExist = cardExist;
      logMethod(title: 'Card exist', message: '${cardAlreadyExist.toString()} and Card active value:$cardActive');
    });
  }

  void setSelectedUserData(
      {String? firstName,
      String? lastName,
      String? dateOfBirth,
      String? gouvernmentId,
      String? phoneNumber}) {
    var appConstants = Provider.of<AppConstants>(context, listen: false);
    appConstants.updateDateOfBirth(dateOfBirth!);
    firstNameController.text = firstName ?? '';
    lastNameController.text = lastName ?? '';
    phoneNumberController.text = phoneNumber ?? '';
  }

  @override
  Widget build(BuildContext context) {
    var appConstants = Provider.of<AppConstants>(context, listen: true);
    var internet = Provider.of<CheckInternet>(context, listen: true);
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      floatingActionButton: CustomFloadtingActionButton(),
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Form(
                key: formGlobalKey,
                child: Column(
                  children: [
                    Padding(
                      padding: getCustomPadding(),
                      child: Column(
                        children: [
                          appBarHeader_005(
                              width: width,
                              height: height,
                              context: context,
                              appBarTitle: 'Manage Debit Cards',
                              backArrow: true),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        loading == true
                            ? Center(
                                child: CustomLoader(), 
                              )
                            : appConstants.userModel.usaUserType == "Kid"
                                ? cardAlreadyExist != false
                                    ? Padding(
                                        padding: getCustomPadding(),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              
                                          children: [
                                            cardAlreadyExist.data()[AppConstants
                                                        .ICard_physical_card] ==
                                                    true
                                                ? Center(
                                                    child: CarouselSlider(
                                                      options: CarouselOptions(
                                                        height: height * 0.22,
                                                        autoPlay: false,
                                                        enlargeCenterPage: true,
                                                        enableInfiniteScroll:
                                                            false,
                                                        disableCenter: true,
                                                        aspectRatio: 5,
                                                        scrollPhysics:
                                                            const BouncingScrollPhysics(),
                                                        autoPlayAnimationDuration:
                                                            const Duration(
                                                                milliseconds:
                                                                    300),
                                                      ),
                                                      items: [1, 2].map((i) {
                                                        return Builder(
                                                          builder: (BuildContext
                                                              context) {
                                                            return InkWell(
                                                                onTap:
                                                                    () async {
                                                                  String?
                                                                      cardAssigned =
                                                                      await Navigator.push(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                              builder: (context) => CardBackGroundImage(selectedCardId: selectedUserId, previousImage: cardAlreadyExist.data()[AppConstants.ICard_backGroundImage])));
                                                                  if (cardAssigned ==
                                                                      "success") {
                                                                    ApiServices
                                                                        apiServices =
                                                                        ApiServices();
                                                                    dynamic cardExist = await apiServices.checkCardExist(
                                                                        parentId: appConstants
                                                                            .userModel
                                                                            .userFamilyId!,
                                                                        id: selectedUserId);
                                                                    setState(
                                                                        () {
                                                                      cardAlreadyExist =
                                                                          cardExist;
                                                                    });
                                                                  }
                                                                },
                                                                child: CreaditCard(
                                                                    width,
                                                                    appConstants,
                                                                    height,
                                                                    snapshot:
                                                                        cardAlreadyExist
                                                                            .data()));
                                                          },
                                                        );
                                                      }).toList(),
                                                    ),
                                                  )
                                                : Center(
                                                  child: Stack(
                                                    children: [
                                                      
                                                      CreaditCard(
                                                          width, appConstants, height,
                                                          snapshot: cardAlreadyExist
                                                              .data()),
                                                      if(cardActive==false)
                                                      InActivteCard(),
                                                    ],
                                                  ),
                                                ),
                                            spacing_medium,
                                            TextHeader1(
                                              title: 'Card Settings',
                                            ),
                                            // if(selectedUserId!=appConstants.userRegisteredId && appConstants.userModel.usaUserType!=AppConstants.USER_TYPE_KID)
                                            // (appConstants.userModel.usaUserType==AppConstants.USER_TYPE_SINGLE || appConstants.userModel.usaUserType==AppConstants.USER_TYPE_PARENT)?
                                            (selectedUserType ==
                                                        AppConstants
                                                            .USER_TYPE_SINGLE ||
                                                    selectedUserType ==
                                                        AppConstants
                                                            .USER_TYPE_PARENT)
                                                ? const SizedBox.shrink()
                                                : Column(
                                                    children: [
                                                      spacing_medium,
                                                      ManageDebitCardTile(
                                                        imageUrl:
                                                            'manage_spend_limit',
                                                        title:
                                                            "Manage Spend Limits",
                                                        onTap: () {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (context) =>
                                                                      SpendingLimit(
                                                                          selectedId:
                                                                              selectedUserId)));
                                                        },
                                                      ),
                                                    ],
                                                  ),

                                            spacing_medium,
                                            ManageDebitCardTile(
                                                imageUrl: 'activate_inactivate',
                                                title: "Activate / Inactivate",
                                                onTap: () async {
                                                  ApiServices apiServices =
                                                      ApiServices();
                                                  dynamic cardExist =
                                                      await apiServices.checkCardExist(
                                                          parentId: appConstants
                                                              .userModel
                                                              .userFamilyId!,
                                                          id: selectedUserId);
                                                  setState(() {
                                                    cardAlreadyExist =
                                                        cardExist;
                                                  });
                                                  appConstants
                                                      .updateForCardLockStatus(
                                                          from: false);
                                                  var response = await Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              ActivateCard(
                                                                  snapShot: 
                                                                      cardAlreadyExist,
                                                                  selectedUserId:
                                                                      selectedUserId)));
                                                  logMethod(
                                                      title:
                                                          'PIN Code  match Status:',
                                                      message:
                                                          response ?? 'Not');
                                                  if (response != null) {
                                                    ApiServices apiServices =
                                                        ApiServices();
                                                    await apiServices.updateCardStatus(
                                                        id: cardAlreadyExist.id,
                                                        parentId: appConstants
                                                            .userRegisteredId,
                                                        status: cardAlreadyExist
                                                                    .data()[
                                                                AppConstants
                                                                    .ICard_cardStatus] =
                                                            !cardAlreadyExist[
                                                                AppConstants
                                                                    .ICard_cardStatus]);
                                                    dynamic cardExist =
                                                        await apiServices.checkCardExist(
                                                            parentId: appConstants
                                                                .userModel
                                                                .userFamilyId!,
                                                            id: selectedUserId);
                                                    setState(() {
                                                      cardAlreadyExist =
                                                          cardExist;
                                                    });
                                                  }
                                                }),
                                            spacing_medium,
                                            ManageDebitCardTile(
                                              imageUrl: 'card_info',
                                              title: "See Card Info",
                                              onTap: () async{
                                               CardInformationModel cardInfoModel = await CreaditCardApi().showCardInformation(cardToken: cardAlreadyExist.data()[AppConstants.ICard_Token]);
                                                cardInformation(
                                                    context,
                                                    width,
                                                    height,
                                                    '${cardAlreadyExist.data()[AppConstants.ICard_firstName]} ${cardAlreadyExist.data()[AppConstants.ICard_lastName]}',
                                                    cardInfoModel: cardInfoModel
                                                    );
                                              },
                                            ),
                                            //  spacing_large,
                                            //  Row(
                                            //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            //    children: [
                                            //      WalletCustomWidget(
                                            //       width: width,
                                            //       title: 'Add To',
                                            //       subTitle: 'Apple Wallet',
                                            //       imageUrl: 'add_to_apple',
                                            //       ),
                                            //       WalletCustomWidget(
                                            //       width: width,
                                            //       title: 'Add To',
                                            //       subTitle: 'Google Wallet',
                                            //       imageUrl: 'add_to_google',
                                            //       ),
                                            //    ],
                                            //  ),
                                            //  spacing_medium,
                                            //  Center(
                                            //    child: InkWell(
                                            //     onTap: (){
                                            //       Navigator.push(context,
                                            //       MaterialPageRoute(
                                            //           builder: (context) => const SecretDebitCard())
                                            //           );
                                            //     },
                                            //      child: Text(
                                            //       'Secret Debit Card Test Screen',
                                            //       style: heading3TextStyle(width),
                                            //       ),
                                            //    ),
                                            //  )
                                            //   if (cardAlreadyExist.data()[
                                            //           AppConstants
                                            //               .ICard_physical_card] ==
                                            //       true)
                                            //     Column(
                                            //       crossAxisAlignment:
                                            //           CrossAxisAlignment.start,
                                            //       children: [
                                            //         CustomSizedBox(
                                            //           height: height,
                                            //         ),
                                            //         TextHeader1(
                                            //           title:
                                            //               'Physical Card Settings',
                                            //         ),
                                            //         spacing_medium,
                                            //         ManageDebitCardTile(
                                            //           title: "Lock Card",
                                            //           onTap: () {},
                                            //         ),
                                            //         spacing_medium,
                                            //         ManageDebitCardTile(
                                            //           title: "See Card Info",
                                            //           onTap: () {},
                                            //         ),
                                            //       spacing_medium
                                            //       ],
                                            //     )
                                          ],
                                        ),
                                      )
                                    : Padding(
                                        padding: getCustomPadding(),
                                        child: Column(
                                          children: [
                                            // spacing_X_large,
                                            Image.asset(imageBaseAddress +
                                                'no_card_assigned.png'),
                                            // spacing_X_large,
                                            Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.blueAccent
                                                      .withValues(alpha:0.1),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          14)),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(14.0),
                                                child: Text(
                                                  'Oh Oh...Your parents did not issue \nyou a  Debit Card Yet! 😢',
                                                  style: heading1TextStyle(
                                                      context, width),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                            spacing_large,
                                            ZakiPrimaryButton(
                                              title: 'Ask Them Now!',
                                              width: width,
                                              onPressed: internet.status ==
                                                      AppConstants
                                                          .INTERNET_STATUS_NOT_CONNECTED
                                                  ? null
                                                  : () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  CustomConfermationScreen(
                                                                    title:
                                                                        'Parent Has Been Informed!',
                                                                    // imageUrl: selectedKidImageUrl,
                                                                  )));
                                                    },
                                            )
                                          ],
                                        ),
                                      )
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ///////Todo Logic
                                      if (appConstants.userModel.usaUserType ==
                                          AppConstants.USER_TYPE_PARENT)
                                        Container(
                                          color: green.withValues(alpha:0.05),
                                          width: width,
                                          child: Padding(
                                            padding: getCustomPadding(),
                                            child: SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              physics:
                                                  const BouncingScrollPhysics(),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    height: height * 0.127,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              0.0),
                                                      child: InkWell(
                                                        onTap: () async {
                                                          if (selectedUserId !=
                                                              appConstants
                                                                  .userRegisteredId) {
                                                            setState(() {
                                                              selectedIndex =
                                                                  -1;
                                                              selectedUserId =
                                                                  appConstants
                                                                      .userRegisteredId;
                                                              selectedUserType =
                                                                  appConstants
                                                                      .userModel
                                                                      .usaUserType
                                                                      .toString();
                                                            });
                                                            setSelectedUserData(
                                                              dateOfBirth:
                                                                  appConstants
                                                                      .userModel
                                                                      .usaDob,
                                                              firstName:
                                                                  appConstants
                                                                      .userModel
                                                                      .usaLegalFirstName,
                                                              gouvernmentId: '',
                                                              lastName: appConstants
                                                                  .userModel
                                                                  .usaLegalLastName,
                                                              phoneNumber:
                                                                  appConstants
                                                                      .userModel
                                                                      .usaPhoneNumber,
                                                            );
                                                            ApiServices
                                                                apiServices =
                                                                ApiServices();
                                                            // userCardInfo(appConstants.userRegisteredId, appConstants.userModel.userFamilyId!);
                                                            dynamic cardExist = await apiServices.checkCardExist(
                                                                parentId: appConstants
                                                                    .userModel
                                                                    .userFamilyId??"",
                                                                id: appConstants
                                                                    .userRegisteredId);
                                                            if(cardExist!=false){
                                                              cardActive = cardExist.data()[AppConstants.ICard_cardStatus];
                                                            }
                                                            setState(() {
                                                              cardAlreadyExist =
                                                                  cardExist;
                                                            });
                                                            logMethod(title: 'Card exist', message: '${cardAlreadyExist.toString()} and Card active value:$cardActive');
                                                          }
                                                        },
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Stack(
                                                              children: [
                                                                Container(
                                                                  height: 70,
                                                                  width: 70,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    shape: BoxShape
                                                                        .circle,
                                                                    color:
                                                                        transparent,
                                                                    border: Border.all(
                                                                        width: selectedIndex ==
                                                                                -1
                                                                            ? 2
                                                                            : 0,
                                                                        color: selectedIndex ==
                                                                                -1
                                                                            ? green
                                                                            : transparent),
                                                                    boxShadow:
                                                                        selectedIndex !=
                                                                                -1
                                                                            ? null
                                                                            : [
                                                                                customBoxShadow(color: green)
                                                                              ],
                                                                  ),
                                                                  child: Padding(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              0.0),
                                                                      child: userImage(
                                                                          imageUrl: appConstants
                                                                              .userModel
                                                                              .usaLogo!,
                                                                          userType: appConstants
                                                                              .userModel
                                                                              .usaUserType,
                                                                          width: width *
                                                                              0.6,
                                                                          gender: appConstants
                                                                              .userModel
                                                                              .usaGender)),
                                                                ),
                                                                if (selectedIndex !=
                                                                    -1)
                                                                  UnSelectedKidsWidget()
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: 5,
                                                            ),
                                                            Text(
                                                              '@ ' +
                                                                  appConstants
                                                                      .userModel
                                                                      .usaUserName
                                                                      .toString(),
                                                              // overflow: TextOverflow.clip,
                                                              // maxLines: 1,
                                                              style:
                                                                  heading5TextSmall(
                                                                      width),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 12,
                                                  ),
                                                  userKids == null
                                                      ? const SizedBox()
                                                      : Container(
                                                          // color: Color(0XFFF9FFF9),
                                                          height:
                                                              height * 0.127,
                                                          // width: width,
                                                          child: StreamBuilder<
                                                              QuerySnapshot>(
                                                            stream: userKids,
                                                            builder: (BuildContext
                                                                    context,
                                                                AsyncSnapshot<
                                                                        QuerySnapshot>
                                                                    snapshot) {
                                                              if (snapshot
                                                                  .hasError) {
                                                                return const Text(
                                                                    'Ooops...Something went wrong :(');
                                                              }

                                                              if (snapshot
                                                                      .connectionState ==
                                                                  ConnectionState
                                                                      .waiting) {
                                                                return Center(
                                                                    child:
                                                                        CustomLoader(
                                                                  // color: green,
                                                                ));
                                                              }
                                                              if (snapshot.data!
                                                                      .size ==
                                                                  0) {
                                                                   
                                                                  }
                                                              //snapshot.data!.docs[index] ['USA_first_name']
                                                              return ListView
                                                                  .builder(
                                                                itemCount:
                                                                    snapshot
                                                                        .data!
                                                                        .docs
                                                                        .length,
                                                                physics:
                                                                    const NeverScrollableScrollPhysics(),
                                                                shrinkWrap:
                                                                    true,
                                                                scrollDirection:
                                                                    Axis.horizontal,
                                                                itemBuilder:
                                                                    (BuildContext
                                                                            context,
                                                                        int index) {
                                                                  // print(snapshot.data!.docs[index] ['USA_first_name']);
                                                                  return
                                                                      // snapshot.data!.docs[index][
                                                                      //               AppConstants
                                                                      //                   .NewMember_isEnabled] ==
                                                                      //           false ||
                                                                      appConstants.userRegisteredId ==
                                                                              snapshot.data!.docs[index].id
                                                                          ? const SizedBox.shrink()
                                                                          : InkWell(
                                                                              onTap: () async {
                                                                                if (selectedUserId != snapshot.data!.docs[index].id) {
                                                                                  setState(() {
                                                                                    selectedIndex = index;
                                                                                    selectedUserId = snapshot.data!.docs[index].id;
                                                                                    selectedUserType = snapshot.data!.docs[index][AppConstants.USER_UserType];
                                                                                    // selectedKidId = snapshot.data!.docs[index].id;
                                                                                  });
                                                                                  setSelectedUserData(
                                                                                    dateOfBirth: snapshot.data!.docs[index][AppConstants.USER_dob],
                                                                                    firstName: snapshot.data!.docs[index][AppConstants.USER_legalfirst_name] ?? '',
                                                                                    gouvernmentId: '',
                                                                                    lastName: snapshot.data!.docs[index][AppConstants.USER_legallast_name],
                                                                                    phoneNumber: snapshot.data!.docs[index][AppConstants.USER_phone_number],
                                                                                  );
                                                                                }

                                                                                ApiServices apiServices = ApiServices();
                                                                                dynamic cardExist = await apiServices.checkCardExist(parentId: appConstants.userModel.userFamilyId??appConstants.userRegisteredId, id: snapshot.data!.docs[index].id);
                                                                                if(cardExist!=false){
                                                                                    cardActive = cardExist.data()[AppConstants.ICard_cardStatus];
                                                                                  }
                                                                                setState(() {
                                                                                  cardAlreadyExist = cardExist;
                                                                                });
                                                                                logMethod(title: 'Card InfoUpper', message: 'Card info');
                                                                                logMethod(title: 'Card exist', message: '${cardAlreadyExist.toString()} and Card active value:$cardActive');
                                                                              },
                                                                              child: Padding(
                                                                                padding: const EdgeInsets.only(right: 12.0),
                                                                                child: Column(
                                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                                  children: [
                                                                                    Stack(
                                                                                      children: [
                                                                                        Container(
                                                                                          height: 70,
                                                                                          width: 70,
                                                                                          decoration: BoxDecoration(
                                                                                            shape: BoxShape.circle,
                                                                                            color: transparent,
                                                                                            border: Border.all(width: selectedIndex == index ? 2 : 0, color: selectedIndex == index ? green : transparent),
                                                                                            boxShadow: selectedIndex != index ? null : [customBoxShadow(color: green)],
                                                                                          ),
                                                                                          child: Padding(
                                                                                              padding: const EdgeInsets.all(0.0),
                                                                                              child: userImage(
                                                                                                imageUrl: snapshot.data!.docs[index][AppConstants.USER_Logo],
                                                                                                userType: snapshot.data!.docs[index][AppConstants.USER_UserType],
                                                                                                width: width,
                                                                                                gender: snapshot.data!.docs[index][AppConstants.USER_gender],
                                                                                              )),
                                                                                        ),
                                                                                        if (selectedIndex != index) UnSelectedKidsWidget()
                                                                                      ],
                                                                                    ),
                                                                                    SizedBox(
                                                                                      height: 5,
                                                                                    ),
                                                                                    SizedBox(
                                                                                      // width: height * 0.065,
                                                                                      child: Center(
                                                                                        child: Text(
                                                                                          (snapshot.data!.docs[index][AppConstants.USER_user_name] == null || snapshot.data!.docs[index][AppConstants.USER_user_name] == '') ? snapshot.data!.docs[index][AppConstants.USER_first_name] : '@ ' + snapshot.data!.docs[index][AppConstants.USER_user_name],
                                                                                          overflow: TextOverflow.fade,
                                                                                          maxLines: 1,
                                                                                          style: heading5TextSmall(width),
                                                                                        ),
                                                                                      ),
                                                                                    )
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            );
                                                                },
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      Padding(
                                        padding: getCustomPadding(),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            ///Todo Logic end
                                            spacing_medium,
                                            cardAlreadyExist == false
                                                ? Column(
                                                    children: [
                                                      // spacing_large,
                                                      Image.asset(imageBaseAddress +
                                                          "no_card_assigned.png"),
                                                      spacing_large,
                                                      ZakiPrimaryButton(
                                                        title:
                                                            'Issue a Debit Card',
                                                        width: width,
                                                        onPressed: internet
                                                                    .status ==
                                                                AppConstants
                                                                    .INTERNET_STATUS_NOT_CONNECTED
                                                            ? null
                                                            : () async {
                                                                bool
                                                                    screenNotOpen =
                                                                    await checkUserSubscriptionValue(
                                                                        appConstants,
                                                                        context);
                                                                logMethod(
                                                                    title:
                                                                        'Data from Pay+',
                                                                    message:
                                                                        screenNotOpen
                                                                            .toString());
                                                                if (screenNotOpen ==
                                                                    true) {
                                                                  Navigator.pop(
                                                                      context);
                                                                } else {
                                                                  if (appConstants
                                                                              .userModel
                                                                              .userFamilyId !=
                                                                          appConstants
                                                                              .userModel
                                                                              .usaUserId &&
                                                                      appConstants
                                                                              .userModel
                                                                              .userFamilyId !=
                                                                          '') {
                                                                    // bool
                                                                    //     screenNotOpen =
                                                                    await checkUserSubscriptionValue(
                                                                        appConstants,
                                                                        context,
                                                                        seconderyShowing:
                                                                            true);
                                                                    return;
                                                                  }

                                                                  String?
                                                                      cardAssigned =
                                                                      await Navigator.push(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                              builder: (context) => AddMemberWorkFlow(
                                                                                    fromDebitcard: true,
                                                                                  )));

                                                                  if (cardAssigned ==
                                                                      "success") {
                                                                    ApiServices
                                                                        apiServices =
                                                                        ApiServices();
                                                                    dynamic cardExist = await apiServices.checkCardExist(
                                                                        parentId: appConstants
                                                                            .userModel
                                                                            .userFamilyId!,
                                                                        id: selectedUserId);
                                                                    setState(
                                                                        () {
                                                                      cardAlreadyExist =
                                                                          cardExist;
                                                                    });
                                                                  }
                                                                }
                                                              },
                                                      )
                                                    ],
                                                  )
                                                : Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      cardAlreadyExist.data()[
                                                                  AppConstants
                                                                      .ICard_physical_card] ==
                                                              true
                                                          ? CarouselSlider(
                                                              options:
                                                                  CarouselOptions(
                                                                // height: height * 0.22,
                                                                autoPlay: false,
                                                                enlargeCenterPage:
                                                                    true,
                                                                enableInfiniteScroll:
                                                                    false,
                                                                disableCenter:
                                                                    true,
                                                                aspectRatio: 5,
                                                                scrollPhysics:
                                                                    const BouncingScrollPhysics(),
                                                                autoPlayAnimationDuration:
                                                                    const Duration(
                                                                        milliseconds:
                                                                            300),
                                                              ),
                                                              items: [1, 2]
                                                                  .map((i) {
                                                                return Builder(
                                                                  builder:
                                                                      (BuildContext
                                                                          context) {
                                                                    return InkWell(
                                                                        onTap:
                                                                            () async {
                                                                          String?
                                                                              cardAssigned =
                                                                              await Navigator.push(context, MaterialPageRoute(builder: (context) => CardBackGroundImage(selectedCardId: selectedUserId, previousImage: cardAlreadyExist.data()[AppConstants.ICard_backGroundImage])));
                                                                          if (cardAssigned ==
                                                                              "success") {
                                                                            ApiServices
                                                                                apiServices =
                                                                                ApiServices();
                                                                            dynamic
                                                                                cardExist =
                                                                                await apiServices.checkCardExist(parentId: appConstants.userModel.userFamilyId!, id: selectedUserId);
                                                                            setState(() {
                                                                              cardAlreadyExist = cardExist;
                                                                            });
                                                                          }
                                                                        },
                                                                        child: Stack(
                                                                          children: [
                                                                            CreaditCard(
                                                                                width,
                                                                                appConstants,
                                                                                height,
                                                                                snapshot:
                                                                                    cardAlreadyExist.data()),
                                                                            if(cardActive==false)
                                                                              InActivteCard(),
                                                                          ],
                                                                        ));
                                                                  },
                                                                );
                                                              }).toList(),
                                                            )
                                                          : Center(
                                                            child: Stack(
                                                              children: [
                                                                CreaditCard(
                                                                    width,
                                                                    appConstants,
                                                                    height,
                                                                    snapshot:
                                                                        cardAlreadyExist
                                                                            .data()),
                                                                if(cardActive==false)
                                                      InActivteCard(),
                                                              ],
                                                            ),
                                                          ),
                                                      spacing_medium,
                                                      TextHeader1(
                                                        title: 'Card Settings',
                                                      ),
                                                      // if(selectedUserId!=appConstants.userRegisteredId)
                                                      (selectedUserType ==
                                                                  AppConstants
                                                                      .USER_TYPE_SINGLE ||
                                                              selectedUserType ==
                                                                  AppConstants
                                                                      .USER_TYPE_PARENT)
                                                          ? const SizedBox
                                                              .shrink()
                                                          : Column(
                                                              children: [
                                                                spacing_medium,
                                                                ManageDebitCardTile(
                                                                  imageUrl:
                                                                      'manage_spend_limit',
                                                                  title:
                                                                      "Manage Spend Limits",
                                                                  onTap: () {
                                                                    Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                            builder: (context) =>
                                                                                SpendingLimit(selectedId: selectedUserId)));
                                                                  },
                                                                ),
                                                              ],
                                                            ),
                                                      // spacing_medium,
                                                      // if (!cardAlreadyExist.data()[
                                                      //     AppConstants.ICard_physical_card])
                                                      //   ManageDebitCardTile(
                                                      //     imageUrl: 'issue_physical_card',
                                                      //     title: "Issue a Physical Card",
                                                      //     onTap: () async {
                                                      //       ApiServices service =
                                                      //           ApiServices();
                                                      //       await service
                                                      //           .updateCardPhysicalStatus(
                                                      //               id: cardAlreadyExist.id,
                                                      //               parentId: appConstants
                                                      //                   .userRegisteredId,
                                                      //               status: true);
                                                      //       Future.delayed(
                                                      //           Duration(seconds: 2), () {
                                                      //         service.checkCardExist(
                                                      //             parentId: appConstants
                                                      //                 .userRegisteredId,
                                                      //             id: selectedUserId);
                                                      //         Navigator.push(
                                                      //             context,
                                                      //             MaterialPageRoute(
                                                      //                 builder: (context) =>
                                                      //                     RequestDebitCard()));
                                                      //       });
                                                      //     },
                                                      //   ),

                                                      // spacing_large,
                                                      // TextHeader1(
                                                      //   title:
                                                      //   'Virtual Card Settings',
                                                      // ),
                                                      //  spacing_medium,
                                                      //   ManageDebitCardTile(
                                                      //     title: "Credit Card Image",
                                                      //     onTap: () async {
                                                      //       String? cardAssigned = await Navigator.push(
                                                      //           context,
                                                      //           MaterialPageRoute(
                                                      //               builder: (context) =>
                                                      //                   CardBackGroundImage(
                                                      //                       selectedCardId:
                                                      //                           selectedUserId,
                                                      //                       previousImage:
                                                      //                           cardAlreadyExist
                                                      //                                   .data()[
                                                      //                               AppConstants
                                                      //                                   .ICard_backGroundImage])));
                                                      //       if (cardAssigned == "success") {
                                                      //         ApiServices apiServices =
                                                      //             ApiServices();
                                                      //         dynamic cardExist =
                                                      //             await apiServices
                                                      //                 .checkCardExist(
                                                      //                     parentId: appConstants
                                                      //                         .userRegisteredId,
                                                      //                     id: selectedUserId);
                                                      //         setState(() {
                                                      //           cardAlreadyExist = cardExist;
                                                      //         });
                                                      //       }
                                                      //     },
                                                      //   ),
                                                      // //  spacing_medium,
                                                      //   ManageDebitCardTile(
                                                      //     title: "Add to Apple Send",
                                                      //     onTap: () {},
                                                      //   ),
                                                      spacing_medium,
                                                      ManageDebitCardTile(
                                                          imageUrl:
                                                              'activate_inactivate',
                                                          title:
                                                              "Activate / Inactivate",
                                                          onTap: () async {
                                                            ApiServices
                                                                apiServices =
                                                                ApiServices();
                                                            dynamic cardExist =
                                                                await apiServices.checkCardExist(
                                                                    parentId: appConstants
                                                                        .userModel
                                                                        .userFamilyId??appConstants.userRegisteredId,
                                                                    id: selectedUserId);
                                                            setState(() {
                                                              cardAlreadyExist =
                                                                  cardExist;
                                                            });
                                                            appConstants
                                                                .updateForCardLockStatus(
                                                                    from:
                                                                        false);
                                                            var response = await Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (context) => ActivateCard(
                                                                        snapShot:
                                                                            cardAlreadyExist,
                                                                        selectedUserId:
                                                                            selectedUserId)));
                                                            logMethod(
                                                                title:
                                                                    'PIN Code  match Status:',
                                                                message:
                                                                    response ??
                                                                        'Not');
                                                            if (response !=
                                                                null) {
                                                              ApiServices
                                                                  apiServices =
                                                                  ApiServices();
                                                              await apiServices.updateCardStatus(
                                                                  id: cardAlreadyExist
                                                                      .id,
                                                                  parentId:
                                                                      appConstants
                                                                          .userRegisteredId,
                                                                  status: cardAlreadyExist
                                                                          .data()[
                                                                      AppConstants
                                                                          .ICard_cardStatus] = !cardAlreadyExist[
                                                                      AppConstants
                                                                          .ICard_cardStatus]);
                                                              dynamic cardExist = await apiServices.checkCardExist(
                                                                  parentId: appConstants
                                                                      .userModel
                                                                      .userFamilyId!,
                                                                  id: selectedUserId);
                                                              setState(() {
                                                                cardAlreadyExist =
                                                                    cardExist;
                                                              });
                                                            }
                                                          }),
                                                      spacing_medium,
                                                      // ManageDebitCardTile(
                                                      //   title: "Lock Card? ",
                                                      //   onTap: () async {
                                                      //     ApiServices apiServices =
                                                      //           ApiServices();
                                                      //       dynamic cardExist =
                                                      //           await apiServices
                                                      //               .checkCardExist(
                                                      //                   parentId: appConstants
                                                      //                       .userRegisteredId,
                                                      //                   id: selectedUserId);
                                                      //       setState(() {
                                                      //         cardAlreadyExist = cardExist;
                                                      //       });
                                                      //     appConstants
                                                      //         .updateForCardLockStatus(
                                                      //             from: true);
                                                      //     var response =
                                                      //         await Navigator.push(
                                                      //             context,
                                                      //             MaterialPageRoute(
                                                      //                 builder: (context) =>
                                                      //                     ActivateCard(
                                                      //                       snapShot:
                                                      //                           cardAlreadyExist
                                                      //                               .data(),
                                                      //                       selectedUserId:selectedUserId
                                                      //                     )));
                                                      //     logMethod(
                                                      //         title: 'PIN Code match status:',
                                                      //         message: response ?? 'Not');
                                                      //     if (response != null) {
                                                      //       ApiServices apiService =
                                                      //           ApiServices();
                                                      //       await apiService
                                                      //           .updateCardLockedStatus(
                                                      //               id: cardAlreadyExist.id,
                                                      //               parentId: appConstants
                                                      //                   .userRegisteredId,
                                                      //               status: cardAlreadyExist
                                                      //                               .data()[
                                                      //                           AppConstants
                                                      //                               .ICard_lockedStatus] ==
                                                      //                       true
                                                      //                   ? false
                                                      //                   : true);
                                                      //       dynamic cardExist =
                                                      //           await apiService.checkCardExist(
                                                      //               parentId: appConstants
                                                      //                   .userRegisteredId,
                                                      //               id: selectedUserId);
                                                      //       setState(() {
                                                      //         cardAlreadyExist = cardExist;
                                                      //       });
                                                      //       showNotification(
                                                      //           error: 0,
                                                      //           icon: Icons.check,
                                                      //           message:
                                                      //               'Woohoo...Locked status is updated');
                                                      //     }
                                                      //   },
                                                      // ),
                                                      // spacing_medium,

                                                      ManageDebitCardTile(
                                                        imageUrl: 'card_info',
                                                        title: "See Card Info",
                                                        onTap: () async{
                                                          CardInformationModel cardInfoModel = await CreaditCardApi().showCardInformation(cardToken: cardAlreadyExist.data()[AppConstants.ICard_Token]);
                                                          cardInformation(
                                                            context,
                                                            width,
                                                            height,
                                                            '${cardAlreadyExist.data()[AppConstants.ICard_firstName]} ${cardAlreadyExist.data()[AppConstants.ICard_lastName]}',
                                                            cardInfoModel: cardInfoModel
                                                          );
                                                        },
                                                      ),
                                                      //   spacing_large,
                                                      //  Row(
                                                      //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                      //    children: [
                                                      //      WalletCustomWidget(
                                                      //       width: width,
                                                      //       title: 'Add To',
                                                      //       subTitle: 'Apple Wallet',
                                                      //       imageUrl: 'add_to_apple',
                                                      //       ),
                                                      //       WalletCustomWidget(
                                                      //       width: width,
                                                      //       title: 'Add To',
                                                      //       subTitle: 'Google Wallet',
                                                      //       imageUrl: 'add_to_google',
                                                      //       ),
                                                      //    ],
                                                      //  ),
                                                      //  spacing_medium,
                                                      //  Center(
                                                      //    child: InkWell(
                                                      //     onTap: (){
                                                      //       Navigator.push(context,
                                                      //       MaterialPageRoute(
                                                      //           builder: (context) => const SecretDebitCard())
                                                      //           );
                                                      //     },
                                                      //      child: Text(
                                                      //       'Secret Debit Card Test Screen',
                                                      //       style: heading3TextStyle(width),
                                                      //       ),
                                                      //    ),
                                                      //  ),
                                                      spacing_large,
                                                      if (cardAlreadyExist
                                                                  .data()[
                                                              AppConstants
                                                                  .ICard_physical_card] ==
                                                          true)
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            CustomSizedBox(
                                                              height: height,
                                                            ),
                                                            TextHeader1(
                                                              title:
                                                                  'Physical Card Settings',
                                                            ),
                                                            spacing_medium,
                                                            ManageDebitCardTile(
                                                              title:
                                                                  "Lock Card",
                                                              onTap: () {},
                                                            ),
                                                            spacing_medium,
                                                            ManageDebitCardTile(
                                                              imageUrl:
                                                                  'card_info',
                                                              title:
                                                                  "See Card Info",
                                                              onTap: () async{
                                                                CardInformationModel cardInfoModel = await CreaditCardApi().showCardInformation(cardToken: cardAlreadyExist.data()[AppConstants.ICard_Token]);
                                                                cardInformation(
                                                                    context,
                                                                    width,
                                                                    height,
                                                                    '${cardAlreadyExist.data()[AppConstants.ICard_firstName]} ${cardAlreadyExist.data()[AppConstants.ICard_lastName]}',
                                                                    cardInfoModel: cardInfoModel
                                                                    );
                                                              },
                                                            ),
                                                            spacing_large,
                                                            //  Row(
                                                            //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                            //    children: [
                                                            //      WalletCustomWidget(
                                                            //       width: width,
                                                            //       title: 'Add To',
                                                            //       subTitle: 'Apple Wallet',
                                                            //       imageUrl: 'add_to_apple',
                                                            //       ),
                                                            //       WalletCustomWidget(
                                                            //       width: width,
                                                            //       title: 'Add To',
                                                            //       subTitle: 'Google Wallet',
                                                            //       imageUrl: 'add_to_google',
                                                            //       ),
                                                            //    ],
                                                            //  ),
                                                            //  spacing_medium,
                                                            //  Center(
                                                            //    child: InkWell(
                                                            //     onTap: (){
                                                            //       Navigator.push(context,
                                                            //       MaterialPageRoute(
                                                            //           builder: (context) => const SecretDebitCard())
                                                            //           );
                                                            //     },
                                                            //      child: Text(
                                                            //       'Secret Debit Card Test Screen',
                                                            //       style: heading3TextStyle(width),
                                                            //       ),
                                                            //    ),
                                                            //  )
                                                          ],
                                                        )
                                                    ],
                                                  ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (cardAlreadyExist == true)
            Align(
              alignment: Alignment.center,
              child: Icon(
                Icons.lock_outline,
                color: grey.withValues(alpha:0.4),
                size: height * 0.2,
              ),
            )
        ],
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Container CreaditCard(double width, AppConstants appConstants, double height,
      {dynamic snapshot, String? selectedUserId}) {
    return Container(
      // Color(0XFF9831F5)
      // height: height*0.26,
      width: width,
      // decoration: cardBackgroundConatiner(width, black,
      //     backgroundImageUrl: snapshot![AppConstants.ICard_backGroundImage]),
      child: Stack(
        children: [
          Center(
            child: Image.asset(
              cardImagesBaseAddress + "ZakiPayNoDebitCard.png",
              width: width,
              fit: BoxFit.fitWidth,
              )),
          Positioned(
            bottom: 0,
            left: 0,
            child: Padding(
              padding: const EdgeInsets.only(left: 30.0, bottom: 22),
              child: Text(
                '${snapshot[AppConstants.ICard_firstName]} ${snapshot[AppConstants.ICard_lastName]}',
                style: heading2TextStyle(context, width, color: white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void cardInformation(
      BuildContext? context, double? width, double? height, String? name, {required CardInformationModel cardInfoModel}) {
    showModalBottomSheet(
        context: context!,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(width! * 0.09),
            topRight: Radius.circular(width * 0.09),
          ),
        ),
        builder: (BuildContext bc) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(bc);
                      },
                      child: Container(
                        width: width * 0.2,
                        height: 5,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(width * 0.08),
                            color: grey),
                      ),
                    ),
                  ),
                  TextHeader1(
                    title: 'ZakiPay Card Info',
                  ),
                  spacing_large,
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: width * 0.08,
                      vertical: width * 0.01,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Card Holder name',
                          style: heading1TextStyle(
                            context,
                            width,
                          ),
                        ),
                        CustomSizedBox(
                          height: height,
                        ),
                        Text(
                          name ?? '',
                          style: heading3TextStyle(width),
                        ),
                        const CustomDivider(),
                        Text(
                          'Card Number',
                          style: heading1TextStyle(
                            context,
                            width,
                          ),
                        ),
                        CustomSizedBox(
                          height: height,
                        ),
                        Text(
                          cardInfoModel.pan,
                          style: heading3TextStyle(width),
                        ),
                        const CustomDivider(),
                        Row(
                          children: [
                            Expanded(
                                child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 2.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Expiration date',
                                    style: heading1TextStyle(
                                      context,
                                      width,
                                    ),
                                  ),
                                  CustomSizedBox(
                                    height: height,
                                  ),
                                  Text(
                                    '${cardInfoModel.expirationTime.toString().split('-')[1]}/${cardInfoModel.expirationTime.year}',
                                    style: heading3TextStyle(
                                      width,
                                    ),
                                  ),
                                  const CustomDivider(),
                                ],
                              ),
                            )),
                            Expanded(
                                child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 2.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Security Code',
                                    style: heading1TextStyle(
                                      context,
                                      width,
                                    ),
                                  ),
                                  CustomSizedBox(
                                    height: height,
                                  ),
                                  Text(
                                    cardInfoModel.expiration,
                                    style: heading3TextStyle(width),
                                  ),
                                  const CustomDivider(),
                                ],
                              ),
                            )),
                            // const SizedBox(
                            //   width: 10,
                            // ),
                            // Expanded(
                            //     child: Padding(
                            //   padding:
                            //       const EdgeInsets.symmetric(horizontal: 2.0),
                            //   child: Column(
                            //     crossAxisAlignment: CrossAxisAlignment.start,
                            //     children: [
                            //       Text(
                            //         'Security Code',
                            //         style: heading1TextStyle(
                            //   context, width,),
                            //       ),
                            //       CustomSizedBox(
                            //         height: height,
                            //       ),
                            //       Text(
                            //         '****',
                            //         style: heading3TextStyle(width,),
                            //       ),
                            //       const CustomDivider(),
                            //     ],
                            //   ),
                            // )
                            // )
                          ],
                        ),
                        spacing_medium
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}

class WalletCustomWidget extends StatelessWidget {
  const WalletCustomWidget(
      {Key? key, required this.width, this.imageUrl, this.subTitle, this.title})
      : super(key: key);

  final double width;
  final String? title;
  final String? subTitle;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(10), color: black),
      child: Padding(
        padding: const EdgeInsets.all(6.5),
        child: Row(
          children: [
            Image.asset(
              imageBaseAddress + '$imageUrl.png',
              height: 38,
              width: 38,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 4.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$title',
                    style: heading2TextStyle(context, width,
                        color: white, font: 11),
                  ),
                  Text('$subTitle',
                      style: heading1TextStyle(context, width,
                          color: white, font: 13)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ManageDebitCardTile extends StatelessWidget {
  const ManageDebitCardTile({Key? key, this.title, this.onTap, this.imageUrl})
      : super(key: key);
  final String? title;
  final VoidCallback? onTap;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          // Icon(Icons.add_card, color: black),
          Image.asset(
            imageBaseAddress + '$imageUrl.png',
            height: 30,
            width: 30,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Text(
              '$title',
              style: heading3TextStyle(width),
            ),
          ),
          const Spacer(),
          Icon(
            Icons.arrow_forward,
            color: grey,
          )
        ],
      ),
    );
  }
}
