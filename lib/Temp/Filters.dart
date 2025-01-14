import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:choice/choice.dart';
import 'package:provider/provider.dart';
import 'package:zaki/Constants/AppConstants.dart';
import 'package:zaki/Constants/HelperFunctions.dart';
import 'package:zaki/Constants/Spacing.dart';
import 'package:zaki/Constants/Styles.dart';
import 'package:zaki/Models/Items.dart';
import 'package:zaki/Screens/InviteMainScreen.dart';
import 'package:zaki/Screens/IssueAndManageCards.dart';
import 'package:zaki/Services/api.dart';
import 'package:zaki/Widgets/TextHeader.dart';
import 'package:zaki/Widgets/TopFriendsCustomWidget.dart';
import 'package:zaki/Widgets/ZakiCircularButton.dart';

import '../Widgets/ZakiPrimaryButton.dart';

class InlineScrollableX extends StatefulWidget {
  const InlineScrollableX({Key? key}) : super(key: key);

  @override
  State<InlineScrollableX> createState() => _InlineScrollableXState();
}

class _InlineScrollableXState extends State<InlineScrollableX> {
  Stream<QuerySnapshot<Object?>>? topFriends;
  List<String> queryList = [];
  String walletName = 'All';
  double minPrice = 0;
  double maxPrice = 1000;
  bool onlyAvailable = false;
  String? selectedUserId;
  int? selectedTagit;
  String? selectedDateType;
  int? selectedTransaction;
  String? selectedValue;
  DateTime? startDate;
  DateTime? endDate;
  final ExpansionTileController topFriendsExpansionTile =
      ExpansionTileController();
    final ExpansionTileController tagItExpansionTile =
      ExpansionTileController();
  final ExpansionTileController walletExpansionTile =
      ExpansionTileController();
  final ExpansionTileController dateExpansionTile =
      ExpansionTileController();
  final ExpansionTileController transactionTypeExpansionTile =
      ExpansionTileController();

  void setSelectedValue(String? value) {
    setState(() => selectedValue = value);
  }
  void clear(){
      queryList = [];
      walletName = 'All';
      minPrice = 0;
      maxPrice = 1000;
      onlyAvailable = false;
      selectedUserId=null;
      selectedTagit=null;
      selectedDateType=null;
      selectedTransaction=null;
      selectedValue=null;
      startDate=null;
      endDate=null;
      setState(() {
        
      });
  }

  @override
  void initState() {
    super.initState();
    getTopFriends();
  }
  getTopFriends(){
    Future.delayed(Duration.zero, () async {
      var appConstants = Provider.of<AppConstants>(context, listen: false);
      topFriends = ApiServices().fetchUserTopFriends(context, id: appConstants.userRegisteredId);

      setState(() {});
      
    });
  }

