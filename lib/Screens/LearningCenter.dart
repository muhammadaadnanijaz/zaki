// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:zaki/Widgets/ZakiPrimaryButton.dart';
// import '../Constants/Styles.dart';

// class LearningCenter extends StatefulWidget {
//   const LearningCenter({Key? key}) : super(key: key);

//   @override
//   _LearningCenterState createState() => _LearningCenterState();
// }

// class _LearningCenterState extends State<LearningCenter> {
//   @override
//   Widget build(BuildContext context) {
//     // var appConstants = Provider.of<AppConstants>(context, listen: true);
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
//         elevation: 0,
//         title: Text(
//           '',
//           style:
//               textStyleHeading1WithTheme(context, width * 0.85, whiteColor: 0),
//         ),
//       ),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(
//             height: height * 0.01,
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 8.0),
//             child: Text(
//               'Learning Center',
//               style: textStyleHeading1WithTheme(context, width * 0.75,
//                   whiteColor: 0),
//             ),
//           ),
//           SizedBox(
//             height: height * 0.01,
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 8.0),
//             child: ZakiPrimaryButton(
//               title: 'Ad',
//               width: width,
//               onPressed: () {
                
//               },
//             ),
//           ),
//           SizedBox(
//             height: height * 0.01,
//           ),

//           // Padding(
//           //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
//           //   child: Row(
//           //     children: [
//           //       Expanded(
//           //         child: Padding(
//           //           padding: const EdgeInsets.symmetric(horizontal: 2.0),
//           //           child: ZakiPrimaryButton(
//           //           onPressed: (){
//           //             // if (selectedIndex==1) {
//           //             // selectedIndex = selectedIndex-1;
//           //             // setState(() {
//           //             // _pageController.jumpToPage(selectedIndex);
//           //             // });

//           //             // }

//           //           },
//           //           title: 'All',
//           //           selected: 0,
//           //           width: width,
//           //           ),
//           //         ),
//           //       ),
//           //       Expanded(
//           //         child: Padding(
//           //           padding: const EdgeInsets.symmetric(horizontal: 2.0),
//           //           child: ZakiPrimaryButton(
//           //           onPressed: (){
//           //             // if (selectedIndex==1) {
//           //             // selectedIndex = selectedIndex-1;
//           //             // setState(() {
//           //             // _pageController.jumpToPage(selectedIndex);
//           //             // });

//           //             // }

//           //           },
//           //           title: 'Articles',
//           //           selected: 1,
//           //           // selected: selectedIndex==0?0:1,
//           //           width: width,
//           //           ),
//           //         ),
//           //       ),
//           //      Expanded(
//           //         child: Padding(
//           //           padding: const EdgeInsets.symmetric(horizontal: 2.0),
//           //           child: ZakiPrimaryButton(
//           //           onPressed: (){
//           //             // if (selectedIndex==0) {
//           //             // selectedIndex = selectedIndex+1;
//           //             // setState(() {
//           //             // _pageController.jumpToPage(selectedIndex);
//           //             // });

//           //             // }

//           //           },
//           //           // selected: selectedIndex==0?1:0,
//           //           selected: 1,
//           //           title: 'Videos',
//           //           width: width,
//           //           ),
//           //         ),
//           //     ),
//           //     ],
//           //   ),
//           // ),
//           Expanded(
//               child: Padding(
//             padding: const EdgeInsets.symmetric(vertical: 8.0),
//             child: ListView.separated(
//               separatorBuilder: (context, index) => const Divider(),
//               itemCount: 3,
//               shrinkWrap: true,
//               physics: const BouncingScrollPhysics(),
//               itemBuilder: (BuildContext context, int index) {
//                 return Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.all(0.0),
//                       child: Container(
//                         height: height * 0.25,
//                         width: double.infinity,
//                         decoration: BoxDecoration(color: grey),
//                       ),
//                     ),
//                     Row(
//                       children: [
//                         Expanded(
//                           child: Padding(
//                             padding: const EdgeInsets.symmetric(
//                                 horizontal: 6.0, vertical: 4),
//                             child: Text(
//                               'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et.',
//                               style: textStyleHeading2WithTheme(
//                                   context, width * 0.75,
//                                   whiteColor: 2),
//                               maxLines: 2,
//                             ),
//                           ),
//                         ),
//                         IconButton(
//                           icon: const Icon(Icons.more_vert),
//                           onPressed: () {},
//                         )
//                       ],
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 0),
//                       child: Row(
//                         children: [
//                           InkWell(
//                             child: Padding(
//                               padding:
//                                   const EdgeInsets.symmetric(horizontal: 4.0),
//                               child: Icon(
//                                 FontAwesomeIcons.whatsapp,
//                                 size: width * 0.05,
//                               ),
//                             ),
//                           ),
//                           InkWell(
//                             child: Padding(
//                               padding:
//                                   const EdgeInsets.symmetric(horizontal: 4.0),
//                               child: Icon(
//                                 FontAwesomeIcons.facebook,
//                                 size: width * 0.05,
//                               ),
//                             ),
//                           ),
//                           InkWell(
//                             child: Padding(
//                               padding:
//                                   const EdgeInsets.symmetric(horizontal: 4.0),
//                               child: Icon(
//                                 FontAwesomeIcons.share,
//                                 size: width * 0.05,
//                               ),
//                             ),
//                           ),
//                           InkWell(
//                             child: Padding(
//                               padding:
//                                   const EdgeInsets.symmetric(horizontal: 4.0),
//                               child: Icon(
//                                 Icons.favorite,
//                                 size: width * 0.05,
//                               ),
//                             ),
//                           ),
//                           Text(
//                             '5',
//                             style: textStyleHeading2WithTheme(
//                                 context, width * 0.62,
//                                 whiteColor: 0),
//                           ),
//                           InkWell(
//                             child: Padding(
//                               padding:
//                                   const EdgeInsets.symmetric(horizontal: 4.0),
//                               child: Icon(
//                                 FontAwesomeIcons.comment,
//                                 size: width * 0.05,
//                               ),
//                             ),
//                           ),
//                           Text(
//                             '8',
//                             style: textStyleHeading2WithTheme(
//                                 context, width * 0.62,
//                                 whiteColor: 0),
//                           ),
//                           const Spacer(),
//                           Icon(
//                             FontAwesomeIcons.lock,
//                             size: width * 0.05,
//                             color: grey,
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 0),
//                             child: Text(
//                               'Friends Only',
//                               style: textStyleHeading2WithTheme(
//                                   context, width * 0.6,
//                                   whiteColor: 2),
//                             ),
//                           )
//                         ],
//                       ),
//                     )
//                   ],
//                 );
//               },
//             ),
//           ))
//         ],
//       ),
//     );
//   }
// }
