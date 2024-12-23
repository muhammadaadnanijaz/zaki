import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../Constants/Styles.dart';

class CustomHeaders extends StatelessWidget {
  const CustomHeaders(
      {Key? key,
      required this.controller,
      this.title,
      required this.validator,
      required this.onChange,
      this.keyboardType,
      this.maxLength,
      this.validationMode,
      this.hintText,
      this.leadingIcon,
      this.error,
      this.inputFormates
      })
      : super(key: key);

  final TextEditingController controller;
  final String? Function(String?)? validator;
  final Function(String) onChange;
  final String? title;
  final String? hintText;
  final TextInputType? keyboardType;
  final int? maxLength;
  final AutovalidateMode? validationMode;
  final Icon? leadingIcon;
  final String? error;
  final List<TextInputFormatter>? inputFormates;

  @override
  Widget build(BuildContext context) {
    // var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return TextFormField(
      autovalidateMode: validationMode == null
          ? AutovalidateMode.onUserInteraction
          : validationMode,
      validator: validator,
      inputFormatters: inputFormates!=null? inputFormates: null,
      // style: TextStyle(color: primaryColor),
      style: heading2TextStyle(context, width, color: green),
      controller: controller,
      obscureText: false,
      keyboardType: keyboardType == null ? TextInputType.name : keyboardType,
      maxLines: 1,
      maxLength: maxLength == null ? 15 : maxLength,
      onChanged: onChange,
      decoration: InputDecoration(
        counterText: "",
        isDense: true,
        errorText: (error == null || error == '') ? null : error,
        hintText: '$hintText',
        hintStyle: heading2TextStyle(context, width, color: green),
        prefixIcon: leadingIcon == null
            ? null
            : Padding(
                padding: const EdgeInsets.only(right: 2), child: leadingIcon),
        prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
      ),
    );
  }
}
