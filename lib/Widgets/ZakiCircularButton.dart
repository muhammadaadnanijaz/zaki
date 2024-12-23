import 'package:flutter/material.dart';
import 'package:zaki/Constants/Styles.dart';

class ZakiCicularButton extends StatelessWidget {
  const ZakiCicularButton(
      {Key? key,
      this.width,
      this.title,
      this.selected,
      this.onPressed,
      this.icon,
      this.iconColor,
      this.iconSize,
      this.backGroundColor,
      this.textColor,
      this.border,
      this.textStyle,
      this.borderColor
      })
      : super(key: key);

  final double? width;
  final double? iconSize;
  final Color? backGroundColor;
  final Color? borderColor;
  final String? title;
  final VoidCallback? onPressed;
  final int? selected;
  final IconData? icon;
  final Color? iconColor;
  final Color? textColor;
  final bool? border;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    // var appConstants = Provider.of<AppConstants>(context, listen: false);
    return 
    
    InkWell(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: backGroundColor!=null? backGroundColor: selected == 3 ? white:null,
          border: border==false?null: Border.all(width: 1,
                color: borderColor!=null? borderColor! : selected == 1 ? grey : selected == 2 ? purple : selected == 3 ? orange : selected == 4 ? blue : selected == 5 ? black : selected == 6 ? crimsonColor:  green,
                ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                icon!=null? Padding(
                  padding: const EdgeInsets.only(right: 2.0),
                  child: Icon(icon, color: iconColor!=null? iconColor: selected==2? purple :selected == 4 ? blue: selected == 3 ? orange : green , size: iconSize!=null? iconSize: width!*0.07,),
                ): const SizedBox(),
                // icon!=null? SizedBox(width: width!*0.01,) : const SizedBox(), 
                if(title!=null)
                Text(
                  "$title",
                    style: textStyle!=null? textStyle: textStyleHeading2WithTheme(context, width!*0.8,
                        whiteColor: selected == 2 ? 6: selected == 3 ? 7 :selected == 4 ? 8:selected == 5 ? 0 : selected == 6 ? 9 : 5)
                        ),
              ],
            ),
          ),
      ),
    );
  }
}
