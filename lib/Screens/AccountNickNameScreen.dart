import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zaki/Constants/Spacing.dart';
import 'package:zaki/Services/api.dart';
import 'package:zaki/Widgets/ZakiPrimaryButton.dart';
import '../Constants/AppConstants.dart'; 
import '../Constants/Styles.dart';
import '../Models/NickNameModel.dart';
import '../Widgets/AppBars/AppBar.dart';
import '../Widgets/CustomConfermationScreen.dart';

class AccountNickNameScreen extends StatefulWidget {
  const AccountNickNameScreen({Key? key}) : super(key: key);

  @override
  State<AccountNickNameScreen> createState() => _AccountNickNameScreenState();
}

class _AccountNickNameScreenState extends State<AccountNickNameScreen> {
  final spendWalletController = TextEditingController();
  final savingsWalletController = TextEditingController();
  final donationsWalletController = TextEditingController();
  final topFriendsWalletController = TextEditingController();
  @override
  void initState() {
    super.initState();
    getUserNickNames();
  }

  getUserNickNames() {
    Future.delayed(Duration.zero, () async {
      var appConstants = Provider.of<AppConstants>(context, listen: false);
      NickNameModel? userModel = await ApiServices().getNickNames(
          context: context, userId: appConstants.userRegisteredId);

      //  Future.delayed(Duration(milliseconds: 100), ()async{
      if (userModel != null) {
        await setNickNames(
            donations: userModel.NickN_DonationWallet,
            savings: userModel.NickN_SavingWallet,
            spending: userModel.NickN_SpendWallet,
            topFriends: userModel.NickN_TopFriends);
      } else {
        appConstants.updateNickNameModel(NickNameModel());
      }

      //  });
      // setNickNames();
    });
  }

  Future<void> setNickNames(
      {String? spending,
      String? savings,
      String? donations,
      String? topFriends}) async {
    spendWalletController.text = spending!;
    savingsWalletController.text = savings!;
    donationsWalletController.text = donations!;
    topFriendsWalletController.text = topFriends!;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var appConstants = Provider.of<AppConstants>(context, listen: true);
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: getCustomPadding(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                appBarHeader_005(
                        context: context, 
                        appBarTitle: 'Nick Names', 
                        backArrow: false, 
                        height: height, 
                        width: width, 
                        leadingIcon: true),
                spacing_medium,
                Image.asset(imageBaseAddress+'change_nick_name.png'),
                spacing_medium,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('Spend Wallet:',
                      style: heading3TextStyle( width),
                    ),
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SizedBox(
                            width: width * 0.122,
                          ),
                          Expanded(
                            child: TextFormField(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (String? name) {
                                // if(name!.isEmpty){
                                //   return 'Please Enter Goal';
                                // }
                                // else{
                                return null;
                                // }
                              },
                              // style: TextStyle(color: primaryColor),
                              style: heading2TextStyle(context, width),
                              controller: spendWalletController,
                              obscureText: false,
                              keyboardType: TextInputType.name,
                              maxLines: 1,maxLength: 10,
                              
                              decoration: InputDecoration(
                                counterText: "",
                                isDense: true,
                                hintText: 'Spend',
                                hintStyle: heading2TextStyle(context, width),
                                // labelText: 'My Name is',
                                // labelStyle: textStyleHeading2WithTheme(context,width*0.8, whiteColor: 2),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Wallet',
                            style: heading3TextStyle( width),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                spacing_medium,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Savings Wallet:',
                      style: heading3TextStyle(width),
                    ),
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SizedBox(
                            width: width * 0.1,
                          ),
                          Expanded(
                            child: TextFormField(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (String? name) {
                                // if(name!.isEmpty){
                                //   return 'Please Enter Goal';
                                // }
                                // else{
                                return null;
                                // }
                              },
                              // style: TextStyle(color: primaryColor),
                              style: heading2TextStyle(context, width),
                              controller: savingsWalletController,
                              obscureText: false,
                              keyboardType: TextInputType.name,
                              maxLines: 1,maxLength: 10,
                              decoration: InputDecoration(
                                counterText: "",
                                isDense: true,
                                hintText: 'Savings',
                                hintStyle: heading2TextStyle(context, width),
                                // labelText: 'My Name is',
                                // labelStyle: textStyleHeading2WithTheme(context,width*0.8, whiteColor: 2),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Wallet',
                            style: heading3TextStyle( width),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                spacing_medium,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                       'Charity Wallet:',
                      style: heading3TextStyle( width),
                    ),
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SizedBox(
                            width: width * 0.09,
                          ),
                          Expanded(
                            child: TextFormField(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (String? name) {
                                // if(name!.isEmpty){
                                //   return 'Please Enter Goal';
                                // }
                                // else{
                                return null;
                                // }
                              },
                              // style: TextStyle(color: primaryColor),
                              style: heading2TextStyle(context, width),
                              controller: donationsWalletController,
                              obscureText: false,
                              keyboardType: TextInputType.name,
                              maxLines: 1,maxLength: 10,
                              decoration: InputDecoration(
                                counterText: "",
                                isDense: true,
                                hintText: 'Charity',
                                hintStyle: heading2TextStyle(context, width),
                                // labelText: 'My Name is',
                                // labelStyle: textStyleHeading2WithTheme(context,width*0.8, whiteColor: 2),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Wallet',
                            style: heading3TextStyle( width),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
               spacing_medium,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('Favorites:',
                      style: heading3TextStyle( width),
                    ),
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SizedBox(
                            width: width * 0.2,
                          ),
                          Expanded(
                            child: TextFormField(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (String? name) {
                                // if(name!.isEmpty){
                                //   return 'Please Enter Goal';
                                // }
                                // else{
                                return null;
                                // }
                              },
                              // style: TextStyle(color: primaryColor),
                              style: heading2TextStyle(context, width),
                              controller: topFriendsWalletController,
                              obscureText: false,
                              keyboardType: TextInputType.name,
                              maxLines: 1,maxLength: 10,
                              decoration: InputDecoration(
                                counterText: "",
                                isDense: true,
                                hintText: 'Favorites',
                                hintStyle: heading2TextStyle(context, width),
                                // labelText: 'My Name is',
                                // labelStyle: textStyleHeading2WithTheme(context,width*0.8, whiteColor: 2),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            '              ',
                            style: heading3TextStyle( width),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                spacing_medium,
                ZakiPrimaryButton(
                  title: 'Save',
                  width: width,
                  onPressed: () async {
                    ApiServices services = ApiServices();
                    await services.setNickNames(
                        kidId: appConstants.userRegisteredId,
                        DonationWallet_Name: donationsWalletController.text,
                        SavingWallet_Name: savingsWalletController.text,
                        SpendWallet_Name: spendWalletController.text,
                        TopFriends_Name: topFriendsWalletController.text,
                        createdAt: DateTime.now());

                    getUserNickNames();
                    Future.delayed(const Duration(
                      milliseconds: 800,
                    ),(){
                       Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CustomConfermationScreen(
                            subTitle: "Nick name has been changed",
                                                // title: 'Mission Accomplished!',
                                                
                                                // imageUrl: appConstants.payRequestModel.selectedKidImageUrl,
                                            )));
                    });
                    
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
