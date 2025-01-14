import 'dart:io';

import 'package:esys_flutter_share_plus/esys_flutter_share_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:zaki/Constants/HelperFunctions.dart';
import 'package:zaki/Constants/Spacing.dart';
import 'package:zaki/Constants/Styles.dart';
import 'package:zaki/Widgets/TextHeader.dart';
import 'package:screenshot/screenshot.dart';
import '../Constants/AppConstants.dart';
import '../Widgets/UserInfoForGoals.dart';

class TransactionDetail extends StatefulWidget {
  const TransactionDetail({Key? key}) : super(key: key);

  @override
  State<TransactionDetail> createState() => _TransactionDetailState();
}

class _TransactionDetailState extends State<TransactionDetail> {
  Uint8List? _imageFile;

  //Create an instance of ScreenshotController
  ScreenshotController screenshotController = ScreenshotController();
  @override
  Widget build(BuildContext context) {
    var appConstants = Provider.of<AppConstants>(context, listen: true);
    // var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        // backgroundColor: Color(0XFFF4F4F4),
        body: SingleChildScrollView(
          child: Padding(
            padding: getCustomPadding(),
            child: Column(
              children: [
                // appBarHeader_005(
                //           width: width,
                //           height: height,
                //           context: context,
                //           appBarTitle: 'Activity Detail',
                //           backArrow: false,
                //           leadingIcon: true),
                spacing_medium,
                Screenshot(
              controller: screenshotController,
                  child: Column(
                    children: [
                      Card(
                        shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: grey.withValues(alpha:0.5))
                        //set border radius more than 50% of height and width to make circle
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // spacing_medium,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  padding: EdgeInsets.zero,
                                  visualDensity: VisualDensity.compact,
                icon: Icon(Icons.share),
                onPressed: (){
                  screenshotController.capture().then((Uint8List? image) async{
                      //Capture Done
                      
                        Directory tempDir = await getTemporaryDirectory();
            
            // Save the image as a file
            // ignore: unused_local_variable
            File imageFile = image==null? File(''): await File('${tempDir.path}/image.jpg').writeAsBytes(image);
            setState(() {
                          _imageFile = image;
                      });
                    await Share.file('Share My Image', 'image.png',
                                _imageFile!, 'image/png',
                                text:'${appConstants.userModel.usaFirstName} Shared an activity from ZakiPay. Download Zakipay and raise Money Smart Kids!');
                  }).catchError((onError) {
                      print(onError);
                  });
                }, 
                ),
                              ],
                            ),
                            SizedBox(width: width,),
                            Image.asset(
                              imageBaseAddress+"header_zakipay_real.png",
                              width: width*0.4,
                            ),
                            spacing_small,
                            // spacing_small,
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: appConstants.transactionDetailModel.amount!.contains('+')? green: black
                                )
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  formatCurrencyStringWithSpace( '${(appConstants.transactionDetailModel.amount)}'),
                                  style: heading1TextStyle(context, width+width*0.5, color: appConstants.transactionDetailModel.amount!.contains('+')? green:null ),
                                ),
                              ),
                              
                            ),
                            spacing_medium,
                            UserInfoForGoals(
                                        userId: appConstants.transactionDetailModel.userId,
                                        fromTransactionDetailPage: true,
                                        ),
                            spacing_medium,
                            Text(
                              'When: '+ appConstants.transactionDetailModel.transactionDate!.split('-')[0],
                              style: heading4TextSmall(width),
                              )
                          ],
                        ),
                      ),
                                  ),
                    spacing_medium,
                              Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: grey.withValues(alpha:0.5))
                      //set border radius more than 50% of height and width to make circle
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          spacing_medium,
                          TextHeader1(title: 'Additional Details:'),
                          spacing_large,
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [ 
                              TextValue2(title: 'Activity Type:'),
                              
                              TextValue2(title: appConstants.transactionDetailModel.transactionType),
                            ],
                          ),
                          spacing_medium,
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextValue2(title: 'Activity Method:'),
                              Text(
                                appConstants.transactionDetailModel.transactionMethod.toString(),
                              style: heading3TextStyle(width, color: appConstants.transactionDetailModel.amount!.contains('+')? green: null),
                              )
                              // TextValue2(title: ),
                            ],
                          ),
                          spacing_medium,
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextValue2(title: 'Tag It:'),
                              TextValue2(title: appConstants.transactionDetailModel.tagItName=='-2'? AppConstants.tagItList[13].title : appConstants.transactionDetailModel.tagItName),
                        //   spacing_large,
                        //   Container(
                        //   height: height * 0.06,
                        //   width: height * 0.06,
                        //   decoration: BoxDecoration(
                        //       shape: BoxShape.circle,
                        //       color: white,
                        //       border: Border.all(color: orange)
                        //     ),
                        //   child: Icon(
                        //     appConstants.transactionDetailModel.tagItIcon,
                        //     color: orange,
                        //   ),
                        // ),
                            ],
                          ),
                          spacing_medium,
                           Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextValue2(title: 'Wallet Name:'),
                              TextValue2(title: appConstants.transactionDetailModel.walletName),
                            ],
                          ),
                          spacing_medium,
                          
                          
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextValue2(title: 'Activity Time:'),
                              TextValue2(title: "${addAmOrPm(appConstants.transactionDetailModel.transactionDate!, appConstants)}"),
                            ],
                          ),
                          spacing_medium,
                          
                          if( appConstants.transactionDetailModel.transactionMessage!=null && appConstants.transactionDetailModel.transactionMessage!.isNotEmpty)
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  TextValue2(title: appConstants.transactionDetailModel.transactionType=='Goals'? 'Goals Title:' : 'Message:'),
                                  TextValue2(title: appConstants.transactionDetailModel.transactionMessage),
                                ],
                              ),
                              spacing_medium,
                            ],
                          ),
                          
                         
                          // spacing_medium,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextValue2(title: 'Activity Id:'),
                              Expanded(
                                child: Text('${appConstants.transactionDetailModel.transactionId}', textAlign: TextAlign.right,)
                                ),
                            ],
                          ),
                          spacing_medium,
                          if(appConstants.transactionDetailModel.transactionLatLang!=null||appConstants.transactionDetailModel.transactionLatLang!=''||appConstants.transactionDetailModel.transactionLatLang!.length.toString()=='0')
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextValue2(title: 'Location:'),
                              TransactionCountry(latLang: "${appConstants.transactionDetailModel.transactionLatLang}"),
                              // Expanded(
                              //   child: Text('${getAddressFromCoordinates(latlung: "${appConstants.transactionDetailModel.transactionLatLang}")}', textAlign: TextAlign.right,)
                              //   ),
                            ],
                          ),
                          spacing_medium,
                        ],
                      ),
                    ),
                  )
                    ],
                  ),
                ),
              spacing_medium,
              
             
              // if(_imageFile!=null)
              // Image.memory(_imageFile!)
              ],
            ),
          ),
        ),
      ),
    );
  }
  addAmOrPm(String dateTime, AppConstants appConstants){
    // appConstants.transactionDetailModel.fullDate;
    // return dateTime;
    return DateFormat('hh:mm a').format(appConstants.transactionDetailModel.fullDate!);
  }
}

class TransactionCountry extends StatelessWidget {
  final String latLang;

  TransactionCountry({required this.latLang});

  Future<Placemark?> getAddressFromCoordinates(String latLang) async {
    logMethod(title: 'Lant, lang inside new Widget', message: latLang.toString());
    if (latLang.length.toString()=='0' || latLang=="null") {
      return null;
    }
    // Assuming latLang is a string of "latitude,longitude"
    List<String> coordinates = latLang.split(',');
    double latitude = double.parse(coordinates[0]);
    double longitude = double.parse(coordinates[1]);

    List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
    if (placemarks.isNotEmpty) {
      return placemarks[0];
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FutureBuilder<Placemark?>(
        future: getAddressFromCoordinates(latLang),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text('Loading...', textAlign: TextAlign.right);
          } else if (snapshot.hasError) {
            return SizedBox.shrink();
          } else if (snapshot.hasData) {
            final placemark = snapshot.data;
            if (placemark != null) {
              return Text(
                '${placemark.locality}, ${placemark.country}',
                textAlign: TextAlign.right,
              );
            } else {
              return Text('No address found', textAlign: TextAlign.right);
            }
          } else {
            return Text('No address found', textAlign: TextAlign.right);
          }
        },
      ),
    );
  }
}
