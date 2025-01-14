// import 'package:choice/choice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
// import 'package:firebase_pagination/firebase_pagination.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:zaki/Constants/HelperFunctions.dart';
import 'package:zaki/Models/ExtractMemoModel.dart';
import 'package:zaki/Models/Items.dart';
import 'package:http/http.dart' as http;
import 'package:zaki/Models/WalletModel.dart';
import 'package:zaki/Screens/InviteMainScreen.dart';
import 'package:zaki/Screens/IssueAndManageCards.dart';
import 'package:zaki/Screens/ManageContacts.dart';
import 'package:zaki/Screens/Socialize.dart';
import 'package:zaki/Services/CreaditCardApis.dart';
import 'package:zaki/Widgets/CustomFeedCard.dart';
import 'package:zaki/Widgets/FloatingActionButton.dart';
import 'package:zaki/Widgets/TextHeader.dart';
// import 'package:zaki/Widgets/TopFriendsCustomWidget.dart';
import 'package:zaki/Widgets/ZakiCircularButton.dart';
import 'package:zaki/Widgets/ZakiPrimaryButton.dart';
import '../Constants/AppConstants.dart';
import '../Constants/Spacing.dart';
import '../Constants/Styles.dart';
import '../Models/TransactionModel.dart';
import '../Services/api.dart';
import '../Widgets/AppBars/AppBar.dart'; 
import '../Widgets/CustomAllTransaction.dart';
import '../Widgets/CustomBottomNavigationBar.dart';
import '../Widgets/UnSelectedKidsWidget.dart';

import 'package:zaki/Widgets/CustomLoader.dart';

class AllTransaction extends StatefulWidget {
  const AllTransaction({Key? key}) : super(key: key);

  @override
  _AllTransactionState createState() => _AllTransactionState();
}

class _AllTransactionState extends State<AllTransaction> {
  Stream<QuerySnapshot>? requestedMoneyActivities;
  Future<CardTransation>? transactionLists;
  CardTransation? transactions;

  List<Datum>? fullTransactions=[];
  List<Datum>? fullTransactionsClear=[];
  List<Datum>? filteredFullTransactions=[];
  // CardTransation? transation = CardTransation(
  //     count: 0, appConstants.startIndex: 0, endIndex: 0, isMore: false, data: []);
  // Stream<QuerySnapshot>? payMoneyActivities;
  Stream<List<Item>>? allTransactions;
  // List<Datum> transaction=[];
  Stream<QuerySnapshot<Object?>>? topFriends;
  List<String> queryList = [];
  String walletName = 'All';
  double minPrice = 0;
  double maxPrice = 1000;
  bool onlyAvailable = false;
  bool filterApply = false;
  String? selectedUserIdForFav;
  int? selectedTagit;
  String? selectedDateType;
  int _selectedDateIndex = 0; 

  int? selectedTransaction;
  String? selectedValue;
  DateTime? startDate;
  DateTime? endDate;
  final ExpansionTileController topFriendsExpansionTile =
      ExpansionTileController();
  final ExpansionTileController tagItExpansionTile = ExpansionTileController();
  final ExpansionTileController walletExpansionTile = ExpansionTileController();
  final ExpansionTileController dateExpansionTile = ExpansionTileController();
  final ExpansionTileController transactionTypeExpansionTile =
      ExpansionTileController();
  final ExpansionTileController minAndMaxExpansionTile =
      ExpansionTileController();
  //
   bool isExpandedtopFriendsExpansionTile =false;
  bool isExpandedtagItExpansionTile = false;
  bool isExpandedwalletExpansionTile = false;
  bool isExpandeddateExpansionTile = false;
  bool isExpandedtransactionTypeExpansionTile =false;
  bool isExpandedminAndMaxExpansionTile =false;
  
  

  final minPriceTextController = TextEditingController();
  final maxPriceTextController = TextEditingController();
  Stream<QuerySnapshot>? userKids;
  int selectedIndex = -2;
  String? selectedUserId;
  String? selectedUserBankId = '';
  String? selectedUserName = '';
  Query? query;
  bool isMore = true;
  bool isLoading = true;

  //////For Pagination
  //  static const _pageSize = 20;

  // final PagingController<int, Datum> _pagingController =
  //     PagingController(firstPageKey: 0);
  final _controller = ScrollController();
  // int appConstants.startIndex=0;
  int? limit=10;
  List<WalletModel> allWalletName =[];
  List<WalletModel> allDateName =[];

  @override
  void initState() {
    super.initState();
    

    Future.delayed(Duration.zero, () async {
      var appConstants = Provider.of<AppConstants>(context, listen: false);
      allDateName = [
        WalletModel(
          isChecked: false,
          title: 'Last 7 Days'
        ),
        WalletModel(
          isChecked: false,
          title: 'Last 30 Days'
        ),
        WalletModel(
          isChecked: false,
          title: 'Last 90 Days'
        ),
        WalletModel(
          isChecked: false,
          title: 'Last 180 Days'
        ),
        WalletModel(
          isChecked: false,
          title: 'Custom'
        ),
      ];
      allWalletName =[
        WalletModel(
          isChecked: false,
          title: (appConstants.nickNameModel.NickN_SpendWallet !=null && appConstants.nickNameModel.NickN_SpendWallet != "")
                                              ? appConstants
                                                  .nickNameModel.NickN_SpendWallet!
                                              : 'Spend-' + 'Wallet'),
        WalletModel(
          isChecked: false,
          title: (appConstants.nickNameModel.NickN_SavingWallet !=
                                                      null &&
                                                  appConstants.nickNameModel
                                                          .NickN_SavingWallet !=
                                                      "")
                                              ? appConstants.nickNameModel
                                                      .NickN_SavingWallet! +
                                                  'Wallet'
                                              : 'Savings-'.tr() + 'Wallet'),
        WalletModel(
          isChecked: false,
          title:(appConstants.nickNameModel.NickN_DonationWallet !=
                                                      null &&
                                                  appConstants.nickNameModel
                                                          .NickN_DonationWallet !=
                                                      "")
                                              ? appConstants.nickNameModel
                                                      .NickN_DonationWallet! +
                                                  ' Wallet'
                                              : 'Charity-'.tr() + "Wallet"),
        WalletModel(
          isChecked: false,
          title:'Goals-Wallet'),
      ];
      appConstants.updateSelectedWalletFilter('');
      selectedUserBankId = appConstants.userModel.userTokenId;

      _controller.addListener(() {
      if(_controller.position.maxScrollExtent==_controller.offset){
        // getCardTrnsactions(
        //     appConstants: appConstants,
        //     actingUserToken: appConstants.userModel.userTokenId,
        //     userToken: appConstants.userModel.userTokenId,
        //     appConstants.startIndex: appConstants.startIndex,
        //     limit:limit,
        //     );
        if(isMore){
          cardTransactionsFromApi(
        appConstants: appConstants,
            actingUserToken: selectedUserBankId,
            userToken: selectedUserBankId,
            startIndex: appConstants.startIndex,
            limit:limit,
       );
       setState(() {
         
       });
        }
        
            // fullTransactions
         
      }
     });

      bool screenNotOpen =
          await checkUserSubscriptionValue(appConstants, context);
      logMethod(title: 'Data from Pay+', message: screenNotOpen.toString());
      if (screenNotOpen == true) {
        Navigator.pop(context);
      } else {
        setState(() {
          isLoading = true;
        });
        await getUserTransaction(appConstants.userRegisteredId);
        // _pagingController.addPageRequestListener((pageKey) async{
      // _fetchPage();
      appConstants.updateStartIndex(0);
      await cardTransactionsFromApi(
        appConstants: appConstants,
            actingUserToken: appConstants.userModel.userTokenId,
            userToken: appConstants.userModel.userTokenId,
            startIndex: 0,
            limit:limit,
       );

        await getCardTrnsactions(
            appConstants: appConstants,
            actingUserToken: appConstants.userModel.userTokenId,
            userToken: appConstants.userModel.userTokenId,
            startIndex: appConstants.startIndex,
            limit:limit,
            );
    // });
        if (appConstants.userModel.usaUserType != "Kid")
          getUserKids(appConstants);
        selectedUserId = appConstants.userRegisteredId;
        userCardInfo(selectedUserId!, appConstants.userModel.userFamilyId??"");
        // getUserTransaction(appConstants.userChildRegisteredId);
      }
      setState(() {
          isLoading = false;
        });
    });
  }

  Future<dynamic> userCardInfo(String seletedUser, String parentId) async {
    ApiServices apiServices = ApiServices();
    dynamic cardExist =
        await apiServices.checkCardExist(parentId: parentId, id: seletedUser);
    // logMethod(title: 'Card exist', message: cardExist.toString());
    if (cardExist == false) {
    } else {
      // logMethod(
      //     title: 'Card Successfully',
      //     message:
      //         'Card Token::::::: ${cardExist[AppConstants.ICard_Token].toString()} & User Token::::::: ${cardExist[AppConstants.ICard_User_Token].toString()}');
      //  getCardTrnsactions(userToken: '97c65d9e-d0f3-4319-986b-8d3b1b4ef09b', actingUserToken: '97c65d9e-d0f3-4319-986b-8d3b1b4ef09b');
      // getCardTrnsactions(
      //     userToken: cardExist[AppConstants.ICard_User_Token].toString(),
      //     actingUserToken: cardExist[AppConstants.ICard_User_Token].toString());
    }
  }

  
  cardTransactionsFromApi(
      {String? userToken,
      String? actingUserToken,
      AppConstants? appConstants,
      required int startIndex,
      int? limit,
      // required AppConstants appConstants
      }) async {
  logMethod(title: 'Before Is More and Start Index', message: '$isMore and ${appConstants!.startIndex}');
   var data = await http.get(Uri.parse('${ApiConstants.MARQATA_BASE_URL}${ApiConstants.TRANSACTIONS}?user_token=$userToken&acting_user_token=$actingUserToken&start_index=$startIndex&limit=$limit'),
            headers: ApiConstants.headers(),
          ).whenComplete(() {
    // ignore: body_might_complete_normally_catch_error
    }).catchError((e) {
    });
    // logMethod(title: 'Card Transactions:', message: data.body);
    // ignore: unused_local_variable
    setState(() {
    final cardTransationModel = cardTransationFromMap(data.body);
    fullTransactions!.addAll(cardTransationModel.data);
    filteredFullTransactions!.addAll(cardTransationModel.data);
    fullTransactionsClear!.addAll(cardTransationModel.data);
    transactions =  cardTransationModel;
    isMore = cardTransationModel.isMore;

    // appConstants.startIndex = appConstants.startIndex+9;
    appConstants.updateStartIndex(appConstants.startIndex+9);
      
    });
    logMethod(title: 'After Is More and Start Index', message: '$isMore and ${appConstants.startIndex}');
    // appConstants!.updateTransactionList(cardTransationModel);
    // logMethod(title: 'Card TransactionsFrom Model:', message: appConstants.cardTransactionList.count.toString());
    // cardTransationModel.data.first.gpaOrder.
    // return cardTransationModel;
  }


  getCardTrnsactions(
      {String? userToken,
      String? actingUserToken,
      AppConstants? appConstants,
      int? startIndex,
      int? limit,
      }) async {
    // CardTransation? cardTransaction =
    // if (appConstants!.testMode != false)
    transactionLists = CreaditCardApi().cardTransaction(
        userToken: userToken,
        actingUserToken: actingUserToken,
        appConstants: appConstants,
        limit: limit,
        startIndex: appConstants!.startIndex
        );
    // transaction = transaction.addAll(appConstants!.cardTransactionList.data) as List<Datum>;
    // logMethod(title: 'Has more Items', message: appConstants.cardTransactionList.isMore.toString());
      // transactions!.addAll(appConstants!.cardTransactionList.data);
    // Future.delayed(Duration(seconds: 2), (){
    //   logMethod(title: 'Transaction Method:', message: transactions.toString());
    // });
    // transation = cardTransaction;
    // setState(() {});
    // transactionLists!.then((value) {
    //   transactions = value.data;
    //   setState(() {
        
    //   });
    // });
  }

  Future getUserKids(AppConstants appConstants) async {
    // setState(() {
    selectedIndex = -1;
    selectedUserId = appConstants.userRegisteredId;
    // });
    userKids = ApiServices().fetchUserKids(
        appConstants.userModel.seeKids == true
            ? appConstants.userModel.userFamilyId!
            : appConstants.userRegisteredId,
        currentUserId: appConstants.userRegisteredId);

    setState(() {});
  }

  void setSelectedValue(String? value) {
    setState(() => selectedValue = value);
  }

  getTopFriends() {
    Future.delayed(Duration.zero, () async {
      var appConstants = Provider.of<AppConstants>(context, listen: false);
      topFriends = ApiServices()
          .fetchUserTopFriends(context, id: appConstants.userRegisteredId);

      setState(() {});
    });
  }

  void clear() {
    setState(() {
      queryList = [];
      walletName = 'All';
      minPrice = 0;
      maxPrice = 1000;
      onlyAvailable = false;
      selectedUserIdForFav = null;
      selectedTagit = null;
      selectedDateType = null;
      selectedTransaction = null;
      selectedValue = null;
      startDate = null;
      endDate = null;
    });
  }

  Future getUserTransaction(String id) async {
   
    
    setState(() {
      query = ApiServices().giveQuery(
          transactionTagitCategory: queryList,
          userId: id,
          maxPrice: maxPrice,
          minPrice: minPrice,
          walletName: walletName,
          startDate: startDate,
          endDate: endDate,
          selectedUserId: selectedUserIdForFav);
      allTransactions = ApiServices().fetchTransactions(
          transactionTagitCategory: queryList,
          userId: id,
          maxPrice: maxPrice,
          minPrice: minPrice,
          walletName: walletName,
          startDate: startDate,
          endDate: endDate,
          selectedUserId: selectedUserIdForFav);
      // requestedMoneyActivities = ApiServices()
      //     .getRequestedMoney(id, collectionName: AppConstants.Transaction);
      // requestedMoneyActivities = ApiServices().getRequestedMoney(id, collectionName: 'Requested');
      // payMoneyActivities = ApiServices().getRequestedMoney(id, collectionName: 'Send');
    });
  }

