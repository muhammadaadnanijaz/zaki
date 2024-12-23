import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Constants/HelperFunctions.dart';
import '../Constants/Styles.dart';
import '../Widgets/AppBars/AppBar.dart';
import '../Widgets/CustomSizedBox.dart';
import '../Widgets/ZakiPrimaryButton.dart';

class RequestDebitCard extends StatefulWidget {
  const RequestDebitCard({ Key? key, }) : super(key: key);

  @override
  State<RequestDebitCard> createState() => _RequestDebitCardState();
}

class _RequestDebitCardState extends State<RequestDebitCard> {
    final formGlobalKey = GlobalKey<FormState>();
  final zipCodeController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final streetAddressController = TextEditingController();
  final appartOrSuitController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    // var appConstants = Provider.of<AppConstants>(context, listen: true);
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8),
            child: Column(
              children: [
                appBarHeader_005(
                            context: context, 
                            appBarTitle: 'Request a ZakiPay Physical Card', 
                            backArrow: true, 
                            height: height, 
                            width: width, 
                            leadingIcon: true),
                Image.asset(imageBaseAddress+"mainwallet.png"),
                TextFormField(
                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                      // readOnly:   true: false,
                                      enabled:    true,
                                      validator:    (String? name) {
                                        if (name!.isEmpty) {
                                          return 'Enter a Street Address';
                                        } else {
                                          return null;
                                        }
                                      },
                                      // style: TextStyle(color: primaryColor),
                                      style: heading2TextStyle(
                                          context, width),
                                      controller: streetAddressController,
                                      obscureText: false,
                                      keyboardType: TextInputType.streetAddress,
                                      maxLines: 1,
                                      decoration: InputDecoration(
                                        hintText: 'Street Address',
                                        hintStyle: heading2TextStyle(
                                          context, width),
                                      ),
                                    ),
                          CustomSizedBox(height: height),
                          TextFormField(
                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                      // readOnly:   true: false,
                                      enabled:    true,
                                      validator:    (String? name) {
                                        if (name!.isEmpty) {
                                          return 'Enter a Street Adress';
                                        } else {
                                          return null;
                                        }
                                      },
                                      // style: TextStyle(color: primaryColor),
                                      style: heading2TextStyle(context, width),
                                      controller: appartOrSuitController,
                                      obscureText: false,
                                      keyboardType: TextInputType.name,
                                      maxLines: 1,
                                      decoration: InputDecoration(
                                        hintText: 'Apartment or Suite (Optional)',
                                        hintStyle: heading2TextStyle(context, width),
                                      ),
                                    ),
                          CustomSizedBox(height: height),
                          TextFormField(
                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                      // readOnly:   true: false,
                                      enabled:    true,
                                      validator:    (String? name) {
                                        if (name!.isEmpty) {
                                          return 'Enter a City Name';
                                        } else {
                                          return null;
                                        }
                                      },
                                      // style: TextStyle(color: primaryColor),
                                      style: heading2TextStyle(context, width),
                                      controller: cityController,
                                      obscureText: false,
                                      keyboardType: TextInputType.name,
                                      maxLines: 1,
                                      decoration: InputDecoration(
                                        hintText: 'City',
                                        hintStyle: heading2TextStyle(
                                          context, width),
                                      ),
                                    ),
                          CustomSizedBox(height: height),
                          TextFormField(
                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                      // readOnly:   true: false,
                                      enabled:    true,
                                      validator:    (String? name) {
                                        if (name!.isEmpty) {
                                          return 'Enter a State';
                                        } else {
                                          return null;
                                        }
                                      },
                                      // style: TextStyle(color: primaryColor),
                                      style: heading2TextStyle(context, width),
                                      controller: stateController,
                                      obscureText: false,
                                      keyboardType: TextInputType.name,
                                      maxLines: 1,
                                      decoration: InputDecoration(
                                        hintText: 'State',
                                        hintStyle: heading2TextStyle(
                                          context, width),
                                      ),
                                    ),
                          CustomSizedBox(height: height,),
                          TextFormField(
                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                      // readOnly:   true: false,
                                      enabled:    true,
                                      inputFormatters: [
                                              FilteringTextInputFormatter.digitsOnly
                                        ],
                                      validator:    (String? name) {
                                        if (name!.isEmpty) {
                                          return 'Enter Zip Code';
                                        } else {
                                          return null;
                                        }
                                      },
                                      // style: TextStyle(color: primaryColor),
                                      style: heading2TextStyle(context, width),
                                      controller: zipCodeController,
                                      obscureText: false,
                                      keyboardType: TextInputType.number,
                                      maxLines: 1,
                                      decoration: InputDecoration(
                                        hintText: 'Enter Zip Code',
                                        hintStyle: heading2TextStyle(
                                          context, width),
                                      ),
                                    ),
                          
                          CustomSizedBox(height: height),
                          
                                SizedBox(
                            height: height*0.02,
                          ),
                      ZakiPrimaryButton(
                        title: 'Request Now',
                        width: width,
                        onPressed:() async{
                          showNotification(error: 0, icon: Icons.check, message: 'Caard assigned successfully');
                              Future.delayed(Duration(seconds: 2), (){
                              Navigator.pop(context, "success");
                              });
                            },
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }
}