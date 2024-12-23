import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zaki/Constants/HelperFunctions.dart';
import 'package:zaki/Screens/HomeScreen.dart';
import 'package:zaki/Widgets/TextHeader.dart';
import 'package:zaki/Widgets/ZakiPrimaryButton.dart';
import '../Constants/AppConstants.dart';
import '../Constants/Styles.dart';
import 'Socialize.dart';

class TransferDoone extends StatefulWidget {
  const TransferDoone({Key? key}) : super(key: key);

  @override
  _TransferDooneState createState() => _TransferDooneState();
}

class _TransferDooneState extends State<TransferDoone> {
  @override
  Widget build(BuildContext context) {
    var appConstants = Provider.of<AppConstants>(context, listen: true);
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 0),
          child: Column(
            children: [
              SizedBox(
                width: width,
              ),
              SizedBox(
                height: height * 0.3,
              ),
              Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: green),
                        shape: BoxShape.circle),
                    child: CircleAvatar(
                        backgroundColor: grey,
                        radius: width * 0.095,
                        child: userImage(
                          imageUrl:
                              appConstants.payRequestModel.selectedKidImageUrl,
                          userType:
                              appConstants.payRequestModel.receiverUserType,
                          width: width,
                          gender: appConstants.payRequestModel.receiverGender,
                        )),
                  ),
                  Positioned(
                    top: 2,
                    right: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Icon(
                        Icons.check_circle,
                        color: green,
                        size: width * 0.05,
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: height * 0.02,
              ),
              TextHeader1(
                title: 'Mission Accomplished!',
              ),
              SizedBox(
                height: height * 0.005,
              ),
              TextValue2(
                title: appConstants.payRequestModel.selectedKidName.toString(),
              ),
              SizedBox(
                height: height * 0.005,
              ),
              TextValue3(
                title:
                    '${getCurrencySymbol(context, appConstants: appConstants)} ${appConstants.payRequestModel.amount}',
              ),
              SizedBox(
                height: height * 0.12,
              ),
              ZakiPrimaryButton(
                title: 'Manage My Spending',
                width: width,
                onPressed: () {},
              ),
              SizedBox(
                height: height * 0.01,
              ),
              ZakiPrimaryButton(
                title: 'Friends Activities',
                width: width,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AllActivities()));
                },
              ),
              SizedBox(
                height: height * 0.01,
              ),
              ZakiPrimaryButton(
                title: 'Home',
                width: width,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => HomeScreen()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
