import 'package:flutter/services.dart';
import 'package:qrpay/backend/local_storage/local_storage.dart';

class DecimalTextInputFormatter extends TextInputFormatter {
  DecimalTextInputFormatter();

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text == '') {
      return newValue;
    }

    final TextEditingValue newText = newValue.copyWith(
      text: newValue.text.replaceAll(RegExp(r'[^0-9.]'), ''),
    );

    if (newText.text.contains('.') &&
        newText.text.indexOf('.') != newText.text.lastIndexOf('.')) {
      return oldValue;
    }

    if (newText.text.contains('.')) {
      final List<String> parts = newText.text.split('.');
      if (parts.length > 1 &&
          parts[1].length > LocalStorages.getCryptoPrecision()) {
        return oldValue;
      }
    }

    return newText;
  }
}
