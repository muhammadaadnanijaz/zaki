// // ignore_for_file: file_names

// import 'dart:io';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_chips_input/flutter_chips_input.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:provider/provider.dart';
// import 'package:zaki/Screens/MoveMoneyFrom.dart';
// import 'package:zaki/Services/api.dart';
// import 'package:zaki/Widgets/CustomSizedBox.dart';
// import '../Constants/AppConstants.dart';
// import '../Constants/Styles.dart';
// import '../Models/ImageModels.dart';
// import '../Widgets/ZakiPrimaryButton.dart';

// class FundsWithFamily extends StatefulWidget {
//   const FundsWithFamily({Key? key}) : super(key: key);

//   @override
//   _FundsWithFamilyState createState() => _FundsWithFamilyState();
// }

// class _FundsWithFamilyState extends State<FundsWithFamily> {
//   var mockResults = const <AppProfile>[
//       AppProfile('John Doe', 'jdoe@flutter.io',
//           'https://d2gg9evh47fn9z.cloudfront.net/800px_COLOURBOX4057996.jpg'),
//       AppProfile('Paul', 'paul@google.com',
//           'https://mbtskoudsalg.com/images/person-stock-image-png.png'),
//       AppProfile('Fred', 'fred@google.com',
//           'https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png'),
//       AppProfile('Brian', 'brian@flutter.io',
//           'https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png'),
//       AppProfile('John', 'john@flutter.io',
//           'https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png'),
//       AppProfile('Thomas', 'thomas@flutter.io',
//           'https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png'),
//       AppProfile('Nelly', 'nelly@flutter.io',
//           'https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png'),
//       AppProfile('Marie', 'marie@flutter.io',
//           'https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png'),
//       AppProfile('Charlie', 'charlie@flutter.io',
//           'https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png'),
//       AppProfile('Diana', 'diana@flutter.io',
//           'https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png'),
//       AppProfile('Ernie', 'ernie@flutter.io',
//           'https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png'),
//       AppProfile('Gina', 'fred@flutter.io',
//           'https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png'),
//     ];
//   final ImagePicker _picker = ImagePicker();
//   XFile? img;
//   XFile? userLogo;
//   int selectedIndex = -1;
//   bool emojiShowing = false;
//   final fromController = TextEditingController();
//   final messageController = TextEditingController();
//   final amountController = TextEditingController();
//   String imageUrl = '1';
//   String selectedKidId = '';

//   List<ImageModel> imageList = [
//     ImageModel(id: 0, imageName: imageBaseAddress + '1.png'),
//     ImageModel(id: 1, imageName: imageBaseAddress + '2.png'),
//     ImageModel(id: 2, imageName: imageBaseAddress + '3.png'),
//     ImageModel(id: 3, imageName: imageBaseAddress + '4.jpg'),
//   ];

// void _onEmojiSelected(Emoji emoji) {
//     messageController
//       ..text += emoji.emoji
//       ..selection = TextSelection.fromPosition(
//           TextPosition(offset: messageController.text.length));
//   }

//   void _onBackspacePressed() {
//     messageController
//       ..text = messageController.text.characters.skipLast(1).toString()
//       ..selection = TextSelection.fromPosition(
//           TextPosition(offset: messageController.text.length));
//   }

// @override
//   void initState() {
//     fromController.text = 'Search';
//     super.initState();
//     getUserKids();

//   }
//   getUserKids() {
//     // Future.delayed(const Duration(milliseconds: 200),() async{
//     //   var appConstants = Provider.of<AppConstants>(context, listen: false);
//     //   ApiServices services = ApiServices();
//     //   List<AppProfile> data  = await services.fetchUserKidsWithSearch(appConstants.userRegisteredId);
//     //   setState(() {
//     //     mockResults = data;
//     //   });
//     //   // showNotification(error: 0, icon: Icons.check, message: data);
//     // });

//   }
//   // @override
//   // void dispose() {
//   //   messageController.dispose();
//   //   // passwordCotroller.dispose();
//   //   super.dispose();
//   // }

//   void clearFields() {
//     messageController.text = '';
//     // passwordCotroller.text = '';
//     setState(() {});
//   }

//   @override
//   Widget build(BuildContext context) {
//     var appConstants = Provider.of<AppConstants>(context, listen: true);
//     var height = MediaQuery.of(context).size.height;
//     var width = MediaQuery.of(context).size.width;
//     return Scaffold(
//       body: Container(
//         width: width,
//         // height:height,
//         color: white,
//         child: SingleChildScrollView(
//           physics: const BouncingScrollPhysics(),
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 ///////
//                 CustomSizedBox(
//                   height: height,
//                 ),
                
