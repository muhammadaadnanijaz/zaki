// import 'dart:io';
// import 'package:country_picker/country_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:provider/provider.dart';
// import 'package:zaki/Constants/AppConstants.dart';
// import 'package:zaki/Constants/Styles.dart';
// import 'package:flutter_colorpicker/flutter_colorpicker.dart';
// import 'package:zaki/Models/ImageModels.dart';

// enum SingingCharacter { male, female }

// class Profile extends StatefulWidget {
//   const Profile({Key? key}) : super(key: key);

//   @override
//   _ProfileState createState() => _ProfileState();
// }

// class _ProfileState extends State<Profile> {
//   late SingingCharacter? gender = SingingCharacter.male;
//   final ImagePicker _picker = ImagePicker();
// // create some values
//   Color pickerColor = const Color(0xff443a49);
//   Color currentColor = const Color(0xFFFFFF00);

// // ValueChanged<Color> callback
//   void changeColor(Color color) {
//     setState(() => pickerColor = color);
//   }

//   XFile? img;
//   XFile? userLogo;
//   List<ImageModel> imageList = [
//     ImageModel(id: 0, imageName: imageBaseAddress + '1.png'),
//     ImageModel(id: 1, imageName: imageBaseAddress + '2.png'),
//     ImageModel(id: 2, imageName: imageBaseAddress + '3.png'),
//     ImageModel(id: 3, imageName: imageBaseAddress + '4.jpg'),
//   ];
//   @override
//   Widget build(BuildContext context) {
//     var appConstants = Provider.of<AppConstants>(context, listen: true);
//     var height = MediaQuery.of(context).size.height;
//     var width = MediaQuery.of(context).size.width;
//     return Scaffold(
//       appBar: AppBar(
//         title: InkWell(
//             onTap: () {
//               // Navigator.push(context, MaterialPageRoute(builder: (context)=>GetContacts()));
//             },
//             child: Text(
//               'Profile',
//               style: textStyleHeading1WithTheme(context, width, whiteColor: 0),
//             )),
//         backgroundColor: white,
//         leading: IconButton(
//           icon: (Icon(
//             Icons.arrow_back,
//             color: black,
//           )),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             SizedBox(
//               height: height * 0.02,
//             ),
//             Row(
//               children: [
//                 Text(
//                   'First Name:',
//                   style:
//                       textStyleHeading1WithTheme(context, width, whiteColor: 0),
//                 ),
//                 SizedBox(
//                   width: width * 0.02,
//                 ),
//                 Text(
//                   'Muhammad Adnan',
//                   style:
//                       textStyleHeading2WithTheme(context, width, whiteColor: 0),
//                 ),
//               ],
//             ),
//             SizedBox(
//               height: height * 0.01,
//             ),
//             Row(
//               children: [
//                 Text(
//                   'Last Name:',
//                   style:
//                       textStyleHeading1WithTheme(context, width, whiteColor: 0),
//                 ),
//                 SizedBox(
//                   width: width * 0.02,
//                 ),
//                 Text(
//                   'Ijaz',
//                   style:
//                       textStyleHeading2WithTheme(context, width, whiteColor: 0),
//                 ),
//               ],
//             ),
//             SizedBox(
//               height: height * 0.01,
//             ),
//             Row(
//               children: [
//                 Text(
//                   'Nick Name:',
//                   style:
//                       textStyleHeading1WithTheme(context, width, whiteColor: 0),
//                 ),
//                 SizedBox(
//                   width: width * 0.02,
//                 ),
//                 Text(
//                   'Dani',
//                   style:
//                       textStyleHeading2WithTheme(context, width, whiteColor: 0),
//                 ),
//               ],
//             ),
//             SizedBox(
//               height: height * 0.01,
//             ),
//             Row(
//               children: [
//                 Text(
//                   'Email:',
//                   style:
//                       textStyleHeading1WithTheme(context, width, whiteColor: 0),
//                 ),
//                 SizedBox(
//                   width: width * 0.02,
//                 ),
//                 Expanded(
//                   child: Text(
//                     'muhammadadnanijaz01@gmail.com',
//                     style: textStyleHeading2WithTheme(context, width,
//                         whiteColor: 0),
//                     overflow: TextOverflow.clip,
//                   ),
//                 ),
//                 IconButton(
//                   icon: Icon(
//                     Icons.verified,
//                     color: black,
//                   ),
//                   onPressed: () async {},
//                 )
//               ],
//             ),
//             SizedBox(
//               height: height * 0.01,
//             ),
//             Row(
//               children: [
//                 Text(
//                   'Phone:',
//                   style:
//                       textStyleHeading1WithTheme(context, width, whiteColor: 0),
//                 ),
//                 SizedBox(
//                   width: width * 0.02,
//                 ),
//                 Text(
//                   '00923225898717',
//                   style:
//                       textStyleHeading2WithTheme(context, width, whiteColor: 0),
//                 ),
//               ],
//             ),
//             SizedBox(
//               height: height * 0.01,
//             ),
//             Row(
//               children: [
//                 Text(
//                   'Date of birth:',
//                   style:
//                       textStyleHeading1WithTheme(context, width, whiteColor: 0),
//                 ),
//                 SizedBox(
//                   width: width * 0.02,
//                 ),
//                 Text(
//                   '22/01/1995',
//                   style:
//                       textStyleHeading2WithTheme(context, width, whiteColor: 0),
//                 ),
//               ],
//             ),
//             Row(
//               children: [
//                 Text(
//                   'Gender',
//                   style:
//                       textStyleHeading1WithTheme(context, width, whiteColor: 0),
//                 ),
//                 SizedBox(
//                   width: width * 0.02,
//                 ),
//                 Radio(
//                     value: SingingCharacter.male,
//                     groupValue: gender,
//                     onChanged: (SingingCharacter? caha) {
//                       setState(() {
//                         gender = caha;
//                       });
//                     }),
//                 Text(
//                   'male',
//                   style: textStyleHeading2WithTheme(context, width),
//                 ),
//                 Radio(
//                     value: SingingCharacter.female,
//                     groupValue: gender,
//                     onChanged: (SingingCharacter? caha) {
//                       setState(() {
//                         gender = caha;
//                       });
//                     }),
//                 Text(
//                   'fe male',
//                   style: textStyleHeading2WithTheme(context, width),
//                 ),
//               ],
//             ),
//             SizedBox(
//               height: height * 0.01,
//             ),
//             Row(
//               children: [
//                 Text(
//                   'Country of Residence :',
//                   style:
//                       textStyleHeading1WithTheme(context, width, whiteColor: 0),
//                 ),
//                 SizedBox(
//                   width: width * 0.02,
//                 ),
//                 InkWell(
//                   onTap: () {
//                     showCountryPicker(
//                       context: context,
//                       showWorldWide: false,
//                       showPhoneCode:
//                           false, // optional. Shows phone code before the country name.
//                       onSelect: (Country country) {
//                         appConstants.updateCountry(country.name);
//                         showSnackBarDialog(
//                             context: context,
//                             message:
//                                 'Countery: ${country.name} code is: ${country.phoneCode} ');
//                       },
//                     );
//                   },
//                   child: Text(
//                     appConstants.selectedCountry,
//                     style: textStyleHeading2WithTheme(context, width,
//                         whiteColor: 0),
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(
//               height: height * 0.01,
//             ),
//             Row(
//               children: [
//                 Text(
//                   'Currency :',
//                   style:
//                       textStyleHeading1WithTheme(context, width, whiteColor: 0),
//                 ),
//                 SizedBox(
//                   width: width * 0.02,
//                 ),
//                 Text(
//                   'USD',
//                   style:
//                       textStyleHeading2WithTheme(context, width, whiteColor: 0),
//                 ),
//               ],
//             ),
//             InkWell(
//                 onTap: () async {
//                   // Pick an image
//                   final XFile? image = await _picker.pickImage(
//                       maxWidth: 500,
//                       maxHeight: 600,
//                       imageQuality: 80,
//                       source: ImageSource.gallery);
//                   if (image != null) {
//                     setState(() {
//                       imageList.add(ImageModel(id: 6, imageName: image.path));
//                     });
//                   }
//                 },
//                 child: Text(
//                   'Pick any Image:',
//                   style:
//                       textStyleHeading1WithTheme(context, width, whiteColor: 0),
//                 )),
//             SizedBox(
//               height: height * 0.13,
//               width: width,
//               child: ListView.builder(
//                   itemCount: imageList.length,
//                   scrollDirection: Axis.horizontal,
//                   shrinkWrap: true,
//                   physics: const BouncingScrollPhysics(),
//                   itemBuilder: (context, index) {
//                     return Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 0),
//                       child: Container(
//                         height: height * 0.13,
//                         width: width * 0.25,
//                         color: Colors.grey.withOpacity(0.2),
//                         child: imageList[index]
//                                 .imageName!
//                                 .contains('com.zakipay.teencard')
//                             ? Image.file(
//                                 File(imageList[index].imageName!),
//                                 // height: 150,
//                                 // width: double.infinity,
//                                 // fit: BoxFit.fill,
//                               )
//                             : Image.asset(imageList[index].imageName!),
//                       ),
//                     );
//                   }),
//             ),
//             SizedBox(
//               height: height * 0.01,
//             ),
//             Row(
//               children: [
//                 InkWell(
//                     onTap: () async {
//                       final XFile? image = await _picker.pickImage(
//                           maxWidth: 500,
//                           maxHeight: 600,
//                           imageQuality: 80,
//                           source: ImageSource.gallery);
//                       if (image != null) {
//                         userLogo = image;
//                         setState(() {});
//                       }
//                     },
//                     child: Text(
//                       'Profile Logo:',
//                       style: textStyleHeading1WithTheme(context, width,
//                           whiteColor: 0),
//                     )),
//                 Expanded(
//                     child: Center(
//                   child: InkWell(
//                     onTap: () async {
//                       var dynamic = await showDialog(
//                         builder: (context) => AlertDialog(
//                           title: const Text('Pick a color!'),
//                           content: SingleChildScrollView(
//                             // child: ColorPicker(
//                             //   pickerColor: pickerColor,
//                             //   onColorChanged: changeColor,
//                             // ),
//                             // Use Material color picker:
//                             //
//                             child: MaterialPicker(
//                               pickerColor: pickerColor,
//                               onColorChanged: changeColor,
//                               // showLabel: true, // only on portrait mode
//                             ),
//                             //
//                             // Use Block color picker:
//                             //
//                             // child: BlockPicker(
//                             //   pickerColor: currentColor,
//                             //   onColorChanged: changeColor,
//                             // ),
//                             //
//                             // child: MultipleChoiceBlockPicker(
//                             //   pickerColors: currentColors,
//                             //   onColorsChanged: changeColors,
//                             // ),
//                           ),
//                           actions: <Widget>[
//                             ElevatedButton(
//                               child: const Text('Got it'),
//                               onPressed: () {
//                                 setState(() => currentColor = pickerColor);
//                                 Navigator.pop(context, currentColor);
//                               },
//                             ),
//                           ],
//                         ),
//                         context: context,
//                       );
//                       if (dynamic != null) {
//                         print('Picked Color is: $dynamic');
//                         setState(() {
//                           pickerColor = dynamic;
//                         });
//                       }
//                     },
//                     child: Container(
//                       decoration: BoxDecoration(
//                           shape: BoxShape.circle, color: pickerColor),
//                       width: width * 0.25,
//                       height: height * 0.12,
//                       child: Center(
//                         child: userLogo == null
//                             ? Text(
//                                 'MI',
//                                 style: textStyleHeading1WithTheme(
//                                     context, width + width * 0.4,
//                                     whiteColor: 1),
//                               )
//                             : ClipOval(
//                                 child: Image.file(
//                                 File(userLogo!.path),
//                                 fit: BoxFit.cover,
//                                 width: width * 0.25,
//                                 height: height * 0.12,
//                               )),
//                       ),
//                     ),
//                   ),
//                 ))
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
