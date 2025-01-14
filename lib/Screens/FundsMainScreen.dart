// // ignore_for_file: file_names

// import 'package:flutter/material.dart';
// import 'package:zaki/Screens/PayOrRequestScreen.dart';
// import 'package:zaki/Widgets/AppBars/AppBar.dart';
// import '../Constants/Styles.dart';

// class FundsMainScreen extends StatefulWidget {
//   const FundsMainScreen({Key? key}) : super(key: key);

//   @override
//   _FundsMainScreenState createState() => _FundsMainScreenState();
// }

// class _FundsMainScreenState extends State<FundsMainScreen> {
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
//       body: SafeArea(
//         child: Column(
//           children: [
            
//             // Padding(
//             //   padding: EdgeInsets.symmetric(horizontal: width*0.025),
//             //   child: Container(
//             //         height: height * 0.06,
//             //         decoration: BoxDecoration(
//             //             color: transparent,
//             //             border: Border.all(color: grey.withValues(alpha:0.4)),
//             //             borderRadius: BorderRadius.circular(width * 0.08)),
//             //         child: Row(
//             //           children: [
//             //             Expanded(
//             //               child: InkWell(
//             //                 onTap: () {
//             //                    selectedIndex = 0;
//             //             setState(() {
//             //               _pageController.jumpToPage(selectedIndex);
//             //             });
//             //                 },
//             //                 child: AnimatedContainer(
//             //                   duration: const Duration(milliseconds: 300),
//             //                   decoration: BoxDecoration(
//             //                       borderRadius: selectedIndex == 0
//             //                           ? BorderRadius.circular(width * 0.08)
//             //                           : BorderRadius.circular(0),
//             //                       color: selectedIndex == 0 
//             //                           ? green
//             //                           : transparent),
//             //                   child: Row(
//             //                     mainAxisAlignment: MainAxisAlignment.center,
//             //                     children: [
//             //                       AnimatedSwitcher(
//             //                         duration: const Duration(milliseconds: 400),
//             //                         transitionBuilder: (child, animation) {
//             //                           return SlideTransition(
//             //                             position: animation.drive(Tween(
//             //                               begin: const Offset(1.0, 0.0),
//             //                               end: const Offset(0.0, 0.0),
//             //                             )),
//             //                             child: child,
//             //                           );
//             //                         },
//             //                       child: selectedIndex == 0?
//             //                         Image.asset(imageBaseAddress+'money_white.png') :Image.asset(imageBaseAddress+'money_green.png'),
//             //                       ),
//             //                       const SizedBox(width: 5),
//             //                       Center(
//             //                           child: FittedBox(
//             //                               child: Text(
//             //                         'Move Money',
//             //                         style: textStyleHeading1WithTheme(context, width * 0.6,
//             //           whiteColor: selectedIndex == 0? 0: 2),
//             //                       ))),
//             //                     ],
//             //                   ),
//             //                 ),
//             //               ),
//             //             ),
//             //             Expanded(
//             //                 child: InkWell(
//             //               onTap: () {
//             //                 selectedIndex = 1;
//             //             setState(() {
//             //               _pageController.jumpToPage(selectedIndex);
//             //             });
//             //               },
//             //               child: AnimatedContainer(
//             //                 duration: const Duration(milliseconds: 300),
//             //                 decoration: BoxDecoration(
//             //                     borderRadius: selectedIndex == 1 
//             //                         ? BorderRadius.circular(width * 0.08)
//             //                         : BorderRadius.circular(0),
//             //                     color: selectedIndex == 1 
//             //                         ? green
//             //                         : transparent),
//             //                 child: Row(
//             //                   mainAxisAlignment: MainAxisAlignment.center,
//             //                   children: [
//             //                     AnimatedSwitcher(
//             //                       duration: const Duration(milliseconds: 400),
//             //                       transitionBuilder: (child, animation) {
//             //                         return SlideTransition(
//             //                           position: animation.drive(Tween(
//             //                             begin: const Offset(1.0, 0.0),
//             //                             end: const Offset(0.0, 0.0),
//             //                           )),
//             //                           child: child,
//             //                         );
//             //                       },
//             //                       child: selectedIndex == 1?
//             //                         Image.asset(imageBaseAddress+'money_white.png') :Image.asset(imageBaseAddress+'money_green.png'),
//             //                     ),
//             //                       const SizedBox(width: 5),
//             //                     Center(
//             //                         child: FittedBox(
//             //                             child: Text(
//             //                       'Send or Request',
//             //                       style: textStyleHeading1WithTheme(context, width * 0.6,
//             //           whiteColor: selectedIndex == 1? 0: 2),
//             //                     ))),
//             //                   ],
//             //                 ),
//             //               ),
//             //             ))
//             //           ],
//             //         ),
//             //       ),
//             // ),
//             Expanded(
//               child: PageView(
//                 controller: _pageController,
//                 onPageChanged: (index) {},
//                 physics: const NeverScrollableScrollPhysics(),
//                 children: const[
//                   //  FundsWithFamily(),
//                    PayOrRequestScreen(),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