//                 Text(
//                   'How Much?',
//                   style: textStyleHeading2WithTheme(context, width * 0.85,
//                       whiteColor: 0),
//                 ),
//                 TextFormField(
//                   autovalidateMode: AutovalidateMode.onUserInteraction,
//                   validator: (String? email) {
//                     if (email!.isEmpty) {
//                       return 'Please Enter Amount';
//                     } else {
//                       return null;
//                     }
//                   },
//                   // style: TextStyle(color: primaryColor),
//                   style: textStyleHeading1WithTheme(context, width * 0.8,
//                         whiteColor: 0),
//                   controller: amountController,
//                   obscureText: false,
//                   keyboardType: TextInputType.number,
//                   maxLines: 1,
//                   decoration: InputDecoration(
//                     hintText: '150.00',
//                     prefixIcon: Padding(
//                       padding: const EdgeInsets.all(8),
//                       child: Text(
//                         "PKR",
//                         style: textStyleHeading2WithTheme(context, width,
//                             whiteColor: 2),
//                       ),
//                     ),
//                     prefixIconConstraints:
//                         const BoxConstraints(minWidth: 0, minHeight: 0),
//                     hintStyle: textStyleHeading1WithTheme(context, width * 0.8,
//                         whiteColor: 0),
//                     // labelText: 'Enter Email',
//                     // labelStyle: textStyleHeading2WithTheme(context,width*0.8, whiteColor: 0),
//                   ),
//                 ),
//                 CustomSizedBox(height: height,),
//                 Text(
//                   'From',
//                   style: textStyleHeading2WithTheme(context, width * 0.85,
//                       whiteColor: 0),
//                 ),
//                 SizedBox(
//                   height: height * 0.01,
//                 ),
//                 TextFormField(
//                   controller: fromController,
//                   // autovalidateMode: AutovalidateMode.onUserInteraction,
//                   // validator: (String? email) {
//                   //   if(email!.isEmpty){
//                   //     return 'Please Enter Email';
//                   //   }
//                   //   else{
//                   //     return null;
//                   //   }
//                   // },
//                   // style: TextStyle(color: primaryColor),
//                   readOnly: true,
//                   onTap: () {
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => const MoveMoneyFrom()));
//                   },
//                   style: textStyleHeading2WithTheme(context, width * 0.8,
//                       whiteColor: 2),
//                   enabled: true,
//                   // controller: emailCotroller,
//                   obscureText: false,
//                   keyboardType: TextInputType.emailAddress,
//                   maxLines: 1, 
//                   decoration: InputDecoration(
//                     suffixIcon: Icon(Icons.keyboard_arrow_down, color: grey),
//                     focusedBorder:  UnderlineInputBorder(
//                       borderSide: BorderSide(color: grey), 
//                     ),
//                     // labelText: 'Enter Email',
//                     // labelStyle: textStyleHeading2WithTheme(context,width*0.8, whiteColor: 0),
//                   ),
//                 ),
//                 CustomSizedBox(
//                   height: height,
//                 ),
               
                
//                 Text(
//                   'To',
//                   style: textStyleHeading2WithTheme(context, width * 0.85,
//                       whiteColor: 0),
//                 ),
//                 SizedBox(
//                   height: height * 0.13,
//                   child: 
//                   StreamBuilder<QuerySnapshot>(
//                   stream: ApiServices()
//                       .fetchUserKids(appConstants.userRegisteredId),
//                   builder: (BuildContext context,
//                       AsyncSnapshot<QuerySnapshot> snapshot) {
                        
//                     if (snapshot.hasError) {
//                       return const Text('Ooops...Something went wrong :(');
//                     }

