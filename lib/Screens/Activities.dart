// // ignore_for_file: file_names

// import 'package:flutter/material.dart';
// import 'package:zaki/Constants/Spacing.dart';
// import 'package:zaki/Screens/AllActivities.dart';
// import 'package:zaki/Widgets/CustomSizedBox.dart';
// import '../Widgets/AppBars/AppBar.dart';

// class FriendsActivities extends StatefulWidget {
//   const FriendsActivities({Key? key}) : super(key: key);

//   @override
//   _FriendsActivitiesState createState() => _FriendsActivitiesState();
// }

// class _FriendsActivitiesState extends State<FriendsActivities> {
//   late PageController _pageController;
//   int selectedIndex = 0;

//   @override
//   void initState() {
//     _pageController = PageController(initialPage: selectedIndex);
//     super.initState();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _pageController.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     // var appConstants = Provider.of<AppConstants>(context, listen: true);
//     var height = MediaQuery.of(context).size.height;
//     var width = MediaQuery.of(context).size.width;
//     return Scaffold(
//       // actions: [
//       //   IconButton(
//       //       onPressed: () {
//       //         Navigator.push(
//       //             context,
//       //             MaterialPageRoute(
//       //                 builder: (context) => const UploadVideo()));
//       //       },
//       //       icon: Icon(
//       //         Icons.slow_motion_video_outlined,
//       //         color: black,
//       //       ))
//       // ],

//       body: SafeArea(
//         child: Column(
//           children: [
//             Padding(
//                 padding: getCustomPadding(),
//                 child: appBarHeader_005(
//                     context: context,
//                     appBarTitle: 'Socialize',
//                     backArrow: true,
//                     height: height,
//                     width: width,
//                     leadingIcon: true)),
//             // Padding(
//             //   padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 0),
//             //   child: Image.asset(imageBaseAddress+'ad.png')
//             // ),
//             // SizedBox(
//             //   height: height * 0.01,
//             // ),
//             // Container(
//             //       color: const Color(0XFFF9FFF9),
//             //       child: Padding(
//             //       padding: EdgeInsets.symmetric(horizontal: width*0.075, vertical:width*0.045, ),
//             //       child: Container(
//             //             height: height * 0.06,
//             //             decoration: BoxDecoration(
//             //                 color: white,
//             //                 border: Border.all(color: grey.withValues(alpha:0.4)),
//             //                 borderRadius: BorderRadius.circular(width * 0.08)),
//             //             child: Row(
//             //               children: [
//             //                 Expanded(
//             //                   child: InkWell(
//             //                     onTap: () {
//             //                        selectedIndex = 0;
//             //                 setState(() {
//             //                   _pageController.jumpToPage(selectedIndex);
//             //                 });
//             //                     },
//             //                     child: AnimatedContainer(
//             //                       duration: const Duration(milliseconds: 300),
//             //                       decoration: BoxDecoration(
//             //                           borderRadius: selectedIndex == 0
//             //                               ? BorderRadius.circular(width * 0.08)
//             //                               : BorderRadius.circular(0),
//             //                           color: selectedIndex == 0
//             //                               ? green
//             //                               : transparent),
//             //                       child: Row(
//             //                         mainAxisAlignment: MainAxisAlignment.center,
//             //                         children: [
//             //                           AnimatedSwitcher(
//             //                             duration: const Duration(milliseconds: 400),
//             //                             transitionBuilder: (child, animation) {
//             //                               return SlideTransition(
//             //                                 position: animation.drive(Tween(
//             //                                   begin: const Offset(1.0, 0.0),
//             //                                   end: const Offset(0.0, 0.0),
//             //                                 )),
//             //                                 child: child,
//             //                               );
//             //                             },
//             //                           child: selectedIndex == 0?
//             //                             Image.asset(imageBaseAddress+'social_selected.png') :Image.asset(imageBaseAddress+'social_un_selected.png'),
//             //                           ),
//             //                           const SizedBox(width: 5),
//             //                           Center(
//             //                               child: FittedBox(
//             //                                   child: Text(
//             //                             'Social',
//             //                             style: textStyleHeading2WithTheme(context, width * 0.75,
//             //               whiteColor: selectedIndex == 0? 1: 5),
//             //                           ))),
//             //                         ],
//             //                       ),
//             //                     ),
//             //                   ),
//             //                 ),
//             //                 Expanded(
//             //                     child: InkWell(
//             //                   onTap: () {
//             //                     selectedIndex = 1;
//             //                 setState(() {
//             //                   _pageController.jumpToPage(selectedIndex);
//             //                 });
//             //                   },
//             //                   child: AnimatedContainer(
//             //                     duration: const Duration(milliseconds: 300),
//             //                     decoration: BoxDecoration(
//             //                         borderRadius: selectedIndex == 1
//             //                             ? BorderRadius.circular(width * 0.08)
//             //                             : BorderRadius.circular(0),
//             //                         color: selectedIndex == 1
//             //                             ? green
//             //                             : transparent),
//             //                     child: Row(
//             //                       mainAxisAlignment: MainAxisAlignment.center,
//             //                       children: [
//             //                         AnimatedSwitcher(
//             //                           duration: const Duration(milliseconds: 400),
//             //                           transitionBuilder: (child, animation) {
//             //                             return SlideTransition(
//             //                               position: animation.drive(Tween(
//             //                                 begin: const Offset(1.0, 0.0),
//             //                                 end: const Offset(0.0, 0.0),
//             //                               )),
//             //                               child: child,
//             //                             );
//             //                           },
//             //                           child: selectedIndex == 1?
//             //                             Image.asset(imageBaseAddress+'video_selected.png') :Image.asset(imageBaseAddress+'video_un_selected.png'),
//             //                         ),
//             //                           const SizedBox(width: 5),
//             //                         Center(
//             //                             child: FittedBox(
//             //                                 child: Text(
//             //                           'Videos',
//             //                           style: textStyleHeading2WithTheme(context, width * 0.75,
//             //               whiteColor: selectedIndex == 1? 1: 5),
//             //                         ))),
//             //                       ],
//             //                     ),
//             //                   ),
//             //                 ))
//             //               ],
//             //             ),
//             //           ),
//             //   ),
//             //     ),
//             Expanded(
//               child: PageView(
//                 controller: _pageController,
//                 onPageChanged: (index) {},
//                 physics: const NeverScrollableScrollPhysics(),
//                 children: const [
//                   AllActivities(),
//                   // ActivitiesWithVideos()
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
