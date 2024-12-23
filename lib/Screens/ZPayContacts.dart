import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zaki/Widgets/TextHeader.dart';
import 'package:zaki/Widgets/CustomLoader.dart';
import '../Constants/AppConstants.dart';
import '../Constants/Styles.dart';

class ZPayContacts extends StatefulWidget {
  const ZPayContacts({Key? key}) : super(key: key);

  @override
  _ZPayContactsState createState() => _ZPayContactsState();
}

class _ZPayContactsState extends State<ZPayContacts> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 200), () {
      var appConstants = Provider.of<AppConstants>(context, listen: false);
      appConstants.getContact();
    });
  }

  @override
  Widget build(BuildContext context) {
    var appConstants = Provider.of<AppConstants>(context, listen: true);
    var height = MediaQuery.of(context).size.height;
    // var width = MediaQuery.of(context).size.width;

    return Scaffold(
        body: SafeArea(
      child: Column(
        children: [
          SizedBox(
            height: height * 0.02,
          ),
          Row(
            children: [
              Checkbox(
                  value: appConstants.inviteAll,
                  autofocus: true,
                  onChanged: (b) {
                    appConstants.updateInviteAll(b!);
                    appConstants.inviteAllContacts();
                  }),
              TextValue2(
                title: 'Select All',
              ),
            ],
          ),
          Expanded(
              child: (appConstants.contacts) == null
                  ? const Center(child: CustomLoader())
                  : ListView.builder(
                      itemCount: appConstants.contacts!.length,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        Uint8List? image = appConstants.contacts![index].photo;
                        String num =
                            (appConstants.contacts![index].phones.isNotEmpty)
                                ? (appConstants
                                    .contacts![index].phones.first.number)
                                : "--";
                        return ListTile(
                            leading: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Checkbox(
                                    value:
                                        appConstants.contacts![index].isStarred,
                                    onChanged: (b) {
                                      setState(() {
                                        appConstants
                                            .contacts![index].isStarred = b!;
                                      });
                                    }),
                                (appConstants.contacts![index].photo == null)
                                    ? const CircleAvatar(
                                        child: Icon(Icons.person))
                                    : CircleAvatar(
                                        backgroundImage: MemoryImage(image!)),
                              ],
                            ),
                            title: TextValue2(
                              title:
                                  "${appConstants.contacts![index].name.first} ${appConstants.contacts![index].name.last}",
                            ),
                            subtitle: TextValue3(
                              title: num,
                            ),
                            onTap: () {
                              // if (contacts![index].phones.isNotEmpty) {
                              //   launch('tel: ${num}');
                              // }
                            },
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                InkWell(
                                  onTap: () {
                                    print(
                                        'Whatsapp is tabbed::${(appConstants.contacts![index].phones.first.number)}');
                                    if (appConstants
                                        .contacts![index].phones.isNotEmpty) {}
                                  },
                                  child: Icon(
                                    Icons.person_add_alt_1_outlined,
                                    color: black,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: InkWell(
                                    onTap: () {
                                      print('Email is tabbed');
                                    },
                                    child: Icon(
                                      Icons.favorite_border,
                                      color: black,
                                    ),
                                  ),
                                ),
                              ],
                            ));
                      },
                    ))
        ],
      ),
    ));
  }
}
