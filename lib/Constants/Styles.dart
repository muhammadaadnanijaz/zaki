import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'AppConstants.dart';


String imageBaseAddress = 'assets/images/';

///White theme
Color white = Colors.white;
Color black = const Color(0XFF000000);
Color buttonColor = const Color(0XFFFFFF);
Color red = const Color(0XFFFF0000);
Color grey = Colors.grey;
Color darkGrey = const Color(0XFF404040);
Color lightGrey = const Color(0XFF77777B); 
Color borderColor = const Color(0XFFE7E7E7); 
Color transparent = Colors.transparent;
Color green = const Color(0XFF36B12E);
Color goalLightGreenColor = const Color(0XFFDCF8CC);
Color primaryButtonColor = green;
Color lightGreen = const Color(0XFF75D6A1);
Color yellow =  const Color(0XFFFFC700);
Color blue = const Color(0XFF102AA3);
Color lightBlue = const Color(0XFF197498);
Color purple = const Color(0XFF7412C1);
Color orange = const Color(0XFFFB5F02);
Color seconderySheetColor = const Color(0XFFff8404);
Color toDoBackgroundColor = const Color(0XFFF8FAFF);
Color crimsonColor = const Color(0XFFC9013B);



TextStyle textStyleHeading1WithTheme(BuildContext context, double width, {int? whiteColor, int? isUnderline, bool? bold}) {
 var appConstants = Provider.of<AppConstants>(context, listen: false);
  return GoogleFonts.lato(
      textStyle: TextStyle(
          color: (appConstants.themeId==0 && whiteColor==0)? black: whiteColor== 2? green : whiteColor== 6? orange :  (appConstants.themeId==0 && whiteColor==3)? purple: (appConstants.themeId==0 && whiteColor==4)? blue : (appConstants.themeId==0 && whiteColor==5)? grey : (appConstants.themeId==0 && whiteColor==7)? red : (appConstants.themeId==0 && whiteColor==8) ? orange : (appConstants.themeId==0 && whiteColor==9) ? crimsonColor: (appConstants.themeId==0 && whiteColor==10)? lightBlue: white ,
          // fontSize: bold==false? 21: 22,
          fontSize: width * 0.07,
          fontWeight: bold==false? FontWeight.w600 : FontWeight.w900,
          // letterSpacing: 0.3,
          decoration: whiteColor== 6? TextDecoration.lineThrough : TextDecoration.none
          )
  );
}
TextStyle textStyleGoals(BuildContext context, double width, {int? whiteColor, int? isUnderline }) {
 var appConstants = Provider.of<AppConstants>(context, listen: false);
  return GoogleFonts.lato(
      textStyle: TextStyle(
          color: (appConstants.themeId==0 && whiteColor==0)? black: whiteColor== 2? green : whiteColor== 6? orange :  (appConstants.themeId==0 && whiteColor==3)? purple: (appConstants.themeId==0 && whiteColor==4)? blue : (appConstants.themeId==0 && whiteColor==5)? grey : (appConstants.themeId==0 && whiteColor==7)? red : (appConstants.themeId==0 && whiteColor==8) ? orange : (appConstants.themeId==0 && whiteColor==9) ? crimsonColor: (appConstants.themeId==0 && whiteColor==10)? lightBlue: white ,
          fontSize: 16,
          //fontSize: width * 0.07,
          fontWeight: FontWeight.w900,
          // letterSpacing: 0.3,
          decoration: whiteColor== 6? TextDecoration.lineThrough : TextDecoration.none
          )
          );
}
TextStyle textStyleHeading2WithTheme(BuildContext context, double width, {int? whiteColor, double? font}) {
  var appConstants = Provider.of<AppConstants>(context, listen: false);
  return GoogleFonts.lato(
    
      textStyle: TextStyle(
    color: appConstants.themeId==0? whiteColor == 1
        ? white
        : whiteColor == 2 ? grey
            : whiteColor == 3
                ? red: whiteColor == 4
                ? yellow 
                : whiteColor == 5 ?
                 green : whiteColor == 6 ? purple: 
                 whiteColor == 8 ? blue:
                 whiteColor == 7 ? orange : whiteColor == 9 ? crimsonColor : black :  yellow,
    fontSize: font!=null? font: 14,
    // fontSize: width * 0.058,
    fontWeight: FontWeight.w500,
    // decoration: TextDecoration.underline
    
  ));
}

TextStyle textStyleButtonTextMain(BuildContext context, double width, {int? whiteColor, Color? color }) {
  // var appConstants = Provider.of<AppConstants>(context, listen: false);
  return GoogleFonts.lato(
    
      textStyle: TextStyle(
        shadows: [
                Shadow(
                  color: whiteColor == 1
        ? white
        : color!=null? color: buttonColor,
        offset: Offset(0, -3))
              ],
    color:transparent,
            
    fontSize: 18,
    // fontSize: width * 0.051,
    fontWeight: FontWeight.bold,
    decoration:
              TextDecoration.underline,
              decorationColor: color!=null? color: white,
              decorationThickness: 1,
              decorationStyle:
              TextDecorationStyle.solid,
    
  ));
}
TextStyle textStyleHeading2(BuildContext context,double width, {int? whiteColor, double? font, Color? color, bool? isLineThrough}) {
  return GoogleFonts.lato(
      textStyle: TextStyle(
    color: color!=null? color: whiteColor == 1
        ? white
        : whiteColor == 2
            ? grey
            : whiteColor == 3
                ? red: whiteColor == 4
                ? yellow
                : black,
    fontSize: font!=null? font: 16,
    //fontSize: width * 0.045,
    fontWeight: FontWeight.normal,
    decoration: (isLineThrough!=null && isLineThrough==true)
              ? TextDecoration.lineThrough
              : TextDecoration.none
  ));
}

