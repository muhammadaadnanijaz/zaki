import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_pagination/firebase_pagination.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zaki/Constants/Spacing.dart';
import 'package:zaki/Widgets/CustomLoader.dart';
import 'package:zaki/Widgets/TextHeader.dart';

import '../Constants/AppConstants.dart';
import '../Constants/Styles.dart';
import '../Services/api.dart';
import '../Widgets/AppBars/AppBar.dart';
import '../Widgets/ExpiredOrComplatedGoalTile.dart';

class CompletedGoals extends StatefulWidget {
  const CompletedGoals({Key? key}) : super(key: key);

  @override
  State<CompletedGoals> createState() => _CompletedGoalsState();
}

class _CompletedGoalsState extends State<CompletedGoals> {
  // Stream<QuerySnapshot>? completedGoals;
   Query? completedGoalsQuery;

  @override
  void initState() {
    getCompletedOrExpiredGoals();
    super.initState();
    
  }

  getCompletedOrExpiredGoals() {
    Future.delayed(const Duration(milliseconds: 200), () {
      var appConstants = Provider.of<AppConstants>(context, listen: false);
      setState(() {
        completedGoalsQuery = ApiServices()
            .getCompletedOrExpiredGoalsWithQuery(appConstants.userRegisteredId);
        // completedGoals = ApiServices()
        //     .getCompletedOrExpiredGoals(appConstants.userRegisteredId);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // var appConstants = Provider.of<AppConstants>(context, listen: true);
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: getCustomPadding(),
          child: Column(
            children: [ 
              appBarHeader_005(
                  context: context,
                  appBarTitle: 'Expired & Completed Goals',
                  backArrow: false,
                  height: height,
                  width: width,
                  leadingIcon: true),
              if(completedGoalsQuery!=null)
              Expanded(
              child: FirestorePagination(
                                // query: allTransactions,
                                // query: FirebaseFirestore.instance.collection('${AppConstants.USER}/${appConstants.userRegisteredId}/${AppConstants.Transaction}').orderBy(AppConstants.created_at, descending: true),
                                query: completedGoalsQuery!,
                                // query: FirebaseFirestore.instance.collection(AppConstants().COUNTRY_CODE).doc(AppConstants().BANK_ID).collection(AppConstants.USER).doc(userId).collection(AppConstants.Transaction),
                                  // query: FirebaseFirestore.instance.collection(AppConstants().COUNTRY_CODE).doc(AppConstants().BANK_ID).collection(AppConstants.USER).orderBy(AppConstants.USER_created_at),
                                  isLive: true,
                                  physics: AlwaysScrollableScrollPhysics(),
                                  scrollDirection: Axis.vertical,
                                  limit: 10,
                                  shrinkWrap: true,
                                  initialLoader: CustomLoader(),
                                  onEmpty: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: height * 0.1,
                                ),
                                Center(
                                    child: Image.asset(
                                        imageBaseAddress + 'no_goal.png')),
                                spacing_medium,
                                TextHeader1(
                                  title: 'Nothing to see here',
                                ),
                              ],
                            ),
                                  bottomLoader: Center(child: CircularProgressIndicator()),
                                  itemBuilder: (context, documentSnapshot, index) {
                                    // final data = documentSnapshot.data() as Map<String, dynamic>;
                                    final queryDocumentSnapshot = documentSnapshot[index] as QueryDocumentSnapshot<Object?>;
    return ExpiredOrComplatedCustomTile(
                                        snapshot: queryDocumentSnapshot);
                                    // Padding(
                                    //   padding: const EdgeInsets.all(24.0),
                                    //   child: Text(item.goalName.toString()),
                                    // );
                                },
                              ),),
              // Expanded(
              //   child: completedGoals == null
              //       ? SizedBox.shrink()
              //       : StreamBuilder(
              //           stream: completedGoals,
              //           //     stream: FirebaseFirestore.instance.collection(AppConstants.GOAL)
              //           // .where(AppConstants.GOAL_Status, isNotEqualTo: "AppConstants.GOAL_Status_Active")
              //           // .where(AppConstants.GOAL_user_id, isEqualTo: appConstants.userRegisteredId)
              //           // .snapshots(),
              //           // .orderBy(AppConstants.GOAL_created_at, descending: false).snapshots(),
              //           // initialData: initialData,
              //           builder:
              //               (BuildContext context, AsyncSnapshot snapshot) {
              //             if (snapshot.hasError) {
              //               return const Text(
              //                   'Ooops...Something went wrong :(');
              //             }

              //             if (snapshot.connectionState ==
              //                 ConnectionState.waiting) {
              //               return const Text("");
              //             }
              //             if (snapshot.data!.size == 0) {
              //               return Column(
              //                 crossAxisAlignment: CrossAxisAlignment.center,
              //                 children: [
              //                   SizedBox(
              //                     height: height * 0.1,
              //                   ),
              //                   Center(
              //                       child: Image.asset(
              //                           imageBaseAddress + 'no_goal.png')),
              //                   spacing_medium,
              //                   TextHeader1(
              //                     title: 'Nothing to see here',
              //                   ),
              //                 ],
              //               );
              //             }
              //             return Padding(
              //               padding: EdgeInsets.only(bottom: height * 0.08),
              //               child: ListView.builder(
              //                 itemCount: snapshot.data!.docs.length,
              //                 physics: const BouncingScrollPhysics(),
              //                 shrinkWrap: true,
              //                 itemBuilder: (BuildContext context, int index) {
              //                   return InkWell(
              //                       onTap: () {},
              //                       child: ExpiredOrComplatedCustomTile(
              //                           snapshot: snapshot.data!.docs[index])
              //                       // Padding(
              //                       //   padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 0),
              //                       //   child: Column(
              //                       //     children: [
              //                       //       Container(
              //                       //         decoration: BoxDecoration(
              //                       //             borderRadius:
              //                       //                 BorderRadius.circular(width * 0.02),
              //                       //             border: Border.all(
              //                       //               color: grey,
              //                       //             )),
              //                       //         child: Padding(
              //                       //           padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 0),
              //                       //           child: Column(
              //                       //             children: [
              //                       //               Row(
              //                       //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //                       //                 children: [
              //                       //                   Text(
              //                       //                   '${snapshot.data!.docs[index] [AppConstants.GOAL_name]}',
              //                       //                   style: textStyleHeading1WithTheme(
              //                       //                       context, width * 0.8,
              //                       //                       whiteColor: 0),
              //                       //                 ),
              //                       //                 snapshot.data!.docs[index] [AppConstants.GOAL_Status]=="completed"? const SizedBox.shrink():
              //                       //                 InkWell(
              //                       //                   onTap: (){
              //                       //                     appConstants.updateGoalModel(
              //                       //                     GoalModel(
              //                       //                       docId: snapshot.data!.docs[index].id,
              //                       //                       goalDate: snapshot.data!.docs[index][AppConstants.GOAL_created_at].toDate(),
              //                       //                       goalName: snapshot.data!.docs[index][AppConstants.GOAL_name],
              //                       //                       goalPrice: snapshot.data!.docs[index][AppConstants.Goal_Target_Amount].toString(),
              //                       //                       topSecret: snapshot.data!.docs[index][AppConstants.GOAL_isPrivate],
              //                       //                       userId: appConstants.userRegisteredId
              //                       //                     ));
              //                       //                     Navigator.push(
              //                       //                         context,
              //                       //                         MaterialPageRoute(
              //                       //                             builder: (context) => const NewGoal()));
              //                       //                   },
              //                       //                   child: const Icon(Icons.more_horiz)),
              //                       //                 ],
              //                       //               ),
              //                       //               Row(
              //                       //                 mainAxisAlignment:
              //                       //                     MainAxisAlignment.spaceEvenly,
              //                       //                 children: [
              //                       //                   Padding(
              //                       //                     padding:
              //                       //                         const EdgeInsets.all(8.0),
              //                       //                     child: Column(
              //                       //                       crossAxisAlignment: CrossAxisAlignment.center,
              //                       //                       mainAxisAlignment: MainAxisAlignment.center,
              //                       //                       children: [
              //                       //                         Image.asset(imageBaseAddress +
              //                       //                             'goal.png'),
              //                       //                         SizedBox(
              //                       //                             height: height * 0.01),
              //                       //                         appConstants.userModel.usaCountry=="Pakistan"?

              //                       //                       Row(
              //                       //                         children: [
              //                       //                           Text(
              //                       //                             '${getFormatedNumber(number: (snapshot.data!.docs[index][AppConstants.Goal_Target_Amount]).toDouble()
              //                       //                               )}'.toString(),
              //                       //                             style:
              //                       //                                 textStyleHeading1WithTheme(
              //                       //                                     context,
              //                       //                                     width,
              //                       //                                     whiteColor: 0),
              //                       //                           ),
              //                       //                           Padding(
              //                       //                             padding: const EdgeInsets.only(left: 2.0),
              //                       //                             child: Text(
              //                       //                               '${getCurrencySymbol(context, appConstants: appConstants)}',
              //                       //                               style:
              //                       //                                   textStyleHeading2WithTheme(
              //                       //                                       context,
              //                       //                                       width * 0.8,
              //                       //                                       whiteColor: 0),),
              //                       //                           )
              //                       //                         ],
              //                       //                       ):
              //                       //                       Row(
              //                       //                         children: [
              //                       //                           Padding(
              //                       //                             padding: const EdgeInsets.only(right: 2.0),
              //                       //                             child: Text(
              //                       //                               '${getCurrencySymbol(context, appConstants: appConstants)}',
              //                       //                               style:
              //                       //                                   textStyleHeading2WithTheme(
              //                       //                                       context,
              //                       //                                       width * 0.8,
              //                       //                                       whiteColor: 0),),
              //                       //                           ),
              //                       //                           Text(
              //                       //                             '${getFormatedNumber(number: (snapshot.data!.docs[index][AppConstants.Goal_Target_Amount]).toDouble()
              //                       //                               )}'.toString(),
              //                       //                             style:
              //                       //                                 textStyleHeading1WithTheme(
              //                       //                                     context,
              //                       //                                     width,
              //                       //                                     whiteColor: 0),
              //                       //                           ),

              //                       //                         ],
              //                       //                       )
              //                       //                       ],
              //                       //                     ),
              //                       //                   ),
              //                       //                   /////////////
              //                       //                   // if(snapshot.data!.docs[index] [AppConstants.GOAL_Status]=="AppConstants.GOAL_Status_Active")
              //                       //           /////////////If status is completed then days option will not be shown
              //                       //                   if(snapshot.data!.docs[index] [AppConstants.GOAL_Status]=="expired")
              //                       //                   Padding(
              //                       //                     padding:
              //                       //                         const EdgeInsets.all(8.0),
              //                       //                     child: Column(
              //                       //                       children: [

              //                       //                         //  (!snapshot.data!.docs[index] ['GOAL_expired_status'] && !snapshot.data!.docs[index] ['GOAL_complete_status'])?

              //                       //                        snapshot.data!.docs[index] [AppConstants.GOAL_Status]=="expired"?
              //                       //                         Image.asset(imageBaseAddress +
              //                       //                             'expire_loading.png') :
              //                       //                         Image.asset(imageBaseAddress +
              //                       //                             'loading.png'),
              //                       //                         SizedBox(
              //                       //                             height: height * 0.01),
              //                       //                         Text(
              //                       //                           '${daysBetween(from: DateTime.now(),to: snapshot.data!.docs[index] [AppConstants.GOAL_created_at].toDate())}d',
              //                       //                           style:
              //                       //                               textStyleHeading1WithTheme(
              //                       //                                   context,
              //                       //                                   width,
              //                       //                                   whiteColor: 0),
              //                       //                         ),
              //                       //                       ],
              //                       //                     ),
              //                       //                   ),
              //                       //                   Padding(
              //                       //                     padding:
              //                       //                         const EdgeInsets.all(8.0),
              //                       //                     child: Column(
              //                       //                       children: [
              //                       //                         SizedBox(
              //                       //                             // height: height*0.1,
              //                       //                             width: width * 0.12,
              //                       //                             // alignment: Alignment.topCenter,
              //                       //                             child:
              //                       //                                 LinearProgressIndicator(
              //                       //                               value:( ((snapshot.data!.docs[index] [AppConstants.GOAL_amount_collected]).toDouble() / (snapshot.data!.docs[index] [AppConstants.Goal_Target_Amount]).toDouble()) * 100/100),
              //                       //                               backgroundColor: grey,
              //                       //                               color: lightGreen,
              //                       //                               minHeight: height * 0.05,
              //                       //                             )),
              //                       //                         SizedBox(
              //                       //                             height: height * 0.01),
              //                       //                         Text(
              //                       //                           '${(((snapshot.data!.docs[index] [AppConstants.GOAL_amount_collected]).toDouble() / (snapshot.data!.docs[index] [AppConstants.Goal_Target_Amount]).toDouble()) * 100).toInt()}%',
              //                       //                           style:
              //                       //                               textStyleHeading1WithTheme(
              //                       //                                   context,
              //                       //                                   width,
              //                       //                                   whiteColor: 0),
              //                       //                         ),
              //                       //                       ],
              //                       //                     ),
              //                       //                   ),
              //                       //                   SizedBox(
              //                       //                     height: height * 0.1,
              //                       //                     child: const VerticalDivider(
              //                       //                       thickness: 2,
              //                       //                       // width: 1,
              //                       //                     ),
              //                       //                   ),
              //                       //                   snapshot.data!.docs[index] [AppConstants.GOAL_Status]=="expired"?
              //                       //                         Column(
              //                       //                           children: [
              //                       //                             Image.asset(imageBaseAddress +
              //                       //                                 'expire_logo.png'),
              //                       //                             Text(
              //                       //                               'Expired',
              //                       //                           style:
              //                       //                               textStyleHeading1WithTheme(
              //                       //                                   context,
              //                       //                                   width * 0.8,
              //                       //                                   whiteColor: 7),
              //                       //                         ),
              //                       //                           ],
              //                       //                         ) :
              //                       //                   Column(
              //                       //                     children: [

              //                       //                       // snapshot.data!.docs[index] [AppConstants.GOAL_Status] =="uncompleted"?
              //                       //                       //   Image.asset(imageBaseAddress +
              //                       //                       //       'completed.png'):
              //                       //                         Image.asset(imageBaseAddress +
              //                       //                             'completed.png'),
              //                       //                       FittedBox(
              //                       //                         child: Text(
              //                       //                           'Completed',
              //                       //                           style:
              //                       //                               textStyleHeading1WithTheme(
              //                       //                                   context,
              //                       //                                   width * 0.9,
              //                       //                                   whiteColor: 0),
              //                       //                         ),
              //                       //                       ),
              //                       //                     ],
              //                       //                   ),
              //                       //                 ],
              //                       //               ),
              //                       //             ],
              //                       //           ),
              //                       //         ),
              //                       //       ),
              //                       //     ],
              //                       //   ),
              //                       // ),
              //                       );
              //                 },
              //               ),
              //             );
              //           },
              //         ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
