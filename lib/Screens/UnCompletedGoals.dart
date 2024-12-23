import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_pagination/firebase_pagination.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
// import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:zaki/Constants/Spacing.dart';
// import 'package:zaki/Models/GaolModelWithQuery.dart';
import 'package:zaki/Widgets/CustomLoader.dart';
import 'package:zaki/Widgets/GoalUnCompletedCustomTile.dart';

import '../Constants/AppConstants.dart';
import 'package:flutter/material.dart';
import '../Constants/Styles.dart';
import '../Models/GoalModel.dart';
import '../Services/api.dart';
import '../Widgets/ZakiPrimaryButton.dart';
import 'NewGoal.dart';

class UnCompletedGoals extends StatefulWidget {
  const UnCompletedGoals({
    Key? key,
    // required this.bottomSheetController,
  }) : super(key: key);
  // final PanelController bottomSheetController;

  @override
  State<UnCompletedGoals> createState() => _UnCompletedGoalsState();
}

class _UnCompletedGoalsState extends State<UnCompletedGoals> {
  // Stream<QuerySnapshot>? unCompletedGoals;
  Query? unCompletedGoalsQuery;
  @override
  void initState() {
    super.initState();
    getUncompletedGoals();
  }

  getUncompletedGoals() {
    Future.delayed(const Duration(milliseconds: 200), () {
      var appConstants = Provider.of<AppConstants>(context, listen: false);
      setState(() {
        unCompletedGoalsQuery = ApiServices().getUncompletedGoalsWithQuery(appConstants.userRegisteredId,);
        // unCompletedGoals =
        //     ApiServices().getUncompletedGoals(appConstants.userRegisteredId,);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var appConstants = Provider.of<AppConstants>(context, listen: true);
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return 
    // unCompletedGoals == null
    //     ? SizedBox.shrink()
    //     : 
        Padding(
          padding: getCustomPadding(),
          child: Column(
            children: [
              if(unCompletedGoalsQuery!=null)
              Expanded(
              child: FirestorePagination(
                                // query: allTransactions,
                                // query: FirebaseFirestore.instance.collection('${AppConstants.USER}/${appConstants.userRegisteredId}/${AppConstants.Transaction}').orderBy(AppConstants.created_at, descending: true),
                                query: unCompletedGoalsQuery!,
                                // query: FirebaseFirestore.instance.collection(AppConstants.USER).doc(userId).collection(AppConstants.Transaction),
                                  // query: FirebaseFirestore.instance.collection(AppConstants.USER).orderBy(AppConstants.USER_created_at),
                                  isLive: true,
                                  physics: AlwaysScrollableScrollPhysics(),
                                  scrollDirection: Axis.vertical,
                                  limit: 10,
                                  shrinkWrap: true,
                                  initialLoader: CustomLoader(),
                                  onEmpty: 
                                   SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: height * 0.05,
                            ),
                            spacing_large,
                            ZakiPrimaryButton(
                                title: 'Create a New Goal',
                                width: width,
                                icon: FontAwesomeIcons.bullseye,
                                backGroundColor: blue,
                                onPressed: () {
                                  appConstants.updateGoalModel(GoalModel());
                                  appConstants.updateDateOfBirth('dd / mm / yyyy');
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => const NewGoal()));
                                }),
                          ],
                        ),
                      ),
                                  bottomLoader: Center(child: CircularProgressIndicator()),
                                  itemBuilder: (context, documentSnapshot, index) {
                                    // final data = documentSnapshot.data() as Map<String, dynamic>;
                                    // final item = GoalModelWithQuery.fromFirestore(data);
                                    final documentSnapshotss = documentSnapshot[index];
  if (documentSnapshotss is QueryDocumentSnapshot) {
    final queryDocumentSnaps = documentSnapshotss;
    return GoalCustomTile(snapshot: queryDocumentSnaps);
  } else {
    return const SizedBox.shrink(); // or handle the case appropriately
  }
                                    // Padding(
                                    //   padding: const EdgeInsets.all(24.0),
                                    //   child: Text(item.goalName.toString()),
                                    // );
                                },
                              ),),
                              
              // StreamBuilder(
              //     stream: unCompletedGoals,
              //     // stream: FirebaseFirestore.instance.collection(AppConstants.GOAL).where(AppConstants.GOAL_user_id, isEqualTo: appConstants.userRegisteredId).where(AppConstants.GOAL_Status, isEqualTo: false).orderBy(AppConstants.GOAL_created_at, descending: false).snapshots(),
              //     // initialData: initialData,
              //     builder: (BuildContext context, AsyncSnapshot snapshot) {
              //       if (snapshot.hasError) {
              //         return const Text('Ooops...Something went wrong :(');
              //       }
              
              //       if (snapshot.connectionState == ConnectionState.waiting) {
              //         return const Text("");
              //       }
              //       if (snapshot.data!.size == 0) {
              //         return SingleChildScrollView(
              //           child: Column(
              //             crossAxisAlignment: CrossAxisAlignment.center,
              //             children: [
              //               SizedBox(
              //                 height: height * 0.05,
              //               ),
              //               spacing_large,
              //               ZakiPrimaryButton(
              //                   title: 'Create a New Goal',
              //                   width: width,
              //                   icon: FontAwesomeIcons.bullseye,
              //                   backGroundColor: blue,
              //                   onPressed: () {
              //                     appConstants.updateGoalModel(GoalModel());
              //                     appConstants.updateDateOfBirth('dd / mm / yyyy');
              //                     Navigator.push(
              //                         context,
              //                         MaterialPageRoute(
              //                             builder: (context) => const NewGoal()));
              //                   }),
              //             ],
              //           ),
              //         );
              //       }
              //       return ListView.builder(
              //         itemCount: snapshot.data!.docs.length,
              //         physics: const BouncingScrollPhysics(),
              //         shrinkWrap: true,
              //         itemBuilder: (BuildContext context, int index) {
              //           return InkWell(
              //             onTap: () {},
              //             child: Padding(
              //               padding: const EdgeInsets.symmetric(vertical: 5.0),
              //               child: GoalCustomTile(snapshot: snapshot.data!.docs[index]),
              //             ),
              //           );
              //         },
              //       );
              //     },
              //   ),
            ],
          ),
        );
  }
}
