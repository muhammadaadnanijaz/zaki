import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:zaki/Constants/AppConstants.dart';

import '../Constants/HelperFunctions.dart';
import '../Constants/Styles.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {Key? key,
      required this.amountController,
      // required this.validator,
      this.onFieldSubmitted,
      this.onChanged,
      this.validator,
      this.readOnly,
      this.amountLimit,
      this.textFieldLimit,
      this.error,
      this.inputFormatter,
      this.hintText,
      this.onTap,
      this.textFieldColor
      })
      : super(key: key);

  final TextEditingController amountController;
  final String? Function(String?)? validator;
  final Function(String)? onFieldSubmitted;
  final Function(String)? onChanged;
  final Function()? onTap;
  final bool? readOnly;
  final double? amountLimit;
  final int? textFieldLimit;
  final String? error;
  final List<TextInputFormatter>? inputFormatter;
  final bool? hintText;
  final Color? textFieldColor;

  @override
  Widget build(BuildContext context) {
    var appConstants = Provider.of<AppConstants>(context, listen: true);
    // var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      inputFormatters:
          inputFormatter ?? [FilteringTextInputFormatter.digitsOnly],
      // validator: validator,
      validator: validator != null
          ? validator
          : (String? amount) {
              if (amount!.isEmpty) {
                return 'Please Enter Amount';
              } else if (double.parse(amount) >
                  (amountLimit != null ? amountLimit! : 500)) {
                return "Maximum ${getCurrencySymbol(context, appConstants: appConstants)}500";
              } else {
                return null;
              }
            },
      // style: TextStyle(color: primaryColor),
      style: heading3TextStyle(width, color: textFieldColor!=null? textFieldColor: green),
      readOnly: readOnly == true ? true : false,
      enabled: readOnly == true ? false : true,
      controller: amountController,
      obscureText: false,
      keyboardType: TextInputType.number,
      maxLines: 1,
      onTap: onTap ?? null,
      onChanged: onChanged == null ? null : onChanged,
      maxLength: textFieldLimit != null ? textFieldLimit : 3,
      // onChanged: onChanged==null?null:onChanged,
      onFieldSubmitted: onFieldSubmitted == null ? null : onFieldSubmitted,
      decoration: InputDecoration(
        hintText: hintText == false ? null : '0',
        counterText: '',
        errorText: error != null ? error : null,
        // isDense: true,
        prefixIcon: Padding(
          padding: const EdgeInsets.only(right: 6, top: 3),
          child: Text(
            "${getCurrencySymbol(context, appConstants: appConstants)}",
            style: heading4TextSmall(width),
          ),
        ),
        prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        hintStyle: heading3TextStyle(width, color: green),
        // labelText: 'Enter Email',
        // labelStyle: textStyleHeading2WithTheme(context,width*0.8, whiteColor: 0),
      ),
    );
  }
}
