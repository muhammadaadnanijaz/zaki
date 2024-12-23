// import 'package:flutter/material.dart';
// import 'package:zaki/Screens/TransferDone.dart';
// import 'package:loading_animations/loading_animations.dart';
// import '../Constants/Styles.dart';
// import 'package:slide_to_confirm/slide_to_confirm.dart';

// class TransferConfirm extends StatefulWidget {
//   const TransferConfirm({Key? key}) : super(key: key);

//   @override
//   _TransferConfirmState createState() => _TransferConfirmState();
// }

// class _TransferConfirmState extends State<TransferConfirm> {
//   bool loading = false;
//   @override
//   Widget build(BuildContext context) {
//     // var appConstants = Provider.of<AppConstants>(context, listen: true);
//     var height = MediaQuery.of(context).size.height;
//     var width = MediaQuery.of(context).size.width;
//     return Scaffold(
//       body: loading
//           ? Center(
//               child: LoadingBouncingGrid.circle(
//                 size: width * 0.2,
//               ),
//             )
//           : Column(
//               children: [
//                 Expanded(
//                     flex: 9,
//                     child: Center(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Column(
//                                 children: [
//                                   Container(
//                                     height: height * 0.075,
//                                     width: height * 0.075,
//                                     decoration: BoxDecoration(
//                                         shape: BoxShape.circle, color: grey),
//                                   ),
//                                   Text(
//                                     'John D',
//                                     style: textStyleHeading2WithTheme(
//                                         context, width * 0.8,
//                                         whiteColor: 0),
//                                   )
//                                 ],
//                               ),
//                               Padding(
//                                 padding: EdgeInsets.all(width * 0.05),
//                                 child: Icon(
//                                   Icons.arrow_forward,
//                                   size: width * 0.1,
//                                   color: grey,
//                                 ),
//                               ),
//                               Column(
//                                 children: [
//                                   Container(
//                                     height: height * 0.075,
//                                     width: height * 0.075,
//                                     decoration: BoxDecoration(
//                                         shape: BoxShape.circle, color: grey),
//                                   ),
//                                   Text(
//                                     'John D',
//                                     style: textStyleHeading2WithTheme(
//                                         context, width * 0.8,
//                                         whiteColor: 0),
//                                   )
//                                 ],
//                               ),
//                             ],
//                           ),
//                           SizedBox(
//                             height: height * 0.02,
//                           ),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 'SAR',
//                                 style: textStyleHeading2WithTheme(
//                                     context, width * 0.75,
//                                     whiteColor: 2),
//                               ),
//                               const SizedBox(
//                                 width: 5,
//                               ),
//                               Text(
//                                 '250.00',
//                                 style: textStyleHeading1WithTheme(
//                                     context, width + width * 0.3,
//                                     whiteColor: 0),
//                               ),
//                             ],
//                           )
//                         ],
//                       ),
//                     )),
//                 Expanded(
//                     flex: 2,
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 0),
//                       child: Column(
//                         children: [
//                           Center(
//                             child: ConfirmationSlider(
//                               height: height * 0.065,
//                               foregroundColor: grey,
//                               // backgroundColor: transparent,
//                               shadow: BoxShadow(color: black),
//                               onConfirmation: () async {
//                                 setState(() {
//                                   loading = true;
//                                 });
//                                 Future.delayed(
//                                     const Duration(milliseconds: 1000), () {
//                                   setState(() {
//                                     loading = false;
//                                     Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                             builder: (context) =>
//                                                 const TransferDoone()));
//                                   });
//                                 });
//                               },
//                             ),
//                           ),
//                         ],
//                       ),
//                     ))
//               ],
//             ),
//     );
//   }
// }