  /////Full Screen Dialouge
  Future<String?> showFilterDialog() async {
    int selectedIndex = -1;
    String? selecetd = await showDialog(
        context: context,
        // useSafeArea: false,

        builder: (BuildContext context) {
          var appConstants = Provider.of<AppConstants>(context, listen: true);
          var width = MediaQuery.of(context).size.width;
          var height = MediaQuery.of(context).size.height;
          return StatefulBuilder(
            builder: (context, setState) {
              return Dialog.fullscreen(
                // contentPadding: EdgeInsets.zero,
                // title: Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     TextHeader1(
                //       title: 'Filter By:',
                //     ),
                //     IconButton(
                //       icon: Icon(Icons.close),
                //       onPressed: () {
                //         Navigator.pop(context);
                //       },
                //     ),
                //   ],
                // ),
                // actions: [
                  // Row(
                  //   children: [
                  //     Expanded(
                  //       child: ZakiPrimaryButton(
                  //         title: 'Clear All',
                  //         width: width * 0.5,
                  //         backgroundTransparent: 1,
                  //         textColor: grey,
                  //         onPressed: () {
                  //           // clear();
                  //           setState(() {
                  //             queryList = [];
                  //             walletName = 'All';
                  //             // minPrice = 0;
                  //             // maxPrice = 1000;
                  //             onlyAvailable = false;
                  //             selectedUserIdForFav = null;
                  //             selectedTagit = null;
                  //             selectedDateType = null;
                  //             selectedTransaction = null;
                  //             selectedValue = null;
                  //             startDate = null;
                  //             endDate = null;
                  //             filterApply = false;
                  //             allTransactions = ApiServices().fetchTransactions(
                  //                 transactionTagitCategory: queryList,
                  //                 userId: appConstants.userRegisteredId,
                  //                 maxPrice: maxPrice,
                  //                 minPrice: minPrice,
                  //                 walletName: walletName,
                  //                 startDate: startDate,
                  //                 endDate: endDate,
                  //                 selectedUserId: selectedUserIdForFav);
                  //           });
                  //           // Navigator.pop(context);
                  //         },
                  //       ),
                  //     ),
                  //     SizedBox(
                  //       width: 10,
                  //     ),
                  //     Expanded(
                  //       child: ZakiPrimaryButton(
                  //         title: 'View',
                  //         width: width * 0.4,
                  //         onPressed: () async {
                  //           logMethod(
                  //               title: 'All Values',
                  //               message:
                  //                   "Apply Filter: $filterApply selecte Wallet: $walletName, selectedUserId: $selectedUserId, tagit: $queryList, startDate: ${startDate}, endDate: ${endDate}");
                  //           setState(() {
                  //             filterApply = true;
                  //           });
                  //           Navigator.pop(context, "Closed");
                  //         },
                  //       ),
                  //     ),
                  //   ],
                  // ),
                // // ],
                // insetPadding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                // shape: RoundedRectangleBorder(
                //     borderRadius: BorderRadius.all(Radius.circular(10.0))),
                // insetPadding: EdgeInsets.zero,
                // actionsPadding: EdgeInsets.zero,
                // title: Text('Filter Dialog'),
                // content:
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              spacing_large,
                              Padding(
                                padding: EdgeInsets.only(left: 8),
                                child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Text(
                                                            'Filter By:',
                                                            style: appBarTextStyle(context, width),
                                                          ),
                                                          IconButton(
                                                            padding: EdgeInsets.zero,
                                                            visualDensity: VisualDensity.compact,
                                                            icon: Icon(Icons.close),
                                                            onPressed: () {
                                Navigator.pop(context);
                                                            },
                                                          ),
                                                        ],
                                                      ),
                              ),
                              spacing_medium,
                              SizedBox(width: width,),
                              Container(
                                decoration: expansionBoxDecoration(),
                                child: Theme(
                                  data: Theme.of(context)
                                      .copyWith(dividerColor: transparent),
                                  child: ListTileTheme(
                                  contentPadding: EdgeInsets.all(0),
                                  dense: true,
                                    child: ListTileTheme(
                                  contentPadding: EdgeInsets.all(0),
                                  dense: true,
                                      child: ExpansionTile(
                                        // tilePadding: EdgeInsets.zero,
                                        tilePadding: const EdgeInsets.symmetric(horizontal: 8,vertical: 0),
                                        
                                        // key: UniqueKey(),
                                        // initiallyExpanded: _isExpanded,
                                        initiallyExpanded: isExpandedtopFriendsExpansionTile,
                                        onExpansionChanged: (isExpanded) {
                                          setState(() {
                                            isExpandedtopFriendsExpansionTile = isExpanded;
                                          });
                                        },
                                        controller: topFriendsExpansionTile,
                                                                
                                        maintainState: true,
                                        // backgroundColor: Colors.red,
                                        // collapsedBackgroundColor: Colors.yellow,
                                        // shape: roundedBorderCustom(sunscriptionValue: appConstants.userModel.subScriptionValue),
                                        // collapsedShape: roundedBorderCustom(sunscriptionValue: appConstants.userModel.subScriptionValue),
                                        
                                        childrenPadding: getCustomPadding(),
                                        iconColor: green,
                                        // trailing:Icon(
                                        //         Icons.done,
                                        //         color: grey.withValues(alpha:0.6),
                                        //       ),
                                        // initiallyExpanded: appConstants.userModel.subScriptionValue==2?false:true ,
                                        title: Text(
                                          'Favorite',
                                          style: heading1TextStyle(context, width),
                                        ),
                                        children: [
                                          topFriends == null
                                              ? SizedBox.shrink()
                                              : SizedBox(
                                                  height: height * 0.15,
                                                  width: width,
                                                  child: StreamBuilder<QuerySnapshot>(
                                                    stream: topFriends,
                                                    builder: (BuildContext context,
                                                        AsyncSnapshot<QuerySnapshot>
                                                            snapshot) {
                                                      if (snapshot.hasError) {
                                                        return const Text(
                                                            'Ooops...Something went wrong :(');
                                                      }
                                                      if (snapshot.connectionState ==
                                                          ConnectionState.waiting) {
                                                        return const Text("");
                                                      }
                                                      if (snapshot.data!.size == 0) {
                                                        return SizedBox(
                                                          width: width * 0.85,
                                                          child: Row(
                                                            mainAxisSize: MainAxisSize.min,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment.center,
                                                            children: [
                                                              ZakiCicularButton(
                                                                title: 'Sync Contacts',
                                                                width: width * 0.7,
                                                                selected: 3,
                                                                icon: Icons.sync_outlined,
                                                                onPressed: () {
                                                                  Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                        builder: (context) =>
                                                                            const InviteMainScreen(
                                                                          fromHomeScreen:
                                                                              true,
                                                                        ),
                                                                      ));
                                                                },
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      }
                                                      return ListView.builder(
                                                        itemCount: snapshot.data!.docs.length,
                                                        physics:
                                                            const BouncingScrollPhysics(),
                                                        shrinkWrap: true,
                                                        scrollDirection: Axis.horizontal,
                                                        itemBuilder: (BuildContext context,
                                                            int index) {
                                                          // print(snapshot.data!.docs[index] ['USER_first_name']);
                                                          return InkWell(
                                                            onTap: () async {
                                                              selectedIndex = index;
                                                              selectedUserIdForFav = snapshot
                                                                  .data!.docs[index].id;
                                                              logMethod(title: 'Selected User From Filter', message: snapshot.data!.docs[index][AppConstants.USER_UserID]);
                                                              setState(() {});
                                                            },
                                                            child: 
                                                            Container(
                                                              // decoration: BoxDecoration(
                                                              //     border:
                                                              //         selectedUserIdForFav ==
                                                              //                 snapshot
                                                              //                     .data!
                                                              //                     .docs[index]
                                                              //                     .id
                                                              //             ? Border.all(
                                                              //                 color: green)
                                                              //             : null,
                                                              //     borderRadius:
                                                              //         BorderRadius.circular(
                                                              //             width * 0.4)),
                                                              child: 
                                                              StreamBuilder<DocumentSnapshot>(
                                                                    stream: FirebaseFirestore.instance.collection(AppConstants.USER)
                                                                    .doc(snapshot.data!.docs[index][AppConstants.USER_UserID])
                                                                    .snapshots(),
                                                                    builder: (context, snapshots) {
                                                                      
                                                                      if (snapshot.hasError) {
                                                                        return const Text('Ooops...Something went wrong :(');
                                                                      }
                                                                      if (snapshots.connectionState ==
                                                                          ConnectionState.waiting) {
                                                                        return SizedBox.shrink();
                                                                      }
                                                                      if (!snapshots.data!.exists) {
                                                                        return SizedBox.shrink();
                                                                      }
                                                                      var userData = snapshots.data!.data() as Map<String, dynamic>;
                                                                      return Column(
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
                                                                        width: selectedUserIdForFav == snapshot
                                                                  .data!.docs[index].id
                                                                            ? 2
                                                                            : 0,
                                                                        color: selectedUserIdForFav == snapshot
                                                                  .data!.docs[index].id
                                                                            ? orange
                                                                            : transparent),
                                                                    boxShadow:
                                                                        selectedIndex  !=
                                                                                index
                                                                            ? null
                                                                            : [
                                                                                customBoxShadow(color: orange)
                                                                              ],
                                                                  ),
                                                                            child: Padding(
                                                                                padding:
                                                                                    const EdgeInsets
                                                                                        .all(
                                                                                        0.0),
                                                                                child:
                                                                                    userImage(
                                                                                  imageUrl: userData[AppConstants
                                                                                          .USER_Logo],
                                                                                  userType: userData[AppConstants
                                                                                          .USER_UserType],
                                                                                  width:
                                                                                      width,
                                                                                  gender: userData
                                                                                      [
                                                                                      AppConstants
                                                                                          .USER_gender],
                                                                                )),
                                                                          ),
                                                                  //             if (selectedIndex !=index)
                                                                  // UnSelectedKidsWidget(),
                                                      
                                                            SizedBox(
                                                              height: 5,
                                                            ),
                                                            SizedBox(
                                                              // width: height * 0.065,
                                                              child: Center(
                                                                child: Text(
                                                                  (userData[AppConstants.USER_user_name] ==
                                                                              null ||
                                                                          userData[AppConstants
                                                                                  .USER_user_name] ==
                                                                              '')
                                                                      ? userData
                                                                          [
                                                                          AppConstants
                                                                              .USER_first_name]
                                                                      : '@ ' +
                                                                         userData[AppConstants.USER_user_name],
                                                                  overflow:
                                                                      TextOverflow
                                                                          .fade,
                                                                  maxLines: 1,
                                                                  style:
                                                                      heading5TextSmall(
                                                                          width),
                                                                ),
                                                              ),
                                                            )
                                                                              
                                                                        ],
                                                                      );
                                                                        })
                                                              // TopFriendsCustomWidget(
                                                              //   selectedIndexTopFriends: 0,
                                                              //   width: width,
                                                              //   index: index,
                                                              //   snapshot: snapshot
                                                              //       .data!.docs[index],
                                                              // ),
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
                              ),
                              spacing_medium,
                              // CustomDivider(),
                              Container(
                                decoration: expansionBoxDecoration(),
                                child: Theme(
                                  data: Theme.of(context)
                                      .copyWith(dividerColor: transparent),
                                  child: ListTileTheme(
                                  contentPadding: EdgeInsets.all(0),
                                  dense: true,
                                    child: ExpansionTile(
                                      // key: UniqueKey(),
                                      // initiallyExpanded: _isExpanded,
                                      tilePadding: const EdgeInsets.symmetric(horizontal: 8,vertical: 0),
                                      controller: tagItExpansionTile,
                                                              
                                      maintainState: true,
                                      // backgroundColor: Colors.red,
                                      // collapsedBackgroundColor: Colors.yellow,
                                      // shape: roundedBorderCustom(sunscriptionValue: appConstants.userModel.subScriptionValue),
                                      // collapsedShape: roundedBorderCustom(sunscriptionValue: appConstants.userModel.subScriptionValue),
                                      initiallyExpanded: isExpandedtagItExpansionTile,
                                      onExpansionChanged: (isExpanded) {
                                        setState(() {
                                          isExpandedtagItExpansionTile = isExpanded;
                                        });
                                      },
                                      childrenPadding: getCustomPadding(),
                                      iconColor: green,
                                      // trailing:Icon(
                                      //         Icons.done,
                                      //         color: grey.withValues(alpha:0.6),
                                      //       ),
                                      // initiallyExpanded: appConstants.userModel.subScriptionValue==2?false:true ,
                                      title: Text(
                                        'Tag-It',
                                        style: heading1TextStyle(context, width),
                                      ),
                                      children: [
                                        ListView.builder(
                                          itemCount: AppConstants.tagItList.length,
                                          shrinkWrap: true,
                                          physics: const NeverScrollableScrollPhysics(),
                                          itemBuilder: (BuildContext context, int index) {
                                            return
                                            AppConstants.tagItList[index].publicTag_it ==
                                                    false
                                                ? const SizedBox()
                                                : 
                                             CheckboxListTile(
                                              controlAffinity: ListTileControlAffinity.leading,
                                              contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                                              dense: true,
                                              visualDensity: VisualDensity.compact,
                                              title: Text(AppConstants.tagItList[index].title.toString(), style: heading3TextStyle(width),),
                                              value: AppConstants.tagItList[index].isSelected,
                                              fillColor: WidgetStateProperty.all(AppConstants.tagItList[index].isSelected!? green: white),
                                              // checkColor: green,
                                              onChanged: (bool? value) {
                                                setState(() {
                                                  AppConstants.tagItList[index].isSelected = value!;
                                                });
                                            });
                                          },
                                        ),
                                        // InlineChoice<String>.multiple(
                                        //   // clearable: false,
                                        //   // value: selectedValue,
                                        //   value: queryList,
                                        //   // onChanged: setSelectedValue,
                                        //   itemCount: AppConstants.tagItList.length,
                                                              
                                        //   // onChanged: (List<String> list){
                                        //   //   logMethod(title: 'Selected Data', message: queryList.toString());
                                        //   //   queryList.addAll(list);
                                        //   //   setState(() {
                                        //   //     // queryList =  list;
                                        //   //   });
                                        //   // },
                                        //   itemBuilder: (state, i) {
                                        //     return AppConstants.tagItList[i].enabled ==
                                        //             false
                                        //         ? const SizedBox()
                                        //         : Container(
                                        //             decoration: BoxDecoration(
                                        //                 color: selectedTagit == i
                                        //                     ? green
                                        //                     : transparent,
                                        //                 borderRadius: BorderRadius.circular(
                                        //                     width * 0.2)),
                                        //             child: ChoiceChip(
                                        //               selected: state.selected(AppConstants
                                        //                   .tagItList[i].id
                                        //                   .toString()),
                                        //               showCheckmark: true,
                                        //               onSelected: state.onSelected(
                                        //                   AppConstants.tagItList[i].title
                                        //                       .toString(),
                                        //                   onChanged: (List<String> item) {
                                        //                 // logMethod(title: 'List After selecting', message: item.toString());
                                        //                 setState(() {
                                        //                   selectedTagit = i;
                                        //                   // String? selectedDateType;
                                        //                   // String? selectedTransaction;
                                        //                 });
                                        //               }),
                                        //               label: Text(AppConstants
                                        //                   .tagItList[i].title
                                        //                   .toString()),
                                        //               avatar: Icon(
                                        //                 AppConstants.tagItList[i].icon,
                                        //                 size: 14,
                                        //               ),
                                        //               selectedColor: orange,
                                        //             ),
                                        //           );
                                        //   },
                                        //   listBuilder: ChoiceList.createWrapped(
                                        //     spacing: 10,
                                        //     runSpacing: 10,
                                        //     padding: const EdgeInsets.symmetric(
                                        //       horizontal: 10,
                                        //       vertical: 10,
                                        //     ),
                                        //   ),
                                        // ),
                                      
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              spacing_medium,
                              // CustomDivider(),
                              Container(
                                decoration: expansionBoxDecoration(),
                                child: Theme(
                                  data: Theme.of(context)
                                      .copyWith(dividerColor: transparent),
                                  child: ListTileTheme(
                                  contentPadding: EdgeInsets.all(0),
                                  dense: true,
                                    child: ExpansionTile(
                                      tilePadding: const EdgeInsets.symmetric(horizontal: 8,vertical: 0),
                                      // key: UniqueKey(),
                                      // initiallyExpanded: _isExpanded,
                                      controller: walletExpansionTile,
                                      // maintainState: true,
                                      // backgroundColor: Colors.red,
                                      // collapsedBackgroundColor: Colors.yellow,
                                      // shape: roundedBorderCustom(sunscriptionValue: appConstants.userModel.subScriptionValue),
                                      // collapsedShape: roundedBorderCustom(sunscriptionValue: appConstants.userModel.subScriptionValue),
                                      initiallyExpanded: isExpandedwalletExpansionTile,
                                      onExpansionChanged: (isExpanded) {
                                        setState(() {
                                          isExpandedwalletExpansionTile = isExpanded;
                                        });
                                      },
                                      childrenPadding: getCustomPadding(),
                                      iconColor: green,
                                      // trailing:Icon(
                                      //         Icons.done,
                                      //         color: grey.withValues(alpha:0.6),
                                      //       ),
                                      // initiallyExpanded: appConstants.userModel.subScriptionValue==2?false:true ,
                                      title: Text(
                                        'Wallet',
                                        style: heading1TextStyle(context, width),
                                      ),
                                      children: [
                                        // Column(
                                        //   children: [
                                        //     ListView.builder(
                                        //       itemCount: 3,
                                        //       shrinkWrap: true,
                                        //       physics: NeverScrollableScrollPhysics(),
                                        //       itemBuilder: (BuildContext context, int index) {
                                        //         return Text('List value: $index');
                                        //       },
                                        //     ),
                                        //   ],
                                        // ),
                                        ListView.builder(
                                          itemCount: allWalletName.length,
                                          shrinkWrap: true,
                                          physics: BouncingScrollPhysics(),
                                          // scrollDirection: Axis.vertical,
                                          itemBuilder: (context, index){
                                            return CheckboxListTile(
                                              controlAffinity: ListTileControlAffinity.leading,
                                              contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                                              dense: true,
                                              visualDensity: VisualDensity.compact,
                                              title: Text(allWalletName[index].title, style: heading3TextStyle(width),),
                                              value: allWalletName[index].isChecked,
                                              fillColor: WidgetStateProperty.all(allWalletName[index].isChecked? green: white),
                                              // checkColor: green,
                                              onChanged: (bool? value) {
                                                setState(() {
                                                  allWalletName[index].isChecked = value!;
                                                });
                                            });
                                          }),
                                        // Row(
                                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        //   children: [
                                        //     DropdownButton<String>(
                                        //       value: walletName,
                                        //       onChanged: (String? newValue) {
                                        //         setState(() {
                                        //           walletName = newValue!;
                                        //         });
                                        //       },
                                        //       items: <String>[
                                        //         'All',
                                        //         (appConstants.nickNameModel
                                        //                         .NickN_SpendWallet !=
                                        //                     null &&
                                        //                 appConstants.nickNameModel
                                        //                         .NickN_SpendWallet !=
                                        //                     "")
                                        //             ? appConstants
                                        //                 .nickNameModel.NickN_SpendWallet!
                                        //             : 'Spend-' + 'Wallet',
                                        //         (appConstants.nickNameModel
                                        //                         .NickN_SavingWallet !=
                                        //                     null &&
                                        //                 appConstants.nickNameModel
                                        //                         .NickN_SavingWallet !=
                                        //                     "")
                                        //             ? appConstants.nickNameModel
                                        //                     .NickN_SavingWallet! +
                                        //                 'Wallet'
                                        //             : 'Savings-'.tr() + 'Wallet',
                                        //         (appConstants.nickNameModel
                                        //                         .NickN_DonationWallet !=
                                        //                     null &&
                                        //                 appConstants.nickNameModel
                                        //                         .NickN_DonationWallet !=
                                        //                     "")
                                        //             ? appConstants.nickNameModel
                                        //                     .NickN_DonationWallet! +
                                        //                 ' Wallet'
                                        //             : 'Charity-'.tr() + "Wallet",
                                        //         'Goals-Wallet'
                                        //       ].map<DropdownMenuItem<String>>(
                                        //           (String value) {
                                        //         return DropdownMenuItem<String>(
                                        //           value: value,
                                        //           child: Text(value),
                                        //         );
                                        //       }).toList(),
                                        //     ),
                                        //   ],
                                        // ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              spacing_medium,
                              // CustomDivider(),
                              Container(
                                decoration: expansionBoxDecoration(),
                                child: Theme(
                                  data: Theme.of(context)
                                      .copyWith(dividerColor: transparent),
                                  child: ListTileTheme(
                                  contentPadding: EdgeInsets.all(0),
                                  dense: true,
                                    child: ExpansionTile(
                                      tilePadding: const EdgeInsets.symmetric(horizontal: 8,vertical: 0),
                                      controller: dateExpansionTile,
                                      maintainState: true,
                                      initiallyExpanded: isExpandeddateExpansionTile,
                                      onExpansionChanged: (isExpanded) {
                                        setState(() {
                                          isExpandeddateExpansionTile = isExpanded;
                                        });
                                      },
                                      childrenPadding: getCustomPadding(),
                                      iconColor: green,
                                      // trailing:Icon(
                                      //         Icons.done,
                                      //         color: grey.withValues(alpha:0.6),
                                      //       ),
                                      // initiallyExpanded: appConstants.userModel.subScriptionValue==2?false:true ,
                                      title: Text(
                                        'Date',
                                        style: heading1TextStyle(context, width),
                                      ),
                                      children: [
                                        
                                        ListView.builder(
                                          itemCount: allDateName.length,
                                          shrinkWrap: true,
                                          physics: BouncingScrollPhysics(),
                                          itemBuilder: (BuildContext context, int index) {
                                            return RadioListTile<String>(
                                              fillColor: WidgetStateProperty.all(
                                                (_selectedDateIndex==4 && selectedDateType == 'nocustom')? orange:green,
                                                // selectedDateType == 'nocustom'? orange: green
                                                      ),
                                              // tileColor: orange,
                                              // tileColor: ,
                                              selectedTileColor: (_selectedDateIndex==4 && selectedDateType == 'nocustom')? orange:green,
                                  title: Text(
                                    allDateName[index].title,
                                    style: heading3TextStyle(width),
                                  ),
                                  value: index.toString(),
                                  groupValue: _selectedDateIndex.toString(),
                                  // selectedTileColor: _selectedDateIndex==4? orange:null,
                                  onChanged: (String? value) async{
                                    if (value != null) {
                                      if (value=='0') {
                                        selectedDateType = '7';
                                        endDate = DateTime.now();
                                        startDate = DateTime.now()
                                            .subtract(Duration(days: 7));
                                      }
                                      if (value=='1') {
                                        selectedDateType = '30';
                                                  endDate = DateTime.now();
                                                  startDate = DateTime.now()
                                                      .subtract(Duration(days: 30));
                                      }
                                      if (value=='2') {
                                        selectedDateType = '90';
                                                  endDate = DateTime.now();
                                                  startDate = DateTime.now()
                                                      .subtract(Duration(days: 90));
                                      }
                                      if (value=='3') {
                                        selectedDateType = '180';
                                                  endDate = DateTime.now();
                                                  startDate = DateTime.now()
                                                      .subtract(Duration(days: 180));
                                      }
                                      if (value=='4') {
                                        DateTimeRange? picked =
                                                      await showDateRangePicker(
                                                          context: context,
                                                          firstDate: DateTime(
                                                              DateTime.now().year - 5),
                                                          lastDate: DateTime(
                                                              DateTime.now().year + 5),
                                                          initialDateRange: DateTimeRange(
                                                            end: DateTime(
                                                                DateTime.now().year,
                                                                DateTime.now().month,
                                                                DateTime.now().day + 13),
                                                            start: DateTime.now(),
                                                          ),
                                                          builder: (context, child) {
                                                              return Theme(
                                                                data: Theme.of(context).copyWith(
                                                                  colorScheme: ColorScheme.light(
                                                                    primary: green,
                                                                  ),
                                                                ),
                                                                child: child!,
                                                              );
                                                            },
                                                          // builder: (context, child) {
                                                          //   return Column(
                                                          //     children: [
                                                          //       ConstrainedBox(
                                                          //         constraints:
                                                          //             BoxConstraints(
                                                          //           maxWidth: 400.0,
                                                          //         ),
                                                          //         child: child,
                                                          //       )
                                                          //     ],
                                                          //   );
                                                          // }
                                                          );
                                                  if (picked != null) {
                                                    // logMethod(title: 'Selected Date Range', message: picked.toString());
                                                    setState(() {
                                                      selectedDateType = 'custom';
                                                      startDate = picked.start;
                                                      endDate = picked.end;
                                                    });
                                                  }
                                                  else{
                                                    // if (picked != null) {
                                                    // logMethod(title: 'Selected Date Range', message: picked.toString());
                                                    setState(() {
                                                      selectedDateType = 'nocustom';
                                                    });
                                                  // }
                                                  }
                                      }

                                      setState(() {
                                      _selectedDateIndex=int.parse(value);
                                                });
                                      logMethod(title: 'Selected Index', message: value);
                                      // itemModel.selectItem(value);
                                    }
                                  },
                                  activeColor: Colors.blue,
                                );
                                          },
                                        ),
                              if(selectedDateType == 'custom')
                              Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(formatedDateWithMonth(date: startDate), style: heading4TextSmall(width),),
                                      Text(formatedDateWithMonth(date: endDate), style: heading4TextSmall(width),),
                                    ],
                                  ),
                                  spacing_medium
                                ],
                              )
                      
                                        // Row(
                                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        //   children: [
                                        //     // ZakiCicularButton(
                                        //     //   title: '7 days',
                                        //     //   width: width,
                                        //     //   borderColor:
                                        //     //       selectedDateType == '7' ? orange : null,
                                        //     //   onPressed: () {
                                                
                                        //     //   },
                                        //     // ),
                                        //     // ZakiCicularButton(
                                        //     //   title: '30 days',
                                        //     //   width: width,
                                        //     //   borderColor:
                                        //     //       selectedDateType == '30' ? orange : null,
                                        //     //   onPressed: () {
                                        //     //     setState(() {
                                                  
                                        //     //     });
                                        //     //   },
                                        //     // ),
                                        //     // ZakiCicularButton(
                                        //     //   title: '90 days',
                                        //     //   width: width,
                                        //     //   borderColor:
                                        //     //       selectedDateType == '90' ? orange : null,
                                        //     //   onPressed: () {
                                        //     //     setState(() {
                                                  
                                        //     //     });
                                        //     //   },
                                        //     // ),
                                        //     // ZakiCicularButton(
                                        //     //   title: '180 days',
                                        //     //   borderColor:
                                        //     //       selectedDateType == '180' ? orange : null,
                                        //     //   width: width,
                                        //     //   onPressed: () {
                                        //     //     setState(() {
                                                  
                                        //     //     });
                                        //     //   },
                                        //     // ),
                                        //   ],
                                        // ),
                                        // Row(
                                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        //   children: [
                                        //     TextHeader1(
                                        //       title: 'Choose Date Range',
                                        //     ),
                                        //     IconButton(
                                        //         icon: Icon(
                                        //           Icons.date_range_outlined,
                                        //           color: selectedDateType == 'custom'
                                        //               ? orange
                                        //               : null,
                                        //         ),
                                        //         onPressed: () async {
                                        //           DateTimeRange? picked =
                                        //               await showDateRangePicker(
                                        //                   context: context,
                                        //                   firstDate: DateTime(
                                        //                       DateTime.now().year - 5),
                                        //                   lastDate: DateTime(
                                        //                       DateTime.now().year + 5),
                                        //                   initialDateRange: DateTimeRange(
                                        //                     end: DateTime(
                                        //                         DateTime.now().year,
                                        //                         DateTime.now().month,
                                        //                         DateTime.now().day + 13),
                                        //                     start: DateTime.now(),
                                        //                   ),
                                        //                   builder: (context, child) {
                                        //                       return Theme(
                                        //                         data: Theme.of(context).copyWith(
                                        //                           colorScheme: ColorScheme.light(
                                        //                             primary: green,
                                        //                           ),
                                        //                         ),
                                        //                         child: child!,
                                        //                       );
                                        //                     },
                                        //                   // builder: (context, child) {
                                        //                   //   return Column(
                                        //                   //     children: [
                                        //                   //       ConstrainedBox(
                                        //                   //         constraints:
                                        //                   //             BoxConstraints(
                                        //                   //           maxWidth: 400.0,
                                        //                   //         ),
                                        //                   //         child: child,
                                        //                   //       )
                                        //                   //     ],
                                        //                   //   );
                                        //                   // }
                                        //                   );
                                        //           if (picked != null) {
                                        //             // logMethod(title: 'Selected Date Range', message: picked.toString());
                                        //             setState(() {
                                        //               selectedDateType = 'custom';
                                        //               startDate = picked.start;
                                        //               endDate = picked.end;
                                        //             });
                                        //           }
                                        //         })
                                        //   ],
                                        // ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              // CustomDivider(),
                              spacing_medium,
                              Container(
                                decoration: expansionBoxDecoration(),
                                child: Theme(
                                  data: Theme.of(context)
                                      .copyWith(dividerColor: transparent),
                                  child: ListTileTheme(
                                  contentPadding: EdgeInsets.all(0),
                                  dense: true,
                                    child: ExpansionTile(
                                      tilePadding: const EdgeInsets.symmetric(horizontal: 8,vertical: 0),
                                      // key: UniqueKey(),
                                      // initiallyExpanded: _isExpanded,
                                      controller: transactionTypeExpansionTile,
                                      maintainState: true,
                                      initiallyExpanded: isExpandedtransactionTypeExpansionTile,
                                      onExpansionChanged: (isExpanded) {
                                        setState(() {
                                          isExpandedtransactionTypeExpansionTile = isExpanded;
                                        });
                                      },
                                      childrenPadding: getCustomPadding(),
                                      iconColor: green,
                                      // trailing:Icon(
                                      //         Icons.done,
                                      //         color: grey.withValues(alpha:0.6),
                                      //       ),
                                      // initiallyExpanded: appConstants.userModel.subScriptionValue==2?false:true ,
                                      title: Text(
                                        'Activity Type',
                                        style: heading1TextStyle(context, width),
                                      ),
                                      children: [
                                        ListView.builder(
                                          itemCount: AppConstants.tagItList.length,
                                          shrinkWrap: true,
                                          physics: const NeverScrollableScrollPhysics(),
                                          itemBuilder: (BuildContext context, int index) {
                                            return
                                            AppConstants.tagItList[index].publicTag_it !=
                                                    false
                                                ? const SizedBox()
                                                : 
                                             CheckboxListTile(
                                              controlAffinity: ListTileControlAffinity.leading,
                                              contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                                              dense: true,
                                              visualDensity: VisualDensity.compact,
                                              title:  Text( AppConstants.tagItList[index].fullName?? AppConstants.tagItList[index].title.toString(), style: heading3TextStyle(width),),
                                              value: AppConstants.tagItList[index].isSelected,
                                              fillColor: WidgetStateProperty.all(AppConstants.tagItList[index].isSelected==true? green: white),
                                              // checkColor: green,
                                              onChanged: (bool? value) {
                                                setState(() {
                                                  AppConstants.tagItList[index].isSelected = value!;
                                                });
                                            });
                                          },
                                        ),
                                        // InlineChoice<String>.multiple(
                                        //   clearable: false,
                                        //   // value: selectedValue,
                                        //   // onChanged: setSelectedValue,
                                        //   itemCount: AppConstants.TRANSACTION_LIST.length,
                                                              
                                        //   onChanged: (List<String> list) {
                                        //     // logMethod(title: 'Selected Data', message: list.toString());
                                        //     setState(() {
                                        //       // queryList = list;
                                        //     });
                                        //   },
                                        //   itemBuilder: (state, i) {
                                        //     return Container(
                                        //       decoration: BoxDecoration(
                                        //           color: selectedTransaction == i
                                        //               ? green
                                        //               : transparent,
                                        //           borderRadius:
                                        //               BorderRadius.circular(width * 0.1)),
                                        //       child: ChoiceChip(
                                        //         selected: state.selected(AppConstants
                                        //             .TRANSACTION_LIST[i]
                                        //             .toString()),
                                        //         onSelected: state.onSelected(
                                        //             AppConstants.TRANSACTION_LIST[i]
                                        //                 .toString(),
                                        //             onChanged: (List<String> list) {
                                        //           setState(() {
                                        //             selectedTransaction = i;
                                        //           });
                                        //         }),
                                        //         label: Text(AppConstants.TRANSACTION_LIST[i]
                                        //             .toString()),
                                        //       ),
                                        //     );
                                        //   },
                                        //   listBuilder: ChoiceList.createWrapped(
                                        //     spacing: 10,
                                        //     runSpacing: 10,
                                        //     padding: const EdgeInsets.symmetric(
                                        //       horizontal: 10,
                                        //       vertical: 10,
                                        //     ),
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              spacing_medium,
                              Container(
                                decoration: expansionBoxDecoration(),
                                child: Theme(
                                  data: Theme.of(context)
                                      .copyWith(dividerColor: transparent),
                                  child: ListTileTheme(
                                  contentPadding: EdgeInsets.all(0),
                                  dense: true,
                                    child: ExpansionTile(
                                      tilePadding: const EdgeInsets.symmetric(horizontal: 8,vertical: 0),
                                      // key: UniqueKey(),
                                      // initiallyExpanded: _isExpanded,
                                      controller: minAndMaxExpansionTile,
                                      maintainState: true,
                                      initiallyExpanded: isExpandedminAndMaxExpansionTile,
                                      onExpansionChanged: (isExpanded) {
                                        setState(() {
                                          isExpandedminAndMaxExpansionTile = isExpanded;
                                        });
                                      },
                                      childrenPadding: getCustomPadding(),
                                      iconColor: green,
                                      // trailing:Icon(
                                      //         Icons.done,
                                      //         color: grey.withValues(alpha:0.6),
                                      //       ),
                                      // initiallyExpanded: appConstants.userModel.subScriptionValue==2?false:true ,
                                      title: Text(
                                        'Price Range',
                                        style: heading1TextStyle(context, width),
                                      ),
                                      children: [
                                        spacing_medium,
                                        Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: RichText(
      text: TextSpan(
        text: 'Min ',
        style: heading3TextStyle( width),
        children: [
          TextSpan(
            text:'(${getCurrencySymbol(context, appConstants: appConstants)}):',
            style: heading5TextSmall(width, bold: false))
                  ]
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (String? name) {
                          if (name!.isEmpty) {
                            return 'Empty';
                          } else {
                            return null;
                          }
                        },
                        // style: TextStyle(color: primaryColor),
                        style: heading3TextStyle(width, color: green),
                        controller: minPriceTextController,
                        obscureText: false,
                        keyboardType: TextInputType.number,
                        // maxLines: 1,
                        maxLength: 5,
                        onChanged: (String min) {},
                        decoration: InputDecoration(
                          border: circularOutLineBorder,
                          enabledBorder: circularOutLineBorder,
                          counterText: "",
                          isDense: true,
                          contentPadding: EdgeInsets.all(8),
                          // hintText: 'Legal First Name',
                          hintStyle: heading3TextStyle(width, color: green),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: const SizedBox(
                        width: 10,
                      ),
                    ),
                    
                  ],
                ),
                spacing_small,
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: RichText(
      text: TextSpan(
        text: 'Max ',
        style: heading3TextStyle(width),
        children: [
          TextSpan(
            text:'(${getCurrencySymbol(context, appConstants: appConstants)}):',
            style: heading5TextSmall(width, bold: false))
                  ]
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (String? name) {
                          if (name!.isEmpty) {
                            return 'Empty';
                          } else {
                            return null;
                          }
                        },
                        // style: TextStyle(color: primaryColor),
                        style: heading3TextStyle(width, color: green),
                        controller: maxPriceTextController,
                        obscureText: false,
                        keyboardType: TextInputType.number,
                        maxLines: 1,
                        maxLength: 5,
                        onChanged: (String max) {},
                        decoration: InputDecoration(
                          border: circularOutLineBorder,
                          enabledBorder: circularOutLineBorder,
                          counterText: "",
                          isDense: true,
                          contentPadding: EdgeInsets.all(8),
                          // hintText: 'Legal First Name',
                          hintStyle: heading3TextStyle(width, color: green),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: SizedBox(
                        width: 10,
                      )
                      
                    ),
                  ],
                ),
                                        // RangeSlider(
                                        //   values: RangeValues(minPrice, maxPrice),
                                        //   min: 0,
                                        //   max: 5000,
                                        //   divisions: 100,
                                        //   labels: RangeLabels('$minPrice', '$maxPrice'),
                                        //   onChanged: (RangeValues newRange) {
                                        //     setState(() {
                                        //       minPrice = newRange.start;
                                        //       maxPrice = newRange.end;
                                        //     });
                                        //   },
                                        // ),
                                        
                                        spacing_medium,
                                        
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              // CustomDivider(),
                          // spacing_X_large,
                           
                              // RangeSlider(
                              //   values: RangeValues(minPrice, maxPrice),
                              //   min: 0,
                              //   max: 5000,
                              //   divisions: 100,
                              //   labels: RangeLabels('$minPrice', '$maxPrice'),
                              //   onChanged: (RangeValues newRange) {
                              //     setState(() {
                              //       minPrice = newRange.start;
                              //       maxPrice = newRange.end;
                              //     });
                              //   },
                              // ),
                              // SwitchListTile(
                              //   title: Text("Only Available"),
                              //   value: onlyAvailable,
                              //   onChanged: (bool value) {
                              //     setState(() {
                              //       onlyAvailable = value;
                              //     });
                              //   },
                              // ),
                          
                              //             StreamBuilder<List<Item>>(
                              //               // stream: ApiServices(). fetchTransactions(categoryFilter: walletName,minPrice: minPrice, maxPrice: maxPrice, onlyAvailable: onlyAvailable, transactionTagitCategory: 'Fund_My_Wallet'),
                              //               stream: ApiServices().fetchTransactions(transactionTagitCategory: queryList, userId: appConstants.userRegisteredId, maxPrice: maxPrice, minPrice: minPrice, walletName: walletName, startDate: startDate, endDate: endDate, selectedUserId: selectedUserIdForFav),
                              //               builder: (context, snapshot) {
                              // if (snapshot.connectionState == ConnectionState.waiting) {
                              //   return Center(child: CircularProgressIndicator());
                              // }
                              // if (!snapshot.hasData) {
                              //   return Center(child: Text('No items found'));
                              // }
                              // var items = snapshot.data!;
                              // return ListView.builder(
                              //   itemCount: items.length,
                              //   shrinkWrap: true,
                              //   physics: const NeverScrollableScrollPhysics(),
                              //   itemBuilder: (context, index) {
                              //     return ListTile(
                              //       title: Text(items[index].transactionAmount.toString()),
                              //       subtitle: Text('${items[index].transactionFromWallet} - \$${items[index].transactionTagitCategory}'),
                              //     );
                              //   },
                              // );
                              //               },
                              //             ),
                            ],
                          ),
                        ),
                      ),
                    ),
                     Padding(
                       padding: getCustomPadding(),
                       child: Column(
                         children: [
                          spacing_small,
                           Row(
                                children: [
                                  Expanded(
                                    child: ZakiPrimaryButton(
                                      title: 'Clear All',
                                      width: width * 0.5,
                                      backgroundTransparent: 1,
                                      textColor: grey,
                                      onPressed: () {
                                        AppConstants.tagItList.forEach((element) {
                                          element.isSelected=false;
                                        });
                                        allWalletName.forEach((element) {
                                          element.isChecked=false;
                                        });
                                        minPriceTextController.clear();
                                        maxPriceTextController.clear();
                                        // clear();
                                        setState(() {
                                          fullTransactions = filteredFullTransactions;
                                          fullTransactions!.clear();
                                          fullTransactions!.addAll(fullTransactionsClear!);
                                          queryList = [];
                                          walletName = 'All';
                                          // minPrice = 0;
                                          // maxPrice = 1000;
                                          onlyAvailable = false;
                                          selectedUserIdForFav = null;
                                          selectedTagit = null;
                                          selectedDateType = null;
                                          selectedTransaction = null;
                                          selectedValue = null;
                                          startDate = null;
                                          endDate = null;
                                          filterApply = false;
                                          
                                          allTransactions = ApiServices().fetchTransactions(
                                              transactionTagitCategory: queryList,
                                              userId: appConstants.userRegisteredId,
                                              maxPrice: maxPrice,
                                              minPrice: minPrice,
                                              walletName: walletName,
                                              startDate: startDate,
                                              endDate: endDate,
                                              selectedUserId: selectedUserIdForFav);
                                        });
                                        // Navigator.pop(context);
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: ZakiPrimaryButton(
                                      title: 'View',
                                      width: width * 0.4,
                                      onPressed: () async {
                                        AppConstants.tagItList.forEach((element) {
                                          if(element.publicTag_it!=false)
                                          if(element.isSelected==true)
                                          logMethod(
                                            title: 'Tag -It checked Name',
                                            message:
                                                "${element.title}");
                                        });
                                        allWalletName.forEach((element) {
                                          if(element.isChecked==true)
                                          logMethod(
                                            title: 'Wallet checked Name',
                                            message:
                                                "${element.title}");
                                        });
                           
                                        AppConstants.tagItList.forEach((element) {
                                          // AppConstants.tagItList[index].enabled
                                          if(element.publicTag_it==false)
                                          if(element.isSelected==true)
                                          logMethod(
                                            title: 'Activity Type Name',
                                            message:
                                                "${element.title}");
                                        });
                                        logMethod(
                                            title: 'All Values',
                                            message:
                                                "Apply Filter: $filterApply selecte Wallet: $walletName, selectedUserId: $selectedUserId, tagit: $queryList, startDate: ${startDate}, endDate: ${endDate}");
                                        setState(() {
                                          filterApply = true;
                                        });
                                        Navigator.pop(context, "Closed");
                                      },
                                    ),
                                  ),
                                ],
                              ),
                         ],
                       ),
                     ),
                     spacing_small
                  ],
                ),
                // actions: <Widget>[
                //   TextButton(
                //     child: Text('Apply'),
                //     onPressed: () {
                //       Navigator.of(context).pop();
                //       // Here, you can process the filterValues as you need
                //     },
                //   ),
                // ],
              );
            },
          );
        });
    return selecetd != null ? 'data' : '';
  }

  BoxDecoration expansionBoxDecoration() {
    return BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                        color: grey.withValues(alpha:0.5),
                        width: 1)
                            );
  }

  @override
  Widget build(BuildContext context) {
    var appConstants = Provider.of<AppConstants>(context, listen: true);
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      // backgroundColor: grey.withValues(alpha:0.98),
      floatingActionButton: CustomFloadtingActionButton(),
      bottomNavigationBar: CustomBottomNavigationBar(),
      body: 
       
       SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: getCustomPadding(),
              child: appBarHeader_005(
                  context: context,
                  appBarTitle: 'Money Activities',
                  backArrow: true,
                  height: height,
                  width: width),
            ),

            ///////Todo Logic
            if (appConstants.userModel.usaUserType ==
                AppConstants.USER_TYPE_PARENT)
              Container(
                color: orange.withValues(alpha:0.05),
                width: width,
                child: Padding(
                  padding: getCustomPadding(),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: height * 0.127,
                          child: Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: InkWell(
                              onTap: () async {
                                if (selectedUserId !=
                                    appConstants.userRegisteredId) {
                                  setState(() {
                                    // fullTransactions = filteredFullTransactions;
                                    fullTransactions!.clear();
                                    isLoading = true;
                                    selectedIndex = -1;
                                    selectedUserId =
                                        appConstants.userRegisteredId;
                                    selectedUserBankId = appConstants.userModel.userTokenId;
                                  });
                                  appConstants.updateStartIndex(0);
                                await cardTransactionsFromApi(
                                  appConstants: appConstants,
                                      actingUserToken: appConstants.userModel.userTokenId,
                                      userToken: appConstants.userModel.userTokenId,
                                      startIndex: 0,
                                      limit:limit,
                                );


                                  await getUserTransaction(
                                      appConstants.userRegisteredId);
                                  // getCardTrnsactions(
                                  //     actingUserToken:
                                  //         appConstants.userModel.userTokenId,
                                  //     userToken:
                                  //         appConstants.userModel.userTokenId,
                                  //     appConstants: appConstants);
                                  userCardInfo(
                                      appConstants.userRegisteredId,
                                      appConstants.userModel.userFamilyId
                                          .toString());
                                  setState(() {
                                    isLoading = false;
                                  });
                                }
                              },
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
                                          border: Border.all(
                                              width:
                                                  selectedIndex == -1 ? 2 : 0,
                                              color: selectedIndex == -1
                                                  ? orange
                                                  : transparent),
                                          boxShadow: selectedIndex != -1
                                              ? null
                                              : [
                                                  customBoxShadow(color: orange)
                                                ],
                                        ),
                                        child: Padding(
                                            padding: const EdgeInsets.all(0.0),
                                            child: userImage(
                                                imageUrl: appConstants
                                                    .userModel.usaLogo!,
                                                userType: appConstants
                                                    .userModel.usaUserType,
                                                width: width * 0.6,
                                                gender: appConstants
                                                    .userModel.usaGender)),
                                      ),
                                      if (selectedIndex != -1)
                                        UnSelectedKidsWidget()
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    '@ ' +
                                        appConstants.userModel.usaUserName
                                            .toString(),
                                    // overflow: TextOverflow.clip,
                                    // maxLines: 1,
                                    style: heading5TextSmall(width),
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
                                height: height * 0.127,
                                // width: width,
                                child: StreamBuilder<QuerySnapshot>(
                                  stream: userKids,
                                  builder: (BuildContext context,
                                      AsyncSnapshot<QuerySnapshot> snapshot) {
                                    if (snapshot.hasError) {
                                      return const Text(
                                          'Ooops...Something went wrong :(');
                                    }
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Center(
                                          child: CustomLoader(
                                              // color: green,
                                              ));
                                    }
                                    if (snapshot.data!.size == 0) {}
                                    //snapshot.data!.docs[index] ['USA_first_name']
                                    return ListView.builder(
                                      itemCount: snapshot.data!.docs.length,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        // print(snapshot.data!.docs[index] ['USA_first_name']);
                                        return
                                            // snapshot.data!.docs[index][
                                            //               AppConstants
                                            //                   .NewMember_isEnabled] ==
                                            //           false ||
                                            (snapshot.data!.docs[index][
                                                        AppConstants
                                                            .USER_UserType] !=
                                                    AppConstants.USER_TYPE_KID)
                                                ? const SizedBox.shrink()
                                                : InkWell(
                                                    onTap: () async {
                                                      // // appConstants.updateAllowanceSchedule(snapshot.data!.docs[index]['USER_allowance_schedule']);
                                                      // ApiServices services = ApiServices();
                                                      // dynamic kidData = await services.fetchUserKidWithFuture(snapshot.data!.docs[index].id);
                                                      // print("This document id: ${snapshot.data!.docs[index].id}");
                                                      if (selectedUserId !=
                                                          snapshot.data!
                                                              .docs[index].id) {
                                                        setState(() {
                                                          fullTransactions!.clear();
                                                          selectedIndex = index;
                                                          selectedUserId =
                                                              snapshot
                                                                  .data!
                                                                  .docs[index]
                                                                  .id;
                                                          isLoading = true;
                                                          selectedUserBankId = appConstants.userModel.userTokenId;
                                                          // selectedKidId = snapshot.data!.docs[index].id;
                                                        });
                                                      appConstants.updateStartIndex(0);
                                                      cardTransactionsFromApi(
                                                        appConstants: appConstants,
                                                            actingUserToken: snapshot.data!.docs[index][AppConstants.USER_BankAccountID],
                                                            userToken: snapshot.data!.docs[index][AppConstants.USER_BankAccountID],
                                                            startIndex: 0,
                                                            limit:limit,
                                                      );
                                                      
                                                        await getUserTransaction(
                                                            snapshot
                                                                .data!
                                                                .docs[index]
                                                                .id);
                                                        
                                                        // await getCardTrnsactions(
                                                        //     actingUserToken: snapshot
                                                        //             .data!
                                                        //             .docs[index]
                                                        //         [AppConstants
                                                        //             .USER_BankAccountID],
                                                        //     userToken: snapshot
                                                        //             .data!
                                                        //             .docs[index]
                                                        //         [AppConstants
                                                        //             .USER_BankAccountID],
                                                        //     appConstants:
                                                        //         appConstants);
                                                        await userCardInfo(
                                                            selectedUserId
                                                                .toString(),
                                                            appConstants
                                                                .userModel
                                                                .userFamilyId
                                                                .toString());
                                                        setState(() {
                                                          isLoading = false;
                                                        });
                                                        // ApiServices().addMoneyToSelectedMainWallet(receivedUserId: selectedKidId, senderId: appConstants.userRegisteredId);
                                                        // });
                                                      }
                                                    },
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 12.0),
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
                                                                              index
                                                                          ? 2
                                                                          : 0,
                                                                      color: selectedIndex ==
                                                                              index
                                                                          ? orange
                                                                          : transparent),
                                                                  boxShadow:
                                                                      selectedIndex !=
                                                                              index
                                                                          ? null
                                                                          : [
                                                                              customBoxShadow(color: orange)
                                                                            ],
                                                                ),
                                                                child: Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(
                                                                            0.0),
                                                                    child:
                                                                        userImage(
                                                                      imageUrl: snapshot
                                                                              .data!
                                                                              .docs[index]
                                                                          [
                                                                          AppConstants
                                                                              .USER_Logo],
                                                                      userType: snapshot
                                                                              .data!
                                                                              .docs[index]
                                                                          [
                                                                          AppConstants
                                                                              .USER_UserType],
                                                                      width:
                                                                          width,
                                                                      gender: snapshot
                                                                              .data!
                                                                              .docs[index]
                                                                          [
                                                                          AppConstants
                                                                              .USER_gender],
                                                                    )),
                                                              ),
                                                              if (selectedIndex !=
                                                                  index)
                                                                UnSelectedKidsWidget()
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            height: 5,
                                                          ),
                                                          SizedBox(
                                                            // width: height * 0.065,
                                                            child: Center(
                                                              child: Text(
                                                                (snapshot.data!.docs[index][AppConstants.USER_user_name] ==
                                                                            null ||
                                                                        snapshot.data!.docs[index][AppConstants.USER_user_name] ==
                                                                            '')
                                                                    ? snapshot
                                                                            .data!
                                                                            .docs[index]
                                                                        [
                                                                        AppConstants
                                                                            .USER_first_name]
                                                                    : '@ ' +
                                                                        snapshot
                                                                            .data!
                                                                            .docs[index][AppConstants.USER_user_name],
                                                                overflow:
                                                                    TextOverflow
                                                                        .fade,
                                                                maxLines: 1,
                                                                style:
                                                                    heading5TextSmall(
                                                                        width),
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

            ///Todo Logic end
            CustomDivider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                      onTap: () async {
                        getTopFriends();
                        String? dataAfter = await showFilterDialog();
                        logMethod(
                            title: "After Selecting",
                            message: dataAfter.toString());
                        if (dataAfter == "data") {
                          setState(() {

                            // filteredFullTransactions!.forEach((element) {
                               
                                
                            //   // element.gpaOrder
                            // });
                            
                            fullTransactions = fullTransactions!
            .where((datum) { 
              ExtractMemoModel? memoModel =  extractMemo(
                                memo: (datum.type.name).toLowerCase() ==
                                          ('gpa_credit')
                                    ? (datum.gpaOrder!.tags)??null
                                    : (datum.peerTransfer!.tags)?? null);
              // logMethod(title: 'Amount is:', message: datum.amount.toString());
              // AppConstants.tagItList.forEach((element) {
              //                       if(element.enabled!=false)
              //                       if(element.isSelected==true)
              //                       logMethod(
              //                         title: 'Tag -It checked Name',
              //                         message:
              //                             "${element.title}");
              //                     });
                                  allWalletName.forEach((element) {
                                    if(element.isChecked==true)
                                    logMethod(
                                      title: 'Wallet checked Name',
                                      message:
                                          "${memoModel!.toWallet} and title: ${element.title}");
                                  });

              //                     AppConstants.tagItList.forEach((element) {
              //                       // AppConstants.tagItList[index].enabled
              //                       if(element.enabled==false)
              //                       if(element.isSelected==true)
              //                       logMethod(
              //                         title: 'Activity Type Name',
              //                         message:
              //                             "${element.title}");
              //                     });
            // Filter conditions
        // bool isUserIdMatch = selectedUserIdForFav == memoModel!.senderId || selectedUserIdForFav == memoModel.receiverId;

        bool isDateMatch = (startDate==null|| endDate==null)?false: datum.createdTime .isAfter(startDate!) && datum.createdTime.isBefore(endDate!);
        // bool isAmountInRange = datum.amount >= double.parse(minPriceTextController.text.trim()) &&
        //                        datum.amount <= double.parse(maxPriceTextController.text.trim());
        logMethod(title: 'Transaction date:',
                                      message:
                                          "${datum.createdTime.day} and Start Date: ${startDate!.day} and End Date: ${endDate!.day} and isMatched: ${isDateMatch}");
        // // Check if transaction tag matches any selected tags or checked wallets
        bool hasMatchingTag = AppConstants.tagItList.any((element) {
          if((element.publicTag_it==true || element.publicTag_it==null) && element.isSelected==true)
          // logMethod(
          //   title: 'Tag it titles:', 
          //   message: "List Tag it id: ${element.title} and Model Tag it id: ${memoModel!.tagItame} and Enabled: ${element.publicTag_it}"
          //   );
            {
                        return (element.publicTag_it==true || element.publicTag_it==null) && element.isSelected==true && element.title == memoModel!.tagItame;

            }
            else{
              return false;
            }
        });
        
        
        // ignore: unused_local_variable
        bool hasMatchingActivityType = AppConstants.tagItList.any((element) {
          if(element.publicTag_it==false && element.isSelected==true)
          // logMethod(
          //   title: 'Activity titles:', 
          //   message: "Activity List Title: ${element.title} and Model List title : ${memoModel!.transactionType}" );
          {
            return element.publicTag_it==false && element.isSelected==true && element.title == memoModel!.transactionType;
          }
          else{
            return false;
          }
          
        });
            
        bool hasMatchingWallet = allWalletName.any((element) =>
            element.isChecked && element.title == memoModel!.toWallet);
        // logMethod(
        //   title: 'Selected User Id: $selectedUserIdForFav and model Sender User Id: ${memoModel!.senderId} or model Receiver User Id: ${memoModel.receiverId}',
        //                               message:
        //                                   "Message");
        // && hasMatchingActivityType && hasMatchingTag
          return (hasMatchingTag && hasMatchingWallet && isDateMatch && (datum.amount>=double.parse(minPriceTextController.text.toString().trim()) && datum.amount<=double.parse(maxPriceTextController.text.toString().trim()))); 
        // return ((selectedUserIdForFav== memoModel.senderId || selectedUserIdForFav== memoModel.receiverId) || datum.createdTime.isBefore(endDate!)||(datum.amount>=double.parse(minPriceTextController.text.toString().trim()) && datum.amount<=double.parse(maxPriceTextController.text.toString().trim()))  ); 
        // return isUserIdMatch && isDateMatch && isAmountInRange && hasMatchingTag && hasMatchingActivityType && hasMatchingWallet && isDateMatch && isAmountInRange && hasMatchingTag && hasMatchingActivityType && hasMatchingWallet;
              })
            .toList();
                            // query = ApiServices().giveQuery(
                            //     transactionTagitCategory: queryList,
                            //     userId: appConstants.userRegisteredId,
                            //     maxPrice: maxPrice,
                            //     minPrice: minPrice,
                            //     walletName: walletName,
                            //     startDate: startDate,
                            //     endDate: endDate,
                            //     selectedUserId: selectedUserIdForFav);
                            // allTransactions = ApiServices().fetchTransactions(
                            //   transactionTagitCategory: queryList,
                            //   userId: appConstants.userRegisteredId,
                            //   maxPrice: maxPrice,
                            //   minPrice: minPrice,
                            //   walletName: walletName,
                            //   startDate: startDate,
                            //   endDate: endDate,
                            //   selectedUserId: selectedUserIdForFav,
                            // );
                          });
                        }
                        //  Navigator.push(
                        //                         context,
                        //                         MaterialPageRoute(
                        //                             builder: (context) =>
                        //                                 const InlineScrollableX()));
                      },
                      child: Icon(
                        Icons.list,
                        color: filterApply ? green : grey.withValues(alpha:0.8),
                      )),
                ],
              ),
            ),
            // spacing_small,
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.end,
            //   children: [
            //     TextButton.icon(
            //       style: ButtonStyle(
            //         padding: MaterialStatePropertyAll(EdgeInsets.zero),
            //       ),
            //       icon: Icon(Icons.filter, color: black,),
            //       label: Text('Filter', style: heading3TextStyle(width,),),
            //       onPressed: () async{
            //         //  String? data = await _showFilterDialog();
            //         //  if(data!=null|| data!='')
            //         //  await getUserTransaction(appConstants.userRegisteredId);

            //       },
            //       )
            //   ],
            // ),
            // spacing_medium,

            // CustomSizedBox(height: height),
            //               payMoneyActivities==null? const SizedBox()
            //               :
            //               StreamBuilder<QuerySnapshot>(
            //                       stream: payMoneyActivities,
            //                       builder: (BuildContext context,
            //                           AsyncSnapshot<QuerySnapshot> snapshot) {
            //                         if (snapshot.hasError) {
            //                           return const SizedBox();
            //                         }
            //                         if (snapshot.connectionState ==
            //                             ConnectionState.waiting) {
            //                           return const Center(
            //                               child: CustomLoader());
            //                         }
            //                         if (snapshot.data!.size == 0) {
            //                           return Padding(
            //                             padding: const EdgeInsets.symmetric(horizontal: 12.0),
            //                             child:
            //                             selectedIndex!=-1? Column(
            //                               children: [
            //                                 SizedBox(height: height*0.2, width: double.infinity,),
            //                                 Text('No Activities Yet', style: heading1TextStyle(context, width),),
            //                               ],
            //                             ):
            //                              Column(
            //                               children: [
            //                                 SizedBox(height: height*0.2,),
            //                                 ZakiPrimaryButton(
            //                                   title: 'Invite Friends',
            //                                   width: width,
            //                                   onPressed: ()async {
            //                                       await ApiServices().getUserData(
            //                                           context: context,
            //                                           userId:
            //                                               appConstants.userRegisteredId);
            //                                       Navigator.push(
            //                                           context,
            //                                           MaterialPageRoute(
            //                                               builder: (context) =>
            //                                                   const InviteMainScreen()));
            //                                   },
            //                                 ),
            //                                 CustomSizedBox(height: height,),
            //                                 ZakiPrimaryButton(
            //                                   title: 'Sync Contacts',
            //                                   width: width,
            //                                   onPressed: ()async {
            //                                       await ApiServices().getUserData(
            //                                           context: context,
            //                                           userId:
            //                                               appConstants.userRegisteredId);
            //                                       Navigator.push(
            //                                           context,
            //                                           MaterialPageRoute(
            //                                               builder: (context) =>
            //                                                   const ManageContacts()));
            //                                   },
            //                                 ),
            //                               ],
            //                             ),
            //                           );
            //                         }
            // //snapshot.data!.docs[index] ['USER_first_name']
            //                         return ListView.separated(
            //                           separatorBuilder: (context, index) => const Divider(),
            //                           itemCount: snapshot.data!.docs.length,
            //                           physics: const NeverScrollableScrollPhysics(),
            //                           shrinkWrap: true,
            //                           itemBuilder: (BuildContext context, int index) {
            //                             // print(snapshot.data!.docs[index] ['USER_first_name']);
            //                             return ListTile(
            //                               onTap: () {
            //                               },
            //                               leading: Container(
            //                                 height: height * 0.07,
            //                                 width: height * 0.07,
            //                                 decoration: BoxDecoration(
            //                                     shape: BoxShape.circle,
            //                                     color: grey,
            //                                     border: Border.all(color: orange),
            //                                     ),
            //                                 child:
            //                                 snapshot.data!.docs[index][AppConstants.RQT_sender_image_url].contains('assets/images/') ?
            //                                   CircleAvatar(
            //                                                       backgroundColor: grey,
            //                                                       radius: width*0.09,
            //                                                       backgroundImage:
            //                                                          AssetImage(snapshot.data!.docs[index][AppConstants.RQT_sender_image_url])
            //                                                     )
            //                                               :
            //                                               CircleAvatar(
            //                                                       backgroundColor: grey,
            //                                                       radius: width*0.09,
            //                                                       backgroundImage:
            //                                                          NetworkImage(snapshot.data!.docs[index][AppConstants.RQT_sender_image_url])
            //                                                     ),
            //                               ),
            //                               title: Text(
            //                                 snapshot.data!.docs[index]
            //                                     [AppConstants.RQT_Sender_UserName],
            //                                 overflow: TextOverflow.clip,
            //                                 maxLines: 1,
            //                                 style: textStyleHeading2WithTheme(
            //                                     context, width * 0.85,
            //                                     whiteColor: 0),
            //                               ),
            //                               subtitle: Text(
            //                                 formatedDate(snapshot
            //                                     .data!.docs[index][AppConstants.created_at]
            //                                     .toDate()),
            //                                 overflow: TextOverflow.clip,
            //                                 maxLines: 1,
            //                                 style: textStyleHeading2WithTheme(
            //                                     context, width * 0.65,
            //                                     whiteColor: 2),
            //                               ),
            //                               trailing: Row(
            //                                 mainAxisSize: MainAxisSize.min,
            //                                 children: [
            //                                   Text(
            //                                     snapshot.data!.docs[index]
            //                                                 [AppConstants.Transaction_transaction_type] ==
            //                                             'Send'
            //                                         ? '+'
            //                                         : '-',
            //                                     overflow: TextOverflow.clip,
            //                                     maxLines: 1,
            //                                     style: textStyleHeading2WithTheme(
            //                                         context, width * 0.85,
            //                                         whiteColor: snapshot.data!.docs[index]
            //                                                     [AppConstants.Transaction_transaction_type] ==
            //                                                 'Send'
            //                                             ? 5
            //                                             : 0),
            //                                   ),
            //                                   Text(
            //                                     snapshot.data!.docs[index][AppConstants.RQT_amount],
            //                                     overflow: TextOverflow.clip,
            //                                     maxLines: 1,
            //                                     style: textStyleHeading2WithTheme(
            //                                         context, width * 0.85,
            //                                         whiteColor: snapshot.data!.docs[index]
            //                                                     [AppConstants.Transaction_transaction_type] ==
            //                                                 'Send'
            //                                             ? 5
            //                                             : 0),
            //                                   ),
            //                                   Padding(
            //                                     padding: const EdgeInsets.only(left: 4.0),
            //                                     child: Icon(
            //                                       Icons.arrow_circle_right,
            //                                       size: width * 0.05,
            //                                       color: black,
            //                                     ),
            //                                   ),
            //                                 ],
            //                               ),
            //                             );
            //                           },
            //                         );
            //                       },
            //                     ),
            // spacing_small,

            // if (appConstants.testMode != false)
            
            //// New Logic start
            // if(fullTransactions!=null)
            // isLoading?
            // Expanded(
            //   child: ShimmerList(),
            // )
            // :
            // Expanded(
            //   child: Padding(
            //     padding: getCustomPadding(),
            //     child: ListView.separated(
            //       controller: _controller,
            //       itemCount: fullTransactions!.length+1,
            //                 separatorBuilder: (context, index) => const Divider(),
            //                 shrinkWrap: true,
            //                 physics: const BouncingScrollPhysics(),
            //                 itemBuilder: (context, index) {

            //                   if(fullTransactions!.length==0){
            //                     return SizedBox.shrink();
            //                   }

            //                   ExtractMemoModel? memoModel = !(index<fullTransactions!.length)? null: extractMemo(
            //                     memo: (fullTransactions![index].type.name).toLowerCase() ==
            //                               ('gpa_credit')
            //                         ? (fullTransactions![index].gpaOrder!.tags)??null
            //                         : (fullTransactions![index].peerTransfer!.tags)?? null);
            //                 logMethod(title: 'Sender and receiver ids', message: "${memoModel!.senderId.toString()} and ${memoModel.receiverId}");
            //                 Item value = (memoModel==null)? Item(): Item(
            //                     transactionFromWallet: memoModel.fromWallet,
            //                     transactionMessageText: '',
            //                     transactionMethod: memoModel.transactionMethod,
            //                     transactionReceiverUserId: memoModel.receiverId,
            //                     transactionSenderUserId: memoModel.senderId,
            //                     transactionSenderUserName: '',
            //                     transactionTagitCategory: memoModel.tagItame,
            //                     transactionTagitCode: memoModel.tagItId,
            //                     transactionToWallet: memoModel.toWallet,
            //                     transactionAmount: fullTransactions![index].gpa.impactedAmount
            //                         .toString(),
            //                     transactionId: memoModel.transactionId,
            //                     transactionReceiverName: '',
            //                     transactionTransactionType:
            //                         memoModel.transactionType,
            //                     createdAt: fullTransactions![index].createdTime,
            //                     latLang: memoModel.latLng
            //                     );

            //                 // logMethod(
            //                 //     title: 'Memo',
            //                 //     message: memoModel!.transactionType.toString());

            //         return
            //          index<fullTransactions!.length?
            //         //  Padding(
            //         //    padding: const EdgeInsets.all(15.0),
            //         //    child: Text('${fullTransactions![index].type.name}: $index'),
            //         //  )
            //         AllActivitiesCustomTile(
            //                   data: value,
            //                   onTap: () {},
            //                   fromBankApi: true,
            //                 )
            //          :
            //          Center(
            //            child: Padding(
            //              padding: const EdgeInsets.all(8.0),
            //              child: isMore==false? Text('No More Activities') : CircularProgressIndicator(),
            //            ),
            //          );
            //       }
            //       ),
            //   ),
            // ),

            //// New Logic end
            
            // if (transactionLists != null)
            //   Expanded(
            //     child: Padding(
            //       padding: getCustomPadding(),
            //       child: FutureBuilder<CardTransation>(
            //         future: transactionLists,
            //         // initialData: CardTransation(
            //         //     count: 0,
            //         //     appConstants.startIndex: 0,
            //         //     endIndex: 0,
            //         //     isMore: false,
            //         //     data: []),
            //         builder: (BuildContext context, snapshot) {
            //           if (snapshot.hasError) {
            //             return Text(snapshot.error.toString());
            //           }

            //           if (snapshot.connectionState == ConnectionState.waiting) {
            //             return Center(child: const CustomLoader());
            //           }
            //           if (snapshot.data!.data.length == 0) {
            //             return Column(
            //               children: [
            //                 SizedBox(
            //                   height: height * 0.1,
            //                 ),
            //                 CustomInviteImage(),
            //               ],
            //             );
            //           }

            //           return ListView.separated(
            //               separatorBuilder: (context, index) => const Divider(),
            //               itemCount: snapshot.data!.data.length,
            //               shrinkWrap: true,
            //               physics: const BouncingScrollPhysics(),
            //               itemBuilder: (context, index) {
            //                 // if(index==0){
            //                 //   return SizedBox();
            //                 // }
            //                 ExtractMemoModel? memoModel = extractMemo(
            //                     memo: (snapshot.data!.data[index].type.name).toLowerCase() ==
            //                               ('gpa_credit')
            //                         ? (snapshot.data!.data[index].gpaOrder!.tags)??null
            //                         : (snapshot
            //                             .data!.data[index].peerTransfer!.tags)?? null);
            //                 // logMethod(title: 'After extration', message: memoModel.toString());
            //                 Item value = (memoModel==null)? Item(): Item(
            //                     transactionFromWallet: memoModel.fromWallet,
            //                     transactionMessageText: '',
            //                     transactionMethod: memoModel.transactionMethod,
            //                     transactionReceiverUserId: memoModel.receiverId,
            //                     transactionSenderUserId: memoModel.senderId,
            //                     transactionSenderUserName: '',
            //                     transactionTagitCategory: memoModel.tagItame,
            //                     transactionTagitCode: memoModel.tagItId,
            //                     transactionToWallet: memoModel.toWallet,
            //                     transactionAmount: snapshot
            //                         .data!.data[index].gpa.impactedAmount
            //                         .toString(),
            //                     transactionId: memoModel.transactionId,
            //                     transactionReceiverName: '',
            //                     transactionTransactionType:
            //                         memoModel.transactionType,
            //                     createdAt:
            //                         snapshot.data!.data[index].createdTime);

            //                 logMethod(
            //                     title: 'Memo',
            //                     message: memoModel!.transactionType.toString());

            //                 // if(appConstants.selectedWallatFilter==''){}
            //                 return
            //                  memoModel.transactionType==null?
            //                  SizedBox():                           
            //                  AllActivitiesCustomTile(
            //                   data: value,
            //                   onTap: () {},
            //                 );
            //                 //                   ListTile(
            //                 //                     dense: false,
            //                 //                     contentPadding:
            //                 //                         EdgeInsets.symmetric(horizontal: 4),
            //                 //                     onTap: () {
            //                 //                       appConstants.updateDetailTransactionModel(
            //                 //                           TransactionDetailModel(
            //                 //                               userId: snapshot.data!.data[index].gpa.impactedAmount < 0
            //                 //                                   ? memoModel.receiverId
            //                 //                                   : memoModel.senderId,
            //                 //                               tagItIcon: (memoModel.transactionType ==
            //                 //                                       AppConstants
            //                 //                                           .TAG_IT_Transaction_TYPE_INTERNAL_TRANSFER)
            //                 //                                   ? Icons.money
            //                 //                                   : memoModel.transactionType ==
            //                 //                                           AppConstants
            //                 //                                               .TAG_IT_Transaction_TYPE_TODO_REWARD
            //                 //                                       ? FontAwesomeIcons
            //                 //                                           .moneyBillTransfer
            //                 //                                       : memoModel.tagItId == null
            //                 //                                           ? Icons.star_half
            //                 //                                           : AppConstants
            //                 //                                               .tagItList[int.parse(memoModel
            //                 //                                                   .tagItId!)]
            //                 //                                               .icon,
            //                 //                               // walletName:walletNickName(walletName: memoModel.toWallet, appConstants: appConstants),
            //                 //                               walletName: walletNickName(
            //                 //                                   walletName: (memoModel.transactionType ==
            //                 //                                               AppConstants
            //                 //                                                   .TAG_IT_Transaction_TYPE_ALLOWANCE &&
            //                 //                                           (snapshot
            //                 //                                                   .data!
            //                 //                                                   .data[index]
            //                 //                                                   .gpa
            //                 //                                                   .impactedAmount <
            //                 //                                               0))
            //                 //                                       ? memoModel.fromWallet
            //                 //                                       : ((memoModel.transactionType == AppConstants.TAG_IT_Transaction_TYPE_GOALS) &&
            //                 //                                               (snapshot.data!.data[index].gpa.impactedAmount < 0))
            //                 //                                           ? memoModel.fromWallet
            //                 //                                           : memoModel.toWallet,
            //                 //                                   appConstants: appConstants),
            //                 //                               amount: '${snapshot.data!.data[index].gpa.impactedAmount < 0 ? '-' : '+'} ${getCurrencySymbol(context, appConstants: appConstants)} ${checkAmount(amount: snapshot.data!.data[index].gpa.impactedAmount).toStringAsFixed(2)}',
            //                 //                               transactionType: memoModel.transactionType,
            //                 //                               name: appConstants.userModel.usaUserName,
            //                 //                               transactionDate: formatedDateWithMonthAndTime(date: snapshot.data!.data[index].createdTime),
            //                 //                               transactionMessage: '',
            //                 //                               transactionId: snapshot.data!.data[index].token,
            //                 //                               transactionMethod: snapshot.data!.data[index].gpa.impactedAmount < 0 ? AppConstants.Transaction_Method_Payment : AppConstants.Transaction_Method_Received,
            //                 //                               tagItName: memoModel.tagItame));
            //                 //                       Navigator.push(
            //                 //                           context,
            //                 //                           MaterialPageRoute(
            //                 //                               builder: (context) =>
            //                 //                                   TransactionDetail()));
            //                 //                     },
            //                 // //                     Icon(
            //                 // //     (widget.data.transactionTransactionType ==
            //                 // //             AppConstants.TAG_IT_Transaction_TYPE_INTERNAL_TRANSFER)
            //                 // //         ? FontAwesomeIcons.moneyBillTransfer
            //                 // //         : (widget.data.transactionTransactionType ==
            //                 // //                 AppConstants.TAG_IT_Transaction_TYPE_Fund_My_Wallet)
            //                 // //             ? FontAwesomeIcons.creditCard
            //                 // //             : widget.data.transactionTransactionType ==
            //                 // //                     AppConstants.TAG_IT_Transaction_TYPE_TODO_REWARD
            //                 // //                 ? FontAwesomeIcons.trophy
            //                 // //                 : widget.data.transactionTagitCode ==
            //                 // //                         null
            //                 // //                     ? Icons.star_half
            //                 // //                     : AppConstants
            //                 // //                         .tagItList[int.parse(widget.data.transactionTagitCode.toString())]
            //                 // //                         .icon,
            //                 // //     color: orange,
            //                 // //   ),
            //                 // //   // child: Image.asset(AppConstants.tagItList[snapshot.data!.docs[index][int.parse(AppConstants.Transaction_TAGIT_code)]].icon.toString() ),
            //                 // // ),
            //                 //                     // leading: Container(
            //                 //                     //   height: height * 0.06,
            //                 //                     //   width: height * 0.06,
            //                 //                     //   decoration: BoxDecoration(
            //                 //                     //       shape: BoxShape.circle,
            //                 //                     //       color: white,
            //                 //                     //       border: Border.all(color: orange)),
            //                 //                     //   child: Icon(
            //                 //                     //     (memoModel.transactionType == AppConstants.TAG_IT_Transaction_TYPE_INTERNAL_TRANSFER)
            //                 //                     //         ? Icons.money
            //                 //                     //         : memoModel.transactionType ==
            //                 //                     //                 AppConstants
            //                 //                     //                     .TAG_IT_Transaction_TYPE_TODO_REWARD
            //                 //                     //             ? FontAwesomeIcons.moneyBillTransfer
            //                 //                     //             : (memoModel.tagItId == null ||
            //                 //                     //                     memoModel.tagItId == '')
            //                 //                     //                 ? Icons.star_half
            //                 //                     //                 : AppConstants
            //                 //                     //                     .tagItList[int.parse(
            //                 //                     //                         memoModel.tagItId!)]
            //                 //                     //                     .icon,
            //                 //                     //     color: orange,
            //                 //                     //   ),
            //                 //                     //   // child: Image.asset(AppConstants.tagItList[snapshot.data!.docs[index][int.parse(AppConstants.Transaction_TAGIT_code)]].icon.toString() ),
            //                 //                     // ),
            //                 //                     title: Row(
            //                 //                       mainAxisSize: MainAxisSize.min,
            //                 //                       children: [
            //                 //                         Text(
            //                 //                             (memoModel.transactionType ==
            //                 //                                     AppConstants
            //                 //                                         .TAG_IT_Transaction_TYPE_DEBIT_CARD_P)
            //                 //                                 ? '[Store Name]'
            //                 //                                 : memoModel.transactionType ==
            //                 //                                         AppConstants
            //                 //                                             .TAG_IT_Transaction_TYPE_DEBIT_CARD_V
            //                 //                                     ? 'Refund'
            //                 //                                     : (memoModel.transactionType ==
            //                 //                                                 AppConstants
            //                 //                                                     .TAG_IT_Transaction_TYPE_INTERNAL_TRANSFER ||
            //                 //                                             memoModel
            //                 //                                                     .transactionType ==
            //                 //                                                 AppConstants
            //                 //                                                     .TAG_IT_Transaction_TYPE_GOALS ||
            //                 //                                             memoModel
            //                 //                                                     .transactionType ==
            //                 //                                                 AppConstants
            //                 //                                                     .TAG_IT_Transaction_TYPE_Fund_My_Wallet ||
            //                 //                                             memoModel
            //                 //                                                     .transactionType ==
            //                 //                                                 AppConstants
            //                 //                                                     .TAG_IT_Transaction_TYPE_TODO_REWARD ||
            //                 //                                             memoModel
            //                 //                                                     .transactionType ==
            //                 //                                                 AppConstants
            //                 //                                                     .TAG_IT_Transaction_TYPE_SEND_OR_REQUEST ||
            //                 //                                             memoModel
            //                 //                                                     .transactionType ==
            //                 //                                                 AppConstants
            //                 //                                                     .TAG_IT_Transaction_TYPE_ALLOWANCE)
            //                 //                                         ? '${getTransactionName(appConstants: appConstants, fromWallet: memoModel.fromWallet, toWallet: memoModel.toWallet, transactionMethod: memoModel.transactionMethod, transactionType: memoModel.transactionType)} ${(memoModel.transactionType == AppConstants.TAG_IT_Transaction_TYPE_SEND_OR_REQUEST || memoModel.transactionType == AppConstants.TAG_IT_Transaction_TYPE_TODO_REWARD || memoModel.transactionType == AppConstants.TAG_IT_Transaction_TYPE_ALLOWANCE || memoModel.transactionType == AppConstants.TAG_IT_Transaction_TYPE_Fund_My_Wallet) ? '' : (snapshot.data!.data[index].gpa.impactedAmount < 0 ? ' - Sent' : ' - Received')}'
            //                 //                                         : '',
            //                 //                             //  '${getTransactionName(appConstants: appConstants)} ${checkTransactionType(userId: appConstants.userRegisteredId)} ${senderCurrentUser(userId: appConstants.userRegisteredId) ? widget.data[AppConstants.Transaction_receiver_name] : widget.data[AppConstants.Transaction_Sender_UserName]}',
            //                 //                             overflow: TextOverflow.clip,
            //                 //                             maxLines: 2,
            //                 //                             style: heading3TextStyle(width * 0.9)),
            //                 //                         if (memoModel.transactionType ==
            //                 //                                 AppConstants
            //                 //                                     .TAG_IT_Transaction_TYPE_SEND_OR_REQUEST ||
            //                 //                             memoModel.transactionType ==
            //                 //                                 AppConstants
            //                 //                                     .TAG_IT_Transaction_TYPE_TODO_REWARD ||
            //                 //                             memoModel.transactionType ==
            //                 //                                 AppConstants
            //                 //                                     .TAG_IT_Transaction_TYPE_ALLOWANCE)
            //                 //                           //
            //                 //                           Row(
            //                 //                             mainAxisSize: MainAxisSize.min,
            //                 //                             children: [
            //                 //                               Text(
            //                 //                                   snapshot.data!.data[index].gpa
            //                 //                                               .impactedAmount <
            //                 //                                           0
            //                 //                                       ? 'sent to '
            //                 //                                       : 'received from ',
            //                 //                                   style: heading3TextStyle(
            //                 //                                       width * 0.9)),
            //                 //                               UserInfoForGoals(
            //                 //                                 onlyUserName: true,
            //                 //                                 userId: snapshot.data!.data[index]
            //                 //                                             .gpa.impactedAmount <
            //                 //                                         0
            //                 //                                     ? memoModel.receiverId
            //                 //                                     : memoModel.senderId,
            //                 //                               ),
            //                 //                             ],
            //                 //                           )
            //                 //                       ],
            //                 //                     ),
            //                 //                     subtitle: Column(
            //                 //                       mainAxisSize: MainAxisSize.min,
            //                 //                       mainAxisAlignment: MainAxisAlignment.start,
            //                 //                       crossAxisAlignment: CrossAxisAlignment.start,
            //                 //                       children: [
            //                 //                         Row(
            //                 //                           crossAxisAlignment:
            //                 //                               CrossAxisAlignment.start,
            //                 //                           mainAxisAlignment:
            //                 //                               MainAxisAlignment.start,
            //                 //                           mainAxisSize: MainAxisSize.min,
            //                 //                           children: [
            //                 //                             // if(memoModel.transactionType == AppConstants.TAG_IT_Transaction_TYPE_INTERNAL_TRANSFER)
            //                 //                             Text(
            //                 //                               '{${walletNickName(walletName: (memoModel.transactionType == AppConstants.TAG_IT_Transaction_TYPE_ALLOWANCE && (snapshot.data!.data[index].gpa.impactedAmount < 0)) ? memoModel.fromWallet : ((memoModel.transactionType == AppConstants.TAG_IT_Transaction_TYPE_GOALS) && (snapshot.data!.data[index].gpa.impactedAmount < 0)) ? memoModel.fromWallet : memoModel.toWallet, appConstants: appConstants)}} - ',
            //                 //                               overflow: TextOverflow.clip,
            //                 //                               maxLines: 1,
            //                 //                               style: heading4TextSmall(width),
            //                 //                             ),

            //                 //                             Text(
            //                 //                               formatedDateWithMonth(
            //                 //                                   date: snapshot.data!.data[index]
            //                 //                                       .createdTime),
            //                 //                               overflow: TextOverflow.clip,
            //                 //                               maxLines: 1,
            //                 //                               style: heading4TextSmall(width),
            //                 //                             ),

            //                 //                             // Text(
            //                 //                             //   " - ${data[AppConstants.Transaction_Method]}" ,
            //                 //                             //   overflow: TextOverflow.clip,
            //                 //                             //   maxLines: 1,
            //                 //                             //   style: heading4TextSmall(width),
            //                 //                             // ),
            //                 //                             //
            //                 //                           ],
            //                 //                         ),
            //                 //                         // if((memoModel.transactionType == AppConstants.TAG_IT_Transaction_TYPE_INTERNAL_TRANSFER))
            //                 //                         // Text(
            //                 //                         //   widget.data[AppConstants.Transaction_Message_Text],
            //                 //                         //   style: heading4TextSmall(width*0.85),
            //                 //                         // )
            //                 //                       ],
            //                 //                     ),
            //                 //                     // Text(
            //                 //                     // '${snapshot.data!.data[index].response==null? '': snapshot.data!.data[index].response!.memo}',
            //                 //                     // style: heading3TextStyle(width,color: black,),
            //                 //                     // ),
            //                 //                     trailing: Row(
            //                 //                       mainAxisSize: MainAxisSize.min,
            //                 //                       children: [
            //                 //                         Text(
            //                 //                           '${snapshot.data!.data[index].gpa.impactedAmount < 0 ? '-' : '+'} ${getCurrencySymbol(context, appConstants: appConstants)} ${checkAmount(amount: snapshot.data!.data[index].gpa.impactedAmount).toStringAsFixed(2)}',
            //                 //                           style: heading3TextStyle(width,
            //                 //                               color: snapshot.data!.data[index].gpa
            //                 //                                           .impactedAmount <
            //                 //                                       0
            //                 //                                   ? black
            //                 //                                   : green,
            //                 //                               font: 12),
            //                 //                           overflow: TextOverflow.clip,
            //                 //                           maxLines: 1,
            //                 //                         ),
            //                 //                         memoModel.transactionType ==
            //                 //                                 AppConstants
            //                 //                                     .TAG_IT_Transaction_TYPE_SEND_OR_REQUEST
            //                 //                             ? selectedUserId ==
            //                 //                                     appConstants.userRegisteredId
            //                 //                                 ? InkWell(
            //                 //                                     onTap: () {
            //                 //                                       logMethod(
            //                 //                                           title:
            //                 //                                               'Memo transaction Id',
            //                 //                                           message: memoModel
            //                 //                                               .senderId
            //                 //                                               .toString());
            //                 //                                       Stream<QuerySnapshot>?
            //                 //                                           specficSocialFeed =
            //                 //                                           ApiServices().getSpecficSoalFeed(
            //                 //                                               userId: appConstants
            //                 //                                                   .userRegisteredId,
            //                 //                                               transactionId: memoModel
            //                 //                                                   .transactionId);
            //                 //                                       customFeedDialouge(
            //                 //                                           context: context,
            //                 //                                           socialFeed:
            //                 //                                               specficSocialFeed);
            //                 //                                     },
            //                 //                                     child: Padding(
            //                 //                                       padding:
            //                 //                                           const EdgeInsets.only(
            //                 //                                               left: 4.0),
            //                 //                                       child: Icon(
            //                 //                                         Icons.arrow_forward,
            //                 //                                         size: width * 0.05,
            //                 //                                         color: grey,
            //                 //                                       ),
            //                 //                                     ),
            //                 //                                   )
            //                 //                                 : const SizedBox.shrink()
            //                 //                             : const SizedBox.shrink(),
            //                 //                       ],
            //                 //                     ),
            //                 //                     // subtitle: Text(
            //                 //                     //   formatedDateWithMonth(date: appConstants.cardTransactionList.data[index].createdTime),
            //                 //                     //   overflow: TextOverflow.clip,
            //                 //                     //   maxLines: 1,
            //                 //                     //   style: heading4TextSmall(width),
            //                 //                     // )
            //                 //                   );
            //               });
            //         },
            //       ),
            //     ),
            //   ),


//             Expanded(
//               child: FirestorePagination(
//                 // query: allTransactions,
//                 // query: FirebaseFirestore.instance.collection('${AppConstants.USER}/${appConstants.userRegisteredId}/${AppConstants.Transaction}').orderBy(AppConstants.created_at, descending: true),
//                 query: query!,
//                 // query: FirebaseFirestore.instance.collection(AppConstants.USER).doc(userId).collection(AppConstants.Transaction),
//                   // query: FirebaseFirestore.instance.collection(AppConstants.USER).orderBy(AppConstants.USER_created_at),
//                   isLive: true,
//                   limit: 20,
//                   shrinkWrap: true,
//                   itemBuilder: (context, documentSnapshot, index) {
//                     final data = documentSnapshot.data() as Map<String, dynamic>;
//                     final item = Item.fromFirestore(data);
//                     // Do something cool with the data
//                     return
//                     // Text('Users names are: ${data[AppConstants.USER_first_name]}');
//                     AllActivitiesCustomTile(data: item, onTap: (){},);
//                     // AllActivitiesCustomTileHomeScreen(
//                     //             data: data[index],
//                     //             onTap: () {
//                     //               // selectAnAlocationBottomSheet(
//                     //               //     context: context,
//                     //               //     height: height,
//                     //               //     width: width,
//                     //               //     selectedUserId: selectedUserId,
//                     //               //     transactionId:
//                     //               //         snapshot.data!.docs[index].id,
//                     //               //     previousSelected: snapshot
//                     //               //             .data!.docs[index]
//                     //               //         [AppConstants.Transaction_TAGIT_code]
//                     //               //     // appConstants: appConstants
//                     //               //     );
//                     //             },
//                     //           );
//   },
// ),),
            Expanded(
              child: allTransactions == null
                  ? const SizedBox()
                  : Padding(
                      padding: getCustomPadding(),
                      child: StreamBuilder<List<Item>>(
                        stream: allTransactions,
                        builder: (BuildContext context, snapshot) {
                          if (snapshot.hasError) {
                            return const SizedBox();
                          }
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(child: CustomLoader());
                          }
                          if (snapshot.data!.length == 0) {
                            return Column(
                              children: [
                                SizedBox(
                                  height: height * 0.1,
                                ),
                                CustomInviteImage(),
                              ],
                            );
                          }
                          //snapshot.data!.docs[index] ['USER_first_name']
                          return ListView.separated(
                            separatorBuilder: (context, index) =>
                                const Divider(),
                            itemCount: snapshot.data!.length,
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index) {
                              // logMethod(
                              //     title:
                              //         'Selected Wallet Filter Name Collections',
                              //     message: appConstants.selectedWallatFilter);
                              // print(snapshot.data!.docs[index] ['USER_first_name']);
                              return AllActivitiesCustomTile(
                                data: snapshot.data![index],
                                onTap: () {
                                  // selectAnAlocationBottomSheet(
                                  //     context: context,
                                  //     height: height,
                                  //     width: width,
                                  //     selectedUserId: selectedUserId,
                                  //     transactionId:
                                  //         snapshot.data!.docs[index].id,
                                  //     previousSelected: snapshot
                                  //             .data!.docs[index]
                                  //         [AppConstants.Transaction_TAGIT_code]
                                  //     // appConstants: appConstants
                                  //     );
                                },
                              );
                            },
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> customFeedDialouge(
      {Stream<QuerySnapshot<Object?>>? socialFeed, BuildContext? context}) {
    return showDialog(
      // useSafeArea: true,
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

  double checkAmount({double? amount}) {
    return amount! < 0 ? double.parse(amount.toString().split('-')[1]) : amount;
  }

  getTransactionName(
      {AppConstants? appConstants,
      String? transactionType,
      String? transactionMethod,
      String? fromWallet,
      String? toWallet}) {
    if (
        // data[AppConstants.Transaction_transaction_type] == AppConstants.TAG_IT_Transaction_TYPE_SEND_OR_REQUEST &&
        transactionType == AppConstants.TAG_IT_Transaction_TYPE_SEND_OR_REQUEST) {
      return 'Money';
    } else if (transactionType == AppConstants.TAG_IT_Transaction_TYPE_ALLOWANCE) {
      return '${AppConstants.TAG_IT_Transaction_TYPE_ALLOWANCE}';
    } else if (transactionType == AppConstants.TAG_IT_Transaction_TYPE_TODO_REWARD) {
      return 'Reward';
    } else if (transactionType ==
        AppConstants.TAG_IT_Transaction_TYPE_INTERNAL_TRANSFER) {
      return '${(transactionMethod == AppConstants.Transaction_Method_Payment) ? 'Money moved to ${walletNickName(walletName: fromWallet, appConstants: appConstants)}' : 'Money moved from ${walletNickName(walletName: fromWallet, appConstants: appConstants)}'}';
    } else if (transactionType == AppConstants.TAG_IT_Transaction_TYPE_GOALS) {
      return 'Goals Funding';
      // return 'Goals Contribution ${(transactionMethod==AppConstants.Transaction_Method_Payment) ? ' to ${widget.data[AppConstants.Transaction_receiver_name]}' : ' from ${widget.data[AppConstants.Transaction_Sender_UserName]}}'}';
    } else if (transactionType ==
        AppConstants.TAG_IT_Transaction_TYPE_Fund_My_Wallet) {
      return 'Deposit';
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

  void selectAnAlocationBottomSheet(
      {required BuildContext context,
      double? width,
      double? height,
      String? selectedUserId,
      String? transactionId,
      String? previousSelected
      // AppConstants? appConstants
      }) {
    // List<ImageModelTagIt> AppConstants.tagItList = [
    //   ImageModelTagIt(id: 0, icon: Icons.phone_iphone_sharp, title: 'Apps'),
    //   ImageModelTagIt(
    //       id: 1, icon: FontAwesomeIcons.moneyBillTransfer, title: 'Allowance'),
    //   ImageModelTagIt(
    //       id: 2, icon: FontAwesomeIcons.tv, title: 'Electronics'),
    //   ImageModelTagIt(
    //       id: 3, icon: FontAwesomeIcons.handHolding, title: 'Charity'),
    //   ImageModelTagIt(
    //       id: 4, icon: FontAwesomeIcons.graduationCap, title: 'Education'),
    //   ImageModelTagIt(id: 5, icon: FontAwesomeIcons.burger, title: 'Food'),
    //   ImageModelTagIt(id: 6, icon: FontAwesomeIcons.gift, title: 'Gifts'),
    //   ImageModelTagIt(id: 7, icon: FontAwesomeIcons.bullseye, title: 'Goals'),
    //   ImageModelTagIt(
    //       id: 8, icon: FontAwesomeIcons.basketShopping, title: 'Groceries'),
    //   ImageModelTagIt(
    //       id: 9, icon: FontAwesomeIcons.gasPump, title: 'Gas Stations'),
    //   ImageModelTagIt(
    //       id: 10,
    //       // ignore: deprecated_member_use
    //       icon: FontAwesomeIcons.exchange,
    //       title: 'Internal Transfer'),
    //   ImageModelTagIt(
    //       id: 11, icon: FontAwesomeIcons.video, title: 'Movies'),
    //   ImageModelTagIt(
    //       id: 12, icon: Icons.receipt_long_rounded, title: 'Reward'),
    //   ImageModelTagIt(
    //       id: 13, icon: FontAwesomeIcons.cartShopping, title: 'Shopping'),
    //   ImageModelTagIt(
    //       id: 14, icon: FontAwesomeIcons.gamepad, title: 'Video Games'),
    // ];
    int selected = previousSelected == null ? -1 : int.parse(previousSelected);
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
          return StatefulBuilder(
              builder: (BuildContext context, setState) => SizedBox(
                    height: height! * 0.9,
                    child: Padding(
                      padding: MediaQuery.of(context).viewInsets,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 8.0, bottom: 8.0),
                            child: InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                width: width * 0.2,
                                height: 5,
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(width * 0.08),
                                    color: grey),
                              ),
                            ),
                          ),
                          Text(
                            'Tag It',
                            style: heading1TextStyle(context, width),
                          ),
                          SizedBox(
                            height: height * 0.01,
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 18, vertical: 0),
                              child: ListView.builder(
                                itemCount: AppConstants.tagItList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 300),
                                      color: selected == index
                                          ? green.withValues(alpha:0.15)
                                          : transparent,
                                      child: ListTile(
                                        onTap: () async {
                                          ApiServices services = ApiServices();
                                          setState(() {
                                            selected = index;
                                          });
                                          services.updateTransactionTagIt(
                                              tagItId: index.toString(),
                                              selectedUserId: selectedUserId,
                                              transactionId: transactionId);
                                          Future.delayed(
                                              Duration(milliseconds: 800), () {
                                            Navigator.pop(context);
                                          });
                                          // appConstants.updateSelectedAllocationIndex(index);
                                        },
                                        leading: Container(
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                    color: selected == index
                                                        ? green
                                                        : grey)),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Icon(
                                                  AppConstants
                                                      .tagItList[index].icon,
                                                  color: selected == index
                                                      ? green
                                                      : grey,
                                                  size: width * 0.06),
                                            )),
                                        title: TextValue3(
                                          title:
                                              '${AppConstants.tagItList[index].title}',
                                        ),
                                        trailing: selected == index
                                            ? Icon(
                                                Icons.check_circle,
                                                color: green,
                                              )
                                            : null,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ));
        });
  }
}

class ShimmerList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      enabled: true,
      direction: ShimmerDirection.ltr,
      // period: Duration(milliseconds: 2),
      // loop: 6,
      child: ListView.builder(
        itemCount: 10, // Adjust the count based on your needs
        itemBuilder: (context, index) {
          return 
          
          ListTile(
            leading: CircleAvatar(
      key: key,
      radius: 25,
      backgroundColor: Colors.grey[200],
      // backgroundImage: const AssetImage('images/Staff-Placeholder.jpg'),
      // foregroundImage: profile != null ? NetworkImage(profile) : null,
    
            ),
            title:  Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RoundedRectangle(height: 15),
          SizedBox(height: 5),
          RoundedRectangle(height: 15, width: 100)
            ],
          ),
          trailing: RoundedRectangle(height: 15, width: 50),
          );
        },
      ),
    );
  }
}


class RoundedRectangle extends StatelessWidget {
  final double height;
  final double width;
  const RoundedRectangle({
    // super.key,

    this.height = 50,
    this.width = double.maxFinite,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(15),
        ));
  }
}