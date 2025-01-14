// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:provider/provider.dart';
// import 'package:zaki/Widgets/CustomSizedBox.dart';
// import 'package:zaki/Widgets/ZakiPrimaryButton.dart';

// import '../Constants/AppConstants.dart';
// import '../Constants/HelperFunctions.dart';
// import '../Constants/Spacing.dart';
// import '../Constants/Styles.dart';
// import '../Services/api.dart';
// import '../Widgets/AppBars/AppBar.dart';
// import '../Widgets/ConfirmationScreen.dart';
// import '../Widgets/CustomConfermationScreen.dart';

// class ManageLinkedCards extends StatefulWidget {
//   const ManageLinkedCards({Key? key}) : super(key: key);

//   @override
//   State<ManageLinkedCards> createState() => _ManageLinkedCardsState();
// }

// class _ManageLinkedCardsState extends State<ManageLinkedCards> {
//   final formGlobalKey = GlobalKey<FormState>();
//   final amountController = TextEditingController();
//   final cvvController = TextEditingController();
//   final cardHolderNameController = TextEditingController();
//   final cardNumberController = TextEditingController();
//   final zipCodeController = TextEditingController();
//   final expireDateController =TextEditingController();
//   double processingFee = 0.00;

//   @override
//   void dispose() {
//     amountController.dispose();
//     cvvController.dispose();
//     super.dispose();
//   }

//   void clearFields() {
//     amountController.text = '';
//     cvvController.text = '';
//   }

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     var appConstants = Provider.of<AppConstants>(context, listen: true);
//     var height = MediaQuery.of(context).size.height;
//     var width = MediaQuery.of(context).size.width;
//     return Scaffold(
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: getCustomPadding(),
//             child: Column(
//               children: [
//                 appBarHeader_005(context: context, appBarTitle: 'Manage Linked Card', height: height, width: width),
//                 Form(
//                   key: formGlobalKey,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'Your Linked Card',
//                         style: heading3TextStyle(width),
//                       ),
//                       spacing_medium,
//                       Container(
//                         decoration: BoxDecoration(
//                             color: grey.withValues(alpha:0.4),
//                             borderRadius: BorderRadius.circular(width * 0.015)),
//                         child: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Text(
//                                     '(Card Name Here)',
//                                     style: heading1TextStyle(context, width),
//                                   ),
//                                   InkWell(
//                                     onTap: () {
//                                       cardHolderNameController.text = appConstants.fundMeWalletModel.FM_WALLET_cardHolderName!;
//                                       cardNumberController.text = appConstants.fundMeWalletModel.FM_WALLET_card_number!;
//                                       updateCardInfoBottomSheet(
//                                           context: context,
//                                           width: width,
//                                           height: height);
//                                     },
//                                     child: Icon(
//                                       // ignore: deprecated_member_use
//                                       FontAwesomeIcons.solidEdit,
//                                       color: black,
//                                     ),
//                                   )
//                                 ],
//                               ),
//                               CustomSizedBox(
//                                 height: height,
//                               ),
//                               CustomSizedBox(
//                                 height: height,
//                               ),
//                               Text(
//                                 '${appConstants.fundMeWalletModel.FM_WALLET_cardHolderName}',
//                                 style: heading3TextStyle(width),
//                               ),
//                               // "${expiryDate.toString().split('/')[0]}/${expiryDate.toString().split('/')[2]}"
//                               Text(
//                                 '${formatedDate((appConstants.fundMeWalletModel.FM_WALLET_expiryDate)!.toLocal())}'.split('/')[0] +'/'+ '${formatedDate((appConstants.fundMeWalletModel.FM_WALLET_expiryDate)!.toLocal())}'.split('/')[2],
//                                 style: heading3TextStyle(width),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       spacing_large,
//                       Text(
//                         'How Much?',
//                         style: heading1TextStyle(context, width),
//                       ), 
//                     TextFormField(
//                           autovalidateMode: AutovalidateMode.onUserInteraction,
//                           validator: (String? amount) {
//                             if (amount!.isEmpty) {
//                               return 'Enter Amount';
//                             }else if(double.parse(amount)>500) {
//                               return "Maximum ${getCurrencySymbol(context, appConstants: appConstants)}500";
//                             }  else {
//                               return null;
//                             }
//                           },
//                           // style: TextStyle(color: primaryColor),
//                           style: heading2TextStyle(context, width),
//                           controller: amountController,
//                           obscureText: false,
//                           keyboardType: TextInputType.number,
//                           maxLines: 1,
//                           onFieldSubmitted: (String value){
//                             processingFee = double.parse(value) *0.01;
//                           },
//                           decoration: InputDecoration(
//                             hintText: '0.00',
//                             prefixIcon: Padding(
//                               padding: const EdgeInsets.all(1),
//                               child: Text(
//                                 "${getCurrencySymbol(context, appConstants: appConstants)}",
//                                 style: heading2TextStyle(context, width),
//                               ),
//                             ),
//                             prefixIconConstraints:
//                                 const BoxConstraints(minWidth: 0, minHeight: 0),
//                             hintStyle: heading2TextStyle(context, width),
//                             // labelText: 'Enter Email',
//                             // labelStyle: textStyleHeading2WithTheme(context,width*0.8, whiteColor: 0),
//                           ),
//                         ),
//                       spacing_large,
//                       Row(
//                         children: [
//                           Expanded(
//                             child: Column(
//                               children: [
//                                 Row(
//                                   children: [
//                                     Text(
//                                       'Security Code',
//                                       style: heading1TextStyle(context, width),
//                                     ),
//                                   ],
//                                 ),
//                                 TextFormField(
//                                   autovalidateMode:
//                                       AutovalidateMode.onUserInteraction,
//                                       maxLength: 5,
//                                       obscureText: true,
//                                   obscuringCharacter: '*',
//                                   validator: (String? password) {
//                                     return null;

