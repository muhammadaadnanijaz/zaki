// // ignore_for_file: file_names

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:zaki/Constants/Spacing.dart';
// import 'package:zaki/Widgets/TextHeader.dart';
// import '../Constants/AppConstants.dart';
// import '../Constants/Styles.dart';

// class FamilyInformation extends StatefulWidget {
//   const FamilyInformation({Key? key}) : super(key: key);

//   @override
//   _FamilyInformationState createState() => _FamilyInformationState();
// }

// class _FamilyInformationState extends State<FamilyInformation> {
//   final List<Map<String, dynamic>> _values = [];
//   var kidsLength = [
//     '0',
//     '1',
//     '2',
//     '3',
//     '4',
//   ];

//   @override
//   void initState() {
//     Future.delayed(
//         const Duration(
//           milliseconds: 100,
//         ), () {
//       var appConstants = Provider.of<AppConstants>(context, listen: false);
//       appConstants.updateHveKidsOrNot('Yes');
//     });
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     var appConstants = Provider.of<AppConstants>(context, listen: true);
//     // var height = MediaQuery.of(context).size.height;
//     var width = MediaQuery.of(context).size.width;
//     return Scaffold(
//       body: SafeArea(
//         child: (
//           // appConstants.signUpRole == "Mom" ||
//                 appConstants.accountSettingUpFor == "Me")
//             ? const Center(child: Text('Cant Add kids'))
//             : 
//             SingleChildScrollView(
//                 physics: const BouncingScrollPhysics(),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     spacing_large,
//                     // Row(
//                     //   children: [
//                     //     Radio(
//                     //         value: SingingCharacter.yes,
//                     //         groupValue: appConstants.kids,
//                     //         onChanged: (SingingCharacter? caha) {
//                     //           appConstants.updateHaveKids(caha);
//                     //           appConstants.updateHveKidsOrNot('Yes');
//                     //         }),
//                     //     Text(
//                     //       'Yes',
//                     //       style: heading2TextStyle(context, width),
//                     //     ),
//                     //     Radio(
//                     //         value: SingingCharacter.no,
//                     //         groupValue: appConstants.kids,
//                     //         onChanged: (SingingCharacter? caha) {
//                     //           appConstants.updateHaveKids(caha);
//                     //           appConstants.updateHveKidsOrNot('No');
//                     //         }),
//                     //     Text(
//                     //       'No',
//                     //       style: heading2TextStyle(context, width),
//                     //     ),
//                     //   ],
//                     // ),
//                     appConstants.kids!.index == 1
//                         ? Container()
//                         : Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               spacing_large,
//                               TextHeader1(
//                                 title: 
//                                 'How many kids do you have?',
//                               ),
//                               DropdownButton(
//                                 isExpanded: true,
//                                 // Initial Value
//                                 value: appConstants.kidsLength,
//                                 style: heading2TextStyle(context, width),

//                                 // Down Arrow Icon
//                                 icon: const Icon(Icons.keyboard_arrow_down),

//                                 // Array list of items
//                                 items: kidsLength.map((String items) {
//                                   return DropdownMenuItem(
//                                     value: items,
//                                     child: Text(items),
//                                   );
//                                 }).toList(),
//                                 // After selecting the desired option,it will
//                                 // change button value to selected value
//                                 onChanged: (String? newValue) {
//                                   if (newValue == '0') {
//                                     appConstants.updateHveKidsOrNot('No');
//                                   } else{
//                                     appConstants.updateHveKidsOrNot('Yes');
//                                   }
//                                   appConstants.updateKidsLength(newValue!);
//                                 },
//                               ),
//                               spacing_medium,
//                               if(appConstants.kidsLength !='0')
//                               Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     'My kids names are:',
//                                     style: heading1TextStyle(context, width),
//                                   ),
//                                   ListView.builder(
//                                 itemCount: int.parse(appConstants.kidsLength),
//                                 shrinkWrap: true,
//                                 // scrollDirection: Axis.horizontal,
//                                 physics: const NeverScrollableScrollPhysics(),
//                                 itemBuilder:
//                                     (BuildContext context, int index) {
//                                   return TextFormField(
//                                     validator: (String? name) {
//                                       // if(name!.isEmpty){
//                                       //   return 'Enter Name';
//                                       // }
//                                       // else{
//                                       return null;
//                                       // }
//                                     },
//                                     onChanged: (val) {
//                                       _onUpdate(index, val, appConstants);
//                                     },
//                                     // style: TextStyle(color: primaryColor),
//                                     style: heading2TextStyle(context, width),
//                                     // controller: nameController,
//                                     obscureText: false,
//                                     keyboardType: TextInputType.name,
//                                     maxLines: 1,
//                                     maxLength: 15,
//                                     decoration: InputDecoration(
//                                       counterText: '',
//                                       // hintText: 'Jhons smith',
//                                       // hintStyle: textStyleHeading2WithTheme(context,width*0.8, whiteColor: 2),
//                                       hintText: 'First/Nick Name',
//                                       hintStyle:
//                                           heading2TextStyle(context, width),
//                                     ),
//                                   );
//                                 },
//                               ),
                            
//                                 ],
//                               ),
//                               ],
//                           ),
//                   ],
//                 ),
//               ),
//       ),
//     );
//   }

//   _onUpdate(int index, String val, AppConstants appConstants) async {
//     int foundKey = -1;
//     for (var map in _values) {
//       if (map.containsKey("id")) {
//         if (map["id"] == index) {
//           foundKey = index;
//           break;
//         }
//       }
//     }
//     if (-1 != foundKey) {
//       _values.removeWhere((map) {
//         return map["id"] == foundKey;
//       });
//     }
//     Map<String, dynamic> json = {
//       "id": index,
//       "value": val,
//     };
//     _values.add(json);
//     appConstants.updateKidsRegistrationList(_values);
//   }
// }
