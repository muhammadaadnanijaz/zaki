// import 'package:flutter/material.dart';
// import '../Constants/Styles.dart';
// import 'AccountSetUpInformation.dart';

// class WelcomeEmail extends StatefulWidget {
//   const WelcomeEmail({Key? key}) : super(key: key);

//   @override
//   State<WelcomeEmail> createState() => _WelcomeEmailState();
// }

// class _WelcomeEmailState extends State<WelcomeEmail> {
//   @override
//   Widget build(BuildContext context) {
    
//     var width = MediaQuery.of(context).size.width;
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Welcome Email',
//           style:
//               textStyleHeading1WithTheme(context, width * 0.8, whiteColor: 0),
//         ),
//         centerTitle: true,
//         backgroundColor: transparent,
//         elevation: 0,
//         leading: IconButton(
//           icon: (Icon(
//             Icons.clear,
//             color: black,
//           )),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//         actions: [
//           IconButton(
//             icon: Icon(
//               Icons.forward,
//               color: black,
//             ),
//             onPressed: () {
//               Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => const AccountSetupInformation()));
//             },
//           )
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 0),
//           child: Column(
//             children: [
//               Text(
//                 'Subect: Welcome to ZakiPay! We’re excited to have you \nBody \nHi [NAME],\nWelcome to ZakiPay! We’re excited to have you on board and we’d love to say thank you on behalf of our whole company for choosing us. We believe ZakiPaywill help your family better understand how to manage their finances from an early age....this will be a fun ride \nTo ensure you gain the very best out of our product/ service, we’ve put together some of the most helpful guides:\nThis video [LINK] walks you through setting up your [PRODUCT] for the first time. \nOur FAQ [LINK] is a great place to find the answers to common questions you might have as a new customer. \nThe knowledge base [LINK] has the answers to all of your tech related questions. \nOur blog [LINK] has some great tips and best practices on how you can use and benefit from [PRODUCT].\nHave any questions or need more information? Just shoot us an email! We’re always here to help. Feel free to hit us up on Facebook (link) or Twitter (link), if you want a fast response, too.\nTake care,\nSam,\nZakiPay',
//                 style: textStyleHeading2WithTheme(context, width * 0.8,
//                     whiteColor: 0),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
