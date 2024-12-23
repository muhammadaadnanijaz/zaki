// import 'dart:io';

// import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:provider/provider.dart';
// import 'package:sliding_up_panel/sliding_up_panel.dart';
// import 'package:zaki/Screens/LearningCenter.dart';
// import 'package:zaki/Widgets/ZakiPrimaryButton.dart';

// import '../Constants/AppConstants.dart';
// import '../Constants/Styles.dart';

// class UploadVideo extends StatefulWidget {
//   const UploadVideo({Key? key}) : super(key: key);

//   @override
//   _UploadVideoState createState() => _UploadVideoState();
// }

// class _UploadVideoState extends State<UploadVideo> {
//   final ImagePicker _picker = ImagePicker();
//   final bottomSheetController = PanelController();
//   XFile? newVideo;
//   // late File _video;
//   bool emojiShowing = false;
//   bool emojiCaptionShowing = false;
//   final titleController = TextEditingController();
//   final captionController = TextEditingController();

//   void _onEmojiSelected(Emoji emoji) {
//     titleController
//       ..text += emoji.emoji
//       ..selection = TextSelection.fromPosition(
//           TextPosition(offset: titleController.text.length));
//   }

//   void _onBackspacePressed() {
//     titleController
//       ..text = titleController.text.characters.skipLast(1).toString()
//       ..selection = TextSelection.fromPosition(
//           TextPosition(offset: titleController.text.length));
//   }

//   void _onEmojiSelectedCaption(Emoji emoji) {
//     captionController
//       ..text += emoji.emoji
//       ..selection = TextSelection.fromPosition(
//           TextPosition(offset: titleController.text.length));
//   }

//   void _onBackspacePressedCaption() {
//     captionController
//       ..text = captionController.text.characters.skipLast(1).toString()
//       ..selection = TextSelection.fromPosition(
//           TextPosition(offset: titleController.text.length));
//   }

