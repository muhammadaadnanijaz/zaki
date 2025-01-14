// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:zaki/Widgets/CustomLoader.dart';
import '../Constants/Styles.dart';
// import 'package:provider/provider.dart';
// import 'package:zaki/Constants/HelperFunctions.dart';
// import 'package:zaki/Constants/Styles.dart';
// import 'package:zaki/Models/CardBackgroundImage.dart';
// import 'package:zaki/Screens/ActivateCard.dart';
// import 'package:zaki/Screens/SpendingLimit.dart';
// import 'package:zaki/Screens/IssueDebitCard.dart';
// import 'package:zaki/Widgets/CustomSizedBox.dart';

// import '../Constants/AppConstants.dart';
// import '../Services/api.dart';
// import '../Widgets/BackgroundConatiner.dart';

// class IssueAndManageCards extends StatefulWidget {
//   const IssueAndManageCards({Key? key}) : super(key: key);

//   @override
//   State<IssueAndManageCards> createState() => _IssueAndManageCardsState();
// }

// class _IssueAndManageCardsState extends State<IssueAndManageCards> {

// Stream<QuerySnapshot>? userKidsCards;
//     @override
//   void initState() {
//     super.initState();
//     getUserKids();
//   }

//   getUserKids() {
//     Future.delayed(const Duration(milliseconds: 200), () {
//       setState(() {
//         var appConstants = Provider.of<AppConstants>(context, listen: false);
//         userKidsCards = ApiServices().fetchUserKidsCards(parentId: appConstants.userRegisteredId);
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     var appConstants = Provider.of<AppConstants>(context, listen: true);
//     var height = MediaQuery.of(context).size.height;
//     var width = MediaQuery.of(context).size.width;
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//            's'.tr() ,
//           style:
//               textStyleHeading1WithTheme(context, width * 0.8, whiteColor: 0),
//         ),
//         centerTitle: true,
//         backgroundColor: transparent,
//         elevation: 0,
//         leading: IconButton(
//           icon: (Icon(
//             Icons.clear,
//             color: black,
//           )),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//         actions: [
//           IconButton(
//             icon: Icon(
//               Icons.edit_note_sharp,
//               color: black,
//             ),
//             onPressed: () {
//               Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => const SpendingLimit()));
//             },
//           )
//         ],
//       ),
//       body: SingleChildScrollView(
//         physics: const BouncingScrollPhysics(),
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                'Your Card'.tr() ,
//                 style: textStyleHeading1WithTheme(context, width * 0.8,
//                     whiteColor: 0),
//               ),
//               CustomSizedBox(
//                 height: height,
//               ),
//               userKidsCards == null
//                     ? const SizedBox()
//                     :
//                     StreamBuilder<QuerySnapshot>(
//                       stream: userKidsCards,
//                       builder: (BuildContext context,
//                           AsyncSnapshot<QuerySnapshot> snapshot) {
//                         if (snapshot.hasError) {
//                           return const Text('Something went wrong');
//                         }

