// ignore_for_file: file_names

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:zaki/Constants/AppConstants.dart';
import 'package:zaki/Constants/HelperFunctions.dart';
import 'package:zaki/Constants/Spacing.dart';
import 'package:zaki/Widgets/TextHeader.dart';
import 'package:zaki/Widgets/ZakiPrimaryButton.dart';
import '../Constants/Styles.dart';
import '../Widgets/ContactListTileWidget.dart';
import 'package:zaki/Widgets/CustomLoader.dart';

class GetContacts extends StatefulWidget {
  const GetContacts({Key? key}) : super(key: key);

  @override
  _GetContactsState createState() => _GetContactsState();
}

class _GetContactsState extends State<GetContacts> {
  final searchNameController = TextEditingController();
  bool? requestDenied = true;
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 200), () {
      getIntialSetup();
    });
    // _fetchContacts();
    // Future.delayed(const Duration(milliseconds: 200), () {
    //   var appConstants = Provider.of<AppConstants>(context, listen: false);
    //   await Permission.contacts.request();
    //   var statuss = await Permission.contacts.status;
    //   logMethod(
    //               title: 'Permission Contacts==>>>', message: statuss.name);
    //           if (statuss.name == 'denied') {
    //             logMethod(
    //                 title: 'Permission internal Contacts==>>>',
    //                 message: statuss.name);
    //                await openAppSettings();
    //             // We didn't ask for permission yet or the permission has been denied before but not permanently.
    //           }
    //   else
    //   appConstants.getContact();
    // // });
  }

  getIntialSetup() async {
    // _fetchContacts();
    // Future.delayed(const Duration(milliseconds: 200), () {
    var appConstants = Provider.of<AppConstants>(context, listen: false);
    await Permission.contacts.request();
    // var statuss =
    await Permission.contacts.status;

    if (await Permission.contacts.isDenied) {
      setState(() {
        requestDenied = false;
      });
      // The user opted to never again see the permission request dialog for this
      // app. The only way to change the permission's status now is to let the
      // user manually enable it in the system settings.
      // Future.delayed(Duration(seconds: 3), (){
      //   logMethod(title: 'Permission Contacts==>>>', message: 'Denied: ${statuss.isDenied.toString()}, Granted: ${statuss.isGranted.toString()}, IsLimited: ${statuss.isLimited.toString()}, Is Permanently Denined: ${statuss.isPermanentlyDenied.toString()}, Is Restricted: ${statuss.isRestricted.toString()}, Name: ${statuss.name.toString()}');
      // openAppSettings();
      // });
    }
    // logMethod(
    //             title: 'Permission Contacts==>>>', message: statuss.name);
    // if (statuss.isPermanentlyDenied) {
    //   logMethod(
    //       title: 'Permission internal Contacts==>>>',
    //       message: statuss.name);
    //       // bool stat = await openAppSettings();
    //       await Permission.contacts.request();
    //       Future.delayed(Duration(seconds: 9), ()async{
    //         // if(stat){
    //       //   logMethod(
    //       // title: 'Permission Status==>>>',
    //       // message: stat.toString());
    //         await appConstants.getContact();
    //       // }
    //       });

    //   // We didn't ask for permission yet or the permission has been denied before but not permanently.
    // }
    else
      appConstants.getContact();
    // });
  }

  // List<Contact>? _contacts;
  // ignore: unused_field
  bool _permissionDenied = false;

  // Future _fetchContacts() async {
  //   // logMethod(title: 'Permission Outside', message:'${Permission.contacts.status} Successfully granted');
  //   // await Permission.contacts.request();
  //   // if(await Permission.contacts.isGranted==true){
  //   //   logMethod(title: 'Permission inside', message:'${await Permission.contacts.status.isGranted} Successfully granted');
  //   // List<Contact> contacts = await ContactsService.getContacts();
  //   //   setState(() {
  //   //     appConstants.contacts = contacts;
  //   //   });
  //   //   for (var item in contacts) {

  //   //     logMethod(title: 'Number is ', message: item.displayName);
  //   //   }
  //   // }
  //   if (!await FlutterContacts.requestPermission(readonly: true)) {
  //     setState(() => _permissionDenied = true);
  //   } else {
  //     final contacts = await FlutterContacts.getContacts(
  //       withProperties: true,
  //       withPhoto: true,
  //       withThumbnail: true,
  //       deduplicateProperties: false
  //     );
  //     setState(() {
  //       _contacts = contacts;
  //     });
  //     // for (var item in contacts) {
  //     //   logMethod(title: 'Number is:', message: item.phones.first.number);
  //     // }
  //     // var data;
  //     // ApiServices services = ApiServices();
  //     // for (var contact in contacts) {
  //     //   data = await services.isUserExist(number: contact.phones.first.number);
  //     //                     if (data!=null) {
  //     //                       showNotification(error: 0, icon: Icons.check, message: 'Not');
  //     //                     } else {
  //     //                     //   isRegistered = true;
  //     //                     // showNotification(error: 0, icon: Icons.check, message: 'yes');
  //     //                     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    var appConstants = Provider.of<AppConstants>(context, listen: true);
    // var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: requestDenied == false
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: SizedBox(
                        height: width * 0.1,
                        child: ZakiPrimaryButton(
                          title: 'Allow Permissions',
                          width: width,
                          onPressed: () async {
                            var stat = await openAppSettings();
                            Future.delayed(Duration(seconds: 12), () async {
                              if (stat) {
                                logMethod(
                                    title: 'Permission Status==>>>',
                                    message: stat.toString());
                                await appConstants.getContact();
                                //  var statuss =
                                await Permission.contacts.status;

                                if (await Permission.contacts.isGranted) {
                                  setState(() {
                                    requestDenied = true;
                                  });
                                }
                              }
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                )
              : Column(
                  children: [
                    Container(
                      width: width,
                      decoration: BoxDecoration(
                        border: Border.all(color: borderColor),
                        borderRadius: BorderRadius.circular(width*0.03)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          
                          children: [
                            Center(
                              child: Image.asset(
                              imageBaseAddress + 'invite_screen.png',
                              // 
                              // width: MediaQuery.of(context).size.width,
                              // color: green,
                              // fit: BoxFit.cover,
                              ),
                            ),
                            spacing_medium,
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextValue2(title: '•  Invite Friends & Family for FREE!',),
                                spacing_small,
                                FittedBox(child: TextValue2(title: '•  Send or Request Money from Friends & Family',)),
                                spacing_medium,
                              ],

                            )
                          ],
                        ),
                      ),
                    ),

                    TextFormField(
                      controller: searchNameController,
                      onChanged: (value) {
                        setState(() {
                          appConstants.contacts = appConstants.filteredContacts!
                              .where((element) => element.displayName
                                      .toLowerCase()
                                      .contains(value.toLowerCase())
                                  // || element.usaLastName!.toLowerCase().contains(value.toLowerCase())
                                  // || element.usaUserName!.toLowerCase().contains(value.toLowerCase() )
                                  )
                              .toList();
                        });
                      },
                      // maxLength: 1,
                      decoration: InputDecoration(
                        hintText: 'Search',
                        hintStyle: heading2TextStyle(context, width),
                        prefixIcon: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Icon(Icons.search)),
                        prefixIconConstraints:
                            const BoxConstraints(minWidth: 0, minHeight: 0),
                      ),
                    ),
                    Expanded(
                      child: (appConstants.contacts) == null
                          ? const Center(child: CustomLoader())
                          : ListView.builder(
                              itemCount: appConstants.contacts!.length,
                              physics: const BouncingScrollPhysics(),
                              // shrinkWrap: true,
                              itemBuilder: (BuildContext context, int index) {
                                var data;
                                // WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async{
                                //   ApiServices services = ApiServices();
                                //     data = await services.isUserExist(number: appConstants.contacts![index].phones.first.number);
                                //     if (data!=null) {
                                //       showNotification(error: 0, icon: Icons.check, message: 'Not');
                                //     } else {
                                //     //   isRegistered = true;
                                //     // showNotification(error: 0, icon: Icons.check, message: 'yes');
                                //     }
                                // });

                                Uint8List? image =
                                    appConstants.contacts![index].photo;
                                // String num = (appConstants.contacts![index].phones.isNotEmpty)
                                //     ? (appConstants.contacts![index].phones.first.number)
                                //     : "--";
                                return
                                    //           ListTile(
                                    // title: Text(appConstants.contacts![index].displayName),
                                    // onTap: () async {
                                    //   final fullContact =
                                    //       await FlutterContacts.getContact(appConstants.contacts![index].id);
                                    //   // await Navigator.of(context).push(
                                    //   //     MaterialPageRoute(builder: (_) => ContactPage(fullContact!)));
                                    // })
                                    ContactListTileWidget(
                                  contacts: appConstants.contacts![index],
                                  image: image,
                                  width: width,
                                  data: data,
                                  userModel: appConstants.userModel,
                                );
                              },
                            ),
                    ),

                    // spacing_medium,
                    // ZakiPrimaryButton(
                    //     title: 'Invite All',
                    //     width: width,
                    //     onPressed: () {
                    //       for (var contact in appConstants.contacts!) {
                    //         if (contact.emails.isNotEmpty) {
                    //           logMethod(
                    //               title: "email address is",
                    //               message: contact.emails.first.address);
                    //         }
                    //       }
                    //       Navigator.push(
                    //           context,
                    //           MaterialPageRoute(
                    //               builder: (context) => const GetStarted()));
                    //     })
                    // ,spacing_medium
                  ],
                ),
        ));
  }
}