//   @override
//   void dispose() {
//     titleController.dispose();
//     captionController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     var appConstants = Provider.of<AppConstants>(context, listen: true);
//     var height = MediaQuery.of(context).size.height;
//     var width = MediaQuery.of(context).size.width;
//     return Scaffold(
//       // backgroundColor: grey.withOpacity(0.98),
//       appBar: AppBar(
//         leading: IconButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           icon: Icon(
//             Icons.clear,
//             color: black,
//           ),
//         ),
//         backgroundColor: transparent,
//         centerTitle: true,
//         elevation: 0,
//         title: Text(
//           'Upload 🎥 video',
//           style:
//               textStyleHeading1WithTheme(context, width * 0.85, whiteColor: 0),
//         ),
//       ),
//       body: SlidingUpPanel(
//         controller: bottomSheetController,
//         maxHeight: height * 0.55,
//         minHeight: height * 0,
//         backdropEnabled: true,
//         borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(width * 0.09),
//             topRight: Radius.circular(width * 0.09)),
//         panel: SingleChildScrollView(
//           child: Column(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
//                 child: InkWell(
//                   onTap: () {
//                     if (bottomSheetController.isPanelOpen) {
//                       bottomSheetController.close();
//                     }
//                   },
//                   child: Container(
//                     width: width * 0.2,
//                     height: 5,
//                     decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(width * 0.08),
//                         color: grey),
//                   ),
//                 ),
//               ),
//               Text(
//                 'Upload 🎥 video',
//                 style:
//                     textStyleHeading2WithTheme(context, width, whiteColor: 0),
//               ),
//               SizedBox(
//                 height: height * 0.01,
//               ),
//               SizedBox(
//                 height: height * 0.01,
//               ),
//               Padding(
//                 padding: EdgeInsets.symmetric(
//                     horizontal: width * 0.08, vertical: width * 0.01),
//                 child: VideoTypeButton(
//                   width: width,
//                   icon: Icons.camera_alt,
//                   selected: appConstants.selectedPrivacyType == 1 ? 1 : 0,
//                   title: 'From Camera',
//                   onTap: () async {
//                     appConstants.updateSlectedPrivacyTypeIndex(1);
//                     bottomSheetController.close();
//                     final XFile? video =
//                         await _picker.pickVideo(source: ImageSource.camera);
//                     if (video != null) {
//                       setState(() {
//                         newVideo = video;
//                         print('picked video: ${newVideo!.path}');
//                       });
//                     }
//                   },
//                 ),
//               ),
//               Padding(
//                 padding: EdgeInsets.symmetric(
//                     horizontal: width * 0.08, vertical: width * 0.01),
//                 child: VideoTypeButton(
//                   width: width,
//                   title: 'From Gallery',
//                   icon: Icons.browse_gallery,
//                   selected: appConstants.selectedPrivacyType == 2 ? 1 : 0,
//                   onTap: () async {
//                     appConstants.updateSlectedPrivacyTypeIndex(2);
//                     bottomSheetController.close();
//                     // Pick video from gallery
//                     final XFile? video =
//                         await _picker.pickVideo(source: ImageSource.gallery);
//                     if (video != null) {
//                       setState(() {
//                         newVideo = video;
//                         print('picked video: ${newVideo!.path}');
//                       });
//                     }
//                   },
//                 ),
//               ),
//               Padding(
//                 padding: EdgeInsets.symmetric(
//                     horizontal: width * 0.08, vertical: width * 0.01),
//                 child: VideoTypeButton(
//                   width: width,
//                   title: 'From Drive',
//                   icon: Icons.cloud_download_rounded,
//                   selected: appConstants.selectedPrivacyType == 3 ? 1 : 0,
//                   onTap: () {
//                     appConstants.updateSlectedPrivacyTypeIndex(3);
//                     bottomSheetController.close();
//                   },
//                 ),
//               ),
//               Padding(
//                 padding: EdgeInsets.symmetric(
//                     horizontal: width * 0.08, vertical: width * 0.01),
//                 child: VideoTypeButton(
//                   width: width,
//                   title: 'From Link',
//                   icon: FontAwesomeIcons.link,
//                   selected: appConstants.selectedPrivacyType == 4 ? 1 : 0,
//                   onTap: () {
//                     appConstants.updateSlectedPrivacyTypeIndex(4);
//                     bottomSheetController.close();
//                     linkEnterBottomSheet(context, width, height);
//                   },
//                 ),
//               )
//             ],
//           ),
//         ),
//         body: SingleChildScrollView(
//           // physics: const BouncingScrollPhysics(),
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 TextButton(
//                   child: Center(
//                     child: Text(
//                       'Upload',
//                       style: textStyleHeading2WithTheme(context, width * 0.85,
//                           whiteColor: 0),
//                     ),
//                   ),
//                   style: ButtonStyle(
//                     shape: MaterialStateProperty.all(RoundedRectangleBorder(
//                         // borderRadius: BorderRadius.circular(30.0),
//                         side: BorderSide(color: black))),
//                   ),
//                   onPressed: () async {
//                     bottomSheetController.open();
//                   },
//                 ),
//                 SizedBox(
//                   height: height * 0.01,
//                 ),
//                 newVideo == null
//                     ? const Text('No Video is selected')
//                     : const Text('Selected'),
//                 SizedBox(
//                   height: height * 0.01,
//                 ),
//                 TextFormField(
//                   autovalidateMode: AutovalidateMode.onUserInteraction,
//                   validator: (String? name) {
//                     if (name!.isEmpty) {
//                       return 'Please Enter Title';
//                     } else {
//                       return null;
//                     }
//                   },
//                   // style: TextStyle(color: primaryColor),
//                   style: textStyleHeading2WithTheme(context, width * 0.8,
//                       whiteColor: 0),
//                   controller: titleController,
//                   obscureText: false,
//                   keyboardType: TextInputType.name,
//                   maxLines: 1,
//                   maxLength: 60,
//                   decoration: InputDecoration(
//                     hintText: 'Title',
//                     hintStyle: textStyleHeading2WithTheme(context, width * 0.8,
//                         whiteColor: 2),
//                     labelText: 'Title',
//                     labelStyle: textStyleHeading2WithTheme(context, width * 0.8,
//                         whiteColor: 2),
//                   ),
//                 ),
//                 InkWell(
//                     onTap: () {
//                       setState(() {
//                         emojiShowing = !emojiShowing;
//                       });
//                     },
//                     child: Icon(emojiShowing
//                         ? Icons.emoji_emotions
//                         : Icons.emoji_emotions_outlined)),
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
//                 SizedBox(
//                   height: height * 0.01,
//                 ),

//                 TextFormField(
//                   autovalidateMode: AutovalidateMode.onUserInteraction,
//                   // validator: (String? name) {
//                   //   if(name!.isEmpty){
//                   //     return 'Please Enter Title';
//                   //   }
//                   //   else{
//                   //     return null;
//                   //   }
//                   // },
//                   // style: TextStyle(color: primaryColor),
//                   style: textStyleHeading2WithTheme(context, width * 0.8,
//                       whiteColor: 0),
//                   controller: captionController,
//                   obscureText: false,
//                   keyboardType: TextInputType.name,
//                   maxLines: 4,
//                   maxLength: 140,
//                   decoration: InputDecoration(
//                     hintText: 'example: @friendsname',
//                     hintStyle: textStyleHeading2WithTheme(context, width * 0.8,
//                         whiteColor: 2),
//                     labelText: 'Caption (Optional)',
//                     labelStyle: textStyleHeading2WithTheme(context, width * 0.8,
//                         whiteColor: 2),
//                   ),
//                 ),
//                 Row(
//                   children: [
//                     InkWell(
//                         onTap: () {
//                           setState(() {
//                             emojiCaptionShowing = !emojiCaptionShowing;
//                           });
//                         },
//                         child: Icon(emojiCaptionShowing
//                             ? Icons.emoji_emotions
//                             : Icons.emoji_emotions_outlined)),
//                     const Icon(Icons.contact_page_outlined),
//                     const Icon(FontAwesomeIcons.snapchat)
//                   ],
//                 ),
//                 //////////////Emojei Settings
//                 Offstage(
//                   offstage: !emojiCaptionShowing,
//                   child: SizedBox(
//                     height: 250,
//                     child: EmojiPicker(
//                         onEmojiSelected: (Category category, Emoji emoji) {
//                           _onEmojiSelectedCaption(emoji);
//                         },
//                         onBackspacePressed: _onBackspacePressedCaption,
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
//                 SizedBox(
//                   height: height * 0.25,
//                 ),
//                 Center(
//                   child: Text(
//                     'Note: Videos will be visible within 6 hours',
//                     style: textStyleHeading2WithTheme(context, width * 0.65,
//                         whiteColor: 0),
//                   ),
//                 ),
//                 ZakiPrimaryButton(
//                     title: 'Publish',
//                     width: width,
//                     onPressed: () {
//                       // Navigator.push(
//                       //     context,
//                       //     MaterialPageRoute(
//                       //         builder: (context) => const LearningCenter()));
//                     }),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   void linkEnterBottomSheet(
//       BuildContext context, double? width, double? height) {
//     showModalBottomSheet(
//         context: context,
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
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
//                   child: InkWell(
//                     onTap: () {
//                       if (bottomSheetController.isPanelOpen) {
//                         bottomSheetController.close();
//                       }
//                     },
//                     child: Container(
//                       width: width * 0.2,
//                       height: 5,
//                       decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(width * 0.08),
//                           color: grey),
//                     ),
//                   ),
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(
//                       Icons.exit_to_app,
//                       size: width * 0.08,
//                     ),
//                     Text(
//                       ' Insert a link',
//                       style: textStyleHeading2WithTheme(context, width,
//                           whiteColor: 0),
//                     ),
//                   ],
//                 ),
//                 SizedBox(
//                   height: height! * 0.01,
//                 ),
//                 SizedBox(
//                   height: height * 0.01,
//                 ),
//                 Padding(
//                   padding: EdgeInsets.symmetric(
//                     horizontal: width * 0.08,
//                     vertical: width * 0.01,
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           Icon(
//                             FontAwesomeIcons.youtube,
//                             size: width * 0.045,
//                           ),
//                           const SizedBox(
//                             width: 8,
//                           ),
//                           Text(
//                             'Youtube',
//                             style: textStyleHeading2WithTheme(
//                                 context, width * 0.7),
//                           ),
//                         ],
//                       ),
//                       TextFormField(
//                         // autovalidateMode: AutovalidateMode.onUserInteraction,
//                         // validator: (String? name) {
//                         // if(name!.isEmpty){
//                         //   return 'Please Enter Goal';
//                         // }
//                         // else{
//                         //   return null;
//                         // }
//                         // },
//                         // style: TextStyle(color: primaryColor),
//                         style: textStyleHeading2WithTheme(context, width * 0.8,
//                             whiteColor: 0),

//                         // controller: goalDetailController,
//                         obscureText: false,
//                         keyboardType: TextInputType.name,
//                         maxLines: 2,
//                         decoration: InputDecoration(
//                           contentPadding: const EdgeInsets.only(top: 18),
//                           prefixIcon: Icon(
//                             Icons.content_paste,
//                             color: black,
//                           ),
//                           // hintText: 'Enter Details',
//                           // hintStyle: textStyleHeading2WithTheme(context,width*0.8, whiteColor: 2),
//                           // labelText: 'My Name is',
//                           // labelStyle: textStyleHeading2WithTheme(context,width*0.8, whiteColor: 2),
//                         ),
//                       ),
//                       SizedBox(
//                         height: height * 0.01,
//                       ),
//                       Row(
//                         children: [
//                           Icon(
//                             FontAwesomeIcons.tiktok,
//                             size: width * 0.045,
//                           ),
//                           const SizedBox(
//                             width: 8,
//                           ),
//                           Text(
//                             'Tiktok',
//                             style: textStyleHeading2WithTheme(
//                                 context, width * 0.7),
//                           ),
//                         ],
//                       ),
//                       TextFormField(
//                         // autovalidateMode: AutovalidateMode.onUserInteraction,
//                         // validator: (String? name) {
//                         // if(name!.isEmpty){
//                         //   return 'Please Enter Goal';
//                         // }
//                         // else{
//                         //   return null;
//                         // }
//                         // },
//                         // style: TextStyle(color: primaryColor),
//                         style: textStyleHeading2WithTheme(context, width * 0.8,
//                             whiteColor: 0),

//                         // controller: goalDetailController,
//                         obscureText: false,
//                         keyboardType: TextInputType.name,
//                         maxLines: 2,
//                         decoration: InputDecoration(
//                           contentPadding: const EdgeInsets.only(top: 18),
//                           prefixIcon: Icon(
//                             Icons.content_paste,
//                             color: black,
//                           ),
//                           // hintText: 'Enter Details',
//                           // hintStyle: textStyleHeading2WithTheme(context,width*0.8, whiteColor: 2),
//                           // labelText: 'My Name is',
//                           // labelStyle: textStyleHeading2WithTheme(context,width*0.8, whiteColor: 2),
//                         ),
//                       ),
//                       SizedBox(
//                         height: height * 0.1,
//                       ),
//                       ZakiPrimaryButton(
//                           title: 'Publish', width: width, onPressed: () {})
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           );
//         });
//   }
// }

// class VideoTypeButton extends StatelessWidget {
//   const VideoTypeButton({
//     Key? key,
//     required this.width,
//     this.onTap,
//     this.selected,
//     this.icon,
//     this.title,
//   }) : super(key: key);

//   final double width;
//   final VoidCallback? onTap;
//   final int? selected;
//   final IconData? icon;
//   final String? title;

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onTap,
//       child: Container(
//         decoration: BoxDecoration(
//             color: selected == 1 ? black : transparent,
//             border: Border.all(
//               color: selected == 1 ? black : grey,
//             )),
//         child: Padding(
//           padding: const EdgeInsets.all(2.0),
//           child: ListTile(
//             leading: Icon(
//               icon,
//               color: selected == 1 ? white : grey,
//             ),
//             title: Text(
//               title!,
//               style: textStyleHeading2WithTheme(context, width * 0.9,
//                   whiteColor: selected == 1 ? 1 : 2),
//             ),
//             trailing: Icon(
//               // ignore: deprecated_member_use
//               FontAwesomeIcons.arrowCircleRight,
//               color: selected == 1 ? white : black,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
