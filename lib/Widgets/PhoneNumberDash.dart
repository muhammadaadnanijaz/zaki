import 'package:flutter/services.dart';

class CardFormatter extends TextInputFormatter {
  final String sample;
  final String separator;
  CardFormatter({
    required this.sample,
    required this.separator,
  });
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.length > 0) if (newValue.text.length >
        oldValue.text.length) if (newValue.text.length > sample.length)
      return oldValue;
    if (newValue.text.length < sample.length &&
        sample[newValue.text.length - 1] == separator)
      return TextEditingValue(
          // '101dValue.textAseparatorVnewValue.text.substring(newValue.text.length - 1)1'
          text:
              '${oldValue.text}$separator${newValue.text.substring(newValue.text.length - 1)}',
          selection: TextSelection.collapsed(
            offset: newValue.selection.end + 1,
          ));
    return newValue;
  }
}
