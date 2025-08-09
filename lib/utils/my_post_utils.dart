import 'package:baettori/utils/style.dart';
import 'package:flutter/material.dart';

// 공백 확인
String? checkValue(String? value) {
  if (value!.isEmpty || value.replaceAll(RegExp('\\s'), '') == '') {
    return '';
  }
  return null;
}

// 입력창 스타일
InputDecoration writeInputDecoration(String hintMessage) {
  UnderlineInputBorder borderStyle(Color color) {
    return UnderlineInputBorder(borderSide: BorderSide(color: color));
  }

  return InputDecoration(
      hintText: hintMessage,
      hintStyle: const TextStyle(color: gray),
      enabledBorder: borderStyle(lightGray),
      focusedBorder: borderStyle(mainBlue),
      errorBorder: borderStyle(lightGray),
      focusedErrorBorder: borderStyle(mainBlue),
      errorStyle: const TextStyle(fontSize: 0, color: Colors.black));
}
