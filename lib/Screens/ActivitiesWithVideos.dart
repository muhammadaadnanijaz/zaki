// // ignore_for_file: file_names

// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart'
//     show FontAwesomeIcons;
// import '../Constants/Styles.dart';

// class ActivitiesWithVideos extends StatefulWidget {
//   const ActivitiesWithVideos({Key? key}) : super(key: key);

//   @override
//   _ActivitiesWithVideosState createState() => _ActivitiesWithVideosState();
// }

// class _ActivitiesWithVideosState extends State<ActivitiesWithVideos> {
//   @override
//   Widget build(BuildContext context) {
//     // var appConstants = Provider.of<AppConstants>(context, listen: true);
//     var height = MediaQuery.of(context).size.height;
//     var width = MediaQuery.of(context).size.width;
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: ListView.separated(
//         separatorBuilder: (context, index) => const Divider(),
//         itemCount: 3,
//         shrinkWrap: true,
//         physics: const BouncingScrollPhysics(),
//         itemBuilder: (BuildContext context, int index) {
//           return Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.all(2.0),
//                     child: Container(
//                       height: height * 0.065,
//                       width: height * 0.065,
//                       decoration:
//                           BoxDecoration(shape: BoxShape.circle, color: grey),
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(left: 4.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'John Doe',
//                           style: textStyleHeading1WithTheme(
//                               context, width * 0.7,
//                               whiteColor: 0),
//                         ),
//                         // Text(
//                         // 'Paid',
//                         // style: textStyleHeading2WithTheme(context,width*0.7, whiteColor: 0),
//                         // )
//                       ],
//                     ),
//                   ),
//                   const Spacer(),
//                   IconButton(
//                     icon: const Icon(Icons.more_horiz),
//                     onPressed: () {},
//                   )
//                 ],
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(2.0),
//                 child: Container(
//                   height: height * 0.25,
//                   width: double.infinity,
//                   decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(width * 0.02),
//                       color: grey),
//                 ),
//               ),
//               Padding(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 6.0, vertical: 4),
//                 child: Text(
//                   'Lorem ipsum dolor',
//                   style: textStyleHeading1WithTheme(context, width * 0.6,
//                       whiteColor: 2),
//                   maxLines: 3,
//                 ),
//               ),
//               Padding(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 6.0, vertical: 4),
//                 child: Text(
//                   'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et.',
//                   style: textStyleHeading2WithTheme(context, width * 0.75,
//                       whiteColor: 0),
//                   maxLines: 3,
//                 ),
//               ),
//               Padding(
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
//                                 color: green,
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
//                                 color: green,
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
//                                 color: green,
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
//                                 color: green,
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
//                                 color: green,
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
//                                 color: green,
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 0),
//                             child: Text(
//                               'Friends Only',
//                               style: textStyleHeading2WithTheme(
//                                   context, width * 0.75,
//                                   whiteColor: 2),
//                             ),
//                           )
//                         ],
//                       ),
//                     )
//             ],
//           );
//         },
//       ),
//     );
//   }
// }