  @override
  Widget build(BuildContext context) {
    var appConstants = Provider.of<AppConstants>(context, listen: true);
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: 
        SingleChildScrollView(
          child: Padding(
            padding: getCustomPadding(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                spacing_medium,
                TextHeader1(
                              title: 'Filter:',
                            ),
                spacing_medium,
                Theme(
                    data:
                        Theme.of(context).copyWith(dividerColor: transparent),
                    child: ExpansionTile(
                      // key: UniqueKey(),
                      // initiallyExpanded: _isExpanded,
                      controller: topFriendsExpansionTile,
                
                      maintainState: true,
                      // backgroundColor: Colors.red,
                      // collapsedBackgroundColor: Colors.yellow,
                      // shape: roundedBorderCustom(sunscriptionValue: appConstants.userModel.subScriptionValue),
                      // collapsedShape: roundedBorderCustom(sunscriptionValue: appConstants.userModel.subScriptionValue),
                      onExpansionChanged: (value) {},
                      childrenPadding: getCustomPadding(),
                      iconColor: green,
                      // trailing:Icon(
                      //         Icons.done,
                      //         color: grey.withValues(alpha:0.6),
                      //       ),
                      // initiallyExpanded: appConstants.userModel.subScriptionValue==2?false:true ,
                      title: Text(
                        'Favorite',
                        style: heading1TextStyle(context, width
                           ),
                      ),
                    children: [
                        
                      topFriends==null ? SizedBox.shrink():
                      SizedBox(
                        height: height * 0.15,
                                            width: width,
                        child: StreamBuilder<QuerySnapshot>(
                          stream: topFriends,
                          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasError) {
                              return const Text('Ooops...Something went wrong :(');
                            }
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Text("");
                            }
                            if (snapshot.data!.size == 0) {
                              return SizedBox(
                                width: width*0.85,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
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
                              physics: const BouncingScrollPhysics(),
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (BuildContext context, int index) {
                                // print(snapshot.data!.docs[index] ['USER_first_name']);
                                return InkWell(
                                  onTap: () async {
                                    selectedUserId = snapshot.data!.docs[index].id;
                                    logMethod(title: 'Selected User From Filter', message: snapshot.data!.docs[index].id);
                                    setState(() {
                                      
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: selectedUserId== snapshot.data!.docs[index].id?Border.all(color: green):null,
                                      borderRadius: BorderRadius.circular(width*0.4)
                                    ),
                                    child: TopFriendsCustomWidget(
                                      selectedIndexTopFriends: 0,
                                      width: width,
                                      index: index,
                                      snapshot: snapshot.data!.docs[index],
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
                // spacing_medium,
                CustomDivider(),
                
            //     TextButton(
            //       child: Text('Check filter'),
            //       onPressed: (){
            //         showDialog(
            //     context: context,
            //     builder: (BuildContext context) {
            //  return  Dialog(
            //       child: Container(
            // padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            // height: 659,
            // width: 0,
            // decoration: BoxDecoration(
            //   color: Colors.white,
            //   borderRadius: BorderRadius.circular(12),
            // ),
            // child: Column(
            //   children: [
            //   Row(children: [
            //     const Text(
            //       'Filter your search',
            //       style: TextStyle(color: Color(0xFF181C2E), fontSize: 16),
            //     ),
            //     const SizedBox(width: 60),
            //     Padding(
            //       padding: const EdgeInsets.only(left: 18),
            //       child: Container(
            //           height: 45,
            //           width: 45,
            //           decoration: BoxDecoration(
            //             borderRadius: BorderRadius.circular(25),
            //             color: const Color(0xFFECF0F4),
            //           ),
            //           child: const Icon(Icons.clear)),
            //     ),
            //   ]),
            //   const SizedBox(height: 10),
            //   SizedBox(
            //       height: 130,
            //       width: 291,
            //       child: 
            //       // Here is the offers column
            //       Column(children: [
            //         const Padding(
            //           padding: EdgeInsets.only(right: 200, bottom: 10),
            //           child: Text(
            //             'OFFERS',
            //             style: TextStyle(color: Color(0xFF181C2E), fontSize: 12),
            //           ),
            //         ),
            //         Row(children: [
            //           // delivery container or
            //           Container(
            //             width: 82,
            //             height: 46,
            //             decoration: BoxDecoration(
            //               borderRadius: const BorderRadius.all(Radius.circular(33)),
            //               border: Border.all(
            //                   width: 2.0,
            //                   color: const Color(0xFFEDEDED),
            //                   style: BorderStyle.solid),
            //             ),
            //             child: const Padding(
            //               padding: EdgeInsets.only(top: 8),
            //               child: Text(
            //                 'Delivery',
            //                 textAlign: TextAlign.center,
            //                 style: TextStyle(
            //                   color: Color(0xFF464E57),
            //                   fontSize: 14,
            //                   fontFamily: 'Sen',
            //                 ),
            //               ),
            //             ),
            //           ),
            //           const SizedBox(
            //             width: 5,
            //           ),
            //           Container(
            //             // or pick up container
            //             width: 80,
            //             height: 46,
            //             decoration: BoxDecoration(
            //               borderRadius: const BorderRadius.all(Radius.circular(33)),
            //               border: Border.all(
            //                   width: 2.0,
            //                   color: const Color(0xFFEDEDED),
            //                   style: BorderStyle.solid),
            //             ),
            //             child: const Padding(
            //               padding: EdgeInsets.only(top: 8),
            //               child: Text(
            //                 'Pick up',
            //                 textAlign: TextAlign.center,
            //                 style: TextStyle(
            //                   color: Color(0xFF181C2E),
            //                   fontSize: 14,
            //                   fontFamily: 'Sen',
            //                 ),
            //               ),
            //             ),
            //           ),
            //           const SizedBox(
            //             width: 5,
            //           ),
            //           Container(
            //             // or offers container
            //             width: 78,
            //             height: 46,
            //             decoration: BoxDecoration(
            //               borderRadius: const BorderRadius.all(Radius.circular(33)),
            //               border: Border.all(
            //                   width: 2.0,
            //                   color: const Color(0xFFEDEDED),
            //                   style: BorderStyle.solid),
            //             ),
            //             child: const Padding(
            //               padding: EdgeInsets.only(top: 8),
            //               child: Text(
            //                 'Offer',
            //                 textAlign: TextAlign.center,
            //                 style: TextStyle(
            //                   color: Color(0xFF181C2E),
            //                   fontSize: 14,
            //                   fontFamily: 'Sen',
            //                 ),
            //               ),
            //             ),
            //           ),
            //         ]),
            //         const SizedBox(
            //           height: 10,
            //         ),
            //         Padding(
            //           padding: const EdgeInsets.only(right: 34),
            //           child: 
            //             // or online payment available container
            //           Container(
            //             width: 219,
            //             height: 45.96,
            //             decoration: BoxDecoration(
            //               borderRadius: const BorderRadius.all(Radius.circular(33)),
            //               border: Border.all(
            //                   width: 2.0,
            //                   color: const Color(0xFFEDEDED),
            //                   style: BorderStyle.solid),
            //             ),
            //             child: const Padding(
            //               padding: EdgeInsets.only(top: 8),
            //               child: Text(
            //                 'Online payment available',
            //                 textAlign: TextAlign.center,
            //                 style: TextStyle(
            //                   color: Color(0xFF181C2E),
            //                   fontSize: 14,
            //                   fontFamily: 'Sen',
            //                 ),
            //               ),
            //             ),
            //           ),
            //         ),
            //       ])),
            //   const SizedBox(
            //     height: 25,
            //   ),
            //   const Padding(
            //     padding: EdgeInsets.only(right: 169, bottom: 10),
            //     child: 
            //            // And then Click on any option on
            //     //children of Delivery-Time
            //     Text(
            //       'DELIVERY-TIME',
            //       style: TextStyle(color: Color(0xFF181C2E), fontSize: 12),
            //     ),
            //   ),
            //   Row(children: [
            //     Container(
            //       // First Container with 10-15 min
            //       width: 86,
            //       height: 46,
            //       decoration: BoxDecoration(
            //         borderRadius: const BorderRadius.all(Radius.circular(33)),
            //         border: Border.all(
            //             width: 2.0,
            //             color: const Color(0xFFEDEDED),
            //             style: BorderStyle.solid),
            //       ),
            //       child: const Padding(
            //         padding: EdgeInsets.only(top: 8),
            //         child: Text(
            //           '10-15 min',
            //           textAlign: TextAlign.center,
            //           style: TextStyle(
            //             color: Color(0xFF464E57),
            //             fontSize: 14,
            //             fontFamily: 'Sen',
            //           ),
            //         ),
            //       ),
            //     ),
            //     const SizedBox(
            //       width: 4,
            //     ),
            //     Container(
            //       // First Container with 20 min
            //       width: 80,
            //       height: 46,
            //       decoration: BoxDecoration(
            //         borderRadius: const BorderRadius.all(Radius.circular(33)),
            //         border: Border.all(
            //             width: 2.0,
            //             color: const Color(0xFFEDEDED),
            //             style: BorderStyle.solid),
            //       ),
            //       child: const Padding(
            //         padding: EdgeInsets.only(top: 8),
            //         child: Text(
            //           '20 min',
            //           textAlign: TextAlign.center,
            //           style: TextStyle(
            //             color: Color(0xFF181C2E),
            //             fontSize: 14,
            //             fontFamily: 'Sen',
            //           ),
            //         ),
            //       ),
            //     ),
            //     const SizedBox(
            //       width: 5,
            //     ),
            //     Container(
            //       // First Container with 30 min
            //       width: 75,
            //       height: 46,
            //       decoration: BoxDecoration(
            //         borderRadius: const BorderRadius.all(Radius.circular(33)),
            //         border: Border.all(
            //             width: 2.0,
            //             color: const Color(0xFFEDEDED),
            //             style: BorderStyle.solid),
            //       ),
            //       child: const Padding(
            //         padding: EdgeInsets.only(top: 8),
            //         child: Text(
            //           '30 min',
            //           textAlign: TextAlign.center,
            //           style: TextStyle(
            //             color: Color(0xFF181C2E),
            //             fontSize: 14,
            //             fontFamily: 'Sen',
            //           ),
            //         ),
            //       ),
            //     ),
            //   ]),
            //   const SizedBox(
            //     height: 25,
            //   ),
            //   const Padding(
            //     padding: EdgeInsets.only(right: 200, bottom: 10),
            //     child: 
            //               // And then Click on any option on
            //     //Pricing children
            //     Text(
            //       'PRICING',
            //       style: TextStyle(color: Color(0xFF181C2E), fontSize: 12),
            //     ),
            //   ),
            //   Row(children: [
            //     // FIRST PRICE
            //     Container(
            //       alignment: Alignment.center,
            //       width: 48,
            //       height: 48,
            //       decoration: BoxDecoration(
            //         color: Colors.white,
            //         borderRadius: BorderRadius.circular(25),
            //         border: Border.all(
            //           color: Color(0XFFEDEDED),
            //           width: 2,
            //         ),
            //       ),
            //       child: Text(
            //         '\$',
            //         style: TextStyle(),
            //       ),
            //     ),
            //     SizedBox(width: 5),
            //     // SECOND PRICE
            //     Container(
            //       alignment: Alignment.center,
            //       width: 48,
            //       height: 48,
            //       decoration: BoxDecoration(
            //         color: Colors.orange,
            //         borderRadius: BorderRadius.circular(25),
            //         border: Border.all(
            //           color: Color(0XFFEDEDED),
            //           width: 2,
            //         ),
            //       ),
            //       child: Text(
            //         '\$\$',
            //         style: TextStyle(
            //           color: Colors.white,
            //         ),
            //       ),
            //     ),
            //     SizedBox(width: 5),
            //     // THIRD PRICE
            //     Container(
            //       alignment: Alignment.center,
            //       width: 48,
            //       height: 48,
            //       decoration: BoxDecoration(
            //         color: Colors.white,
            //         borderRadius: BorderRadius.circular(25),
            //         border: Border.all(
            //           color: const Color(0XFFEDEDED),
            //           width: 2,
            //         ),
            //       ),
            //       child: const Text(
            //         '\$\$\$',
            //         style: TextStyle(),
            //       ),
            //     ),
            //   ]),
            //   const SizedBox(
            //     height: 25,
            //   ),
            //   // And then Click on any option on
            //   //  Rating Children
            //   const Padding(
            //     padding: EdgeInsets.only(right: 200, bottom: 10),
            //     child: Text(
            //       'RATING',
            //       style: TextStyle(color: Color(0xFF181C2E), fontSize: 12),
            //     ),
            //   ),
            //   Row(children: [
            //     Container(
            //       // 1 Star Rating
            //         alignment: Alignment.center,
            //         width: 40,
            //         height: 40,
            //         decoration: BoxDecoration(
            //           color: Colors.white,
            //           borderRadius: BorderRadius.circular(25),
            //           border: Border.all(
            //             color: const Color(0XFFEDEDED),
            //             width: 2,
            //           ),
            //         ),
            //         child: const Icon(Icons.star, color: Colors.orange)),
            //     const SizedBox(
            //       width: 5,
            //     ),
            //       // 2 Star Rating
            //     Container(
            //         alignment: Alignment.center,
            //         width: 40,
            //         height: 40,
            //         decoration: BoxDecoration(
            //           color: Colors.white,
            //           borderRadius: BorderRadius.circular(25),
            //           border: Border.all(
            //             color: const Color(0XFFEDEDED),
            //             width: 2,
            //           ),
            //         ),
            //         child: const Icon(Icons.star, color: Colors.orange)),
            //     const SizedBox(
            //       width: 5,
            //     ),
            //       // 3 Star Rating
            //     Container(
            //         alignment: Alignment.center,
            //         width: 40,
            //         height: 40,
            //         decoration: BoxDecoration(
            //           color: Colors.white,
            //           borderRadius: BorderRadius.circular(25),
            //           border: Border.all(
            //             color: const Color(0XFFEDEDED),
            //             width: 2,
            //           ),
            //         ),
            //         child: const Icon(Icons.star, color: Colors.orange)),
            //     const SizedBox(
            //       width: 5,
            //     ),
            //     Container(
            //       // 4 Star Ratin
            //         alignment: Alignment.center,
            //         width: 40,
            //         height: 40,
            //         decoration: BoxDecoration(
            //           color: Colors.white,
            //           borderRadius: BorderRadius.circular(25),
            //           border: Border.all(
            //             color: Color(0XFFEDEDED),
            //             width: 2,
            //           ),
            //         ),
            //         child: const Icon(Icons.star, color: Colors.orange)),
            //     const SizedBox(
            //       width: 5,
            //     ),
            //       // 5 Star Rating
            //     Container(
            //         alignment: Alignment.center,
            //         width: 40,
            //         height: 40,
            //         decoration: BoxDecoration(
            //           color: Colors.white,
            //           borderRadius: BorderRadius.circular(25),
            //           border: Border.all(
            //             color: const Color(0XFFEDEDED),
            //             width: 2,
            //           ),
            //         ),
            //         child: const Icon(Icons.star_border_outlined,
            //             color: Color(0xFFD9D9D9))),
            //   ]),
            //   const SizedBox(
            //     height: 25,
            //   ),
            //   // AND FINALLY CLICKED ON THIS ELEVATED BUTTON
            //   ElevatedButton(
            //       // style: buttonPrimary2,
            //       onPressed: () {},
            //       child:
            //           const Text('FILTER', style: TextStyle(color: Colors.white)))
            // ]),
            //       ),
            //     );});
            
            //     },),
            Theme(
                    data:
                        Theme.of(context).copyWith(dividerColor: transparent),
                    child: ExpansionTile(
                      // key: UniqueKey(),
                      // initiallyExpanded: _isExpanded,
                      controller: tagItExpansionTile,
                
                      maintainState: true,
                      // backgroundColor: Colors.red,
                      // collapsedBackgroundColor: Colors.yellow,
                      // shape: roundedBorderCustom(sunscriptionValue: appConstants.userModel.subScriptionValue),
                      // collapsedShape: roundedBorderCustom(sunscriptionValue: appConstants.userModel.subScriptionValue),
                      onExpansionChanged: (value) {},
                      childrenPadding: getCustomPadding(),
                      iconColor: green,
                      // trailing:Icon(
                      //         Icons.done,
                      //         color: grey.withValues(alpha:0.6),
                      //       ),
                      // initiallyExpanded: appConstants.userModel.subScriptionValue==2?false:true ,
                      title: Text(
                        'Tag-It',
                        style: heading1TextStyle(context, width
                           ),
                      ),
                    children: [
                        InlineChoice<String>.multiple(
                          // clearable: false,
                          // value: selectedValue,
                          value: queryList,
                          // onChanged: setSelectedValue,
                          itemCount: AppConstants.tagItList.length,
                          
                          // onChanged: (List<String> list){
                          //   logMethod(title: 'Selected Data', message: queryList.toString());
                          //   queryList.addAll(list);
                          //   setState(() {
                          //     // queryList =  list;
                          //   });
                          // },
                          itemBuilder: (state, i) {
                            return
                            AppConstants.tagItList[i].publicTag_it==false ? const SizedBox():
                             Container(
                              decoration: BoxDecoration(
                                color: selectedTagit==i? green:transparent,
                                borderRadius: BorderRadius.circular(width*0.2)
                              ),
                               child: ChoiceChip(
                                selected: state.selected(AppConstants.tagItList[i].id.toString()),
                                showCheckmark: true,
                                onSelected: state.onSelected(AppConstants.tagItList[i].title.toString(), onChanged: (List<String> item){
                                  logMethod(title: 'List After selecting', message: item.toString());
                                  setState(() {
                                    selectedTagit = i;
                                   // String? selectedDateType;
  // String? selectedTransaction;
                                  });
                                }),
                                label: Text(AppConstants.tagItList[i].title.toString()),
                                avatar: Icon(AppConstants.tagItList[i].icon, size: 14,),
                                selectedColor: orange,
                                                           ),
                             );
                          },
                          listBuilder: ChoiceList.createWrapped(
                            spacing: 10,
                            runSpacing: 10,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 10,
                            ),
                          ),
                        ),
                        

                    ],
                    ),
                    ),
                CustomDivider(),
                Theme(
                    data:
                        Theme.of(context).copyWith(dividerColor: transparent),
                    child: ExpansionTile(
                      // key: UniqueKey(),
                      // initiallyExpanded: _isExpanded,
                      controller: walletExpansionTile,
                      maintainState: true,
                      // backgroundColor: Colors.red,
                      // collapsedBackgroundColor: Colors.yellow,
                      // shape: roundedBorderCustom(sunscriptionValue: appConstants.userModel.subScriptionValue),
                      // collapsedShape: roundedBorderCustom(sunscriptionValue: appConstants.userModel.subScriptionValue),
                      onExpansionChanged: (value) {},
                      childrenPadding: getCustomPadding(),
                      iconColor: green,
                      // trailing:Icon(
                      //         Icons.done,
                      //         color: grey.withValues(alpha:0.6),
                      //       ),
                      // initiallyExpanded: appConstants.userModel.subScriptionValue==2?false:true ,
                      title: Text(
                        'Wallet',
                        style: heading1TextStyle(context, width
                           ),
                      ),
                    children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              
                              DropdownButton<String>(
                              value: walletName,
                              onChanged: (String? newValue) {
                                setState(() {
                                  walletName = newValue!;
                                });
                              },
                              items: <String>['All',(appConstants.nickNameModel.NickN_SpendWallet !=null && appConstants.nickNameModel.NickN_SpendWallet !="")
                                                                                    ? appConstants.nickNameModel.NickN_SpendWallet!
                                                                                    : 'Spend-'+'Wallet', 
                                              (appConstants.nickNameModel.NickN_SavingWallet !=null && appConstants.nickNameModel.NickN_SavingWallet != "")
                                                                            ? appConstants.nickNameModel.NickN_SavingWallet! +
                                                                                'Wallet': 'Savings-'.tr() +'Wallet', 
                                              (appConstants.nickNameModel.NickN_DonationWallet != null && appConstants.nickNameModel.NickN_DonationWallet !="")
                                                                            ? appConstants.nickNameModel.NickN_DonationWallet! + ' Wallet'
                                                                            : 'Charity-'.tr() +"Wallet",
                                              'Goals-Wallet' 
                                               ]
                                  .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                                          ),
                            ],
                          ),
                        

                    ],
                    ),
                    ),
              CustomDivider(),
                Theme(
                    data:
                        Theme.of(context).copyWith(dividerColor: transparent),
                    child: ExpansionTile(
                      // key: UniqueKey(),
                      // initiallyExpanded: _isExpanded,
                      controller: dateExpansionTile,
                      maintainState: true,
                      // backgroundColor: Colors.red,
                      // collapsedBackgroundColor: Colors.yellow,
                      // shape: roundedBorderCustom(sunscriptionValue: appConstants.userModel.subScriptionValue),
                      // collapsedShape: roundedBorderCustom(sunscriptionValue: appConstants.userModel.subScriptionValue),
                      onExpansionChanged: (value) {},
                      childrenPadding: getCustomPadding(),
                      iconColor: green,
                      // trailing:Icon(
                      //         Icons.done,
                      //         color: grey.withValues(alpha:0.6),
                      //       ),
                      // initiallyExpanded: appConstants.userModel.subScriptionValue==2?false:true ,
                      title: Text(
                        'Date',
                        style: heading1TextStyle(context, width
                           ),
                      ),
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ZakiCicularButton(
                            title: '7 days',
                            width: width,
                            borderColor:selectedDateType=='7'? orange:null,
                            onPressed: (){
                              setState(() {
                                selectedDateType='7';
                                endDate = DateTime.now();
                                startDate = DateTime.now().subtract(Duration(days: 7));
                              });
                            },
                          ),
                          ZakiCicularButton(
                            title: '30 days',
                            width: width,
                            borderColor:selectedDateType=='30'? orange:null,
                            onPressed: (){
                              setState(() {
                                selectedDateType='30';
                                endDate = DateTime.now();
                                startDate = DateTime.now().subtract(Duration(days: 30));
                              });
                            },
                          ),
                          ZakiCicularButton(
                            title: '90 days',
                            width: width,
                            borderColor:selectedDateType=='90'? orange:null,
                            onPressed: (){
                              setState(() {
                                selectedDateType='90';
                                endDate = DateTime.now();
                                startDate = DateTime.now().subtract(Duration(days: 90));
                              });
                            },
                          ),
                          ZakiCicularButton(
                            title: '180 days',
                            borderColor:selectedDateType=='180'? orange:null,
                            width: width,
                            onPressed: (){
                              setState(() {
                                selectedDateType='180';
                                endDate = DateTime.now();
                                startDate = DateTime.now().subtract(Duration(days: 180));
                              });
                            },
                          ),
                        ],
                      ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextHeader1(
                                title: 'Choose Date Range',
                              ),
                              IconButton(
                                icon: Icon(Icons.date_range_outlined, color:selectedDateType=='custom'? orange:null,),
                                onPressed: () async{
                              DateTimeRange? picked = await showDateRangePicker(
                        context: context,
                        firstDate: DateTime(DateTime.now().year - 5),
                        lastDate: DateTime(DateTime.now().year + 5),
                        initialDateRange: DateTimeRange(
                          end: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 13),
                          start: DateTime.now(),
                        ),
                        builder: (context, child) {
                          return Column(
                            children: [
                              ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxWidth: 400.0,
                                ),
                                child: child,
                              )
                            ],
                          );
                        });
                        if(picked!=null){

                            logMethod(title: 'Selected Date Range', message: picked.toString());
                            setState(() {
                              selectedDateType='custom';
                              startDate= picked.start;
                              endDate= picked.end;
                            });
                        }
                              })
                            ],
                          ),
                          

                    ],
                    ),
                    ),
            CustomDivider(),
                Theme(
                    data:
                        Theme.of(context).copyWith(dividerColor: transparent),
                    child: ExpansionTile(
                      // key: UniqueKey(),
                      // initiallyExpanded: _isExpanded,
                      controller: transactionTypeExpansionTile,
                      maintainState: true,
                      // backgroundColor: Colors.red,
                      // collapsedBackgroundColor: Colors.yellow,
                      // shape: roundedBorderCustom(sunscriptionValue: appConstants.userModel.subScriptionValue),
                      // collapsedShape: roundedBorderCustom(sunscriptionValue: appConstants.userModel.subScriptionValue),
                      onExpansionChanged: (value) {},
                      childrenPadding: getCustomPadding(),
                      iconColor: green,
                      // trailing:Icon(
                      //         Icons.done,
                      //         color: grey.withValues(alpha:0.6),
                      //       ),
                      // initiallyExpanded: appConstants.userModel.subScriptionValue==2?false:true ,
                      title: Text(
                        'Transaction Type',
                        style: heading1TextStyle(context, width
                           ),
                      ),
                    children: [
                          
                          InlineChoice<String>.multiple(
                          clearable: false,
                          // value: selectedValue,
                          // onChanged: setSelectedValue,
                          itemCount: AppConstants.TRANSACTION_LIST.length,
                          
                          onChanged: (List<String> list){
                            logMethod(title: 'Selected Data', message: list.toString());
                            setState(() {
                              // queryList = list;
                            });
                          },
                          itemBuilder: (state, i) {
                            return
                             Container(
                              decoration: BoxDecoration(
                                color: selectedTransaction==i? green:transparent,
                                borderRadius: BorderRadius.circular(width*0.1)
                              ),
                               child: ChoiceChip(
                                selected: state.selected(AppConstants.TRANSACTION_LIST[i].toString()),
                                onSelected: state.onSelected(AppConstants.TRANSACTION_LIST[i].toString(), onChanged: (List<String> list){
                                  setState(() {
                                    selectedTransaction = i;
                                  });
                                }),
                                label: Text(AppConstants.TRANSACTION_LIST[i].toString()),
                                                           ),
                             );
                          },
                          listBuilder: ChoiceList.createWrapped(
                            spacing: 10,
                            runSpacing: 10,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 10,
                            ),
                          ),
                        ),

                          

                    ],
                    ),
                    ),
            CustomDivider(),
            Row(
              children: [
                Expanded(
                  child: ZakiPrimaryButton(
                                    title: 'Clear All',
                                    width: width * 0.7,
                                    backgroundTransparent: 1,
                                    textColor: grey,
                                    onPressed:clear,
                  ),
                ),
                SizedBox(width: 10,),
                Expanded(
                  child: ZakiPrimaryButton(
                                    title: 'View',
                                    width: width * 0.7,
                                    onPressed: (){
                  
                                    },
                  ),
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
              // SwitchListTile(
              //   title: Text("Only Available"),
              //   value: onlyAvailable,
              //   onChanged: (bool value) {
              //     setState(() {
              //       onlyAvailable = value;
              //     });
              //   },
              // ),

              StreamBuilder<List<Item>>(
                // stream: ApiServices(). fetchTransactions(categoryFilter: walletName,minPrice: minPrice, maxPrice: maxPrice, onlyAvailable: onlyAvailable, transactionTagitCategory: 'Fund_My_Wallet'),
                stream: ApiServices().fetchTransactions(transactionTagitCategory: queryList, userId: appConstants.userRegisteredId, maxPrice: maxPrice, minPrice: minPrice, walletName: walletName, startDate: startDate, endDate: endDate, selectedUserId: selectedUserId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData) {
                    return Center(child: Text('No items found'));
                  }
                  var items = snapshot.data!;
                  return ListView.builder(
                    itemCount: items.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(items[index].transactionAmount.toString()),
                        subtitle: Text('${items[index].transactionFromWallet} - \$${items[index].transactionTagitCategory}'),
                      );
                    },
                  );
                },
              ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FilterWidget extends StatefulWidget {
  @override
  _FilterWidgetState createState() => _FilterWidgetState();
}

class _FilterWidgetState extends State<FilterWidget> {
  String walletName = 'All';
  double minPrice = 0;
  double maxPrice = 1000;
  bool onlyAvailable = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Item Filter')),
      body: Column(
        children: <Widget>[
          
        ],
      ),
    );
  }
}
