import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zaki/Constants/Spacing.dart';
import 'package:zaki/Widgets/ToDoCustomTileCompleted.dart';
import 'package:zaki/Widgets/CustomLoader.dart';
import '../Constants/AppConstants.dart';
import '../Services/api.dart';
import '../Widgets/AppBars/AppBar.dart';

class ToDoCompleted extends StatefulWidget {
  const ToDoCompleted({Key? key}) : super(key: key);

  @override
  State<ToDoCompleted> createState() => _ToDoCompletedState();
}

class _ToDoCompletedState extends State<ToDoCompleted> {
  Stream<QuerySnapshot>? selectedUserToDo;
  String selectedUserId = '';
  @override
  void initState() {
    super.initState();
    getUserData();
  }

  getUserData() {
    Future.delayed(const Duration(milliseconds: 200), () {
      ApiServices service = ApiServices();
      setState(() {
        var appConstants = Provider.of<AppConstants>(context, listen: false);
        selectedUserId = appConstants.userRegisteredId;
        // selectedUserParentId = '';
        // userKids = service.fetchUserKids(appConstants.userRegisteredId);
        // selectedUserToDo = service.getToDos(
        //     id: appConstants.userRegisteredId,
        //     condition: "Completed",
        //     limit: 1);
        selectedUserToDo =
            service.getCompltedToDos(id: appConstants.userRegisteredId);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var appConstants = Provider.of<AppConstants>(context, listen: true);
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
                appBarTitle: 'Completed To Do\'s',
                backArrow: false,
                height: height,
                width: width,
                leadingIcon: true,
              ),
              // CustomSizedBox(
              //   height: height,
              // ),
              Expanded(
                child: selectedUserToDo == null
                    ? const SizedBox()
                    : StreamBuilder<QuerySnapshot>(
                        stream: selectedUserToDo,
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> dataSnapshot) {
                          if (dataSnapshot.hasError) {
                            return const Text(
                                'Ooops...Something went wrong :(');
                          }

                          if (dataSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: const CustomLoader());
                          }
                          if (dataSnapshot.data!.size == 0) {}
                          //snapshot.data!.docs[index] ['USA_first_name']
                          return ListView.builder(
                            itemCount: dataSnapshot.data!.docs.length,
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            // scrollDirection: Axis.horizontal,
                            itemBuilder: (BuildContext context, int index) {
                              // print(snapshot.data!.docs[index] ['USA_first_name']);
                              return StreamBuilder<DocumentSnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection(AppConstants.TO_DO)
                                    .doc(appConstants.userRegisteredId)
                                    .collection(AppConstants.TO_DO)
                                    .doc(dataSnapshot.data!.docs[index]
                                        [AppConstants.TO_DO_Id])
                                    .snapshots(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                                  // if (snapshot.connectionState ==
                                  //     ConnectionState.waiting) {
                                  //   return Center(
                                  //       child: const CustomLoader());
                                  // }
                                  // if (snapshot.data!.data().toString().length == 0) {}
                                  // var snap = snapshot.data!.data() as Map<String, dyna>
                                  //snapshot.data!.docs[index] ['USA_first_name']
                                  return (snapshot.data == null ||
                                          snapshot.data!.data() == null)
                                      ? SizedBox.shrink()
                                      :
                                      // Text('${snapshot.data!.data()[AppConstants.DO_Title]}');
                                      Column(
                                          children: [
                                            ToDoCustomTileCompleted(
                                              snapshot.data!,
                                              selectedUserId,
                                              completedDateTime: dataSnapshot
                                                  .data!
                                                  .docs[index][AppConstants
                                                      .To_DO_Completed_At]
                                                  .toDate(),
                                              completedToDoId: dataSnapshot
                                                  .data!.docs[index].id,
                                            ),
                                            Container(
                                              height: 0.35,
                                              width: width,
                                              color:
                                                  Colors.grey.withOpacity(0.5),
                                            ),
                                            // Divider(
                                            //   color: Colors.grey.withOpacity(0.5),
                                            //   endIndent: 0,
                                            //   )
                                          ],
                                        );
                                },
                              );
                              // Text('${snapshot.data!.docs[index][AppConstants.DO_Title]}')
                              // ToDoCustomTileCompleted(
                              //     snapshot.data!.docs[index],
                              //     selectedUserId);
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