//                     if (snapshot.connectionState == ConnectionState.waiting) {
//                       return const Text("");
//                     }
//                     if (snapshot.data!.size == 0) {
//                       return const Center(child: Text("Nothing to show"));
//                     }
// //snapshot.data!.docs[index] ['USA_first_name']
//                     return ListView.builder(
//                     itemCount: snapshot.data!.docs.length,
//                     physics: const BouncingScrollPhysics(),
//                     shrinkWrap: true,
//                     scrollDirection: Axis.horizontal,
//                     itemBuilder: (BuildContext context, int index) {
//                       // print(snapshot.data!.docs[index] ['USA_first_name']);
//                       return InkWell(
//                         onTap: () async{
//                           // appConstants.updateAllowanceSchedule(snapshot.data!.docs[index]['USA_allowance_schedule']);
//                           ApiServices services = ApiServices();
//                           // dynamic kidData = 
//                           await services.fetchUserKidWithFuture(snapshot.data!.docs[index].id);
//                           print("This document id: ${snapshot.data!.docs[index].id}");
//                           setState(() {
//                             selectedKidId = snapshot.data!.docs[index].id;
//                           });
//                           // ApiServices().addMoneyToSelectedMainWallet(receivedUserId: selectedKidId, senderId: appConstants.userRegisteredId);
//                           // });

