import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zaki/Constants/HelperFunctions.dart';
import 'package:zaki/Screens/HomeScreen.dart';
import 'package:zaki/Widgets/TextHeader.dart';
import 'package:zaki/Widgets/ZakiPrimaryButton.dart';
import '../Constants/AppConstants.dart';
import '../Constants/Styles.dart';
import '../Screens/Socialize.dart';

// share_plus

class ConfirmedScreen extends StatefulWidget {
  final String? walletImageUrl;
  final String? amount;
  final String? name;
  final bool? fromCreaditCardScreen;
  final String? title;
  final IconData? icon;
  final Color? color;

  ConfirmedScreen(
      {Key? key,
      this.title,
      this.color,
      this.icon,
      this.walletImageUrl,
      this.amount,
      this.name,
      this.fromCreaditCardScreen})
      : super(key: key);

  @override
  _TransferDooneState createState() => _TransferDooneState();
}

class _TransferDooneState extends State<ConfirmedScreen> {
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
              widget.name == null
                  ? Column(
                      children: [
                        Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: widget.icon != null ? red : green),
                                  shape: BoxShape.circle),
                              child: CircleAvatar(
                                backgroundColor: transparent,
                                radius: width * 0.1,
                                child: widget.icon != null
                                    ? Icon(
                                        widget.icon,
                                        color:
                                            widget.icon != null ? red : green,
                                      )
                                    : Image.asset(
                                        widget.walletImageUrl.toString(),
                                        fit: BoxFit.cover),
                                // backgroundImage: AssetImage(
                                //   widget.walletImageUrl.toString(),
                                //   ),
                              ),
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
                          title: widget.title != null
                              ? widget.title
                              : 'Mission Accomplished!',
                        ),
                        SizedBox(
                          height: height * 0.005,
                        ),
                        if (widget.icon == null)
                          Text(
                            '${getCurrencySymbol(context, appConstants: appConstants)} ${widget.amount}',
                            style: heading2TextStyle(context, width),
                          ),
                        SizedBox(
                          height: height * 0.005,
                        ),
                        if (widget.fromCreaditCardScreen != true)
                          TextValue2(
                            title:
                                'Moved from Your ${appConstants.selectFromWallet} to ${appConstants.selectToWallet}',
                          ),
                      ],
                    )
                  : Text(
                      '${widget.name.toString().toUpperCase()} is now part of your family!',
                      style: heading1TextStyle(context, width),
                    ),
              SizedBox(
                height: height * 0.1,
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

// class CustomTextButton extends StatelessWidget {
//   const CustomTextButton(
//       {Key? key, required this.width, this.title, this.onPressed})
//       : super(key: key);

//   final double width;
//   final String? title;
//   final VoidCallback? onPressed;

//   @override
//   Widget build(BuildContext context) {
//     return TextButton(
//       child: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(2.0),
//           child: TextValue2(
//             title: '$title',
//           ),
//         ),
//       ),
//       style: ButtonStyle(
//         backgroundColor: MaterialStateProperty.all(transparent),
//         shape: MaterialStateProperty.all(RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(10.0),
//           // side: BorderSide(color: black),
//         )),
//       ),
//       onPressed: onPressed,
//     );
//   }
// }