//                                     // if(password!.isEmpty){
//                                     //   return 'Please Enter Password';
//                                     // } else if (password!=passwordCotroller.text) {
//                                     //   return 'Password doesn’t match :( Try again';
//                                     // }
//                                     // else{
//                                     //   return null;
//                                     // }
//                                   },
//                                   style: heading2TextStyle(context, width),
//                                     decoration: InputDecoration(
//                                       counterText: ''
//                                     ),
//                                   controller: cvvController,
//                                   // obscureText: appConstants.passwordVissibleRegistration,
//                                   keyboardType: TextInputType.number,
//                                 ),
//                               ],
//                             ),
//                           ),
//                           SizedBox(
//                             width: width * 0.08,
//                           ),
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   'Zip Code',
//                                   style: heading1TextStyle(context, width),
//                                 ),
//                                 TextFormField(
//                                   autovalidateMode:
//                                       AutovalidateMode.onUserInteraction,
//                                       maxLength: 5,
//                                   validator: (String? password) {
//                                     return null;

//                                     // if(password!.isEmpty){
//                                     //   return 'Please Enter Password';
//                                     // } else if (password!=passwordCotroller.text) {
//                                     //   return 'Password doesn’t match :( Try again';
//                                     // }
//                                     // else{
//                                     //   return null;
//                                     // }
//                                   },
//                                   decoration: InputDecoration(
//                                     counterText: ''
//                                   ),
//                                   style: heading2TextStyle(context, width),
//                                   controller: zipCodeController,
//                                   // obscureText: appConstants.passwordVissibleRegistration,
//                                   keyboardType: TextInputType.number,
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                      spacing_small,
//                       Row(
//                                     children: [
//                                       Text(
//                                                     'Processing Fee:  ',
//                                                     style: heading3TextStyle(width),
//                                                   ),
//                                       Text(
//                                                 '${getCurrencySymbol(context, appConstants: appConstants)} $processingFee',
//                                                 style: heading2TextStyle(context, width),
//                                               ),
//                                     ],
//                                   ),
//                       spacing_large,
//                       ZakiPrimaryButton(
//                           title: 'Fund My Wallet', width: width,
//                           onPressed:(amountController.text.isEmpty  || zipCodeController.text.length<5 || cvvController.text.length <5 )?null:  () async{
//                             ApiServices service = ApiServices();
//                             // await ApiServices().addMoneyToMainWallet(amountSend: amountController.text.trim(), senderId: appConstants.userRegisteredId);
//                             await service.addMoneyToMainWallet(
//                                           amountSend: amountController.text.trim(),
//                                           senderId: appConstants.userRegisteredId);
//                            await service.saveProcessingFee(feeAmount: processingFee, totalAmount: double.parse(amountController.text.trim()), id: appConstants.userRegisteredId);
//                                           showNotification(error: 0, icon: Icons.check, message: 'Amount Added Successfully');
                          