//                         },
//                         child: Padding(
//                           padding: const EdgeInsets.all(2.0),
//                           child: Column(
//                             children: [
//                               Container(
//                                 height: height * 0.08,
//                                 width: height * 0.08,
//                                 decoration: BoxDecoration(
//                                     shape: BoxShape.circle,
//                                     color: transparent,
//                                     border: Border.all(
//                                         width: appConstants.kidSelectedIndex == index ? 2 : 0,
//                                         color: appConstants.kidSelectedIndex == index
//                                             ? black
//                                             : transparent)),
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(2.0),
//                                   child: Container(
//                                     height: height * 0.07,
//                                     width: height * 0.065,
//                                     decoration: BoxDecoration(
//                                       shape: BoxShape.circle,
//                                       color: grey,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               SizedBox(
//                                 width: height * 0.065,
//                                 child: Center(
//                                   child: Text(
//                                     snapshot.data!.docs[index] ['USA_first_name'],
//                                     overflow: TextOverflow.clip,
//                                     maxLines: 1,
//                                     style: textStyleHeading2WithTheme(
//                                         context, width * 0.65,
//                                         whiteColor: 0),
//                                   ),
//                                 ),
//                               )
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   );
//                   },
//                 ),
//     ),
//                  ChipsInput(
//     // initialValue: [
//     //     AppProfile('John Doe', 'jdoe@flutter.io', 'https://d2gg9evh47fn9z.cloudfront.net/800px_COLOURBOX4057996.jpg')
//     // ],
//     decoration: InputDecoration(
//         hintText: 'Search @username or Name',
//         hintStyle: textStyleHeading2WithTheme(context,width*0.8, whiteColor: 2),
//     ),
//     maxChips: 3,
//     allowChipEditing: true,
//     // suggestionsBoxMaxHeight: 100,
//     findSuggestions: (String query) {
//         if (query.isNotEmpty) {
//             var lowercaseQuery = query.toLowerCase();
//             return mockResults.where((profile) {
//                 return profile.name.toLowerCase().contains(query.toLowerCase()) || profile.email.toLowerCase().contains(query.toLowerCase());
//             }).toList(growable: false)
//                 ..sort((a, b) => a.name
//                     .toLowerCase()
//                     .indexOf(lowercaseQuery)
//                     .compareTo(b.name.toLowerCase().indexOf(lowercaseQuery)));
//         } else {
//             return const <AppProfile>[];
//         }
//     },
//     onChanged: (data) {
//         print(data);
//     },
//     chipBuilder: (context, state, AppProfile profile) {
//         return InputChip(
//             key: ObjectKey(profile),
//             label: Text(profile.name),
//             // avatar: CircleAvatar(
//             //     backgroundImage: NetworkImage(profile.imageUrl),
//             // ),
//             onDeleted: () => state.deleteChip(profile),
//             materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
//         );
//     },
//     suggestionBuilder: (context, state,AppProfile profile) {
//         return ListTile(
//             key: ObjectKey(profile),
//             // leading: CircleAvatar(
//             //     backgroundImage: NetworkImage(profile.imageUrl),
//             // ),
//             title: Text(profile.name),
//             subtitle: Text(profile.email),
//             onTap: () => state.selectSuggestion(profile),
//         );
//     },
// ),
//                 CustomSizedBox(height: height+height,),
//                 Text(
//                   'Make it Fun',
//                   style: textStyleHeading2WithTheme(context, width * 0.8,
//                       whiteColor: 0),
//                 ),
//                 Text(
//                   'Select or Upload an image',
//                   style: textStyleHeading2WithTheme(context, width * 0.8,
//                       whiteColor: 2),
//                 ),
//                 SizedBox(
//                   height: height * 0.01,
//                 ),
//                 SizedBox(
//                   height: height * 0.1,
//                   width: width,
//                   child: ListView.builder(
//                       itemCount: imageList.length,
//                       scrollDirection: Axis.horizontal,
//                       shrinkWrap: true,
//                       physics: const BouncingScrollPhysics(),
//                       itemBuilder: (context, index) {
//                         return Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 0),
//                           child: InkWell(
//                             onTap: () {
//                               setState(() {
//                                 imageUrl = imageList[index].imageName!;
//                               });
//                             },
//                             child: Container(
//                               height: height * 0.13,
//                               width: width * 0.25,
//                               color: Colors.grey.withValues(alpha:0.2),
//                               child: imageList[index]
//                                       .imageName!
//                                       .contains('com.zakipay.teencard')
//                                   ? Image.file(
//                                       File(imageList[index].imageName!),
//                                       // height: 150,
//                                       // width: double.infinity,
//                                       // fit: BoxFit.fill,
//                                     )
//                                   : Image.asset(imageList[index].imageName!),
//                             ),
//                           ),
//                         );
//                       }),
//                 ),
//                 SizedBox(
//                   height: height * 0.01,
//                 ),
//                 SizedBox(
//                   width: double.infinity,
//                   height: height * 0.24,
//                   child: Stack(
//                     fit: StackFit.expand,
//                     children: [
//                       imageUrl == '1'
//                           ? Image.asset(
//                               imageBaseAddress + 'image_upload.png',
//                               // height: height*0.2,
//                               // width: width,
//                               fit: BoxFit.fill,
//                             )
//                           : imageUrl.contains('com.zakipay.teencard')
//                               ? Image.file(
//                                   File(imageUrl),
//                                   // height: 150,
//                                   // width: double.infinity,
//                                   // fit: BoxFit.fill,
//                                 )
//                               : Image.asset(imageUrl),
//                       Positioned(
//                           right: 5,
//                           top: 5,
//                           child: IconButton(
//                             icon: const Icon(Icons.camera_alt),
//                             onPressed: () async {
//                               // Pick an image
//                               final XFile? image = await _picker.pickImage(
//                                   maxWidth: 500,
//                                   maxHeight: 600,
//                                   imageQuality: 80,
//                                   source: ImageSource.gallery);
//                               if (image != null) {
//                                 setState(() {
//                                   imageList.add(
//                                       ImageModel(id: 6, imageName: image.path));
//                                 });
//                               }
//                             },
//                           ))
//                     ],
//                   ),
//                 ),
//                 CustomSizedBox(
//                   height: height,
//                 ),
//                 Text(
//                   'Message (optional)',
//                   style: textStyleHeading2WithTheme(context, width * 0.85,
//                       whiteColor: 0),
//                 ),
//                 SizedBox(
//                   height: height * 0.01,
//                 ),
//                 TextFormField(
//                   // autovalidateMode: AutovalidateMode.onUserInteraction,
//                   // validator: (String? email) {
//                   // if(email!.isEmpty){
//                   //   return 'Please Enter Amount';
//                   // }
//                   // else{
//                   //   return null;
//                   // }
//                   // },
//                   // style: TextStyle(color: primaryColor),
//                   style: textStyleHeading2WithTheme(context, width * 0.8,
//                       whiteColor: 0),
//                   controller: messageController,
//                   obscureText: false,
//                   keyboardType: TextInputType.emailAddress,
//                   maxLines: 6,
//                   maxLength: 140,
//                   decoration: InputDecoration(
//                     hintText:
//                         'Add a note, Make it Fun!',
//                     hintStyle: textStyleHeading2WithTheme(context, width * 0.8,
//                         whiteColor: 2),
//                     // labelText: 'Enter Email',
//                     // labelStyle: textStyleHeading2WithTheme(context,width*0.8, whiteColor: 0),
//                   ),
//                 ),
//                 CustomSizedBox(
//                   height: height
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Row(
//                       children: [
//                         IconButton(
//                           icon: Icon(emojiShowing
//                               ? Icons.emoji_emotions
//                               : Icons.emoji_emotions_outlined),
//                               color: green,
//                           onPressed: () {
//                             setState(() {
//                               emojiShowing = !emojiShowing;
//                             });
//                           },
//                         ),
//                         IconButton(
//                           icon: Icon(
//                             FontAwesomeIcons.snapchat,
//                             color: green,

//                             ),
//                           onPressed: () {},
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),

