import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zaki/Constants/AppConstants.dart';
import 'package:zaki/Constants/Spacing.dart';
import 'package:zaki/Constants/Styles.dart';
import 'package:zaki/Services/api.dart';

class SecondaryUserScreen extends StatefulWidget {
  const SecondaryUserScreen({Key? key}) : super(key: key);

  @override
  State<SecondaryUserScreen> createState() => _SecondaryUserScreenState();
}

class _SecondaryUserScreenState extends State<SecondaryUserScreen> {
  String? parentName;

  @override
  void initState() {
    Future.delayed(Duration(seconds: 1), ()async{
      var appConstants = Provider.of<AppConstants>(context, listen: false);
      parentName = await ApiServices().getParentName(parentId: appConstants.userModel.userFamilyId);
      setState(() {
        
      });
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var appConstants = Provider.of<AppConstants>(context, listen: true);
    // var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Container(
      // color: orange,
      child: Column(
        children: [
          Center(child: Image.asset(imageBaseAddress+'secondaryUser.png')),
          spacing_medium,
          appConstants.userModel.subscriptionExpired==true?
          Column(
            children: [
              Text(
                'Your Subscription Expired 😢',
                style: heading1TextStyle(context, width, color: white),
                textAlign: TextAlign.center,
              ),
              spacing_medium,
              Text(
            'Talk to “${parentName??'⏳'}” to renew it!',
            style: heading2TextStyle(context, width, color: white),
            textAlign: TextAlign.center,
            ),
              // 
            ],
          ):
          Column(
            children: [
              Text(
            'This users account is not fully set up yet!',
            style: heading1TextStyle(context, width, color: white),
            textAlign: TextAlign.center,
            ),
          spacing_medium,
          Text(
            'Next Steps: ',
            style: heading1TextStyle(context, width, color: white),
            textAlign: TextAlign.center,
            ),
          spacing_medium,
          Text(
            'Talk To “${parentName??'⏳'}” to complete account setup,',
            style: heading2TextStyle(context, width, color: white),
            textAlign: TextAlign.center,
            ),
            ],
          ),
          
          
        ],
      ),
    );
  }
}