//                           Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                           builder: (context) => CustomConfermationScreen(
//                                             title: 'Mission Accomplished!',
//                                             subTitle: "${getCurrencySymbol(context, appConstants: appConstants)} ${amountController.text} added to your \n${appConstants.nickNameModel.NickN_SpendWallet?? 'Spend'} Wallet",)));
//                           // Navigator.push(
//                           //           context,
//                           //           MaterialPageRoute(
//                           //               builder: (context) =>
//                           //                    ConfirmedScreen(
//                           //                     amount: amountController.text.trim(), 
//                           //                     // name: appConstants.userModel.usaUserName, 
//                           //                     walletImageUrl: imageBaseAddress +'spending_act.png', 
//                           //                     fromCreaditCardScreen: true,
//                           //                     )));
//                           }
//                           ),
//                         spacing_medium
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   void updateCardInfoBottomSheet(
//       {required BuildContext context, double? width, double? height}) {
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
//           var appConstants = Provider.of<AppConstants>(bc, listen: true);
//           String expiryDate = formatedDate((appConstants.fundMeWalletModel.FM_WALLET_expiryDate)!.toLocal());
//           DateTime expireDate = DateTime.now();
          
//           expireDateController.text = "${expiryDate.toString().split('/')[0]}/${expiryDate.toString().split('/')[2]}";
//           return Padding(
//             padding: MediaQuery.of(context).viewInsets,
//             child: SingleChildScrollView(
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
//                     child: InkWell(
//                       onTap: () {},
//                       child: Container(
//                         width: width * 0.2,
//                         height: 5,
//                         decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(width * 0.08),
//                             color: grey),
//                       ),
//                     ),
//                   ),
//                   Center(
//                     child: Text(
//                       'Update Card Info',
//                       style: heading1TextStyle(context, width),
//                     ),
//                   ),
//                   textValueHeaderbelow,
//                   textValueBelow,
//                   Padding(
//                     padding: EdgeInsets.symmetric(
//                       horizontal: width * 0.08,
//                       vertical: width * 0.01,
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'Card Number',
//                           style: heading3TextStyle(width),
//                         ),
//                         TextFormField(
//                           autovalidateMode: AutovalidateMode.onUserInteraction,
//                           validator: (String? amount) {
//                             // if(password!.isEmpty){
//                             //   return 'Please Enter Password';
//                             // } else if (password!=passwordCotroller.text) {
//                             //   return 'Password doesn’t match :( Try again';
//                             // }
//                             // else{
//                             //   return null;
//                             // }
//                             return null;
//                           },
//                           style: heading2TextStyle(context, width),
//                           controller: cardNumberController,
//                           // obscureText: appConstants.passwordVissibleRegistration,
//                           keyboardType: TextInputType.number,
//                           decoration: InputDecoration(
//                             isDense: true,
//                           ),
//                         ),
//                         textValueHeaderbelow,
//                         Text(
//                           'Card holder name.',
//                           style: heading3TextStyle(width),
//                         ),
//                         TextFormField(
//                           autovalidateMode: AutovalidateMode.onUserInteraction,
//                           validator: (String? amount) {
//                             // if(password!.isEmpty){
//                             //   return 'Please Enter Password';
//                             // } else if (password!=passwordCotroller.text) {
//                             //   return 'Password doesn’t match :( Try again';
//                             // }
//                             // else{
//                             //   return null;
//                             // }
//                             return null;
//                           },
//                           style: heading2TextStyle(context, width),
//                           controller: cardHolderNameController,
//                           // obscureText: appConstants.passwordVissibleRegistration,
//                           keyboardType: TextInputType.name,
//                           decoration: InputDecoration(
//                             isDense: true,
//                           ),
//                         ),
//                         CustomSizedBox(height: height,),
//                         Row(
//                           children: [
//                             Expanded(
//                                     child: Padding(
//                                   padding:
//                                       const EdgeInsets.symmetric(horizontal: 2.0),
//                                   child: Column(
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         'Expiration Date',
//                                         style: heading3TextStyle(width),
//                                       ),
//                                       TextFormField(
//                                         // enabled: false,
//                                         readOnly: true,
//                                         autovalidateMode:
//                                             AutovalidateMode.onUserInteraction,
//                                             // obscureText: true,
//                                             // obscuringCharacter: '*',
//                                         onTap: ()async{
//                                           DateTime? dateTime = await showDatePicker(
//                                               context: context,
//                                               initialDate: DateTime.now(),
//                                               firstDate: DateTime(1950),
//                                               lastDate: DateTime.now(),
//                                               initialEntryMode: DatePickerEntryMode.calendar);
//                                           print('Selected date is: ${dateTime!.day}');
//                                           // ignore: unnecessary_null_comparison
//                                           if (dateTime != null) {
//                                           setState(() {
//                                             expireDate = dateTime;
//                                           });

//                                             appConstants.updateDateOfBirth('${dateTime.month} / ${dateTime.year}');
//                                             expireDateController.text = appConstants.dateOfBirth;
//                                           }
//                                         },
//                                         validator: (String? password) {
//                                           return null;

//                                           // if(password!.isEmpty){
//                                           //   return 'Please Enter Password';
//                                           // } else if (password!=passwordCotroller.text) {
//                                           //   return 'Password doesn’t match :( Try again';
//                                           // }
//                                           // else{
//                                           //   return null;
//                                           // }
//                                         },
//                                         maxLength: 8,
//                                         decoration: InputDecoration(
//                                           counterText: "",
//                                         ),
//                                         style: heading2TextStyle(context, width),
//                                         controller: expireDateController,
//                                         // obscureText: appConstants.passwordVissibleRegistration,
//                                         keyboardType: TextInputType.datetime,
//                                       ),
//                                     ],
//                                   ),
//                                 )),
//                             const SizedBox(
//                               width: 10,
//                             ),
//                             Expanded(
//                                 child: Padding(
//                               padding:
//                                   const EdgeInsets.symmetric(horizontal: 2.0),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       Text(
//                                         'Zip Code',
//                                         style: heading3TextStyle(width),
//                                       ),
//                                     ],
//                                   ),
//                                   TextFormField(
//                               autovalidateMode:
//                                   AutovalidateMode.onUserInteraction,
//                                   maxLength: 5,
//                               validator: (String? password) {
//                                 return null;

//                                 // if(password!.isEmpty){
//                                 //   return 'Please Enter Password';
//                                 // } else if (password!=passwordCotroller.text) {
//                                 //   return 'Password doesn’t match :( Try again';
//                                 // }
//                                 // else{
//                                 //   return null;
//                                 // }
//                               },

//                               decoration: InputDecoration(
//                                 counterText: ''
//                               ),
//                               style: heading2TextStyle(context, width),
//                               controller: zipCodeController,
//                               // obscureText: appConstants.passwordVissibleRegistration,
//                               keyboardType: TextInputType.number,
//                             ),
                                  
//                                 ],
//                               ),
//                             ))
//                           ],
//                         ),
//                         textValueHeaderbelow,
//                         Text(
//                                         'Security Code',
//                                         style: heading3TextStyle(width),
//                                       ),
//                         Row(
//                           children: [
//                             Expanded(
//                               child: TextFormField(
//                                     autovalidateMode:
//                                         AutovalidateMode.onUserInteraction,
//                                         maxLength: 5,
//                                     validator: (String? password) {
//                                       return null;

//                                       // if(password!.isEmpty){
//                                       //   return 'Please Enter Password';
//                                       // } else if (password!=passwordCotroller.text) {
//                                       //   return 'Password doesn’t match :( Try again';
//                                       // }
//                                       // else{
//                                       //   return null;
//                                       // }
//                                     },
//                                     obscureText: true,
//                                     decoration: InputDecoration(
//                                       counterText: ''
//                                     ),
//                                     style: heading2TextStyle(context, width),
//                                     controller: cvvController,
//                                     // obscureText: appConstants.passwordVissibleRegistration,
//                                     keyboardType: TextInputType.number,
//                                   ),
//                             ),
//                             Expanded(child: SizedBox(width: width*0.1,))
//                           ],
//                         ),
//                         textValueHeaderbelow,
//                         ZakiPrimaryButton(
//                             title: 'Update', 
//                             width: width, onPressed: () async{
//                               ApiServices().updateCardInfo(cardHolderName: cardHolderNameController.text.trim(), cardNumber: cardNumberController.text.trim(), expiryDate: expireDate, id: appConstants.userRegisteredId);
//                               Navigator.pop(context);
//                               showNotification(error: 0, icon: Icons.check, message: 'Updated Successfully');
//                             }),
//                         CustomTextButton(
//                             width: width,
//                             title: 'Delete Card',
//                             onPressed: () async{
//                               await ApiServices().deleteCard(id: appConstants.userRegisteredId);
//                               showNotification(error: 0, icon: Icons.check, message: 'Card Has Been Deleted');
//                               Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                           builder: (context) =>
//                                                ConfirmedScreen(
//                                                 amount: amountController.text.trim(), 
//                                                 // name: appConstants.userModel.usaUserName, 
//                                                 walletImageUrl: imageBaseAddress +'spending_act.png', 
//                                                 fromCreaditCardScreen: true,
//                                                 icon: Icons.delete,
//                                                 title: 'Card Deleted',
//                                                 color: red,
//                                                 )));
//                             },
//                             )
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         });
//   }
// }