//                 //////////////Emojei Settings
//                 Offstage(
//                   offstage: !emojiShowing,
//                   child: SizedBox(
//                     height: 250,
//                     child: EmojiPicker(
//                         onEmojiSelected: (Category category, Emoji emoji) {
//                           _onEmojiSelected(emoji);
//                         },
//                         onBackspacePressed: _onBackspacePressed,
//                         config: Config(
//                             columns: 7,
//                             // Issue: https://github.com/flutter/flutter/issues/28894
//                             emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0),
//                             verticalSpacing: 0,
//                             horizontalSpacing: 0,
//                             initCategory: Category.RECENT,
//                             bgColor: const Color(0xFFF2F2F2),
//                             indicatorColor: Colors.blue,
//                             iconColor: Colors.grey,
//                             iconColorSelected: Colors.blue,
//                             progressIndicatorColor: Colors.blue,
//                             backspaceColor: Colors.blue,
//                             skinToneDialogBgColor: Colors.white,
//                             skinToneIndicatorColor: Colors.grey,
//                             enableSkinTones: true,
//                             showRecentsTab: true,
//                             recentsLimit: 28,
//                             noRecentsText: 'No Recents',
//                             noRecentsStyle: const TextStyle(
//                                 fontSize: 20, color: Colors.black26),
//                             tabIndicatorAnimDuration: kTabScrollDuration,
//                             categoryIcons: const CategoryIcons(),
//                             buttonMode: ButtonMode.MATERIAL)),
//                   ),
//                 ),
//                 /////////
//                 Text(
//                   'Allocation',
//                   style: textStyleHeading2WithTheme(context, width * 0.85,
//                       whiteColor: 0),
//                 ),
//                 SizedBox(
//                   height: height * 0.01,
//                 ),
//                 SizedBox(
//                   height: height * 0.1,
//                   child: ListView.builder(
//                     itemCount: 8,
//                     physics: const BouncingScrollPhysics(),
//                     shrinkWrap: true,
//                     scrollDirection: Axis.horizontal,
//                     itemBuilder: (BuildContext context, int index) {
//                       return
//                           // index==4? IconButton(onPressed: (){}, icon: Icon(Icons.arrow_drop_down, size: width*0.1,)) :
//                           Padding(
//                         padding: const EdgeInsets.all(2.0),
//                         child: Container(
//                           height: height * 0.08,
//                           width: height * 0.08,
//                           decoration: BoxDecoration(
//                               shape: BoxShape.circle, color: grey),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//                 SizedBox(
//                   height: height * 0.01,
//                 ),
//                 SizedBox(
//                   height: height * 0.01,
//                 ),
//                 // Expanded(
//                 //     child: Padding(
//                 //   padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 0),
//                 //   child: ZakiPrimaryButton(
//                 //     onPressed: () {},
//                 //     title: 'Request',
//                 //     width: width,
//                 //   ),
//                 // )),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 0),
//                   child: ZakiPrimaryButton(
//                 onPressed: () async{
//                   // ApiServices services = ApiServices();
//                   // await services.addMoveMoney(message: messageController.text, accountHolderName: '${appConstants.userModel.usaFirstName}+${appConstants.userModel.usaLastName}', accountType: 'Spending', tagItId : 'YVU6OqjMRC929jBFGCLN', tagItName: 'Study', amount: amountController.text, imageUrl: imageUrl, parentId: appConstants.userModel.userFamilyId, senderId: '1234', userId: selectedKidId, senderUserId: appConstants.userRegisteredId,);
//                   // Navigator.push(
//                   //     context,
//                   //     MaterialPageRoute(
//                   //         builder: (context) =>
//                   //             const FriendsActivities()));
//                 },
//                 title: 'Move',
//                 width: width,
//                   ),
//                 ),
//                 // SizedBox(height: height*0.15,),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class AppProfile {
//   final String name;
//   final String email;
//   final String imageUrl;

//   const AppProfile(this.name, this.email, this.imageUrl);

//   @override
//   bool operator ==(Object other) =>
//       identical(this, other) ||
//       other is AppProfile &&
//           runtimeType == other.runtimeType &&
//           name == other.name;

//   @override
//   int get hashCode => name.hashCode;

//   @override
//   String toString() {
//     return name;
//   }
// }
