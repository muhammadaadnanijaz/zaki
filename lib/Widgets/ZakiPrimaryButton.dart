import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zaki/Constants/Styles.dart';

import '../Constants/AppConstants.dart';

class ZakiPrimaryButton extends StatelessWidget {
  const ZakiPrimaryButton( 
      {Key? key,
      this.width,
      this.title,
      this.selected,
      this.onPressed,
      this.icon,
      this.backgroundTransparent,
      this.rounded,
      this.backGroundColor,
      this.textColor,
      this.borderColor,
      this.textStyle
      })
      : super(key: key);

  final double? width;
  final String? title;
  final VoidCallback? onPressed;
  final int? selected;
  final int? rounded;
  final IconData? icon;
  final int? backgroundTransparent;
  final Color? backGroundColor;
  final Color? textColor;
  final Color? borderColor;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    var appConstants = Provider.of<AppConstants>(context, listen: false);
    return 
    
    ElevatedButton(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(9.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                icon!=null? Icon(icon, color: backgroundTransparent==1? green: white): const SizedBox(),
                icon!=null? SizedBox(width: width!*0.02,) : const SizedBox(), 
                FittedBox(
                  // fit: BoxFit.cover,
                    child: Text(
                      "$title",
                        style: textStyle!=null? textStyle: textStyleButtonTextMain(context, width!,
                            whiteColor: backgroundTransparent==1? 5 : 1,
                            color: textColor
                        )
                      ),
                    ),
              ],
            ),
          ),
        ),
        style: ElevatedButton.styleFrom(
            backgroundColor: backGroundColor !=null? backGroundColor : appConstants.themeId != 0
                ? yellow
                : 
                backgroundTransparent==1? white:
                selected == 1
                    ? grey
                    : primaryButtonColor,
            // side: BorderSide(
            //   width: 1,
            //   // color: selected == 1 ? grey : backgroundTransparent==1? grey: grey,
            // ),
            shape: RoundedRectangleBorder(
              side: BorderSide(color: borderColor==null? transparent: borderColor!, width: 0.7),
              borderRadius: BorderRadius.circular(rounded == 0 ? 0 : rounded == 1 ? 40 : 16),
            )
            //  shape: StadiumBorder()
            ),
        onPressed: onPressed);
  }
}