TextStyle textStyleHeading1(context,double width, {int? whiteColor, int? isUnderline }) {
  return GoogleFonts.lato(
      textStyle: TextStyle(
          color: whiteColor == 1 ? white : whiteColor == 2? grey : black,
          fontSize: 20,
          //fontSize: width * 0.054,
          fontWeight: FontWeight.bold,
          decoration: isUnderline == 1
              ? TextDecoration.underline
              : TextDecoration.none));
}



TextStyle appBarTextStyle(BuildContext context, double width, {Color? color}) {
  // var appConstants = Provider.of<AppConstants>(context, listen: false);
  return GoogleFonts.lato(
      textStyle: TextStyle(
    color: color!=null? color: black,
    // fontSize: 22,
    fontSize: width * 0.062,
    fontWeight: FontWeight.w600,
  ));
}

TextStyle heading1TextStyle(BuildContext context, double width,{ Color? color, double? font}) {
  // var appConstants = Provider.of<AppConstants>(context, listen: false);
  return GoogleFonts.lato(
      textStyle: TextStyle(
    color: color!=null ? color : darkGrey,
    // fontSize: font!=null? font: 16,
    fontSize: font!=null? font: width*0.045,
    fontWeight: FontWeight.w700,
  ));
}

TextStyle heading2TextStyle(BuildContext context, double width, {Color? color, double? font}) {
  // var appConstants = Provider.of<AppConstants>(context, listen: false);
  return GoogleFonts.lato(
      textStyle: TextStyle(
    color: color!=null? color: green,
    // fontSize: font!=null? font : 15,
    fontSize: font!=null? font : width*0.0413,
    fontWeight: FontWeight.w400,
  ));
}

TextStyle heading3TextStyle(double width, {Color? color, double? font, bool? underLine, bool? bold}) {
  // var appConstants = Provider.of<AppConstants>(context, listen: false);
  return GoogleFonts.lato(
      textStyle: TextStyle(
    color: color!=null? color: darkGrey,
    // fontSize: font!=null? font : 15,
    fontSize: font!=null? font : width*0.0413,
    fontWeight: bold!=null? FontWeight.bold: FontWeight.w400,
    // shadows: underLine!=true? null:[
    //   Shadow(
    //     color: green,
    //                 offset: Offset(0, -3))
    //           ],
    decoration: underLine==true ? TextDecoration.underline: TextDecoration.none
  ));
}

TextStyle heading4TextSmall(double width, {Color? color, bool? underline}) {
  // var appConstants = Provider.of<AppConstants>(context, listen: false);
  return GoogleFonts.lato(
      textStyle: TextStyle(
    color: color!=null? color: lightGrey,
    // fontSize: 12,
    fontSize: width*0.035,
    fontWeight: FontWeight.normal,
    decoration: underline==true? TextDecoration.underline : TextDecoration.none
  ));
}
TextStyle heading5TextSmall(double width, {double? font, bool? bold, Color? color}) {
  // var appConstants = Provider.of<AppConstants>(context, listen: false);
  return GoogleFonts.lato(
      textStyle: TextStyle(
    color: color?? black,
    // fontSize: font!=null?font: 10,
    fontSize: width*0.03,
    fontWeight: bold==false? null: FontWeight.bold,
  ));
}

// TextStyle heading5ButtonLarge(double width) {
//   // var appConstants = Provider.of<AppConstants>(context, listen: false);
//   return GoogleFonts.lato(
//       textStyle: TextStyle(
//     color: white,
//     // fontSize: 12,
//     fontSize: width*0.058,
//     fontWeight: FontWeight.bold,
//   ));
// }
// TextStyle heading5ButtonSmall(double width) {
//   // var appConstants = Provider.of<AppConstants>(context, listen: false);
//   return GoogleFonts.lato(
//       textStyle: TextStyle(
//     color: darkGrey,
//     // fontSize: 12,
//     fontSize: width*0.035,
//     fontWeight: FontWeight.normal,
//   ));
// }



void showSnackBarDialog({String? message, BuildContext? context}) {
  ScaffoldMessenger.of(context!)
      .showSnackBar(SnackBar(content: Text(message!)));
}

// showNotification({IconData? icon, String? title, required bool isSuccess}){
//   showSimpleNotification(Text('$title'),
//         leading: Icon(icon),
//         position: isSuccess? NotificationPosition.top: NotificationPosition.bottom,
//         background: isSuccess? Colors.green: Colors.red);
// }
dynamic deleteDialog(BuildContext context, String id, String imageUrl) async {
  // flutter defined function
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
        title: const Text("Select Gender"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              onTap: () {
                Navigator.pop(context, 'Male');
              },
              title: const Text('Male'),
            ),
            ListTile(
              onTap: () {
                Navigator.pop(context, 'Fe Male');
              },
              title: const Text('Fe Male'),
            )
          ],
        ),
        actions: <Widget>[
          // usually buttons at the bottom of the dialog
          TextButton(
            child: const Text(
              "Delete",
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () {
              // ApiService().deleteProduct(id, imageUrl);
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text("Cancel"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

////////////////////////////////////






  
