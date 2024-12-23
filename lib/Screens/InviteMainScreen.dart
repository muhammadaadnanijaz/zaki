// ignore_for_file: file_names, deprecated_member_use
import 'package:flutter/material.dart';
import 'package:zaki/Constants/Spacing.dart';
import 'package:zaki/Screens/GetContacts.dart';
import 'package:zaki/Screens/ZPayContacts.dart';
import 'package:zaki/Widgets/AppBars/AppBar.dart';

class InviteMainScreen extends StatefulWidget {
  final bool? fromHomeScreen;
  const InviteMainScreen({Key? key, this.fromHomeScreen}) : super(key: key);

  @override
  _InviteMainScreenState createState() => _InviteMainScreenState();
}

class _InviteMainScreenState extends State<InviteMainScreen> {
  late PageController _pageController;
  int selectedIndex = 0;

  @override
  void initState() {
    _pageController = PageController(initialPage: selectedIndex);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // var appConstants = Provider.of<AppConstants>(context, listen: true);
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        // widget.fromHomeScreen==null?
          return widget.fromHomeScreen==null? false:true;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Padding(
            padding: getCustomPadding(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                appBarHeader_005(
                    context: context,
                    appBarTitle: 'Invite Friends & Family',
                    height: height,
                    width: width,
                    fromInviteScreen:
                        widget.fromHomeScreen == null ? 
                        true : 
                        false,
                    leadingIcon: widget.fromHomeScreen == true ? true : false),
                // Row(
                //     children: [
                //       Expanded(
                //         child: Padding(
                //           padding: const EdgeInsets.symmetric(horizontal: 4.0),
                //           child: ZakiPrimaryButton(
                //           onPressed: (){
                //             if (selectedIndex==1) {
                //             selectedIndex = selectedIndex-1;
                //             setState(() {
                //             _pageController.jumpToPage(selectedIndex);
                //             });
    
                //             }
    
                //           },
                //           title: 'Phone Contacts',
                //           selected: selectedIndex==0?0:1,
                //           width: width,
                //           ),
                //         ),
                //       ),
                //      Expanded(
                //         child: Padding(
                //           padding: const EdgeInsets.symmetric(horizontal: 4.0),
                //           child: ZakiPrimaryButton(
                //           onPressed: (){
                //             if (selectedIndex==0) {
                //             selectedIndex = selectedIndex+1;
                //             setState(() {
                //             _pageController.jumpToPage(selectedIndex);
                //             });
    
                //             }
    
                //           },
                //           selected: selectedIndex==0?1:0,
                //           title: 'Zpay',
                //           width: width,
                //           ),
                //         ),
                //     ),
                //     ],
                //   ),
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (index) {},
                    physics: const NeverScrollableScrollPhysics(),
                    children: const [GetContacts(), ZPayContacts()],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