//                         if (snapshot.connectionState ==
//                             ConnectionState.waiting) {
//                           return Center(child: CustomLoader(color: green,));
//                         }
//                         if (snapshot.data!.size == 0) {
//                           return const Center(child: Text(""));
//                         }
// //snapshot.data!.docs[index] ['USA_first_name']
//                         return ListView.builder(
//                           itemCount: snapshot.data!.docs.length,
//                           physics: const NeverScrollableScrollPhysics(),
//                           shrinkWrap: true,
//                           itemBuilder: (BuildContext context, int index) {
//                             // print(snapshot.data!.docs[index] ['USA_first_name']);
//                             return
//                             snapshot.data!.docs[index].id==appConstants.userRegisteredId?
//                             InkWell(
//                     onTap: () {
//                       cardInformation(context, width, height);
//                     },
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(vertical: 4.0),
//                       child: CreaditCard(width, appConstants, height, snapshot: snapshot.data!.docs[index]),
//                     ),
//                   )
//                   :const SizedBox();
//                           },
//                         );
//                       },
//                     ),
//               CustomSizedBox(
//                 height: height,
//               ),
//               CustomSizedBox(
//                 height: height,
//               ),
//               Text(
//                 'ZakiPay Family Cards'.tr() ,
//                 style: textStyleHeading1WithTheme(context, width * 0.8,
//                     whiteColor: 0),
//               ),
//               CustomSizedBox(
//                 height: height,
//               ),
//               CustomSizedBox(
//                 height: height,
//               ),
//               Container(
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(10),
//                   color: green.withValues(alpha:0.15)
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(12.0),
//                   child: Row(
//                     children: [
//                       Icon(Icons.add_card, color: green),
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 12.0),
//                         child: Text('Manage Cards Spend Limits.',
//                         style: textStyleHeading1WithTheme(context, width * 0.7,
//                         whiteColor: 0),),
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//               CustomSizedBox(
//                 height: height,
//               ),
//               CustomSizedBox(
//                 height: height,
//               ),
//               Container(
//                 decoration:
//                     cardBackgroundConatiner(width, const Color(0XFF9831F5), backgroundImageUrl: ""),
//                 child: Padding(
//                   padding:
//                       const EdgeInsets.all(12),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       SizedBox(
//                         height: height*0.06,
//                       ),
//                       Text(
//                         'lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
//                         style: textStyleHeading2WithTheme(context, width * 0.65,
//                             whiteColor: 1),
//                       ),
//                       CustomSizedBox(
//                         height: height,
//                       ),
//                       CustomSizedBox(
//                         height: height,
//                       ),
//                       Align(
//                         alignment: Alignment.centerRight,
//                         child: TextButton(
//                           style:  ButtonStyle(
//                             backgroundColor: MaterialStateProperty.all(white)
//                           ),
//                           child: Text(
//                             'Issue Debit Card',
//                             style: textStyleHeading2WithTheme(
//                                 context, width * 0.85,
//                                 whiteColor: 3),
//                           ),
//                           onPressed: () {
//                             Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                     builder: (context) =>
//                                         const IssueDebitCard()));
//                             // Navigator.push(
//                             //     context,
//                             //     MaterialPageRoute(
//                             //         builder: (context) =>
//                             //             const ActivateCard()));
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               CustomSizedBox(
//                 height: height,
//               ),
//               userKidsCards == null
//                     ? const SizedBox()
//                     :
//                     StreamBuilder<QuerySnapshot>(
//                       stream: userKidsCards,
//                       builder: (BuildContext context,
//                           AsyncSnapshot<QuerySnapshot> snapshot) {
//                         if (snapshot.hasError) {
//                           return const Text('Something went wrong');
//                         }

//                         if (snapshot.connectionState ==
//                             ConnectionState.waiting) {
//                           return Center(child: CustomLoader(color: green,));
//                         }
//                         if (snapshot.data!.size == 0) {
//                           return const Center(child: Text(""));
//                         }
// //snapshot.data!.docs[index] ['USA_first_name']
//                         return ListView.builder(
//                           itemCount: snapshot.data!.docs.length,
//                           physics: const NeverScrollableScrollPhysics(),
//                           shrinkWrap: true,
//                           itemBuilder: (BuildContext context, int index) {
//                             // print(snapshot.data!.docs[index] ['USA_first_name']);
//                             return
//                             snapshot.data!.docs[index].id==appConstants.userRegisteredId?const SizedBox():
//                             InkWell(
//                     onTap: () {
//                       Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                     builder: (context) =>
//                                          CardBackGroundImage(selectedCardId: snapshot.data!.docs[index].id, previousImage: snapshot.data!.docs[index][AppConstants.ICard_backGroundImage])));
//                       // cardInformation(context, width, height);
//                     },
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(vertical: 4.0),
//                       child: CreaditCard(width, appConstants, height, snapshot: snapshot.data!.docs[index]),
//                     ),
//                   );
//                           },
//                         );
//                       },
//                     ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void cardInformation(BuildContext? context, double? width, double? height) {
//     showModalBottomSheet(
//         context: context!,
//         isScrollControlled: true,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(width! * 0.09),
//             topRight: Radius.circular(width * 0.09),
//           ),
//         ),
//         builder: (BuildContext bc) {
//           return Padding(
//             padding: MediaQuery.of(context).viewInsets,
//             child: SingleChildScrollView(
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
//                     child: InkWell(
//                       onTap: () {
//                         Navigator.pop(bc);
//                       },
//                       child: Container(
//                         width: width * 0.2,
//                         height: 5,
//                         decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(width * 0.08),
//                             color: grey),
//                       ),
//                     ),
//                   ),
//                   Text(
//                     'ZakiPay Card Info',
//                     style: textStyleHeading2WithTheme(context, width,
//                         whiteColor: 0),
//                   ),
//                   SizedBox(
//                     height: height! * 0.01,
//                   ),
//                   SizedBox(
//                     height: height * 0.01,
//                   ),
//                   Padding(
//                     padding: EdgeInsets.symmetric(
//                       horizontal: width * 0.08,
//                       vertical: width * 0.01,
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'Card Number',
//                           style: textStyleHeading2WithTheme(
//                               context, width * 0.8,
//                               whiteColor: 0),
//                         ),
//                         CustomSizedBox(
//                           height: height,
//                         ),
//                         Text(
//                           '4888 8887 9987 9979',
//                           style: textStyleHeading2WithTheme(
//                               context, width * 0.9,
//                               whiteColor: 0),
//                         ),
//                         const CustomDivider(),
//                         Text(
//                           'Card Holder name',
//                           style: textStyleHeading2WithTheme(
//                               context, width * 0.8,
//                               whiteColor: 0),
//                         ),
//                         CustomSizedBox(
//                           height: height,
//                         ),
//                         Text(
//                           'John Doe',
//                           style: textStyleHeading2WithTheme(
//                               context, width * 0.9,
//                               whiteColor: 0),
//                         ),
//                         const CustomDivider(),
//                         Row(
//                           children: [
//                             Expanded(
//                                 child: Padding(
//                               padding:
//                                   const EdgeInsets.symmetric(horizontal: 2.0),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     'Expiration date',
//                                     style: textStyleHeading2WithTheme(
//                                         context, width * 0.8,
//                                         whiteColor: 0),
//                                   ),
//                                   CustomSizedBox(
//                                     height: height,
//                                   ),
//                                   Text(
//                                     '03/22',
//                                     style: textStyleHeading2WithTheme(
//                                         context, width * 0.9,
//                                         whiteColor: 0),
//                                   ),
//                                   const CustomDivider(),
//                                 ],
//                               ),
//                             )),
//                             const SizedBox(
//                               width: 10,
//                             ),
//                             Expanded(
//                                 child: Padding(
//                               padding:
//                                   const EdgeInsets.symmetric(horizontal: 2.0),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     'Security Code',
//                                     style: textStyleHeading2WithTheme(
//                                         context, width * 0.8,
//                                         whiteColor: 0),
//                                   ),
//                                   CustomSizedBox(
//                                     height: height,
//                                   ),
//                                   Text(
//                                     '777',
//                                     style: textStyleHeading2WithTheme(
//                                         context, width * 0.9,
//                                         whiteColor: 0),
//                                   ),
//                                   const CustomDivider(),
//                                 ],
//                               ),
//                             ))
//                           ],
//                         ),
//                         SizedBox(
//                           height: height * 0.1,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         });
//   }

//   // ignore: non_constant_identifier_names
//   Container CreaditCard(
//       double width, AppConstants appConstants, double height, {QueryDocumentSnapshot? snapshot}) {
//     return Container(
//       // Color(0XFF9831F5)
//       decoration: cardBackgroundConatiner(width, lightGreen, backgroundImageUrl: snapshot![AppConstants.ICard_backGroundImage]),
//       child: Padding(
//         padding: const EdgeInsets.all(12.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       snapshot[AppConstants.ICard_firstName],
//                       style: textStyleHeading1WithTheme(
//                           context, width + width * 0.2,
//                           whiteColor: 1),
//                     ),
//                     Transform.scale(
//                       scale: 0.7,
//                       child: CupertinoSwitch(
//                         value: snapshot[AppConstants.ICard_cardStatus],
//                         activeColor: white,
//                         thumbColor: snapshot[AppConstants.ICard_cardStatus]==false?red:green,
//                         trackColor: white,
//                         onChanged: (value) async{
//                          var response = await Navigator.push(context, MaterialPageRoute(builder: (context)=> ActivateCard(snapShot: snapshot,)));
//                          logMethod(title: 'Pin matched Status:', message: response??'Not');
//                          if (response!=null) {
//                           ApiServices().updateCardStatus(id: snapshot.id, parentId: appConstants.userRegisteredId, status: value);
//                          }
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//                 Text(
//                   'Balance: \n50.00 SAR',
//                   style: textStyleHeading2WithTheme(context, width * 0.7,
//                       whiteColor: 1),
//                 ),
//               ],
//             ),
//             SizedBox(
//               height: height * 0.06,
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   '**** 1289',
//                   style: textStyleHeading2WithTheme(context, width*0.8,
//                       whiteColor: 1),
//                 ),
//                 Text(
//                   '09/25',
//                   style: textStyleHeading1WithTheme(context, width * 0.7,
//                       whiteColor: 1),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class CustomDivider extends StatelessWidget {
  const CustomDivider({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: black.withValues(alpha:0.5),
    );
  }
}
